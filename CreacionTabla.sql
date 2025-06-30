use triaje;

--drop table Triage;

/*crea la tabla en sql server*/
CREATE TABLE Triage (
    id INT IDENTITY PRIMARY KEY,
    nomina VARCHAR(50),
    nombre VARCHAR(150),
    sexo VARCHAR(20),
    edad INT,
    medico VARCHAR(150),
    fecha_hora DATETIME,
    pregunta_1 INT,
    pregunta_2 INT,
    pregunta_3 INT,
    pregunta_4 INT,
    pregunta_5 INT,
    pregunta_6 INT,
	pregunta_7 INT,
	pregunta_8 INT,
	pregunta_9 INT,
	pregunta_10 INT,
	pregunta_11 INT


	)
/*tabla creada*/
	select *from Triage
