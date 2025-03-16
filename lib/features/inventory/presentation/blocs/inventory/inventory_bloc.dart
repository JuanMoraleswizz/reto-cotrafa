import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventaries.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventary.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final AddInventoryUseCase _addInventoryUseCase;
  final DeleteInventoryUseCase _deleteInventoryUseCase;
  final GetInventariesUseCase _getInventariesUseCase;
  final GetInventaryUseCase _getInventaryUseCase;
  final UpdateInventoryUseCase _updateInventoryUseCase;
  final DeleteProductsByInventoryUseCase _deleteProductByInventory;

  InventoryBloc(
      this._addInventoryUseCase,
      this._deleteInventoryUseCase,
      this._getInventariesUseCase,
      this._getInventaryUseCase,
      this._updateInventoryUseCase,
      this._deleteProductByInventory)
      : super(InventoryInitial()) {
    on<LoadInventories>((event, emit) async {
      emit(InventoryLoading());

      final inventories = await _getInventariesUseCase();
      inventories.fold((f) => emit(InventoryError(failure: f)),
          (p) => emit(InventoryLoaded(inventories: p)));
    });

    on<SearchInventary>((event, emit) async {
      final response = await _getInventaryUseCase(event.id);
      response.fold((f) => emit(InventoryError(failure: f)),
          (p) => emit(InventarySearch(inventory: p)));
    });

    on<AddInventory>((event, emit) async {
      final response = await _addInventoryUseCase(event.inventory);

      response.fold((f) => emit(InventoryError(failure: f)), (p) {});
    });

    on<UpdateInventory>((event, emit) async {
      final response = await _updateInventoryUseCase(event.inventory);
      response.fold((f) => emit(InventoryError(failure: f)), (p) {});
    });

    on<DeleteInventory>((event, emit) async {
      emit(InventoryLoading());
      await _deleteInventoryUseCase(event.id);
      await _deleteProductByInventory(event.id);
      final inventories = await _getInventariesUseCase();
      inventories.fold((f) => emit(InventoryError(failure: f)),
          (p) => emit(InventoryLoaded(inventories: p)));
    });
  }
}
