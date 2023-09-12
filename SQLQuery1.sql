CREATE DATABASE VirtualStore

USE VirtualStore

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY,
    Nombre VARCHAR(60),
    Descripcion TEXT,
    Precio DECIMAL(10, 2), 
    Stock INT,
    CategoriaID INT,
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID) 
);

CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY,
    Nombre VARCHAR(60)
);

CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nombre VARCHAR(60),
    Apellido VARCHAR(60),
    CorreoElectronico VARCHAR(60),
    Direccion TEXT,
    PaisID INT,
    FOREIGN KEY (PaisID) REFERENCES Paises(PaisID) 
);

CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY,
    ClienteID INT,
    FechaPedido DATE,
    Estado VARCHAR(60),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID) 
);

CREATE TABLE DetallesPedidos (
    DetalleID INT PRIMARY KEY,
    PedidoID INT,
    ProductoID INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10, 2), 
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID), 
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID) 
);

CREATE TABLE Envios (
    EnvioID INT PRIMARY KEY,
    PedidoID INT,
    FechaEnvio DATE,
    MetodoEnvio VARCHAR(60),
    DireccionEnvio TEXT,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID)
);

CREATE TABLE Paises (
    PaisID INT PRIMARY KEY,
    NombrePais VARCHAR(60)
);

CREATE TABLE BitacoraCambios (
    BitacoraID INT PRIMARY KEY,
    Tabla VARCHAR(60),
    RegistroID INT,
    CampoModificado VARCHAR(60),
    ValorAntiguo VARCHAR(60),
    ValorNuevo VARCHAR(60),
    FechaCambio TIMESTAMP,
    Usuario VARCHAR(60)
);

/*

Relaciones:

Un Producto pertenece a una Categor�a (relaci�n uno a muchos).
Un Cliente puede realizar varios Pedidos (relaci�n uno a muchos).
Un Pedido puede tener varios Detalles de Pedidos (relaci�n uno a muchos).
Un Pedido est� asociado a un Cliente (clave for�nea ClienteID).
Un Detalle de Pedido est� asociado a un Producto (clave for�nea ProductoID).
Un Env�o est� asociado a un Pedido (clave for�nea PedidoID).
Un Cliente tiene una direcci�n en un Pa�s (clave for�nea Pa�sID).*/

--inserci�n de datos

INSERT INTO Categorias (CategoriaID, Nombre)
VALUES
    (1, 'Electr�nica'),
    (2, 'Ropa'),
    (3, 'Alimentos');

INSERT INTO Paises (PaisID, NombrePais)
VALUES
    (1, 'Estados Unidos'),
    (2, 'Canad�'),
    (3, 'M�xico');

INSERT INTO Productos (ProductoID, Nombre, Descripcion, Precio, Stock, CategoriaID)
VALUES
    (1, 'Smartphone', 'Tel�fono inteligente de �ltima generaci�n', 699.99, 100, 1),
    (2, 'Camiseta', 'Camiseta de algod�n de manga corta', 19.99, 200, 2),
    (3, 'Cereal', 'Cereal para el desayuno', 3.99, 500, 3);

INSERT INTO Clientes (ClienteID, Nombre, Apellido, CorreoElectronico, Direccion, PaisID)
VALUES
    (1, 'Juan', 'P�rez', 'juan@example.com', '123 Calle Principal', 1),
    (2, 'Ana', 'G�mez', 'ana@example.com', '456 Avenida Central', 2),
    (3, 'Carlos', 'S�nchez', 'carlos@example.com', '789 Calle Secundaria', 3);

INSERT INTO Pedidos (PedidoID, ClienteID, FechaPedido, Estado)
VALUES
    (1, 1, '2023-09-07', 'En proceso'),
    (2, 2, '2023-09-08', 'Entregado'),
    (3, 3, '2023-09-09', 'En camino');

INSERT INTO DetallesPedidos (DetalleID, PedidoID, ProductoID, Cantidad, PrecioUnitario)
VALUES
    (1, 1, 1, 2, 699.99),
    (2, 2, 2, 3, 19.99),
    (3, 3, 3, 5, 3.99);

