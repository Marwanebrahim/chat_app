import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/models/massege_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isMe});
  final MassegeModel message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    final isFailed = message.status == MassegeStatus.failed;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: isFailed
            ? () => context.read<ChatBloc>().add(
                RetryMessageEvent(message.massegeId),
              )
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: isMe && !isFailed ? colors.primaryGradient : null,
            color: isFailed
                ? colors.red.withValues(alpha: 0.15)
                : (isMe ? null : colors.white),
            border: isFailed ? Border.all(color: colors.red) : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 2),
              bottomRight: Radius.circular(isMe ? 2 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: appTextStyles.bodyMedium.copyWith(
                  color: isFailed
                      ? colors.red
                      : (isMe ? colors.white : colors.text1),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFailed) ...[
                    Icon(Icons.error_outline, size: 14, color: colors.red),
                    const SizedBox(width: 4),
                    Text(
                      "Tap to retry",
                      style: appTextStyles.bodySmall.copyWith(
                        color: colors.red,
                      ),
                    ),
                  ] else ...[
                    Text(
                      DateFormat.jm().format(message.dateTime),
                      style: appTextStyles.bodySmall.copyWith(
                        color: isMe
                            ? colors.white.withValues(alpha: 0.8)
                            : colors.text3,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.status == MassegeStatus.seen
                            ? Icons.done_all
                            : Icons.done,
                        size: 14,
                        color: colors.white.withValues(alpha: 0.8),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
