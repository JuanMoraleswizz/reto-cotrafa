import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/data/models/inventory_model.dart';
import 'package:reto_cotrafa/features/inventory/data/repository/inventory_repository_impl.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late InventoryRepositoryImpl repository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    repository =
        InventoryRepositoryImpl(sharedPreferences: mockSharedPreferences);
  });

  var tInventoryModel = InventoryModel(id: '1', name: 'Test Inventory');
  var tInventory = Inventory(id: '1', name: 'Test Inventory');
  const tStorageKey = "inventories";

  group('addInventory', () {
    test('should add inventory and return true on success', () async {
      when(mockSharedPreferences.getString(tStorageKey)).thenReturn(null);
      when(mockSharedPreferences.setString(tStorageKey, "test"))
          .thenAnswer((_) async => true);

      final result = await repository.addInventory(tInventory);

      verify(mockSharedPreferences.setString(
        tStorageKey,
        json.encode([tInventoryModel.toJson()]),
      ));
      expect(result, const Right(true));
    });

    test('should return StorageFailure when saving fails', () async {
      when(mockSharedPreferences.getString(tStorageKey)).thenReturn(null);
      when(mockSharedPreferences.setString(tStorageKey, ""))
          .thenAnswer((_) async => false);

      final result = await repository.addInventory(tInventory);

      expect(result, Left(StorageFailure("Error al guardar el inventario")));
    });
  });

  group('deleteInventory', () {
    test('should delete inventory and return true on success', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([tInventoryModel.toJson()]));
      when(mockSharedPreferences.setString(tStorageKey, ""))
          .thenAnswer((_) async => true);

      final result = await repository.deleteInventory('1');

      verify(mockSharedPreferences.setString(tStorageKey, json.encode([])));
      expect(result, const Right(true));
    });

    test('should return StorageFailure when deletion fails', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([tInventoryModel.toJson()]));
      when(mockSharedPreferences.setString("", ""))
          .thenThrow(Exception('Error'));

      final result = await repository.deleteInventory('1');

      expect(result, isA<Left>());
    });
  });

  group('getInventories', () {
    test('should return a list of inventories on success', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([tInventoryModel.toJson()]));

      final result = await repository.getInventories();

      expect(result, Right([tInventory]));
    });

    test('should return an empty list when no inventories are found', () async {
      when(mockSharedPreferences.getString(tStorageKey)).thenReturn(null);

      final result = await repository.getInventories();

      expect(result, const Right([]));
    });

    test('should return StorageFailure on error', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenThrow(Exception('Error'));

      final result = await repository.getInventories();

      expect(result, isA<Left>());
    });
  });

  group('getInventory', () {
    test('should return the inventory when found', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([tInventoryModel.toJson()]));

      final result = await repository.getInventory('1');

      expect(result, Right(tInventoryModel));
    });

    test('should return StorageFailure when inventory is not found', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([]));

      final result = await repository.getInventory('1');

      expect(result, Left(StorageFailure("Inventario con ID 1 no encontrado")));
    });
  });

  group('updateInventory', () {
    test('should update inventory and return true on success', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([tInventoryModel.toJson()]));
      when(mockSharedPreferences.setString(tStorageKey, ""))
          .thenAnswer((_) async => true);

      final updatedInventory = Inventory(id: '1', name: 'Updated Inventory');
      final result = await repository.updateInventory(updatedInventory);

      verify(mockSharedPreferences.setString(
        tStorageKey,
        json.encode([InventoryModel.fromEntity(updatedInventory).toJson()]),
      ));
      expect(result, const Right(true));
    });

    test('should return StorageFailure when inventory is not found', () async {
      when(mockSharedPreferences.getString(tStorageKey))
          .thenReturn(json.encode([]));

      final result = await repository.updateInventory(tInventory);

      expect(result, Left(StorageFailure("Inventario no encontrado")));
    });
  });
}
