class MessageModel {
  final int? chatId;
  final int? senderId;
  final String? senderType;
  final int? receiverId;
  final String? receiverType;
  final String? message;
  final String? messageType;
  final String? createdAt;
  final int? id;

  MessageModel({
    this.chatId,
    this.senderId,
    this.senderType,
    this.receiverId,
    this.receiverType,
    this.message,
    this.messageType,
    this.createdAt,
    this.id,
  });

  /// Safely parse a dynamic value to int (handles both int and String).
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chatId: _toInt(json['chat_id']),
      senderId: _toInt(json['sender_id']),
      senderType: json['sender_type']?.toString(),
      receiverId: _toInt(json['receiver_id']),
      receiverType: json['receiver_type']?.toString(),
      message: json['message']?.toString(),
      messageType: json['message_type']?.toString(),
      createdAt: json['created_at']?.toString(),
      id: _toInt(json['message_id'] ?? json['id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_type': senderType,
      'receiver_id': receiverId,
      'receiver_type': receiverType,
      'message': message,
      'message_type': messageType,
      if (createdAt != null) 'created_at': createdAt,
      if (id != null) 'id': id,
    };
  }

  /// Check if this message was sent by the doctor (current user)
  bool get isSentByDoctor => senderType == 'doctor';

  /// Check if this message was sent by the patient
  bool get isSentByPatient => senderType == 'patient';

  @override
  String toString() {
    return 'MessageModel(chatId: $chatId, senderId: $senderId, senderType: $senderType, message: $message)';
  }
}
