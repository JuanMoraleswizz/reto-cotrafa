import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';

abstract class InventoryEvent {}

class LoadInventories extends InventoryEvent {}

class SearchInventary extends InventoryEvent {
  final String id;
  SearchInventary(this.id);
}

class AddInventory extends InventoryEvent {
  final Inventory inventory;
  AddInventory(this.inventory);
}

class UpdateInventory extends InventoryEvent {
  final Inventory inventory;
  UpdateInventory(this.inventory);
}

class DeleteInventory extends InventoryEvent {
  final String id;
  DeleteInventory(this.id);
}
