class OfferResponse {
  final bool success;
  final String message;
  final int perPage;
  final int total;
  final int currentPage;
  final int lastPage;
  final List<Offer> data;

  OfferResponse({
    required this.success,
    required this.message,
    required this.perPage,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) => OfferResponse(
    success: json["success"],
    message: json["message"],
    perPage: json["per_page"],
    total: json["total"],
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    data: List<Offer>.from(json["data"].map((x) => Offer.fromJson(x))),
  );
}

class Offer {
  final int id;
  final String name;
  final String description;
  final int price;
  final String fromDate;
  final String toDate;
  final int available;
  final List<OfferItem> offerItems;
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
    offerItems: List<OfferItem>.from(
        json["offer_items"].map((x) => OfferItem.fromJson(x))),
    offerBranches: List<OfferBranch>.from(
        json["offer_branches"].map((x) => OfferBranch.fromJson(x))),
  );
}

class OfferItem {
  final int id;
  final int offerId;
  final int itemId;
  final int quantity;
  final int price;
  final Item item;

  OfferItem({
    required this.id,
    required this.offerId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.item,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) => OfferItem(
    id: json["id"],
    offerId: json["offer_id"],
    itemId: json["item_id"],
    quantity: json["quantity"],
    price: json["price"],
    item: Item.fromJson(json["item"]),
  );
}

class Item {
  final int id;
  final int categoryId;
  final String name;
  final int price;
  final List<ItemImage> itemImages;

  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.itemImages,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    categoryId: json["category_id"],
    name: json["name"],
    price: json["price"],
    itemImages: List<ItemImage>.from(
        json["item_images"].map((x) => ItemImage.fromJson(x))),
  );
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
}
