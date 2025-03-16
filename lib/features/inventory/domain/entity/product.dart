class Product {
  final String id;
  final String inventoryId;
  final String name;
  final String barcode;
  final double price;
  final int quantity;

  Product(
      {required this.id,
      required this.inventoryId,
      required this.name,
      required this.barcode,
      required this.price,
      required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventory_id': inventoryId,
      'name': name,
      'barcode': barcode,
      'price': price,
      'quantity': quantity
    };
  }

  Product copyWith({
    String? id,
    String? inventoryId,
    String? name,
    String? barcode,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      inventoryId: inventoryId ?? this.inventoryId,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
