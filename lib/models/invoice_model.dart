class InvoiceResponse {
  bool success;
  String message;
  int code;
  Data data;

  InvoiceResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) => InvoiceResponse(
    success: json['success'],
    message: json['message'],
    code: json['code'],
    data: Data.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'code': code,
    'data': data.toJson(),
  };
}

class Data {
  int id;
  int tableId;
  int branchId;
  int fullPrice;
  int tax;
  int finalPrice;
  int discount;
  String status;
  String branchName;
  List<InternalOrder> internalOrders;
  List<dynamic> invoiceTaxes;
  List<dynamic> invoiceDiscounts;

  Data({
    required this.id,
    required this.tableId,
    required this.branchId,
    required this.fullPrice,
    required this.tax,
    required this.finalPrice,
    required this.discount,
    required this.status,
    required this.branchName,
    required this.internalOrders,
    required this.invoiceTaxes,
    required this.invoiceDiscounts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json['id'],
    tableId: json['table_id'],
    branchId: json['branch_id'],
    fullPrice: json['full_price'],
    tax: json['tax'],
    finalPrice: json['final_price'],
    discount: json['discount'],
    status: json['status'],
    branchName: json['branch_name'],
    internalOrders: List<InternalOrder>.from(
        json['internal_orders'].map((x) => InternalOrder.fromJson(x))),
    invoiceTaxes: List<dynamic>.from(json['invoice_taxes']),
    invoiceDiscounts: List<dynamic>.from(json['invoice_discounts']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'table_id': tableId,
    'branch_id': branchId,
    'full_price': fullPrice,
    'tax': tax,
    'final_price': finalPrice,
    'discount': discount,
    'status': status,
    'branch_name': branchName,
    'internal_orders': List<dynamic>.from(internalOrders.map((x) => x.toJson())),
    'invoice_taxes': invoiceTaxes,
    'invoice_discounts': invoiceDiscounts,
  };
}

class InternalOrder {
  int id;
  int invoiceId;
  int waiterId;
  int discount;
  int fullPrice;
  String status;
  String waiterName;
  List<InternalOrderLine> internalOrderLines;
  List<InternalOrderOffer> internalOrderOffers;

  InternalOrder({
    required this.id,
    required this.invoiceId,
    required this.waiterId,
    required this.discount,
    required this.fullPrice,
    required this.status,
    required this.waiterName,
    required this.internalOrderLines,
    required this.internalOrderOffers,
  });

  factory InternalOrder.fromJson(Map<String, dynamic> json) => InternalOrder(
    id: json['id'],
    invoiceId: json['invoice_id'],
    waiterId: json['waiter_id'],
    discount: json['discount'],
    fullPrice: json['full_price'],
    status: json['status'],
    waiterName: json['waiter_name'],
    internalOrderLines: List<InternalOrderLine>.from(
        json['internal_order_lines'].map((x) => InternalOrderLine.fromJson(x))),
    internalOrderOffers: List<InternalOrderOffer>.from(
        json['internal_order_offers'].map((x) => InternalOrderOffer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'waiter_id': waiterId,
    'discount': discount,
    'full_price': fullPrice,
    'status': status,
    'waiter_name': waiterName,
    'internal_order_lines': List<dynamic>.from(internalOrderLines.map((x) => x.toJson())),
    'internal_order_offers': List<dynamic>.from(internalOrderOffers.map((x) => x.toJson())),
  };
}

class InternalOrderLine {
  int id;
  int internalOrderId;
  int itemId;
  int quantity;
  int price;
  String itemName;
  int itemPrice;

  InternalOrderLine({
    required this.id,
    required this.internalOrderId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.itemName,
    required this.itemPrice,
  });

  factory InternalOrderLine.fromJson(Map<String, dynamic> json) => InternalOrderLine(
    id: json['id'],
    internalOrderId: json['internal_order_id'],
    itemId: json['item_id'],
    quantity: json['quantity'],
    price: json['price'],
    itemName: json['item_name'],
    itemPrice: json['item_price'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'internal_order_id': internalOrderId,
    'item_id': itemId,
    'quantity': quantity,
    'price': price,
    'item_name': itemName,
    'item_price': itemPrice,
  };
}

class InternalOrderOffer {
  int id;
  int internalOrderId;
  int offerId;
  int quantity;
  int price;
  String offerName;
  String offerDescription;
  int offerPrice;

  InternalOrderOffer({
    required this.id,
    required this.internalOrderId,
    required this.offerId,
    required this.quantity,
    required this.price,
    required this.offerName,
    required this.offerDescription,
    required this.offerPrice,
  });

  factory InternalOrderOffer.fromJson(Map<String, dynamic> json) => InternalOrderOffer(
    id: json['id'],
    internalOrderId: json['internal_order_id'],
    offerId: json['offer_id'],
    quantity: json['quantity'],
    price: json['price'],
    offerName: json['offer_name'],
    offerDescription: json['offer_description'],
    offerPrice: json['offer_price'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'internal_order_id': internalOrderId,
    'offer_id': offerId,
    'quantity': quantity,
    'price': price,
    'offer_name': offerName,
    'offer_description': offerDescription,
    'offer_price': offerPrice,
  };
}
