class ChatModel {
  final String message, time, date;
  final int profileId;
  final int? id;

  ChatModel(
    this.message,
    this.time,
    this.date,
    this.profileId,
    this.id,
  );

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'time': time,
      'profileId': profileId,
      'date': date,
      'id': id,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        map['time'], map['profileId'], map['message'], map['date'], map['id']);
  }
}
