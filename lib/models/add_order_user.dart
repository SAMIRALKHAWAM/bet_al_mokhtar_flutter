class AddOrderItem {
  final int id;
  final String name;
  final int quantity;
  final num price;

  AddOrderItem({
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
    return 'AddOrderItem(id: $id, name: $name, quantity: $quantity, price: $price)';
  }
}
