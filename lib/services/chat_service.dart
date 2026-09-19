import 'package:chat_app/core/constants/firebase_constants.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/massege_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService {
  ChatService._();
  static final ChatService instance = ChatService._();

  final _database = FirebaseDatabase.instance;
  final _firestore = FirebaseFirestore.instance;

  Stream<List<MassegeModel>> getMessagesStream(String conversationId) {
    return _database
        .ref('chats/$conversationId/messages')
        .orderByChild('dateTime')
        .onValue
        .map(
          (event) => List<MassegeModel>.from(
            event.snapshot.children.map((e) => MassegeModel.fromSnapshot(e)),
          ),
        );
  }

  Stream<List<ConversationModel>> getConversationsStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .collection(FirebaseConstants.conversationsCollection)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (event) => List<ConversationModel>.from(
            event.docs.map((e) => ConversationModel.fromJson(e.data())),
          ),
        );
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required MassegeModel massege,
  }) async {
    try {
      DatabaseReference newMessageRef = _database.ref(
        'chats/$conversationId/messages/${massege.massegeId}',
      );
      final messageToSend = massege.copyWith(status: MassegeStatus.sent);

      await newMessageRef.set(messageToSend.toJson());
      final batch = _firestore.batch();
      final isSelfChat = senderId == receiverId;
      final senderDoc = _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(senderId)
          .collection(FirebaseConstants.conversationsCollection)
          .doc(conversationId);

      batch.set(senderDoc, {
        'id': conversationId,
        'participants': [senderId, receiverId],
        'lastMessage': messageToSend.text,
        'lastMessageTime': messageToSend.dateTime.toIso8601String(),
        'unReadCount': 0,
      }, SetOptions(merge: true));

      if (!isSelfChat) {
        final receiverDoc = _firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(receiverId)
            .collection(FirebaseConstants.conversationsCollection)
            .doc(conversationId);

        batch.set(receiverDoc, {
          'id': conversationId,
          'participants': [senderId, receiverId],
          'lastMessage': messageToSend.text,
          'lastMessageTime': messageToSend.dateTime.toIso8601String(),
          'unReadCount': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' || e.code == 'network-request-failed') {
        throw "No internet connection. Please check your network and try again";
      }
      if (e.code == 'permission-denied') {
        throw "You don't have permission to send this message";
      }
      throw "Something went wrong while sending your message";
    } catch (e) {
      throw "Something went wrong while sending your message";
    }
  }

  Future<void> markMessagesAsSeen({
    required String conversationId,
    required String currentUserId,
    required List<MassegeModel> unSeenMasseges,
  }) async {
    try {
      if (unSeenMasseges.isEmpty) return;
      final ref = _database.ref('chats/$conversationId/messages');
      final Map<String, dynamic> massegeMap = {};
      for (var massege in unSeenMasseges) {
        massegeMap["${massege.massegeId}/status"] = MassegeStatus.seen.index;
      }
      await ref.update(massegeMap);
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUserId)
          .collection(FirebaseConstants.conversationsCollection)
          .doc(conversationId)
          .update({'unReadCount': 0});
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' || e.code == 'network-request-failed') {
        throw "No internet connection. Please check your network and try again";
      }
      if (e.code == 'permission-denied') {
        throw "Something went wrong while updating message status";
      }
      throw "Something went wrong while updating message status";
    } catch (e) {
      throw "Something went wrong while updating message status";
    }
  }

  String getMassegeId(String conversationId) {
    final newMessageRef = _database
        .ref('chats/$conversationId/messages')
        .push();
    return newMessageRef.key!;
  }
}
