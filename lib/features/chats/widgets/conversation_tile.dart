import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/chats/args/chat_screen_args.dart';
import 'package:chat_app/features/profile/widgets/user_avatar_widget.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationTile extends StatefulWidget {
  const ConversationTile({super.key, required this.conversation});
  final ConversationModel conversation;

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  late final Future<UserModel> _peerFuture;

  @override
  void initState() {
    super.initState();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final peerUid = widget.conversation.participants.firstWhere(
      (uid) => uid != currentUserId,
      orElse: () => '',
    );
    _peerFuture = peerUid.isEmpty
        ? Future.value(UserModel.empty())
        : AuthService.instance.getUserById(peerUid);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final isToday =
        now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) return DateFormat.jm().format(dateTime);

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        yesterday.year == dateTime.year &&
        yesterday.month == dateTime.month &&
        yesterday.day == dateTime.day;

    if (isYesterday) return "Yesterday";

    return DateFormat.E().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    final hasUnRead = widget.conversation.unReadCount > 0;
    return FutureBuilder<UserModel>(
      future: _peerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: colors.dividerColor.withValues(alpha: 0.5),
            ),
            title: Container(
              height: 12,
              width: 100,
              color: colors.dividerColor.withValues(alpha: 0.5),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: colors.dividerColor.withValues(alpha: 0.5),
              child: Icon(Icons.person_off, color: colors.text2),
            ),
            title: Text(
              "Unknown user",
              style: appTextStyles.bodyLarge.copyWith(color: colors.text1),
            ),
            subtitle: Text(
              widget.conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextStyles.bodyMedium.copyWith(color: colors.text2),
            ),
          );
        }

        final peer = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: hasUnRead ? colors.white : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: UserAvatarWidget(user: peer),
            title: Text(
              peer.username,
              style: appTextStyles.titleLarge.copyWith(color: colors.text1),
            ),
            subtitle: Text(
              widget.conversation.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextStyles.bodyMedium,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(widget.conversation.lastMessageTime),
                  style: appTextStyles.bodySmall.copyWith(color: colors.text3),
                ),
                const SizedBox(height: 6),
                if (widget.conversation.unReadCount > 0)
                  Badge.count(
                    count: widget.conversation.unReadCount,
                    smallSize: 10,
                    backgroundColor: colors.purple,
                    textColor: colors.white,
                    padding: const EdgeInsets.all(4),
                  ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.chat,
                arguments: ChatScreenArgs(
                  peerUserModel: peer,
                  conversationModel: widget.conversation,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
