-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_EVENTS_SIMPLIFIED 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG AS 

with auxiliar as ( 
SELECT 

    dades_academiques.id_assignatura   
    , dades_academiques.id_semestre
    , dades_academiques.id_codi_recurs    
    , dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , count( dades_academiques.EVENT_CODI_RECURS )  as TIMES_USED
 

FROM  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
group by 1,2,3,4,5,6

) 

select
    id_assignatura
    , id_semestre
    , id_codi_recurs
    , DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , coalesce(TIMES_USED , 0) as TIMES_USED

from auxiliar
 

