/*Este es un fragmento de un codigo  ayuda a crear una tabla nueva con algunas especificaciones para un reporte de costos unitarios,
utilizando funciones   de sql server como int, case when, operaciones matemáticas , subconsultas sin generar tablas temporales nuevas.*/


use CostoPorCaja -- use me indica que base ocupa

drop table mediamentos## /*Borra datos de la tabla medicamentos##*/

/*inicia base para reporte de power bi de costo por caja por mes*/
select
case when a.Contratante in ('sustituir este texto por el contenido de la columna' ) then 'sustituir por el nuevo concepto deceado'
						  when a.Contratante in ('sustituir este texto por el contenido de la columna') then 'sustituir por el nuevo concepto deceado'
						  when a.Contratante in ('sustituir este texto por el contenido de la columna') then 'sustituir por el nuevo concepto deceado'
						  when a.Contratante in ('sustituir este texto por el contenido de la columna') then 'sustituir por el nuevo concepto deceado'
						  when a.Contratante in ('sustituir este texto por el contenido de la columna') then 'sustituir por el nuevo concepto deceado'
						  when a.Contratante in ('sustituir este texto por el contenido de la columna') then 'sustituir por el nuevo concepto deceado'
						  else 'Revisar' end 'sustituir por el nuevo nombre de la columna creada', --- dentro de la tabla se agrupan el nombre de la columna contranates se ocupa la funcion de case when
						                                                                           ---- case when funciona como un IF - ELSE evalua diferentes condicuones.
a.[Proveedor Surtido],
a.[Agrupado Proveedor Surtido],
a.Remesa,
a.Folio,
a.NUR,
a.estatusCR,
a.Cantidad,
a.Devengado as 'Total', -- el as sirve para renombrar la columna
a.Devengado/a.Cantidad as 'Costo unitario', --operacion matematica para obtener el costo unitario
CostoPorCaja.dbo.LimpiarDescripcion(a.[CPT EAN]) as 'EAN', -- dentro de esta liena se agrega la fucion para limpriardescricpion (quita espacios inicio, final y dobles espeacios)
a.[CPT EAN] as 'EANSistema',
[Descripcion Servicio],
CostoPorCaja.dbo.LimpiarDescripcion(a.[Descripcion Servicio]) as 'Descripcion Servicio limpia', -- dentro de esta liena se agrega la fucion para limpriardescricpion (quita espacios inicio, final y dobles espeacios)
case when CostoPorCaja.dbo.LimpiarDescripcion(a.[Descripcion Servicio]) like '%TABLETAS%' then 'Contiene Tabletas' -- dentro de esta liena se agrega la fucion para limpriardescricpion (quita espacios inicio, final y dobles espeacios)
     when CostoPorCaja.dbo.LimpiarDescripcion(a.[Descripcion Servicio]) like '%TABLETA%' then 'Contiene Tabletas' -- dentro de esta liena se agrega la fucion para limpriardescricpion (quita espacios inicio, final y dobles espeacios)
     else 'No contiene tabletas' end 'Medicamento tabletas',
a.FechaAtencion,
CostoPorCaja.dbo.EliminarAcentos(b.[MÉDICO TRATANTE]) as 'Medicos',
b.Cronicos,
cast (''as nvarchar (255)) as 'Descripcion_Modificada' -- la funcion de cast ('' as nvarchar (255)) sirve para crear una nueva columna en nuestra nueva tabla

into mediamentos## -- into se ocupa para crear una nueva tabla y esta misma va contener los cambios y columnas mencionadas

from TablerodeControlPowerBi..resuemndevengadoDos## a -- este from se obtiene el la coneccion a otra base de sqlserver y los .. nos da acceso a una tabla de esa base
left join (select  -- left join es como un cruce en excel aqui lo uno con otra base y otra tabla para obtener datos y contemplar la informacion solicitada
            NUR,
			[MÉDICO TRATANTE],
			Cronicos
			from para_hacer_reportes..devengado_excel##
            where
			YEAR ([Fecha Atencion]) between '2024-01-01' and '2025-06-30'
			and Contratante in ('sustituir este texto por el contenido de la columna')) as b on a.NUR = b.NUR
where -- sirve para hacer las esepciones que necesita esta nueva tabla 
YEAR (a.fechaAtencion) between '2024-01-01' and '2025-06-30'
and a.EstastusServiciosOpe in ('Medicamentos')
and a.Contratante in ('sustituir este texto por el contenido de la columna') 

/*Termina base para reporte de power bi de costo por caja por mes*/

/*Inicia una actualizacion sobre una columna en especifico ocpuado un case when para que me considere alguas esepciones al momento de actualizar*/

update mediamentos## set Descripcion_Modificada = case when [Medicamento tabletas] in ('Contiene Tabletas') then [Descripcion Servicio limpia]
                                                       else 'revisar' end;

