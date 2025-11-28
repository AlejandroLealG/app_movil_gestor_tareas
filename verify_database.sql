-- Script de verificación de la base de datos
-- Ejecuta este script después de crear la base de datos para verificar que todo esté correcto

USE gestor_tareas_academicas;

-- Verificar que las tablas existan
SELECT 'Verificando tablas...' as estado;
SHOW TABLES;

-- Verificar estructura de la tabla usuarios
SELECT 'Estructura de la tabla USUARIOS:' as info;
DESCRIBE usuarios;

-- Verificar estructura de la tabla tareas
SELECT 'Estructura de la tabla TAREAS:' as info;
DESCRIBE tareas;

-- Verificar estructura de la tabla sesiones
SELECT 'Estructura de la tabla SESIONES:' as info;
DESCRIBE sesiones;

-- Verificar índices
SELECT 'Índices de la tabla USUARIOS:' as info;
SHOW INDEXES FROM usuarios;

SELECT 'Índices de la tabla TAREAS:' as info;
SHOW INDEXES FROM tareas;

SELECT 'Índices de la tabla SESIONES:' as info;
SHOW INDEXES FROM sesiones;

-- Verificar claves foráneas
SELECT 'Claves foráneas:' as info;
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
    TABLE_SCHEMA = 'gestor_tareas_academicas'
    AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Verificar datos de ejemplo
SELECT 'Datos de ejemplo - USUARIOS:' as info;
SELECT id, nombre, email, usuario, created_at FROM usuarios;

SELECT 'Datos de ejemplo - TAREAS:' as info;
SELECT 
    t.id,
    t.titulo,
    t.materia,
    t.fecha_entrega,
    t.prioridad,
    t.estado,
    u.nombre as usuario
FROM tareas t
JOIN usuarios u ON t.usuario_id = u.id;

-- Verificar conteo de registros
SELECT 'Conteo de registros:' as info;
SELECT 
    'usuarios' as tabla,
    COUNT(*) as total
FROM usuarios
UNION ALL
SELECT 
    'tareas' as tabla,
    COUNT(*) as total
FROM tareas
UNION ALL
SELECT 
    'sesiones' as tabla,
    COUNT(*) as total
FROM sesiones;

-- Verificar integridad referencial
SELECT 'Verificando integridad referencial...' as estado;
SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ Todas las tareas tienen usuarios válidos'
        ELSE CONCAT('✗ ERROR: ', COUNT(*), ' tareas con usuario_id inválido')
    END as resultado
FROM tareas t
LEFT JOIN usuarios u ON t.usuario_id = u.id
WHERE u.id IS NULL;

SELECT 
    CASE 
        WHEN COUNT(*) = 0 THEN '✓ Todas las sesiones tienen usuarios válidos'
        ELSE CONCAT('✗ ERROR: ', COUNT(*), ' sesiones con usuario_id inválido')
    END as resultado
FROM sesiones s
LEFT JOIN usuarios u ON s.usuario_id = u.id
WHERE u.id IS NULL;

-- Resumen final
SELECT '=== RESUMEN DE VERIFICACIÓN ===' as resumen;
SELECT 
    'Base de datos' as componente,
    'gestor_tareas_academicas' as estado,
    '✓ Configurada' as resultado
UNION ALL
SELECT 
    'Tablas creadas' as componente,
    CONCAT(COUNT(*), ' tablas') as estado,
    CASE WHEN COUNT(*) = 3 THEN '✓ Correcto' ELSE '✗ Faltan tablas' END as resultado
FROM information_schema.tables
WHERE table_schema = 'gestor_tareas_academicas'
UNION ALL
SELECT 
    'Usuarios de ejemplo' as componente,
    CONCAT(COUNT(*), ' usuarios') as estado,
    CASE WHEN COUNT(*) >= 3 THEN '✓ Correcto' ELSE '✗ Faltan datos' END as resultado
FROM usuarios
UNION ALL
SELECT 
    'Tareas de ejemplo' as componente,
    CONCAT(COUNT(*), ' tareas') as estado,
    CASE WHEN COUNT(*) >= 5 THEN '✓ Correcto' ELSE '✗ Faltan datos' END as resultado
FROM tareas;

