



/*Para utilizar esta funcion en otra base se tiene que nombrar la base y poner el go*/

use Comparacion

go

/*Crear la fucion donde limpia espacios de las descripciones de los procedimientos*/

CREATE FUNCTION [dbo].[LimpiarDescripcion](@texto NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN

	  -- Convertir a may�sculas
    SET @texto = UPPER(@texto);

	-- Elimina acentos

    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'a');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'e');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'i');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'o');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'u');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'n');
	SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'A');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'E');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'I');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'O');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, '�', 'U');

	    
    -- Eliminar puntuaciones y reemplazar m�ltiples espacios con uno solo
    SET @texto = REPLACE(@texto, CHAR(13), ''); -- Eliminar retornos de carro
    SET @texto = REPLACE(@texto, CHAR(10), ''); -- Eliminar saltos de l�nea

	-- Espacios al inicio y al final

	  RETURN LTRIM(RTRIM(@texto));

    -- Reemplazar m�ltiples espacios con uno solo
    WHILE CHARINDEX('  ', @texto) > 0
    BEGIN
        SET @texto = REPLACE(@texto, '  ', ' ');
    END;

	    RETURN @texto;
END;
GO


