class AddOrderOffer {
  final int id;
  final String name;
  final int quantity;  // لو حابب تحدد كمية من العرض
  final num price;

  AddOrderOffer({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "price": price,
  };

  @override
  String toString() {
    return 'AddOrderOffer(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}
