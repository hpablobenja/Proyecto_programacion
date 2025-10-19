# 📋 Guía de Implementación Completa
## Sistema de Gestión de Inventario

---

## ✅ Estado Actual de Implementación

### **YA IMPLEMENTADO:**
- ✅ **Productos (Products)** - CRUD completo funcionando
- ✅ **Autenticación (Auth)** - Login funcional
- ✅ **Base de datos local (SQLite)** - Configurada
- ✅ **Conexión a Supabase** - Funcionando
- ✅ **InventoryBloc** - Con todos los eventos CRUD

### **PARCIALMENTE IMPLEMENTADO:**
- ⚠️ **Warehouses** - Datasource actualizado, falta UI
- ⚠️ **Stores** - Estructura básica, falta implementación completa
- ⚠️ **Employees** - Estructura básica, falta implementación completa
- ⚠️ **Sales, Purchases, Transfers** - Estructura creada, falta lógica

---

## 🚀 Pasos para Completar la Implementación

### **PASO 1: Configurar Supabase (CRÍTICO)**

1. **Ejecuta el script SQL:**
   - Abre `SUPABASE_SETUP.sql`
   - Ve a Supabase Dashboard → SQL Editor
   - Copia y pega todo el contenido
   - Ejecuta el script

2. **Verifica las tablas:**
   Asegúrate de que existan estas tablas en Supabase:
   - `products` ✅
   - `warehouses`
   - `stores`
   - `employees`
   - `sales`
   - `purchases`
   - `transfers`

3. **Estructura de tablas requerida:**

```sql
-- WAREHOUSES
CREATE TABLE warehouses (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- STORES
CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- EMPLOYEES
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL,
  store_id INT REFERENCES stores(id),
  warehouse_id INT REFERENCES warehouses(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- SALES
CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id),
  quantity INT NOT NULL,
  employee_id INT REFERENCES employees(id),
  store_id INT REFERENCES stores(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- PURCHASES
CREATE TABLE purchases (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id),
  quantity INT NOT NULL,
  employee_id INT REFERENCES employees(id),
  store_id INT REFERENCES stores(id),
  warehouse_id INT REFERENCES warehouses(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- TRANSFERS
CREATE TABLE transfers (
  id SERIAL PRIMARY KEY,
  product_id INT REFERENCES products(id),
  quantity INT NOT NULL,
  employee_id INT REFERENCES employees(id),
  from_location_id INT NOT NULL,
  to_location_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

### **PASO 2: Actualizar Modelos y Entidades**

Ya he actualizado:
- ✅ `ProductModel` - Con `toJson(includeId: false)`
- ✅ `WarehouseModel` - Completo con todos los campos
- ✅ `Warehouse` entity - Actualizada

**PENDIENTE - Actualizar estos archivos:**

#### **1. Store Entity y Model:**

```dart
// lib/src/core/domain/entities/store.dart
class Store {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Store({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });
}
```

```dart
// lib/src/core/data/models/store_model.dart
// Copiar la estructura de WarehouseModel y adaptar para Store
```

#### **2. Sales, Purchases, Transfers:**

Estos ya tienen entidades básicas, solo necesitan:
- Actualizar los datasources con métodos CRUD
- Crear los Blocs correspondientes
- Crear las páginas UI

---

### **PASO 3: Implementar Datasources Remotos**

**Patrón a seguir (ya implementado en Products):**

```dart
// Ejemplo: StoresRemoteDataSource
class StoresRemoteDataSource {
  final SupabaseClient supabaseClient;

  StoresRemoteDataSource(this.supabaseClient);

