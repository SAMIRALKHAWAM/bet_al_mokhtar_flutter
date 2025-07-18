class DiscountModel {
  final int id;
  final String name;
  final String code;
  final int percent;
  final String fromDate;
  final String toDate;

  DiscountModel({
    required this.id,
    required this.name,
    required this.code,
    required this.percent,
    required this.fromDate,
    required this.toDate,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      percent: json['percent'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'percent': percent,
      'from_date': fromDate,
      'to_date': toDate,
    };
  }
}

class DiscountsResponse {
  final bool success;
  final String message;
  final int code;
  final List<DiscountModel> data;

  DiscountsResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory DiscountsResponse.fromJson(Map<String, dynamic> json) {
    return DiscountsResponse(
      success: json['success'],
      message: json['message'],
      code: json['code'],
      data: List<DiscountModel>.from(
        json['data'].map((e) => DiscountModel.fromJson(e)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
