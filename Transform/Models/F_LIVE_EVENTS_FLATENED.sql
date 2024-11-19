
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
CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_LIVE_EVENTS_FLATENED AS 
with aux AS (
SELECT 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string   || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   AS ID_ASIGNATURA_RECURS,  -- material id
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
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string AS semester,
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".canvasCourseId')::string AS canvasCourseId,   
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".sisCourseId')::string AS sisCourseId, 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string AS subjectCode, 
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
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string AS material_id,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string AS source,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".url')::string AS url--,
    --le.*

FROM  DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY le 
    --where subjectCode = 'M8.020'
    -- order by event_time DESC
) 
SELECT * FROM aux    
where 1=1
and ID_ASIGNATURA_RECURS is not null
and ID_CODI_RECURS is not null  
;


-- live events:  
-- 

-- SELECT * FROM  DB_UOC_PROD.DDP_DOCENCIA.F_LIVE_EVENTS_FLATENED;  -- 8,741,384
-- drop table DB_UOC_PROD.DDP_DOCENCIA.F_LIVE_EVENTS_FLATENED


 /**
 
elink : ver todos los clicks de todos los canales noticias 
campus virtual : ( nivel dia --> convertir semestre )  
- grupos debate 
- groups recursos 

    - elink: consultar como traer para eventos 


*/



/***

-- 
FACTS 
* Uso
* que hay en cada semestre 

DIMENSIONES
- Catalogo 
- Asignatura
- Semestre --> calendario 

FRANCESC 2 
ver si los alumnos acceden a los recursos  --> 1 ( cumple con la events)

ver recursos se asignan semestralmente a las asignaturas  -->  ( dim / )  -->  DADES_ACADEMICAS -->  ( aplanada )



semestre 24: 
dim catalog : --> todos los recursos , --> te faltaria semestre para la asignatura
dades_academiques: asignaturas , alumno ,semestre , recurso 

recursos que tienes -->  matematicas ( )

    GET_PATH(JSON, 'data[0]:object.type')::string AS object_type,
    string AS material_id,


*/