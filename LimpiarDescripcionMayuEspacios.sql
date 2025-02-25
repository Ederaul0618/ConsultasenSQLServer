

/*Esta consulta, crear la función donde limpia espacios y cambia el texto a mayúsculas de una columna llamada descripciones, 
la finalidad es limpiar la columna de espacios de más o dobles, saltos de lineal y quitar acentos esto con la finalidad de poder 
hacer una homologación de texto más necesaria para ciertos informes.*/



/*Para utilizar esta funcion en otra base se tiene que nombrar la base y poner el go*/

use Comparacion

go

/*Crear la fucion donde limpia espacios de las descripciones de los procedimientos*/

CREATE FUNCTION [dbo].[LimpiarDescripcion](@texto NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN

	  -- Convertir a mayúsculas
    SET @texto = UPPER(@texto);

	-- Elimina acentos

    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'á', 'a');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'é', 'e');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'í', 'i');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'ó', 'o');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'ú', 'u');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'ñ', 'n');
	SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'Á', 'A');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'É', 'E');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'Í', 'I');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'Ó', 'O');
    SET @texto = REPLACE(@texto COLLATE Latin1_General_BIN, 'Ú', 'U');

	    
    -- Eliminar puntuaciones y reemplazar múltiples espacios con uno solo
    SET @texto = REPLACE(@texto, CHAR(13), ''); -- Eliminar retornos de carro
    SET @texto = REPLACE(@texto, CHAR(10), ''); -- Eliminar saltos de línea

	-- Espacios al inicio y al final

	  RETURN LTRIM(RTRIM(@texto));

    -- Reemplazar múltiples espacios con uno solo
    WHILE CHARINDEX('  ', @texto) > 0
    BEGIN
        SET @texto = REPLACE(@texto, '  ', ' ');
    END;

	    RETURN @texto;
END;
GO


