import 'package:chat_app/bloc/zego_cloud/zego_cloud_state.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:chat_app/services/zego_cloud_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZegoCloudCubit extends Cubit<ZegoCloudState> {
  ZegoCloudCubit() : super(const ZegoCloudState());

  @override
  Future<void> close() async {
    await ZegoCloudService.instance.unInit();
    return super.close();
  }

  Future<void> initCall({
    required String userId,
    required String userName,
  }) async {
    emit(state.copyWith(status: ZegoStatus.initializing));
    try {
      await ZegoCloudService.instance.init(userId: userId, userName: userName);
      if (isClosed) return;

      emit(state.copyWith(status: ZegoStatus.ready));
    } catch (e) {
      if (isClosed) return;

      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> unInitCall() async {
    try {
      await ZegoCloudService.instance.unInit();
      if (isClosed) return;

      emit(const ZegoCloudState());
    } catch (e) {
      if (isClosed) return;
    }
  }

  Future<void> startVideoCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    if (state.status != ZegoStatus.ready) return;
    try {
      emit(
        state.copyWith(status: ZegoStatus.calling, callType: CallType.video),
      );

      await ZegoCloudService.instance.startVideoCall(
        targetUserId: targetUserId,
        targetUserName: targetUserName,
      );
      if (isClosed) return;

      emit(state.copyWith(status: ZegoStatus.ready));
    } catch (e) {
      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> startVoiceCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      if (state.status != ZegoStatus.ready) return;
      emit(
        state.copyWith(status: ZegoStatus.calling, callType: CallType.voice),
      );

      await ZegoCloudService.instance.startVoiceCall(
        targetUserId: targetUserId,
        targetUserName: targetUserName,
      );
      emit(state.copyWith(status: ZegoStatus.ready));
    } catch (e) {
      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
