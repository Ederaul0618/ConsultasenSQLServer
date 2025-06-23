/*Este query es utlizado para crear una base madre para callcenter lo que hace es dividir 
   y identificar estatus de la base primitiva donde se observe cuales son las llamadas recibidas,atendidas o las de ivr
   luego generamos tablas buenvas donde se guerda la informacion, con estos nuevos estatus.Para luego generar una base general 
   Con todos los estatus que se extajeron*/


use CallCenter;


/*para borrar un dia de la base*/
--delete from CallCenter..Datos$
--where Fecha = '2025-05-29'

/*agrupa los dias la fecha y la ordena de mayor a menor para vaidar el ultimo dia que se cargo a la base */
--select 
--Fecha,
--count (fecha),
--sum (LlamadasTotales)

--from CallCenter..Datos$
--where Fecha != 'z: Totales'
--group by Fecha
--order by Fecha desc



/*Borra las bases creadas*/
drop table BaseCallcenterLLamadasRecibidas##;
drop table totalLlamdasRecibidas##;
drop table totalLlamdasRecibidasMayora20##;
drop table totalLlamdasRecibidasMenora20##;
drop table totalLlamdasAbandonadasMayora20##;
drop table totalLlamdasAbandonadasMenora20##;
drop table totalLlamdasIVR##;


/*Inicia base general callCenter BaseCallcenterLLamadasRecibidas##*/
select 
TRY_CONVERT (date, a.Fecha,120) AS 'Fecha',
a.Hora,
a.LlamadasTotales,
a.AbandonoIVR,
a.LlamadasRecibidas,
a.LlamadasAtendidas,
a.LlamadasAbandonadas,
a.AbandonadasMenorA20,
a.AbandonadasMayorA20,
a.llamadasAtendidasMenorA20,
a.llamadasAtendidasMayorA20,
a.dv_groupname,
a.Campania,
CONVERT(TIME(0), TRY_CAST(a.TMO AS TIME)) AS 'TMO',
a.TMO AS 'TMOORIGINAL',
CONVERT(TIME(0), TRY_CAST(a.VelRespuesta AS TIME)) AS 'ASA',
a.VelRespuesta,

case when a.LlamadasTotales != '0'  then  'LLamadas totales'
	 ELSE 'Revisar' end 'estatusTotales',

case when a.AbandonoIVR != '0'  then  'abandono IVR'
	 ELSE 'Revisar' end 'estatusAbandonoIVR',

case when a.AbandonadasMayorA20 != '0'  then  'Abandonadas mayor a 20'
	 ELSE 'Revisar' end 'estatusabandonadasMayora20',
	 
case when a.AbandonadasMenorA20 != '0'  then  'Abandonadas menor a 20'
	 ELSE 'Revisar' end 'estatusabandonadasMenora20',

case when a.llamadasAtendidasMayorA20 != '0'  then  'Atendidas mayor a 20'
	 ELSE 'Revisar' end 'estatusatendidasMayora20',


case when a.llamadasAtendidasMenorA20 != '0'  then  'Atendidas menor a 20'
	 ELSE 'Revisar' end 'estatusatendidasMenora20',

a.VelRepuesta,
a.AgentesConectados,
b.[Numero de agnetes x hora actual],
c.[Numero de medicos x hora actual]

into BaseCallcenterLLamadasRecibidas## 


from CallCenter..Datos$ a /*base cargada desde un excel*/

left join (select 
           Horas,
		   Total as 'Numero de agnetes x hora actual'
		   From CallCenter..Agente$) as b on a.Hora = b.Horas

left join (select 
           Horas,
		   Total as 'Numero de medicos x hora actual'
		   From CallCenter..medico$) as c on a.Hora = c.Horas
where Fecha not  in ('z: Totales');

/*termina base general callCenter BaseCallcenterLLamadasRecibidas##*/

/*Inicia base totalLlamdasRecibidasMayora20##*/

Select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
llamadasAtendidasMayorA20 as 'Numerodellamadas',
estatusatendidasMayora20 as 'estatus'


into totalLlamdasRecibidasMayora20##

from BaseCallcenterLLamadasRecibidas##
where estatusatendidasMayora20 = 'Atendidas mayor a 20';

/*Termina base totalLlamdasRecibidasMayora20##*/

/*Inicia base totalLlamdasRecibidasMenora20##*/

Select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
llamadasAtendidasMenorA20 as 'Numerodellamadas',
estatusatendidasMenora20 as 'estatus'

into totalLlamdasRecibidasMenora20##

from BaseCallcenterLLamadasRecibidas##
where estatusatendidasMenora20 = 'Atendidas menor a 20';

/*Termina base totalLlamdasRecibidasMenora20##*/

/*Inicia base totalLlamdasAbandonadasMayora20##*/

Select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
AbandonadasMayorA20 as 'Numerodellamadas',
estatusabandonadasMayora20 as 'estatus'

into totalLlamdasAbandonadasMayora20##

from BaseCallcenterLLamadasRecibidas##
where estatusabandonadasMayora20 = 'Abandonadas mayor a 20';

/*Termina base totalLlamdasAbandonadasMayora20##*/

/*Inicia base totalLlamdasAbandonadasMenora20##*/

Select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
AbandonadasMenorA20 as 'Numerodellamadas',
estatusabandonadasMenora20 as 'estatus'

into totalLlamdasAbandonadasMenora20##

from BaseCallcenterLLamadasRecibidas##
where estatusabandonadasMenora20 = 'Abandonadas menor a 20';

/*Termina base totalLlamdasAbandonadasMenora20##*/

/*Inicia base totalLlamdasIVR## */

