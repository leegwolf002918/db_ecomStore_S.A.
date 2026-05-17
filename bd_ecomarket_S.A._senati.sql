create database if not exists bd_EcomStore;

use bd_EcomStore;

-- tablaCLIENTES
create table if not exists tb_clientes(
	idCliente int auto_increment primary key not null,
    dni char(8) not null unique,
	nombre varchar(80) not null,
    correo varchar(120) not null unique,
    edad int not null check (edad>=18),
	direccion varchar(90) not null,
    telefono varchar(12) not null unique
);

-- tablaPRODUCTOS
create table if not exists tb_productos(
	idProducto int auto_increment primary key not null,
    nombre varchar(80) not null,
    precio decimal (10,2) not null check
    (precio > 0),
    stock int default 0 check
    (stock >= 0)
);


-- Tabla PEDIDOS
CREATE TABLE IF NOT EXISTS tb_pedidos(
    idPedido int auto_increment primary key,
    cantidad int not null check (cantidad > 0),
    fecha date not null,
    idCliente int not null,
    idProducto int not null,
    CONSTRAINT fk_clientes_pedidos
        foreign key (idCliente) references tb_clientes(idCliente)
        on delete cascade on update cascade,
    CONSTRAINT fk_producto_pedidos
        foreign key (idProducto) references tb_productos(idProducto)
        on delete cascade on update cascade
);


-- Inserción de datos
insert into tb_clientes (dni, nombre, correo, edad, direccion, telefono)
value ('12345678', 'Leonardo Curay', 'leonardo.curay@gmail.com', 20, 'Av. Los Olivos 123', '+51999888777'),
('23456789', 'María López', 'maria.lopez@yahoo.com', 35, 'Jr. San Martín 456', '+51988776655'),
('34567890', 'José Ramírez', 'jose.ramirez@hotmail.com', 42, 'Av. La Marina 789', '+51977665544'),
('45678901', 'Ana Torres', 'ana.torres@gmail.com', 25, 'Calle Primavera 321', '+51966554433'),
('56789012', 'Luis Fernández', 'luis.fernandez@yahoo.com', 30, 'Av. Universitaria 654', '+51955443322'),
('67890123', 'Carmen Díaz', 'carmen.diaz@hotmail.com', 38, 'Jr. Los Pinos 987', '+51944332211'),
('78901234', 'Miguel Castillo', 'miguel.castillo@gmail.com', 27, 'Av. Colonial 741', '+51933221100'),
('89012345', 'Patricia Gómez', 'patricia.gomez@yahoo.com', 33, 'Calle Central 852', '+51922110099'),
('90123456', 'Ricardo Sánchez', 'ricardo.sanchez@hotmail.com', 40, 'Av. Faucett 963', '+51911009988'),
('01234567', 'Lucía Herrera', 'lucia.herrera@gmail.com', 22, 'Jr. Las Flores 159', '+51900998877');

insert into tb_productos (nombre, precio, stock) 
values ('Laptop Lenovo ThinkPad', 3200.00, 15),
('Smartphone Samsung', 2800.00, 25),
('Tablet Apple iPad Air', 2500.00, 20),
('Auriculares Bluetooth Sony', 1200.00, 30),
('Monitor LG UltraWide 34"', 1800.00, 10),
('Teclado Mecánico Logitech', 450.00, 40),
('Mouse Gamer Razer', 350.00, 50),
('Smartwatch Apple Watch', 2200.00, 18),
('Consola PlayStation 5', 3200.00, 12),
('Disco SSD Samsung 1TB', 600.00, 35);

insert into tb_pedidos (cantidad,fecha,idCliente,idProducto)
values (5,"2026-05-10","2","5"),
(2,"2026-01-11","1","1"),
(3,"2026-01-11","1","5"),
(6,"2026-04-08","3","2"),
(3,"2026-03-27","4","8"),
(10,"2026-03-27","5","7");


-- Select
select * from tb_clientes;
select * from tb_productos;
select * from tb_pedidos;

-- busqueda por letra
delimiter %%
create procedure buscar_clientes(
    in p_inicial char(1)
)
begin
    select idCliente, nombre, correo, telefono
    from tb_clientes
    where nombre like CONCAT(p_inicial, '%')
    order by nombre asc;
end %%
delimiter ;

call buscar_clientes("L");

-- busqueda por DNI como en reniec
DELIMITER $$
CREATE PROCEDURE buscar_por_dni(
    IN p_dni CHAR(8)
)
BEGIN
    SELECT idCliente, nombre, dni, correo, telefono
    FROM tb_clientes
    WHERE dni = p_dni;
END $$
DELIMITER ;

CALL buscar_por_dni('12345678');



-- registrar a un cliente
DELIMITER %%
create procedure agregar_cliente(
    in p_dni char(8),
    in p_nombre varchar(80),
    in p_correo varchar(120),
    in p_edad int,
    in p_direccion varchar(90),
    in p_telefono varchar(12)
)
begin
    insert into tb_clientes (dni, nombre, correo, edad, direccion, telefono)
    value (p_dni, p_nombre, p_correo, p_edad, p_direccion, p_telefono);
end %%
DELIMITER ;

call agregar_cliente('12345678', 'Carlos Pérez', 'carlos.perez@gmail.com', 28, 'Av. Los Olivos 123', '+51999888777');


-- eliminar a un cliente
DELIMITER $$
CREATE PROCEDURE eliminar_cliente(
    IN p_idCliente INT
)
BEGIN
    DELETE FROM tb_clientes
    WHERE idCliente = p_idCliente;
END $$
DELIMITER ;

CALL eliminar_cliente(5);


-- eliminar producto
DELIMITER $$
CREATE PROCEDURE eliminar_producto(
    IN p_idProducto INT
)
BEGIN
    DELETE FROM tb_productos
    WHERE idProducto = p_idProducto;
END $$
DELIMITER ;

-- Uso:
CALL eliminar_producto(1);


-- actualizar stock
DELIMITER $$
CREATE PROCEDURE actualizar_stock(
    IN p_idProducto INT,
    IN p_nuevoStock INT
)
BEGIN
    UPDATE tb_productos
    SET stock = p_nuevoStock
    WHERE idProducto = p_idProducto;
END $$
DELIMITER ;

CALL actualizar_stock(1, 20);
