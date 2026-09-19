import 'package:chat_app/bloc/conversation_bloc/conversation_bloc.dart';
import 'package:chat_app/bloc/conversation_bloc/conversation_event.dart';
import 'package:chat_app/bloc/conversation_bloc/conversation_state.dart';
import 'package:chat_app/core/extensions/app_extensions.dart';
import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/features/chats/widgets/conversation_tile.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/widgets/custom_button_widget.dart';
import 'package:chat_app/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              itemCount: 5,
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
          if (state.conversations.isEmpty) {
            return _buildEmpty(context);
          }
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

  Widget _buildEmpty(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(radius: 50, child: Icon(Icons.message, size: 40)),
        const SizedBox(height: 20),
        Text("No conversations yet", style: context.appTextStyles.titleLarge),
        Text(
          "Start a conversation with someone",
          style: context.appTextStyles.bodyMedium,
        ),
        const SizedBox(height: 10),
        CustomButtonWidget(
          height: 56.h,
          width: 250.w,
          borderRadius: 12,
          gradient: context.appColors.primaryGradient,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.search);
          },
          child: Center(
            child: Text(
              "Start a conversation",
              style: context.appTextStyles.labelMedium.copyWith(
                color: context.appColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
