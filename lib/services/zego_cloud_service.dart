import 'dart:developer';

import 'package:chat_app/core/constants/zego_constants.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/calls_service.dart';
import 'package:chat_app/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ZegoCloudService {
  ZegoCloudService._();
  static final ZegoCloudService instance = ZegoCloudService._();

  final _callsService = CallsService.instance;

  String? _currentUserId;
  String? _currentUserName;
  String? _currentCallId;
  DateTime? _callStartTime;
  ZegoCallUser? _currentPeer;
  CallType? _currentCallType;
  bool _currentIsOutgoing = false;

  Future<void> init({required String userId, required String userName}) async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getToken();

    final overlayGranted = await Permission.systemAlertWindow.isGranted;
    if (!overlayGranted) {
      await Permission.systemAlertWindow.request();
    }

    _currentUserId = userId;
    _currentUserName = userName;
    await ZIMKit().connectUser(id: userId, name: userName);
    ZIMKit().getOnMessageReceivedNotifier().removeListener(_onMessageArrived);
    ZIMKit().getOnMessageReceivedNotifier().addListener(_onMessageArrived);

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoConstants.appID,
      appSign: ZegoConstants.appSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          callChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "chat_app_call_channel",
            channelName: "Call Invitation",
          ),
          missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "chat_app_missed_call",
            channelName: "Missed Call",
          ),
          messageChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "chat_app_message_channel",
            channelName: "Chat Messages",
          ),
        ),
      ),
      requireConfig: (data) {
        return data.type == ZegoCallInvitationType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
      },
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) {
          if (_currentIsOutgoing && _currentPeer != null) {
            final duration = _callStartTime == null
                ? null
                : DateTime.now().difference(_callStartTime!).inSeconds;
            _recordOutgoingCall(
              CallStatus.completed,
              durationInSeconds: duration,
            );
          } else {
            _resetCurrentCallTracking();
          }
          defaultAction.call();
        },
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (callId, callee) {
          _callStartTime = DateTime.now();
        },
        onOutgoingCallCancelButtonPressed: () {
          _recordOutgoingCall(CallStatus.cancelled);
        },
        onOutgoingCallDeclined: (callId, callee, customData) {
          _recordOutgoingCall(CallStatus.declined);
        },
        onOutgoingCallRejectedCauseBusy: (callId, callee, customData) {
          _recordOutgoingCall(CallStatus.busy);
        },
        onOutgoingCallTimeout: (callId, callees, isVideoCall) {
          _recordOutgoingCall(CallStatus.missed);
        },
      ),
    );
  }

  void _recordOutgoingCall(CallStatus status, {int? durationInSeconds}) {
    final callerId = _currentUserId;
    final callerName = _currentUserName;
    final callId = _currentCallId;
    final peer = _currentPeer;

    log('ZEGO outgoing call -> $status, callId: $callId');

    if (callerId == null ||
        callerName == null ||
        callId == null ||
        peer == null) {
      _resetCurrentCallTracking();
      return;
    }

    final callType = _currentCallType ?? CallType.voice;
    final now = DateTime.now();

    _callsService
        .saveCallRecordForBoth(
          callerId: callerId,
          calleeId: peer.id,
          callerRecord: CallsModel(
            callId: callId,
            callType: callType,
            status: status,
            peerId: peer.id,
            peerName: peer.name,
            isOutgoing: true,
            timestamp: now,
            durationInSeconds: durationInSeconds,
          ),
          calleeRecord: CallsModel(
            callId: callId,
            callType: callType,
            status: _statusForCallee(status),
            peerId: callerId,
            peerName: callerName,
            isOutgoing: false,
            timestamp: now,
            durationInSeconds: durationInSeconds,
          ),
        )
        .catchError((e) => log(e.toString()));

    _resetCurrentCallTracking();
  }

  CallStatus _statusForCallee(CallStatus callerStatus) {
    switch (callerStatus) {
      case CallStatus.completed:
        return CallStatus.completed;
      case CallStatus.declined:
        return CallStatus.declined;
      case CallStatus.missed:
      case CallStatus.busy:
      case CallStatus.cancelled:
        return CallStatus.missed;
    }
  }

  Future<void> sendMessagePush({
    required String receiverId,
    required String text,
  }) async {
    await ZIMKit().sendTextMessage(receiverId, ZIMConversationType.peer, text);
  }

  Future<void> _onMessageArrived() async {
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return;
    }

    final received = ZIMKit().getOnMessageReceivedNotifier().value;
    if (received == null) return;

    for (final kitMessage in received.receiveMessages) {
      final zimMessage = kitMessage.zim;
      if (zimMessage is! ZIMTextMessage) continue;
      if (zimMessage.senderUserID == _currentUserId) continue;

      var title = 'New message';
      try {
        final sender = await AuthService.instance.getUserById(
          zimMessage.senderUserID,
        );
        title = sender.username;
      } catch (_) {}

      await LocalNotificationService.instance.show(
        title: title,
        body: zimMessage.message,
      );
    }
  }

  void _resetCurrentCallTracking() {
    _currentCallId = null;
    _callStartTime = null;
    _currentPeer = null;
    _currentCallType = null;
    _currentIsOutgoing = false;
  }

  Future<void> unInit() async {
    ZIMKit().getOnMessageReceivedNotifier().removeListener(_onMessageArrived);
    _currentUserId = null;
    _currentUserName = null;
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    await ZIMKit().disconnectUser();
  }

  Future<void> startVideoCall({
    required String targetUserId,
    required String targetUserName,
  }) => _startCall(
    targetUserId: targetUserId,
    targetUserName: targetUserName,
    isVideoCall: true,
  );

  Future<void> startVoiceCall({
    required String targetUserId,
    required String targetUserName,
  }) => _startCall(
    targetUserId: targetUserId,
    targetUserName: targetUserName,
    isVideoCall: false,
  );

  Future<void> _startCall({
    required String targetUserId,
    required String targetUserName,
    required bool isVideoCall,
  }) async {
    final callId =
        'call_${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}';
    _currentCallId = callId;
    _currentPeer = ZegoCallUser(targetUserId, targetUserName);
    _currentCallType = isVideoCall ? CallType.video : CallType.voice;
    _currentIsOutgoing = true;

    try {
      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(targetUserId, targetUserName)],
        isVideoCall: isVideoCall,
        callID: callId,
        resourceID: "chat_app_call",
      );
    } catch (e) {
      _resetCurrentCallTracking();
      rethrow;
    }
  }
}
