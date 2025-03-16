import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reto_cotrafa/core/error/failure.dart';
import 'package:reto_cotrafa/features/inventory/domain/entity/product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/add_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/delete_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_product.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/get_products_by_inventory.dart';
import 'package:reto_cotrafa/features/inventory/domain/use_cases/update_product.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_state.dart';

import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  AddProductUseCase,
  UpdateProductUseCase,
  DeleteProductUseCase,
  GetProductUseCase,
  GetProductsByInventoryUseCase,
])
void main() {
  late ProductBloc productBloc;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;
  late MockGetProductUseCase mockGetProductUseCase;
  late MockGetProductsByInventoryUseCase mockGetProductsByInventoryUseCase;

  setUp(() {
    mockAddProductUseCase = MockAddProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    mockGetProductUseCase = MockGetProductUseCase();
    mockGetProductsByInventoryUseCase = MockGetProductsByInventoryUseCase();

    productBloc = ProductBloc(
      mockAddProductUseCase,
      mockUpdateProductUseCase,
      mockDeleteProductUseCase,
      mockGetProductUseCase,
      mockGetProductsByInventoryUseCase,
    );
  });

  group('LoadProducts', () {
    const inventoryId = 'inventory_1';
    final products = [
      Product(
        id: '1',
        name: 'Product 1',
        inventoryId: 'inventory_1',
        barcode: '123456789',
        price: 10.0,
        quantity: 5,
      )
    ];

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoaded] when products are loaded successfully',
      build: () {
        when(mockGetProductsByInventoryUseCase(inventoryId))
            .thenAnswer((_) async => Right(products));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadProducts(inventoryId: inventoryId)),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductLoaded>(),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when loading products fails',
      build: () {
        when(mockGetProductsByInventoryUseCase(inventoryId))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadProducts(inventoryId: inventoryId)),
      expect: () => [
        isA<ProductLoading>(),
        isA<ProductError>(),
      ],
    );
  });

  group('SearchProduct', () {
    const productId = '1';
    final product = Product(
      id: productId,
      name: 'Product 1',
      inventoryId: 'inventory_1',
      barcode: '123456789',
      price: 10.0,
      quantity: 5,
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductError] when searching for product fails',
      build: () {
        when(mockGetProductUseCase(productId))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return productBloc;
      },
      act: (bloc) => bloc.add(SearchProduct(productId)),
      expect: () => [
        isA<ProductError>(),
      ],
    );
  });

  group('AddProduct', () {
    final product = Product(
      id: '1',
      name: 'Product 1',
      inventoryId: 'inventory_1',
      barcode: '123456789',
      price: 10.0,
      quantity: 5,
    );

    blocTest<ProductBloc, ProductState>(
      'does not emit new states when product is added successfully',
      build: () {
        when(mockAddProductUseCase(product))
            .thenAnswer((_) async => Right(true));
        return productBloc;
      },
      act: (bloc) => bloc.add(AddProduct(product)),
      expect: () => [],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductError] when adding product fails',
      build: () {
        when(mockAddProductUseCase(product))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return productBloc;
      },
      act: (bloc) => bloc.add(AddProduct(product)),
      expect: () => [
        isA<ProductError>(),
      ],
    );
  });

  group('UpdateProduct', () {
    final product = Product(
      id: '1',
      name: 'Updated Product',
      inventoryId: 'inventory_1',
      barcode: '123456789',
      price: 20.0,
      quantity: 10,
    );

    blocTest<ProductBloc, ProductState>(
      'does not emit new states when product is updated successfully',
      build: () {
        when(mockUpdateProductUseCase(product))
            .thenAnswer((_) async => Right(true));
        return productBloc;
      },
      act: (bloc) => bloc.add(UpdateProduct(product)),
      expect: () => [],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductError] when updating product fails',
      build: () {
        when(mockUpdateProductUseCase(product))
            .thenAnswer((_) async => Left(ServerFailure('Error')));
        return productBloc;
      },
      act: (bloc) => bloc.add(UpdateProduct(product)),
      expect: () => [
        isA<ProductError>(),
      ],
    );
  });
}
