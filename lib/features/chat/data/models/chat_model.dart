class ChatModel {
  final List<ChatData>? chats;

  ChatModel({this.chats});

  factory ChatModel.fromJson(List<dynamic> json) {
    return ChatModel(chats: json.map((i) => ChatData.fromJson(i)).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return chats?.map((i) => i.toJson()).toList() ?? [];
  }
}

class ChatData {
  final int? id;
  final int? doctorId;
  final int? patientId;
  final String? createdAt;
  final int? appointmentId;
  final String? status;
  final String? closedAt;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? patientName;
  final String? doctorName;

  ChatData({
    this.id,
    this.doctorId,
    this.patientId,
    this.createdAt,
    this.appointmentId,
    this.status,
    this.closedAt,
    this.lastMessage,
    this.lastMessageTime,
    this.patientName,
    this.doctorName,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      createdAt: json['created_at'],
      appointmentId: json['appointment_id'],
      status: json['status'],
      closedAt: json['closed_at'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      patientName: json['patient_name'],
      doctorName: json['doctor_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'created_at': createdAt,
      'appointment_id': appointmentId,
      'status': status,
      'closed_at': closedAt,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'patient_name': patientName,
      'doctor_name': doctorName,
    };
  }
}
