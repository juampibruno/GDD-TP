USE [GD1C2023]
GO

CREATE PROCEDURE MigrarDatosBI
AS
BEGIN
--1.Hacemos la creacion de las Tablas

CREATE TABLE LOCKE.BI_Dimension_CategoriaLocal (
	IdCategoriaLocal  INT IDENTITY(1,1) PRIMARY KEY,
	Categoria NVARCHAR(50) DEFAULT 'Sin categoria'
)

CREATE TABLE LOCKE.BI_Dimension_Local (
	IdLocal  INT IDENTITY(1,1) PRIMARY KEY,
	Nombre NVARCHAR(100)
)

CREATE TABLE LOCKE.BI_Dimension_TipoLocal (
	IdTipoLocal  INT IDENTITY(1,1) PRIMARY KEY,
	TipoLocal NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_EstadoPedido (
	IdEstadoPedido INT IDENTITY(1,1) PRIMARY KEY,
	EstadoPedido NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_TipoMovilidad (
	IdTipoMovilidad  INT IDENTITY(1,1) PRIMARY KEY,
	TipoMovilidad NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_Localidad (
	IdLocalidad  INT IDENTITY(1,1) PRIMARY KEY,
	Nombre NVARCHAR(100)
)

CREATE TABLE LOCKE.BI_Dimension_RangoEtarioUsuario (
	IdEtarioUsuario  INT IDENTITY(1,1) PRIMARY KEY,
	EdadMinima INT NOT NULL,
	EdadMaxima INT NOT NULL
)

CREATE TABLE LOCKE.BI_Dimension_RangoEtarioRepartidor (
	IdEtarioRepartidor  INT IDENTITY(1,1) PRIMARY KEY,
	EdadMinima INT NOT NULL,
	EdadMaxima INT NOT NULL
)

CREATE TABLE LOCKE.BI_Dimension_RangoEtarioOperario (
	IdEtarioOperario  INT IDENTITY(1,1) PRIMARY KEY,
	EdadMinima INT NOT NULL,
	EdadMaxima INT NOT NULL
)

CREATE TABLE LOCKE.BI_Dimension_Dia (
	IdDia  INT IDENTITY(1,1) PRIMARY KEY,
	DiaSemana NVARCHAR(10)
)

CREATE TABLE LOCKE.BI_Dimension_RangoHorario (
	IdHorario  INT IDENTITY(1,1) PRIMARY KEY,
	HoraMinima INT NOT NULL,
	HoraMaxima INT NOT NULL
)

CREATE TABLE LOCKE.BI_Dimension_Anio (
	IdAnio INT NOT NULL PRIMARY KEY
)

CREATE TABLE LOCKE.BI_Dimension_Mes (
	IdMes INT NOT NULL PRIMARY KEY
)

CREATE TABLE LOCKE.BI_Dimension_EstadoEnvioMensajeria (
	IdEstadoEnvioMensajeria  INT IDENTITY(1,1) PRIMARY KEY,
	EstadoEnvio NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_TipoPaquete (
	IdTipoPaquete  INT IDENTITY(1,1) PRIMARY KEY,
	TipoPaquete NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_EstadoReclamo (
	IdEstadoReclamo  INT IDENTITY(1,1) PRIMARY KEY,
	EstadoReclamo NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Dimension_TipoReclamo (
	IdTipoReclamo  INT IDENTITY(1,1) PRIMARY KEY,
	TipoReclamo NVARCHAR(50)
)

CREATE TABLE LOCKE.BI_Hechos_Pedido (
	IdAnio INT NOT NULL,
	IdMes INT NOT NULL,
	IdDia INT NOT NULL,
	IdRangoHorario INT NOT NULL,
	IdLocalidadLocal INT NOT NULL,
	IdCategoriaLocal INT NOT NULL,
	IdEstadoPedido INT NOT NULL,
	IdTipoMovilidad INT NOT NULL,
	IdEtarioRepartidor INT NOT NULL,
	IdEtarioUsuario INT NOT NULL,
	IdLocal INT NOT NULL,
	IdTipoLocal INT NOT NULL,
	CantidadPedidos INT NOT NULL,
	MontoTotal DECIMAL(18,2) NOT NULL,
	PromedioValorEnvio DECIMAL(18,2) NOT NULL,
	TiempoEntregaPromedioEnMins INT, 
	MontoTotalCuponesUtilizados DECIMAL(18,2),
	CalificacionPromedio DECIMAL(18,0) CHECK (CalificacionPromedio BETWEEN 1 AND 5)
)

CREATE TABLE LOCKE.BI_Hechos_Mensajeria (
	IdAnio INT NOT NULL,
	IdMes INT NOT NULL,
	IdDia INT NOT NULL,
	IdRangoHorario INT NOT NULL,
	IdEstadoEnvioMensajeria INT NOT NULL,
	IdTipoMovilidad INT NOT NULL,
	IdEtarioRepartidor INT NOT NULL,
	IdLocalidadRepartidor INT NOT NULL,
	IdEtarioUsuario INT NOT NULL,
	IdTipoPaquete INT NOT NULL,
	CantidadEnviosMensajeria INT NOT NULL,
	TiempoEntregaPromedioEnMins INT, 
	PromedioValorAsegurado DECIMAL(18,2) CHECK (PromedioValorAsegurado >= 0)
)

CREATE TABLE LOCKE.BI_Hechos_Reclamo (
	IdAnio INT NOT NULL,
	IdMes INT NOT NULL,
	IdDia INT NOT NULL,
	IdRangoHorario INT NOT NULL,
	IdTipoReclamo INT NOT NULL,
	IdEtarioOperario INT NOT NULL,
	IdEstadoReclamo INT NOT NULL,
	CantidadReclamos INT NOT NULL,
	TiempoResolucionPromedioEnMins INT, 
	MontoTotalCuponesGenerado DECIMAL(18,2) 
)

PRINT ('Creacion de Tablas realizada correctamente')


--2.Agregamos las PKS a las tablas 
------------------------------------------------PKS---------------------------------------

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD PRIMARY KEY (IdAnio,IdMes,IdDia,IdRangoHorario,IdLocalidadLocal,IdCategoriaLocal,IdEstadoPedido,IdTipoMovilidad,IdEtarioRepartidor,IdEtarioUsuario,IdLocal,IdTipoLocal)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD PRIMARY KEY (IdAnio,IdMes,IdDia,IdRangoHorario,IdEstadoEnvioMensajeria,IdTipoMovilidad,IdEtarioRepartidor,IdLocalidadRepartidor,IdEtarioUsuario,IdTipoPaquete)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD PRIMARY KEY (IdAnio,IdMes,IdDia,IdRangoHorario,IdTipoReclamo,IdEtarioOperario,IdEstadoReclamo)

--3.Agregamos las FKS a las tablas 
----------------------------------------------FKS----------------------------------------------
----------------Fks de Pedido----------------------------------------------------------------

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdAnio) REFERENCES LOCKE.BI_Dimension_Anio (IdAnio)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdMes) REFERENCES LOCKE.BI_Dimension_Mes (IdMes)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdDia) REFERENCES LOCKE.BI_Dimension_Dia (IdDia)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdRangoHorario) REFERENCES LOCKE.BI_Dimension_RangoHorario (IdHorario)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdLocalidadLocal) REFERENCES LOCKE.BI_Dimension_Localidad (IdLocalidad)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdCategoriaLocal) REFERENCES LOCKE.BI_Dimension_CategoriaLocal (IdCategoriaLocal)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdEstadoPedido) REFERENCES LOCKE.BI_Dimension_EstadoPedido (IdEstadoPedido)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdTipoMovilidad) REFERENCES LOCKE.BI_Dimension_TipoMovilidad (IdTipoMovilidad)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdEtarioRepartidor) REFERENCES LOCKE.BI_Dimension_RangoEtarioRepartidor (IdEtarioRepartidor)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdEtarioUsuario) REFERENCES LOCKE.BI_Dimension_RangoEtarioUsuario (IdEtarioUsuario)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdLocal) REFERENCES LOCKE.BI_Dimension_Local (IdLocal)

