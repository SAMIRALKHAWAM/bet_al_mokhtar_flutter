class DeliveryResponse {
  final bool success;
  final String message;
  final int perPage;
  final int total;
  final int currentPage;
  final int lastPage;
  final List<OrderData> data;

  DeliveryResponse({
    required this.success,
    required this.message,
    required this.perPage,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      success: json['success'],
      message: json['message'],
      perPage: json['per_page'],
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: List<OrderData>.from(
        json['data'].map((item) => OrderData.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'per_page': perPage,
      'total': total,
      'current_page': currentPage,
      'last_page': lastPage,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderData {
  final int id;
  final int invoiceId;
  final int? waiterId;
  final int discount;
  final int fullPrice;
  final String status;
  final String type;
  final String? waiterName;
  final int? tableId;
  final ExternalOrderInfo externalOrderInfo;

  OrderData({
    required this.id,
    required this.invoiceId,
    this.waiterId,
    required this.discount,
    required this.fullPrice,
    required this.status,
    required this.type,
    this.waiterName,
    this.tableId,
    required this.externalOrderInfo,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      invoiceId: json['invoice_id'],
      waiterId: json['waiter_id'],
      discount: json['discount'],
      fullPrice: json['full_price'],
      status: json['status'],
      type: json['type'],
      waiterName: json['waiter_name'],
      tableId: json['table_id'],
      externalOrderInfo:
      ExternalOrderInfo.fromJson(json['external_order_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'waiter_id': waiterId,
      'discount': discount,
      'full_price': fullPrice,
      'status': status,
      'type': type,
      'waiter_name': waiterName,
      'table_id': tableId,
      'external_order_info': externalOrderInfo.toJson(),
    };
  }
}

class ExternalOrderInfo {
  final int id;
  final int invoiceId;
  final int userId;
  final String location;
  final String phone;
  final String qr;

  ExternalOrderInfo({
    required this.id,
    required this.invoiceId,
    required this.userId,
    required this.location,
    required this.phone,
    required this.qr,
  });

  factory ExternalOrderInfo.fromJson(Map<String, dynamic> json) {
    return ExternalOrderInfo(
      id: json['id'],
      invoiceId: json['invoice_id'],
      userId: json['user_id'],
      location: json['location'],
      phone: json['phone'],
      qr: json['qr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'user_id': userId,
      'location': location,
      'phone': phone,
      'qr': qr,
    };
  }
}
