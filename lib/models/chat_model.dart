class ChatModel {
  final String message, time, date;
  final int profileId;
  final int? id;

  ChatModel(
    {this.id,
    required this.message,
    required this.time,
    required this.date,
    required this.profileId,}
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
        message: map['message'],
        time: map['time'],
        profileId: map['profileId'],
        date: map['date'],
        id: map['id']);
  }
}
