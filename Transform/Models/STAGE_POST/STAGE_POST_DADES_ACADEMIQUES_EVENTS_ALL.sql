
-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_DOCENCIA?
-- -- #################################################################################################
-- -- #################################################################################################
/***
Reutilizar tables de docencia
- fact docencia : semestre + asignatura + estudiante ( posible aula )
- nivel asignatura / docencia / semestre --> nivel estudiante 
6M historica

*/
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_LIVE_EVENTS_FLATENED_TRANSFORMED AS 

with temp_table as (
    select 
        dades_academiques.*
        , events.*

    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES dades_academiques -- 7,888,532

    left join DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        and dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        and dades_academiques.ID_RESOURCE = events.ID_RESOURCE -- 43k 

) 
select * from temp_table

