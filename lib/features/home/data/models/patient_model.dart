class PatientModel {
  final List<PatientData>? data;
  final Pagination? pagination;

  PatientModel({this.data, this.pagination});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => PatientData.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((i) => i.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class PatientData {
  final int? id;
  final String? fullName;
  final String? phone;
  final String? mrn;
  final String? username;
  final String? specialty;
  final String? createdAt;

  PatientData({
    this.id,
    this.fullName,
    this.phone,
    this.mrn,
    this.username,
    this.specialty,
    this.createdAt,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      mrn: json['mrn'],
      username: json['username'],
      specialty: json['specialty'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'mrn': mrn,
      'username': username,
      'specialty': specialty,
      'created_at': createdAt,
    };
  }
}

class Pagination {
  final int? page;
  final int? limit;
  final int? total;
  final int? pages;

  Pagination({this.page, this.limit, this.total, this.pages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'total': total, 'pages': pages};
  }
}
