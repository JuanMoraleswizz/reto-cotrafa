import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final GetProductUseCase _getProductUseCase;
  final GetProductsByInventoryUseCase _getProductsUseCase;

  ProductBloc(
      this._addProductUseCase,
      this._updateProductUseCase,
      this._deleteProductUseCase,
      this._getProductUseCase,
      this._getProductsUseCase)
      : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());

      final response = await _getProductsUseCase(event.inventoryId);
      response.fold((f) => emit(ProductError(failure: f)),
          (p) => emit(ProductLoaded(products: p)));
    });

    on<SearchProduct>((event, emit) async {
      final response = await _getProductUseCase(event.id);
      response.fold((f) => emit(ProductError(failure: f)),
          (p) => emit(ProductSearch(product: p)));
    });

    on<AddProduct>((event, emit) async {
      final response = await _addProductUseCase(event.product);

      response.fold((f) => emit(ProductError(failure: f)), (p) {});
    });

    on<UpdateProduct>((event, emit) async {
      final response = await _updateProductUseCase(event.product);
      response.fold((f) => emit(ProductError(failure: f)), (p) {});
    });

    on<DeleteProduct>((event, emit) async {
      emit(ProductLoading());
      await _deleteProductUseCase(event.id);

      final response = await _getProductsUseCase(event.inventoryId);
      response.fold((f) => emit(ProductError(failure: f)),
          (p) => emit(ProductLoaded(products: p)));
    });
  }
}
