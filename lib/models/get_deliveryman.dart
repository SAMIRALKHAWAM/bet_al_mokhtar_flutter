class DeliveryManResponse {
  final bool? success;
  final String? message;
  final int? code;
  final List<DeliveryMan> data;

  DeliveryManResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory DeliveryManResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryManResponse(
      success: json['success'],
      message: json['message'],
      code: json['code'],
      data: List<DeliveryMan>.from(
        json['data'].map((x) => DeliveryMan.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class DeliveryMan {
  final int? id;
  final int? branchId;
  final String name;
  final String? userName;
  final String? type;
  final String? phone;
  final String? address;
  final int? age;
  final String? skill;
  final String? lastJob;
  final String? branchName;

  DeliveryMan({
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
    required this.branchName,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      id: json['id'],
      branchId: json['branch_id'],
      name: json['name'] ?? '',
      userName: json['user_name'] ?? '',
      type: json['type'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      age: json['age'] ?? 0,
      skill: json['skill'] ?? '',
      lastJob: json['last_job'] ?? '',
      branchName: json['branch_name'] ?? '',
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
      'branch_name': branchName,
    };
  }
}