ALTER TABLE LOCKE.BI_Hechos_Pedido
ADD FOREIGN KEY (IdTipoLocal) REFERENCES LOCKE.BI_Dimension_TipoLocal (IdTipoLocal)

----------------Fks de Mensajeria----------------------------------------------------------------

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdAnio) REFERENCES LOCKE.BI_Dimension_Anio (IdAnio)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdMes) REFERENCES LOCKE.BI_Dimension_Mes (IdMes)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdDia) REFERENCES LOCKE.BI_Dimension_Dia (IdDia)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdRangoHorario) REFERENCES LOCKE.BI_Dimension_RangoHorario (IdHorario)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdEstadoEnvioMensajeria) REFERENCES LOCKE.BI_Dimension_EstadoEnvioMensajeria (IdEstadoEnvioMensajeria)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdTipoMovilidad) REFERENCES LOCKE.BI_Dimension_TipoMovilidad (IdTipoMovilidad)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdEtarioRepartidor) REFERENCES LOCKE.BI_Dimension_RangoEtarioRepartidor (IdEtarioRepartidor)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdLocalidadRepartidor) REFERENCES LOCKE.BI_Dimension_Localidad (IdLocalidad)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdEtarioUsuario) REFERENCES LOCKE.BI_Dimension_RangoEtarioUsuario (IdEtarioUsuario)

