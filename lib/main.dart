import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reto_cotrafa/core/router/app_routes.dart';
import 'package:reto_cotrafa/di.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/inventory/inventory_event.dart';
import 'package:reto_cotrafa/features/inventory/presentation/blocs/product/product_bloc.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // 🔹 Necesario para `SharedPreferences`
  await Init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => dependencieInyection<ProductBloc>()),
        BlocProvider(
            create: (context) =>
                dependencieInyection<InventoryBloc>()..add(LoadInventories()))
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: appRouter,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
