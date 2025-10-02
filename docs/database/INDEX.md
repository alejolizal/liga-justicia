# Índice de Documentación - Sistema de Administración de Menús

## 📋 Resumen

Este directorio contiene la **definición completa del modelo de datos** para el Sistema de Administración de Menús, incluyendo:

- ✅ 8 Entidades JPA completamente documentadas
- ✅ Scripts DDL para PostgreSQL y H2
- ✅ Diagrama Entidad-Relación
- ✅ Datos de ejemplo temáticos
- ✅ Guía de uso con 40+ ejemplos SQL
- ✅ Documentación completa del modelo

---

## 📂 Estructura de Archivos

### 🔹 Documentación Principal

| Archivo | Descripción | Líneas |
|---------|-------------|---------|
| **[README.md](README.md)** | Documentación completa del modelo de datos | 400+ |
| **[ER-DIAGRAM.md](ER-DIAGRAM.md)** | Diagrama entidad-relación visual con ASCII art | 350+ |
| **[GUIA-USO.md](GUIA-USO.md)** | Guía práctica con consultas y ejemplos | 500+ |
| **[../MODELO-DATOS.md](../MODELO-DATOS.md)** | Resumen ejecutivo del modelo | 400+ |

### 🔹 Scripts SQL

| Archivo | Descripción | Propósito |
|---------|-------------|-----------|
| **[schema-postgresql.sql](schema-postgresql.sql)** | Schema para PostgreSQL | Producción |
| **[schema-h2.sql](schema-h2.sql)** | Schema para H2 Database | Pruebas |
| **[sample-data.sql](sample-data.sql)** | Datos de ejemplo | Desarrollo/Demo |

### 🔹 Código Fuente

| Ubicación | Archivos | Descripción |
|-----------|----------|-------------|
| `../../src/main/java/com/ligajusticia/menu/model/` | 8 archivos .java | Entidades JPA |

---

## 🗂️ Entidades del Modelo

### Entidades Principales

| # | Entidad | Descripción | Líneas de Código |
|---|---------|-------------|------------------|
| 1 | **[Negocio.java](../../src/main/java/com/ligajusticia/menu/model/Negocio.java)** | Organización o empresa | ~120 |
| 2 | **[Sistema.java](../../src/main/java/com/ligajusticia/menu/model/Sistema.java)** | Aplicación dentro de un negocio | ~150 |
| 3 | **[Menu.java](../../src/main/java/com/ligajusticia/menu/model/Menu.java)** | Menú con soporte jerárquico | ~170 |
| 4 | **[Opcion.java](../../src/main/java/com/ligajusticia/menu/model/Opcion.java)** | Opción de menú con soporte jerárquico | ~200 |

### Entidades de Seguridad

| # | Entidad | Descripción | Líneas de Código |
|---|---------|-------------|------------------|
| 5 | **[Usuario.java](../../src/main/java/com/ligajusticia/menu/model/Usuario.java)** | Usuario del sistema | ~160 |
| 6 | **[Rol.java](../../src/main/java/com/ligajusticia/menu/model/Rol.java)** | Rol o perfil de usuario | ~130 |
| 7 | **[Visibilidad.java](../../src/main/java/com/ligajusticia/menu/model/Visibilidad.java)** | Reglas de visibilidad extensibles | ~145 |

### Entidades de Auditoría

| # | Entidad | Descripción | Líneas de Código |
|---|---------|-------------|------------------|
| 8 | **[Acceso.java](../../src/main/java/com/ligajusticia/menu/model/Acceso.java)** | Registro de accesos (auditoría) | ~120 |

---

## 🚀 Inicio Rápido

### 1. Ver el Diagrama ER
```bash
cat docs/database/ER-DIAGRAM.md
```

### 2. Crear la Base de Datos (PostgreSQL)
```bash
# Crear database
createdb menu_admin

# Aplicar schema
psql menu_admin -f docs/database/schema-postgresql.sql

# (Opcional) Cargar datos de ejemplo
psql menu_admin -f docs/database/sample-data.sql
```

### 3. Configurar para Pruebas (H2)
```properties
# application.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.h2.console.enabled=true
spring.sql.init.mode=always
spring.sql.init.data-locations=classpath:schema-h2.sql,classpath:sample-data.sql
```

