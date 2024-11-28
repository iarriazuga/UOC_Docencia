
-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_LIVE_EVENTS_FLATENED_
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE   TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_AUX AS 

with aux_cte_table AS (
SELECT 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".DIM_ASSIGNATURA_KEY')::string   || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   AS ID_ASIGNATURA_RECURS,  -- material id
    upper(GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string) || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   AS DIM_RECURSOS_APRENENTATGE_KEY,  -- material id
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string AS CODI_RECURS,
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string AS DIM_ASSIGNATURA_KEY, 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string AS DIM_SEMESTRE_KEY,

   --JSON:dataVersion::string dataVersion,
    --JSON:data::string data,
    --JSON:data[0],
    JSON:sendTime::datetime AS event_time,
    --GET_PATH(JSON, 'data[0]:event_time')::datetime AS event_time_2,
    --event_time_2 - event_time AS diff,
    JSON:sendTime::date AS event_date,
    JSON:data[0]:action::string AS action,
    --JSON:data[0]:actor.extensions,
    --GET_PATH(JSON, 'data[0]:actor.extensions'),
    GET_PATH(JSON, 'data[0]:actor.name')::string AS actor_name,
    GET_PATH(JSON, 'data[0]:actor.type')::string AS actor_type,  
    GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_login')::string AS userlogin,
    GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_sis_id')::string AS user_sis_id,    
    GET_PATH(JSON, 'data[0]:group.name')::string AS group_name,  

    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".canvasCourseId')::string AS canvasCourseId,   
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".sisCourseId')::string AS sisCourseId, 

    --GET_PATH(JSON, 'data[0]:id')::string AS id_ralti,    
    GET_PATH(JSON, 'data[0]:membership.roles.roles')::string AS rol,
    GET_PATH(JSON, 'data[0]:membership.status')::string AS membership_status,
    GET_PATH(JSON, 'data[0]:object.name')::string AS object_name,
    GET_PATH(JSON, 'data[0]:object.id')::string AS object_id,
    GET_PATH(JSON, 'data[0]:object.mediatype')::string AS object_mediatype,
    GET_PATH(JSON, 'data[0]:object.type')::string AS object_type,
    --GET_PATH(JSON, 'data[0]:object.items[0]:extensions') AS items,
    --GET_PATH(JSON, 'data[0]:object.extensions') AS object_extensions,
    --GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti"') AS ralti,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".format')::string AS format,

    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string AS source,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".url')::string AS url--,
    --le.*

FROM  DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY le 
    --where DIM_ASSIGNATURA_KEY = 'M8.020'
    -- order by event_time DESC
) 
SELECT * FROM aux_cte_table    
where 1=1
    -- and ID_ASIGNATURA_RECURS is not null
    -- AND DIM_SEMESTRE_KEY IS NOT NULL
    -- AND CODI_RECURS IS NOT NULL
;
 
----######################## Replace the auxiliar table 
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED (
    ID_ASIGNATURA_RECURS VARCHAR(16777216),
    DIM_ASSIGNATURA_KEY VARCHAR(6),  
    DIM_SEMESTRE_KEY INT, 
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15), 
    CODI_RECURS INT, 
    EVENT_TIME VARCHAR(16777216), 
    EVENT_DATE VARCHAR(16777216), 
    ACTION VARCHAR(16777216),
    ACTOR_NAME VARCHAR(16777216),
    ACTOR_TYPE VARCHAR(16777216),
    USERLOGIN VARCHAR(16777216),
    USER_SIS_ID VARCHAR(16777216),
    GROUP_NAME VARCHAR(16777216),
    CANVASCOURSEID VARCHAR(16777216),
    SISCOURSEID VARCHAR(16777216),
    ROL VARCHAR(16777216),
    MEMBERSHIP_STATUS VARCHAR(16777216),
    OBJECT_NAME VARCHAR(16777216),
    OBJECT_ID VARCHAR(16777216),
    OBJECT_MEDIATYPE VARCHAR(16777216),
    OBJECT_TYPE VARCHAR(16777216),
    FORMAT VARCHAR(16777216),
    SOURCE VARCHAR(16777216),
    URL VARCHAR(16777216)
) AS

WITH aux_cte_table AS (
    SELECT 
        ID_ASIGNATURA_RECURS, 
        LEFT(DIM_ASSIGNATURA_KEY, 6) AS DIM_ASSIGNATURA_KEY,  -- Truncate to fit VARCHAR(6)
        TRY_CAST(DIM_SEMESTRE_KEY AS INT) AS DIM_SEMESTRE_KEY, 
        LEFT(DIM_RECURSOS_APRENENTATGE_KEY, 15) AS DIM_RECURSOS_APRENENTATGE_KEY,  
        TRY_CAST(CODI_RECURS AS INT) AS CODI_RECURS, 
        
        EVENT_TIME,  
        EVENT_DATE,   
        ACTION, 
        ACTOR_NAME, 
        ACTOR_TYPE, 
        USERLOGIN, 
        USER_SIS_ID, 
        GROUP_NAME, 
        CANVASCOURSEID, 
        SISCOURSEID, 
        ROL, 
        MEMBERSHIP_STATUS, 
        OBJECT_NAME, 
        OBJECT_ID, 
        OBJECT_MEDIATYPE, 
        OBJECT_TYPE, 
        FORMAT, 
        SOURCE, 
        URL
    FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_AUX
) 
SELECT * 
FROM aux_cte_table    
WHERE DIM_ASSIGNATURA_KEY IS NOT NULL
  AND DIM_SEMESTRE_KEY IS NOT NULL
  AND CODI_RECURS IS NOT NULL;

drop table DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_AUX;
