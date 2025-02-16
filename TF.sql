USE DATAMART_MATRICULA

create table fact_matriculas
(
matricula_id int primary key,
fecha datetime,
curso int,
docente int,
centro int,
alumno int,
price float
)
create table dim_alumnos
(
alumno_id int primary key,
alumno_dni int,
alumno_nombre varchar(255),
alumno_apellido_paterno varchar(255),
alumno_fecha_nacimiento datetime
)
create table dim_centros
(
centro_id int primary key,
centro_nombre varchar(255),
centro_distrito varchar(255)
)
create table dim_cursos
(
curso_id int primary key,
curso_descripcion varchar(255),
curso_status int,
curso_precio float,
curso_sesiones int
)
create table dim_docentes
(
docente_id int primary key,
docente_nombre varchar(255),
docente_grado varchar(255),
docente_status int
)
create table dim_tiempo
(
fecha datetime primary key,
anio int,
mes int,
semana int
)

-- modelo estrella

ALTER TABLE fact_matriculas
ADD CONSTRAINT fk_matricula_curso
FOREIGN KEY(curso)
REFERENCES dim_cursos(curso_id)

ALTER TABLE fact_matriculas
ADD CONSTRAINT fk_matricula_docente
FOREIGN KEY(docente)
REFERENCES dim_docentes(docente_id)

ALTER TABLE fact_matriculas
ADD CONSTRAINT fk_matricula_centro
FOREIGN KEY(centro)
REFERENCES dim_centros(centro_id)

ALTER TABLE fact_matriculas
ADD CONSTRAINT fk_matricula_alumno
FOREIGN KEY(alumno)
REFERENCES dim_alumnos(alumno_id)

ALTER TABLE fact_matriculas
ADD CONSTRAINT fk_matricula_tiempo
FOREIGN KEY(fecha)
REFERENCES dim_tiempo(fecha)

USE STAGING_MATRICULA

with fechas as
(
select
distinct [fecha]
from stg_Matricula
)
select
[fecha] as fecha,
YEAR([fecha]) as anio,
MONTH([fecha]) as mes,
datepart(week,[fecha]) as semana
from fechas
order by [fecha]


SELECT A.id_matricula,A.fecha,A.curso,A.docente,A.centro,A.alumno, B.precio as price FROM stg_Matricula A
INNER JOIN stg_Curso B 
ON A.curso = B.ID_CURSO
