import 'package:chat_app/bloc/calls_bloc/calls_bloc.dart';
import 'package:chat_app/bloc/calls_bloc/calls_event.dart';
import 'package:chat_app/bloc/calls_bloc/calls_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/features/calls/widgets/call_tile.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:chat_app/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is CallsLoadingState) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => CallTile(
                call: CallsModel(
                  callId: 'skeleton_$index',
                  callType: CallType.voice,
                  status: CallStatus.completed,
                  peerId: '',
                  peerName: 'Loading Name',
                  isOutgoing: true,
                  timestamp: DateTime.now(),
                  durationInSeconds: 60,
                ),
              ),
            ),
          );
        }

        if (state is CallsErrorState) {
          return RetryWidget(
            message: state.errorMessage,
            onRetry: () =>
                context.read<CallsBloc>().add(CallsSubscriptionEvent()),
          );
        }

        final calls = (state as CallsLoadedState).calls;

        if (calls.isEmpty) {
          return Center(
            child: Text(
              "No calls yet",
              style: appTextStyles.bodyMedium.copyWith(color: colors.text2),
            ),
          );
        }

        return ListView.builder(
          itemCount: calls.length,
          itemBuilder: (context, index) =>
              CallTile(key: ValueKey(calls[index].callId), call: calls[index]),
        );
      },
    );
  }
}
