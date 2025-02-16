use aprendizaje_we go

CREATE TABLE Productos
(
id_cod int identity(1,1) primary key,
cod_prod varchar(5) not null,
nombre varchar(50) not null,
existencia int not null
)

CREATE TABLE Historial
(
	fecha date,
	cod_prod varchar(5),
	descripcion varchar(100),
	usuario varchar(30)
)

insert into Productos values('A001','MEMORIA USB 32GB',175);insert into Productos values('A002','DISCO DURO 2TB',15);insert into Productos values('A003','AIRE COMPRIMIDO',250);insert into Productos values('A004','ESPUMA LIMPIADORA',300);insert into Productos values('A005','FUNDA MONITOR',500);insert into Productos values('A006','FUNDA TECLADO',700);insert into Productos values('A007','SILLA ERGONOMICA',11);insert into Productos values('A008','ALFOMBRILLA PARA SILLA',25);insert into Productos values('A009','LAMPARA ESCRITORIO',7);insert into Productos values('A010','MONITOR LED 18 PULGADAS',45);insert into Productos values('A011','LIBRERO',20);go


CREATE TRIGGER TR_ProductoInsertado
ON Productos FOR INSERT 
AS 
DECLARE @COD_PROD VARCHAR(5)
SELECT @COD_PROD = cod_prod from inserted
INSERT INTO Historial values(GETDATE(),@COD_PROD,'registro insertado', SYSTEM_USER)

SELECT * FROM Productos
SELECT * FROM Historial