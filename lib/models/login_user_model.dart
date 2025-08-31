class LoginResponse {
  final bool success;
  final String message;
  final int code;
  final UserData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      code: json['code'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String userName;
  final String createdAt;
  final String updatedAt;
  final String token;

  UserData({
    required this.id,
    required this.userName,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      userName: json['user_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }
}
