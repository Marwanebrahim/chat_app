import 'package:chat_app/models/user_model.dart';

class ChatScreenArgs {
  final UserModel peerUserModel;
  final String conversationId;
  final bool isSelfChat;
  ChatScreenArgs({
    required this.peerUserModel,
    required this.conversationId,
    required this.isSelfChat,
  });
}
