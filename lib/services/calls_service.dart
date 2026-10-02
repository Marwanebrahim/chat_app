import 'package:chat_app/core/constants/firebase_constants.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallsService {
  CallsService._();
  static final CallsService instance = CallsService._();

  final _firestore = FirebaseFirestore.instance;

  Future<void> saveCallRecord({
    required String currentUserId,
    required CallsModel record,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(currentUserId)
          .collection('calls')
          .doc(record.callId)
          .set(record.toJson());
    } on FirebaseException {
      throw "Something went wrong while saving the call record";
    }
  }

  Stream<List<CallsModel>> getCallsStream(String currentUserId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(currentUserId)
        .collection('calls')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((d) => CallsModel.fromJson(d.data())).toList(),
        );
  }
}