use WE_DWH

delete from dim_producto
delete from dim_stores
delete from dim_tiempo
delete from fact_ventas

create table fact_ventas
(
sale_id int primary key,
fecha datetime,
store_id int,
product_id int,
units int,
unit_price float,
total_price float
)

create table dim_inventario
(
inv_id int primary key,
store_id int,
product_id int,
stock_on_hand int
)


create table dim_producto
(
product_id int primary key,
product_name varchar(100),
product_category varchar(100),
product_cost float
)

create table dim_stores
(
store_id int primary key,
store_name varchar(100),
store_city varchar(100),
store_location varchar(100),
store_open_date datetime
)

create table dim_tiempo
(
fecha datetime primary key,
anio int,
mes int,
semana int
)


-- modelo estrella

ALTER TABLE fact_ventas
ADD CONSTRAINT fk_venta_producto
FOREIGN KEY(product_id)
REFERENCES dim_producto(product_id)
go

ALTER TABLE fact_ventas
ADD CONSTRAINT fk_venta_store
FOREIGN KEY(store_id)
REFERENCES dim_stores(store_id)
go


ALTER TABLE fact_ventas
ADD CONSTRAINT fk_venta_tiempo
FOREIGN KEY(fecha)
REFERENCES dim_tiempo(fecha)
go
USE we_staging
select * from [dbo].[stg_ventas]
select * from [dbo].[stg_productos]
select * from [dbo].[stg_stores]
select * from [dbo].[stg_inventario]


USE WE_STAGING

SELECT DISTINCT DATE FROM stg_Ventas

DELETE FROM [dbo].[fact_ventas]
DELETE FROM [dbo].[dim_producto]
DELETE FROM [dbo].[dim_tiempo]
DELETE FROM [dbo].[dim_stores]

USE WE_DWH

SELECT * FROM [dbo].[fact_ventas]
SELECT * FROM [dbo].[dim_producto]
SELECT * FROM [dbo].[dim_stores]
SELECT * FROM [dbo].[dim_tiempo]

with fechas as
(
select
distinct C_date
from stg_ventas
)
select
C_date as fecha,
YEAR(C_date) as anio,
MONTH(C_date) as mes,
datepart(week,C_date) as semana
from fechas
order by C_date

SELECT
A.C_Sale_ID,
A.C_Date AS FECHA,
A.C_Store_ID,
A.C_Product_ID,
A.C_Units,
B.C_Product_Price AS unit_price,
B.C_Product_Price *A.C_Units AS total_price
FROM stg_ventas A
INNER JOIN stg_productos B
ON A.C_Product_ID = B.Product_ID

