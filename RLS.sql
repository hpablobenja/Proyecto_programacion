-- =====================================================
-- VERIFICACIÓN DE POLÍTICAS SUPABASE
-- Script para verificar que las políticas no afecten el funcionamiento
-- =====================================================

-- =====================================================
-- 1. VERIFICAR ESTADO DE RLS
-- =====================================================

-- Verificar que RLS esté habilitado en todas las tablas
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled,
    CASE 
        WHEN rowsecurity THEN '✅ RLS Habilitado'
        ELSE '❌ RLS Deshabilitado'
    END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('products', 'stores', 'warehouses', 'employees', 'sales', 'purchases', 'transfers')
ORDER BY tablename;

-- =====================================================
-- 2. VERIFICAR POLÍTICAS EXISTENTES
-- =====================================================

-- Listar todas las políticas creadas
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('products', 'stores', 'warehouses', 'employees', 'sales', 'purchases', 'transfers')
ORDER BY tablename, policyname;

-- =====================================================
-- 3. VERIFICAR FUNCIONES DE UTILIDAD
-- =====================================================

-- Verificar que las funciones existan
SELECT 
    routine_name,
    routine_type,
    data_type as return_type
FROM information_schema.routines 
WHERE routine_schema = 'public'
AND routine_name IN ('is_admin', 'get_current_employee_id', 'can_access_store', 'can_access_warehouse', 'get_current_user_role')
ORDER BY routine_name;

-- =====================================================
-- 4. VERIFICAR ÍNDICES
-- =====================================================

-- Verificar índices creados
SELECT 
    indexname,
    tablename,
    indexdef
FROM pg_indexes 
WHERE schemaname = 'public'
AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;

-- =====================================================
-- 5. PRUEBAS DE FUNCIONALIDAD
-- =====================================================

-- Prueba 1: Verificar que se pueden leer productos
SELECT 
    'Productos' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM products
UNION ALL
SELECT 
    'Tiendas' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM stores
UNION ALL
SELECT 
    'Almacenes' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM warehouses
UNION ALL
SELECT 
    'Empleados' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM employees
UNION ALL
SELECT 
    'Ventas' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM sales
UNION ALL
SELECT 
    'Compras' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM purchases
UNION ALL
SELECT 
    'Transferencias' as tabla,
    COUNT(*) as total_registros,
    '✅ Lectura exitosa' as status
FROM transfers;

-- =====================================================
-- 6. VERIFICAR PERMISOS DE USUARIO ACTUAL
-- =====================================================

-- Verificar rol del usuario actual
SELECT 
    auth.uid() as user_id,
    auth.role() as user_role,
    CASE 
        WHEN auth.role() = 'authenticated' THEN '✅ Usuario autenticado'
        ELSE '❌ Usuario no autenticado'
    END as auth_status;

-- Verificar información del empleado actual
SELECT 
    id,
    name,
    email,
    role,
    store_id,
    warehouse_id,
    CASE 
        WHEN role = 'admin' THEN '✅ Administrador'
        WHEN role = 'store_manager' THEN '✅ Encargado de Tienda'
        WHEN role = 'warehouse_manager' THEN '✅ Encargado de Almacén'
        WHEN role = 'employee' THEN '✅ Empleado'
        ELSE '❌ Rol desconocido'
    END as role_status
FROM employees 
WHERE id = auth.uid()::integer;

-- =====================================================
-- 7. VERIFICAR POLÍTICAS ESPECÍFICAS
-- =====================================================

-- Verificar políticas de productos
SELECT 
    'Productos - Lectura' as politica,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_policies 
            WHERE tablename = 'products' 
            AND policyname LIKE '%read%'
        ) THEN '✅ Política de lectura existe'
        ELSE '❌ Política de lectura no encontrada'
    END as status
UNION ALL
SELECT 
    'Productos - Inserción' as politica,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_policies 
            WHERE tablename = 'products' 
            AND policyname LIKE '%insert%'
        ) THEN '✅ Política de inserción existe'
        ELSE '❌ Política de inserción no encontrada'
    END as status;

-- =====================================================
-- 8. VERIFICAR INTEGRIDAD DE DATOS
-- =====================================================

-- Verificar que no hay datos huérfanos
SELECT 
    'Productos sin tienda válida' as problema,
    COUNT(*) as cantidad
