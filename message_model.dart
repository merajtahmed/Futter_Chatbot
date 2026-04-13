class MessageModel {
  final String role; // 'user' or 'bot'
  final String text;
  final DateTime time;

  MessageModel({
    required this.role,
    required this.text,
    required this.time,
  });

  bool get isUser => role == 'user';
}