import 'package:firebase_database/firebase_database.dart';

enum MassegeStatus { pending, sent, delivered, seen, failed }

class MassegeModel {
  final String massegeId;
  final String text;
  final String senderId;
  final DateTime dateTime;
  final MassegeStatus status;
  MassegeModel({
    required this.massegeId,
    required this.text,
    required this.senderId,
    required this.dateTime,
    required this.status,
  });

  factory MassegeModel.fromJson(Map<String, dynamic> json) {
    return MassegeModel(
      massegeId: json['massegeId'],
      text: json['text'],
      senderId: json['senderId'],
      dateTime: DateTime.parse(json['dateTime']),
      status: MassegeStatus.values[json['status']],
    );
  }
  factory MassegeModel.fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return MassegeModel(
      massegeId: snapshot.key!,
      text: data['text'],
      senderId: data['senderId'],
      dateTime: DateTime.parse(data['dateTime']),
      status: MassegeStatus.values[data['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'massegeId': massegeId,
      'text': text,
      'senderId': senderId,
      'dateTime': dateTime.toIso8601String(),
      'status': status.index,
    };
  }

  MassegeModel copyWith({
    String? massegeId,
    String? text,
    String? senderId,
    DateTime? dateTime,
    MassegeStatus? status,
  }) {
    return MassegeModel(
      massegeId: massegeId ?? this.massegeId,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}