FROM products p
LEFT JOIN stores s ON p.store_id = s.id
WHERE p.store_id IS NOT NULL AND s.id IS NULL
UNION ALL
SELECT 
    'Productos sin almacén válido' as problema,
    COUNT(*) as cantidad
FROM products p
LEFT JOIN warehouses w ON p.warehouse_id = w.id
WHERE p.warehouse_id IS NOT NULL AND w.id IS NULL
UNION ALL
SELECT 
    'Ventas sin tienda válida' as problema,
    COUNT(*) as cantidad
FROM sales sa
LEFT JOIN stores s ON sa.store_id = s.id
WHERE sa.store_id IS NOT NULL AND s.id IS NULL
UNION ALL
SELECT 
    'Compras sin almacén válido' as problema,
    COUNT(*) as cantidad
FROM purchases pu
LEFT JOIN warehouses w ON pu.warehouse_id = w.id
WHERE pu.warehouse_id IS NOT NULL AND w.id IS NULL;

-- =====================================================
-- 9. VERIFICAR RENDIMIENTO
-- =====================================================

-- Verificar estadísticas de tablas
SELECT 
    schemaname,
    tablename,
    n_tup_ins as inserts,
    n_tup_upd as updates,
    n_tup_del as deletes,
    n_live_tup as registros_activos,
    n_dead_tup as registros_eliminados
FROM pg_stat_user_tables 
WHERE schemaname = 'public'
AND tablename IN ('products', 'stores', 'warehouses', 'employees', 'sales', 'purchases', 'transfers')
ORDER BY tablename;

-- =====================================================
-- 10. VERIFICAR LOGS DE AUDITORÍA
-- =====================================================

-- Verificar si la tabla de logs existe y tiene datos
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'transaction_logs') 
        THEN '✅ Tabla de logs existe'
        ELSE '❌ Tabla de logs no existe'
    END as tabla_logs,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'transaction_logs') 
        THEN (SELECT COUNT(*)::text FROM transaction_logs)
        ELSE 'N/A'
    END as registros_logs;

-- =====================================================
-- 11. RESUMEN DE VERIFICACIÓN
-- =====================================================

-- Crear resumen de verificación
WITH verification_summary AS (
    SELECT 
        'RLS Habilitado' as item,
        COUNT(*) as total,
        COUNT(*) FILTER (WHERE rowsecurity = true) as habilitado,
        COUNT(*) FILTER (WHERE rowsecurity = false) as deshabilitado
    FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename IN ('products', 'stores', 'warehouses', 'employees', 'sales', 'purchases', 'transfers')
    
    UNION ALL
    
    SELECT 
        'Políticas Creadas' as item,
        COUNT(*) as total,
        COUNT(*) as habilitado,
        0 as deshabilitado
    FROM pg_policies 
    WHERE schemaname = 'public'
    AND tablename IN ('products', 'stores', 'warehouses', 'employees', 'sales', 'purchases', 'transfers')
    
    UNION ALL
    
    SELECT 
        'Funciones de Utilidad' as item,
        COUNT(*) as total,
        COUNT(*) as habilitado,
        0 as deshabilitado
    FROM information_schema.routines 
    WHERE routine_schema = 'public'
    AND routine_name IN ('is_admin', 'get_current_employee_id', 'can_access_store', 'can_access_warehouse', 'get_current_user_role')
)
SELECT 
    item,
    total,
    habilitado,
    deshabilitado,
    CASE 
        WHEN deshabilitado = 0 THEN '✅ Todo correcto'
        ELSE '❌ Revisar configuración'
    END as status
FROM verification_summary
ORDER BY item;

-- =====================================================
-- NOTAS DE VERIFICACIÓN
-- =====================================================

/*
INSTRUCCIONES DE VERIFICACIÓN:

1. EJECUTAR ESTE SCRIPT:
   - Ejecutar en Supabase SQL Editor
   - Verificar que no haya errores
   - Revisar los resultados

2. VERIFICAR FUNCIONALIDAD:
   - Probar lectura de datos
   - Probar inserción de datos
   - Probar actualización de datos
   - Verificar que no haya errores de permisos

3. SI HAY PROBLEMAS:
   - Revisar políticas específicas
   - Verificar roles de usuario
   - Ajustar políticas según necesidades

4. MANTENIMIENTO:
   - Ejecutar este script periódicamente
   - Monitorear logs de auditoría
   - Ajustar políticas según cambios en el sistema
*/
