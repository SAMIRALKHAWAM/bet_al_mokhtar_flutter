// To parse this JSON data, do
//
//     final mealInfoModel = mealInfoModelFromJson(jsonString);

import 'dart:convert';

Get_one_itemModel mealInfoModelFromJson(String str) => Get_one_itemModel.fromJson(json.decode(str));

String mealInfoModelToJson(Get_one_itemModel data) => json.encode(data.toJson());

class Get_one_itemModel {
  bool success;
  String message;
  int code;
  Data data;

  Get_one_itemModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory Get_one_itemModel.fromJson(Map<String, dynamic> json) => Get_one_itemModel(
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
  int id;
  int categoryId;
  String name;
  int price;
  List<ItemImage> itemImages;

  Data({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.itemImages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  int id;
  String image;

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
