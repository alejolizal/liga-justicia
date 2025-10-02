# Modelo de Datos - Sistema de Administración de Menús

## Descripción General

Este documento describe el modelo de datos diseñado para un **Sistema de Administración de Menús** que permite gestionar la estructura de navegación de múltiples sistemas dentro de diferentes negocios u organizaciones.

## Objetivos del Modelo

1. **Jerarquía Multi-nivel**: Soportar negocios → sistemas → menús → opciones
2. **Flexibilidad**: Permitir menús y opciones anidados con múltiples niveles
3. **Control de Acceso**: Gestión de usuarios, roles y visibilidad de opciones
4. **Extensibilidad**: Arquitectura preparada para futuras reglas de visibilidad
5. **Auditoría**: Registro completo de accesos y acciones

## Entidades Principales

### 1. Negocio
Representa una organización o empresa que agrupa múltiples sistemas.

**Atributos clave:**
- `codigo`: Identificador único del negocio
- `nombre`: Nombre de la organización
- `activo`: Estado del negocio

**Caso de uso:** Permite separar sistemas de diferentes empresas o divisiones.

### 2. Sistema
Representa una aplicación o módulo dentro de un negocio.

**Atributos clave:**
- `codigo`: Identificador único dentro del negocio
- `nombre`: Nombre del sistema
- `url_base`: URL base del sistema
- `negocio_id`: Relación con el negocio

**Caso de uso:** Un negocio puede tener sistemas como "ERP", "CRM", "Portal", etc.

### 3. Menu
Representa un menú dentro de un sistema. Soporta jerarquía mediante auto-referencia.

**Atributos clave:**
- `codigo`: Identificador único dentro del sistema
- `nombre`: Nombre del menú
- `orden`: Orden de visualización
- `sistema_id`: Relación con el sistema
- `menu_padre_id`: Referencia al menú padre (para sub-menús)

**Caso de uso:** Permite crear menús principales y sub-menús anidados.

### 4. Opcion
Representa una opción dentro de un menú (enlace, acción, etc.). Soporta jerarquía.

**Atributos clave:**
- `codigo`: Identificador único dentro del menú
- `nombre`: Nombre de la opción
- `url`: URL de destino
- `icono`: Icono asociado
- `orden`: Orden de visualización
- `tipo_accion`: Tipo de acción ("NAVEGACION", "MODAL", "ACCION_BACKEND")
- `menu_id`: Relación con el menú
- `opcion_padre_id`: Referencia a opción padre

**Caso de uso:** Items clickeables en el menú con acciones específicas.

### 5. Usuario
Representa un usuario del sistema.

**Atributos clave:**
- `username`: Nombre de usuario único
- `email`: Email del usuario
- `password_hash`: Hash de la contraseña
- `activo`: Estado del usuario
- `ultimo_acceso`: Timestamp del último acceso

**Caso de uso:** Identifica a las personas que acceden al sistema.

### 6. Rol
Representa un rol o perfil de usuario.

**Atributos clave:**
- `codigo`: Código único del rol
- `nombre`: Nombre del rol
- `descripcion`: Descripción del rol

**Caso de uso:** Agrupa permisos (ej: "ADMIN", "USUARIO", "INVITADO").

### 7. Visibilidad
Define reglas de visibilidad para opciones de menú según roles.

**Atributos clave:**
- `visible`: Si la opción es visible
- `habilitado`: Si la opción está habilitada
- `tipo_regla`: Tipo de regla ("ROL", "NEGOCIO", "PERSONALIZADO")
- `expresion_regla`: Expresión para reglas complejas
- `opcion_id`: Relación con la opción
- `rol_id`: Relación con el rol (opcional)

**Caso de uso:** Controlar qué opciones ve cada rol.

### 8. Acceso
Registra el historial de accesos para auditoría.

**Atributos clave:**
- `fecha_acceso`: Timestamp del acceso
- `ip_address`: Dirección IP
- `user_agent`: User agent del navegador
- `accion_realizada`: Descripción de la acción
- `exitoso`: Si el acceso fue exitoso
- `usuario_id`: Relación con el usuario
- `opcion_id`: Relación con la opción

**Caso de uso:** Auditoría y análisis de uso.

## Relaciones

```
Negocio (1) ──→ (N) Sistema
Sistema (1) ──→ (N) Menu
Menu (1) ──→ (N) Opcion
Menu (1) ──→ (N) Menu (auto-referencia para jerarquía)
Opcion (1) ──→ (N) Opcion (auto-referencia para jerarquía)
Opcion (1) ──→ (N) Visibilidad
Rol (1) ──→ (N) Visibilidad
Usuario (N) ←→ (N) Rol (relación muchos a muchos)
Usuario (1) ──→ (N) Acceso
Opcion (1) ──→ (N) Acceso
```

