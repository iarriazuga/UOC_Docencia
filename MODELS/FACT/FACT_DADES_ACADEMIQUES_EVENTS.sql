
-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_DADES_ACADEMIQUES_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS AS 

with temp_table as (
    select 
 

        dades_academiques.id_assignatura   
        , dades_academiques.id_semestre
        , dades_academiques.id_codi_recurs    
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
        and dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY = events.DIM_RECURSOS_APRENENTATGE_KEY -- 43k  -- agrupar por COCO + recursos 
        -- and dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por -->  duplicados

) 
select * from temp_table



