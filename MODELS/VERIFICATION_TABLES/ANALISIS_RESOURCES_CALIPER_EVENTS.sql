

-- -- #################################################################################################
-- -- #################################################################################################
-- -- ANALISIS_CALIPER_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################
-- CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS AS

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
DIMAX	            33389
COCO	            30859
BOTH	            7290
ERROR	            11
    * not fount in base tables: 
        db_uoc_prod.stg_dadesra.autors_producte  -- coco_prod
        db_uoc_prod.stg_dadesra.autors_modul autors_modul  -- coco_mod
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




