class OrderResponse {
  final bool success;
  final String message;
  final num perPage;
  final int? total;
  final int? currentPage;
  final int? lastPage;
  final List<OrderItem> data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.perPage,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'],
      message: json['message'],
      perPage: json['per_page'],
      total: json['total'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: (json['data'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final int invoiceId;
  final int? waiterId;
  final int? discount;
  final int? fullPrice;
  final String status;
  final String type;
  final String? waiterName;
  final dynamic? table_id;

  OrderItem({
    required this.id,
    required this.invoiceId,
     this.waiterId,
    required this.discount,
    required this.fullPrice,
    required this.status,
    required this.waiterName,
    this.table_id,
    required this.type
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      waiterId: json['waiter_id'],
      discount: json['discount'],
      fullPrice: json['full_price'],
      status: json['status'],
      waiterName: json['waiter_name'],
      table_id: json['table_id'],
      type: json['type'],


    );
  }
}
