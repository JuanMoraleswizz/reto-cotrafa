import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';

abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  final String inventoryId;
  LoadProducts({required this.inventoryId});
}

class SearchProduct extends ProductEvent {
  final String id;
  SearchProduct(this.id);
}

class AddProduct extends ProductEvent {
  final Product product;
  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;
  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final String id;
  final String inventoryId;
  DeleteProduct(this.id, this.inventoryId);
}
