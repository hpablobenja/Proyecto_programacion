import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/local/app_database.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usercases/auth/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/inventory/data/datasources/inventory_local_datasource.dart';
import '../../features/inventory/data/datasources/inventory_remote_datasource.dart';
import '../data/repositories/imp/inventory_repository_impl.dart';
import '../domain/repositories/inventory_repository.dart';
import '../domain/usercases/inventory/get_inventory_usecase.dart';
import '../domain/usercases/inventory/add_product_usecase.dart';
import '../domain/usercases/inventory/update_product_usecase.dart';
import '../domain/usercases/inventory/delete_product_usecase.dart';
import '../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../features/stores/data/datasources/stores_local_datasource.dart';
import '../../features/stores/data/datasources/stores_remote_datasource.dart';
import '../data/repositories/imp/stores_repository_impl.dart';
import '../domain/repositories/stores_repository.dart';
import '../domain/usercases/stores/get_stores_usecase.dart';
import '../domain/usercases/stores/add_store_usecase.dart';
import '../domain/usercases/stores/update_store_usecase.dart';
import '../domain/usercases/stores/delete_store_usecase.dart';
import '../../features/stores/presentation/bloc/stores_bloc.dart';
import '../../features/warehouses/data/datasources/warehouses_local_datasource.dart';
import '../../features/warehouses/data/datasources/warehouses_remote_datasource.dart';
import '../data/repositories/imp/warehouses_repository_impl.dart';
import '../domain/repositories/warehouses_repository.dart';
import '../domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../domain/usercases/warehouses/add_warehouse_usecase.dart';
import '../domain/usercases/warehouses/update_warehouse_usecase.dart';
import '../domain/usercases/warehouses/delete_warehouse_usecase.dart';
import '../../features/warehouses/presentation/bloc/warehouses_bloc.dart';
import '../../features/employees/data/datasources/employees_local_datasource.dart';
import '../../features/employees/data/datasources/employees_remote_datasource.dart';
import '../../features/sales/data/datasources/sales_local_datasource.dart';
import '../../features/sales/data/datasources/sales_remote_datasource.dart';
import '../data/repositories/imp/sales_repository_impl.dart';
import '../domain/repositories/sales_repository.dart';
import '../domain/repositories/employees_repository.dart';
import '../data/repositories/imp/employees_repository_impl.dart';
import '../domain/usercases/sales/get_sales_usecase.dart';
import '../domain/usercases/sales/create_sale_usecase.dart';
import '../domain/usercases/employees/get_employees_usecase.dart';
import '../../features/sales/presentation/bloc/sales_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<ConnectivityService>(ConnectivityService());
  getIt.registerSingleton<AuthService>(AuthService(getIt()));
  getIt.registerSingleton<SyncService>(
    SyncService(
      supabaseClient: getIt(),
      appDatabase: getIt(),
      connectivityService: getIt(),
    ),
  );

  // Auth
  getIt.registerSingleton<AuthLocalDataSource>(AuthLocalDataSource(getIt()));
  getIt.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSource(getIt()));
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: getIt(), localDataSource: getIt()),
  );
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt()));
  getIt.registerFactory(() => AuthBloc(loginUseCase: getIt()));

  // Inventory
  getIt.registerSingleton<InventoryLocalDataSource>(
    InventoryLocalDataSource(getIt()),
  );
  getIt.registerSingleton<InventoryRemoteDataSource>(
    InventoryRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<InventoryRepository>(
    InventoryRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetInventoryUseCase>(GetInventoryUseCase(getIt()));
  getIt.registerSingleton<AddProductUseCase>(AddProductUseCase(getIt()));
  getIt.registerSingleton<UpdateProductUseCase>(UpdateProductUseCase(getIt()));
  getIt.registerSingleton<DeleteProductUseCase>(DeleteProductUseCase(getIt()));
  getIt.registerFactory(() => InventoryBloc(
        getInventoryUseCase: getIt(),
        addProductUseCase: getIt(),
        updateProductUseCase: getIt(),
        deleteProductUseCase: getIt(),
      ));

  // Stores
  getIt.registerSingleton<StoresLocalDataSource>(
    StoresLocalDataSource(getIt()),
  );
  getIt.registerSingleton<StoresRemoteDataSource>(
    StoresRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<StoresRepository>(
    StoresRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetStoresUseCase>(GetStoresUseCase(getIt()));
  getIt.registerSingleton<AddStoreUseCase>(AddStoreUseCase(getIt()));
  getIt.registerSingleton<UpdateStoreUseCase>(UpdateStoreUseCase(getIt()));
  getIt.registerSingleton<DeleteStoreUseCase>(DeleteStoreUseCase(getIt()));
  getIt.registerFactory(() => StoresBloc(
        getStoresUseCase: getIt(),
        addStoreUseCase: getIt(),
        updateStoreUseCase: getIt(),
        deleteStoreUseCase: getIt(),
      ));

  // Warehouses
  getIt.registerSingleton<WarehousesLocalDataSource>(
    WarehousesLocalDataSource(getIt()),
  );
  getIt.registerSingleton<WarehousesRemoteDataSource>(
    WarehousesRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<WarehousesRepository>(
    WarehousesRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetWarehousesUseCase>(GetWarehousesUseCase(getIt()));
  getIt.registerSingleton<AddWarehouseUseCase>(AddWarehouseUseCase(getIt()));
  getIt.registerSingleton<UpdateWarehouseUseCase>(UpdateWarehouseUseCase(getIt()));
  getIt.registerSingleton<DeleteWarehouseUseCase>(DeleteWarehouseUseCase(getIt()));
  getIt.registerFactory(() => WarehousesBloc(
        getWarehousesUseCase: getIt(),
        addWarehouseUseCase: getIt(),
        updateWarehouseUseCase: getIt(),
        deleteWarehouseUseCase: getIt(),
      ));
      
  // Employees
  getIt.registerSingleton<EmployeesLocalDataSource>(
    EmployeesLocalDataSource(getIt()),
  );
  getIt.registerSingleton<EmployeesRemoteDataSource>(
    EmployeesRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<EmployeesRepository>(
    EmployeesRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetEmployeesUseCase>(GetEmployeesUseCase(getIt()));

  // Sales
  getIt.registerSingleton<SalesLocalDataSource>(
    SalesLocalDataSource(getIt()),
  );
  getIt.registerSingleton<SalesRemoteDataSource>(
    SalesRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<SalesRepository>(
    SalesRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetSalesUseCase>(GetSalesUseCase(getIt()));
  getIt.registerSingleton<CreateSaleUseCase>(CreateSaleUseCase(getIt()));
  getIt.registerFactory(() => SalesBloc(
        getSalesUseCase: getIt(),
        createSaleUseCase: getIt(),
      ));
}
