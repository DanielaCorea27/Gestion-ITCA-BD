--CREAR BD
create database BD_GestionPrestamo_ITCA

USE BD_GestionPrestamo_ITCA

-- CREAR TABLA ROLES
CREATE TABLE ROLES (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    rol VARCHAR(50) NOT NULL
);

-- REGISTROS ROLES
INSERT INTO ROLES (rol) VALUES ('estudiante'), ('docente'), ('técnico'), ('admin');

 -- CREAR TABLA USUARIOS
CREATE TABLE USUARIO (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    id_rol INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dui VARCHAR(10) UNIQUE, -- Solo para docentes
    carnet VARCHAR(20) UNIQUE, -- Solo para estudiantes
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'inactivo')),
	FOREIGN KEY (id_rol) REFERENCES ROLES(id_rol)
);

--REGISTROS USUARIOS
INSERT INTO USUARIO (id_rol, nombre, apellido, dui, carnet, correo, telefono, estado) VALUES
(1, 'Ana', 'Martínez', '01234567-8', '990001', 'ana.martinez@itca.edu.sv', '7777-1234', 'activo'),
(2, 'Carlos', 'Ruiz', '02345678-9', '990002', 'carlos.ruiz@itca.edu.sv', '7777-5678', 'activo'),
(3, 'Verónica', 'López', '03456789-0', '990003', 'veronica.lopez@itca.edu.sv', '7666-1212', 'activo'),
(4, 'Julio', 'Cortez', '04567890-1', '990004', 'julio.cortez@itca.edu.sv', '7000-1111', 'activo'),
(1, 'Luis', 'Ramírez', '09234123-5', '230101', 'luis.ramirez@itca.edu.sv', '7888-4321', 'activo'),
(2, 'María', 'Gómez', '08237654-2', '230102', 'maria.gomez@itca.edu.sv', '7999-8765', 'activo'),
(3, 'Javier', 'Morales', '07239871-4', '230103', 'javier.morales@itca.edu.sv', '7222-1111', 'activo'),
(4, 'Camila', 'Reyes', '06235678-6', '230104', 'camila.reyes@itca.edu.sv', '7111-2233', 'activo');

-- CREAR TABLA CATEGORIA_EQUIPO
CREATE TABLE CATEGORIA_EQUIPO (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- REGISTROS CATEGORIA_EQUIPO
INSERT INTO CATEGORIA_EQUIPO (nombre, descripcion) VALUES
('Laptops', 'Equipos portátiles para prácticas de laboratorio.'),
('Computadoras', 'Equipos PC para prácticas.'),
('Proyectores', 'Proyectores para uso académico.'),
('Impresoras', 'Impresoras para documentación académica.'),
('Switches de red', 'Dispositivos para prácticas de redes.'),
('Multímetros', 'Herramientas de medición electrónica.');

-- CREAR TABLA EQUIPO
CREATE TABLE EQUIPO (
    id_equipo VARCHAR(10) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    serie VARCHAR(50),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('disponible', 'prestado', 'mantenimiento', 'inactivo')),
    id_categoria INT NOT NULL,
    fecha_adquisicion DATE NOT NULL,
	stock INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA_EQUIPO(id_categoria)
);

-- REGISTROS EQUIPO
INSERT INTO EQUIPO (id_equipo, nombre, modelo, marca, serie, estado, id_categoria, fecha_adquisicion, stock) VALUES
('LPT-001', 'Laptop Dell Inspiron', 'Inspiron 15', 'Dell', 'SN12345', 'disponible', 1, '2023-02-15', 100),
('PRJ-002', 'Proyector Epson', 'X41', 'Epson', 'SN54321', 'disponible', 3, '2022-10-05', 200),
('SW-003', 'Switch Cisco', '2960', 'Cisco', 'SN11223', 'disponible', 5, '2023-01-10', 100),
('MMT-004', 'Multímetro Fluke', '115', 'Fluke', 'SN55667', 'disponible', 6, '2022-06-18', 100),
('IMP-005', 'Impresora HP', 'LaserJet M404dn', 'HP', 'SN67890', 'disponible', 4, '2021-08-20', 50),
('PC-006', 'Computadora Dell', 'OptiPlex 7080', 'Dell', 'SN11221', 'disponible', 2, '2023-06-15', 100),
('PC-007', 'Computadora HP', 'ProDesk 400 G7', 'HP', 'SN22244', 'mantenimiento', 2, '2023-09-15', 100);

SELECT * FROM EQUIPO

-- CREAR TABLA SALON
CREATE TABLE SALON (
    id_salon INT PRIMARY KEY IDENTITY(1,1),
	tipo_salon VARCHAR(20) NOT NULL CHECK (tipo_salon IN ('Centro de Cómputo', 'Laboratorio', 'Salon de Clase', 'Salon de Conferencia')),
	codigo VARCHAR(10) UNIQUE NOT NULL,
    ubicacion VARCHAR(100),
    capacidad INT,
	imagen VARBINARY(MAX),
    id_responsable INT NOT NULL,
	FOREIGN KEY (id_responsable) REFERENCES USUARIO(id_usuario)
);

