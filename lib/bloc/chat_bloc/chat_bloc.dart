import 'dart:async';
import 'dart:developer';

import 'package:chat_app/bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/models/massege_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoadingState()) {
    on<GetSubscriptionEvent>(_subscribeEvent);
    on<SendMessageEvent>(_sendMessageEvent);
    on<ChatUnsubscribeEvent>(_unsubscribeEvent);
    on<SeenMassegesEvent>(_seenMassegesEvent);
  }

  final _chatService = ChatService.instance;

  StreamSubscription<List<MassegeModel>>? _subscription;
  Completer<void>? completer;

  String? _conversationId;
  List<MassegeModel> _lastConfirmedMessages = [];
  final List<MassegeModel> _pendingMessages = [];

  Future<void> _subscribeEvent(
    GetSubscriptionEvent event,
    Emitter<ChatState> emit,
  ) async {
    _conversationId = event.conversationId;
    completer = Completer<void>();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _subscription = _chatService
        .getMessagesStream(event.conversationId)
        .listen(
          (confirmedMessages) {
            _lastConfirmedMessages = confirmedMessages;
            _emitMergedMessages(emit, confirmedMessages);
            final unSeenMessages = confirmedMessages
                .where(
                  (m) =>
                      m.senderId != currentUserId &&
                      m.status != MassegeStatus.seen,
                )
                .toList();
            if (unSeenMessages.isNotEmpty) {
              _chatService
                  .markMessagesAsSeen(
                    conversationId: event.conversationId,
                    currentUserId: currentUserId,
                    unSeenMasseges: unSeenMessages,
                  )
                  .catchError((e) {
                    log(e.toString());
                  });
            }
          },
          onError: (e) {
            emit(ChatErrorState(errorMessage: e.toString()));
          },
        );

    await completer?.future;
  }

  Future<void> _sendMessageEvent(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final conversationId = _conversationId;
    if (conversationId == null) return;

    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final messageId = _chatService.getMassegeId(conversationId);

    final pendingMessage = MassegeModel(
      massegeId: messageId,
      text: event.massege,
      senderId: senderId,
      dateTime: DateTime.now(),
      status: MassegeStatus.pending,
    );

    _pendingMessages.add(pendingMessage);
    _emitMergedMessages(emit, _lastConfirmedMessages);

    try {
      await _chatService.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        receiverId: event.receiverId,
        massege: pendingMessage,
      );
    } catch (e) {
      _pendingMessages.remove(pendingMessage);
      _pendingMessages.add(
        pendingMessage.copyWith(status: MassegeStatus.failed),
      );
      _emitMergedMessages(emit, _lastConfirmedMessages);
    }
  }

  void _unsubscribeEvent(ChatUnsubscribeEvent event, Emitter<ChatState> emit) {
    _subscription?.cancel();
    completer?.complete();
  }

  void _seenMassegesEvent(SeenMassegesEvent event, Emitter<ChatState> emit) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final conversationId = _conversationId;
    if (conversationId == null) return;

    final unSeenMessages = _lastConfirmedMessages
        .where(
          (m) => m.senderId != currentUserId && m.status != MassegeStatus.seen,
        )
        .toList();

    if (unSeenMessages.isEmpty) return;

    _chatService
        .markMessagesAsSeen(
          conversationId: conversationId,
          currentUserId: currentUserId,
          unSeenMasseges: unSeenMessages,
        )
        .catchError((e) {
          log(e.toString());
        });
  }

  void _emitMergedMessages(
    Emitter<ChatState> emit,
    List<MassegeModel> confirmedMessages,
  ) {
    _pendingMessages.removeWhere(
      (pending) => confirmedMessages.any(
        (confirmed) => confirmed.massegeId == pending.massegeId,
      ),
    );

    final merged = List<MassegeModel>.from(confirmedMessages)
      ..addAll(_pendingMessages);
    merged.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    emit(ChatLoadedState(messages: merged));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    completer?.complete();
    return super.close();
  }
}
