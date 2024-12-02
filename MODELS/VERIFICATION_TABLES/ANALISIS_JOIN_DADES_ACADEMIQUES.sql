-- CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS AS 

with temp_table_dim_key as (
    select 
        dades_academiques.DIM_ASSIGNATURA_KEY || dades_academiques.DIM_SEMESTRE_KEY || dades_academiques.CODI_RECURS as concat_key
        , dades_academiques.DIM_ASSIGNATURA_KEY
        , dades_academiques.DIM_SEMESTRE_KEY
        , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY    
        -- , dades_academiques. PLAN_ESTUDIOS_BASE
        , dades_academiques.SOURCE_DADES_ACADEMIQUES
        , dades_academiques.CODI_RECURS


        
        --REVIEW
        , events.CODI_RECURS as EVENT_CODI_RECURS
        -- , events.DIM_SEMESTRE_KEY
        -- , events.DIM_ASSIGNATURA_KEY
        , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY  as events_key_rec
 
 
    FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques -- 7,888,532

    left join DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED events   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        and dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        and dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY = events.DIM_RECURSOS_APRENENTATGE_KEY -- 43k  -- agrupar por 
        -- and dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 

    where 1=1 
    and EVENT_CODI_RECURS is not null

) 

 

select * 

 
from temp_table_dim_key --- 12_351_002 vs not null  -- 9,813,254 -- mucho mas cercano 

where 1=1 
and EVENT_CODI_RECURS is not null
-- and concat_key  not in ( select concat_key from temp_table_dim_key )





-- 
-- select count(*) from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED -- 12_351_002








-- REVISION FRANCESC 
--- ANALISIS DE REGISTROS FALTANTES
with temp_table_dim_key as (
    select 
        dades_academiques.DIM_ASSIGNATURA_KEY || dades_academiques.DIM_SEMESTRE_KEY || dades_academiques.CODI_RECURS as concat_key
 
        -- , dades_academiques.DIM_ASSIGNATURA_KEY
        -- , dades_academiques.DIM_SEMESTRE_KEY
        -- , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY    
 
        , events.DIM_SEMESTRE_KEY
        , events.DIM_ASSIGNATURA_KEY
        , events.DIM_RECURSOS_APRENENTATGE_KEY   

        , events.source
        , events.source2
        --REVIEW
        , dades_academiques.CODI_RECURS as REC_CODI_RECURS
        , events.CODI_RECURS as EVENT_CODI_RECURS


 
    -- invers 
    --FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques  
    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED events

    left join  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        and dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        and dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY = events.DIM_RECURSOS_APRENENTATGE_KEY -- 43k  -- agrupar por 
        -- and dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 

    -- where 1=1 
    -- and EVENT_CODI_RECURS is not null

) 

, comprobacion as (
    select * -- source2 , count(*) 

 
    from temp_table_dim_key --- 12,527,830 vs not null  --9,861,422 -- mucho mas cercano 

    where 1=1 
    and REC_CODI_RECURS is null  --  2,666,408
    -- and source2 <> 'BOTH'  --- 1,778,133
) 

SELECT distinct EVENT_CODI_RECURS-- * 5,248 resources no aparecen
from comprobacion 
where 1=1 
-- and DIM_ASSIGNATURA_KEY not in ( select DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES   ) -- all resources included
and EVENT_CODI_RECURS not in ( select Codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES   ) -- all resources included 1,762,759 vs  1,781,031 (BOTH difference)

/*

null	20232	UX.195	COCO - 299075	null	299075 --> analizamos este
null	20241	UX.195	COCO - 299078	null	299078
null	20232	21.532	COCO - 300124	null	300124
null	20241	13.544	COCO - 300376	null	300376
null	20232	71.529	DIMAX - 110283	null	110283
null	20232	71.529	DIMAX - 110283	null	110283
null	20231	78.599	DIMAX - 96421	null	96421
null	20232	21.152	DIMAX - 98638	null	98638
-

*/

SELECT * 
from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques  
where 1=1
    and dades_academiques.DIM_ASSIGNATURA_KEY = 'UX.195'
    -- and dades_academiques.DIM_SEMESTRE_KEY = '20232' -- solo 2 recursos para ese semestre --> francesc         299073, 60730
    and dades_academiques.codi_recurs  in  (
        '299233',
        '299073',
        '282957',
        '60730',
        '299234',
        '52636',
        '278115',
        '52660'
    )

SELECT * 
from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques  
where 1=1
    and dades_academiques.DIM_ASSIGNATURA_KEY = '71.529'
    and dades_academiques.DIM_SEMESTRE_KEY = '20232' -- solo 2 recursos para ese semestre --> francesc         299073, 60730
    and dades_academiques.codi_recurs  in  (
        '299233',
        '299073',
        '282957',
        '60730',
        '299234',
        '52636',
        '278115',
        '52660'
    )

C0.079








 




select * 
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE -- estan todos 
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO -- no aparecen
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX --- no aparecen 
where codi_recurs in ( 

'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)


-- Coco BASE: 
select * 
FROM db_uoc_prod.stg_dadesra.autors_productes_versions productos_plan_publicacion  -- 247,902 vs  247,90
where PRODUCTE_ID in ( 

'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)



-- DIMAX_BASE: 
select * 
from  db_uoc_prod.stg_dadesra.dimax_resofite_path  -- no aparece 
where node_cami in (
'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)



select codi_recurs,  count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE -- estan todos 
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO -- no aparecen
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX --- no aparecen 
where codi_recurs in ( 

'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)

group by 1 









