class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? id;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.id,
  });

  /// Create a copy with modified fields
  ChatMessage copyWith({
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? id,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      id: id ?? this.id,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'id': id,
    };
  }

  /// Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      id: json['id'],
    );
  }
}
