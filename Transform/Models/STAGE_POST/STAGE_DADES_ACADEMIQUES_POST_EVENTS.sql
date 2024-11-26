-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_DADES_ACADEMIQUES_POST 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_POST_EVENTS AS 
with auxiliar as ( 
SELECT 

    dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , dades_academiques.ID_RESOURCE
    , dades_academiques.TITOL_RESOURCE 
    , dades_academiques.plan_estudios_base
    , dades_academiques.SOURCE_DADES_ACADEMIQUES

    , coalesce(events.TIMES_USED, 0) as TIMES_USED -- 48k --> 8k ( ejemplo)
    , events.SOURCE

FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_POST dades_academiques -- 7,888,532

left join DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
    on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
    and dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
    and dades_academiques.ID_RESOURCE = events.ID_RESOURCE -- 43k 


) 

select * from auxiliar
-- order by DIM_SEMESTRE_KEY desc 
where  1=1
-- and SOURCE is not null
-- and DIM_ASSIGNATURA_KEY is not null  -- 35,313


-- left join : 7,890,407
-- inner join : 35,313 
-- right join : 1,126,400
-- left join  with not null :  35,313 

