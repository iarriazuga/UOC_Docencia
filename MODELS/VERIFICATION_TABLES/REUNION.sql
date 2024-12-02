-- francesc
listado recursos no matchean / no existen STAGE_LIVE_EVENTS_FLATENED
listado asignaturas no matchean / no existen STAGE_LIVE_EVENTS_FLATENED



-- 1) RECURSOS QUE NO LLEGAN

select * 
from DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS

where 1=1
-- and SOURCE2 = 'ERROR' -- no aparecen en dimax ni coco  -- 6 
and SOURCE2 = 'BOTH'  -- codigo en las 2 pero no sabemos como asignarlo  -- 3,534


--2) ASIGNATURAS QUE NO LLEGAN 
select * 
from  DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_ASSIGNATURA_EVENTS
where 1=1
and DIM_ASSIGNATURA_KEY_origen = 'ERROR'

/*

DIM_ASSIGNATURA_KEY	    NUM_EVENTS	DIM_ASSIGNATURA_KEY_ORIGEN
KK.RRR	                14	        ERROR
99.807	                48	        ERROR

*/

