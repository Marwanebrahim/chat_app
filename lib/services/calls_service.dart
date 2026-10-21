import 'package:chat_app/core/constants/firebase_constants.dart';
import 'package:chat_app/models/calls_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallsService {
  CallsService._();
  static final CallsService instance = CallsService._();

  final _firestore = FirebaseFirestore.instance;

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

  Future<void> saveCallRecordForBoth({
    required String callerId,
    required String calleeId,
    required CallsModel callerRecord,
    required CallsModel calleeRecord,
  }) async {
    try {
      final batch = _firestore.batch();
      final users = _firestore.collection(FirebaseConstants.usersCollection);

      batch.set(
        users.doc(callerId).collection('calls').doc(callerRecord.callId),
        callerRecord.toJson(),
      );
      batch.set(
        users.doc(calleeId).collection('calls').doc(calleeRecord.callId),
        calleeRecord.toJson(),
      );
      await batch.commit();
    } on FirebaseException {
      throw "Something went wrong while saving the call record";
    }
  }
}
