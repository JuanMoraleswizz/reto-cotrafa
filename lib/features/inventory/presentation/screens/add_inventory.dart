import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/widgets/menu_component.dart';
import 'package:uuid/uuid.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Inventario")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nombre del Inventario"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  final newInventory = Inventory(id: uuid.v4(), name: name);
                  context.read<InventoryBloc>().add(AddInventory(newInventory));
                  context.go(Routes.inventories); // Volver atrás
                }
              },
              child: Text("Guardar"),
            )
          ],
        ),
      ),
      drawer: MenuComponent(),
    );
  }
}
