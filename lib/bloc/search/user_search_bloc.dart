import 'dart:async';

import 'package:chat_app/bloc/search/user_search_event.dart';
import 'package:chat_app/bloc/search/user_search_state.dart';
import 'package:chat_app/services/user_search_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchBloc extends Bloc<SearchEvent, SearchState> {
  UserSearchBloc() : super(SearchInitialState()) {
    on<SearchQueryChangedEvent>(_onQueryChanged);
  }

  final _searchService = UserSearchService.instance;

  Timer? _debounceTimer;
  Completer<void>? _debounceCompleter;

  Future<void> _onQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    _debounceTimer?.cancel();
    if (_debounceCompleter?.isCompleted == false) {
      _debounceCompleter!.complete();
    }

    if (query.isEmpty || query.length < 3) {
      emit(SearchInitialState());
      return;
    }

    final completer = Completer<void>();
    _debounceCompleter = completer;
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (!completer.isCompleted) completer.complete();
    });

    await completer.future;

    if (_debounceCompleter != completer) return;

    emit(SearchLoadingState());
    try {
      final users = await _searchService.searchUsers(query);
      emit(SearchLoadedState(users: users));
    } catch (e) {
      emit(SearchErrorState(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    if (_debounceCompleter?.isCompleted == false) {
      _debounceCompleter!.complete();
    }
    return super.close();
  }
}
