import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSearch extends ProductState {
  final Product product;
  ProductSearch({required this.product});
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded({required this.products});
}

class ProductError extends ProductState {
  final Failure failure;
  ProductError({required this.failure});
}
