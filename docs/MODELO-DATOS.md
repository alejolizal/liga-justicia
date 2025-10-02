# Modelo de Datos - Sistema de Administración de Menús

## Resumen Ejecutivo

Este documento presenta el modelo de datos diseñado para el **Sistema de Administración de Menús**, que permite gestionar la estructura de navegación de múltiples aplicaciones dentro de diferentes organizaciones.

## Entidades Definidas

El modelo consta de **8 entidades principales**:

1. **Negocio** - Organización o empresa
2. **Sistema** - Aplicación dentro de un negocio
3. **Menu** - Menú dentro de un sistema
4. **Opcion** - Opción dentro de un menú
5. **Usuario** - Usuario del sistema
6. **Rol** - Rol o perfil de usuario
7. **Visibilidad** - Reglas de visibilidad para opciones
8. **Acceso** - Registro de auditoría de accesos

## Arquitectura del Modelo

### Jerarquía de Navegación

```
Negocio
  └─ Sistema
      └─ Menu
          ├─ Menu (sub-menú)
          └─ Opcion
              └─ Opcion (sub-opción)
```

### Control de Acceso

```
Usuario ←─→ Rol ─→ Visibilidad ─→ Opcion
```

## Atributos Clave por Entidad

### 1. Negocio
- **Identificación**: `codigo` (único), `nombre`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Control**: `activo`
- **Relaciones**: Tiene múltiples sistemas

### 2. Sistema
- **Identificación**: `codigo` (único por negocio), `nombre`
- **Configuración**: `url_base`, `descripcion`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Control**: `activo`
- **Relaciones**: Pertenece a un negocio, tiene múltiples menús

### 3. Menu
- **Identificación**: `codigo` (único por sistema), `nombre`
- **Visualización**: `orden`, `descripcion`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Control**: `activo`
- **Jerarquía**: `menu_padre_id` (auto-referencia)
- **Relaciones**: Pertenece a un sistema, puede tener sub-menús y opciones

### 4. Opcion
- **Identificación**: `codigo` (único por menú), `nombre`
- **Configuración**: `url`, `icono`, `tipo_accion`
- **Visualización**: `orden`, `descripcion`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Control**: `activo`
- **Jerarquía**: `opcion_padre_id` (auto-referencia)
- **Relaciones**: Pertenece a un menú, puede tener sub-opciones y reglas de visibilidad

### 5. Usuario
- **Identificación**: `username` (único), `email`, `nombre`
- **Seguridad**: `password_hash`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`, `ultimo_acceso`
- **Control**: `activo`
- **Relaciones**: Tiene múltiples roles y registros de acceso

### 6. Rol
- **Identificación**: `codigo` (único), `nombre`
- **Descripción**: `descripcion`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Control**: `activo`
- **Relaciones**: Asignado a múltiples usuarios, tiene reglas de visibilidad

### 7. Visibilidad
- **Control**: `visible`, `habilitado`
- **Extensibilidad**: `tipo_regla`, `expresion_regla`
- **Auditoria**: `fecha_creacion`, `fecha_modificacion`
- **Relaciones**: Vincula opción con rol

### 8. Acceso
- **Registro**: `fecha_acceso`, `accion_realizada`
- **Información**: `ip_address`, `user_agent`
- **Estado**: `exitoso`
- **Relaciones**: Vincula usuario con opción

## Relaciones Entre Entidades

| Relación | Cardinalidad | Descripción |
|----------|--------------|-------------|
| Negocio → Sistema | 1:N | Un negocio tiene múltiples sistemas |
| Sistema → Menu | 1:N | Un sistema tiene múltiples menús |
| Menu → Menu | 1:N | Un menú puede tener sub-menús |
| Menu → Opcion | 1:N | Un menú tiene múltiples opciones |
| Opcion → Opcion | 1:N | Una opción puede tener sub-opciones |
| Usuario ↔ Rol | N:M | Relación muchos a muchos |
| Rol → Visibilidad | 1:N | Un rol tiene múltiples reglas |
| Opcion → Visibilidad | 1:N | Una opción tiene múltiples reglas |
| Usuario → Acceso | 1:N | Un usuario tiene múltiples accesos |
| Opcion → Acceso | 1:N | Una opción tiene múltiples accesos |

## Características de Extensibilidad

### 1. Jerarquías Multi-nivel
Las entidades **Menu** y **Opcion** soportan jerarquías ilimitadas:
- Menús pueden contener sub-menús recursivamente
- Opciones pueden contener sub-opciones recursivamente

### 2. Reglas de Visibilidad Extensibles
La tabla **Visibilidad** permite múltiples tipos de reglas:

#### Tipos de Reglas Soportados:
- **ROL**: Basadas en rol del usuario
- **NEGOCIO**: Basadas en el negocio
- **PERSONALIZADO**: Reglas personalizadas mediante expresiones

#### Campos Extensibles:
- `tipo_regla`: Define el tipo de regla
- `expresion_regla`: Campo de texto para expresiones complejas (JSON, XML, etc.)

**Ejemplo de regla personalizada:**
```json
{
  "condiciones": [
    {
      "campo": "departamento",
      "operador": "igual",
      "valor": "IT"
    },
    {
      "campo": "nivel",
      "operador": "mayor_o_igual",
      "valor": "senior"
    }
  ],
  "operador_logico": "AND"
}
```

### 3. Integración de Nuevos Sistemas

El modelo facilita la integración de nuevos sistemas:

**Proceso de integración:**
1. Registrar negocio (si no existe)
2. Crear entrada de sistema
3. Definir estructura de menús
4. Agregar opciones de menú
5. Configurar reglas de visibilidad

**Sin necesidad de:**
- Modificar esquema de base de datos
- Cambiar código de aplicación
- Reiniciar servicios

## Casos de Uso

### Caso 1: Empresa con Múltiples Sistemas

```
Empresa XYZ (Negocio)
├─ ERP (Sistema)
│   ├─ Ventas (Menu)
│   │   ├─ Nueva Venta (Opcion)
│   │   └─ Listar Ventas (Opcion)
│   └─ Inventario (Menu)
│       └─ Productos (Opcion)
├─ CRM (Sistema)
│   └─ Clientes (Menu)
│       ├─ Nuevo Cliente (Opcion)
│       └─ Listar Clientes (Opcion)
└─ Portal (Sistema)
    └─ Dashboard (Menu)
        └─ Resumen (Opcion)
