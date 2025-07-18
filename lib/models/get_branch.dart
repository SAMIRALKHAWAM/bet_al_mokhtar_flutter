/// موديل لتمثيل فرع واحد
class BranchModel {
  final int id;
  final String name;
  final String location;

  BranchModel({
    required this.id,
    required this.name,
    required this.location,
  });

  /// تحويل من JSON إلى BranchModel
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  /// تحويل من BranchModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}

/// موديل لتمثيل استجابة API التي تحتوي على قائمة الفروع
class BranchesResponse {
  final bool success;
  final String message;
  final int code;
  final List<BranchModel> data;

  BranchesResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  /// تحويل من JSON إلى BranchesResponse
  factory BranchesResponse.fromJson(Map<String, dynamic> json) {
    return BranchesResponse(
      success: json['success'],
      message: json['message'],
      code: json['code'],
      data: (json['data'] as List)
          .map((branchJson) => BranchModel.fromJson(branchJson))
          .toList(),
    );
  }

  /// تحويل من BranchesResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((branch) => branch.toJson()).toList(),
    };
  }
}