---

## 📊 Estadísticas del Modelo

### Métricas de Código

| Métrica | Valor |
|---------|-------|
| Total de Entidades | 8 |
| Total de Tablas | 9 (incluye usuario_rol) |
| Líneas de Código Java | ~1,200 |
| Líneas de SQL (DDL) | ~350 |
| Líneas de Documentación | ~2,000 |
| Campos Totales | ~80 |
| Relaciones | 12 |

### Características del Modelo

| Característica | Estado |
|----------------|--------|
| Soporte Jerárquico | ✅ Menu y Opcion |
| Soft Delete | ✅ Campo `activo` |
| Auditoría Temporal | ✅ fecha_creacion/modificacion |
| Multi-tenant | ✅ Via Negocio |
| Extensibilidad | ✅ Visibilidad personalizable |
| Índices Optimizados | ✅ 25+ índices |

---

## 📖 Guías de Lectura Recomendadas

### Para Desarrolladores

1. **Primera lectura**: [README.md](README.md) - Visión general
2. **Segunda lectura**: [ER-DIAGRAM.md](ER-DIAGRAM.md) - Estructura visual
3. **Implementación**: Revisar archivos .java en `src/main/java/`
4. **Práctica**: [GUIA-USO.md](GUIA-USO.md) - Ejemplos SQL

### Para Arquitectos

1. **Diseño**: [../MODELO-DATOS.md](../MODELO-DATOS.md) - Resumen ejecutivo
2. **Relaciones**: [ER-DIAGRAM.md](ER-DIAGRAM.md) - Diagrama completo
3. **Extensibilidad**: [README.md](README.md) - Sección de extensibilidad
4. **Validación**: Revisar constraints en schema-postgresql.sql

### Para DBAs

1. **Schema**: [schema-postgresql.sql](schema-postgresql.sql)
2. **Índices**: Ver sección CREATE INDEX en schema
3. **Mantenimiento**: [GUIA-USO.md](GUIA-USO.md) - Sección de mantenimiento
4. **Troubleshooting**: [GUIA-USO.md](GUIA-USO.md) - Sección de diagnóstico

---

## 🎯 Casos de Uso Principales

### 1. Sistema Multi-Tenant
```
Negocio A → Sistema ERP → Menús → Opciones
Negocio B → Sistema ERP → Menús → Opciones
Negocio C → Sistema CRM → Menús → Opciones
```

### 2. Control de Acceso Basado en Roles
```
Usuario → Roles → Reglas de Visibilidad → Opciones de Menú
```

### 3. Auditoría y Trazabilidad
```
Usuario → Acceso a Opción → Registro en tabla Acceso
```

### 4. Jerarquía de Navegación
```
Menu Principal
  ├─ Sub-menú A
  │   ├─ Opción 1
  │   │   └─ Sub-opción 1.1
  │   └─ Opción 2
  └─ Sub-menú B
      └─ Opción 3
```

---

## 🔍 Consultas Destacadas

