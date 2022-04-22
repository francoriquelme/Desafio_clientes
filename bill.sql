-- 1.- Cargar el respaldo de la base de datos unidad2.sql.
-- Se crea Database bill y se importa el archivo unidad2.sql
-- Se consulta con \l las bases de datos existentes y de la misma forma, se valida la creación de bill
-- \q salir de consola psql
-- $ psql -U francoriquelme bill < unidad2.sql (Importar archivo a Database) -- Ejecuto comando desde terminal
-- $ psql para ingresar a consola psql
-- \c bill para llamar a la base de datos con la que trabajaremos
-- \dt Se ocupara para verificar las tablas creadas desde el respaldo
-- \set AUTOCOMMIT off IMPORTANTE: Para cumplir los siguientes requerimientos, debes recordar tener desactivado el autocommit en tu base de datos, esto se realiza desde psql en la base de datos que estamos trabajando, en este caso: bill
-- \echo :AUTOCOMMIT verificar el estado de autocommit

-- 2.- El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9.
-- ● cantidad: 5.
-- ● fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este requerimiento y luego consulta la tabla producto para validar si fue efectivamente descontado en el stock. 

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha)
VALUES (33, 1, current_date);
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (43, 9, 33, 5);
UPDATE producto SET stock = stock - 5 WHERE id = 9; 
COMMIT;
SAVEPOINT primera_compra;
--Consultamos la tabla compra para ver el resulado de la transacción.
SELECT * FROM compra;
-- -- Luego, consultar la tabla producto (los productos deben estar descontados del stock inicial que era 8)
SELECT * FROM producto;

-- 3.- El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto 2, producto 8.
-- ● cantidad: 3 de cada producto.
-- ● fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realice la compra. 

BEGIN TRANSACTION;
INSERT INTO compra (id, cliente_id, fecha)
VALUES (34, 2, current_date);
-- Producto N° 1
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (44, 1, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 1; 

-- Producto N° 2
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (45, 2, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 2;


-- Producto N° 8
INSERT INTO detalle_compra (id, producto_id, compra_id, cantidad)
VALUES (46, 8, 34, 3);
UPDATE producto SET stock = stock - 3 WHERE id = 8; 
ROLLBACK TO primera_compra;
COMMIT;

-- Consultamos la tabla compra para validar que la transacción se haya ejecutado.
SELECT * FROM compra;
-- Consultamos la tabla producto para validar que se vendió el prodcuto 1 y 2, no así el producto 8, debido a no tener stock suficiente.
SELECT * FROM producto;

-- 4.- Realizar las siguientes consultas:
-- a. Deshabilitar el AUTOCOMMIT .
\set AUTOCOMMIT off

-- b. Insertar un nuevo cliente.

INSERT INTO cliente(id, nombre, email)
VALUES(11, 'usuario11', 'usuario11@hotmail.com');

-- c. Confirmar que fue agregado en la tabla cliente.

SELECT * FROM cliente;

-- d. Realizar un ROLLBACK.
ROLLBACK;
-- e. Confirmar que se restauró la información, sin considerar la inserción del punto b.

SELECT * FROM cliente;
-- f. Habilitar de nuevo el AUTOCOMMIT.

\set AUTOCOMMIT on

-- el respaldo de la base se hace desde la terminal
-- \q para salir de la consola sql
-- $ pg_dump -U francoriquelme bill > respaldo_bill.sql respaldar la base de datos 