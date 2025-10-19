import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/core/config/app_theme.dart';
import 'src/core/injection/injection_container.dart';
import 'src/features/auth/presentation/bloc/auth_bloc.dart';
import 'src/features/auth/presentation/pages/login_page.dart';
import 'src/features/auth/presentation/pages/splash_page.dart';
import 'src/features/auth/presentation/bloc/auth_event.dart';
import 'src/features/inventory/presentation/pages/inventory_page.dart';
import 'src/features/inventory/presentation/pages/product_detail_page.dart';
import 'src/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'src/features/stores/presentation/pages/stores_page.dart';
import 'src/features/stores/presentation/pages/store_detail_page.dart';
import 'src/features/stores/presentation/bloc/stores_bloc.dart';
import 'src/features/warehouses/presentation/pages/warehouses_page.dart';
import 'src/features/warehouses/presentation/pages/warehouse_detail_page.dart';
import 'src/features/warehouses/presentation/bloc/warehouses_bloc.dart';
import 'src/features/home/presentation/pages/home_page.dart';
import 'src/features/sales/presentation/pages/sales_page.dart';
import 'src/features/sales/presentation/bloc/sales_bloc.dart';
import 'src/core/domain/entities/product.dart';
import 'src/core/domain/entities/store.dart';
import 'src/core/domain/entities/warehouse.dart';
import 'src/core/domain/entities/sale.dart';
import 'src/core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print(' Inicializando Supabase...');
    print('URL: ${AppConstants.supabaseUrl}');
    print('AnonKey: ${AppConstants.supabaseAnonKey.substring(0, 20)}...');

    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    print('Supabase inicializado correctamente');

    print('Inicializando dependencias...');
    await initDependencies();
    print('Dependencias inicializadas');

    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error en inicialización: $e');
    print('Stack trace: $stackTrace');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error de inicialización: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckStatusEvent()),
        ),
        BlocProvider(create: (context) => getIt<InventoryBloc>()),
        BlocProvider(create: (context) => getIt<StoresBloc>()),
        BlocProvider(create: (context) => getIt<WarehousesBloc>()),
        BlocProvider(create: (context) => getIt<SalesBloc>()),
      ],
      child: MaterialApp(
        title: 'Inventory Management',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/inventory': (context) => const InventoryPage(),
          '/stores': (context) => const StoresPage(),
          '/warehouses': (context) => const WarehousesPage(),
          '/sales': (context) => const SalesPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/product_detail') {
            final product = settings.arguments as Product?;
            return MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            );
          }
          if (settings.name == '/store_detail') {
            final store = settings.arguments as Store?;
            return MaterialPageRoute(
              builder: (context) => StoreDetailPage(store: store),
            );
          }
          if (settings.name == '/warehouse_detail') {
            final warehouse = settings.arguments as Warehouse?;
            return MaterialPageRoute(
              builder: (context) => WarehouseDetailPage(warehouse: warehouse),
            );
          }
          return null;
        },
      ),
    );
  }
}