### Menús Visibles para Usuario
Ver: [GUIA-USO.md](GUIA-USO.md#consulta-1-menús-visibles-para-un-usuario)

### Jerarquía Completa de Menús
Ver: [GUIA-USO.md](GUIA-USO.md#consulta-2-jerarquía-completa-de-menús)

### Auditoría de Accesos
Ver: [GUIA-USO.md](GUIA-USO.md#consulta-3-estadísticas-de-acceso-por-usuario)

### Top Opciones Más Usadas
Ver: [GUIA-USO.md](GUIA-USO.md#consulta-4-opciones-más-accedidas)

---

## 🛠️ Tecnologías

| Componente | Producción | Pruebas |
|------------|------------|---------|
| **Base de Datos** | PostgreSQL 12+ | H2 Database |
| **ORM** | JPA 2.2 | JPA 2.2 |
| **Implementación** | Hibernate 5.x | Hibernate 5.x |
| **Lenguaje** | Java 8+ | Java 8+ |

---

## 📝 Datos de Ejemplo

El archivo [sample-data.sql](sample-data.sql) incluye:

- ✅ 3 Negocios (Liga de la Justicia, Metrópolis, Gotham)
- ✅ 5 Sistemas (diferentes aplicaciones)
- ✅ 11 Menús (con jerarquía)
- ✅ 20+ Opciones (con jerarquía)
- ✅ 5 Roles (Admin, Líder, Héroe, Consultor, Operador)
- ✅ 8 Usuarios (superhéroes de DC)
- ✅ 30+ Reglas de visibilidad
- ✅ 5 Registros de acceso

**Tema**: Inspirado en la Liga de la Justicia 🦸‍♂️

---

## ✅ Características Implementadas

### Funcionalidades Core
- [x] Modelo de datos completo con 8 entidades
- [x] Soporte para jerarquías multi-nivel
- [x] Control de acceso basado en roles
- [x] Reglas de visibilidad extensibles
- [x] Auditoría de accesos
- [x] Soft delete en todas las entidades
- [x] Timestamps automáticos

### Optimizaciones
- [x] Índices en campos clave
- [x] Constraints de integridad referencial
- [x] Unique constraints compuestos
- [x] Cascadas configuradas correctamente

### Documentación
- [x] Diagrama ER detallado
- [x] Documentación completa del modelo
- [x] Guía de uso con ejemplos
- [x] Scripts SQL listos para usar
- [x] Datos de ejemplo

---

## 🔜 Próximos Pasos Sugeridos

### Fase 1: Implementación Backend
- [ ] Crear repositorios JPA (Spring Data)
- [ ] Implementar servicios de negocio
- [ ] Desarrollar API REST
- [ ] Agregar validaciones

### Fase 2: Seguridad
- [ ] Implementar autenticación (JWT/OAuth2)
- [ ] Integrar con Spring Security
- [ ] Implementar autorización basada en roles
- [ ] Agregar rate limiting

### Fase 3: Optimización
- [ ] Implementar caché (Redis)
- [ ] Agregar paginación
- [ ] Optimizar consultas N+1
- [ ] Implementar lazy loading estratégico

### Fase 4: Testing
- [ ] Tests unitarios de entidades
- [ ] Tests de integración con BD
- [ ] Tests de rendimiento
- [ ] Tests de seguridad

### Fase 5: DevOps
- [ ] Configurar migraciones (Flyway/Liquibase)
- [ ] Scripts de backup
- [ ] Monitoreo de BD
- [ ] CI/CD pipeline

---

## 📞 Soporte

### Documentación Disponible

- **README.md**: Documentación técnica completa
- **ER-DIAGRAM.md**: Diagrama visual del modelo
- **GUIA-USO.md**: Guía práctica con ejemplos
- **MODELO-DATOS.md**: Resumen ejecutivo

### Recursos Adicionales

- Scripts SQL listos para usar
- Datos de ejemplo tematizados
- Consultas SQL optimizadas
- Ejemplos de casos de uso

---

## 📄 Licencia

Este modelo de datos es parte del proyecto Liga de la Justicia.

---

## 👥 Contribuciones

Para sugerir mejoras o cambios:

1. Revisar la documentación existente
2. Validar compatibilidad con el modelo actual
3. Actualizar documentación correspondiente
4. Generar scripts de migración si es necesario

---

## 📊 Resumen Visual

```
Sistema de Administración de Menús
│
├── 📁 Código Fuente (8 entidades JPA)
│   ├── Negocio.java
│   ├── Sistema.java
│   ├── Menu.java
│   ├── Opcion.java
│   ├── Usuario.java
│   ├── Rol.java
│   ├── Visibilidad.java
│   └── Acceso.java
│
├── 📁 Scripts SQL
│   ├── schema-postgresql.sql (6.8 KB)
│   ├── schema-h2.sql (6.2 KB)
│   └── sample-data.sql (12 KB)
│
└── 📁 Documentación (2,000+ líneas)
    ├── README.md (400 líneas)
    ├── ER-DIAGRAM.md (350 líneas)
    ├── GUIA-USO.md (500 líneas)
    ├── MODELO-DATOS.md (400 líneas)
    └── INDEX.md (este archivo)
```

---

**Última actualización**: 2024
**Versión del modelo**: 1.0
**Estado**: ✅ Completo y listo para implementación
