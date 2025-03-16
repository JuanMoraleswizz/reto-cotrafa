import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel(
      {required super.id,
      required super.inventoryId,
      required super.name,
      required super.barcode,
      required super.price,
      required super.quantity});

  factory ProductModel.fromJson(json) {
    return ProductModel(
        id: json['id'],
        inventoryId: json['inventory_id'],
        name: json['name'],
        barcode: json['barcode'],
        price: json['price'],
        quantity: json['quantity']);
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
        id: product.id,
        inventoryId: product.inventoryId,
        name: product.name,
        barcode: product.barcode,
        price: product.price,
        quantity: product.quantity);
  }
}
