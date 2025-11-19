CREATE DATABASE IF NOT EXISTS tienda_online;
USE tienda_online;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_alta DATE NOT NULL,
    estado ENUM('activo','inactivo') NOT NULL
);

CREATE TABLE direcciones_cliente (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    calle VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    es_principal TINYINT(1) NOT NULL,
    CONSTRAINT fk_direcciones_cliente_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_direcciones_cliente_cliente (id_cliente)
    );
    
    CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(100) NOT NULL,
    cuit VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_categoria INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    activo TINYINT(1) NOT NULL,
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_productos_categoria (id_categoria)
);

CREATE TABLE stock (
    id_stock INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    cantidad_actual INT NOT NULL,
    punto_pedido INT NOT NULL,
    ubicacion VARCHAR(50),
    CONSTRAINT fk_stock_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_stock_proveedor
        FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_stock_producto (id_producto),
    INDEX idx_stock_proveedor (id_proveedor)
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_direccion_envio INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    estado ENUM('pendiente','pagado','enviado','cancelado','entregado') NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_pedidos_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_pedidos_direccion
        FOREIGN KEY (id_direccion_envio) REFERENCES direcciones_cliente(id_direccion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_pedidos_cliente (id_cliente),
    INDEX idx_pedidos_direccion (id_direccion_envio)
);

CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedidos_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_pedidos_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_detalle_pedidos_pedido (id_pedido),
    INDEX idx_detalle_pedidos_producto (id_producto)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_pago DATETIME NOT NULL,
    metodo ENUM('tarjeta','transferencia','efectivo','mercado_pago') NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente','aprobado','rechazado') NOT NULL,
    CONSTRAINT fk_pagos_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_pagos_pedido (id_pedido)
);

CREATE TABLE envios (
    id_envio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    fecha_envio DATETIME,
    empresa VARCHAR(100),
    codigo_seguimiento VARCHAR(100),
    costo DECIMAL(10,2),
    estado ENUM('pendiente','en_transito','entregado','devuelto') NOT NULL,
    CONSTRAINT fk_envios_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    UNIQUE KEY uk_envios_pedido (id_pedido),
    INDEX idx_envios_pedido (id_pedido),
    INDEX idx_envios_codigo_seguimiento (codigo_seguimiento)
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    rol ENUM('admin','operador') NOT NULL,
    activo TINYINT(1) NOT NULL
);