-- Script para crear las tablas necesarias en Supabase
-- Ejecutar este script en el SQL Editor de Supabase

-- 1. Crear tabla de productos
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  variant TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  store_id INTEGER,
  warehouse_id INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. Crear tabla de empleados
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'store_manager', 'warehouse_manager', 'employee')),
  store_id INTEGER,
  warehouse_id INTEGER,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. Crear tabla de tiendas
CREATE TABLE IF NOT EXISTS stores (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  manager_id INTEGER REFERENCES employees(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 4. Crear tabla de almacenes
CREATE TABLE IF NOT EXISTS warehouses (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  manager_id INTEGER REFERENCES employees(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 5. Crear tabla de ventas
CREATE TABLE IF NOT EXISTS sales (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(10,2),
  employee_id INTEGER REFERENCES employees(id) NOT NULL,
  store_id INTEGER REFERENCES stores(id),
  customer_name TEXT,
  customer_phone TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 6. Crear tabla de compras
CREATE TABLE IF NOT EXISTS purchases (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(10,2),
  employee_id INTEGER REFERENCES employees(id) NOT NULL,
  store_id INTEGER REFERENCES stores(id),
  warehouse_id INTEGER REFERENCES warehouses(id),
  supplier_name TEXT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 7. Crear tabla de transferencias
CREATE TABLE IF NOT EXISTS transfers (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  employee_id INTEGER REFERENCES employees(id) NOT NULL,
  from_location_type TEXT NOT NULL CHECK (from_location_type IN ('store', 'warehouse')),
  from_location_id INTEGER NOT NULL,
  to_location_type TEXT NOT NULL CHECK (to_location_type IN ('store', 'warehouse')),
  to_location_id INTEGER NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 8. Habilitar RLS en todas las tablas
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE warehouses ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;

-- 9. Crear políticas básicas (permitir todo por ahora para testing)
CREATE POLICY "Allow all operations on sales" ON sales FOR ALL USING (true);
CREATE POLICY "Allow all operations on purchases" ON purchases FOR ALL USING (true);
CREATE POLICY "Allow all operations on transfers" ON transfers FOR ALL USING (true);
CREATE POLICY "Allow all operations on products" ON products FOR ALL USING (true);
CREATE POLICY "Allow all operations on employees" ON employees FOR ALL USING (true);
CREATE POLICY "Allow all operations on stores" ON stores FOR ALL USING (true);
CREATE POLICY "Allow all operations on warehouses" ON warehouses FOR ALL USING (true);

-- 10. Insertar datos de prueba
INSERT INTO employees (name, email, password, role) VALUES 
('Admin User', 'admin@test.com', 'password123', 'admin'),
('Store Manager', 'store@test.com', 'password123', 'store_manager'),
('Warehouse Manager', 'warehouse@test.com', 'password123', 'warehouse_manager');

INSERT INTO stores (name, address, phone) VALUES 
('Tienda Principal', 'Calle Principal 123', '555-0001'),
('Tienda Secundaria', 'Calle Secundaria 456', '555-0002');

INSERT INTO warehouses (name, address, phone) VALUES 
('Almacén Central', 'Avenida Central 789', '555-1001'),
('Almacén Norte', 'Avenida Norte 321', '555-1002');

INSERT INTO products (name, variant, stock, store_id, warehouse_id) VALUES 
('Producto 1', 'Variante A', 100, 1, 1),
('Producto 2', 'Variante B', 50, 1, 1),
('Producto 3', 'Variante C', 75, 2, 2);
