class ChatHelpers {
    static String generateConversationId(String uid1, String uid2){
      List<String> userIds = [uid1,uid2];
      userIds.sort();
      return userIds.join("_");
    } 
}