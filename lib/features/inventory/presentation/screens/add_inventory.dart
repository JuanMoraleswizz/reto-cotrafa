import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/core/router/routes.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:uuid/uuid.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  _AddInventoryPageState createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final uuid = Uuid();

  @override
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
      appBar: AppBar(title: Text("Agregar Inventario")),
      body: _buildForm(),
    );
  }

  Widget _buildDesktopView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Inventario"),
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
                onPressed: () => context.go(Routes.inventories),
                child: Text("Cancelar"),
              ),
              SizedBox(),
              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    final newInventory = Inventory(id: uuid.v4(), name: name);
                    context
                        .read<InventoryBloc>()
                        .add(AddInventory(newInventory));
                    context.go(Routes.inventories);
                  }
                },
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
