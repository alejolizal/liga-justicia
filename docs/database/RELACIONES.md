# Documento de Relaciones del Modelo de Datos

## Mapa de Relaciones Completo

Este documento describe en detalle todas las relaciones entre las entidades del sistema de administración de menús.

---

## 1. Jerarquía de Navegación

### 1.1 Negocio → Sistema (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│     NEGOCIO      │ 1     N │     SISTEMA      │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - codigo         │
│ - nombre         │         │ - negocio_id (FK)│
└──────────────────┘         └──────────────────┘
```

**Descripción**: Un negocio puede tener múltiples sistemas/aplicaciones.

**Implementación JPA**:
```java
// En Negocio.java
@OneToMany(mappedBy = "negocio", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Sistema> sistemas = new HashSet<>();

// En Sistema.java
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "negocio_id", nullable = false)
private Negocio negocio;
```

**Ejemplo SQL**:
```sql
-- Un negocio con sus sistemas
SELECT n.nombre as negocio, s.nombre as sistema
FROM negocio n
JOIN sistema s ON n.id = s.negocio_id
WHERE n.codigo = 'LIGA_JUSTICIA';
```

---

### 1.2 Sistema → Menu (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│     SISTEMA      │ 1     N │      MENU        │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - codigo         │
│ - nombre         │         │ - sistema_id (FK)│
└──────────────────┘         └──────────────────┘
```

**Descripción**: Un sistema puede tener múltiples menús.

**Implementación JPA**:
```java
// En Sistema.java
@OneToMany(mappedBy = "sistema", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Menu> menus = new HashSet<>();

// En Menu.java
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "sistema_id", nullable = false)
private Sistema sistema;
```

---

### 1.3 Menu → Menu (Self-Reference, One-to-Many)

```
┌──────────────────┐
│      MENU        │ 1
│                  │◄────┐
│ - id (PK)        │     │
│ - codigo         │     │ N
│ - menu_padre_id ◄├─────┘
└──────────────────┘
```

**Descripción**: Un menú puede tener sub-menús (jerarquía recursiva).

**Implementación JPA**:
```java
// En Menu.java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "menu_padre_id")
private Menu menuPadre;

@OneToMany(mappedBy = "menuPadre", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Menu> subMenus = new HashSet<>();
```

**Ejemplo de Jerarquía**:
```
Menu Principal
├─ Sub-menú 1
│  ├─ Sub-menú 1.1
│  └─ Sub-menú 1.2
└─ Sub-menú 2
   └─ Sub-menú 2.1
```

---

### 1.4 Menu → Opcion (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│      MENU        │ 1     N │     OPCION       │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - codigo         │
│ - nombre         │         │ - menu_id (FK)   │
└──────────────────┘         └──────────────────┘
```

**Descripción**: Un menú puede tener múltiples opciones.

**Implementación JPA**:
```java
// En Menu.java
@OneToMany(mappedBy = "menu", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Opcion> opciones = new HashSet<>();

// En Opcion.java
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "menu_id", nullable = false)
private Menu menu;
```

---

### 1.5 Opcion → Opcion (Self-Reference, One-to-Many)

```
┌──────────────────┐
│     OPCION       │ 1
│                  │◄────┐
│ - id (PK)        │     │
│ - codigo         │     │ N
│ - opcion_padre_id├─────┘
└──────────────────┘
```

**Descripción**: Una opción puede tener sub-opciones (jerarquía recursiva).

**Implementación JPA**:
```java
// En Opcion.java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "opcion_padre_id")
private Opcion opcionPadre;

