-- Actividad 3: Generación de tráfico auditado (DDL, DML y consulta de log activo)
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO clientes (nombre, email) VALUES ('Juan Pérez', 'juan@example.com');
INSERT INTO clientes (nombre, email) VALUES ('María López', 'maria@example.com');

UPDATE clientes SET email = 'juan.perez@domain.com' WHERE id = 1;

SELECT * FROM clientes;

SELECT pg_current_logfile();