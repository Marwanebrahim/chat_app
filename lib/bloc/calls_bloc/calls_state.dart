import 'package:chat_app/models/calls_model.dart';
import 'package:equatable/equatable.dart';

sealed class CallsState extends Equatable {}

class CallsLoadingState extends CallsState {
  @override
  List<Object?> get props => [];
}

class CallsLoadedState extends CallsState {
  final List<CallsModel> calls;
  CallsLoadedState({required this.calls});
  @override
  List<Object?> get props => [calls];
}

class CallsErrorState extends CallsState {
  final String errorMessage;
  CallsErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
