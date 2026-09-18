import 'package:chat_app/bloc/conversation_bloc/conversation_bloc.dart';
import 'package:chat_app/bloc/conversation_bloc/conversation_event.dart';
import 'package:chat_app/bloc/conversation_bloc/conversation_state.dart';
import 'package:chat_app/features/chats/widgets/conversation_tile.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (previous, current) =>
          current is ConversationErrorState ||
          current is ConversationLoadingState ||
          current is ConversationSubscriptionState,
      builder: (context, state) {
        if (state is ConversationLoadingState) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  ConversationTile(conversation: ConversationModel.empty()),
            ),
          );
        }
        if (state is ConversationErrorState) {
          return RetryWidget(
            message: state.errorMessage,
            onRetry: () => context.read<ConversationBloc>().add(
              ConversationsSubscriptionEvent(),
            ),
          );
        }
        if (state is ConversationSubscriptionState) {
          return ListView.builder(
            itemCount: state.conversations.length,
            itemBuilder: (context, index) =>
                ConversationTile(conversation: state.conversations[index]),
          );
        }
        return Container();
      },
    );
  }
}