ALTER TABLE LOCKE.BI_Hechos_Mensajeria
ADD FOREIGN KEY (IdTipoPaquete) REFERENCES LOCKE.BI_Dimension_TipoPaquete (IdTipoPaquete)

----------------Fks de Reclamo----------------------------------------------------------------

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdAnio) REFERENCES LOCKE.BI_Dimension_Anio (IdAnio)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdMes) REFERENCES LOCKE.BI_Dimension_Mes (IdMes)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdDia) REFERENCES LOCKE.BI_Dimension_Dia (IdDia)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdRangoHorario) REFERENCES LOCKE.BI_Dimension_RangoHorario (IdHorario)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdTipoReclamo) REFERENCES LOCKE.BI_Dimension_TipoReclamo (IdTipoReclamo)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdEtarioOperario) REFERENCES LOCKE.BI_Dimension_RangoEtarioOperario (IdEtarioOperario)

ALTER TABLE LOCKE.BI_Hechos_Reclamo
ADD FOREIGN KEY (IdEstadoReclamo) REFERENCES LOCKE.BI_Dimension_EstadoReclamo (IdEstadoReclamo)


PRINT ('PKs y FKs Creadas Correctamente')

--4.Insertamos los datos a las Tablas
-------------------------INSERTS----------------------------------------------------------------------
--Primero insertamos todas las tablas de dimensiones

--Dimension_CategoriaLocal
INSERT INTO LOCKE.BI_Dimension_CategoriaLocal(Categoria)
(SELECT CATE_CATEGORIA FROM LOCKE.CATEGORIA_LOCAL);

INSERT INTO LOCKE.BI_Dimension_CategoriaLocal(Categoria)
VALUES('Sin categoria');

--Local
INSERT INTO LOCKE.BI_Dimension_Local(Nombre)
(SELECT LOCAL_NOMBRE FROM LOCKE.LOCAL);

--TipoLocal
INSERT INTO LOCKE.BI_Dimension_TipoLocal(TipoLocal)
(SELECT TIPO_LOCAL FROM LOCKE.TIPO_LOCAL);

--EstadoPedido
INSERT INTO LOCKE.BI_Dimension_EstadoPedido(EstadoPedido)
(SELECT ESTA_PEDI_ESTADO FROM LOCKE.ESTADO_PEDIDO);


--TipoMovilidad
INSERT INTO LOCKE.BI_Dimension_TipoMovilidad(TipoMovilidad)
(SELECT TIPO_MOVILIDAD FROM LOCKE.TIPO_MOVILIDAD);

--Localidad
INSERT INTO LOCKE.BI_Dimension_Localidad(Nombre)
(SELECT LOCA_LOCALIDAD FROM LOCKE.LOCALIDAD);

--RangoEtarioUsuario
INSERT INTO LOCKE.BI_Dimension_RangoEtarioUsuario(EdadMinima,EdadMaxima)
VALUES (0,25);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioUsuario(EdadMinima,EdadMaxima)
VALUES (25,35);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioUsuario(EdadMinima,EdadMaxima)
VALUES (35,55);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioUsuario(EdadMinima,EdadMaxima)
VALUES (55,200);

