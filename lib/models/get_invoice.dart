class Get_Invoice {
  bool success;
  String message;
  int? perPage;
  int? total;
  int? currentPage;
  int? lastPage;
  List<Invoice> data;

  Get_Invoice({
    required this.success,
    required this.message,
    required this.perPage,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory Get_Invoice.fromJson(Map<String, dynamic> json) => Get_Invoice(
    success: json['success'],
    message: json['message'],
    perPage: json['per_page'],
    total: json['total'],
    currentPage: json['current_page'],
    lastPage: json['last_page'],
    data: List<Invoice>.from(json['data'].map((x) => Invoice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'per_page': perPage,
    'total': total,
    'current_page': currentPage,
    'last_page': lastPage,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Invoice {
  int id;
  int? userId;
  int? tableId;
  int? branchId;
  int? fullPrice;
  int? tax;
  int? finalPrice;
  int? discount;
  int? deliverymanId;
  String status;
  String? branchName;

  Invoice({
    required this.id,
    this.userId,
    this.tableId,
    required this.branchId,
    required this.fullPrice,
    required this.tax,
    required this.finalPrice,
    required this.discount,
    required this.deliverymanId,
    required this.status,
    required this.branchName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json['id'],
    userId: json['user_id'],
    tableId: json['table_id'],
    branchId: json['branch_id'],
    fullPrice: json['full_price'],
    tax: json['tax'],
    finalPrice: json['final_price'],
    discount: json['discount'],
    deliverymanId: json['deliveryman_id'],
    status: json['status'],
    branchName: json['branch_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'table_id': tableId,
    'branch_id': branchId,
    'full_price': fullPrice,
    'tax': tax,
    'final_price': finalPrice,
    'discount': discount,
    'deliveryman_id': deliverymanId,
    'status': status,
    'branch_name': branchName,
  };
}
