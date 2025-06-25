use triage;
/*borra base Triage */
/*drop table triage.registros;

select *from afiliados;
/*crea la tabla en sql server*/
CREATE TABLE triage.registros (
    nomina VARCHAR(50),
    nombre VARCHAR(150),
    cliente VARCHAR(150),
    sexo VARCHAR(20),
    edad INT,
    medico VARCHAR(150),
    puntaje int,
    fecha DATETIME,
    pregunta_1 INT,
    pregunta_2 INT,
    pregunta_3 INT,
    pregunta_4 INT,
    observaciones_4 VARCHAR(255),
    pregunta_5 INT,
    pregunta_6 INT,
	pregunta_7 INT,
    observaciones_7 VARCHAR(255),
	pregunta_8 INT,
	pregunta_9 INT,
    Ingreso varchar (255),
    hospital varchar (255),
    observaciones VARCHAR(255)
	)
/*tabla creada*/	
	select *from triage.registros
