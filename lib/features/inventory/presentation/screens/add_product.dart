import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  final String inventoryId;

  const AddProductPage({super.key, required this.inventoryId});

  @override
  _AddProductPageState createState() => _AddProductPageState(inventoryId);
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final String inventaryId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  _AddProductPageState(this.inventaryId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Producto")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildDesktopView();
          } else {
            return _buildMobileView();
          }
        },
      ),
    );
  }

  Widget _buildMobileView() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: _buildForm(),
    );
  }

  Widget _buildDesktopView() {
    return Align(
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
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Nombre del Producto"),
            validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
          ),
          TextFormField(
            controller: _barcodeController,
            decoration: InputDecoration(labelText: "Código de Barras"),
          ),
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(labelText: "Precio"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _quantityController,
            decoration: InputDecoration(labelText: "Cantidad"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newProduct = Product(
                  id: Uuid().v4(),
                  inventoryId: widget.inventoryId,
                  name: _nameController.text,
                  barcode: _barcodeController.text,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                );

                context.read<ProductBloc>().add(AddProduct(newProduct));
                context.go('/products/${widget.inventoryId}');
              }
            },
            child: Text("Guardar Producto"),
          ),
        ],
      ),
    );
  }
}
