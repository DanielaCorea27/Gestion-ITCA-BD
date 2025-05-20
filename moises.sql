create database BD_GestionPrestamo_ITCA
 -- Crear tabla USUARIO
CREATE TABLE USUARIO (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('docente', 'estudiante')),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dui VARCHAR(10) UNIQUE, -- Solo para docentes
    carnet VARCHAR(20) UNIQUE, -- Solo para estudiantes
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'inactivo'))
);

-- Crear tabla CATEGORIA_EQUIPO
CREATE TABLE CATEGORIA_EQUIPO (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Crear tabla EQUIPO
CREATE TABLE EQUIPO (
    id_equipo INT PRIMARY KEY IDENTITY(1,1),
    codigo_inventario VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    serie VARCHAR(50),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('disponible', 'prestado', 'mantenimiento', 'inactivo')),
    id_categoria INT NOT NULL,
    fecha_adquisicion DATE NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_EQUIPO(id_categoria)
);

-- Crear tabla LABORATORIO
CREATE TABLE LABORATORIO (
    id_laboratorio INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100),
    capacidad INT,
    responsable VARCHAR(100)
);

-- Crear tabla PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    fecha_prestamo DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_devolucion_programada DATETIME NOT NULL,
    fecha_devolucion_real DATETIME NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'finalizado', 'vencido')),
    id_laboratorio INT NOT NULL,
    observaciones_entrega TEXT,
    observaciones_devolucion TEXT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_laboratorio) REFERENCES LABORATORIO(id_laboratorio)
);

-- Crear tabla DETALLE_PRESTAMO
CREATE TABLE DETALLE_PRESTAMO (
    id_detalle_prestamo INT PRIMARY KEY IDENTITY(1,1),
    id_prestamo INT NOT NULL,
    id_equipo INT NOT NULL,
    estado_entrega TEXT NOT NULL,
    estado_devolucion TEXT NULL,
    FOREIGN KEY (id_prestamo) REFERENCES PRESTAMO(id_prestamo),
    FOREIGN KEY (id_equipo) REFERENCES EQUIPO(id_equipo)
);

-- Crear tabla HISTORIAL_MANTENIMIENTO
CREATE TABLE HISTORIAL_MANTENIMIENTO (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1,1),
    id_equipo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tipo_mantenimiento VARCHAR(50) NOT NULL CHECK (tipo_mantenimiento IN ('preventivo', 'correctivo')),
    descripcion TEXT,
    responsable VARCHAR(100),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'completado')),
    FOREIGN KEY (id_equipo) REFERENCES EQUIPO(id_equipo)
);
