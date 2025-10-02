# Diagrama Entidad-Relación (ER)
## Sistema de Administración de Menús

### Diagrama Visual

```
┌─────────────────┐
│    NEGOCIO      │
├─────────────────┤
│ id (PK)         │
│ codigo (UK)     │
│ nombre          │
│ descripcion     │
│ activo          │
│ fecha_creacion  │
│ fecha_mod       │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────▼────────┐
│    SISTEMA      │
├─────────────────┤
│ id (PK)         │
│ codigo          │
│ nombre          │
│ descripcion     │
│ url_base        │
│ activo          │
│ fecha_creacion  │
│ fecha_mod       │
│ negocio_id (FK) │
└────────┬────────┘
         │ 1
         │
         │ N
┌────────▼────────┐
│      MENU       │
├─────────────────┤
│ id (PK)         │
│ codigo          │
│ nombre          │
│ descripcion     │
│ orden           │
│ activo          │
│ fecha_creacion  │
│ fecha_mod       │
│ sistema_id (FK) │
│ menu_padre_id*  │◄───┐
└────────┬────────┘    │ Auto-referencia
         │ 1           │ (jerarquía)
         │             │
         │ N           │
┌────────▼────────┐    │
│     OPCION      │    │
├─────────────────┤    │
│ id (PK)         │    │
│ codigo          │    │
│ nombre          │    │
│ descripcion     │    │
│ url             │    │
│ icono           │    │
│ orden           │    │
│ activo          │    │
│ tipo_accion     │    │
│ fecha_creacion  │    │
│ fecha_mod       │    │
│ menu_id (FK)    │    │
│ opcion_padre_id*│◄───┘ Auto-referencia
└────────┬────────┘      (jerarquía)
         │ 1
         │
         │ N
┌────────▼────────┐
│  VISIBILIDAD    │
├─────────────────┤
│ id (PK)         │
│ visible         │
│ habilitado      │
│ tipo_regla      │
│ expresion_regla │
│ fecha_creacion  │
│ fecha_mod       │
│ opcion_id (FK)  │
│ rol_id (FK)     │
└────────┬────────┘
         │ N
         │
         │ N
┌────────▼────────┐        ┌─────────────────┐
│      ROL        │        │    USUARIO      │
├─────────────────┤        ├─────────────────┤
│ id (PK)         │        │ id (PK)         │
│ codigo (UK)     │        │ username (UK)   │
│ nombre          │        │ nombre          │
│ descripcion     │        │ email           │
│ activo          │        │ password_hash   │
│ fecha_creacion  │        │ activo          │
│ fecha_mod       │        │ fecha_creacion  │
└────────┬────────┘        │ fecha_mod       │
         │                 │ ultimo_acceso   │
         │                 └────────┬────────┘
         │ N                        │ 1
         │                          │
         │       USUARIO_ROL        │ N
         └──────────┬───────────────┘
                    │ (Tabla asociativa)
                    │
         ┌──────────▼─────────┐
         │    USUARIO_ROL     │
         ├────────────────────┤
         │ usuario_id (PK,FK) │
         │ rol_id (PK,FK)     │
         └────────────────────┘

┌─────────────────┐
│     ACCESO      │
├─────────────────┤
│ id (PK)         │
│ fecha_acceso    │
│ ip_address      │
│ user_agent      │
│ accion_realizada│
│ exitoso         │
│ usuario_id (FK) │◄─────┐
│ opcion_id (FK)  │◄───┐ │
└─────────────────┘    │ │
                       │ │
                    OPCION USUARIO
```

### Leyenda
- **PK**: Primary Key (Clave Primaria)
- **FK**: Foreign Key (Clave Foránea)
- **UK**: Unique Key (Clave Única)
- **1**: Relación uno
- **N**: Relación muchos
- **\***: Permite NULL (opcional)

---

## Relaciones Principales

### 1. Negocio → Sistema (1:N)
Un **Negocio** puede tener múltiples **Sistemas**.

### 2. Sistema → Menu (1:N)
Un **Sistema** puede tener múltiples **Menús**.

### 3. Menu → Opcion (1:N)
Un **Menu** puede tener múltiples **Opciones**.

### 4. Menu → Menu (Auto-referencia 1:N)
Un **Menu** puede tener sub-menús (jerarquía).
- `menu_padre_id` referencia a la tabla `menu`

### 5. Opcion → Opcion (Auto-referencia 1:N)
Una **Opcion** puede tener sub-opciones (jerarquía).
- `opcion_padre_id` referencia a la tabla `opcion`

### 6. Opcion → Visibilidad (1:N)
Una **Opcion** puede tener múltiples reglas de **Visibilidad**.

### 7. Rol → Visibilidad (1:N)
Un **Rol** puede tener múltiples reglas de **Visibilidad** asociadas.

### 8. Usuario ↔ Rol (N:M)
Relación muchos a muchos entre **Usuario** y **Rol**.
- Implementada mediante la tabla asociativa `usuario_rol`
- Un usuario puede tener múltiples roles
- Un rol puede estar asignado a múltiples usuarios

