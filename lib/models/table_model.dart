import 'dart:convert';

class TableResponse {
  bool success;
  String message;
  int perPage;
  int total;
  int currentPage;
  int lastPage;
  List<TableModel> data;

  TableResponse({
    required this.success,
    required this.message,
    required this.perPage,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory TableResponse.fromJson(Map<String, dynamic> json) => TableResponse(
    success: json["success"],
    message: json["message"],
    perPage: json["per_page"],
    total: json["total"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: List<TableModel>.from(json["data"].map((x) => TableModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "per_page": perPage,
    "total": total,
    "current_page": currentPage,
    "last_page": lastPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TableModel {
  int id;
  int branchId;
  int ?invoice_id;
  int tableNumber;
  int chairNumber;
  bool available;
  String branchName;

  TableModel({
    required this.id,
    required this.branchId,
    required this.tableNumber,
    required this.chairNumber,
    required this.available,
    required this.branchName,
    required this.invoice_id,

  });

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
    id: json["id"],
    branchId: json["branch_id"],
    tableNumber: json["table_number"],
    chairNumber: json["chair_number"],
    available: json["available"],
    branchName: json["branch_name"],
    invoice_id: json["invoice_id"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_id": branchId,
    "table_number": tableNumber,
    "chair_number": chairNumber,
    "available": available,
    "branch_name": branchName,
    "invoice_id": invoice_id,


  };
}
