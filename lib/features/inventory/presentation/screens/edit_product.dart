import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/widgets/menu_component.dart';

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

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = widget.product.copyWith(
        name: _nameController.text,
        barcode: _barcodeController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        quantity: int.tryParse(_quantityController.text) ?? 0,
      );

      // Enviar el evento al Bloc
      context.read<ProductBloc>().add(UpdateProduct(updatedProduct));
      context
          .read<ProductBloc>()
          .add(LoadProducts(inventoryId: widget.product.inventoryId));

      // Volver atrás después de guardar
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) =>
                    value!.isEmpty ? "El nombre es obligatorio" : null,
              ),
              TextFormField(
                controller: _barcodeController,
                decoration:
                    const InputDecoration(labelText: "Código de barras"),
                validator: (value) => value!.isEmpty
                    ? "El código de barras es obligatorio"
                    : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Precio"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "El precio es obligatorio" : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "Cantidad"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "La cantidad es obligatoria" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text("Guardar Cambios"),
              ),
            ],
          ),
        ),
      ),
      drawer: MenuComponent(),
    );
  }
}
