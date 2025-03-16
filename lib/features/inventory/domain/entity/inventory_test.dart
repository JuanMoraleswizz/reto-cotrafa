import 'package:flutter_test/flutter_test.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';

void main() {
  group('Inventory', () {
    test('toJson should return a valid map representation', () {
      var inventory = Inventory(id: '123', name: 'Test Inventory');
      final json = inventory.toJson();

      expect(json, {'id': '123', 'name': 'Test Inventory'});
    });

    test('copyWith should return a new instance with updated values', () {
      var inventory = Inventory(id: '123', name: 'Test Inventory');
      final updatedInventory = inventory.copyWith(name: 'Updated Inventory');

      expect(updatedInventory.id, '123');
      expect(updatedInventory.name, 'Updated Inventory');
    });

    test('copyWith should return the same instance if no values are updated',
        () {
      var inventory = Inventory(id: '123', name: 'Test Inventory');
      final sameInventory = inventory.copyWith();

      expect(sameInventory.id, '123');
      expect(sameInventory.name, 'Test Inventory');
    });
  });
}
