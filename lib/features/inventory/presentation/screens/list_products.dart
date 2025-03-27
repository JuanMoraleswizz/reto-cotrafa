import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
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
      body: LayoutBuilder(builder: (context, constraints) {
        return BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products
                  .where((p) => p.inventoryId == widget.inventoryId)
                  .toList();

              if (products.isEmpty) {
                return Center(
                    child: Text("No hay productos en este inventario"));
              }

              return constraints.maxWidth > 600
                  ? _buildDesktopView(state.products)
                  : _buildMobileview(products, widget.inventoryId);
            } else if (state is ProductError) {
              return Center(child: Text("Error: ${state.failure.message}"));
            }
            return Center(child: Text("Cargando productos..."));
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Agregar Producto"),
        icon: Icon(Icons.add),
        onPressed: () => context.go('/add-product/${widget.inventoryId}'),
      ),
      drawer: MenuComponent(),
    );
  }

  Widget _buildMobileview(List<Product> products, String inventoryId) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        context.read<ProductBloc>().add(
                            LoadProducts(inventoryId: product.inventoryId));
                      }
                    },
                  ),
                ),
                Tooltip(
                  message: "Eliminar producto",
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(product);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopView(List<Product> products) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.95,
        child: Card(
          elevation: 4,
          margin: EdgeInsets.only(top: 20, left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: DataTable(
                      columnSpacing: constraints.maxWidth * 0.05,
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(
                          label: Expanded(
                            child: Text('Nombre',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        DataColumn(label: Text('Cantidad'), numeric: true),
                        DataColumn(label: Text('Precio'), numeric: true),
                        DataColumn(label: Text('Acciones'), numeric: true),
                      ],
                      rows: products.map((product) {
                        return DataRow(cells: [
                          DataCell(Text(product.id,
                              overflow: TextOverflow.ellipsis)),
                          DataCell(
                            SizedBox(
                              width: constraints.maxWidth *
                                  0.3, // Nombre más ancho
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          DataCell(Text(product.quantity.toString(),
                              textAlign: TextAlign.center)),
                          DataCell(Text('\$${product.price}',
                              textAlign: TextAlign.center)),
                          DataCell(
                            SizedBox(
                              width:
                                  130, // Fija el ancho de la celda de acciones
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Spacer(), // Empuja los botones a la derecha
                                    Tooltip(
                                      message: "Editar Producto",
                                      child: IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductPage(
                                                      product: product),
                                            ),
                                          );
                                          if (result == true) {
                                            context.read<ProductBloc>().add(
                                                  LoadProducts(
                                                      inventoryId:
                                                          product.inventoryId),
                                                );
                                          }
                                        },
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Eliminar producto",
                                      child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _confirmDelete(product);
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
              },
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text(
              "¿Estás seguro de que deseas eliminar este producto? Esta acción no se puede deshacer."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(), // Cerrar el diálogo
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<ProductBloc>()
                    .add(DeleteProduct(product.id, product.inventoryId));
                context.pop(); // Cierra el diálogo
                context.pop(); // Vuelve a la lista de productos
              },
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
