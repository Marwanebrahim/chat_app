import 'package:equatable/equatable.dart';

sealed class ConversationEvent extends Equatable {}

class ConversationsSubscriptionEvent extends ConversationEvent {
  @override
  List<Object?> get props => [];
}

class ConversationsUnsubscribeEvent extends ConversationEvent {
  @override
  List<Object?> get props => [];
}