### 9. Usuario → Acceso (1:N)
Un **Usuario** puede tener múltiples registros de **Acceso** (auditoría).

### 10. Opcion → Acceso (1:N)
Una **Opcion** puede tener múltiples registros de **Acceso** (auditoría).

---

## Características de Extensibilidad

### 1. Jerarquías Auto-referenciadas
- **Menu**: Soporta múltiples niveles mediante `menu_padre_id`
- **Opcion**: Soporta múltiples niveles mediante `opcion_padre_id`

### 2. Reglas de Visibilidad Extensibles
La tabla **Visibilidad** incluye:
- `tipo_regla`: Tipo de regla (ej: "ROL", "NEGOCIO", "PERSONALIZADO")
- `expresion_regla`: Campo texto para reglas complejas en formato extensible (ej: JSON, expresiones)

Ejemplos de uso futuro:
```sql
-- Regla basada en rol
tipo_regla = 'ROL'
expresion_regla = NULL

-- Regla basada en negocio
tipo_regla = 'NEGOCIO'
expresion_regla = '{"negocio_ids": [1, 2, 3]}'

-- Regla personalizada con lógica compleja
tipo_regla = 'PERSONALIZADO'
expresion_regla = '{"condiciones": [{"campo": "departamento", "valor": "IT"}]}'
```

### 3. Auditoría
La tabla **Acceso** permite:
- Registro histórico de accesos
- Análisis de uso de opciones
- Detección de patrones de acceso
- Trazabilidad completa

---

## Atributos Clave por Entidad

### NEGOCIO
- **id**: Identificador único
- **codigo**: Código único del negocio
- **nombre**: Nombre del negocio
- **activo**: Estado (activo/inactivo)

### SISTEMA
- **id**: Identificador único
- **codigo**: Código único dentro del negocio
- **nombre**: Nombre del sistema
- **url_base**: URL base del sistema
- **negocio_id**: Referencia al negocio

### MENU
- **id**: Identificador único
- **codigo**: Código único dentro del sistema
- **nombre**: Nombre del menú
- **orden**: Orden de visualización
- **sistema_id**: Referencia al sistema
- **menu_padre_id**: Referencia al menú padre (para jerarquía)

### OPCION
- **id**: Identificador único
- **codigo**: Código único dentro del menú
- **nombre**: Nombre de la opción
- **url**: URL de la opción
- **icono**: Icono asociado
- **orden**: Orden de visualización
- **tipo_accion**: Tipo de acción (navegación, modal, etc.)
- **menu_id**: Referencia al menú
- **opcion_padre_id**: Referencia a opción padre (para jerarquía)

### USUARIO
- **id**: Identificador único
- **username**: Nombre de usuario único
- **email**: Email del usuario
- **password_hash**: Hash de contraseña
- **ultimo_acceso**: Fecha del último acceso

### ROL
- **id**: Identificador único
- **codigo**: Código único del rol
- **nombre**: Nombre del rol
- **descripcion**: Descripción del rol

### VISIBILIDAD
- **id**: Identificador único
- **visible**: Si la opción es visible
- **habilitado**: Si la opción está habilitada
- **tipo_regla**: Tipo de regla de visibilidad
- **expresion_regla**: Expresión para reglas complejas
- **opcion_id**: Referencia a la opción
- **rol_id**: Referencia al rol (opcional)

### ACCESO
- **id**: Identificador único
- **fecha_acceso**: Timestamp del acceso
- **ip_address**: Dirección IP
- **user_agent**: User agent del navegador
- **accion_realizada**: Descripción de la acción
- **exitoso**: Si el acceso fue exitoso
- **usuario_id**: Referencia al usuario
- **opcion_id**: Referencia a la opción (opcional)

---

## Índices Importantes

### Optimización de Consultas
- Índices en claves foráneas para joins eficientes
- Índices en campos de búsqueda frecuente (codigo, activo)
- Índices en campos de ordenamiento (orden)
- Índices en campos de auditoría (fecha_acceso)

### Restricciones de Unicidad
- `(codigo, negocio_id)` en Sistema
- `(codigo, sistema_id)` en Menu
- `(codigo, menu_id)` en Opcion
- `(opcion_id, rol_id)` en Visibilidad
- `(usuario_id, rol_id)` en usuario_rol

---

## Tecnologías

- **Producción**: PostgreSQL
- **Pruebas**: H2 Database (compatible con PostgreSQL)
- **ORM**: JPA/Hibernate

---

## Notas de Implementación

1. Todas las entidades incluyen campos de auditoría:
   - `fecha_creacion`: Timestamp de creación
   - `fecha_modificacion`: Timestamp de última modificación

2. El campo `activo` permite soft-delete en entidades principales

3. Las cascadas están configuradas apropiadamente para mantener integridad referencial

4. El modelo soporta multi-tenancy a través de la entidad Negocio
