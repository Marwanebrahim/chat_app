import 'dart:developer';

import 'package:chat_app/core/constants/zego_constants.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:chat_app/services/calls_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCloudService {
  ZegoCloudService._();
  static final ZegoCloudService instance = ZegoCloudService._();

  final _callsService = CallsService.instance;

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

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: ZegoConstants.appID,
      appSign: ZegoConstants.appSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (data) {
        return data.type == ZegoCallInvitationType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
      },
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) {
          if (_currentPeer != null) {
            final duration = _callStartTime == null
                ? null
                : DateTime.now().difference(_callStartTime!).inSeconds;

            _saveRecordSafely(
              currentUserId: userId,
              callId: event.callID,
              status: CallStatus.completed,
              peerId: _currentPeer!.id,
              peerName: _currentPeer!.name,
              isOutgoing: _currentIsOutgoing,
              callType: _currentCallType ?? CallType.voice,
              durationInSeconds: duration,
            );
          }
          _resetCurrentCallTracking();
          defaultAction.call();
        },
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (callId, callee) {
          _callStartTime = DateTime.now();
          _currentPeer = callee;
          _currentIsOutgoing = true;
        },
        onOutgoingCallDeclined: (callId, callee, customData) {
          _saveRecordSafely(
            currentUserId: userId,
            callId: callId,
            status: CallStatus.declined,
            peerId: callee.id,
            peerName: callee.name,
            isOutgoing: true,
            callType: _currentCallType ?? CallType.voice,
          );
          _resetCurrentCallTracking();
        },
        onOutgoingCallRejectedCauseBusy: (callId, callee, customData) {
          _saveRecordSafely(
            currentUserId: userId,
            callId: callId,
            status: CallStatus.busy,
            peerId: callee.id,
            peerName: callee.name,
            isOutgoing: true,
            callType: _currentCallType ?? CallType.voice,
          );
          _resetCurrentCallTracking();
        },
        onOutgoingCallTimeout: (callId, callee, isVideoCall) {
          if (callee.isEmpty) return;
          final callees = callee.first;
          _saveRecordSafely(
            currentUserId: userId,
            callId: callId,
            status: CallStatus.missed,
            peerId: callees.id,
            peerName: callees.name,
            isOutgoing: true,
            callType: isVideoCall ? CallType.video : CallType.voice,
          );
          _resetCurrentCallTracking();
        },
        onIncomingCallReceived:
            (callId, caller, callType, callees, customData) {
              _currentPeer = caller;
              _currentCallType = callType == ZegoCallInvitationType.videoCall
                  ? CallType.video
                  : CallType.voice;
              _currentIsOutgoing = false;
              _callStartTime = DateTime.now();
            },
        onIncomingCallTimeout: (callId, caller) {
          _saveRecordSafely(
            currentUserId: userId,
            callId: callId,
            status: CallStatus.missed,
            peerId: caller.id,
            peerName: caller.name,
            isOutgoing: false,
            callType: _currentCallType ?? CallType.voice,
          );
          _resetCurrentCallTracking();
        },
      ),
    );
  }

  void _saveRecordSafely({
    required String currentUserId,
    required String callId,
    required CallStatus status,
    required String peerId,
    required String peerName,
    required bool isOutgoing,
    required CallType callType,
    int? durationInSeconds,
  }) {
    _callsService
        .saveCallRecord(
          currentUserId: currentUserId,
          record: CallsModel(
            callId: callId,
            callType: callType,
            status: status,
            peerId: peerId,
            peerName: peerName,
            isOutgoing: isOutgoing,
            timestamp: DateTime.now(),
            durationInSeconds: durationInSeconds,
          ),
        )
        .catchError((e) => log(e.toString()));
  }

  void _resetCurrentCallTracking() {
    _callStartTime = null;
    _currentPeer = null;
    _currentCallType = null;
    _currentIsOutgoing = false;
  }

  Future<void> unInit() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  Future<void> startVideoCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(targetUserId, targetUserName)],
        isVideoCall: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startVoiceCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(targetUserId, targetUserName)],
        isVideoCall: false,
      );
    } catch (e) {
      rethrow;
    }
  }
}
