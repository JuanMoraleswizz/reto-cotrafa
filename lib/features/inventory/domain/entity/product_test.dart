import 'package:flutter_test/flutter_test.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';

void main() {
  group('Product', () {
    test('toJson should return a valid JSON map', () {
      final product = Product(
        id: '1',
        inventoryId: 'inv1',
        name: 'Test Product',
        barcode: '123456789',
        price: 10.5,
        quantity: 100,
      );

      final json = product.toJson();

      expect(json, {
        'id': '1',
        'inventory_id': 'inv1',
        'name': 'Test Product',
        'barcode': '123456789',
        'price': 10.5,
        'quantity': 100,
      });
    });

    test('copyWith should return a new Product with updated values', () {
      final product = Product(
        id: '1',
        inventoryId: 'inv1',
        name: 'Test Product',
        barcode: '123456789',
        price: 10.5,
        quantity: 100,
      );

      final updatedProduct = product.copyWith(
        name: 'Updated Product',
        price: 15.0,
      );

      expect(updatedProduct.id, '1');
      expect(updatedProduct.inventoryId, 'inv1');
      expect(updatedProduct.name, 'Updated Product');
      expect(updatedProduct.barcode, '123456789');
      expect(updatedProduct.price, 15.0);
      expect(updatedProduct.quantity, 100);
    });

    test('copyWith should return the same Product if no values are updated',
        () {
      final product = Product(
        id: '1',
        inventoryId: 'inv1',
        name: 'Test Product',
        barcode: '123456789',
        price: 10.5,
        quantity: 100,
      );

      final sameProduct = product.copyWith();

      expect(sameProduct.id, product.id);
      expect(sameProduct.inventoryId, product.inventoryId);
      expect(sameProduct.name, product.name);
      expect(sameProduct.barcode, product.barcode);
      expect(sameProduct.price, product.price);
      expect(sameProduct.quantity, product.quantity);
    });
  });
}
