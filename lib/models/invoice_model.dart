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
  int? tableId;
  int? branchId;
  int? fullPrice;
  int tax;
  int finalPrice;
  int discount;
  String? status;
  String? branchName;
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
    this.status,
    this.branchName,
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
    'internal_orders': internalOrders.map((x) => x.toJson()).toList(),
    'invoice_taxes': invoiceTaxes,
    'invoice_discounts': invoiceDiscounts,
  };
}

class InternalOrder {
  int id;
  int invoiceId;
  int? waiterId;
  int? discount;
  int fullPrice;
  String? status;
  String? waiterName;
  int? tableId;
  List<InternalOrderLine> internalOrderLines;
  List<InternalOrderOffer> internalOrderOffers;

  InternalOrder({
    required this.id,
    required this.invoiceId,
    required this.waiterId,
    required this.discount,
    required this.fullPrice,
    this.status,
    this.waiterName,
    required this.tableId,
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
    tableId: json['table_id'],
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
    'table_id': tableId,
    'internal_order_lines': internalOrderLines.map((x) => x.toJson()).toList(),
    'internal_order_offers': internalOrderOffers.map((x) => x.toJson()).toList(),
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
  Offer offer;

  InternalOrderOffer({
    required this.id,
    required this.internalOrderId,
    required this.offerId,
    required this.quantity,
    required this.price,
    required this.offer,
  });

  factory InternalOrderOffer.fromJson(Map<String, dynamic> json) => InternalOrderOffer(
    id: json['id'],
    internalOrderId: json['internal_order_id'],
    offerId: json['offer_id'],
    quantity: json['quantity'],
    price: json['price'],
    offer: Offer.fromJson(json['offer']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'internal_order_id': internalOrderId,
    'offer_id': offerId,
    'quantity': quantity,
    'price': price,
    'offer': offer.toJson(),
  };
}

class Offer {
  int id;
  String name;
  String description;
  int price;
  String fromDate;
  String toDate;
  int available;
  List<OfferItem> offerItems;
  List<OfferBranch> offerBranches;

  Offer({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.fromDate,
    required this.toDate,
    required this.available,
    required this.offerItems,
    required this.offerBranches,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    fromDate: json['from_date'],
    toDate: json['to_date'],
    available: json['available'],
    offerItems: List<OfferItem>.from(json['offer_items'].map((x) => OfferItem.fromJson(x))),
    offerBranches:
    List<OfferBranch>.from(json['offer_branches'].map((x) => OfferBranch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'from_date': fromDate,
    'to_date': toDate,
    'available': available,
    'offer_items': offerItems.map((x) => x.toJson()).toList(),
    'offer_branches': offerBranches.map((x) => x.toJson()).toList(),
  };
}

class OfferItem {
  int id;
  int offerId;
  int itemId;
  int quantity;
  int price;
  Item item;

  OfferItem({
    required this.id,
    required this.offerId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.item,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
    id: json['id'],
    offerId: json['offer_id'],
    itemId: json['item_id'],
    quantity: json['quantity'],
    price: json['price'],
    item: Item.fromJson(json['item']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'offer_id': offerId,
    'item_id': itemId,
    'quantity': quantity,
    'price': price,
    'item': item.toJson(),
  };
}

class Item {
  int id;
  int categoryId;
  String name;
  int price;
  List<ItemImage> itemImages;

  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.itemImages,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'],
    categoryId: json['category_id'],
    name: json['name'],
    price: json['price'],
    itemImages:
    List<ItemImage>.from(json['item_images'].map((x) => ItemImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'price': price,
    'item_images': itemImages.map((x) => x.toJson()).toList(),
  };
}

class ItemImage {
  int id;
  String image;

  ItemImage({
    required this.id,
    required this.image,
  });

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
    id: json['id'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
  };
}

class OfferBranch {
  int id;
  int offerId;
  int branchId;
  Branch branch;

  OfferBranch({
    required this.id,
    required this.offerId,
    required this.branchId,
    required this.branch,
  });

  factory OfferBranch.fromJson(Map<String, dynamic> json) => OfferBranch(
    id: json['id'],
    offerId: json['offer_id'],
    branchId: json['branch_id'],
    branch: Branch.fromJson(json['branch']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'offer_id': offerId,
    'branch_id': branchId,
    'branch': branch.toJson(),
  };
}

class Branch {
  int id;
  String name;
  String location;

  Branch({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json['id'],
    name: json['name'],
    location: json['location'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
  };
}
