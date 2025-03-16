import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';

class GetInventariesUseCase {
  final InventoryRepository inventoryRepository;

  GetInventariesUseCase({required this.inventoryRepository});

  Future<Either<Failure, List<Inventory>>> call() {
    return inventoryRepository.getInventories();
  }
}