```

### Caso 2: Control de Acceso por Roles

```
Rol: Administrador
└─ Visibilidad: TODAS las opciones (visible y habilitadas)

Rol: Vendedor
└─ Visibilidad: Solo opciones del menú "Ventas" (visible y habilitadas)

Rol: Consultor
└─ Visibilidad: Opciones de "Ventas" (visible pero deshabilitadas)
```

### Caso 3: Auditoría de Accesos

El sistema registra automáticamente:
- Fecha y hora de cada acceso
- Usuario que realizó el acceso
- Opción a la que se accedió
- Dirección IP y User Agent
- Si el acceso fue exitoso

## Tecnologías

### Producción
- **Base de Datos**: PostgreSQL 12+
- **ORM**: JPA 2.2 / Hibernate 5.x
- **Lenguaje**: Java 8+

### Pruebas
- **Base de Datos**: H2 Database (modo PostgreSQL)

## Estructura de Archivos

```
liga-justicia/
├── src/main/java/com/ligajusticia/menu/model/
│   ├── Negocio.java        # Entidad Negocio
│   ├── Sistema.java        # Entidad Sistema
│   ├── Menu.java           # Entidad Menu
│   ├── Opcion.java         # Entidad Opcion
│   ├── Usuario.java        # Entidad Usuario
│   ├── Rol.java            # Entidad Rol
│   ├── Visibilidad.java    # Entidad Visibilidad
│   └── Acceso.java         # Entidad Acceso
└── docs/database/
    ├── README.md              # Documentación completa
    ├── ER-DIAGRAM.md          # Diagrama entidad-relación
    ├── schema-postgresql.sql  # Schema para PostgreSQL
    └── schema-h2.sql          # Schema para H2
```

## Implementación

### Entidades JPA

Todas las entidades están implementadas como clases Java con anotaciones JPA:

```java
@Entity
@Table(name = "negocio")
public class Negocio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true, length = 100)
    private String codigo;
    
    // ... más atributos y métodos
}
```

### Características de las Entidades

1. **Generación automática de IDs**: `@GeneratedValue`
2. **Validaciones de base de datos**: `@Column(nullable = false)`
3. **Restricciones de unicidad**: `@UniqueConstraint`
4. **Índices**: `@Index`
5. **Relaciones bidireccionales**: `@OneToMany`, `@ManyToOne`, `@ManyToMany`
6. **Cascadas configuradas**: `CascadeType.ALL`, `orphanRemoval = true`
7. **Auditoría automática**: `@PrePersist`, `@PreUpdate`

## Validación del Modelo

### Ventajas del Diseño

✅ **Escalabilidad**: Soporta múltiples negocios y sistemas
✅ **Flexibilidad**: Jerarquías ilimitadas en menús y opciones
✅ **Extensibilidad**: Reglas de visibilidad personalizables
✅ **Auditoría**: Registro completo de accesos
✅ **Integridad**: Constraints y foreign keys bien definidos
✅ **Rendimiento**: Índices estratégicos en campos clave
✅ **Mantenibilidad**: Soft delete en lugar de eliminación física

### Consideraciones de Diseño

- **Normalización**: El modelo está normalizado hasta 3FN
- **Integridad Referencial**: Todas las FK tienen constraints
- **Consistencia**: Nomenclatura estándar en todas las tablas
- **Auditoría**: Campos de auditoría en todas las entidades
- **Soft Delete**: Campo `activo` para eliminación lógica

## Próximos Pasos

1. ✅ Modelo de datos definido
2. ⏳ Implementar repositorios JPA
3. ⏳ Crear servicios de negocio
4. ⏳ Desarrollar API REST
5. ⏳ Implementar autenticación y autorización
6. ⏳ Agregar caché para optimización
7. ⏳ Crear tests unitarios e integración
8. ⏳ Documentar API con Swagger/OpenAPI

## Referencias

- **Diagrama ER**: Ver `docs/database/ER-DIAGRAM.md`
- **Documentación Completa**: Ver `docs/database/README.md`
- **Schema PostgreSQL**: Ver `docs/database/schema-postgresql.sql`
- **Schema H2**: Ver `docs/database/schema-h2.sql`
- **Código Fuente**: Ver `src/main/java/com/ligajusticia/menu/model/`

## Conclusión

El modelo de datos presentado cumple con todos los requisitos especificados:

✅ **Entidades definidas**: Negocio, Sistema, Menú, Opción, Usuario, Rol, Visibilidad, Acceso
✅ **Atributos clave**: Cada entidad tiene atributos bien definidos
✅ **Relaciones claras**: Jerarquía de navegación y control de acceso
✅ **Extensibilidad**: Reglas de visibilidad personalizables
✅ **Diagrama ER**: Incluido en `docs/database/ER-DIAGRAM.md`
✅ **Tecnologías**: PostgreSQL para producción, H2 para pruebas

El modelo está listo para ser implementado y puede evolucionar según las necesidades futuras del negocio.
