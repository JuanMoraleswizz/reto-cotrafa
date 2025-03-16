import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';

class GetProductsByInventoryUseCase {
  final ProductRepository productRepository;

  GetProductsByInventoryUseCase({required this.productRepository});

  Future<Either<Failure, List<Product>>> call(String inventoryId) {
    return productRepository.getProductsByInventoryId(inventoryId);
  }
}
