import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {}

class GetSubscriptionEvent extends ChatEvent {
  final String conversationId;
  GetSubscriptionEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class SendMessageEvent extends ChatEvent {
  final String receiverId;
  final String massege;
  SendMessageEvent({required this.receiverId, required this.massege});
  @override
  List<Object?> get props => [receiverId, massege];
}

class ChatUnsubscribeEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class SeenMassegesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}
