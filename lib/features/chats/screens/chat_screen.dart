import 'package:chat_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/bloc/chat_bloc/chat_event.dart';
import 'package:chat_app/bloc/chat_bloc/chat_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/features/chats/args/chat_screen_args.dart';
import 'package:chat_app/features/chats/widgets/message_bubble.dart';
import 'package:chat_app/features/chats/widgets/message_input.dart';
import 'package:chat_app/features/profile/widgets/user_avatar_widget.dart';
import 'package:chat_app/models/massege_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.args});
  final ChatScreenArgs args;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final _messageController = TextEditingController();
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final ChatBloc _chatBloc;
  bool _isBlocCaptured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isBlocCaptured) {
      _chatBloc = context.read<ChatBloc>();
      _isBlocCaptured = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _chatBloc.add(AppLifecycleChangedEvent(state == AppLifecycleState.resumed));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chatBloc.add(ChatUnsubscribeEvent());
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(
      SendMessageEvent(
        receiverId: widget.args.peerUserModel.uid,
        massege: text,
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appTextStyles = context.appTextStyles;
    final peer = widget.args.peerUserModel;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            UserAvatarWidget(user: peer, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.args.isSelfChat
                    ? "${peer.username} (You)"
                    : peer.username,
                style: appTextStyles.titleLarge.copyWith(color: colors.text1),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: colors.purple),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam, color: colors.purple),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoadingState) {
                    return Skeletonizer(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          final isMe = index.isEven;
                          return MessageBubble(
                            message: MassegeModel(
                              massegeId: 'skeleton_$index',
                              text: isMe
                                  ? "Loading message here"
                                  : "Loading reply text",
                              senderId: isMe ? _currentUserId : peer.uid,
                              dateTime: DateTime.now(),
                              status: MassegeStatus.sent,
                            ),
                            isMe: isMe,
                          );
                        },
                      ),
                    );
                  }

                  if (state is ChatErrorState) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: appTextStyles.bodyMedium.copyWith(
                          color: colors.text2,
                        ),
                      ),
                    );
                  }

                  final messages = (state as ChatLoadedState).messages;

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "Say hi to ${peer.username} 👋",
                        style: appTextStyles.bodyMedium.copyWith(
                          color: colors.text2,
                        ),
                      ),
                    );
                  }

                  final reversedMessages = messages.reversed.toList();

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: reversedMessages.length,
                    itemBuilder: (context, index) {
                      final message = reversedMessages[index];
                      final isMe = message.senderId == _currentUserId;

                      final isFirstOfDay =
                          index == reversedMessages.length - 1 ||
                          !_isSameDay(
                            reversedMessages[index + 1].dateTime,
                            message.dateTime,
                          );

                      return Column(
                        children: [
                          if (isFirstOfDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                _formatDateHeader(message.dateTime),
                                style: appTextStyles.bodySmall.copyWith(
                                  color: colors.text3,
                                ),
                              ),
                            ),
                          MessageBubble(message: message, isMe: isMe),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            MessageInput(controller: _messageController, onSend: _send),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDateHeader(DateTime dateTime) {
    final now = DateTime.now();
    if (_isSameDay(now, dateTime)) {
      return "Today, ${DateFormat.jm().format(dateTime)}";
    }
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }
}
