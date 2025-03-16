import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';
import 'package:dartz/dartz.dart';

class AddInventoryUseCase {
  final InventoryRepository inventoryRepository;

  AddInventoryUseCase({required this.inventoryRepository});

  Future<Either<Failure, bool>> call(Inventory inventory) {
    return inventoryRepository.addInventory(inventory);
  }
}
