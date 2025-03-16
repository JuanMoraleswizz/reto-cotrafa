import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventarySearch extends InventoryState {
  final Inventory inventory;
  InventarySearch({required this.inventory});
}

class InventoryLoaded extends InventoryState {
  final List<Inventory> inventories;
  InventoryLoaded({required this.inventories});
}

class InventoryError extends InventoryState {
  final Failure failure;
  InventoryError({required this.failure});
}
