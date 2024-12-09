/*

--FACT_DADES_ACADEMIQUES: 
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_DADES_ACADEMIQUES_COCO' As tabla        from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_DADES_ACADEMIQUES_DIMAX' As tabla      from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'POST_DADES_ACADEMIQUES' As tabla             from  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES union all
-- EVENTS  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'STAGE_LIVE_EVENTS_FLATENED' As tabla         from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED   union all  
-- FACTS  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'FACT_DADES_ACADEMIQUES_EVENTS' As tabla      from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS  union all  
select count(*), count(distinct *), count(DISTINCT CODI_RECURS), COUNT(DISTINCT DIM_ASSIGNATURA_KEY), 'FACT_DADES_ACADEMIQUES_EVENTS_AGG' As tabla  from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG union all 


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
    , 'POST_DADES_ACADEMIQUES' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES  

-- EVENTS  
union all 
select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_LIVE_EVENTS_FLATENED' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED  


-- FACTS  : convertimos codi_recurs a dim_recursos_aprenentatge_key
union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_DADES_ACADEMIQUES_EVENTS' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS


union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_DADES_ACADEMIQUES_EVENTS_AGG' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG





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




 
---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--VERIFICACIONES
--FACT_DADES_ACADEMIQUES: 

union all
select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_DADES_ACADEMIQUES_COCO2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO2  

union all

select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_DADES_ACADEMIQUES_DIMAX2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX2  

union all

select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'POST_DADES_ACADEMIQUES2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES2  

-- EVENTS  
union all 
select 
    count(*) 
    , count(distinct CODI_RECURS, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'STAGE_LIVE_EVENTS_FLATENED2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED2  


-- FACTS  : convertimos codi_recurs a dim_recursos_aprenentatge_key
union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_DADES_ACADEMIQUES_EVENTS2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS2


union all 
select 
    count(*) 
    , count(distinct dim_recursos_aprenentatge_key, DIM_ASSIGNATURA_KEY, dim_semestre_key ) as mix_distinc 
    , count(DISTINCT dim_recursos_aprenentatge_key) as recurs
    , COUNT(DISTINCT DIM_ASSIGNATURA_KEY) as asignatura
    , 'FACT_DADES_ACADEMIQUES_EVENTS_AGG2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2





-- DIM_RECURSOS_APRENENTATGE:
union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'STAGE_RECURSOS_APRENENTATGE_DIMAX2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_DIMAX2

union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS2

union all 
select 
    count(*) 
    , 0 as mix_distinc 
    , count(DISTINCT CODI_RECURS) as recurs
    , 0 as asignatura
    , 'DIM_RECURSOS_APRENENTATGE2' As tabla        
from  DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE2