INSERT INTO Envios (EnvioID, PedidoID, FechaEnvio, MetodoEnvio, DireccionEnvio)
VALUES
    (1, 1, '2023-09-10', 'Env�o est�ndar', '123 Calle Principal'),
    (2, 2, '2023-09-11', 'Env�o r�pido', '456 Avenida Central'),
    (3, 3, '2023-09-12', 'Env�o est�ndar', '789 Calle Secundaria');

	--Creacion de indices para la optimizacion y velocidad de las consultas.

	--Indice Simple
	CREATE INDEX idx_Productos_Nombre ON Productos (Nombre);
	 
	--Indice Compuesto en multiples colunmas
	CREATE INDEX idx_Pedidos_ClienteFecha ON Pedidos (ClienteID, FechaPedido);

	--Indice Unico
	CREATE UNIQUE INDEX idx_Clientes_CorreoElectronico ON Clientes (CorreoElectronico);


	--Politicas de almacenamiento

	/*La compresi�n en el contexto de bases de datos se refiere a la t�cnica de reducir el tama�o de los datos almacenados en una tabla o �ndice. 
	Esto se hace para ahorrar espacio en disco y mejorar el rendimiento de las operaciones de lectura y escritura, ya que los datos comprimidos ocupan 
	menos espacio y pueden leerse o escribirse m�s r�pido.*/

	ALTER TABLE Productos REBUILD WITH (DATA_COMPRESSION = PAGE);

	/*Manejo de Filas Eliminadas:

a. Eliminaci�n L�gica: En lugar de eliminar f�sicamente las filas, puedes implementar un campo "Activo" para marcar las filas como inactivas cuando se eliminan. Por ejemplo:

ALTER TABLE Productos ADD Activo BIT DEFAULT 1;

Luego, al eliminar una fila:

UPDATE Productos SET Activo = 0 WHERE ProductoID = 123;*/



--COPIA DE SEGURIDAD COMPLETA

BACKUP DATABASE VirtualStore TO DISK = 'C:\Proyectos\SQL\Prueba tecnica\BACKUP.bak';

/*Copia Diferencial:

Una copia diferencial respalda solo los cambios realizados desde la �ltima copia completa. */

BACKUP DATABASE VirtualStore TO DISK = 'C:\Proyectos\SQL\Prueba tecnica\BACKUP.bak' WITH DIFFERENTIAL;

/*Copia de Registro de Transacciones:

Una copia de registro de transacciones respalda los cambios de registro de transacciones desde la �ltima copia de registro*/

BACKUP LOG VirtualStore TO DISK = 'C:\Proyectos\SQL\Prueba tecnica\BACKUP.trn';

--CREACION DE ROLES

CREATE ROLE Lectores;
CREATE ROLE Editores;
CREATE ROLE Administradores;

--CREACION DE LOGIN

CREATE LOGIN LogAdmin WITH PASSWORD = '1234'
CREATE LOGIN LogRead WITH PASSWORD = '1234'
CREATE LOGIN LogEdit WITH PASSWORD = '1234'

--CREACION DE USUARIO

CREATE USER UAdmin FOR LOGIN LogAdmin
CREATE USER URead	FOR LOGIN LogEdit
CREATE USER UEdit FOR LOGIN LogRead

--Otorgar permisos

GRANT SELECT --Permisos de SELECT
ON BitacoraCambios
TO UAdmin
WITH GRANT OPTION

GRANT INSERT --Permisos de INSERT
ON Clientes
TO Uedit 
WITH GRANT OPTION

GRANT DELETE --Permisos de DELETE
ON Pedidos
TO URead
WITH GRANT OPTION

--Agregar mas permisos a un usuario.

GRANT SELECT, DELETE, INSERT, UPDATE
ON BitacoraCambios
TO UAdmin
WITH GRANT OPTION

--Para eliminar privilegios se utiliza REVOKE

