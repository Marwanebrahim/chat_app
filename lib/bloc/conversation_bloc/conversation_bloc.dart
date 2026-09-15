import 'dart:async';

import 'package:chat_app/bloc/conversation_bloc/conversation_event.dart';
import 'package:chat_app/bloc/conversation_bloc/conversation_state.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationLoadingState()) {
    on<ConversationsSubscriptionEvent>(_onSubscribe);
    on<ConversationsUnsubscribeEvent>(_onUnsubscribe);
  }

  final _chatService = ChatService.instance;
  StreamSubscription<List<ConversationModel>>? _subscription;

  Completer<void>? completer;
  Future<void> _onSubscribe(
    ConversationsSubscriptionEvent event,
    Emitter<ConversationState> emit,
  ) async {
     completer = Completer<void>();
    _subscription = _chatService.getConversationsStream().listen(
      (conversations) {
        emit(ConversationSubscriptionState(conversations: conversations));
      },
      onError: (e) {
        emit(ConversationErrorState(errorMessage: e.toString()));
      },
    );

    await completer?.future;
  }

  void _onUnsubscribe(
    ConversationsUnsubscribeEvent event,
    Emitter<ConversationState> emit,
  ) {
    _subscription?.cancel();
    completer?.complete();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    completer?.complete();
    return super.close();
  }
}
