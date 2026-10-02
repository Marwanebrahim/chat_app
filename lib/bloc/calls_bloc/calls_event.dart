import 'package:equatable/equatable.dart';

sealed class CallsEvent extends Equatable {}

class CallsSubscriptionEvent extends CallsEvent {
  @override
  List<Object?> get props => [];
}

class CallsUnsubscribeEvent extends CallsEvent {
  @override
  List<Object?> get props => [];
}
