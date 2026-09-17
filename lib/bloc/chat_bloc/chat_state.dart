import 'package:chat_app/models/massege_model.dart';
import 'package:equatable/equatable.dart';

sealed class ChatState extends Equatable {}

class ChatLoadingState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoadedState extends ChatState {
  final List<MassegeModel> messages;

  ChatLoadedState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatErrorState extends ChatState {
  final String errorMessage;

  ChatErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