--RangoEtarioRepartidor
INSERT INTO LOCKE.BI_Dimension_RangoEtarioRepartidor(EdadMinima,EdadMaxima)
VALUES (0,25);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioRepartidor(EdadMinima,EdadMaxima)
VALUES (25,35);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioRepartidor(EdadMinima,EdadMaxima)
VALUES (35,55);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioRepartidor(EdadMinima,EdadMaxima)
VALUES (55,200);

--RangoEtarioOperario
INSERT INTO LOCKE.BI_Dimension_RangoEtarioOperario(EdadMinima,EdadMaxima)
VALUES (0,25);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioOperario(EdadMinima,EdadMaxima)
VALUES (25,35);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioOperario(EdadMinima,EdadMaxima)
VALUES (35,55);

INSERT INTO LOCKE.BI_Dimension_RangoEtarioOperario(EdadMinima,EdadMaxima)
VALUES (55,200);

--Dia
INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Lunes');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Martes');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Miercoles');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Jueves');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Viernes');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Sabado');

INSERT INTO LOCKE.BI_Dimension_Dia(DiaSemana)
VALUES ('Domingo');

--Rango Horario

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (8,10);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (10,12);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (12,14);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (14,16);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (16,18);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (18,20);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (20,22);

INSERT INTO LOCKE.BI_Dimension_RangoHorario(HoraMinima,HoraMaxima)
VALUES (22,24);

--Anio
INSERT INTO LOCKE.BI_Dimension_Anio(IdAnio)
SELECT YEAR(PEDI_FECHA) FROM LOCKE.PEDIDO
GROUP BY YEAR(PEDI_FECHA)

--Mes
INSERT INTO LOCKE.BI_Dimension_Mes(IdMes)
SELECT MONTH(PEDI_FECHA) FROM LOCKE.PEDIDO
GROUP BY MONTH(PEDI_FECHA)


--EstadoEnvioMensajeria
INSERT INTO LOCKE.BI_Dimension_EstadoEnvioMensajeria(EstadoEnvio)
(SELECT ESTA_ENVI_ESTADO FROM LOCKE.ESTADO_ENVIO_MENSAJERIA);

--TipoPaquete
INSERT INTO LOCKE.BI_Dimension_TipoPaquete(TipoPaquete)
(SELECT PAQU_TIPO_TIPO FROM LOCKE.TIPO_PAQUETE);

--EstadoReclamo
INSERT INTO LOCKE.BI_Dimension_EstadoReclamo(EstadoReclamo)
(SELECT ESTA_RECL_ESTADO FROM LOCKE.ESTADO_RECLAMO);

--TipoReclamo
INSERT INTO LOCKE.BI_Dimension_TipoReclamo(TipoReclamo)
(SELECT TIPO_RECL_TIPO FROM LOCKE.TIPO_RECLAMO);

PRINT ('Tablas de Dimensiones cargadas correctamente')
---------------------------------INSERT TABLA Hechos--------------------------------------------------------------------------

--Pedido
SET DATEFIRST 1; --Sirve para establecer el primer dia de la sem como Lunes

INSERT INTO LOCKE.BI_Hechos_Pedido(IdAnio,IdMes,IdDia,IdRangoHorario,IdLocalidadLocal,IdCategoriaLocal,IdEstadoPedido,IdTipoMovilidad,IdEtarioRepartidor,IdEtarioUsuario,IdLocal,IdTipoLocal,CantidadPedidos,MontoTotal,PromedioValorEnvio,TiempoEntregaPromedioEnMins,MontoTotalCuponesUtilizados,CalificacionPromedio)

