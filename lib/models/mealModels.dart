// To parse this JSON data, do
//
//     final mealModel = mealModelFromJson(jsonString);

import 'dart:convert';

MealModel mealModelFromJson(String str) => MealModel.fromJson(json.decode(str));

String mealModelToJson(MealModel data) => json.encode(data.toJson());

class MealModel {
  bool success;
  String message;
  int code;
  List<Datum> data;

  MealModel({
    required this.success,
    required this.message,
    required this.code,
    required this.data,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
    success: json["success"],
    message: json["message"],
    code: json["code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "code": code,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  int categoryId;
  String name;
  int price;
  List<ItemImage> itemImages;

  Datum({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.itemImages,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
