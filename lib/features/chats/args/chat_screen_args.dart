import 'package:chat_app/models/user_model.dart';

class ChatScreenArgs {
  final UserModel peerUserModel;
  final String conversationId;

  ChatScreenArgs({
    required this.peerUserModel,
    required this.conversationId,
  });
}
