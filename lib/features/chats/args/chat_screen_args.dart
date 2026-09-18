import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/user_model.dart';

class ChatScreenArgs {
  final UserModel peerUserModel;
  final ConversationModel conversationModel;

  ChatScreenArgs({
    required this.peerUserModel,
    required this.conversationModel,
  });
}
