import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallTile extends StatelessWidget {
  const CallTile({super.key, required this.call});
  final CallsModel call;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;

    final isMissedOrDeclined =
        call.status == CallStatus.missed ||
        call.status == CallStatus.declined ||
        call.status == CallStatus.busy;

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colors.lightPurple,
        child: Text(
          call.peerName.isEmpty ? "?" : call.peerName[0].toUpperCase(),
          style: appTextStyles.displayLarge.copyWith(color: colors.white),
        ),
      ),
      title: Text(
        call.peerName,
        style: appTextStyles.titleLarge.copyWith(
          color: isMissedOrDeclined ? colors.red : colors.text1,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            call.isOutgoing ? Icons.call_made : Icons.call_received,
            size: 14,
            color: isMissedOrDeclined ? colors.red : colors.text2,
          ),
          const SizedBox(width: 4),
          Text(
            _statusLabel(call),
            style: appTextStyles.bodyMedium.copyWith(
              color: isMissedOrDeclined ? colors.red : colors.text2,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            call.callType == CallType.video ? Icons.videocam : Icons.call,
            size: 18,
            color: colors.purple,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat.jm().format(call.timestamp),
            style: appTextStyles.bodySmall.copyWith(color: colors.text3),
          ),
        ],
      ),
    );
  }

  String _statusLabel(CallsModel call) {
    switch (call.status) {
      case CallStatus.missed:
        return call.isOutgoing ? "No answer" : "Missed call";
      case CallStatus.declined:
        return "Declined";
      case CallStatus.busy:
        return "Busy";
      case CallStatus.completed:
        final seconds = call.durationInSeconds ?? 0;
        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;
        return "${minutes}m ${remainingSeconds}s";
    }
  }
}
