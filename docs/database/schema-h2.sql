-- ============================================
-- Schema para Sistema de Administración de Menús
-- Base de Datos: H2 (para pruebas)
-- ============================================

-- Tabla: negocio
CREATE TABLE negocio (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_negocio_codigo ON negocio(codigo);
CREATE INDEX idx_negocio_activo ON negocio(activo);

-- Tabla: sistema
CREATE TABLE sistema (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    url_base VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    negocio_id BIGINT NOT NULL,
    CONSTRAINT fk_sistema_negocio FOREIGN KEY (negocio_id) REFERENCES negocio(id),
    CONSTRAINT uk_sistema_codigo_negocio UNIQUE (codigo, negocio_id)
);

CREATE INDEX idx_sistema_negocio ON sistema(negocio_id);
CREATE INDEX idx_sistema_activo ON sistema(activo);

-- Tabla: menu
CREATE TABLE menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    orden INTEGER NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sistema_id BIGINT NOT NULL,
    menu_padre_id BIGINT,
    CONSTRAINT fk_menu_sistema FOREIGN KEY (sistema_id) REFERENCES sistema(id),
    CONSTRAINT fk_menu_padre FOREIGN KEY (menu_padre_id) REFERENCES menu(id),
    CONSTRAINT uk_menu_codigo_sistema UNIQUE (codigo, sistema_id)
);

CREATE INDEX idx_menu_sistema ON menu(sistema_id);
CREATE INDEX idx_menu_padre ON menu(menu_padre_id);
CREATE INDEX idx_menu_activo ON menu(activo);
CREATE INDEX idx_menu_orden ON menu(orden);

-- Tabla: opcion
CREATE TABLE opcion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    url VARCHAR(500),
    icono VARCHAR(100),
    orden INTEGER NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    tipo_accion VARCHAR(50),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    menu_id BIGINT NOT NULL,
    opcion_padre_id BIGINT,
    CONSTRAINT fk_opcion_menu FOREIGN KEY (menu_id) REFERENCES menu(id),
    CONSTRAINT fk_opcion_padre FOREIGN KEY (opcion_padre_id) REFERENCES opcion(id),
    CONSTRAINT uk_opcion_codigo_menu UNIQUE (codigo, menu_id)
);

CREATE INDEX idx_opcion_menu ON opcion(menu_id);
CREATE INDEX idx_opcion_padre ON opcion(opcion_padre_id);
CREATE INDEX idx_opcion_activo ON opcion(activo);
CREATE INDEX idx_opcion_orden ON opcion(orden);

-- Tabla: usuario
CREATE TABLE usuario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    password_hash VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP
);

CREATE INDEX idx_usuario_username ON usuario(username);
CREATE INDEX idx_usuario_email ON usuario(email);
CREATE INDEX idx_usuario_activo ON usuario(activo);

-- Tabla: rol
CREATE TABLE rol (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(200) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_rol_codigo ON rol(codigo);
CREATE INDEX idx_rol_activo ON rol(activo);

-- Tabla: usuario_rol (relación muchos a muchos)
CREATE TABLE usuario_rol (
    usuario_id BIGINT NOT NULL,
    rol_id BIGINT NOT NULL,
    PRIMARY KEY (usuario_id, rol_id),
    CONSTRAINT fk_usuario_rol_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    CONSTRAINT fk_usuario_rol_rol FOREIGN KEY (rol_id) REFERENCES rol(id) ON DELETE CASCADE
);

CREATE INDEX idx_usuario_rol_usuario ON usuario_rol(usuario_id);
CREATE INDEX idx_usuario_rol_rol ON usuario_rol(rol_id);

-- Tabla: visibilidad
CREATE TABLE visibilidad (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visible BOOLEAN NOT NULL DEFAULT TRUE,
    habilitado BOOLEAN NOT NULL DEFAULT TRUE,
    tipo_regla VARCHAR(50),
    expresion_regla VARCHAR(1000),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    opcion_id BIGINT NOT NULL,
    rol_id BIGINT,
    CONSTRAINT fk_visibilidad_opcion FOREIGN KEY (opcion_id) REFERENCES opcion(id) ON DELETE CASCADE,
    CONSTRAINT fk_visibilidad_rol FOREIGN KEY (rol_id) REFERENCES rol(id) ON DELETE CASCADE,
    CONSTRAINT uk_visibilidad_opcion_rol UNIQUE (opcion_id, rol_id)
);

CREATE INDEX idx_visibilidad_opcion ON visibilidad(opcion_id);
CREATE INDEX idx_visibilidad_rol ON visibilidad(rol_id);
CREATE INDEX idx_visibilidad_tipo_regla ON visibilidad(tipo_regla);

-- Tabla: acceso (auditoría)
CREATE TABLE acceso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_acceso TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    user_agent VARCHAR(500),
    accion_realizada VARCHAR(200),
    exitoso BOOLEAN NOT NULL DEFAULT TRUE,
    usuario_id BIGINT NOT NULL,
    opcion_id BIGINT,
    CONSTRAINT fk_acceso_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    CONSTRAINT fk_acceso_opcion FOREIGN KEY (opcion_id) REFERENCES opcion(id)
);

CREATE INDEX idx_acceso_usuario ON acceso(usuario_id);
CREATE INDEX idx_acceso_opcion ON acceso(opcion_id);
CREATE INDEX idx_acceso_fecha ON acceso(fecha_acceso);
CREATE INDEX idx_acceso_exitoso ON acceso(exitoso);
