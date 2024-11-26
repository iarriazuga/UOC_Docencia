-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_EVENTS_SIMPLIFIED 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_SIMPLIFIED AS 

with auxiliar as ( 
SELECT 

    dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , count( dades_academiques.ID_CODI_RECURS )  as TIMES_USED
 

FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL dades_academiques
group by 1,2,3

) 

select 
    DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , coalesce(TIMES_USED , 0) as TIMES_USED
from auxiliar
 

-- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_SIMPLIFIED limit 100
-- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL limit 100