@OneToMany(mappedBy = "opcionPadre", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Opcion> subOpciones = new HashSet<>();
```

---

## 2. Control de Acceso y Seguridad

### 2.1 Usuario ↔ Rol (Many-to-Many)

```
┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│     USUARIO      │ N     M │   USUARIO_ROL    │ M     N │       ROL        │
│                  │◄────────┤                  ├────────►│                  │
│ - id (PK)        │         │ - usuario_id (FK)│         │ - id (PK)        │
│ - username       │         │ - rol_id (FK)    │         │ - codigo         │
│ - email          │         └──────────────────┘         │ - nombre         │
└──────────────────┘                                      └──────────────────┘
```

**Descripción**: Relación muchos a muchos implementada con tabla intermedia.
- Un usuario puede tener múltiples roles
- Un rol puede estar asignado a múltiples usuarios

**Implementación JPA**:
```java
// En Usuario.java
@ManyToMany(fetch = FetchType.LAZY)
@JoinTable(
    name = "usuario_rol",
    joinColumns = @JoinColumn(name = "usuario_id"),
    inverseJoinColumns = @JoinColumn(name = "rol_id")
)
private Set<Rol> roles = new HashSet<>();

// En Rol.java
@ManyToMany(mappedBy = "roles")
private Set<Usuario> usuarios = new HashSet<>();
```

**Ejemplo SQL**:
```sql
-- Obtener roles de un usuario
SELECT u.username, r.nombre as rol
FROM usuario u
JOIN usuario_rol ur ON u.id = ur.usuario_id
JOIN rol r ON ur.rol_id = r.id
WHERE u.username = 'superman';
```

---

### 2.2 Opcion → Visibilidad (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│     OPCION       │ 1     N │   VISIBILIDAD    │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - opcion_id (FK) │
│ - nombre         │         │ - visible        │
└──────────────────┘         │ - habilitado     │
                             └──────────────────┘
```

**Descripción**: Una opción puede tener múltiples reglas de visibilidad.

**Implementación JPA**:
```java
// En Opcion.java
@OneToMany(mappedBy = "opcion", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Visibilidad> reglas = new HashSet<>();

// En Visibilidad.java
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "opcion_id", nullable = false)
private Opcion opcion;
```

---

### 2.3 Rol → Visibilidad (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│       ROL        │ 1     N │   VISIBILIDAD    │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - rol_id (FK)    │
│ - nombre         │         │ - tipo_regla     │
└──────────────────┘         └──────────────────┘
```

**Descripción**: Un rol puede tener múltiples reglas de visibilidad asociadas.

**Implementación JPA**:
```java
// En Rol.java
@OneToMany(mappedBy = "rol", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Visibilidad> reglas = new HashSet<>();

// En Visibilidad.java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "rol_id")
private Rol rol;
```

**Nota**: `rol_id` es opcional en Visibilidad para permitir reglas personalizadas sin rol específico.

---

## 3. Auditoría

### 3.1 Usuario → Acceso (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│     USUARIO      │ 1     N │     ACCESO       │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - username       │         │ - usuario_id (FK)│
│ - nombre         │         │ - fecha_acceso   │
└──────────────────┘         │ - ip_address     │
                             └──────────────────┘
```

**Descripción**: Un usuario puede tener múltiples registros de acceso.

**Implementación JPA**:
```java
// En Usuario.java
@OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL, orphanRemoval = true)
private Set<Acceso> accesos = new HashSet<>();

// En Acceso.java
@ManyToOne(fetch = FetchType.LAZY, optional = false)
@JoinColumn(name = "usuario_id", nullable = false)
private Usuario usuario;
```

---

### 3.2 Opcion → Acceso (One-to-Many)

```
┌──────────────────┐         ┌──────────────────┐
│     OPCION       │ 1     N │     ACCESO       │
│                  │◄────────┤                  │
│ - id (PK)        │         │ - id (PK)        │
│ - codigo         │         │ - opcion_id (FK) │
│ - nombre         │         │ - fecha_acceso   │
└──────────────────┘         │ - exitoso        │
                             └──────────────────┘
```

**Descripción**: Una opción puede tener múltiples registros de acceso.

**Implementación JPA**:
```java
// En Acceso.java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "opcion_id")
private Opcion opcion;
```

**Nota**: `opcion_id` es opcional para permitir registros de acceso generales.

---

## 4. Resumen de Cardinalidades

| Relación | Cardinalidad | Tipo | Opcional |
|----------|--------------|------|----------|
| Negocio → Sistema | 1:N | Composición | No |
| Sistema → Menu | 1:N | Composición | No |
| Menu → Menu | 1:N | Auto-referencia | Sí (menu_padre) |
| Menu → Opcion | 1:N | Composición | No |
| Opcion → Opcion | 1:N | Auto-referencia | Sí (opcion_padre) |
| Usuario ↔ Rol | N:M | Asociación | No |
| Opcion → Visibilidad | 1:N | Composición | No |
| Rol → Visibilidad | 1:N | Agregación | Sí (rol_id) |
| Usuario → Acceso | 1:N | Composición | No |
| Opcion → Acceso | 1:N | Agregación | Sí (opcion_id) |

---

## 5. Cascadas y Eliminación

### 5.1 Cascadas Configuradas

| Entidad Padre | Entidad Hija | Cascade Type | Orphan Removal |
|---------------|--------------|--------------|----------------|
| Negocio | Sistema | ALL | true |
| Sistema | Menu | ALL | true |
| Menu | Menu (sub-menús) | ALL | true |
| Menu | Opcion | ALL | true |
| Opcion | Opcion (sub-opciones) | ALL | true |
| Opcion | Visibilidad | ALL | true |
| Rol | Visibilidad | ALL | true |
| Usuario | Acceso | ALL | true |

### 5.2 Comportamiento de Eliminación

**Ejemplo 1: Eliminar un Negocio**
```
DELETE Negocio
  └─ CASCADE DELETE → Todos sus Sistemas
      └─ CASCADE DELETE → Todos los Menús de esos sistemas
          └─ CASCADE DELETE → Todas las Opciones de esos menús
              └─ CASCADE DELETE → Todas las Visibilidades de esas opciones
```

**Ejemplo 2: Eliminar un Usuario**
```
DELETE Usuario
  ├─ CASCADE DELETE → Tabla usuario_rol (ON DELETE CASCADE)
  └─ CASCADE DELETE → Todos sus Accesos
```

**Ejemplo 3: Soft Delete (Recomendado)**
```sql
-- En lugar de DELETE físico
UPDATE negocio SET activo = FALSE WHERE id = 1;

-- Las consultas filtran por activo
SELECT * FROM negocio WHERE activo = TRUE;
```

---

## 6. Integridad Referencial

### 6.1 Foreign Keys Configuradas

```sql
-- Relaciones obligatorias (NOT NULL)
ALTER TABLE sistema ADD CONSTRAINT fk_sistema_negocio 
  FOREIGN KEY (negocio_id) REFERENCES negocio(id);

ALTER TABLE menu ADD CONSTRAINT fk_menu_sistema 
  FOREIGN KEY (sistema_id) REFERENCES sistema(id);

ALTER TABLE opcion ADD CONSTRAINT fk_opcion_menu 
  FOREIGN KEY (menu_id) REFERENCES menu(id);

ALTER TABLE visibilidad ADD CONSTRAINT fk_visibilidad_opcion 
  FOREIGN KEY (opcion_id) REFERENCES opcion(id) ON DELETE CASCADE;

ALTER TABLE acceso ADD CONSTRAINT fk_acceso_usuario 
  FOREIGN KEY (usuario_id) REFERENCES usuario(id);

-- Relaciones opcionales (NULL permitido)
ALTER TABLE menu ADD CONSTRAINT fk_menu_padre 
  FOREIGN KEY (menu_padre_id) REFERENCES menu(id);

ALTER TABLE opcion ADD CONSTRAINT fk_opcion_padre 
  FOREIGN KEY (opcion_padre_id) REFERENCES opcion(id);

ALTER TABLE visibilidad ADD CONSTRAINT fk_visibilidad_rol 
  FOREIGN KEY (rol_id) REFERENCES rol(id) ON DELETE CASCADE;

ALTER TABLE acceso ADD CONSTRAINT fk_acceso_opcion 
  FOREIGN KEY (opcion_id) REFERENCES opcion(id);
```

### 6.2 Unique Constraints Compuestos

```sql
-- Garantiza unicidad dentro de contexto
ALTER TABLE sistema ADD CONSTRAINT uk_sistema_codigo_negocio 
  UNIQUE (codigo, negocio_id);

ALTER TABLE menu ADD CONSTRAINT uk_menu_codigo_sistema 
  UNIQUE (codigo, sistema_id);

ALTER TABLE opcion ADD CONSTRAINT uk_opcion_codigo_menu 
  UNIQUE (codigo, menu_id);

ALTER TABLE visibilidad ADD CONSTRAINT uk_visibilidad_opcion_rol 
  UNIQUE (opcion_id, rol_id);
```

---

## 7. Consultas de Validación de Relaciones

### 7.1 Verificar Jerarquía de Menús

```sql
-- Verificar que no hay ciclos en jerarquía de menús
WITH RECURSIVE menu_path AS (
  SELECT id, codigo, menu_padre_id, ARRAY[id] as path, 0 as depth
  FROM menu
  WHERE menu_padre_id IS NULL
  
  UNION ALL
  
  SELECT m.id, m.codigo, m.menu_padre_id, path || m.id, depth + 1
  FROM menu m
  JOIN menu_path mp ON m.menu_padre_id = mp.id
  WHERE NOT (m.id = ANY(path))  -- Detectar ciclos
    AND depth < 10  -- Limitar profundidad máxima
)
SELECT * FROM menu_path ORDER BY path;
```

### 7.2 Verificar Integridad Usuario-Rol-Visibilidad

```sql
-- Usuarios sin roles
SELECT u.username
FROM usuario u
LEFT JOIN usuario_rol ur ON u.id = ur.usuario_id
WHERE ur.usuario_id IS NULL AND u.activo = TRUE;

-- Roles sin usuarios
SELECT r.codigo, r.nombre
FROM rol r
LEFT JOIN usuario_rol ur ON r.id = ur.rol_id
WHERE ur.rol_id IS NULL AND r.activo = TRUE;

-- Reglas de visibilidad con rol inválido
SELECT v.*
FROM visibilidad v
LEFT JOIN rol r ON v.rol_id = r.id
WHERE v.rol_id IS NOT NULL AND r.id IS NULL;
```

### 7.3 Verificar Opciones Sin Reglas de Visibilidad

```sql
SELECT o.codigo, o.nombre, m.nombre as menu
FROM opcion o
JOIN menu m ON o.menu_id = m.id
LEFT JOIN visibilidad v ON o.id = v.opcion_id
WHERE v.id IS NULL AND o.activo = TRUE;
```

---

## 8. Patrones de Acceso Comunes

### 8.1 Cargar Menú Completo para Usuario

```sql
-- Con todas las relaciones
SELECT 
    n.nombre as negocio,
    s.nombre as sistema,
    m.nombre as menu,
    m.orden as menu_orden,
    o.nombre as opcion,
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
JOIN sistema s ON m.sistema_id = s.id
JOIN negocio n ON s.negocio_id = n.id
WHERE u.username = ?
  AND v.visible = TRUE
  AND o.activo = TRUE
  AND m.activo = TRUE
  AND s.activo = TRUE
  AND n.activo = TRUE
ORDER BY s.orden, m.orden, o.orden;
```

### 8.2 Registrar Acceso

```sql
-- Insertar registro de acceso
INSERT INTO acceso (
    usuario_id, 
    opcion_id, 
    fecha_acceso, 
    ip_address, 
    user_agent, 
    accion_realizada, 
    exitoso
)
SELECT 
    u.id,
    o.id,
    CURRENT_TIMESTAMP,
    ?,  -- IP desde aplicación
    ?,  -- User agent desde aplicación
    ?,  -- Acción desde aplicación
    TRUE
FROM usuario u
JOIN opcion o ON o.codigo = ?
WHERE u.username = ?;
```

---

## 9. Diagramas Simplificados

### 9.1 Vista de Navegación

```
Negocio
  ↓
Sistema
  ↓
Menu ⟲ (auto-referencia)
  ↓
Opcion ⟲ (auto-referencia)
```

### 9.2 Vista de Seguridad

```
Usuario ←→ Rol
           ↓
       Visibilidad
           ↓
        Opcion
```

### 9.3 Vista de Auditoría

```
Usuario ──→ Acceso ←── Opcion
```

---

## 10. Conclusión

El modelo de datos implementa un sistema robusto de relaciones que permite:

✅ Jerarquía multi-nivel de navegación
✅ Control de acceso granular
✅ Extensibilidad mediante reglas personalizadas
✅ Auditoría completa de accesos
✅ Integridad referencial garantizada
✅ Soft delete para recuperación de datos
✅ Optimización mediante índices estratégicos

**Total de Relaciones**: 10 relaciones principales
**Total de Entidades**: 8 entidades + 1 tabla asociativa
**Nivel de Normalización**: 3FN (Tercera Forma Normal)
