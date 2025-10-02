-- ============================================
-- Datos de Ejemplo para Sistema de Administración de Menús
-- ============================================

-- ========================================
-- 1. NEGOCIO
-- ========================================
INSERT INTO negocio (codigo, nombre, descripcion, activo) VALUES
('LIGA_JUSTICIA', 'Liga de la Justicia', 'Organización de superhéroes', TRUE),
('METROPOLIS', 'Metrópolis Corp', 'Empresa tecnológica de Metrópolis', TRUE),
('GOTHAM', 'Gotham Industries', 'Conglomerado industrial de Gotham', TRUE);

-- ========================================
-- 2. SISTEMA
-- ========================================
INSERT INTO sistema (codigo, nombre, descripcion, url_base, activo, negocio_id) VALUES
-- Sistemas de Liga de la Justicia
('MISION_TRACKER', 'Sistema de Misiones', 'Sistema para gestionar misiones', 'https://missions.ligajusticia.com', TRUE, 1),
('HERO_REGISTRY', 'Registro de Héroes', 'Sistema de registro y perfil de héroes', 'https://heroes.ligajusticia.com', TRUE, 1),
('VILLANOS_DB', 'Base de Villanos', 'Base de datos de villanos conocidos', 'https://villains.ligajusticia.com', TRUE, 1),
-- Sistemas de Metrópolis
('ERP_METROPOLIS', 'ERP Metrópolis', 'Sistema ERP corporativo', 'https://erp.metropolis.com', TRUE, 2),
-- Sistemas de Gotham
('ERP_GOTHAM', 'ERP Gotham', 'Sistema ERP corporativo', 'https://erp.gotham.com', TRUE, 3);

-- ========================================
-- 3. MENU
-- ========================================
-- Menús del Sistema de Misiones
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id, menu_padre_id) VALUES
('MENU_MISIONES', 'Misiones', 'Gestión de misiones', 1, TRUE, 1, NULL),
('MENU_EQUIPO', 'Equipo', 'Gestión de equipos', 2, TRUE, 1, NULL),
('MENU_REPORTES', 'Reportes', 'Reportes y estadísticas', 3, TRUE, 1, NULL),
('MENU_CONFIG', 'Configuración', 'Configuración del sistema', 4, TRUE, 1, NULL);

-- Sub-menús
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id, menu_padre_id) VALUES
('SUBMENU_REPORTES_MISIONES', 'Reportes de Misiones', 'Reportes específicos de misiones', 1, TRUE, 1, 3),
('SUBMENU_REPORTES_HEROES', 'Reportes de Héroes', 'Reportes específicos de héroes', 2, TRUE, 1, 3);

-- Menús del Registro de Héroes
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id, menu_padre_id) VALUES
('MENU_HEROES', 'Héroes', 'Gestión de héroes', 1, TRUE, 2, NULL),
('MENU_PODERES', 'Poderes', 'Catálogo de poderes', 2, TRUE, 2, NULL),
('MENU_CIUDADES', 'Ciudades', 'Ciudades de operación', 3, TRUE, 2, NULL);

-- Menús de Base de Villanos
INSERT INTO menu (codigo, nombre, descripcion, orden, activo, sistema_id, menu_padre_id) VALUES
('MENU_VILLANOS', 'Villanos', 'Gestión de villanos', 1, TRUE, 3, NULL),
('MENU_AMENAZAS', 'Amenazas', 'Nivel de amenazas', 2, TRUE, 3, NULL);

-- ========================================
-- 4. OPCION
-- ========================================
-- Opciones del menú Misiones
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_NUEVA_MISION', 'Nueva Misión', 'Crear una nueva misión', '/misiones/nueva', 'icon-plus-circle', 1, TRUE, 'NAVEGACION', 1, NULL),
('OPC_LISTAR_MISIONES', 'Listar Misiones', 'Ver todas las misiones', '/misiones/listar', 'icon-list', 2, TRUE, 'NAVEGACION', 1, NULL),
('OPC_MISIONES_ACTIVAS', 'Misiones Activas', 'Ver misiones en curso', '/misiones/activas', 'icon-play', 3, TRUE, 'NAVEGACION', 1, NULL),
('OPC_MISIONES_COMPLETADAS', 'Misiones Completadas', 'Ver misiones completadas', '/misiones/completadas', 'icon-check', 4, TRUE, 'NAVEGACION', 1, NULL);

-- Opciones del menú Equipo
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_ASIGNAR_HEROES', 'Asignar Héroes', 'Asignar héroes a misiones', '/equipo/asignar', 'icon-users', 1, TRUE, 'NAVEGACION', 2, NULL),
('OPC_VER_DISPONIBILIDAD', 'Disponibilidad', 'Ver disponibilidad de héroes', '/equipo/disponibilidad', 'icon-calendar', 2, TRUE, 'NAVEGACION', 2, NULL);

