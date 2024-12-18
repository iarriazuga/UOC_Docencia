/*

--FACT_DADES_ACADEMIQUES: 
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_DADES_ACADEMIQUES_COCO' As tabla        from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_DADES_ACADEMIQUES_DIMAX' As tabla      from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'POST_DADES_ACADEMIQUES_RA' As tabla             from  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA union all
-- EVENTS  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_LIVE_EVENTS_FLATENED_RA' As tabla         from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA   union all  
-- FACTS  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'FACT_RECURSOS_APRENENTATGE_EVENTS' As tabla      from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'FACT_DADES_RECURSOS_APRENENTATGE_AGG' As tabla  from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_RECURSOS_APRENENTATGE_AGG union all 


-- DIM_RECURSOS_APRENENTATGE: 
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_RECURSOS_APRENENTATGE_DIMAX' As tabla        from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_DIMAX union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS' As tabla      from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'DIM_RECURSOS_APRENENTATGE' As tabla             from  DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE 

*/


---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--VERIFICACIONES
--FACT_DADES_ACADEMIQUES: 
select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_DADES_ACADEMIQUES_COCO' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO  

union all

select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_DADES_ACADEMIQUES_DIMAX' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX  

union all

select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'POST_DADES_ACADEMIQUES_RA' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA  

-- EVENTS  
union all 
select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_LIVE_EVENTS_FLATENED_RA' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA  


-- FACTS  : convertimos codi_recurs a dim_recursos_aprenentatge_key
union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_RECURSOS_APRENENTATGE_EVENTS' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS


union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_DADES_RECURSOS_APRENENTATGE_AGG' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG





-- DIM_RECURSOS_APRENENTATGE:
union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'STAGE_RECURSOS_APRENENTATGE_DIMAX' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_DIMAX

union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS

union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'DIM_RECURSOS_APRENENTATGE' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE


/***

MIX_DISTINC: combinacion de asignatura y codi_recurs 

COUNT(*)	MIX_DISTINC	RECURS	ASIGNATURA	TABLA
1713249	    1713249	    52209	12197	STAGE_DADES_ACADEMIQUES_COCO
3390907	    3390907	    70357	14161	STAGE_DADES_ACADEMIQUES_DIMAX
5104156	    5104156	    116915	15797	POST_DADES_ACADEMIQUES_RA
91341	    11897	    9161	2085	STAGE_LIVE_EVENTS_FLATENED_RA
5174058	    5104156	    122566	15797	FACT_RECURSOS_APRENENTATGE_EVENTS
5104156	    5104156	    122566	15797	FACT_DADES_RECURSOS_APRENENTATGE_AGG

102166	    0	        102166	0	    STAGE_RECURSOS_APRENENTATGE_DIMAX
116900	    0	        116893	0	    STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
219060	    0	        208930	0	    DIM_RECURSOS_APRENENTATGE

*/



 select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
