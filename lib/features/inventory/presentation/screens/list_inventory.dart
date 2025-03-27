import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/edit_inventory.dart';
import '../blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_state.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is InventoryLoaded) {
                return constraints.maxWidth > 600
                    ? _buildDesktopView(state.inventories)
                    : _buildMobileView(state.inventories);
              } else if (state is InventoryError) {
                return Center(child: Text("Error: ${state.failure.message}"));
              }
              return const Center(
                  child: Text("No hay inventarios disponibles"));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.go(Routes.addInventory), // 🔹 Agregar inventario
        icon: const Icon(Icons.add),
        label: Text("Agregar Inventario"),
      ),
      drawer: MenuComponent(),
    );
  }

  Widget _buildMobileView(List<Inventory> inventories) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: inventories.length,
      itemBuilder: (context, index) {
        final inventory = inventories[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(inventory.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
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
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, inventory.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopView(List<Inventory> inventories) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.50,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: DataTable(
                    columnSpacing: constraints.maxWidth * 0.05,
                    columns: [
                      DataColumn(
                          label: Expanded(
                        child: Text("Nombre",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      DataColumn(
                          label: Text("Acciones",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          numeric: true),
                    ],
                    rows: inventories.map((inventory) {
                      return DataRow(cells: [
                        DataCell(Text(inventory.name)),
                        DataCell(
                          SizedBox(
                            width: 130,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Spacer(),
                                  Tooltip(
                                    message: "Ver productos del inventario",
                                    child: IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: Colors.black),
                                        onPressed: () => context
                                            .go('/products/${inventory.id}')),
                                  ),
                                  Tooltip(
                                    message: "Editar Inventario",
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditInventoryPage(
                                                    inventory: inventory),
                                          ),
                                        );

                                        if (result == true) {
                                          context.read<InventoryBloc>().add(
                                              LoadInventories()); // Recargar lista
                                        }
                                      },
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Eliminar Inventario",
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _confirmDelete(context, inventory.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String inventoryId) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Seguro que quieres eliminar este inventario?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                context.read<InventoryBloc>().add(DeleteInventory(inventoryId));
                Navigator.of(ctx).pop();
              },
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