## Características de Extensibilidad

### 1. Jerarquías Flexibles
Las entidades Menu y Opcion soportan jerarquías ilimitadas mediante auto-referencia:
- Un menú puede contener sub-menús
- Una opción puede contener sub-opciones

### 2. Reglas de Visibilidad Extensibles
La tabla Visibilidad está diseñada para soportar múltiples tipos de reglas:

**Ejemplo 1: Regla basada en Rol**
```sql
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES (1, 1, TRUE, TRUE, 'ROL');
```

**Ejemplo 2: Regla personalizada con expresión JSON**
```sql
INSERT INTO visibilidad (opcion_id, visible, habilitado, tipo_regla, expresion_regla)
VALUES (2, TRUE, TRUE, 'PERSONALIZADO', '{"departamento": "IT", "nivel": "senior"}');
```

**Ejemplo 3: Regla basada en Negocio**
```sql
INSERT INTO visibilidad (opcion_id, visible, habilitado, tipo_regla, expresion_regla)
VALUES (3, TRUE, TRUE, 'NEGOCIO', '{"negocio_ids": [1, 2, 3]}');
```

### 3. Integración de Nuevos Sistemas
Para integrar un nuevo sistema:

1. Crear entrada en tabla `negocio` (si es nueva organización)
2. Crear entrada en tabla `sistema` vinculada al negocio
3. Definir estructura de menús en tabla `menu`
4. Agregar opciones en tabla `opcion`
5. Configurar reglas de visibilidad en tabla `visibilidad`

## Ejemplo de Datos

### Ejemplo Completo: Sistema ERP para Empresa XYZ

```sql
-- 1. Crear negocio
INSERT INTO negocio (codigo, nombre, descripcion, activo)
VALUES ('EMP_XYZ', 'Empresa XYZ S.A.', 'Empresa de tecnología', TRUE);

-- 2. Crear sistema
INSERT INTO sistema (codigo, nombre, url_base, negocio_id)
VALUES ('ERP_01', 'Sistema ERP', 'https://erp.empresaxyz.com', 1);

-- 3. Crear menús principales
INSERT INTO menu (codigo, nombre, orden, sistema_id)
VALUES 
  ('MENU_VENTAS', 'Ventas', 1, 1),
  ('MENU_INVENTARIO', 'Inventario', 2, 1),
  ('MENU_REPORTES', 'Reportes', 3, 1);

-- 4. Crear sub-menú
INSERT INTO menu (codigo, nombre, orden, sistema_id, menu_padre_id)
VALUES ('MENU_REPORTES_FINANCIEROS', 'Reportes Financieros', 1, 1, 3);

-- 5. Crear opciones
INSERT INTO opcion (codigo, nombre, url, icono, orden, tipo_accion, menu_id)
VALUES 
  ('OPC_NUEVA_VENTA', 'Nueva Venta', '/ventas/nueva', 'icon-plus', 1, 'NAVEGACION', 1),
  ('OPC_LISTAR_VENTAS', 'Listar Ventas', '/ventas/listar', 'icon-list', 2, 'NAVEGACION', 1),
  ('OPC_PRODUCTOS', 'Productos', '/inventario/productos', 'icon-box', 1, 'NAVEGACION', 2);

-- 6. Crear roles
INSERT INTO rol (codigo, nombre, descripcion)
VALUES 
  ('ADMIN', 'Administrador', 'Acceso completo al sistema'),
  ('VENDEDOR', 'Vendedor', 'Acceso a módulo de ventas'),
  ('ALMACENISTA', 'Almacenista', 'Acceso a módulo de inventario');

-- 7. Crear usuarios
INSERT INTO usuario (username, nombre, email, activo)
VALUES 
  ('jdoe', 'John Doe', 'jdoe@empresaxyz.com', TRUE),
  ('msmith', 'Mary Smith', 'msmith@empresaxyz.com', TRUE);

-- 8. Asignar roles a usuarios
INSERT INTO usuario_rol (usuario_id, rol_id)
VALUES 
  (1, 1), -- John es Admin
  (2, 2); -- Mary es Vendedor

-- 9. Configurar visibilidad por rol
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla)
VALUES 
  (1, 1, TRUE, TRUE, 'ROL'), -- Admin puede crear ventas
  (1, 2, TRUE, TRUE, 'ROL'), -- Vendedor puede crear ventas
  (2, 1, TRUE, TRUE, 'ROL'), -- Admin puede listar ventas
  (2, 2, TRUE, TRUE, 'ROL'), -- Vendedor puede listar ventas
  (3, 1, TRUE, TRUE, 'ROL'), -- Admin puede ver productos
  (3, 3, TRUE, TRUE, 'ROL'); -- Almacenista puede ver productos

-- 10. Registrar acceso (se genera automáticamente al usar el sistema)
INSERT INTO acceso (usuario_id, opcion_id, ip_address, accion_realizada, exitoso)
VALUES (1, 1, '192.168.1.100', 'Acceso a Nueva Venta', TRUE);
```

