class RequestModel {
  final bool? error;
  final List<RequestData>? requests;

  RequestModel({this.error, this.requests});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      error: json['error'],
      requests: json['requests'] != null
          ? (json['requests'] as List)
                .map((i) => RequestData.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'requests': requests?.map((i) => i.toJson()).toList(),
    };
  }
}

class RequestData {
  final int? id;
  final int? patientId;
  final String? specialty;
  final String? status;
  final String? createdAt;
  final int? doctorId; // Nullable as it can be null
  final String? patientName;

  RequestData({
    this.id,
    this.patientId,
    this.specialty,
    this.status,
    this.createdAt,
    this.doctorId,
    this.patientName,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      id: json['id'],
      patientId: json['patient_id'],
      specialty: json['specialty'],
      status: json['status'],
      createdAt: json['created_at'],
      doctorId: json['doctor_id'],
      patientName: json['patient_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'specialty': specialty,
      'status': status,
      'created_at': createdAt,
      'doctor_id': doctorId,
      'patient_name': patientName,
    };
  }
}
