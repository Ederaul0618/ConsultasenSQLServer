/*este query crea la base pra revisara la asistencia de los agentes y medicos para luego presentarla en power bi */

use CallCenter;

/*agrupa los dias la fecha y la ordena de mayor a menor para vaidar el ultimo dia que se cargo a la base */

--select 
--convert (date,fecha) as 'fechaFormato',
--count (convert (date,fecha))
--from CallCenter..DatosSKILL$
--group by 
--convert (date,fecha)
--order by convert (date,fecha) desc


/*borra tabla del reporte para power bi */

drop table ReporteAsistencias##;

/*finaliza el borrado tabla */

/*inicia la contruccion de la base de asistencia call center*/

with Asistencia## as (	select 

						a.Clave,
						a.[Login],
						a.NombreAgente,
						a.ClaveGrupo,
						---a.DescripcionGrupo,
						a.fecha,
						convert (date,a.fecha) as 'fechaFormato',
						a.HoraEntrada,
					    convert (time (0),a.HoraEntrada) as 'sistemaEntradaData',

						/*ROW_NUMBER():Asigna un número secuencial a cada fila dentro del grupo ordenado. 
						 Over: Esta función no se aplicará a toda la tabla, sino a una ventana específica de filas, que tú defines con PARTITION BY y ORDER BY.
						 PARTITION BY: Agrupa los registros por combinación de NombreAgente y fecha (sin la hora),Es decir, todos los registros de un mismo agente en un mismo día se consideran un grupo.
						 ORDER BY: Dentro de cada grupo, ordena los registros de menor a mayor*/

						ROW_NUMBER() OVER (PARTITION BY a.NombreAgente, convert (date,a.fecha)  ORDER BY HoraEntrada ASC) AS fila, 
						a.HoraSalida,
						convert (time (0),a.HoraSalida) as 'sistemaSalida',
						b.entradaContrato,
						b.salidaContrato,
						b.horaMas15min,
						b.gruposEntrada,
						b.puesto,
						b.estatus,
						b.[DescripcionGrupo]

						from DatosSKILL$ a 
						left join (select *,
						           convert (time (0),[entrada ]) as 'entradaContrato',
								   convert (time (0),salida) as 'salidaContrato',
								   convert (time (0), DATEADD(MINUTE, 15, [entrada ])) AS 'horaMas15min'
								   from CallCenter..HorarioAgentes$
						           where estatus = 'Activo') as b on a.[Login] = b.[Login]

						where a.ClaveGrupo = 'Login'
						and b.estatus = 'Activo'



)

select 
Clave,
[Login],
NombreAgente,
ClaveGrupo,
---DescripcionGrupo,
fechaFormato,
sistemaEntradaData,
sistemaSalida,
entradaContrato,
salidaContrato,
horaMas15min,
gruposEntrada,
fila,
puesto,
estatus,
DescripcionGrupo,
CASE 
    WHEN DATEDIFF(SECOND, horaMas15min, sistemaEntradaData) >= 0 THEN 
        CONVERT(VARCHAR(8), DATEADD(SECOND, DATEDIFF(SECOND, horaMas15min, sistemaEntradaData), 0), 108)
    ELSE 
        '-' + CONVERT(VARCHAR(8), DATEADD(SECOND, ABS(DATEDIFF(SECOND, horaMas15min, sistemaEntradaData)), 0), 108)
  END AS DiferenciaHora,

case when gruposEntrada = 'Grupo6AM' and sistemaEntradaData between '05:50:00' and '06:15:00' then '0'
     when gruposEntrada = 'Grupo6AM' and sistemaEntradaData >= '06:16:00' then '1'

	 when gruposEntrada = 'Grupo7AM' and  sistemaEntradaData between '06:50:00' and '07:15:00' then '0'
     when gruposEntrada = 'Grupo7AM' and  sistemaEntradaData>= '07:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo8AM' and  sistemaEntradaData between '07:50:00' and '08:15:00' then '0'
     when gruposEntrada = 'Grupo8AM' and  sistemaEntradaData>= '08:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo11AM' and sistemaEntradaData between '10:50:00' and '11:15:00' then '0'
     when gruposEntrada = 'Grupo11AM' and sistemaEntradaData >= '11:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo10AM' and sistemaEntradaData between '09:50:00' and '10:15:00' then '0'
     when gruposEntrada = 'Grupo10AM' and sistemaEntradaData >= '10:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo23PM' and sistemaEntradaData between '22:50:00' and '23:15:00' then '0'
     when gruposEntrada = 'Grupo23PM' and sistemaEntradaData >= '23:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo15PM' and sistemaEntradaData between '14:50:00' and '15:15:00' then '0'
     when gruposEntrada = 'Grupo15PM' and sistemaEntradaData >= '15:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo9AM' and  sistemaEntradaData between '08:50:00' and '09:15:00' then '0'
     when gruposEntrada = 'Grupo9AM' and  sistemaEntradaData>= '09:16:00' then '1'
										  
     when gruposEntrada = 'Grupo14PM' and sistemaEntradaData between '13:50:00' and '14:15:00' then '0'
     when gruposEntrada = 'Grupo14PM' and sistemaEntradaData >= '14:16:00' then '1'
										  
	 when gruposEntrada = 'Grupo12PM' and sistemaEntradaData between '11:50:00' and '12:15:00' then '0'
     when gruposEntrada = 'Grupo12PM' and sistemaEntradaData >= '12:16:00' then '1'

	 else '2' end 'estatusAsistencia',

case when gruposEntrada = 'Grupo6AM' and sistemaEntradaData between '05:50:00' and '06:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo6AM' and sistemaEntradaData >= '06:16:00' then 'Retardo'

	 when gruposEntrada = 'Grupo7AM' and  sistemaEntradaData between '06:50:00' and '07:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo7AM' and  sistemaEntradaData>= '07:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo8AM' and  sistemaEntradaData between '07:50:00' and '08:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo8AM' and  sistemaEntradaData>= '08:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo11AM' and sistemaEntradaData between '10:50:00' and '11:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo11AM' and sistemaEntradaData >= '11:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo10AM' and sistemaEntradaData between '09:50:00' and '10:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo10AM' and sistemaEntradaData >= '10:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo23PM' and sistemaEntradaData between '22:50:00' and '23:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo23PM' and sistemaEntradaData >= '23:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo15PM' and sistemaEntradaData between '14:50:00' and '15:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo15PM' and sistemaEntradaData >= '15:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo9AM' and  sistemaEntradaData between '08:50:00' and '09:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo9AM' and  sistemaEntradaData>= '09:16:00' then 'Retardo'
										  
     when gruposEntrada = 'Grupo14PM' and sistemaEntradaData between '13:50:00' and '14:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo14PM' and sistemaEntradaData >= '14:16:00' then 'Retardo'
										  
	 when gruposEntrada = 'Grupo12PM' and sistemaEntradaData between '11:50:00' and '12:15:00' then 'Puntual'
     when gruposEntrada = 'Grupo12PM' and sistemaEntradaData >= '12:16:00' then 'Retardo'

	 else 'Falta' end 'estatusAsistenciaConcepto'

into ReporteAsistencias##

from Asistencia##
where ---fechaFormato between '2025-06-01' and '2025-06-29'
---and gruposEntrada = 'Grupo6AM'
fila = '1';

/*finaliza la creacion de la base de asistencias call center */

---select  *from ReporteAsistencias##;


