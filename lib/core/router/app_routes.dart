import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/add_inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/add_product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/list_inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/list_products.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home', // Página inicial
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => InventoryListPage(),
    ),
    GoRoute(
      path: Routes.inventories,
      builder: (context, state) => InventoryListPage(),
    ),
    GoRoute(
      path: Routes.addInventory,
      builder: (context, state) => AddInventoryPage(),
    ),
    GoRoute(
      path: Routes.products,
      builder: (context, state) {
        final inventoryId = state.pathParameters['inventoryId']!;
        return ProductListPage(inventoryId: inventoryId);
      },
    ),
    GoRoute(
      path: Routes.addProduct,
      builder: (context, state) {
        final inventoryId = state.pathParameters['inventoryId']!;
        return AddProductPage(inventoryId: inventoryId);
      },
    ),
    GoRoute(
      path: Routes.editProduct,
      builder: (context, state) {
        final inventoryId = state.pathParameters['product_id']!;
        return AddProductPage(inventoryId: inventoryId);
      },
    ),
    GoRoute(
      path: Routes.editInventory,
      builder: (context, state) {
        final inventoryId = state.pathParameters['inventoryId']!;
        return AddProductPage(inventoryId: inventoryId);
      },
    ),
  ],
);
