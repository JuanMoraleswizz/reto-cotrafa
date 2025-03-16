import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';

class DeleteInventoryUseCase {
  final InventoryRepository inventoryRepository;

  DeleteInventoryUseCase({required this.inventoryRepository});

  Future<Either<Failure, bool>> call(String id) {
    return inventoryRepository.deleteInventory(id);
  }
}
