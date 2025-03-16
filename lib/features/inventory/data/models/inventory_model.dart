import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';

class InventoryModel extends Inventory {
  InventoryModel({required super.id, required super.name});

  factory InventoryModel.fromJson(json) {
    return InventoryModel(id: json['id'], name: json['name']);
  }

  factory InventoryModel.fromEntity(Inventory inventory) {
    return InventoryModel(id: inventory.id, name: inventory.name);
  }
}
