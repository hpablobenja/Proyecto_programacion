-- ============================================
-- ESQUEMA DE BASE DE DATOS ACTUALIZADO
-- Sistema de Gestión de Inventario
-- Objetivos: Compras, Almacenes y Ventas
-- ============================================

-- 1. TABLA DE PRODUCTOS
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  variant TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  store_id INTEGER REFERENCES stores(id),
  warehouse_id INTEGER REFERENCES warehouses(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. TABLA DE ALMACENES
CREATE TABLE warehouses (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  manager_id INTEGER REFERENCES employees(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 3. TABLA DE TIENDAS
CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT,
  manager_id INTEGER REFERENCES employees(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 4. TABLA DE EMPLEADOS
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'store_manager', 'warehouse_manager', 'employee')),
  store_id INTEGER REFERENCES stores(id),
  warehouse_id INTEGER REFERENCES warehouses(id),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 5. TABLA DE COMPRAS
CREATE TABLE purchases (
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

-- 6. TABLA DE VENTAS
CREATE TABLE sales (
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

-- 7. TABLA DE TRANSFERENCIAS
CREATE TABLE transfers (
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

-- ============================================
-- VISTAS PARA INVENTARIO ACTUALIZADO
-- ============================================

-- Vista de Inventario Global
CREATE OR REPLACE VIEW inventory_global AS
SELECT 
  p.id,
  p.name,
  p.variant,
  SUM(p.stock) as total_stock,
  COUNT(DISTINCT p.store_id) as stores_count,
  COUNT(DISTINCT p.warehouse_id) as warehouses_count,
  p.updated_at
FROM products p
GROUP BY p.id, p.name, p.variant, p.updated_at;

-- Vista de Inventario por Tienda
CREATE OR REPLACE VIEW inventory_by_store AS
SELECT 
  p.id as product_id,
  p.name as product_name,
  p.variant,
  p.stock,
  s.id as store_id,
  s.name as store_name,
  s.manager_id,
  e.name as manager_name,
  p.updated_at
FROM products p
INNER JOIN stores s ON p.store_id = s.id
LEFT JOIN employees e ON s.manager_id = e.id
WHERE p.store_id IS NOT NULL;

-- Vista de Inventario por Almacén
CREATE OR REPLACE VIEW inventory_by_warehouse AS
SELECT 
  p.id as product_id,
  p.name as product_name,
  p.variant,
  p.stock,
  w.id as warehouse_id,
  w.name as warehouse_name,
  w.manager_id,
  e.name as manager_name,
  p.updated_at
FROM products p
INNER JOIN warehouses w ON p.warehouse_id = w.id
LEFT JOIN employees e ON w.manager_id = e.id
WHERE p.warehouse_id IS NOT NULL;

-- ============================================
-- VISTAS PARA REPORTES
-- ============================================

-- Vista de Reporte de Ventas
CREATE OR REPLACE VIEW sales_report AS
SELECT 
  s.id,
  s.product_id,
  p.name as product_name,
  s.quantity,
  s.unit_price,
  s.total_price,
  s.store_id,
  st.name as store_name,
  s.employee_id,
  e.name as employee_name,
  s.customer_name,
  s.customer_phone,
  s.created_at,
  DATE(s.created_at) as sale_date
FROM sales s
LEFT JOIN products p ON s.product_id = p.id
LEFT JOIN stores st ON s.store_id = st.id
LEFT JOIN employees e ON s.employee_id = e.id;

-- Vista de Reporte de Compras
CREATE OR REPLACE VIEW purchases_report AS
SELECT 
  pu.id,
  pu.product_id,
  p.name as product_name,
  pu.quantity,
  pu.unit_price,
  pu.total_price,
  pu.store_id,
  st.name as store_name,
  pu.warehouse_id,
  w.name as warehouse_name,
  pu.employee_id,
  e.name as employee_name,
  pu.supplier_name,
  pu.created_at,
  DATE(pu.created_at) as purchase_date
FROM purchases pu
LEFT JOIN products p ON pu.product_id = p.id
LEFT JOIN stores st ON pu.store_id = st.id
LEFT JOIN warehouses w ON pu.warehouse_id = w.id
LEFT JOIN employees e ON pu.employee_id = e.id;

-- Vista de Reporte de Transferencias
CREATE OR REPLACE VIEW transfers_report AS
SELECT 
  t.id,
  t.product_id,
  p.name as product_name,
  t.quantity,
  t.from_location_type,
  t.from_location_id,
  CASE 
    WHEN t.from_location_type = 'store' THEN st.name
    WHEN t.from_location_type = 'warehouse' THEN wh.name
  END as from_location_name,
  t.to_location_type,
  t.to_location_id,
  CASE 
    WHEN t.to_location_type = 'store' THEN st2.name
    WHEN t.to_location_type = 'warehouse' THEN wh2.name
  END as to_location_name,
  t.employee_id,
  e.name as employee_name,
  t.created_at,
  DATE(t.created_at) as transfer_date
FROM transfers t
LEFT JOIN products p ON t.product_id = p.id
LEFT JOIN employees e ON t.employee_id = e.id
LEFT JOIN stores st ON t.from_location_type = 'store' AND t.from_location_id = st.id
LEFT JOIN warehouses wh ON t.from_location_type = 'warehouse' AND t.from_location_id = wh.id
LEFT JOIN stores st2 ON t.to_location_type = 'store' AND t.to_location_id = st2.id
LEFT JOIN warehouses wh2 ON t.to_location_type = 'warehouse' AND t.to_location_id = wh2.id;

-- ============================================
-- FUNCIONES PARA REPORTES ESPECÍFICOS
-- ============================================

-- Función para Venta Global del Día
CREATE OR REPLACE FUNCTION get_daily_global_sales(target_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
  total_quantity BIGINT,
  total_transactions BIGINT,
  total_revenue DECIMAL(12,2)
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    SUM(s.quantity)::BIGINT as total_quantity,
    COUNT(*)::BIGINT as total_transactions,
    COALESCE(SUM(s.total_price), 0) as total_revenue
  FROM sales s
  WHERE DATE(s.created_at) = target_date;
END;
$$ LANGUAGE plpgsql;

-- Función para Ventas por Tienda y Fecha
CREATE OR REPLACE FUNCTION get_sales_by_store_and_date(
  p_store_id INTEGER DEFAULT NULL,
  p_start_date DATE DEFAULT NULL,
  p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
  sale_id INTEGER,
  product_name TEXT,
  quantity INTEGER,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(10,2),
  store_name TEXT,
  employee_name TEXT,
  customer_name TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    s.id as sale_id,
    p.name as product_name,
    s.quantity,
    s.unit_price,
    s.total_price,
    st.name as store_name,
    e.name as employee_name,
    s.customer_name,
    s.created_at
  FROM sales s
  LEFT JOIN products p ON s.product_id = p.id
  LEFT JOIN stores st ON s.store_id = st.id
  LEFT JOIN employees e ON s.employee_id = e.id
  WHERE 
    (p_store_id IS NULL OR s.store_id = p_store_id)
    AND (p_start_date IS NULL OR DATE(s.created_at) >= p_start_date)
    AND (p_end_date IS NULL OR DATE(s.created_at) <= p_end_date)
  ORDER BY s.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Función para Compras por Tienda y Fecha
CREATE OR REPLACE FUNCTION get_purchases_by_store_and_date(
  p_store_id INTEGER DEFAULT NULL,
  p_warehouse_id INTEGER DEFAULT NULL,
  p_start_date DATE DEFAULT NULL,
  p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
  purchase_id INTEGER,
  product_name TEXT,
  quantity INTEGER,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(10,2),
  store_name TEXT,
  warehouse_name TEXT,
  employee_name TEXT,
  supplier_name TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    pu.id as purchase_id,
    p.name as product_name,
    pu.quantity,
    pu.unit_price,
    pu.total_price,
    st.name as store_name,
    w.name as warehouse_name,
    e.name as employee_name,
    pu.supplier_name,
    pu.created_at
  FROM purchases pu
  LEFT JOIN products p ON pu.product_id = p.id
  LEFT JOIN stores st ON pu.store_id = st.id
  LEFT JOIN warehouses w ON pu.warehouse_id = w.id
  LEFT JOIN employees e ON pu.employee_id = e.id
  WHERE 
    (p_store_id IS NULL OR pu.store_id = p_store_id)
    AND (p_warehouse_id IS NULL OR pu.warehouse_id = p_warehouse_id)
    AND (p_start_date IS NULL OR DATE(pu.created_at) >= p_start_date)
    AND (p_end_date IS NULL OR DATE(pu.created_at) <= p_end_date)
  ORDER BY pu.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Función para Transferencias Filtradas
CREATE OR REPLACE FUNCTION get_transfers_filtered(
  p_from_location_type TEXT DEFAULT NULL,
  p_from_location_id INTEGER DEFAULT NULL,
  p_to_location_type TEXT DEFAULT NULL,
  p_to_location_id INTEGER DEFAULT NULL,
  p_start_date DATE DEFAULT NULL,
  p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
  transfer_id INTEGER,
  product_name TEXT,
  quantity INTEGER,
  from_location_name TEXT,
  to_location_name TEXT,
  employee_name TEXT,
  created_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id as transfer_id,
    p.name as product_name,
    t.quantity,
    CASE 
      WHEN t.from_location_type = 'store' THEN st.name
      WHEN t.from_location_type = 'warehouse' THEN wh.name
    END as from_location_name,
    CASE 
      WHEN t.to_location_type = 'store' THEN st2.name
      WHEN t.to_location_type = 'warehouse' THEN wh2.name
    END as to_location_name,
    e.name as employee_name,
    t.created_at
  FROM transfers t
  LEFT JOIN products p ON t.product_id = p.id
  LEFT JOIN employees e ON t.employee_id = e.id
  LEFT JOIN stores st ON t.from_location_type = 'store' AND t.from_location_id = st.id
  LEFT JOIN warehouses wh ON t.from_location_type = 'warehouse' AND t.from_location_id = wh.id
  LEFT JOIN stores st2 ON t.to_location_type = 'store' AND t.to_location_id = st2.id
  LEFT JOIN warehouses wh2 ON t.to_location_type = 'warehouse' AND t.to_location_id = wh2.id
  WHERE 
    (p_from_location_type IS NULL OR t.from_location_type = p_from_location_type)
    AND (p_from_location_id IS NULL OR t.from_location_id = p_from_location_id)
    AND (p_to_location_type IS NULL OR t.to_location_type = p_to_location_type)
    AND (p_to_location_id IS NULL OR t.to_location_id = p_to_location_id)
    AND (p_start_date IS NULL OR DATE(t.created_at) >= p_start_date)
    AND (p_end_date IS NULL OR DATE(t.created_at) <= p_end_date)
  ORDER BY t.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- POLÍTICAS RLS (ROW LEVEL SECURITY)
-- ============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE warehouses ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;

-- Políticas para empleados (solo pueden ver sus propios datos y los de su tienda/almacén)
CREATE POLICY "Employees can view their own data and store/warehouse data"
ON employees FOR SELECT
TO authenticated
USING (
  id = auth.uid()::INTEGER 
  OR store_id IN (SELECT store_id FROM employees WHERE id = auth.uid()::INTEGER)
  OR warehouse_id IN (SELECT warehouse_id FROM employees WHERE id = auth.uid()::INTEGER)
);

-- Políticas para productos (basadas en el rol del empleado)
CREATE POLICY "Store managers can view products in their store"
ON products FOR ALL
TO authenticated
USING (
  store_id IN (SELECT store_id FROM employees WHERE id = auth.uid()::INTEGER AND role = 'store_manager')
  OR warehouse_id IN (SELECT warehouse_id FROM employees WHERE id = auth.uid()::INTEGER AND role = 'warehouse_manager')
  OR EXISTS (SELECT 1 FROM employees WHERE id = auth.uid()::INTEGER AND role = 'admin')
);

-- Políticas similares para las demás tablas...
-- (Se pueden agregar más políticas específicas según los roles)

-- ============================================
-- TRIGGERS PARA ACTUALIZAR INVENTARIO
-- ============================================

-- Función para actualizar stock después de una venta
CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products 
  SET stock = stock - NEW.quantity,
      updated_at = NOW()
  WHERE id = NEW.product_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para ventas
CREATE TRIGGER trigger_update_stock_after_sale
  AFTER INSERT ON sales
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_after_sale();

-- Función para actualizar stock después de una compra
CREATE OR REPLACE FUNCTION update_stock_after_purchase()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE products 
  SET stock = stock + NEW.quantity,
      updated_at = NOW()
  WHERE id = NEW.product_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para compras
CREATE TRIGGER trigger_update_stock_after_purchase
  AFTER INSERT ON purchases
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_after_purchase();

-- Función para actualizar stock después de una transferencia
CREATE OR REPLACE FUNCTION update_stock_after_transfer()
RETURNS TRIGGER AS $$
BEGIN
  -- Reducir stock del origen
  IF NEW.from_location_type = 'store' THEN
    UPDATE products 
    SET stock = stock - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id AND store_id = NEW.from_location_id;
  ELSIF NEW.from_location_type = 'warehouse' THEN
    UPDATE products 
    SET stock = stock - NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id AND warehouse_id = NEW.from_location_id;
  END IF;
  
  -- Aumentar stock del destino
  IF NEW.to_location_type = 'store' THEN
    UPDATE products 
    SET stock = stock + NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id AND store_id = NEW.to_location_id;
  ELSIF NEW.to_location_type = 'warehouse' THEN
    UPDATE products 
    SET stock = stock + NEW.quantity,
        updated_at = NOW()
    WHERE id = NEW.product_id AND warehouse_id = NEW.to_location_id;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para transferencias
CREATE TRIGGER trigger_update_stock_after_transfer
  AFTER INSERT ON transfers
  FOR EACH ROW
  EXECUTE FUNCTION update_stock_after_transfer();
