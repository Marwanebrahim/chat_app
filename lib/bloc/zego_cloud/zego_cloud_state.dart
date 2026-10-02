import 'package:chat_app/models/calls_model.dart';
import 'package:equatable/equatable.dart';

enum ZegoStatus { idle, initializing, ready, calling, reconnecting, error }

class ZegoCloudState extends Equatable {
  final ZegoStatus status;
  final String? errorMessage;
  final CallType? callType;

  const ZegoCloudState({
    this.callType = CallType.voice,
    this.status = ZegoStatus.idle,
    this.errorMessage,
  });

  ZegoCloudState copyWith({
    ZegoStatus? status,
    String? errorMessage,
    CallType? callType,
  }) {
    return ZegoCloudState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      callType: callType ?? this.callType,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
