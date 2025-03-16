import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';

class UpdateInventoryUseCase {
  final InventoryRepository inventoryRepository;

  UpdateInventoryUseCase({required this.inventoryRepository});

  Future<Either<Failure, bool>> call(Inventory inventory) {
    return inventoryRepository.updateInventory(inventory);
  }
}