-- Opciones del menú Reportes
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_DASHBOARD', 'Dashboard', 'Panel principal de estadísticas', '/reportes/dashboard', 'icon-dashboard', 1, TRUE, 'NAVEGACION', 3, NULL);

-- Opciones de sub-menú Reportes de Misiones
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_REP_MISION_EXITO', 'Tasa de Éxito', 'Reporte de tasa de éxito de misiones', '/reportes/misiones/exito', 'icon-chart-bar', 1, TRUE, 'NAVEGACION', 5, NULL),
('OPC_REP_MISION_TIEMPO', 'Tiempo Promedio', 'Reporte de tiempo promedio de misiones', '/reportes/misiones/tiempo', 'icon-clock', 2, TRUE, 'NAVEGACION', 5, NULL);

-- Opciones del menú Héroes
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_NUEVO_HEROE', 'Nuevo Héroe', 'Registrar nuevo héroe', '/heroes/nuevo', 'icon-user-plus', 1, TRUE, 'NAVEGACION', 7, NULL),
('OPC_LISTAR_HEROES', 'Listar Héroes', 'Ver todos los héroes', '/heroes/listar', 'icon-users', 2, TRUE, 'NAVEGACION', 7, NULL),
('OPC_PERFIL_HEROE', 'Perfil de Héroe', 'Ver perfil detallado', '/heroes/perfil', 'icon-id-card', 3, TRUE, 'NAVEGACION', 7, NULL);

-- Opciones del menú Villanos
INSERT INTO opcion (codigo, nombre, descripcion, url, icono, orden, activo, tipo_accion, menu_id, opcion_padre_id) VALUES
('OPC_NUEVO_VILLANO', 'Nuevo Villano', 'Registrar nuevo villano', '/villanos/nuevo', 'icon-user-times', 1, TRUE, 'NAVEGACION', 10, NULL),
('OPC_LISTAR_VILLANOS', 'Listar Villanos', 'Ver todos los villanos', '/villanos/listar', 'icon-list', 2, TRUE, 'NAVEGACION', 10, NULL),
('OPC_VILLANOS_PELIGROSOS', 'Más Peligrosos', 'Ver villanos más peligrosos', '/villanos/peligrosos', 'icon-exclamation-triangle', 3, TRUE, 'NAVEGACION', 10, NULL);

-- ========================================
-- 5. ROL
-- ========================================
INSERT INTO rol (codigo, nombre, descripcion, activo) VALUES
('ADMIN', 'Administrador', 'Acceso completo al sistema', TRUE),
('LIDER', 'Líder de Equipo', 'Líder de equipo con permisos de gestión', TRUE),
('HEROE', 'Héroe', 'Miembro del equipo con acceso básico', TRUE),
('CONSULTOR', 'Consultor', 'Acceso de solo lectura', TRUE),
('OPERADOR', 'Operador', 'Personal de operaciones', TRUE);

-- ========================================
-- 6. USUARIO
-- ========================================
INSERT INTO usuario (username, nombre, email, activo) VALUES
('superman', 'Clark Kent', 'clark.kent@ligajusticia.com', TRUE),
('batman', 'Bruce Wayne', 'bruce.wayne@ligajusticia.com', TRUE),
('wonderwoman', 'Diana Prince', 'diana.prince@ligajusticia.com', TRUE),
('flash', 'Barry Allen', 'barry.allen@ligajusticia.com', TRUE),
('aquaman', 'Arthur Curry', 'arthur.curry@ligajusticia.com', TRUE),
('cyborg', 'Victor Stone', 'victor.stone@ligajusticia.com', TRUE),
('greenlantern', 'Hal Jordan', 'hal.jordan@ligajusticia.com', TRUE),
('admin', 'Administrador Sistema', 'admin@ligajusticia.com', TRUE);

-- ========================================
-- 7. USUARIO_ROL
-- ========================================
INSERT INTO usuario_rol (usuario_id, rol_id) VALUES
-- Superman: Admin y Líder
(1, 1), (1, 2),
-- Batman: Admin y Líder
(2, 1), (2, 2),
-- Wonder Woman: Líder
(3, 2),
-- Flash: Héroe
(4, 3),
-- Aquaman: Héroe
(5, 3),
-- Cyborg: Héroe y Operador
(6, 3), (6, 5),
-- Green Lantern: Héroe
(7, 3),
-- Admin: Admin
(8, 1);

-- ========================================
-- 8. VISIBILIDAD
-- ========================================
-- Reglas para Administradores (pueden ver todo)
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla) VALUES
-- Admin puede ver y usar todas las opciones del sistema de misiones
(1, 1, TRUE, TRUE, 'ROL'),  -- Nueva Misión
(2, 1, TRUE, TRUE, 'ROL'),  -- Listar Misiones
(3, 1, TRUE, TRUE, 'ROL'),  -- Misiones Activas
(4, 1, TRUE, TRUE, 'ROL'),  -- Misiones Completadas
(5, 1, TRUE, TRUE, 'ROL'),  -- Asignar Héroes
(6, 1, TRUE, TRUE, 'ROL'),  -- Ver Disponibilidad
(7, 1, TRUE, TRUE, 'ROL'),  -- Dashboard
(8, 1, TRUE, TRUE, 'ROL'),  -- Tasa de Éxito
(9, 1, TRUE, TRUE, 'ROL');  -- Tiempo Promedio

