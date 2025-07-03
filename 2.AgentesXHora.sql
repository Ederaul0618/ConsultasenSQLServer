use CallCenter;

/*para agregar una nueva columna a tabla*/

----ALTER TABLE DatosXAgente$
----ADD  LlamadasRecibidas [float] 

/*para borrar un dia de la base*/
--delete from CallCenter..DatosXAgente$
--where Fecha between '2025-05-24' and '2025-07-01'

/*agrupa los dias la fecha y la ordena de mayor a menor para vaidar el ultimo dia que se cargo a la base */

--select 
--Fecha,
--count (fecha),
--sum (LlamadasAtendidas)

--from CallCenter..DatosXAgente$
--where Fecha != 'z: Totales'
--group by Fecha
--order by Fecha desc

/*revisar el tipo de dato de toral gestion de lo nuevo que has cargado*/
--select  *from CallCenter..DatosXAgente$
--order by Fecha desc

/*Para borrar base BaseXAgenteAtendidasEstatus##*/

drop table BaseXAgenteAtendidasEstatus##;
drop table BaseXAgente##;
drop table BaseXAgenteAtendidasMayor20##;
drop table BaseXAgenteAtendidasMenor20##;
drop table BaseXAgenteAdandonadasMenor20##;
drop table BaseXAgenteAdandonadasMayor20##;

/*Inicia la baseBaseXAgenteAtendidas## para convertir la fecha a date y poner estatus de llamdas */
with BaseXAgenteAtendidas## as (
								select *,
								TRY_CONVERT (date, Fecha,120) AS 'FechaDos',
								CONVERT(TIME(0), TRY_CAST(PromedioAtencion AS TIME)) AS 'TMO',
								CONVERT(TIME(0), TRY_CAST(VelRepuesta AS TIME)) AS 'ASA',
								CONVERT(TIME(0), TRY_CAST(TotalGestion AS TIME)) AS 'TotalGestionTime'
								

								from DatosXAgente$

)
select 
FechaDos,
Hora,
[Login],
Clave,
NombreAgente,
ASA,
VelRepuesta,
TMO,
PromedioAtencion,
TotalGestion,
TotalGestionTime,
Macroproceso,
AbandonadasMayorA20,
AbandonadasMenorA20,
LlamadasAtendidasMayor,
LlamadasAtendidasMenor,


case when AbandonadasMayorA20 != '0'  then  'Abandonadas mayor a 20'
	 ELSE 'Revisar' end 'estatusabandonadasMayora20',
	 
case when AbandonadasMenorA20 != '0'  then  'Abandonadas menor a 20'
	 ELSE 'Revisar' end 'estatusabandonadasMenora20',

case when LlamadasAtendidasMayor != '0'  then  'Atendidas mayor a 20'
	 ELSE 'Revisar' end 'estatusatendidasMayora20',

case when LlamadasAtendidasMenor != '0'  then  'Atendidas menor a 20'
	 ELSE 'Revisar' end 'estatusatendidasMenora20'

into BaseXAgenteAtendidasEstatus##

from BaseXAgenteAtendidas##;

/*termina  la baseBaseXAgenteAtendidas## */

/*inicia base de BaseXAgenteAtendidasMayor20## */

select 
FechaDos,
Hora,
[Login],
Clave,
NombreAgente,
ASA,
VelRepuesta,
TMO,
PromedioAtencion,
TotalGestion,
TotalGestionTime,
Macroproceso,
LlamadasAtendidasMayor as 'NumeroLLamadas',
estatusatendidasMayora20 as 'EstatusLLamadas'

into BaseXAgenteAtendidasMayor20##

from BaseXAgenteAtendidasEstatus##
where estatusatendidasMayora20 = 'Atendidas mayor a 20';

/*Termina base de BaseXAgenteAtendidasMayor20## */

/*inicia base de BaseXAgenteAtendidasMenor20## */

select 
FechaDos,
Hora,
[Login],
Clave,
NombreAgente,
ASA,
VelRepuesta,
TMO,
PromedioAtencion,
TotalGestion,
TotalGestionTime,
Macroproceso,
LlamadasAtendidasMenor as 'NumeroLLamadas',
estatusatendidasMenora20 as 'EstatusLLamadas'

into BaseXAgenteAtendidasMenor20##

from BaseXAgenteAtendidasEstatus##
where estatusatendidasMenora20 = 'Atendidas menor a 20';

/*Termina base de BaseXAgenteAtendidasMenor20## */

/*inicia base de BaseXAgenteAdandonadasMenor20## */

select 
FechaDos,
Hora,
[Login],
Clave,
NombreAgente,
ASA,
VelRepuesta,
TMO,
PromedioAtencion,
TotalGestion,
TotalGestionTime,
Macroproceso,
AbandonadasMenorA20 as 'NumeroLLamadas',
estatusabandonadasMenora20 as 'EstatusLLamadas'

into BaseXAgenteAdandonadasMenor20##

from BaseXAgenteAtendidasEstatus##
where estatusabandonadasMenora20 = 'Abandonadas menor a 20';

/*Termina base de BaseXAgenteAdandonadasMenor20## */


/*inicia base de BaseXAgenteAdandonadasMayor20## */

select 
FechaDos,
Hora,
[Login],
Clave,
NombreAgente,
ASA,
VelRepuesta,
TMO,
PromedioAtencion,
TotalGestion,
TotalGestionTime,
Macroproceso,
AbandonadasMayorA20 as 'NumeroLLamadas',
estatusabandonadasMayora20 as 'EstatusLLamadas'

into BaseXAgenteAdandonadasMayor20##

from BaseXAgenteAtendidasEstatus##
where estatusabandonadasMayora20 = 'Abandonadas mayor a 20';

/*Termina base de BaseXAgenteAdandonadasMayor20## */

/*Aumentar el tamaño de la columna,necesitas que la columna tenga al menos 10 caracteres*/
ALTER TABLE CallCenter.dbo.BaseXAgenteAtendidasMayor20## 
ALTER COLUMN EstatusLLamadas VARCHAR(50);  -- O el tamaño que consideres adecuado


/*Inicia la union de las bases creeadas a una sola tabla y es a la BaseXAgenteAtendidasMayor20## */
insert into BaseXAgenteAtendidasMayor20## (
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
)
select 
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
from BaseXAgenteAtendidasMenor20##;

/*abandono menor 20*/
insert into BaseXAgenteAtendidasMayor20## (
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
)
select 
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
from BaseXAgenteAdandonadasMenor20##;

/*abandono mayor a 20*/
insert into BaseXAgenteAtendidasMayor20## (
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
)
select 
[FechaDos],
[Hora],
[Login],
[Clave],
[NombreAgente],
[ASA],
[VelRepuesta],
[TMO],
[PromedioAtencion],
[TotalGestion],
[TotalGestionTime],
[Macroproceso],
[NumeroLLamadas],
[EstatusLLamadas]
from BaseXAgenteAdandonadasMayor20##;

/*base final power bi */

select *,
case when NombreAgente in ('ENRIQUE  ALADINO','ADRIANA BEATRIZ SALDIVAR') then 'Encargados'
     when NombreAgente not in ('ENRIQUE  ALADINO','ADRIANA BEATRIZ SALDIVAR') then 'Agentes'
	 else 'Revisar' end 'EstatusAgentes'

into BaseXAgente##
     
from BaseXAgenteAtendidasMayor20##;

/*base final*/

