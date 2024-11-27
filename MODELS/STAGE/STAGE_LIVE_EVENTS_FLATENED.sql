
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
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED AS 
with aux AS (
SELECT 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".DIM_ASSIGNATURA_KEY')::string   || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   AS ID_ASIGNATURA_RECURS,  -- material id
    upper(GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string) || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   AS ID_CODI_RECURS,  -- material id
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
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string AS DIM_SEMESTRE_KEY,
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".canvasCourseId')::string AS canvasCourseId,   
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".sisCourseId')::string AS sisCourseId, 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".DIM_ASSIGNATURA_KEY')::string AS DIM_ASSIGNATURA_KEY, 
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
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string AS CODI_RECURS,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string AS source,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".url')::string AS url--,
    --le.*

FROM  DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY le 
    --where DIM_ASSIGNATURA_KEY = 'M8.020'
    -- order by event_time DESC
) 
SELECT * FROM aux    
where 1=1
and ID_ASIGNATURA_RECURS is not null
and ID_CODI_RECURS is not null  
;
-- fact_docencia_recursos_aprenentatje : como final ( eventos + catalogo de producto )

/*

 select  semester, count(*) 
 from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED 
 group by 1 order by 2 desc

 select distinct semester, event_date, event_time, action
 from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED 
*/ 
 
 