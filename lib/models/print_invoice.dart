class Print_Invoice {
  bool success;
  String message;
  int code;
  InvoiceData data;

  Print_Invoice({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Print_Invoice.fromJson(Map<String, dynamic> json) => Print_Invoice(
    success: json['success'],
    message: json['message'],
    code: json['code'],
    data: InvoiceData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'code': code,
    'data': data.toJson(),
  };
}

class InvoiceData {
  Invoice invoice;
  List<Item> items;
  List<Offer> offers;
  List<Tax> taxes;
  List<Discount> discounts;

  InvoiceData({
    required this.invoice,
    required this.items,
    required this.offers,
    required this.taxes,
    required this.discounts,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
    invoice: Invoice.fromJson(json['invoice']),
    items: List<Item>.from(json['items'].map((x) => Item.fromJson(x))),
    offers: List<Offer>.from(json['offers'].map((x) => Offer.fromJson(x))),
    taxes: List<Tax>.from(json['taxes'].map((x) => Tax.fromJson(x))),
    discounts: List<Discount>.from(json['discounts'].map((x) => Discount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'invoice': invoice.toJson(),
    'items': List<dynamic>.from(items.map((x) => x.toJson())),
    'offers': List<dynamic>.from(offers.map((x) => x.toJson())),
    'taxes': List<dynamic>.from(taxes.map((x) => x.toJson())),
    'discounts': List<dynamic>.from(discounts.map((x) => x.toJson())),
  };
}

class Invoice {
  int id;
  int? userId;
  int? tableId;
  int branchId;
  int fullPrice;
  int tax;
  int finalPrice;
  int discount;
  int deliverymanId;
  String status;
  String branchName;

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

class Item {
  int id;
  String name;
  String description;
  int price;
  int quantity;
  int totalPrice;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    quantity: json['quantity'],
    totalPrice: json['total_price'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'quantity': quantity,
    'total_price': totalPrice,
  };
}

class Offer {
  // حالياً ما في بيانات، لكن نضيف موديل بسيط، عدل حسب البيانات الفعلية لاحقاً
  Offer();

  factory Offer.fromJson(Map<String, dynamic> json) {
    // إذا بيانات العروض كانت فارغة، رجع قيمة افتراضية
    return Offer();
  }

  Map<String, dynamic> toJson() => {};
}

class Tax {
  int id;
  int invoiceId;
  int taxId;
  int percent;
  int amount;
  String taxName;

  Tax({
    required this.id,
    required this.invoiceId,
    required this.taxId,
    required this.percent,
    required this.amount,
    required this.taxName,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    id: json['id'],
    invoiceId: json['invoice_id'],
    taxId: json['tax_id'],
    percent: json['percent'],
    amount: json['amount'],
    taxName: json['tax_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_id': invoiceId,
    'tax_id': taxId,
    'percent': percent,
    'amount': amount,
    'tax_name': taxName,
  };
}

class Discount {
  // خصم حالياً فارغ، نفس فكرة العروض
  Discount();

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount();
  }

  Map<String, dynamic> toJson() => {};
}
