import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/data/models/product_model.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepositoryImpl implements ProductRepository {
  static const String _storageKey = "products";
  final SharedPreferences sharedPreferences;

  ProductRepositoryImpl({required this.sharedPreferences});
  @override
  Future<Either<Failure, bool>> addProduct(Product product) async {
    try {
      final result = await getProducts();
      return result.fold(
        (failure) => Left(failure),
        (products) async {
          final newProducts = [...products, ProductModel.fromEntity(product)];
          final jsonString = json.encode(newProducts
              .map((p) => ProductModel.fromEntity(p).toJson())
              .toList());

          await sharedPreferences.setString(_storageKey, jsonString);

          return const Right(true);
        },
      );
    } catch (e) {
      return Left(
          StorageFailure("❌ Error al agregar producto: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);

      if (jsonString == null) {
        return Left(StorageFailure("No hay productos guardados"));
      }

      List<dynamic> jsonList = json.decode(jsonString);
      List<ProductModel> products =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();

      products.removeWhere((p) => p.id == id);

      String updatedJsonString =
          json.encode(products.map((p) => p.toJson()).toList());

      await sharedPreferences.setString(_storageKey, updatedJsonString);
      return Right(true);
    } catch (e) {
      return Left(
          StorageFailure("Error al eliminar producto: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);
      if (jsonString == null) {
        return Left(StorageFailure("No hay inventarios guardados"));
      }

      List<dynamic> jsonList = json.decode(jsonString);
      List<ProductModel> products =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();

      final product = products.firstWhere(
        (inv) => inv.id == id,
        orElse: () => ProductModel(
            id: "",
            name: "",
            inventoryId: '',
            barcode: '',
            price: 0.0,
            quantity: 0), // Devuelve un objeto vacío si no existe
      );

      if (product.id.isEmpty) {
        return Left(StorageFailure("Inventario con ID $id no encontrado"));
      }

      return Right(product);
    } catch (e) {
      return Left(StorageFailure(
          "Error al obtener productos del inventario $id: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);

      if (jsonString == null) return Right([]);

      List<dynamic> jsonList = json.decode(jsonString);
      List<Product> inventories =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();
      return Right(inventories);
    } catch (e) {
      return Left(
          StorageFailure("Error al obtener productos: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(Product product) async {
    try {
      List<Product> products =
          (await getProductsByInventoryId(product.inventoryId))
              .getOrElse(() => []);

      int index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = ProductModel.fromEntity(product);

        String updatedJson =
            json.encode(products.map((p) => p.toJson()).toList());
        await sharedPreferences.setString(_storageKey, updatedJson);
        return Right(true);
      } else {
        return Left(StorageFailure("Producto no encontrado"));
      }
    } catch (e) {
      return Left(
          StorageFailure("Error al actualizar producto: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByInventoryId(
      String inventoryId) async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        return const Right([]);
      }

      List<dynamic> jsonList = json.decode(jsonString);
      List<ProductModel> products =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();

      List<Product> filteredProducts =
          products.where((p) => p.inventoryId == inventoryId).toList();

      return Right(filteredProducts);
    } catch (e) {
      return Left(StorageFailure(
          "Error al obtener productos del inventario $inventoryId: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProductByInventory(
      String inventoryId) async {
    try {
      final String? jsonString = sharedPreferences.getString(_storageKey);

      if (jsonString == null) {
        return Left(StorageFailure("No hay productos guardados"));
      }

      List<dynamic> jsonList = json.decode(jsonString);
      List<ProductModel> products =
          jsonList.map((json) => ProductModel.fromJson(json)).toList();

      List<ProductModel> updatedProducts =
          products.where((p) => p.inventoryId != inventoryId).toList();
      final String updatedJson =
          json.encode(updatedProducts.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(_storageKey, updatedJson);

      return Right(true);
    } catch (e) {
      return Left(StorageFailure(
          "Error al eliminar productos del inventario $inventoryId: ${e.toString()}"));
    }
  }
}
