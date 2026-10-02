enum CallType { video, voice }
enum CallStatus { completed, missed, declined, busy }

class CallsModel {
  final String callId;
  final CallType callType;
  final CallStatus status;
  final String peerId;
  final String peerName;
  final bool isOutgoing;
  final DateTime timestamp;
  final int? durationInSeconds;

  CallsModel({
    required this.callId,
    required this.callType,
    required this.status,
    required this.peerId,
    required this.peerName,
    required this.isOutgoing,
    required this.timestamp,
    this.durationInSeconds,
  });

  factory CallsModel.fromJson(Map<String, dynamic> json) {
    return CallsModel(
      callId: json['callId'],
      callType: json['callType'] == 'video' ? CallType.video : CallType.voice,
      status: CallStatus.values.byName(json['status']),
      peerId: json['peerId'],
      peerName: json['peerName'],
      isOutgoing: json['isOutgoing'],
      timestamp: DateTime.parse(json['timestamp']),
      durationInSeconds: json['durationInSeconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callType': callType == CallType.video ? 'video' : 'voice',
      'status': status.name,
      'peerId': peerId,
      'peerName': peerName,
      'isOutgoing': isOutgoing,
      'timestamp': timestamp.toIso8601String(),
      'durationInSeconds': durationInSeconds,
    };
  }
}