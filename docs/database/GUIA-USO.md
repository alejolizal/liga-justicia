# Guía de Uso del Modelo de Datos

## Índice
1. [Inicialización de Base de Datos](#inicialización-de-base-de-datos)
2. [Casos de Uso Comunes](#casos-de-uso-comunes)
3. [Consultas Útiles](#consultas-útiles)
4. [Mejores Prácticas](#mejores-prácticas)
5. [Ejemplos Prácticos](#ejemplos-prácticos)

---

## Inicialización de Base de Datos

### PostgreSQL (Producción)

```bash
# 1. Crear base de datos
createdb menu_admin

# 2. Conectar a la base de datos
psql menu_admin

# 3. Ejecutar script de schema
\i docs/database/schema-postgresql.sql

# 4. (Opcional) Cargar datos de ejemplo
\i docs/database/sample-data.sql
```

### H2 (Pruebas)

```bash
# El schema se carga automáticamente al iniciar la aplicación
# Configuración en application.properties:

spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=create-drop
spring.sql.init.mode=always
spring.sql.init.data-locations=classpath:data.sql
```

---

## Casos de Uso Comunes

### 1. Agregar un Nuevo Negocio

```sql
-- Paso 1: Crear el negocio
INSERT INTO negocio (codigo, nombre, descripcion, activo)
VALUES ('ACME_CORP', 'ACME Corporation', 'Empresa de tecnología', TRUE);

-- Verificar creación
SELECT * FROM negocio WHERE codigo = 'ACME_CORP';
```

### 2. Agregar un Sistema a un Negocio

```sql
-- Paso 1: Obtener ID del negocio
SELECT id FROM negocio WHERE codigo = 'ACME_CORP';

-- Paso 2: Crear el sistema
INSERT INTO sistema (codigo, nombre, descripcion, url_base, activo, negocio_id)
VALUES ('PORTAL', 'Portal Corporativo', 'Portal web de la empresa', 
        'https://portal.acme.com', TRUE, 1);

-- Verificar creación
SELECT s.*, n.nombre as negocio_nombre
FROM sistema s
JOIN negocio n ON s.negocio_id = n.id
WHERE s.codigo = 'PORTAL';
```

### 3. Crear Estructura de Menús

```sql
-- Paso 1: Crear menú principal
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id)
VALUES ('MENU_PRINCIPAL', 'Menú Principal', 'Menú principal del portal', 1, TRUE, 1);

-- Paso 2: Crear sub-menú
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id, menu_padre_id)
VALUES ('MENU_ADMIN', 'Administración', 'Menú de administración', 1, TRUE, 1, 1);

-- Verificar jerarquía
SELECT 
    m1.nombre as menu_principal,
    m2.nombre as submenu
FROM menu m1
LEFT JOIN menu m2 ON m2.menu_padre_id = m1.id
WHERE m1.menu_padre_id IS NULL
ORDER BY m1.orden, m2.orden;
```

### 4. Agregar Opciones a un Menú

```sql
-- Crear opciones para un menú
INSERT INTO opcion (codigo, nombre, url, icono, orden, tipo_accion, activo, menu_id)
VALUES 
    ('OPC_INICIO', 'Inicio', '/home', 'icon-home', 1, 'NAVEGACION', TRUE, 1),
    ('OPC_PERFIL', 'Mi Perfil', '/perfil', 'icon-user', 2, 'NAVEGACION', TRUE, 1),
    ('OPC_CONFIGURACION', 'Configuración', '/config', 'icon-settings', 3, 'NAVEGACION', TRUE, 1);

-- Verificar opciones del menú
SELECT o.*, m.nombre as menu_nombre
FROM opcion o
JOIN menu m ON o.menu_id = m.id
WHERE m.id = 1
ORDER BY o.orden;
```

### 5. Crear y Asignar Roles

```sql
-- Paso 1: Crear rol
INSERT INTO rol (codigo, nombre, descripcion, activo)
VALUES ('GERENTE', 'Gerente', 'Personal de gerencia', TRUE);

-- Paso 2: Crear usuario
INSERT INTO usuario (username, nombre, email, activo)
VALUES ('jsmith', 'John Smith', 'jsmith@acme.com', TRUE);

-- Paso 3: Asignar rol a usuario
INSERT INTO usuario_rol (usuario_id, rol_id)
VALUES (1, 1);

-- Verificar asignación
SELECT u.username, u.nombre, r.nombre as rol
FROM usuario u
JOIN usuario_rol ur ON u.id = ur.usuario_id
JOIN rol r ON ur.rol_id = r.id
WHERE u.username = 'jsmith';
```

### 6. Configurar Reglas de Visibilidad

```sql
-- Regla simple: Rol puede ver opción
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES (1, 1, TRUE, TRUE, 'ROL');

-- Regla de solo lectura: Visible pero no habilitado
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES (2, 2, TRUE, FALSE, 'ROL');

-- Regla personalizada con expresión
INSERT INTO visibilidad (opcion_id, visible, habilitado, tipo_regla, expresion_regla)
VALUES (3, TRUE, TRUE, 'PERSONALIZADO', 
        '{"condiciones": [{"campo": "departamento", "valor": "IT"}]}');

-- Verificar reglas
SELECT 
    o.nombre as opcion,
    r.nombre as rol,
    v.visible,
    v.habilitado,
    v.tipo_regla
FROM visibilidad v
JOIN opcion o ON v.opcion_id = o.id
LEFT JOIN rol r ON v.rol_id = r.id;
```

---

## Consultas Útiles

### Consulta 1: Menús Visibles para un Usuario

```sql
-- Obtener todos los menús y opciones visibles para un usuario específico
SELECT DISTINCT
    m.id as menu_id,
    m.nombre as menu_nombre,
    m.orden as menu_orden,
    o.id as opcion_id,
    o.nombre as opcion_nombre,
    o.url,
    o.icono,
    o.orden as opcion_orden,
    v.visible,
    v.habilitado
FROM usuario u
JOIN usuario_rol ur ON u.id = ur.usuario_id
JOIN rol r ON ur.rol_id = r.id
JOIN visibilidad v ON r.id = v.rol_id
JOIN opcion o ON v.opcion_id = o.id
JOIN menu m ON o.menu_id = m.id
WHERE u.username = 'superman'  -- Cambiar por el usuario deseado
  AND v.visible = TRUE
  AND m.activo = TRUE
  AND o.activo = TRUE
ORDER BY m.orden, o.orden;
```

### Consulta 2: Jerarquía Completa de Menús

```sql
-- Obtener jerarquía completa de menús con recursión
WITH RECURSIVE menu_tree AS (
    -- Menús raíz
    SELECT 
        id,
        codigo,
        nombre,
        menu_padre_id,
        sistema_id,
        0 as nivel,
        CAST(nombre AS VARCHAR(500)) as ruta
    FROM menu
    WHERE menu_padre_id IS NULL
    
    UNION ALL
    
    -- Sub-menús
    SELECT 
        m.id,
        m.codigo,
        m.nombre,
        m.menu_padre_id,
        m.sistema_id,
        mt.nivel + 1,
        CAST(mt.ruta || ' > ' || m.nombre AS VARCHAR(500))
    FROM menu m
    JOIN menu_tree mt ON m.menu_padre_id = mt.id
)
SELECT 
    nivel,
    REPEAT('  ', nivel) || nombre as menu_jerarquico,
    ruta
FROM menu_tree
ORDER BY ruta;
```

### Consulta 3: Estadísticas de Acceso por Usuario

```sql
-- Top 10 usuarios con más accesos
SELECT 
    u.username,
    u.nombre,
    COUNT(a.id) as total_accesos,
    COUNT(DISTINCT a.opcion_id) as opciones_distintas,
    MAX(a.fecha_acceso) as ultimo_acceso
FROM usuario u
JOIN acceso a ON u.id = a.usuario_id
GROUP BY u.id, u.username, u.nombre
ORDER BY total_accesos DESC
LIMIT 10;
```

### Consulta 4: Opciones Más Accedidas

```sql
-- Top 10 opciones más populares
SELECT 
    o.nombre as opcion,
    m.nombre as menu,
    COUNT(a.id) as total_accesos,
    COUNT(DISTINCT a.usuario_id) as usuarios_unicos
FROM opcion o
JOIN menu m ON o.menu_id = m.id
LEFT JOIN acceso a ON o.id = a.opcion_id
GROUP BY o.id, o.nombre, m.nombre
ORDER BY total_accesos DESC
LIMIT 10;
```

### Consulta 5: Auditoría de Accesos Fallidos

```sql
-- Accesos fallidos en las últimas 24 horas
SELECT 
    u.username,
    o.nombre as opcion,
    a.fecha_acceso,
    a.ip_address,
    a.accion_realizada
FROM acceso a
JOIN usuario u ON a.usuario_id = u.id
LEFT JOIN opcion o ON a.opcion_id = o.id
WHERE a.exitoso = FALSE
  AND a.fecha_acceso > CURRENT_TIMESTAMP - INTERVAL '24 hours'
ORDER BY a.fecha_acceso DESC;
```

### Consulta 6: Usuarios Sin Rol Asignado

```sql
-- Encontrar usuarios sin roles
SELECT 
    u.id,
    u.username,
    u.nombre,
    u.email
FROM usuario u
LEFT JOIN usuario_rol ur ON u.id = ur.usuario_id
WHERE ur.usuario_id IS NULL
  AND u.activo = TRUE;
```

### Consulta 7: Opciones Sin Reglas de Visibilidad

```sql
-- Encontrar opciones sin reglas de visibilidad configuradas
SELECT 
    o.id,
    o.codigo,
    o.nombre,
    m.nombre as menu,
    s.nombre as sistema
FROM opcion o
JOIN menu m ON o.menu_id = m.id
JOIN sistema s ON m.sistema_id = s.id
LEFT JOIN visibilidad v ON o.id = v.opcion_id
WHERE v.id IS NULL
  AND o.activo = TRUE;
```

---

## Mejores Prácticas

### 1. Nomenclatura

```sql
-- ✅ CORRECTO: Usar códigos descriptivos y únicos
INSERT INTO negocio (codigo, nombre) VALUES ('TECH_CORP', 'Technology Corporation');

-- ❌ INCORRECTO: Códigos genéricos o poco descriptivos
INSERT INTO negocio (codigo, nombre) VALUES ('NEG1', 'Technology Corporation');
```

### 2. Soft Delete

```sql
-- ✅ CORRECTO: Desactivar en lugar de eliminar
UPDATE negocio SET activo = FALSE WHERE id = 1;

-- ❌ INCORRECTO: Eliminar físicamente (puede romper integridad referencial)
DELETE FROM negocio WHERE id = 1;
```

### 3. Orden de Elementos

```sql
-- ✅ CORRECTO: Usar números con espacio para reordenar
INSERT INTO menu (codigo, nombre, orden, sistema_id) VALUES
('MENU1', 'Primero', 10, 1),
('MENU2', 'Segundo', 20, 1),
('MENU3', 'Tercero', 30, 1);

-- Ahora puedes insertar entre ellos sin renumerar todo
INSERT INTO menu (codigo, nombre, orden, sistema_id) 
VALUES ('MENU1.5', 'Entre Primero y Segundo', 15, 1);
```

### 4. Reglas de Visibilidad

```sql
-- ✅ CORRECTO: Definir reglas específicas para cada rol
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES (1, 1, TRUE, TRUE, 'ROL');  -- Admin

INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES (1, 2, TRUE, FALSE, 'ROL');  -- Usuario (solo lectura)

-- ❌ INCORRECTO: Asumir que sin regla = sin acceso
-- Mejor: Configurar explícitamente todas las reglas
```

### 5. Auditoría

```sql
-- ✅ CORRECTO: Registrar información completa
INSERT INTO acceso (usuario_id, opcion_id, ip_address, user_agent, accion_realizada, exitoso)
VALUES (1, 1, '192.168.1.100', 'Mozilla/5.0...', 'Creación de usuario', TRUE);

-- ❌ INCORRECTO: Datos incompletos
INSERT INTO acceso (usuario_id, opcion_id)
VALUES (1, 1);
```

---

## Ejemplos Prácticos

### Ejemplo 1: Sistema Completo de E-Commerce

```sql
-- 1. Crear negocio
INSERT INTO negocio (codigo, nombre, descripcion) 
VALUES ('ECOMMERCE', 'Mi Tienda Online', 'Plataforma de comercio electrónico');

-- 2. Crear sistema
INSERT INTO sistema (codigo, nombre, url_base, negocio_id)
VALUES ('ADMIN_PANEL', 'Panel de Administración', 'https://admin.mitienda.com', 1);

-- 3. Crear menús
INSERT INTO menu (codigo, nombre, orden, sistema_id) VALUES
('PRODUCTOS', 'Productos', 1, 1),
('PEDIDOS', 'Pedidos', 2, 1),
('CLIENTES', 'Clientes', 3, 1),
('REPORTES', 'Reportes', 4, 1);

-- 4. Crear opciones de productos
INSERT INTO opcion (codigo, nombre, url, icono, orden, tipo_accion, menu_id) VALUES
('PROD_NUEVO', 'Nuevo Producto', '/productos/nuevo', 'icon-plus', 1, 'NAVEGACION', 1),
('PROD_LISTA', 'Lista de Productos', '/productos/lista', 'icon-list', 2, 'NAVEGACION', 1),
('PROD_CATEGORIAS', 'Categorías', '/productos/categorias', 'icon-folder', 3, 'NAVEGACION', 1);

-- 5. Crear roles
INSERT INTO rol (codigo, nombre) VALUES
('ADMIN_ECOMMERCE', 'Administrador de Tienda'),
('VENDEDOR', 'Vendedor'),
('INVENTARIO', 'Gestor de Inventario');

-- 6. Configurar visibilidad
-- Admin ve todo
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
SELECT id, 1, TRUE, TRUE, 'ROL' FROM opcion WHERE menu_id IN (1,2,3,4);

-- Vendedor solo ve pedidos y clientes
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
SELECT id, 2, TRUE, TRUE, 'ROL' FROM opcion WHERE menu_id IN (2,3);

-- Inventario solo ve productos
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
SELECT id, 3, TRUE, TRUE, 'ROL' FROM opcion WHERE menu_id = 1;
```

### Ejemplo 2: Sistema Multi-Tenant

```sql
-- Crear múltiples negocios (tenants)
INSERT INTO negocio (codigo, nombre) VALUES
('TENANT_A', 'Empresa A'),
('TENANT_B', 'Empresa B'),
('TENANT_C', 'Empresa C');

-- Crear mismo sistema para cada tenant
INSERT INTO sistema (codigo, nombre, negocio_id)
SELECT 'CRM', 'Sistema CRM', id FROM negocio;

-- Verificar aislamiento
SELECT n.nombre as negocio, s.nombre as sistema
FROM sistema s
JOIN negocio n ON s.negocio_id = n.id
ORDER BY n.nombre;
```

### Ejemplo 3: Migración de Usuarios Entre Roles

```sql
-- Cambiar usuarios de rol "USUARIO" a "PREMIUM"
BEGIN;

-- Crear nuevo rol si no existe
INSERT INTO rol (codigo, nombre, descripcion)
VALUES ('PREMIUM', 'Usuario Premium', 'Usuario con funcionalidades premium')
ON CONFLICT (codigo) DO NOTHING;

-- Migrar usuarios
UPDATE usuario_rol ur
SET rol_id = (SELECT id FROM rol WHERE codigo = 'PREMIUM')
WHERE ur.rol_id = (SELECT id FROM rol WHERE codigo = 'USUARIO')
  AND ur.usuario_id IN (
    SELECT id FROM usuario WHERE email LIKE '%@premium.com'
  );

COMMIT;
```

---

## Mantenimiento

### Limpieza de Registros de Acceso Antiguos

```sql
-- Eliminar accesos de más de 90 días
DELETE FROM acceso 
WHERE fecha_acceso < CURRENT_TIMESTAMP - INTERVAL '90 days';

-- O crear una función para archivar
CREATE TABLE acceso_historico AS SELECT * FROM acceso WHERE 1=0;

INSERT INTO acceso_historico
SELECT * FROM acceso 
WHERE fecha_acceso < CURRENT_TIMESTAMP - INTERVAL '90 days';

DELETE FROM acceso 
WHERE fecha_acceso < CURRENT_TIMESTAMP - INTERVAL '90 days';
```

### Reindexación

```sql
-- PostgreSQL: Reindexar todas las tablas
REINDEX DATABASE menu_admin;

-- O tablas específicas
REINDEX TABLE acceso;
```

### Análisis de Rendimiento

```sql
-- Analizar tablas para optimizar consultas
ANALYZE negocio;
ANALYZE sistema;
ANALYZE menu;
ANALYZE opcion;
ANALYZE usuario;
ANALYZE rol;
ANALYZE visibilidad;
ANALYZE acceso;
```

---

## Troubleshooting

### Problema: Usuario no ve opciones de menú

```sql
-- Diagnóstico
-- 1. Verificar que el usuario tiene roles
SELECT u.username, r.nombre as rol
FROM usuario u
LEFT JOIN usuario_rol ur ON u.id = ur.usuario_id
LEFT JOIN rol r ON ur.rol_id = r.id
WHERE u.username = 'usuario_problema';

-- 2. Verificar reglas de visibilidad para ese rol
SELECT o.nombre, v.visible, v.habilitado
FROM visibilidad v
JOIN opcion o ON v.opcion_id = o.id
WHERE v.rol_id IN (
    SELECT rol_id FROM usuario_rol WHERE usuario_id = 
    (SELECT id FROM usuario WHERE username = 'usuario_problema')
);
```

### Problema: Jerarquía de menús no se muestra correctamente

```sql
-- Verificar integridad de referencias
SELECT m1.nombre as menu, m2.nombre as menu_padre
FROM menu m1
LEFT JOIN menu m2 ON m1.menu_padre_id = m2.id
WHERE m1.menu_padre_id IS NOT NULL;

-- Detectar referencias huérfanas
SELECT * FROM menu 
WHERE menu_padre_id IS NOT NULL 
  AND menu_padre_id NOT IN (SELECT id FROM menu);
```

---

## Recursos Adicionales

- **Diagrama ER**: `docs/database/ER-DIAGRAM.md`
- **Schema DDL**: `docs/database/schema-postgresql.sql`
- **Datos de Ejemplo**: `docs/database/sample-data.sql`
- **Documentación Completa**: `docs/database/README.md`
