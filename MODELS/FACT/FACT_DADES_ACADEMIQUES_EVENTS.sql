
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
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS AS 

with temp_table as (
    select 
 

            
        dades_academiques.DIM_ASSIGNATURA_KEY
        , dades_academiques.DIM_SEMESTRE_KEY
        , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY    
        , dades_academiques. PLAN_ESTUDIOS_BASE
        , dades_academiques.SOURCE_DADES_ACADEMIQUES
        , dades_academiques.CODI_RECURS

        -- , events.DIM_SEMESTRE_KEY
        -- , events.CODI_RECURS
        -- , events.DIM_ASSIGNATURA_KEY
        
        --REVIEW
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

        , events.CANVASCOURSEID
        , events.SISCOURSEID

        , events.ROL
        , events.MEMBERSHIP_STATUS
        , events.OBJECT_NAME
        , events.OBJECT_ID
        , events.OBJECT_MEDIATYPE
        , events.OBJECT_TYPE
        , events.FORMAT

        , events.SOURCE
        , events.URL

    FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES dades_academiques -- 7,888,532

    left join DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED events   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        and dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        and dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 

) 
select * from temp_table


-- -- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL -- 14,119,411 


-- select 
-- dim_assignatura_key
-- , dim_semestre_key
-- , dim_recursos_aprenentatge_key
-- , count(*)

-- from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS_ALL  
-- group by 1,2,3


-- -- STAGE_POST_DADES_ACADEMIQUES :  5,204,193 duplicados 
-- select 
-- dim_assignatura_key
-- , dim_semestre_key
-- , dim_recursos_aprenentatge_key
-- , count(*)

-- from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES  
-- group by 1,2,3
-- having count(*) > 1 

-- order by 4 desc