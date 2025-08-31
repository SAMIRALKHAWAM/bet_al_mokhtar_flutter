class Login_emp_Model {
  final bool success;
  final String message;
  final int code;
  final EmployeeData data;

  Login_emp_Model({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Login_emp_Model.fromJson(Map<String, dynamic> json) {
    return Login_emp_Model(
      success: json['success'],
      message: json['message'],
      code: json['code'],
      data: EmployeeData.fromJson(json['data']),
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

class EmployeeData {
  final int id;
  final int branchId;
  final String name;
  final String userName;
  final String type;
  final String phone;
  final String address;
  final int age;
  final String skill;
  final String lastJob;
  final String token;
  final String branchName;

  EmployeeData({
    required this.id,
    required this.branchId,
    required this.name,
    required this.userName,
    required this.type,
    required this.phone,
    required this.address,
    required this.age,
    required this.skill,
    required this.lastJob,
    required this.token,
    required this.branchName,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'],
      userName: json['user_name'],
      type: json['type'],
      phone: json['phone'],
      address: json['address'],
      age: json['age'],
      skill: json['skill'],
      lastJob: json['last_job'],
      token: json['token'],
      branchName: json['branch_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'name': name,
      'user_name': userName,
      'type': type,
      'phone': phone,
      'address': address,
      'age': age,
      'skill': skill,
      'last_job': lastJob,
      'token': token,
      'branch_name': branchName,
    };
  }
}
