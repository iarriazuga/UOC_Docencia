

-- -- #################################################################################################
-- -- #################################################################################################
-- -- ANALISIS_CALIPER_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TEMP TABLE DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS AS

with aux as (

select 
-- DIM_ASSIGNATURA_KEY, 
-- DIM_SEMESTRE_KEY, 
DIM_RECURSOS_APRENENTATGE_KEY, 
CODI_RECURS,
upper(source) as source_event,
count(*) as num_events

from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED   -- 12,224,872 vs 172,784 grouped
group by 1,2,3 -- ,4,5

/*
select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED limit 100 
select source_event, count(*) from aux group by 1 order by 2 desc

    SOURCE_EVENT	COUNT(*) 
    NIU	            12_224_872
    null	        41_042
    DIMAX	        27_288
    COCO	        19_027

*/
), 

codi_recurs_valoration as (
    
    select *,
    case 
        -- Both tables: 
        when 
            codi_recurs in (select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS)  
            and 
            codi_recurs in (select codi_recurs from db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax)  
        then 'BOTH'

        -- Dimax only: 
        when 
            codi_recurs in (select codi_recurs from db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax)  
        then 'DIMAX'

        -- Coco only:
        when 
            codi_recurs in (select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS)  
        then 'COCO'

    else 'ERROR' end as codi_recurs_origen
    from aux  
)
/*

select codi_recurs_origen , count(*) from codi_recurs_valoration group by 1 order by 2 desc

CODI_RECURS_ORIGEN	COUNT(*)
DIMAX	            33_389
COCO	            30_859
BOTH	            7_290 -- listar y presentar a francesc 
ERROR	            11
    * not fount in base tables: 
        db_uoc_prod.stg_dadesra.autors_producte  -- coco_prod
        db_uoc_prod.stg_dadesra.autors_modul   -- coco_mod
        db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax  -- dimax
        db_uoc_prod.stg_dadesra.dimax_v_recurs -- id_recurs --> origen tables 
    
    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'
*/

select * 
from codi_recurs_valoration 

where 1=1
-- and codi_recurs_origen = 'ERROR'
and codi_recurs_origen = 'BOTH'






with aux  as ( 

select distinct
eve.codi_recurs , eve.source,  rec.source_recurs
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED eve

left join DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE rec 
on eve.codi_recurs = rec.codi_recurs
) 

select source , source_recurs,  count(*) 

from aux
group by 1,2
order by 1 desc


--- valoracion de duplicados  : conservamos --> pasar listado a frances : 
select codi_recurs, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE --8,975
group by 1
having count(*) > 1 




--- valoracion de duplicados 
select codi_recurs as test2 , * --codi_recurs, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE --8,975
where codi_recurs in ( 



'114045',
'113965',
'122347',
'114123',
'113993',
'122487',
'113963',
'122291',
'122293',
'122351',
'122276',
'113887'
)
 order by codi_recurs desc

-- francesc
listado asignaturas no matchean / no existen STAGE_LIVE_EVENTS_FLATENED
listado recursos no matchean / no existen STAGE_LIVE_EVENTS_FLATENED


/**
niu	null	9
niu	DIMAX	17117
niu	COCO_PROD	12893
niu	COCO_MOD	2909

-- fase 2 
niu	null	6
niu	DIMAX	17195
niu	COCO_MOD	2909
niu	COCO_PROD	10372


*/