Select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
AbandonoIVR as 'Numerodellamadas',
estatusAbandonoIVR as 'estatus'

into totalLlamdasIVR##

from BaseCallcenterLLamadasRecibidas##
where estatusAbandonoIVR = 'abandono IVR';

/*Termina base totalLlamdasIVR##*/

/*Aumentar el tamaño de la columna,necesitas que la columna tenga al menos 10 caracteres*/
ALTER TABLE CallCenter.dbo.totalLlamdasRecibidasMayora20## 
ALTER COLUMN estatus VARCHAR(50);  -- O el tamaño que consideres adecuado

ALTER TABLE CallCenter.dbo.totalLlamdasRecibidasMayora20## 
ALTER COLUMN AgentesConectados float;  -- O el tamaño que consideres adecuado


/*inserta a la tabla totalLlamdasRecibidasMayora20## los datos de la tabla totalLlamdasRecibidasMenora20## */

insert into  totalLlamdasRecibidasMayora20##(
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus
)
select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus

from totalLlamdasRecibidasMenora20##

/*termnina el into a la tabla totalLlamdasRecibidasMayora20## los datos de la tabla totalLlamdasRecibidasMenora20##*/


/*inserta a la tabla totalLlamdasRecibidasMayora20##  todo lo que tiene la base totalLlamdasIVR##*/
insert into  totalLlamdasRecibidasMayora20## (
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus
)
select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus

from totalLlamdasIVR##

/*termnina el into totalLlamdasRecibidasMayora20## de todo lo que tiene la base totalLlamdasIVR##*/

/*inserta a la tabla totalLlamdasRecibidasMayora20#### todo lo que tiene la base totalLlamdasAbandonadasMayora20##*/
insert into  totalLlamdasRecibidasMayora20## (
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus
)
select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus

from totalLlamdasAbandonadasMayora20##

/*termnina el into a la tabla totalLlamdasRecibidasMayora20#### todo lo que tiene la base totalLlamdasAbandonadasMayora20##*/

/*inserta a la tabla totalLlamdasRecibidasMayora20#### todo lo que tiene la base totalLlamdasAbandonadasMenora20##*/
insert into  totalLlamdasRecibidasMayora20## (
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus
)
select 
Fecha,
Hora,
[Numero de agnetes x hora actual],
[Numero de medicos x hora actual],
AgentesConectados,
Campania,
dv_groupname,
TMO,
TMOORIGINAL,
VelRespuesta,
ASA,
Numerodellamadas,
estatus

from totalLlamdasAbandonadasMenora20##

/*termnina el into a la tabla totalLlamdasRecibidasMayora20## todo lo que tiene la base totalLlamdasAbandonadasMenora20##*/

/*se crea la base para power bi*/
select *,

case when estatus = 'Atendidas mayor a 20' then 'Recibidas'
     when estatus = 'Atendidas menor a 20' then 'Recibidas'
	 when estatus = 'Abandonadas mayor a 20' then 'Recibidas'
	 when estatus = 'Abandonadas menor a 20' then 'Recibidas'
	 when estatus = 'abandono IVR' then 'Abandono IVR'
	 else 'revisar' end 'EstatusPowerbiGeneral',

case when estatus = 'Atendidas mayor a 20' then 'Atendidas'
     when estatus = 'Atendidas menor a 20' then 'Atendidas'
	 when estatus = 'Abandonadas mayor a 20' then 'Abandonadas'
	 when estatus = 'Abandonadas menor a 20' then 'Abandonadas'
	 when estatus = 'abandono IVR' then 'Abandono IVR'
	 else 'revisar' end 'EstatusPowerbiRecibidas',

case when Campania like '%5589930250%' then 'BANRURAL'
     when Campania like '%5589930248%' then 'INDEP'
	 when Campania like '%5589930395%' then 'CNBV'
	 ELSE 'TRANSFERENCIA' END 'EstatusClientes',

case when Campania like '%EMERGENCIA_MEDICA%' then 'Emergencia Medica'
    when  Campania like '%ACTIVACION_NURS%' then 'Activacion de nur'
	when  Campania like '%Internamiento-evento-hospitalizacion%' then 'Internamiento evento hospitalizacion'
	when  Campania like '%REF_PROVEEDORES%' then 'REF Proveedores'
	when  Campania like '%EGRESO_HOSPITALARIO%' then 'Egreso hospitalario'
	when  Campania like '%MEDICAMENTO_RECETA%' then 'Medicamento receta'
	when  Campania like '%AUTORIZACION%' then 'Autorizacion'
	when  Campania like '%SOLICITUD_SEGUIMIENTO_AUTO%' then 'Solicitud seguimiento auto'
	when  Campania like '%SOPORTE_TECNICO%' then 'Soporte tecnico'
	when  Campania like '%TRASLADO_INSUMOS%' then 'Traslado insumos'
	when  Campania like '%ALTA_PROGRAMAS%' then 'Alta programa'
	when  Campania like '%SEGUIMIENTO%' then 'Seguimiento'
	when  Campania like '%STATUS_PAGO%' then 'Status pago'
	when  Campania like '%ALTA_PROGRAMAS%' then 'Alta programas'
	when  Campania like '%ATENCION_PERSONALIZADA%' then 'Atencion personalizada'
	when  Campania like '%STATUS_PAGO%' then 'Status pago'
	when  Campania like '%ATC%' then 'ATC'
	when  Campania like '%COBRANZA-OMA%' then 'Cobranza OMA'
	ELSE 'REVISAR' END 'EstatusCampaña'

into totalLlamdasRecibidas##

 From totalLlamdasRecibidasMayora20##


--select *from totalLlamdasRecibidas##