SELECT YEAR(PEDI_FECHA),MONTH(PEDI_FECHA),IdDia,IdHorario,IdLocalidad,1 as CategoriaLocal , IdEstadoPedido, IdTipoMovilidad,IdEtarioRepartidor,IdEtarioUsuario, IdLocal,IdTipoLocal, COUNT(PEDI_NRO), SUM(PEDI_TOTAL_PRODUCTOS) , AVG(PEDI_PRECIO_ENVIO), AVG(DATEDIFF(MINUTE,PEDI_FECHA,PEDI_FECHA_ENTREGA)) as TiempoPromedioEntregaEnMins , SUM(PEDI_TOTAL_CUPONES), AVG(PEDI_CALIFICACION)
FROM LOCKE.PEDIDO 
		JOIN LOCKE.BI_Dimension_Dia ON (IdDia = (DATEPART(WEEKDAY,PEDI_FECHA)))
		JOIN LOCKE.BI_Dimension_RangoHorario as rh ON ((DATEPART(HOUR,PEDI_FECHA) >= rh.HoraMinima AND (DATEPART(HOUR,PEDI_FECHA)) < rh.HoraMaxima))
		JOIN LOCKE.LOCAL ON (PEDI_LOCAL = LOCAL_NOMBRE) JOIN LOCKE.BI_Dimension_Localidad ON (LOCAL_LOCALIDAD = Nombre)
		LEFT JOIN LOCKE.BI_Dimension_CategoriaLocal ON (LOCAL_CATEGORIA = Categoria) --Gracias al Join de arriba ya tengo las columnas de local
		JOIN LOCKE.BI_Dimension_EstadoPedido on (EstadoPedido = PEDI_ESTADO) 
		JOIN LOCKE.REPARTIDOR ON (REPA_ID = PEDI_REPARTIDOR) JOIN Locke.BI_Dimension_RangoEtarioRepartidor as rr ON (DATEDIFF(YEAR,REPA_FECHA_NACIMIENTO,GETDATE()) >= rr.EdadMinima AND DATEDIFF(YEAR,REPA_FECHA_NACIMIENTO,GETDATE()) < rr.EdadMaxima)
		JOIN LOCKE.BI_Dimension_TipoMovilidad ON (REPA_TIPO_MOVILIDAD = TipoMovilidad) 
		JOIN LOCKE.USUARIO ON (USUA_ID = PEDI_USUARIO) JOIN Locke.BI_Dimension_RangoEtarioUsuario as ru ON (DATEDIFF(YEAR,USUA_FECHA_NACIMIENTO,GETDATE()) >= ru.EdadMinima AND DATEDIFF(YEAR,USUA_FECHA_NACIMIENTO,GETDATE()) < ru.EdadMaxima)
		JOIN LOCKE.BI_Dimension_Local as dl ON (dl.Nombre = PEDI_LOCAL)
		JOIN LOCKE.BI_Dimension_TipoLocal ON (TipoLocal = LOCAL_TIPO)
GROUP BY YEAR(PEDI_FECHA),MONTH(PEDI_FECHA),IdDia,IdHorario,IdLocalidad,IdEstadoPedido, IdTipoMovilidad,IdEtarioRepartidor,IdEtarioUsuario, IdLocal,IdTipoLocal

----Mensajeria

INSERT INTO LOCKE.BI_Hechos_Mensajeria(IdAnio,IdMes, IdDia, IdRangoHorario, IdEstadoEnvioMensajeria, IdTipoMovilidad, IdEtarioRepartidor, IdLocalidadRepartidor, IdEtarioUsuario, IdTipoPaquete, CantidadEnviosMensajeria, TiempoEntregaPromedioEnMins, PromedioValorAsegurado)

