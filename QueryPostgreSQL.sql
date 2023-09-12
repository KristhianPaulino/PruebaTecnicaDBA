CREATE DATABASE VirtualStore;

CREATE TABLE Productos (
    ProductoID serial PRIMARY KEY,
    Nombre varchar(255) NOT NULL,
    Descripcion text,
    Precio numeric(10, 2),
    Stock integer,
    CategoriaID integer REFERENCES Categorias(CategoriaID)
);

CREATE TABLE Categorias (
    CategoriaID serial PRIMARY KEY,
    Nombre varchar(255) NOT NULL
);

CREATE TABLE Clientes (
    ClienteID serial PRIMARY KEY,
    Nombre varchar(255) NOT NULL,
    Apellido varchar(255) NOT NULL,
    CorreoElectronico varchar(255),
    Direccion text,
    PaisID integer REFERENCES Paises(PaisID)
);

CREATE TABLE Pedidos (
    PedidoID serial PRIMARY KEY,
    ClienteID integer REFERENCES Clientes(ClienteID),
    FechaPedido date,
    Estado varchar(255)
);

CREATE TABLE DetallesPedidos (
    DetalleID serial PRIMARY KEY,
    PedidoID integer REFERENCES Pedidos(PedidoID),
    ProductoID integer REFERENCES Productos(ProductoID),
    Cantidad integer,
    PrecioUnitario numeric(10, 2)
);

CREATE TABLE Envios (
    EnvioID serial PRIMARY KEY,
    PedidoID integer REFERENCES Pedidos(PedidoID),
    FechaEnvio date,
    MetodoEnvio varchar(255),
    DireccionEnvio text
);

CREATE TABLE Paises (
    PaisID serial PRIMARY KEY,
    NombrePais varchar(255) NOT NULL
);

CREATE TABLE BitacoraCambios (
    BitacoraID serial PRIMARY KEY,
    TablaModificada varchar(255) NOT NULL,
    RegistroID integer,
    CampoModificado varchar(255),
    ValorAntiguo text,
    ValorNuevo text,
    FechaCambio timestamp,
    Usuario varchar(255)
);

--Politicas de almacenamiento y filas eliminadas

CREATE EXTENSION IF NOT EXISTS pg_repack;

SELECT pg_repack.repack_table('public.pedidos', full); --Comprension de la tabla pedidos para optimizar rendimiento y espacio.

ALTER TABLE pedidos ADD COLUMN eliminado boolean DEFAULT false;

UPDATE pedidos SET eliminado = true WHERE pedido_id = 1;

SELECT * FROM pedidos WHERE eliminado = false;

--Se agrego una columna "eliminado" a las tablas relevantes y establecer su valor en "true" cuando se marque una fila como eliminada

SELECT pg_repack.repack_table('public.Bitacoracambios', 'quiet=true, only=true'); --Creacion de scripts para la reorganizacion de scripts.

ANALYZE detallespedidos; --Actualizacion de estadisticas

DELETE FROM nombre_tabla WHERE fecha < NOW() - INTERVAL '1 year'; --Purga de registros 

--COPIA DE SEGURIDAD COPLETA --Ejecutar en terminal de lineas de comando.

pg_dump -U usuario -d basededatos -f copia_completa.sql

--COPIA DE SEGURIDAD DIFERENCIAL 

pgbackrest --stanza=nombre_stanza backup

--Implementacion de políticas de control de acceso en el nivel de filas para restringir la visibilidad de datos confidenciales.

--Habilitar la Extensión RLS:
CREATE EXTENSION IF NOT EXISTS row_security;

--Definir una Política de Seguridad:
CREATE POLICY restriccion_pedido
ON detallespedidos
FOR SELECT
USING (rol = 'usuario');

--Asociar la politica
ALTER TABLE detallepedidos ENABLE ROW LEVEL SECURITY;





