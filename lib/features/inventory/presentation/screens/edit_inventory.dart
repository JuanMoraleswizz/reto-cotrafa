import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  final _formKey = GlobalKey<FormState>();
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

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildDesktopView();
        } else {
          return _buildMobileView();
        }
      },
    );
  }

  Widget _buildMobileView() {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Inventario")),
      body: _buildForm(),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Inventario"),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(top: 50),
            child: Container(
              width: 500,
              padding: EdgeInsets.all(24),
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nombre del Inventario"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Este campo es obligatorio";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade200),
                onPressed: () => context.pop(),
                child: Text("Cancelar"),
              ),
              SizedBox(),
              ElevatedButton(
                onPressed: _saveInventory,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200),
                child: Text("Guardar"),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
