import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_state.dart';
import 'package:reto_cotrafa/features/inventory/presentation/screens/edit_product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/widgets/menu_component.dart';

class ProductListPage extends StatefulWidget {
  final String inventoryId;

  const ProductListPage({super.key, required this.inventoryId});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(LoadProducts(inventoryId: widget.inventoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productos del Inventario")),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products
                .where((p) => p.inventoryId == widget.inventoryId)
                .toList();

            if (products.isEmpty) {
              return Center(child: Text("No hay productos en este inventario"));
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Nombre: ${product.name}"),
                    subtitle: Text(
                        "Cantidad: ${product.quantity} - Precio: \$${product.price}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: "Editar Producto",
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductPage(product: product),
                                ),
                              );
                              if (result == true) {
                                context.read<ProductBloc>().add(LoadProducts(
                                    inventoryId: product.inventoryId));
                              }
                            },
                          ),
                        ),
                        Tooltip(
                          message: "Eliminar producto",
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<ProductBloc>().add(DeleteProduct(
                                  product.id, widget.inventoryId));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text("Error: ${state.failure.message}"));
          }
          return Center(child: Text("Cargando productos..."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => context.go('/add-product/${widget.inventoryId}'),
      ),
      drawer: MenuComponent(),
    );
  }
}
