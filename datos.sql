-- ============================================
-- SCRIPT DE CONFIGURACIÓN COMPLETA PARA SUPABASE
-- Sistema de Gestión de Inventario
-- ============================================

-- 1. CREAR LAS TABLAS PRIMERO
-- ============================================

-- Tabla de almacenes
CREATE TABLE IF NOT EXISTS warehouses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location TEXT,
    capacity INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de tiendas
CREATE TABLE IF NOT EXISTS stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location TEXT,
    manager VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de empleados
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(100),
    store_id INTEGER REFERENCES stores(id),
    warehouse_id INTEGER REFERENCES warehouses(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    variant VARCHAR(100),
    sku VARCHAR(100) UNIQUE,
    price DECIMAL(10,2),
    cost DECIMAL(10,2),
    stock INTEGER DEFAULT 0,
    min_stock INTEGER DEFAULT 0,
    max_stock INTEGER DEFAULT 0,
    store_id INTEGER REFERENCES stores(id),
    warehouse_id INTEGER REFERENCES warehouses(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    store_id INTEGER REFERENCES stores(id),
    employee_id INTEGER REFERENCES employees(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de compras
CREATE TABLE IF NOT EXISTS purchases (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    supplier VARCHAR(255),
    store_id INTEGER REFERENCES stores(id),
    warehouse_id INTEGER REFERENCES warehouses(id),
    employee_id INTEGER REFERENCES employees(id),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabla de transferencias
CREATE TABLE IF NOT EXISTS transfers (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    from_location_type VARCHAR(50), -- 'store' o 'warehouse'
    from_location_id INTEGER,
    to_location_type VARCHAR(50), -- 'store' o 'warehouse'
    to_location_id INTEGER,
    employee_id INTEGER REFERENCES employees(id),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

-- ============================================
-- 2. HABILITAR ROW LEVEL SECURITY EN TODAS LAS TABLAS
-- ============================================

ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE warehouses ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. ELIMINAR POLÍTICAS EXISTENTES SI LAS HAY (OPCIONAL)
-- ============================================

DROP POLICY IF EXISTS "Allow authenticated users to read products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users to insert products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users to update products" ON products;
DROP POLICY IF EXISTS "Allow authenticated users to delete products" ON products;

-- Repetir para las demás tablas...

-- ============================================
-- 4. POLÍTICAS PARA PRODUCTS
-- ============================================

-- Permitir lectura a todos los usuarios autenticados
CREATE POLICY "Allow authenticated users to read products"
ON products FOR SELECT
TO authenticated
USING (true);

-- Permitir inserción a usuarios autenticados
CREATE POLICY "Allow authenticated users to insert products"
ON products FOR INSERT
TO authenticated
WITH CHECK (true);

-- Permitir actualización a usuarios autenticados
CREATE POLICY "Allow authenticated users to update products"
ON products FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Permitir eliminación a usuarios autenticados
CREATE POLICY "Allow authenticated users to delete products"
ON products FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 5. POLÍTICAS PARA WAREHOUSES
-- ============================================

CREATE POLICY "Allow authenticated users to read warehouses"
ON warehouses FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert warehouses"
ON warehouses FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update warehouses"
ON warehouses FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete warehouses"
ON warehouses FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 6. POLÍTICAS PARA STORES
-- ============================================

CREATE POLICY "Allow authenticated users to read stores"
ON stores FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert stores"
ON stores FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update stores"
ON stores FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete stores"
ON stores FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 7. POLÍTICAS PARA EMPLOYEES
-- ============================================

CREATE POLICY "Allow authenticated users to read employees"
ON employees FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert employees"
ON employees FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update employees"
ON employees FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete employees"
ON employees FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 8. POLÍTICAS PARA SALES
-- ============================================

CREATE POLICY "Allow authenticated users to read sales"
ON sales FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert sales"
ON sales FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update sales"
ON sales FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete sales"
ON sales FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 9. POLÍTICAS PARA PURCHASES
-- ============================================

CREATE POLICY "Allow authenticated users to read purchases"
ON purchases FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert purchases"
ON purchases FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update purchases"
ON purchases FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete purchases"
ON purchases FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 10. POLÍTICAS PARA TRANSFERS
-- ============================================

CREATE POLICY "Allow authenticated users to read transfers"
ON transfers FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Allow authenticated users to insert transfers"
ON transfers FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update transfers"
ON transfers FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete transfers"
ON transfers FOR DELETE
TO authenticated
USING (true);

-- ============================================
-- 11. VISTAS PARA REPORTES
-- ============================================

-- Vista para inventario global
CREATE OR REPLACE VIEW inventory_global AS
SELECT 
    p.id,
    p.name,
    p.variant,
    SUM(p.stock) as total_stock,
    p.updated_at
FROM products p
GROUP BY p.id, p.name, p.variant, p.updated_at;

-- Vista para inventario por tienda
CREATE OR REPLACE VIEW inventory_by_store AS
SELECT 
    p.id as product_id,
    p.name as product_name,
    p.variant,
    p.stock,
    s.id as store_id,
    s.name as store_name,
    p.updated_at
FROM products p
INNER JOIN stores s ON p.store_id = s.id
WHERE p.store_id IS NOT NULL;

-- Vista para inventario por almacén
CREATE OR REPLACE VIEW inventory_by_warehouse AS
SELECT 
    p.id as product_id,
    p.name as product_name,
    p.variant,
    p.stock,
    w.id as warehouse_id,
    w.name as warehouse_name,
    p.updated_at
FROM products p
INNER JOIN warehouses w ON p.warehouse_id = w.id
WHERE p.warehouse_id IS NOT NULL;

-- Vista para ventas del día
CREATE OR REPLACE VIEW daily_sales AS
SELECT 
    DATE(s.created_at) as sale_date,
    s.store_id,
    st.name as store_name,
    SUM(s.quantity) as total_quantity,
    COUNT(*) as total_transactions,
    s.created_at
FROM sales s
LEFT JOIN stores st ON s.store_id = st.id
WHERE DATE(s.created_at) = CURRENT_DATE
GROUP BY DATE(s.created_at), s.store_id, st.name, s.created_at;

-- Vista para reporte de ventas por tienda y fecha
CREATE OR REPLACE VIEW sales_report AS
SELECT 
    s.id,
    s.product_id,
    p.name as product_name,
    s.quantity,
    s.store_id,
    st.name as store_name,
    s.employee_id,
    e.name as employee_name,
    s.created_at,
    DATE(s.created_at) as sale_date
FROM sales s
LEFT JOIN products p ON s.product_id = p.id
LEFT JOIN stores st ON s.store_id = st.id
LEFT JOIN employees e ON s.employee_id = e.id;

-- Vista para reporte de compras
CREATE OR REPLACE VIEW purchases_report AS
SELECT 
    pu.id,
    pu.product_id,
    p.name as product_name,
    pu.quantity,
    pu.store_id,
    st.name as store_name,
    pu.warehouse_id,
    w.name as warehouse_name,
    pu.employee_id,
    e.name as employee_name,
    pu.created_at,
    DATE(pu.created_at) as purchase_date
FROM purchases pu
LEFT JOIN products p ON pu.product_id = p.id
LEFT JOIN stores st ON pu.store_id = st.id
LEFT JOIN warehouses w ON pu.warehouse_id = w.id
LEFT JOIN employees e ON pu.employee_id = e.id;

-- Vista para reporte de transferencias
CREATE OR REPLACE VIEW transfers_report AS
SELECT 
    t.id,
    t.product_id,
    p.name as product_name,
    t.quantity,
    t.from_location_id,
    t.to_location_id,
    t.employee_id,
    e.name as employee_name,
    t.created_at,
    DATE(t.created_at) as transfer_date
FROM transfers t
LEFT JOIN products p ON t.product_id = p.id
LEFT JOIN employees e ON t.employee_id = e.id;

-- ============================================
-- 12. FUNCIONES PARA REPORTES
-- ============================================

-- Función para obtener venta global del día
CREATE OR REPLACE FUNCTION get_daily_global_sales(target_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
    total_quantity BIGINT,
    total_transactions BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(SUM(s.quantity), 0)::BIGINT as total_quantity,
        COALESCE(COUNT(*), 0)::BIGINT as total_transactions
    FROM sales s
    WHERE DATE(s.created_at) = target_date;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener ventas por tienda y rango de fechas
CREATE OR REPLACE FUNCTION get_sales_by_store_and_date(
    p_store_id INT DEFAULT NULL,
    p_start_date DATE DEFAULT NULL,
    p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
    sale_id INT,
    product_name TEXT,
    quantity INT,
    store_name TEXT,
    employee_name TEXT,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id as sale_id,
        p.name as product_name,
        s.quantity,
        st.name as store_name,
        e.name as employee_name,
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

-- ============================================
-- 13. DATOS DE EJEMPLO (OPCIONAL)
-- ============================================

-- Insertar datos de ejemplo si lo deseas
INSERT INTO warehouses (name, location, capacity) VALUES
('Almacén Central', 'Av. Principal #123', 10000),
('Almacén Norte', 'Zona Industrial Norte', 5000);

INSERT INTO stores (name, location, manager) VALUES
('Tienda Centro', 'Centro Comercial Downtown', 'Juan Pérez'),
('Tienda Mall', 'Mall del Sur', 'María García');

INSERT INTO employees (name, email, role, store_id, warehouse_id) VALUES
('Carlos López', 'carlos@empresa.com', 'Vendedor', 1, NULL),
('Ana Martínez', 'ana@empresa.com', 'Gerente', 2, NULL),
('Pedro Rodríguez', 'pedro@empresa.com', 'Almacenero', NULL, 1);

-- ============================================
-- INSTRUCCIONES DE USO:
-- ============================================
-- 1. Ve a tu proyecto en Supabase Dashboard
-- 2. Abre el SQL Editor
-- 3. Copia y pega todo este script
-- 4. Ejecuta el script completo
-- 5. Verifica que todas las tablas y políticas se hayan creado
-- ============================================