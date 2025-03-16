import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';

class AddProductUseCase {
  final ProductRepository productRepository;

  AddProductUseCase({required this.productRepository});

  Future<Either<Failure, bool>> call(Product product) {
    return productRepository.addProduct(product);
  }
}