-- Reglas para Líderes
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla) VALUES
(1, 2, TRUE, TRUE, 'ROL'),   -- Nueva Misión
(2, 2, TRUE, TRUE, 'ROL'),   -- Listar Misiones
(3, 2, TRUE, TRUE, 'ROL'),   -- Misiones Activas
(4, 2, TRUE, TRUE, 'ROL'),   -- Misiones Completadas
(5, 2, TRUE, TRUE, 'ROL'),   -- Asignar Héroes
(6, 2, TRUE, TRUE, 'ROL'),   -- Ver Disponibilidad
(7, 2, TRUE, TRUE, 'ROL'),   -- Dashboard
(8, 2, TRUE, FALSE, 'ROL'),  -- Tasa de Éxito (visible pero no habilitado)
(9, 2, TRUE, FALSE, 'ROL');  -- Tiempo Promedio (visible pero no habilitado)

-- Reglas para Héroes (acceso limitado)
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla) VALUES
(2, 3, TRUE, TRUE, 'ROL'),   -- Listar Misiones
(3, 3, TRUE, TRUE, 'ROL'),   -- Misiones Activas
(4, 3, TRUE, TRUE, 'ROL'),   -- Misiones Completadas
(6, 3, TRUE, TRUE, 'ROL'),   -- Ver Disponibilidad
(7, 3, TRUE, TRUE, 'ROL');   -- Dashboard

-- Reglas para Consultores (solo lectura)
INSERT INTO visibilidad (opcion_id, rol_id, visible, habilitado, tipo_regla) VALUES
(2, 4, TRUE, FALSE, 'ROL'),  -- Listar Misiones (visible pero no habilitado)
(3, 4, TRUE, FALSE, 'ROL'),  -- Misiones Activas (visible pero no habilitado)
(4, 4, TRUE, FALSE, 'ROL'),  -- Misiones Completadas (visible pero no habilitado)
(7, 4, TRUE, FALSE, 'ROL');  -- Dashboard (visible pero no habilitado)

-- Reglas personalizadas con expresiones
INSERT INTO visibilidad (opcion_id, visible, habilitado, tipo_regla, expresion_regla) VALUES
(11, TRUE, TRUE, 'PERSONALIZADO', '{"condicion": "usuario.ciudad == ''Metropolis''", "descripcion": "Solo usuarios de Metrópolis"}'),
(12, TRUE, TRUE, 'PERSONALIZADO', '{"condicion": "usuario.nivel >= 5", "descripcion": "Solo usuarios con nivel 5 o superior"}');

-- ========================================
-- 9. ACCESO (Ejemplos de auditoría)
-- ========================================
INSERT INTO acceso (usuario_id, opcion_id, fecha_acceso, ip_address, user_agent, accion_realizada, exitoso) VALUES
(1, 1, CURRENT_TIMESTAMP - INTERVAL '2 hours', '192.168.1.100', 'Mozilla/5.0', 'Creación de nueva misión', TRUE),
(2, 5, CURRENT_TIMESTAMP - INTERVAL '1 hour', '192.168.1.101', 'Mozilla/5.0', 'Asignación de héroes', TRUE),
(3, 2, CURRENT_TIMESTAMP - INTERVAL '30 minutes', '192.168.1.102', 'Mozilla/5.0', 'Consulta de misiones', TRUE),
(4, 3, CURRENT_TIMESTAMP - INTERVAL '15 minutes', '192.168.1.103', 'Mozilla/5.0', 'Visualización de misiones activas', TRUE),
(5, 7, CURRENT_TIMESTAMP - INTERVAL '5 minutes', '192.168.1.104', 'Mozilla/5.0', 'Acceso al dashboard', TRUE);

-- ========================================
-- VERIFICACIÓN DE DATOS
-- ========================================
-- Contar registros por tabla
-- SELECT 'Negocios' as tabla, COUNT(*) as total FROM negocio
-- UNION ALL SELECT 'Sistemas', COUNT(*) FROM sistema
-- UNION ALL SELECT 'Menus', COUNT(*) FROM menu
-- UNION ALL SELECT 'Opciones', COUNT(*) FROM opcion
-- UNION ALL SELECT 'Usuarios', COUNT(*) FROM usuario
-- UNION ALL SELECT 'Roles', COUNT(*) FROM rol
-- UNION ALL SELECT 'Usuario-Rol', COUNT(*) FROM usuario_rol
-- UNION ALL SELECT 'Visibilidad', COUNT(*) FROM visibilidad
-- UNION ALL SELECT 'Accesos', COUNT(*) FROM acceso;
