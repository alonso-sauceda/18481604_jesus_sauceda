CREATE TABLE IF NOT EXISTS clientes (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE DEFAULT CURRENT_DATE
);

INSERT INTO clientes (nombre, correo, telefono, rfc, edad, ciudad, codigo_postal)
VALUES 
('Juan Pérez', 'juan.perez@example.com', '6671234567', 'PERJ900101HA1', 34, 'Culiacán', '80000'),
('Ana López', 'ana@example.com', '6677654321', 'LOPA850505MA2', 25, 'Mazatlán', '82000'),
('Carlos Ruiz', 'carlos.ruiz@example.com', '6689998877', 'RUCC781112HA3', 62, 'Los Mochis', '81200'),
('María Gómez', 'maria.gomez@example.com', '6674443322', 'GOMA920315MA4', 17, 'Culiacán', '80010');

DROP TABLE IF EXISTS clientes_soporte;

CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

INSERT INTO clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono
FROM clientes;

SELECT * FROM clientes_soporte;