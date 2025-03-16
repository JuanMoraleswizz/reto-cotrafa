import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, bool>> addProduct(Product product);
  Future<Either<Failure, bool>> updateProduct(Product product);
  Future<Either<Failure, bool>> deleteProduct(String id);
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, List<Product>>> getProductsByInventoryId(
      String inventoryId);
  Future<Either<Failure, bool>> deleteProductByInventory(String inventory);
}
