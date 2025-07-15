class InternalOrderResponse {
  final bool success;
  final String message;
  final int code;
  final Data data;

  InternalOrderResponse({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory InternalOrderResponse.fromJson(Map<String, dynamic> json) => InternalOrderResponse(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": data.toJson(),
  };
}

class Data {
  final List<Item> items;
  final List<OfferItem> offers;

  Data({
    required this.items,
    required this.offers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    offers: List<OfferItem>.from(json["offers"].map((x) => OfferItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
  };
}

class Item {
  final int id;
  final int internalOrderId;
  final int itemId;
  final int quantity;
  final int price;
  final String itemName;
  final int itemPrice;

  Item({
    required this.id,
    required this.internalOrderId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.itemName,
    required this.itemPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    internalOrderId: json["internal_order_id"],
    itemId: json["item_id"],
    quantity: json["quantity"],
    price: json["price"],
    itemName: json["item_name"],
    itemPrice: json["item_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "internal_order_id": internalOrderId,
    "item_id": itemId,
    "quantity": quantity,
    "price": price,
    "item_name": itemName,
    "item_price": itemPrice,
  };
}

class OfferItem {
  final int id;
  final int internalOrderId;
  final int offerId;
  final int quantity;
  final int price;
  final Offer offer;

  OfferItem({
    required this.id,
    required this.internalOrderId,
    required this.offerId,
    required this.quantity,
    required this.price,
    required this.offer,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
    id: json["id"],
    internalOrderId: json["internal_order_id"],
    offerId: json["offer_id"],
    quantity: json["quantity"],
    price: json["price"],
    offer: Offer.fromJson(json["offer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "internal_order_id": internalOrderId,
    "offer_id": offerId,
    "quantity": quantity,
    "price": price,
    "offer": offer.toJson(),
  };
}

class Offer {
  final int id;
  final String name;
  final String description;
  final int price;
  final String fromDate;
  final String toDate;
  final int available;
  final List<OfferItemDetail> offerItems;
  final List<OfferBranch> offerBranches;

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
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    fromDate: json["from_date"],
    toDate: json["to_date"],
    available: json["available"],
    offerItems: List<OfferItemDetail>.from(json["offer_items"].map((x) => OfferItemDetail.fromJson(x))),
    offerBranches: List<OfferBranch>.from(json["offer_branches"].map((x) => OfferBranch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "from_date": fromDate,
    "to_date": toDate,
    "available": available,
    "offer_items": List<dynamic>.from(offerItems.map((x) => x.toJson())),
    "offer_branches": List<dynamic>.from(offerBranches.map((x) => x.toJson())),
  };
}

class OfferItemDetail {
  final int id;
  final int offerId;
  final int itemId;
  final int quantity;
  final int price;
  final ItemDetail item;

  OfferItemDetail({
    required this.id,
    required this.offerId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.item,
  });

  factory OfferItemDetail.fromJson(Map<String, dynamic> json) => OfferItemDetail(
    id: json["id"],
    offerId: json["offer_id"],
    itemId: json["item_id"],
    quantity: json["quantity"],
    price: json["price"],
    item: ItemDetail.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_id": offerId,
    "item_id": itemId,
    "quantity": quantity,
    "price": price,
    "item": item.toJson(),
  };
}

class ItemDetail {
  final int id;
  final int categoryId;
  final String name;
  final int price;
  final List<ItemImage> itemImages;

  ItemDetail({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.itemImages,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
    id: json["id"],
    categoryId: json["category_id"],
    name: json["name"],
    price: json["price"],
    itemImages: List<ItemImage>.from(json["item_images"].map((x) => ItemImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "name": name,
    "price": price,
    "item_images": List<dynamic>.from(itemImages.map((x) => x.toJson())),
  };
}

class ItemImage {
  final int id;
  final String image;

  ItemImage({
    required this.id,
    required this.image,
  });

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}

class OfferBranch {
  final int id;
  final int offerId;
  final int branchId;
  final Branch branch;

  OfferBranch({
    required this.id,
    required this.offerId,
    required this.branchId,
    required this.branch,
  });

  factory OfferBranch.fromJson(Map<String, dynamic> json) => OfferBranch(
    id: json["id"],
    offerId: json["offer_id"],
    branchId: json["branch_id"],
    branch: Branch.fromJson(json["branch"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_id": offerId,
    "branch_id": branchId,
    "branch": branch.toJson(),
  };
}

class Branch {
  final int id;
  final String name;
  final String location;

  Branch({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    name: json["name"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
  };
}
