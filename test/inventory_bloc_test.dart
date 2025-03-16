import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventaries.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_inventary.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_inventory.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_state.dart';

import 'inventory_bloc_test.mocks.dart';

@GenerateMocks([
  GetInventaryUseCase,
  AddInventoryUseCase,
  DeleteInventoryUseCase,
  GetInventariesUseCase,
  UpdateInventoryUseCase,
  DeleteProductsByInventoryUseCase,
])
void main() {
  late InventoryBloc inventoryBloc;
  late MockGetInventaryUseCase mockGetInventaryUseCase;
  late MockUpdateInventoryUseCase mockUpdateInventoryUseCase;
  late MockAddInventoryUseCase mockAddInventoryUseCase;
  late MockDeleteProductsByInventoryUseCase
      mockDeleteProductsByInventoryUseCase;
  late MockGetInventariesUseCase mockGetInventariesUseCase;
  late MockDeleteInventoryUseCase mockDeleteInventoryUseCase;

  setUp(() {
    mockGetInventaryUseCase = MockGetInventaryUseCase();
    mockDeleteInventoryUseCase = MockDeleteInventoryUseCase();
    mockUpdateInventoryUseCase = MockUpdateInventoryUseCase();
    mockAddInventoryUseCase = MockAddInventoryUseCase();
    mockDeleteProductsByInventoryUseCase =
        MockDeleteProductsByInventoryUseCase();
    mockGetInventariesUseCase = MockGetInventariesUseCase();

    inventoryBloc = InventoryBloc(
      mockAddInventoryUseCase,
      mockDeleteInventoryUseCase,
      mockGetInventariesUseCase,
      mockGetInventaryUseCase,
      mockUpdateInventoryUseCase,
      mockDeleteProductsByInventoryUseCase,
    );
  });

  tearDown(() {
    inventoryBloc.close();
  });

  group('SearchInventary', () {
    const tInventoryId = "1";
    final tInventory =
        Inventory(id: tInventoryId.toString(), name: 'Test Inventory');

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventarySearch] when GetInventaryUseCase succeeds',
      build: () {
        when(mockGetInventaryUseCase(tInventoryId))
            .thenAnswer((_) async => Right(tInventory));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(SearchInventary(tInventoryId)),
      expect: () => [isA<InventarySearch>()],
    );
  });

  group('UpdateInventory', () {
    final tInventory = Inventory(id: "1", name: "Updated Inventory");

    blocTest<InventoryBloc, InventoryState>(
      'does not emit new states when UpdateInventoryUseCase succeeds',
      build: () {
        when(mockUpdateInventoryUseCase(tInventory))
            .thenAnswer((_) async => const Right(true));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(UpdateInventory(tInventory)),
      expect: () => [],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryError] when UpdateInventoryUseCase fails',
      build: () {
        when(mockUpdateInventoryUseCase(tInventory)).thenAnswer(
            (_) async => Left(ServerFailure("Failed to update inventory")));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(UpdateInventory(tInventory)),
      expect: () => [isA<InventoryError>()],
    );
  });

  group('DeleteInventory', () {
    const tInventoryId = "1";

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryLoaded] when DeleteInventoryUseCase and DeleteProductsByInventoryUseCase succeed',
      build: () {
        when(mockDeleteInventoryUseCase(tInventoryId))
            .thenAnswer((_) async => const Right(true));
        when(mockDeleteProductsByInventoryUseCase(tInventoryId))
            .thenAnswer((_) async => const Right(true));
        when(mockGetInventariesUseCase())
            .thenAnswer((_) async => const Right([]));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(DeleteInventory(tInventoryId)),
      expect: () => [isA<InventoryLoading>(), isA<InventoryLoaded>()],
    );
  });

  group('LoadInventories', () {
    final tInventories = [
      Inventory(id: "1", name: "Inventory 1"),
      Inventory(id: "2", name: "Inventory 2"),
    ];

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryLoaded] when GetInventariesUseCase succeeds',
      build: () {
        when(mockGetInventariesUseCase())
            .thenAnswer((_) async => Right(tInventories));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(LoadInventories()),
      expect: () => [isA<InventoryLoading>(), isA<InventoryLoaded>()],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryError] when GetInventariesUseCase fails',
      build: () {
        when(mockGetInventariesUseCase()).thenAnswer(
            (_) async => Left(ServerFailure("Failed to load inventories")));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(LoadInventories()),
      expect: () => [isA<InventoryLoading>(), isA<InventoryError>()],
    );
  });
}