-- REGISTROS SALON
INSERT INTO SALON (tipo_salon, codigo, ubicacion, capacidad, imagen, id_responsable)
VALUES ('Centro de Cómputo', 'F207', 'Edificio F, 2do nivel', 16, NULL, 1),
('Laboratorio', 'K105', 'Edificio K, 2do nivel', 35, NULL, 1),
('Salon de Clase', 'C205', 'Edificio C, 2do nivel', 40, NULL, 1),
('Salon de Conferencia', 'F200', 'Edificio F, 1er nivel', 20, NULL, 1),
('Centro de Cómputo', 'F305', 'Edificio F, 3er nivel', 16, NULL, 1);

-- CREAR TABLA PRESTAMO
CREATE TABLE PRESTAMO (
    id_prestamo INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT NOT NULL,
    fecha_prestamo DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_devolucion_programada DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('activo', 'finalizado', 'vencido')),
    id_salon INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_salon) REFERENCES SALON(id_salon)
);

-- REGISTROS PRESTAMO ESTA EN TRIGGERS

-- CREAR TABLA DETALLE_PRESTAMO
CREATE TABLE DETALLE_PRESTAMO (
    id_detalle_prestamo INT PRIMARY KEY IDENTITY(1,1),
    id_prestamo INT NOT NULL,
    id_equipo VARCHAR(10) NOT NULL,
	fecha_devolucion_real DATETIME,
    estado_devolucion TEXT NULL,
    FOREIGN KEY (id_prestamo) REFERENCES PRESTAMO(id_prestamo),
    FOREIGN KEY (id_equipo) REFERENCES EQUIPO(id_equipo)
);

--REGISTROS DETALLE_PRESTAMO TRIGGERS

-- CREAR TABLA HISTORIAL_MANTENIMIENTO
CREATE TABLE HISTORIAL_MANTENIMIENTO (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1,1),
    id_equipo VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin_programada DATE NOT NULL,
	fecha_fin_real DATE NULL,
    tipo_mantenimiento VARCHAR(50) NOT NULL CHECK (tipo_mantenimiento IN ('preventivo', 'correctivo')),
    descripcion TEXT,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'completado')),
	id_responsable INT NOT NULL,
	FOREIGN KEY (id_responsable) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_equipo) REFERENCES EQUIPO(id_equipo)
);

-- REGISTROS HISTORIAL_MANTENIMIENTO TRIGGERS
--TRIGGGERS
--ESTE TRIGGER ES PARA CUANDO SE REGISTRE UN DETALLE PRESTAMO EL ESTADO DEL EQUIPO PASE DE DISPONIBLE A PRESTADO
CREATE TRIGGER tr_registrarPrestamo
ON DETALLE_PRESTAMO 
AFTER INSERT 
AS
BEGIN
	UPDATE EQUIPO
	SET estado = 'prestado'
	WHERE id_equipo IN (
        SELECT id_equipo FROM INSERTED
    )
END

--REGISTROS PRESTAMOS
INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon) VALUES
(1, GETDATE(), DATEADD(DAY, 2, GETDATE()), 'activo', 1),
(2, GETDATE(), DATEADD(DAY, 3, GETDATE()), 'activo', 4),
(3, GETDATE(), DATEADD(DAY, 4, GETDATE()), 'activo', 5),
(4, GETDATE(), DATEADD(DAY, 1, GETDATE()), 'activo', 2);

SELECT * FROM PRESTAMO

--REGISTROS DETALLE_PRESTAMO
INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_equipo, fecha_devolucion_real, estado_devolucion) VALUES
(1, 'LPT-001', NULL, NULL),
(2, 'PRJ-002', NULL, NULL),
(3, 'SW-003', NULL, NULL),
(4, 'MMT-004', NULL, NULL);

SELECT * FROM EQUIPO -- Comprueben si los registros con el id_equipo estan prestados

--ESTE TRIGGER ES PARA CUANDO SE REGISTRE LA FECHA DE DEVOLUCIÓN DENTRO DE UN DETALLE PRESTAMO EL ESTADO DEL EQUIPO PASE DE PRESTADO A DISPONIBLE
CREATE TRIGGER tr_ActualizarEstado
ON DETALLE_PRESTAMO
AFTER UPDATE
AS 
BEGIN
    UPDATE EQUIPO
    SET estado = 'disponible'
    WHERE id_equipo IN (
        SELECT i.id_equipo
        FROM inserted i
        INNER JOIN deleted d ON i.id_detalle_prestamo = d.id_detalle_prestamo
        WHERE i.fecha_devolucion_real IS NOT NULL AND d.fecha_devolucion_real IS NULL
    );
END;
SELECT * FROM DETALLE_PRESTAMO

UPDATE DETALLE_PRESTAMO
SET fecha_devolucion_real = GETDATE()
WHERE id_detalle_prestamo = 4;

UPDATE DETALLE_PRESTAMO
SET estado_devolucion = 'En buenas condiciones'
WHERE id_detalle_prestamo = 4;

