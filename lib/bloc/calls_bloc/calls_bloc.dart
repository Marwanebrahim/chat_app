import 'dart:async';

import 'package:chat_app/bloc/calls_bloc/calls_event.dart';
import 'package:chat_app/bloc/calls_bloc/calls_state.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:chat_app/services/calls_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallsBloc extends Bloc<CallsEvent, CallsState> {
  CallsBloc() : super(CallsLoadingState()) {
    on<CallsSubscriptionEvent>(_onSubscribe);
    on<CallsUnsubscribeEvent>(_onUnsubscribe);
  }

  final _callsService = CallsService.instance;
  StreamSubscription<List<CallsModel>>? _subscription;
  Completer<void>? completer;

  Future<void> _onSubscribe(
    CallsSubscriptionEvent event,
    Emitter<CallsState> emit,
  ) async {
    completer = Completer<void>();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    _subscription = _callsService
        .getCallsStream(currentUserId)
        .listen(
          (calls) {
            emit(CallsLoadedState(calls: calls));
          },
          onError: (e) {
            emit(CallsErrorState(errorMessage: e.toString()));
          },
        );

    await completer?.future;
  }

  void _onUnsubscribe(CallsUnsubscribeEvent event, Emitter<CallsState> emit) {
    _subscription?.cancel();
    if (completer?.isCompleted == false) {
      completer!.complete();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    if (completer?.isCompleted == false) {
      completer!.complete();
    }
    return super.close();
  }
}
