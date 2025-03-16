import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';

class GetProductUseCase {
  final ProductRepository productRepository;

  GetProductUseCase({required this.productRepository});

  Future<Either<Failure, Product>> call(String id) {
    return productRepository.getProduct(id);
  }
}