SELECT YEAR(ENVI_FECHA),MONTH(ENVI_FECHA),IdDia,IdHorario,IdEstadoEnvioMensajeria,IdTipoMovilidad,IdEtarioRepartidor,IdLocalidad,IdEtarioUsuario,IdTipoPaquete, COUNT(ENVI_NRO), AVG(DATEDIFF(MINUTE,ENVI_FECHA,ENVI_FECHA_ENTREGA)) as TiempoPromedioEntregaEnMins, AVG(ENVI_VALOR_ASEGURADO)
FROM LOCKE.ENVIO_MENSAJERIA
		JOIN LOCKE.BI_Dimension_Dia ON (IdDia = (DATEPART(WEEKDAY,ENVI_FECHA)))
		JOIN LOCKE.BI_Dimension_RangoHorario as rh ON ((DATEPART(HOUR,ENVI_FECHA) >= rh.HoraMinima AND (DATEPART(HOUR,ENVI_FECHA)) < rh.HoraMaxima))
		JOIN LOCKE.BI_Dimension_EstadoEnvioMensajeria ON (ENVI_ESTADO = EstadoEnvio)
		JOIN LOCKE.REPARTIDOR ON (REPA_ID = ENVI_REPARTIDOR) JOIN Locke.BI_Dimension_RangoEtarioRepartidor as rr ON (DATEDIFF(YEAR,REPA_FECHA_NACIMIENTO,GETDATE()) >= rr.EdadMinima AND DATEDIFF(YEAR,REPA_FECHA_NACIMIENTO,GETDATE()) < rr.EdadMaxima)
		JOIN LOCKE.BI_Dimension_TipoMovilidad ON (REPA_TIPO_MOVILIDAD = TipoMovilidad)
		JOIN LOCKE.BI_Dimension_Localidad ON (Nombre = ENVI_LOCALIDAD) 
		JOIN LOCKE.USUARIO ON (USUA_ID = ENVI_USUARIO) JOIN Locke.BI_Dimension_RangoEtarioUsuario as ru ON (DATEDIFF(YEAR,USUA_FECHA_NACIMIENTO,GETDATE()) >= ru.EdadMinima AND DATEDIFF(YEAR,USUA_FECHA_NACIMIENTO,GETDATE()) < ru.EdadMaxima)
		JOIN LOCKE.PAQUETE ON (PAQU_ENVIO = ENVI_NRO) JOIN LOCKE.BI_Dimension_TipoPaquete ON (PAQU_TIPO = TipoPaquete)
GROUP BY YEAR(ENVI_FECHA),MONTH(ENVI_FECHA),IdDia,IdHorario,IdEstadoEnvioMensajeria,IdTipoMovilidad,IdEtarioRepartidor,IdLocalidad,IdEtarioUsuario,IdTipoPaquete		


----Reclamos 

INSERT INTO LOCKE.BI_Hechos_Reclamo(IdAnio,IdMes, IdDia, IdRangoHorario, IdTipoReclamo, IdEtarioOperario,IdEstadoReclamo,CantidadReclamos,TiempoResolucionPromedioEnMins,MontoTotalCuponesGenerado)

SELECT YEAR(RECL_FECHA),MONTH(RECL_FECHA),IdDia,IdHorario,IdTipoReclamo, IdEtarioOperario, IdEstadoReclamo, COUNT(RECL_NRO), AVG(DATEDIFF(MINUTE,RECL_FECHA,RECL_FECHA_SOLUCION)) as TiempoPromedioResolucionEnMins, SUM(CUPO_RECL_MONTO)
FROM LOCKE.RECLAMO
		JOIN LOCKE.BI_Dimension_Dia ON (IdDia = (DATEPART(WEEKDAY,RECL_FECHA)))
		JOIN LOCKE.BI_Dimension_RangoHorario as rh ON ((DATEPART(HOUR,RECL_FECHA) >= rh.HoraMinima AND (DATEPART(HOUR,RECL_FECHA)) < rh.HoraMaxima))
		JOIN LOCKE.BI_Dimension_TipoReclamo ON (RECL_TIPO = TipoReclamo)
		JOIN LOCKE.OPERADOR_RECLAMO ON (RECL_OPERADOR = OPER_ID) JOIN  Locke.BI_Dimension_RangoEtarioOperario as rr ON (DATEDIFF(YEAR,OPER_FECHA_NACIMIENTO,GETDATE()) >= rr.EdadMinima AND DATEDIFF(YEAR,OPER_FECHA_NACIMIENTO,GETDATE()) < rr.EdadMaxima)
		JOIN LOCKE.BI_Dimension_EstadoReclamo ON (RECL_ESTADO = EstadoReclamo)
		JOIN LOCKE.CUPON_RECLAMO ON (RECL_NRO = CUPO_RECL_RECLAMO) 
GROUP BY YEAR(RECL_FECHA),MONTH(RECL_FECHA),IdDia,IdHorario,IdTipoReclamo, IdEtarioOperario, IdEstadoReclamo

