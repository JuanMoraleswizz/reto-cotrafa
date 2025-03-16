import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Inventory>>> getInventories();
  Future<Either<Failure, bool>> addInventory(Inventory inventory);
  Future<Either<Failure, bool>> updateInventory(Inventory inventory);
  Future<Either<Failure, bool>> deleteInventory(String id);
  Future<Either<Failure, Inventory>> getInventory(String id);
}