## Consultas Útiles

### Obtener menús visibles para un usuario

```sql
SELECT DISTINCT m.*, o.*
FROM menu m
JOIN opcion o ON o.menu_id = m.id
JOIN visibilidad v ON v.opcion_id = o.id
JOIN usuario_rol ur ON ur.rol_id = v.rol_id
WHERE ur.usuario_id = ? 
  AND v.visible = TRUE
  AND m.activo = TRUE
  AND o.activo = TRUE
ORDER BY m.orden, o.orden;
```

### Obtener jerarquía completa de menús de un sistema

```sql
WITH RECURSIVE menu_hierarchy AS (
  -- Menús principales
  SELECT id, codigo, nombre, sistema_id, menu_padre_id, 0 as nivel
  FROM menu
  WHERE sistema_id = ? AND menu_padre_id IS NULL
  
  UNION ALL
  
  -- Sub-menús
  SELECT m.id, m.codigo, m.nombre, m.sistema_id, m.menu_padre_id, mh.nivel + 1
  FROM menu m
  JOIN menu_hierarchy mh ON m.menu_padre_id = mh.id
)
SELECT * FROM menu_hierarchy ORDER BY nivel, orden;
```

### Auditoría de accesos por usuario

```sql
SELECT u.username, o.nombre as opcion, a.fecha_acceso, a.accion_realizada
FROM acceso a
JOIN usuario u ON a.usuario_id = u.id
LEFT JOIN opcion o ON a.opcion_id = o.id
WHERE u.id = ?
ORDER BY a.fecha_acceso DESC
LIMIT 100;
```

## Archivos del Modelo

- **`schema-postgresql.sql`**: Script DDL para PostgreSQL (producción)
- **`schema-h2.sql`**: Script DDL para H2 Database (pruebas)
- **`ER-DIAGRAM.md`**: Diagrama entidad-relación detallado

## Tecnologías

- **Base de datos de producción**: PostgreSQL 12+
- **Base de datos de pruebas**: H2 Database (modo PostgreSQL)
- **ORM**: JPA 2.2 / Hibernate 5.x
- **Lenguaje**: Java 8+

## Consideraciones de Implementación

### 1. Soft Delete
Todas las entidades principales incluyen el campo `activo` para permitir soft delete:
- No se eliminan registros físicamente
- Se marca `activo = FALSE` cuando se "elimina"
- Las consultas filtran por `activo = TRUE`

### 2. Auditoría Temporal
Todas las entidades incluyen:
- `fecha_creacion`: Se establece automáticamente al crear
- `fecha_modificacion`: Se actualiza automáticamente al modificar

### 3. Índices
Se han definido índices estratégicos para optimizar:
- Búsquedas por código
- Filtros por estado activo
- Ordenamiento por campo orden
- Joins por claves foráneas
- Consultas de auditoría por fecha

### 4. Constraints de Unicidad
Se garantiza unicidad mediante constraints compuestos:
- `(codigo, negocio_id)` en Sistema
- `(codigo, sistema_id)` en Menu
- `(codigo, menu_id)` en Opcion
- `(opcion_id, rol_id)` en Visibilidad

## Próximos Pasos

1. **Implementar Repositorios**: Crear repositorios JPA para cada entidad
2. **Servicios de Negocio**: Implementar lógica de negocio para gestión de menús
3. **API REST**: Exponer endpoints para CRUD de entidades
4. **Autenticación**: Integrar con sistema de autenticación (JWT, OAuth2)
5. **Caché**: Implementar caché para mejorar rendimiento de consultas frecuentes
6. **Testing**: Crear tests unitarios y de integración

## Contribuciones

Para sugerir cambios o mejoras al modelo de datos, por favor:
1. Revisar el diagrama ER
2. Validar que el cambio no rompa relaciones existentes
3. Actualizar documentación correspondiente
4. Generar scripts de migración si es necesario
