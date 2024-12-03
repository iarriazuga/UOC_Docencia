
-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_DADES_ACADEMIQUES_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS (

    ID_ASSIGNATURA NUMBER(38, 0),
    ID_SEMESTRE NUMBER(38, 0),
    ID_CODI_RECURS NUMBER(38, 0),
    DIM_ASSIGNATURA_KEY VARCHAR2(6),
    DIM_SEMESTRE_KEY NUMBER(38, 0),
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR2(15),
    SOURCE_DADES_ACADEMIQUES VARCHAR2(5),
    CODI_RECURS NUMBER(38, 0),
    EVENT_CODI_RECURS NUMBER(38, 0),
    EVENT_TIME VARCHAR2(16777216),
    EVENT_DATE VARCHAR2(16777216),
    ACTION VARCHAR2(16777216),
    ACTOR_NAME VARCHAR2(16777216),
    ACTOR_TYPE VARCHAR2(16777216),
    USERLOGIN VARCHAR2(16777216),
    USER_SIS_ID VARCHAR2(16777216),
    GROUP_NAME VARCHAR2(16777216),
    CANVASCOURSEID VARCHAR2(16777216),
    SISCOURSEID VARCHAR2(16777216),
    ROL VARCHAR2(16777216),
    MEMBERSHIP_STATUS VARCHAR2(16777216),
    OBJECT_NAME VARCHAR2(16777216),
    OBJECT_ID VARCHAR2(16777216),
    OBJECT_MEDIATYPE VARCHAR2(16777216),
    OBJECT_TYPE VARCHAR2(16777216),
    FORMAT VARCHAR2(16777216),
    SOURCE VARCHAR2(6),
    URL VARCHAR2(16777216)

) AS 

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
        -- and dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY = events.DIM_RECURSOS_APRENENTATGE_KEY   --      14_859_255
        and dades_academiques.CODI_RECURS = events.CODI_RECURS -- confirmacion Francesc & Acoran 2024/12/03 :   15_720_775

) 
select * from temp_table



/*

select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS  limit 100
select count(*) from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS  

desc table  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS 

*/

