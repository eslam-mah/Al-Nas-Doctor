class UserModel {
  final bool? success;
  final String? token;
  final UserData? userData;

  UserModel({this.success, this.token, this.userData});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json['success'],
      token: json['token'],
      // Maps from the 'doctor' key in your JSON
      userData: json['doctor'] != null
          ? UserData.fromJson(json['doctor'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'token': token, 'doctor': userData?.toJson()};
  }
}

class UserData {
  final int? id;
  final String? fullName;
  final String? username;
  final String? specialty;

  UserData({this.id, this.fullName, this.username, this.specialty});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      specialty: json['specialty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'specialty': specialty,
    };
  }
}
