import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';

class EditInventoryPage extends StatefulWidget {
  final Inventory inventory;

  const EditInventoryPage({super.key, required this.inventory});

  @override
  _EditInventoryPageState createState() => _EditInventoryPageState();
}

class _EditInventoryPageState extends State<EditInventoryPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.inventory.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveInventory() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("El nombre del inventario no puede estar vacío")),
      );
      return;
    }

    final updatedInventory =
        widget.inventory.copyWith(name: _nameController.text.trim());

    context.read<InventoryBloc>().add(UpdateInventory(updatedInventory));
    context.read<InventoryBloc>().add(LoadInventories());
    Navigator.pop(
        context, true); // Regresamos `true` para indicar que hubo cambios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Inventario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: "Nombre del Inventario"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInventory,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
