import 'package:get_it/get_it.dart';
import 'package:reto_cotrafa/features/inventory/data/repository/inventory_repository_impl.dart';
import 'package:reto_cotrafa/features/inventory/data/repository/product_repository_impl.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/inventory_repository.dart';
import 'package:reto_cotrafa/features/inventory/domain/repository/product_repository.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventaries.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventary.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_products.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dependencieInyection = GetIt.instance;

Future<void> Init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  dependencieInyection.registerSingleton<SharedPreferences>(sharedPreferences);

  // Bloc
  dependencieInyection.registerFactory(
    () => ProductBloc(
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
    ),
  );

  // Use cases
  dependencieInyection.registerLazySingleton(
      () => AddProductUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => UpdateProductUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => DeleteProductUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => GetProductUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => GetProductsUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(() =>
      GetProductsByInventoryUseCase(productRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(() =>
      DeleteProductsByInventoryUseCase(
          productRepository: dependencieInyection()));

  // Repository
  dependencieInyection.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sharedPreferences: dependencieInyection()),
  );

// Bloc
  dependencieInyection.registerFactory(
    () => InventoryBloc(
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
      dependencieInyection(),
    ),
  );

  // Use cases
  dependencieInyection.registerLazySingleton(
      () => AddInventoryUseCase(inventoryRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(() =>
      UpdateInventoryUseCase(inventoryRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(() =>
      DeleteInventoryUseCase(inventoryRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => GetInventaryUseCase(inventoryRepository: dependencieInyection()));
  dependencieInyection.registerLazySingleton(
      () => GetInventariesUseCase(inventoryRepository: dependencieInyection()));

  // Repository
  dependencieInyection.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(sharedPreferences: dependencieInyection()),
  );
}