PRINT ('Tablas de Hechos cargadas correctamente')
----------------------------------------------------------------------------------------------
END;
GO
EXEC MigrarDatosBI


-----------------------------------------------------------------------------------------------------------

/* 1. Día de la semana y franja horaria con mayor cantidad de pedidos según la
localidad y categoría del local, para cada mes de cada año.*/
GO
create view dia_y_franjaHoraria_mayor_pedidos as

SELECT h.IdLocalidadLocal,h.IdCategoriaLocal,h.IdMes,h.IdAnio, 
(SELECT top 1 p.IdDia from LOCKE.BI_Hechos_Pedido as p
 where p.IdLocalidadLocal = h.IdLocalidadLocal and p.IdCategoriaLocal = h.IdCategoriaLocal and p.IdMes = h.IdMes and p.IdAnio = h.IdAnio
 group by p.IdDia,p.IdLocalidadLocal, p.IdCategoriaLocal, p.IdMes, p.IdAnio
 order by sum(CantidadPedidos) desc) as Dia_Sem_MayorCantidadPedidos,

 (SELECT top 1 p.IdRangoHorario from LOCKE.BI_Hechos_Pedido as p
 where p.IdLocalidadLocal = h.IdLocalidadLocal and p.IdCategoriaLocal = h.IdCategoriaLocal and p.IdMes = h.IdMes and p.IdAnio = h.IdAnio
 group by p.IdRangoHorario,p.IdLocalidadLocal, p.IdCategoriaLocal, p.IdMes, p.IdAnio
 order by sum(CantidadPedidos) desc) as FranjaHoraria_MayorCantidadPedidos

from LOCKE.BI_Hechos_Pedido as h
group by h.IdLocalidadLocal,h.IdCategoriaLocal,h.IdMes,h.IdAnio;


/*2.	Monto total no cobrado por cada local en función de los pedidos
cancelados según el día de la semana y la franja horaria (cuentan como
pedidos cancelados tanto los que cancela el usuario como el local).*/
GO
create view monto_pedidos_cancelados_local as
SELECT IdLocal,IdDia,IdRangoHorario, SUM(MontoTotal) as MontoTotalNoCobrado
FROM LOCKE.BI_Hechos_Pedido
WHERE IdEstadoPedido = 1 --EL ID 1 ES "Estado Mensajeria Cancelado"
GROUP BY IdLocal,IdDia,IdRangoHorario;


/*3. Valor promedio mensual que tienen los envíos de pedidos en cada
localidad*/
GO
create view valor_promedio_envios as
SELECT IdLocalidadLocal,IdAnio,IdMes, AVG(PromedioValorEnvio) as ValorEnvioPromedioMensual  from LOCKE.BI_Hechos_Pedido
GROUP BY IdLocalidadLocal,IdAnio,IdMes;

/*4.	Desvío promedio en tiempo de entrega según el tipo de movilidad, el día
de la semana y la franja horaria.
El desvío debe calcularse en minutos y representa la diferencia entre la
fecha/hora en que se realizó el pedido y la fecha/hora que se entregó en
comparación con los minutos de tiempo estimados.
Este indicador debe tener en cuenta todos los envíos, es decir, sumar tanto
los envíos de pedidos como los de mensajería.*/
GO
create view devio_tiempo_entrega as 
SELECT IdTipoMovilidad, IdDia, IdRangoHorario, AVG(TiempoEntregaPromedioEnMins) as TiempoEntregaPromedioEnMins
FROM LOCKE.BI_Hechos_Pedido 
GROUP BY IdTipoMovilidad, IdDia, IdRangoHorario
UNION 
SELECT IdTipoMovilidad, IdDia, IdRangoHorario, AVG(TiempoEntregaPromedioEnMins) as TiempoEntregaPromedioEnMins
FROM LOCKE.BI_Hechos_Mensajeria
GROUP BY IdTipoMovilidad, IdDia, IdRangoHorario;

/*5.	Monto total de los cupones utilizados por mes en función del rango etario
de los usuarios.*/
GO
create view cupones_utilizados as 
SELECT IdAnio,IdMes,idEtarioUsuario, SUM(MontoTotalCuponesUtilizados) as  MontoTotalCuponesUtilizados
FROM LOCKE.BI_Hechos_Pedido
GROUP BY IdAnio,IdMes,idEtarioUsuario;

