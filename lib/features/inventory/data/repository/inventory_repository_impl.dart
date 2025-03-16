import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/data/models/inventory_model.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  static const String _storageKey = "inventories";
  final SharedPreferences sharedPreferences;

  InventoryRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, bool>> addInventory(Inventory inventory) async {
    final result = await getInventories();

    return result.fold(
      (failure) => Left(failure),
      (inventories) async {
        final updatedList = List<InventoryModel>.from(
            inventories.map((inv) => InventoryModel.fromEntity(inv)))
          ..add(InventoryModel.fromEntity(inventory)); // 🔹 Conversión correcta

        String jsonString =
            json.encode(updatedList.map((i) => i.toJson()).toList());
        final success =
            await sharedPreferences.setString(_storageKey, jsonString);

        return success
            ? const Right(true)
            : Left(StorageFailure("Error al guardar el inventario"));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteInventory(String id) async {
    try {
      List<Inventory> inventories =
          (await getInventories()).getOrElse(() => []);

      inventories.removeWhere((i) => i.id == id);

      String jsonString = json.encode(
          inventories.map((i) => (i as InventoryModel).toJson()).toList());

      await sharedPreferences.setString(_storageKey, jsonString);
      return Right(true);
    } catch (e) {
      return Left(
          StorageFailure("Error al eliminar inventario: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Inventory>>> getInventories() async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);

      if (jsonString == null) return Right([]);

      List<dynamic> jsonList = json.decode(jsonString);
      final List<Inventory> inventories =
          jsonList.map((json) => InventoryModel.fromJson(json)).toList();
      return Right(inventories);
    } catch (e) {
      return Left(
          StorageFailure("Error al obtener inventarios: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Inventory>> getInventory(String id) async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);

      if (jsonString == null) {
        return Left(StorageFailure("No hay inventarios guardados"));
      }

      List<dynamic> jsonList = json.decode(jsonString);
      List<InventoryModel> inventories =
          jsonList.map((json) => InventoryModel.fromJson(json)).toList();

      final inventory = inventories.firstWhere(
        (inv) => inv.id == id,
        orElse: () => InventoryModel(id: "", name: ""),
      );

      if (inventory.id.isEmpty) {
        return Left(StorageFailure("Inventario con ID $id no encontrado"));
      }

      return Right(inventory);
    } catch (e) {
      return Left(StorageFailure(
          "Error al obtener inventario por ID: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateInventory(Inventory inventory) async {
    try {
      List<Inventory> inventories =
          (await getInventories()).getOrElse(() => []);

      int index = inventories.indexWhere((i) => i.id == inventory.id);
      if (index != -1) {
        inventories[index] = InventoryModel.fromEntity(inventory);

        String jsonString =
            json.encode(inventories.map((i) => i.toJson()).toList());

        await sharedPreferences.setString(_storageKey, jsonString);
        return Right(true);
      } else {
        return Left(StorageFailure("Inventario no encontrado"));
      }
    } catch (e) {
      return Left(
          StorageFailure("Error al actualizar inventario: ${e.toString()}"));
    }
  }
}