SELECT * FROM DETALLE_PRESTAMO -- Ver si se actualizo fecha y estado
SELECT * FROM EQUIPO  -- Comprobar si el equipo esta otra vez disponible

--ESTE TRIGGER HACE QUE VERIFICA SI LOS EQUIPOS ESTAN EN MANTENIMIENTO O SI NO ESTAN DISPONIBLES PARA NO PERMITIR UN PRESTMOA
CREATE TRIGGER tr_NoPrestarEquiposNoDisponibles
ON DETALLE_PRESTAMO
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN EQUIPO e ON i.id_equipo = e.id_equipo
        WHERE e.estado <> 'disponible'
    )
    BEGIN
        RAISERROR('No se encuentra disponible el equipo', 16, 1);
        RETURN;
    END

    INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_equipo, fecha_devolucion_real, estado_devolucion)
    SELECT i.id_prestamo, i.id_equipo, i.fecha_devolucion_real, i.estado_devolucion
    FROM inserted i;
END;

SELECT * FROM DETALLE_PRESTAMO

--REGISTROS PRESTAMOS
INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon) VALUES
(5, GETDATE(), DATEADD(DAY, 3, GETDATE()), 'activo', 3);

--DEBE LANZAR ERROR DE QUE NO ESTA DISPONIBLE ESO
INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_equipo, fecha_devolucion_real, estado_devolucion) VALUES
(5, 'PC-007', GETDATE(), 'En buenas condiciones');

--TRIGGER PARA QUE LOS USUARIOS INACTIVOS NO HAGAN NADA
CREATE TRIGGER tr_NoPrestarUsuariosInactivos
ON PRESTAMO
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN USUARIO u ON i.id_usuario = u.id_usuario
        WHERE u.estado = 'inactivo'
    )
    BEGIN
        RAISERROR('El usuario esta inactivo', 16, 1);
        RETURN;
    END

    INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon)
    SELECT i.id_usuario, i.fecha_prestamo, i.fecha_devolucion_programada, i.estado, i.id_salon
    FROM inserted i;
END;

UPDATE USUARIO SET estado = 'inactivo' WHERE nombre = 'Luis';

-- DEBE LANZAR ERROR QUE ESTA INACTIVO 
INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon) VALUES
(5, GETDATE(), DATEADD(DAY, 3, GETDATE()), 'activo', 3);

UPDATE USUARIO SET estado = 'activo' WHERE nombre = 'Luis';

--ESTE TRIGGER ES PARA CUANDO SE REGISTRE UN MANTENIMIENTO SE PONGA EL EQUIPO COMO mantenimiento EN ESTADO
CREATE TRIGGER tr_RegistrarMantenimiento
ON HISTORIAL_MANTENIMIENTO
AFTER INSERT 
AS
BEGIN
	UPDATE EQUIPO
	SET estado = 'mantenimiento'
	WHERE id_equipo IN (
        SELECT id_equipo FROM INSERTED
    )
END;


-- Registrar historial de mantenimiento manualmente
INSERT INTO HISTORIAL_MANTENIMIENTO (id_equipo, fecha_inicio, fecha_fin_programada, fecha_fin_real, tipo_mantenimiento, descripcion, estado, id_responsable) VALUES
('PC-006', '2024-05-10', '2024-05-12', NULL, 'correctivo', 'Revision de pantalla.', 'pendiente', 3);

SELECT * FROM EQUIPO

--PROCEDIMIENTOS ALMACENADOS
-- SP para actualizar préstamos vencidos
CREATE PROCEDURE sp_ActualizarVencidos
AS
BEGIN
    UPDATE P
    SET P.estado = 'vencido'
    FROM PRESTAMO P
    WHERE P.estado <> 'vencido'
      AND P.fecha_devolucion_programada < GETDATE()
      AND EXISTS (
          SELECT 1
          FROM DETALLE_PRESTAMO D
          WHERE D.id_prestamo = P.id_prestamo
            AND D.fecha_devolucion_real IS NULL
      );

    PRINT 'Préstamos vencidos actualizados';
END;

-- Insertar préstamo con fecha vencida
INSERT INTO PRESTAMO (id_usuario, fecha_prestamo, fecha_devolucion_programada, estado, id_salon)
VALUES (1, GETDATE() - 10, GETDATE() - 5, 'activo', 1);  -- Prestamo vencido

SELECT * FROM PRESTAMO

INSERT INTO EQUIPO (id_equipo, nombre, modelo, marca, serie, estado, id_categoria, fecha_adquisicion, stock) VALUES
('LPT-008', 'Laptop HP', 'HP 15', 'HP', 'SN12567', 'disponible', 1, '2023-02-15', 100);

INSERT INTO DETALLE_PRESTAMO (id_prestamo, id_equipo)
VALUES (6, 'LPT-008');

--PROBAR SP
EXEC sp_ActualizarVencidos;

--VER SI FUNCIONA ESTO 
SELECT * FROM PRESTAMO WHERE id_prestamo = 6; --ver si esta vencido