  Future<List<Store>> getStores() async {
    final response = await supabaseClient.from('stores').select();
    return (response as List)
        .map((json) => StoreModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> addStore(Store store) async {
    await supabaseClient
        .from('stores')
        .insert(StoreModel.fromEntity(store).toJson(includeId: false));
  }

  Future<void> updateStore(Store store) async {
    await supabaseClient
        .from('stores')
        .update(StoreModel.fromEntity(store).toJson())
        .eq('id', store.id);
  }

  Future<void> deleteStore(int id) async {
    await supabaseClient.from('stores').delete().eq('id', id);
  }
}
```

**Aplicar este patrón a:**
- ✅ Products (ya hecho)
- ✅ Warehouses (ya hecho)
- ⚠️ Stores (pendiente)
- ⚠️ Employees (pendiente)
- ⚠️ Sales (pendiente)
- ⚠️ Purchases (pendiente)
- ⚠️ Transfers (pendiente)

---

### **PASO 4: Crear Blocs para cada Feature**

**Patrón a seguir (ya implementado en Inventory):**

```dart
// Ejemplo: StoresBloc
class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final GetStoresUseCase getStoresUseCase;
  final AddStoreUseCase addStoreUseCase;
  final UpdateStoreUseCase updateStoreUseCase;
  final DeleteStoreUseCase deleteStoreUseCase;

  StoresBloc({
    required this.getStoresUseCase,
    required this.addStoreUseCase,
    required this.updateStoreUseCase,
    required this.deleteStoreUseCase,
  }) : super(StoresInitial()) {
    on<LoadStoresEvent>((event, emit) async {
      emit(StoresLoading());
      try {
        final stores = await getStoresUseCase();
        emit(StoresLoaded(stores));
      } catch (e) {
        emit(StoresError(e.toString()));
      }
    });

    on<AddStoreEvent>((event, emit) async {
      emit(StoresLoading());
      try {
        await addStoreUseCase(event.store);
        add(LoadStoresEvent());
      } catch (e) {
        emit(StoresError(e.toString()));
      }
    });

    // ... más handlers
  }
}
```

---

### **PASO 5: Crear Páginas UI**

**Estructura de cada página:**

```dart
// Ejemplo: StoresPage
class StoresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stores')),
      body: BlocBuilder<StoresBloc, StoresState>(
        builder: (context, state) {
          if (state is StoresLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StoresLoaded) {
            return ListView.builder(
              itemCount: state.stores.length,
              itemBuilder: (context, index) {
                final store = state.stores[index];
                return ListTile(
                  title: Text(store.name),
                  subtitle: Text(store.address),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/store_detail',
                    arguments: store,
                  ),
                );
              },
            );
          } else if (state is StoresError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No stores found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/store_detail'),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

---

### **PASO 6: Implementar Reportes**

**Los reportes ya tienen datasources básicos. Necesitas:**

1. **Actualizar ReportsBloc** para manejar todos los tipos de reportes
2. **Crear páginas de reportes** con filtros
3. **Usar las vistas SQL** creadas en Supabase

**Ejemplo de uso de vista:**

```dart
// En ReportsRemoteDataSource
Future<List<SalesReport>> getSalesReport({
  int? storeId,
  DateTime? startDate,
  DateTime? endDate,
}) async {
  var query = supabaseClient.from('sales_report').select();
  
  if (storeId != null) {
    query = query.eq('store_id', storeId);
  }
  if (startDate != null) {
    query = query.gte('sale_date', startDate.toIso8601String());
  }
  if (endDate != null) {
    query = query.lte('sale_date', endDate.toIso8601String());
  }
  
  final response = await query;
  return (response as List)
      .map((json) => SalesReportModel.fromJson(json).toEntity())
      .toList();
}
```

---

### **PASO 7: Registrar en Dependency Injection**

**Para cada feature, agregar en `injection_container.dart`:**

```dart
// Ejemplo para Stores
getIt.registerSingleton<StoresRemoteDataSource>(
  StoresRemoteDataSource(getIt()),
);
getIt.registerSingleton<StoresLocalDataSource>(
  StoresLocalDataSource(getIt()),
);
getIt.registerSingleton<StoresRepository>(
  StoresRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
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
```

---

### **PASO 8: Agregar Rutas en main.dart**

```dart
routes: {
  '/splash': (context) => const SplashPage(),
  '/login': (context) => const LoginPage(),
  '/inventory': (context) => const InventoryPage(),
  '/stores': (context) => const StoresPage(),
  '/warehouses': (context) => const WarehousesPage(),
  '/employees': (context) => const EmployeesPage(),
  '/sales': (context) => const SalesPage(),
  '/purchases': (context) => const PurchasesPage(),
  '/transfers': (context) => const TransfersPage(),
  '/reports': (context) => const ReportsPage(),
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
  // ... más rutas con argumentos
  return null;
},
```

---

## 📊 Funcionalidades Requeridas - Checklist

### **1. Gestionar Datos:**
- ✅ Productos - FUNCIONANDO
- ⚠️ Almacenes - Datasource listo, falta UI
- ⚠️ Tiendas - Falta implementar
- ⚠️ Empleados - Falta implementar

### **2. Autenticación:**
- ✅ Login básico - FUNCIONANDO
- ⚠️ Autenticación por rol (encargado de tienda/almacén) - Falta implementar

### **3. Transacciones:**
- ⚠️ Compras - Estructura creada, falta lógica
- ⚠️ Ventas - Estructura creada, falta lógica
- ⚠️ Transferencias - Estructura creada, falta lógica

### **4. Inventario Actualizado:**
- ✅ Inventario global - Funcionando (vista SQL creada)
- ⚠️ Por tienda - Vista SQL creada, falta UI
- ⚠️ Por almacén - Vista SQL creada, falta UI

### **5. Reportes:**
- ⚠️ Ventas por tienda y fecha - Vista SQL creada, falta UI
- ⚠️ Compras filtradas - Vista SQL creada, falta UI
- ⚠️ Transferencias filtradas - Vista SQL creada, falta UI
- ⚠️ Venta global del día - Función SQL creada, falta UI

---

## 🎯 Prioridades de Implementación

### **ALTA PRIORIDAD (Hacer primero):**
1. ✅ Ejecutar `SUPABASE_SETUP.sql` en Supabase
2. ⚠️ Completar Stores (modelo, datasource, bloc, UI)
3. ⚠️ Completar Warehouses (UI)
4. ⚠️ Implementar Sales (completo)
5. ⚠️ Implementar Purchases (completo)

### **MEDIA PRIORIDAD:**
6. ⚠️ Completar Employees
7. ⚠️ Implementar Transfers
8. ⚠️ Crear página de reportes básica

### **BAJA PRIORIDAD:**
9. ⚠️ Reportes avanzados con gráficos
10. ⚠️ Autenticación por roles específicos

---

## 💡 Consejos de Implementación

1. **Sigue el patrón de Products:**
   - Ya está completamente implementado
   - Úsalo como referencia para las demás features

2. **Prueba cada feature individualmente:**
   - Implementa una feature completa antes de pasar a la siguiente
   - Verifica que funcione en Supabase

3. **Usa los logs:**
   - Los logs con emojis te ayudarán a debuggear
   - Mantén el patrón de logging en todas las features

4. **RLS es crítico:**
   - Sin las políticas RLS, nada funcionará
   - Ejecuta el script SQL primero

---

## 🔧 Comandos Útiles

```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en dispositivo
flutter run

# Ver logs
flutter logs

# Analizar código
flutter analyze
```

---

## 📞 Siguiente Paso Inmediato

**ACCIÓN REQUERIDA:**

1. **Abre Supabase Dashboard**
2. **Ve a SQL Editor**
3. **Ejecuta `SUPABASE_SETUP.sql`**
4. **Verifica que todas las políticas se crearon**
5. **Prueba agregar un producto** - Debería funcionar sin errores

Una vez hecho esto, podemos continuar implementando las demás features una por una.

---

¿Por dónde quieres empezar? Te recomiendo:
1. Ejecutar el script SQL
2. Implementar Stores completo (es el más simple después de Products)
3. Luego Sales (es crítico para los reportes)
