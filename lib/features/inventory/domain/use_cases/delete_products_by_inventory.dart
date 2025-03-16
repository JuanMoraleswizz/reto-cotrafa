import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';

class DeleteProductsByInventoryUseCase {
  final ProductRepository productRepository;

  DeleteProductsByInventoryUseCase({required this.productRepository});

  Future<Either<Failure, bool>> call(String id) {
    return productRepository.deleteProduct(id);
  }
}
