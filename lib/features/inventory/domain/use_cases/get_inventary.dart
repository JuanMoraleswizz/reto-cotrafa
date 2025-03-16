import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';

class GetInventaryUseCase {
  final InventoryRepository inventoryRepository;

  GetInventaryUseCase({required this.inventoryRepository});

  Future<Either<Failure, Inventory>> call(String id) {
    return inventoryRepository.getInventory(id);
  }
}
