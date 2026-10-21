class ChatHelpers {
  static String generateConversationId(String uid1, String uid2) {
    List<String> userIds = [uid1, uid2];
    userIds.sort();
    return userIds.join("_");
  }

  static bool isSelfChat(String uid1, String uid2) => uid1 == uid2;

  static bool isSelfConversation(List<String> participants) =>
      participants.isNotEmpty && participants.toSet().length == 1;
}