/*6.	Promedio de calificación mensual por local*/
GO
create view calificacion_local as
SELECT IdLocal, IdAnio,IdMes, AVG(CalificacionPromedio) as PromedioCalificacion
FROM LOCKE.BI_Hechos_Pedido
GROUP BY IdLocal, IdAnio,IdMes;


/*7.	Porcentaje de pedidos y mensajería entregados mensualmente según el
rango etario de los repartidores y la localidad.
Este indicador se debe tener en cuenta y sumar tanto los envíos de pedidos
como los de mensajería.
El porcentaje se calcula en función del total general de pedidos y envíos
mensuales entregados.*/
GO
create view porcentaje_entregado as 
SELECT m.IdEtarioRepartidor, m.IdLocalidadRepartidor,m.IdMes,m.IdAnio,
str(cast(sum(m.CantidadEnviosMensajeria) + (select sum(p.CantidadPedidos) from LOCKE.BI_Hechos_Pedido as p
									where p.IdEtarioRepartidor = m.IdEtarioRepartidor and p.IdLocalidadLocal = m.IdLocalidadRepartidor and p.IdMes = m.IdMes and p.IdAnio = m.IdAnio
									group by p.IdEtarioRepartidor,p.IdLocalidadLocal,p.IdMes,p.IdAnio ) * 100 as decimal(6,2)) /
									
									cast((SELECT sum(p1.CantidadPedidos) from LOCKE.BI_Hechos_Pedido as p1
									where p1.IdAnio = m.IdAnio and p1.IdMes = m.IdMes
									group by p1.IdAnio, p1.IdMes )
									
									 + (SELECT sum(m1.CantidadEnviosMensajeria) from LOCKE.BI_Hechos_Mensajeria as m1
										where m1.IdAnio = m.IdAnio and m1.IdMes = m.IdMes
										group by m1.IdAnio, m1.IdMes ) as decimal(6,2)),4,4) + '%' as Porcentaje_Entregado_del_total

from LOCKE.BI_Hechos_Mensajeria as m 
group by m.IdEtarioRepartidor, m.IdLocalidadRepartidor,m.IdMes,m.IdAnio;

/*8.	Promedio mensual del valor asegurado (valor declarado por el usuario) de
los paquetes enviados a través del servicio de mensajería en función del
tipo de paquete.*/
GO
create view promedio_valor_asegurado as 
SELECT IdAnio,IdMes,IdTipoPaquete, AVG(PromedioValorAsegurado) as PromedioValorAsegurado
FROM LOCKE.BI_Hechos_Mensajeria
GROUP BY IdAnio,IdMes,IdTipoPaquete;


/*9.	Cantidad de reclamos mensuales recibidos por cada local en función del
día de la semana y rango horario.*/
GO
create view reclamos_mensuales_local as
SELECT IdAnio,IdMes, IdDia, IdRangoHorario, SUM(CantidadReclamos) as CantidadDeReclamos
FROM LOCKE.BI_Hechos_Reclamo
GROUP BY IdAnio,IdMes, IdDia, IdRangoHorario;


/*10. Tiempo promedio de resolución de reclamos mensual según cada tipo de
reclamo y rango etario de los operadores.
El tiempo de resolución debe calcularse en minutos y representa la
diferencia entre la fecha/hora en que se realizó el reclamo y la fecha/hora
que se resolvió. */
GO
create view tiempo_resolucion_reclamos as
SELECT IdTipoReclamo, IdEtarioOperario, AVG(TiempoResolucionPromedioEnMins) as TiempoPromedioResolucionReclamos
FROM LOCKE.BI_Hechos_Reclamo
GROUP BY IdTipoReclamo, IdEtarioOperario;


/*11.	Monto mensual generado en cupones a partir de reclamos.*/
GO
create view monto_cupones_reclamo as
SELECT IdAnio,IdMes, SUM(MontoTotalCuponesGenerado) as MontoGeneradoEnCupones
FROM LOCKE.BI_Hechos_Reclamo
GROUP BY IdAnio,IdMes;