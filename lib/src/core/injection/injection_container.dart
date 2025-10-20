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
import '../domain/usercases/employees/add_employee_usecase.dart';
import '../domain/usercases/employees/update_employee_usecase.dart';
import '../domain/usercases/employees/delete_employee_usecase.dart';
import '../../features/employees/presentation/bloc/employees_bloc.dart';
import '../../features/sales/presentation/bloc/sales_bloc.dart';
import '../../features/transfers/data/datasources/transfers_local_datasource.dart';
import '../../features/transfers/data/datasources/transfers_remote_datasource.dart';
import '../data/repositories/imp/transfers_repository_impl.dart';
import '../domain/repositories/transfers_repository.dart';
import '../domain/usercases/transfers/get_transfers_usecase.dart';
import '../domain/usercases/transfers/create_transfer_usecase.dart';
import '../../features/transfers/presentation/bloc/transfers_bloc.dart';
import '../../features/purchases/data/datasources/purchases_local_datasource.dart';
import '../../features/purchases/data/datasources/purchases_remote_datasource.dart';
import '../data/repositories/imp/purchases_repository_impl.dart';
import '../domain/repositories/purchases_repository.dart';
import '../domain/usercases/purchases/get_purchases_usecase.dart';
import '../domain/usercases/purchases/create_purchase_usecase.dart';
import '../../features/purchases/presentation/bloc/purchases_bloc.dart';
import '../data/repositories/imp/reports_repository_impl.dart';
import '../domain/repositories/reports_repository.dart';
import '../domain/usercases/reports/generate_sales_report_usecase.dart';
import '../domain/usercases/reports/generate_purchases_report_usecase.dart';
import '../domain/usercases/reports/generate_transfers_report_usecase.dart';
import '../domain/usercases/reports/generate_daily_sales_report_usecase.dart';
import '../domain/usercases/reports/get_report_history_usecase.dart';
import '../../features/reports/presentation/bloc/reports_bloc.dart';

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
  getIt.registerFactory(
    () => InventoryBloc(
      getInventoryUseCase: getIt(),
      addProductUseCase: getIt(),
      updateProductUseCase: getIt(),
      deleteProductUseCase: getIt(),
    ),
  );

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
  getIt.registerFactory(
    () => StoresBloc(
      getStoresUseCase: getIt(),
      addStoreUseCase: getIt(),
      updateStoreUseCase: getIt(),
      deleteStoreUseCase: getIt(),
    ),
  );

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
  getIt.registerSingleton<UpdateWarehouseUseCase>(
    UpdateWarehouseUseCase(getIt()),
  );
  getIt.registerSingleton<DeleteWarehouseUseCase>(
    DeleteWarehouseUseCase(getIt()),
  );
  getIt.registerFactory(
    () => WarehousesBloc(
      getWarehousesUseCase: getIt(),
      addWarehouseUseCase: getIt(),
      updateWarehouseUseCase: getIt(),
      deleteWarehouseUseCase: getIt(),
    ),
  );

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
  getIt.registerSingleton<AddEmployeeUseCase>(AddEmployeeUseCase(getIt()));
  getIt.registerSingleton<UpdateEmployeeUseCase>(
    UpdateEmployeeUseCase(getIt()),
  );
  getIt.registerSingleton<DeleteEmployeeUseCase>(
    DeleteEmployeeUseCase(getIt()),
  );
  getIt.registerFactory(
    () => EmployeesBloc(
      getEmployeesUseCase: getIt(),
      addEmployeeUseCase: getIt(),
      updateEmployeeUseCase: getIt(),
      deleteEmployeeUseCase: getIt(),
    ),
  );

  // Sales
  getIt.registerSingleton<SalesLocalDataSource>(SalesLocalDataSource(getIt()));
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
  getIt.registerFactory(
    () => SalesBloc(getSalesUseCase: getIt(), createSaleUseCase: getIt()),
  );

  // Transfers
  getIt.registerSingleton<TransfersLocalDataSource>(
    TransfersLocalDataSource(getIt()),
  );
  getIt.registerSingleton<TransfersRemoteDataSource>(
    TransfersRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<TransfersRepository>(
    TransfersRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetTransfersUseCase>(GetTransfersUseCase(getIt()));
  getIt.registerSingleton<CreateTransferUseCase>(
    CreateTransferUseCase(getIt()),
  );
  getIt.registerFactory(
    () => TransfersBloc(
      getTransfersUseCase: getIt(),
      createTransferUseCase: getIt(),
    ),
  );

  // Purchases
  getIt.registerSingleton<PurchasesLocalDataSource>(
    PurchasesLocalDataSource(getIt()),
  );
  getIt.registerSingleton<PurchasesRemoteDataSource>(
    PurchasesRemoteDataSource(getIt()),
  );
  getIt.registerSingleton<PurchasesRepository>(
    PurchasesRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: getIt(),
      syncService: getIt(),
    ),
  );
  getIt.registerSingleton<GetPurchasesUseCase>(GetPurchasesUseCase(getIt()));
  getIt.registerSingleton<CreatePurchaseUseCase>(
    CreatePurchaseUseCase(getIt()),
  );
  getIt.registerFactory(
    () => PurchasesBloc(
      getPurchasesUseCase: getIt(),
      createPurchaseUseCase: getIt(),
    ),
  );

  // Reports
  getIt.registerSingleton<ReportsRepository>(
    ReportsRepositoryImpl(
      salesRepository: getIt(),
      purchasesRepository: getIt(),
      transfersRepository: getIt(),
    ),
  );
  getIt.registerSingleton<GenerateSalesReportUseCase>(
    GenerateSalesReportUseCase(getIt()),
  );
  getIt.registerSingleton<GeneratePurchasesReportUseCase>(
    GeneratePurchasesReportUseCase(getIt()),
  );
  getIt.registerSingleton<GenerateTransfersReportUseCase>(
    GenerateTransfersReportUseCase(getIt()),
  );
  getIt.registerSingleton<GenerateDailySalesReportUseCase>(
    GenerateDailySalesReportUseCase(getIt()),
  );
  getIt.registerSingleton<GetReportHistoryUseCase>(
    GetReportHistoryUseCase(getIt()),
  );
  getIt.registerFactory(
    () => ReportsBloc(
      generateSalesReportUseCase: getIt(),
      generatePurchasesReportUseCase: getIt(),
      generateTransfersReportUseCase: getIt(),
      generateDailySalesReportUseCase: getIt(),
      getReportHistoryUseCase: getIt(),
    ),
  );
}
