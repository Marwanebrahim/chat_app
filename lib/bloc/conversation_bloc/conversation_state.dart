import 'package:chat_app/models/conversation_model.dart';
import 'package:equatable/equatable.dart';

sealed class ConversationState extends Equatable {}

class ConversationLoadingState extends ConversationState {
  @override
  List<Object?> get props => [];
}

class ConversationSubscriptionState extends ConversationState {
  final List<ConversationModel> conversations;
  ConversationSubscriptionState({required this.conversations});
  @override
  List<Object?> get props => [conversations];
}

class ConversationErrorState extends ConversationState {
  final String errorMessage;
  ConversationErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