/*este update lo que estara actualziando sera una descripcion que nos va a remplazar la palabra TAB O TABS por tabletas ocupando funciones*/
update mediamentos## set Descripcion_Modificada = CASE  -- case when funciona como un IF - ELSE evalua diferentes condicuones
                                                        -- Si "TAB" está seguido de un número
														WHEN PATINDEX('% TAB [0-9]%', [Descripcion Servicio limpia]) > 0  --devuelve la posición en la que aparece un patrón dentro de una cadena de texto.
														THEN STUFF( ---reemplaza una parte de un texto en una posición específica
															[Descripcion Servicio limpia], 
															PATINDEX('% TAB [0-9]%', [Descripcion Servicio limpia]) + 1, 
															3, 'TABLETAS')

                                                        -- Si "TAB" está antes de un número con un espacio
														WHEN PATINDEX('%[0-9] TAB%', [Descripcion Servicio limpia]) > 0 
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('%[0-9] TAB%', [Descripcion Servicio limpia]) + 2, 
															3, 'TABLETAS')

														-- Si "TAB" está antes de un número sin espacio
														WHEN PATINDEX('%[0-9]TAB%', [Descripcion Servicio limpia]) > 0 
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('%[0-9]TAB%', [Descripcion Servicio limpia]) + 2, 
															3, ' TABLETAS') --se agrega aqui el espacio al momento de reemplazar

												       -- Si "TAB" está después de una letra (mayúscula)
						                               WHEN PATINDEX('%[A-Z] TAB%', [Descripcion Servicio limpia]) > 0 
												       THEN STUFF(
													              [Descripcion Servicio limpia], 
													              PATINDEX('%[A-Z] TAB%', [Descripcion Servicio limpia]) + 2, 
													              3,'TABLETAS')

														-- Si "TAB" está al inicio o al final con in signo como -/(
						                               WHEN PATINDEX('%[-/(] TAB [-/)]%', [Descripcion Servicio limpia]) > 0 
												       THEN STUFF(
													              [Descripcion Servicio limpia], 
													              PATINDEX('%[-/(] TAB [-/)]%', [Descripcion Servicio limpia]) + 1, 
													              3,'TABLETAS')

														-- Si "TAB" está al inicio -/(
						                               WHEN PATINDEX('%[-/(]TAB%', [Descripcion Servicio limpia]) > 0 
												       THEN STUFF(
													              [Descripcion Servicio limpia], 
													              PATINDEX('%[-/(]TAB%', [Descripcion Servicio limpia]) + 1, 
													              3,' TABLETAS')
                                                           ---Si "TAB" está rodeado de caracteres como paréntesis, guiones, espacios, etc.
														WHEN PATINDEX('%  TAB %', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('%  TAB %', [Descripcion Servicio limpia]) + 2, 
															3, 'TABLETAS'
														)
        
															---Si "TAB" está precedido o seguido por números u otros caracteres
														WHEN PATINDEX('% .TAB. %', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('% .TAB. %', [Descripcion Servicio limpia]) + 2, 
															3, 'TABLETAS'
														)
														          ---Si "TAB" está rodeado de caracteres puntos o espacios
														WHEN PATINDEX('%. TABS. %', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
														[Descripcion Servicio limpia], 
														PATINDEX('%. TABS. %', [Descripcion Servicio limpia]) + 2, 
														4, 'TABLETAS'
														)
        
														----Si "TAB" está precedido espacios
														WHEN PATINDEX('%  TABS%', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
														[Descripcion Servicio limpia], 
														PATINDEX('%  TABS%', [Descripcion Servicio limpia]) + 2, 
														4, 'TABLETAS'
														)
														----Si "TAB" está precedido o seguido por letras u numeros
														WHEN PATINDEX('%[A-Z]TAB[0-9]%', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
														[Descripcion Servicio limpia], 
														PATINDEX('%[A-Z]TAB[0-9]%', [Descripcion Servicio limpia]) + 1, 
														3, ' TABLETAS '
														)
														----Si "TAB" está precedido doble o carater especial
														WHEN PATINDEX('%  TAB', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
														[Descripcion Servicio limpia], 
														PATINDEX('%  TAB', [Descripcion Servicio limpia]) + 2, 
														3, ' TABLETAS '
														)
														WHEN PATINDEX('%[A-Z]TAB [A-Z]%', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('%[A-Z]TAB [A-Z]%', [Descripcion Servicio limpia]) + 2, 
															3, ' TABLETAS '
														)
														WHEN PATINDEX('%. TAB. %', [Descripcion Servicio limpia]) > 0  
														THEN STUFF(
															[Descripcion Servicio limpia], 
															PATINDEX('%. TAB. %', [Descripcion Servicio limpia]) + 2, 
															3, ' TABLETAS '
														)

													  ELSE [Descripcion Servicio limpia] END 

													WHERE Descripcion_Modificada IN ('revisar') ;


/*Termina la creacion y manipulacion de la nueva tabla para el reporte solicitado*/

/*Se crea una subconsulta sin crear nninguna tabla para poder optimizar*/

WITH CostoMinimoMedicamentos## AS (
    SELECT 
        [Contratante (grupossql)],
        [Proveedor Surtido],
		Descripcion_Modificada,
		YEAR (FechaAtencion) as 'Año',
		MONTH (FechaAtencion) as 'Mes',
        MIN([Costo unitario]) AS 'CostoMinimo'

    FROM mediamentos##
	where estatusCR in ('Pagado','Autorizado')
    GROUP BY
	    [Contratante (grupossql)],
        [Proveedor Surtido],
		Descripcion_Modificada,
		YEAR (FechaAtencion),
		MONTH (FechaAtencion)
),
RankingProveedores## AS (
SELECT 
        [Contratante (grupossql)],
        [Proveedor Surtido],
		Descripcion_Modificada,
		[Año],
	    Mes,
        CostoMinimo,
    RANK() OVER (PARTITION BY Descripcion_Modificada ORDER BY CostoMinimo ASC) AS Ranking ---asigna un ranking basado en el costo mínimo, pero separado por cada medicamento
FROM CostoMinimoMedicamentos##

)
select *from RankingProveedores##
where Ranking = 1;
