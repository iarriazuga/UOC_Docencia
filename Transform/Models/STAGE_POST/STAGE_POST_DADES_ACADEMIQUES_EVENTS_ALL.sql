
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
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL AS 

with temp_table as (
    select 
        dades_academiques.*

        , events.ID_ASIGNATURA_RECURS
        , events.ID_CODI_RECURS
        , events.EVENT_TIME
        , events.EVENT_DATE
        , events.ACTION
        , events.ACTOR_NAME
        , events.ACTOR_TYPE
        , events.USERLOGIN
        , events.USER_SIS_ID
        , events.GROUP_NAME
        , events.SEMESTER
        , events.CANVASCOURSEID
        , events.SISCOURSEID
        , events.SUBJECTCODE
        , events.ROL
        , events.MEMBERSHIP_STATUS
        , events.OBJECT_NAME
        , events.OBJECT_ID
        , events.OBJECT_MEDIATYPE
        , events.OBJECT_TYPE
        , events.FORMAT
        , events.MATERIAL_ID
        , events.SOURCE
        , events.URL

    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES dades_academiques -- 7,888,532

    left join DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED events   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.SUBJECTCODE -- 114,821,250
        and dades_academiques.DIM_SEMESTRE_KEY = events.SEMESTER
        and dades_academiques.CODI_RECURS = events.MATERIAL_ID -- 43k 

) 
select * from temp_table


-- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL -- 14,119,411 
