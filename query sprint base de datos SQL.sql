-- 1. se creo un usuario como adminsprint

-- 2. Crear la base de datos
CREATE DATABASE IF NOT EXISTS telovendosprint;
USE telovendosprint;

-- 3. Crear las tablas

-- Tabla para proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,    -- Identificador único del proveedor
    nombre_representante VARCHAR(100) NOT NULL,  -- Nombre del representante legal
    nombre_corporativo VARCHAR(100) NOT NULL,    -- Nombre corporativo del proveedor
    telefono1 VARCHAR(15) NOT NULL,            -- Primer número de contacto
    nombre_contacto1 VARCHAR(100) NOT NULL,     -- Nombre del contacto para el primer teléfono
    telefono2 VARCHAR(15),                     -- Segundo número de contacto (opcional)
    nombre_contacto2 VARCHAR(100),             -- Nombre del contacto para el segundo teléfono (opcional)
    categoria_producto VARCHAR(50) NOT NULL,    -- Categoría de productos que ofrece
    correo_electronico VARCHAR(100) NOT NULL    -- Correo electrónico para enviar la factura
);

-- Tabla para clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Identificador único del cliente
    nombre VARCHAR(50) NOT NULL,           -- Nombre del cliente
    apellido VARCHAR(50) NOT NULL,         -- Apellido del cliente
    direccion VARCHAR(255) NOT NULL        -- Dirección del cliente
);

-- Tabla para productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,     -- Identificador único del producto
    nombre VARCHAR(100) NOT NULL,         -- Nombre del producto
    precio DECIMAL(10, 2) NOT NULL,       -- Precio del producto
    categoria VARCHAR(50) NOT NULL,       -- Categoría del producto
    color VARCHAR(50) NOT NULL,           -- Color del producto
    stock INT NOT NULL,                   -- Cantidad en stock del producto
    proveedor_id INT NOT NULL,            -- Relación con la tabla proveedores
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)  -- Llave foránea
);

-- 4. Insertar datos en la tabla proveedores

START TRANSACTION;

INSERT INTO proveedores (nombre_representante, nombre_corporativo, telefono1, nombre_contacto1, telefono2, nombre_contacto2, categoria_producto, correo_electronico) VALUES
('Juan Pérez', 'Proveedores SA', '555-1234', 'Ana Ruiz', '555-5678', 'Luis Gómez', 'Electrónica', 'factura@proveedorsa.com'),
('Laura Martínez', 'Tecnología Ltda', '555-8765', 'Pedro Díaz', NULL, NULL, 'Informática', 'factura@tecnologialtda.com'),
('Carlos Sánchez', 'Moda y Estilo', '555-4321', 'María López', '555-6789', 'Julio Torres', 'Ropa', 'factura@modaestilo.com'),
('Sofía Gómez', 'ElectroWorld', '555-1111', 'Luis Pérez', '555-2222', 'Nina Fernández', 'Electrodomésticos', 'factura@electroworld.com'),
('Alejandro Torres', 'Hogar y Más', '555-3333', 'Andrea Martínez', NULL, NULL, 'Muebles', 'factura@hogarymas.com');

SELECT * FROM proveedores;

update proveedores
set nombre_representante = 'alejandrita torres'
WHERE id = 5;

INSERT INTO proveedores (nombre_representante, nombre_corporativo, telefono1, nombre_contacto1, telefono2, nombre_contacto2, categoria_producto, correo_electronico) VALUES
('Rodrigo Vasquez', 'Proveedores a eliminar SA', '555-1234', 'anabrita ', '555-5678', 'luis guitierrez', 'Electrónica', 'factura@proveedoraeliminarsa.com');  -- agregamos un nuevo proveedor

delete FROM proveedores
where id = 6; -- eliminamos el proveedor creado

ROLLBACK; -- deshacemos la eliminacion realizada

COMMIT; --  Nos aseguramos que la transaccion es valida


-- 5. Insertar datos en la tabla clientes
INSERT INTO clientes (nombre, apellido, direccion) VALUES
('Ana', 'García', 'Calle Falsa 123'),
('Mario', 'Hernández', 'Avenida Siempre Viva 742'),
('Claudia', 'Morales', 'Boulevard de los Sueños 456'),
('Jorge', 'Castro', 'Plaza de la Libertad 9'),
('Isabel', 'Vega', 'Camino Real 321');

-- 6. Insertar datos en la tabla productos
INSERT INTO productos (nombre, precio, categoria, color, stock, proveedor_id) VALUES
('Laptop HP', 1200000, 'Electrónica', 'Negro', 15, 1),
('Smartphone Samsung', 800000, 'Electrónica', 'Gris', 25, 1),
('Cámara Canon', 500000, 'Electrónica', 'Rojo', 5, 2),
('Monitor Dell', 300000, 'Electrónica', 'Negro', 10, 1),
('Tablet Lenovo', 200000, 'Electrónica', 'Azul', 8, 2),
('Silla Ergonomica', 150000, 'Muebles', 'Gris', 20, 5),
('Sofá Cama', 600000, 'Muebles', 'Beige', 10, 5),
('Camiseta Nike', 30000, 'Ropa', 'Rojo', 50, 3),
('Jeans Levi\'s', 60000, 'Ropa', 'Azul', 30, 3),
('Cartera Gucci', 150000, 'Moda', 'Negro', 15, 3);




-- 7. Consultas

-- Categoría de productos que más se repite
SELECT categoria, COUNT(*) AS cantidad
FROM productos
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Productos con mayor stock
SELECT nombre, stock
FROM productos
ORDER BY stock DESC;

-- Color de producto más común
SELECT color, COUNT(*) AS cantidad
FROM productos
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Proveedores con menor stock de productos
SELECT p.nombre_corporativo, MIN(prod.stock) AS menor_stock
FROM proveedores p
JOIN productos prod ON p.id = prod.proveedor_id
GROUP BY p.nombre_corporativo
ORDER BY menor_stock ASC;

-- 8. Actualizar la categoría de productos más popular
UPDATE productos
SET categoria = 'Electrónica y computación'
WHERE categoria = (SELECT categoria
                   FROM (SELECT categoria, COUNT(*) AS cantidad
                         FROM productos
                         GROUP BY categoria
                         ORDER BY cantidad DESC
                         LIMIT 1) AS subquery);