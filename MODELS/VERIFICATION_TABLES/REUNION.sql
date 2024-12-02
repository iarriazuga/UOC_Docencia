-- francesc
listado recursos no matchean / no existen STAGE_LIVE_EVENTS_FLATENED
listado asignaturas no matchean / no existen STAGE_LIVE_EVENTS_FLATENED

-- Previa: delete confirmation --> borramos modulos duplicados coco --> francesc 02/12/2024
select * 
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
where codi_recurs in ( SELECT codi_recurs FROM DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP ) 


-- 1) RECURSOS QUE NO LLEGAN
select * 
from DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS

where 1=1
-- and SOURCE2 = 'ERROR' -- no aparecen en dimax ni coco  -- 6 : ---> francesc revisa 
and SOURCE2 = 'BOTH'  -- codigo en las 2 pero no sabemos como asignarlo  -- 3,534

select SOURCE2, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS
group by 1
order by 2 desc 

--2) ASIGNATURAS QUE NO LLEGAN 
select * 
from  DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_ASSIGNATURA_EVENTS
where 1=1
and DIM_ASSIGNATURA_KEY_origen = 'ERROR'

/*

DIM_ASSIGNATURA_KEY	    NUM_EVENTS	DIM_ASSIGNATURA_KEY_ORIGEN
KK.RRR	                14	        ERROR
99.807	                48	        ERROR


-- docente : persona docente --> fact 
asignaturas equivalentes
periodo validez en la asignatura 
* victor : equipo  
* francesc 

*/

