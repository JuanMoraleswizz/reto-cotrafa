import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_state.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/edit_inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/widgets/menu_component.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(LoadInventories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventarios")),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoaded) {
            return _buildInventoryList(state.inventories);
          } else if (state is InventoryError) {
            return Center(child: Text("Error: ${state.failure.message}"));
          }
          return const Center(child: Text("No hay inventarios disponibles"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.go(Routes.addInventory), // 🔹 Agregar inventario
        child: const Icon(Icons.add),
      ),
      drawer: MenuComponent(),
    );
  }

  /// Construye la lista de inventarios
  Widget _buildInventoryList(List<Inventory> inventories) {
    return ListView.builder(
      itemCount: inventories.length,
      itemBuilder: (context, index) {
        final inventory = inventories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(inventory.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: "Ver productos del inventario",
                  child: IconButton(
                      icon: const Icon(Icons.remove_red_eye_sharp,
                          color: Colors.black),
                      onPressed: () => context.go('/products/${inventory.id}')),
                ),
                Tooltip(
                  message: "Editar inventario",
                  child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditInventoryPage(inventory: inventory),
                          ),
                        );

                        if (result == true) {
                          context
                              .read<InventoryBloc>()
                              .add(LoadInventories()); // Recargar lista
                        }
                      }),
                ),
                Tooltip(
                  message: "Eliminar inventario",
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => context
                        .read<InventoryBloc>()
                        .add(DeleteInventory(inventory.id)),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
