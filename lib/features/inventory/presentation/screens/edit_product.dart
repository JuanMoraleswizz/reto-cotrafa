import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _barcodeController = TextEditingController(text: widget.product.barcode);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Producto")),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade200),
                onPressed: () => context.pop(),
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedProduct = widget.product.copyWith(
                      name: _nameController.text,
                      barcode: _barcodeController.text,
                      price: double.tryParse(_priceController.text) ?? 0.0,
                      quantity: int.tryParse(_quantityController.text) ?? 0,
                    );

                    context
                        .read<ProductBloc>()
                        .add(UpdateProduct(updatedProduct));
                    context.pop();
                  }
                },
                child: Text("Guardar Cambios"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
