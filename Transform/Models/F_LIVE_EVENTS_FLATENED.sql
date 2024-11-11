
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
with aux as (
select 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string   || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   as ID_ASIGNATURA_RECURS,  -- material id
    upper(GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string) || '-' ||  GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string   as ID_CODI_RECURS,  -- material id
   --JSON:dataVersion::string dataVersion,
    --JSON:data::string data,
    --JSON:data[0],
    JSON:sendTime::datetime as event_time,
    --GET_PATH(JSON, 'data[0]:event_time')::datetime as event_time_2,
    --event_time_2 - event_time as diff,
    JSON:sendTime::date as event_date,
    JSON:data[0]:action::string as action,
    --JSON:data[0]:actor.extensions,
    --GET_PATH(JSON, 'data[0]:actor.extensions'),
    GET_PATH(JSON, 'data[0]:actor.name')::string as actor_name,
    GET_PATH(JSON, 'data[0]:actor.type')::string as actor_type,  
    GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_login')::string as userlogin,
    GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_sis_id')::string as user_sis_id,    
    GET_PATH(JSON, 'data[0]:group.name')::string as group_name,  
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string as semester,
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".canvasCourseId')::string as canvasCourseId,   
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".sisCourseId')::string as sisCourseId, 
    GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string as subjectCode, 
    --GET_PATH(JSON, 'data[0]:id')::string as id_ralti,    
    GET_PATH(JSON, 'data[0]:membership.roles.roles')::string as rol,
    GET_PATH(JSON, 'data[0]:membership.status')::string as membership_status,
    GET_PATH(JSON, 'data[0]:object.name')::string as object_name,
    GET_PATH(JSON, 'data[0]:object.id')::string as object_id,
    GET_PATH(JSON, 'data[0]:object.mediatype')::string as object_mediatype,
    GET_PATH(JSON, 'data[0]:object.type')::string as object_type,
    --GET_PATH(JSON, 'data[0]:object.items[0]:extensions') as items,
    --GET_PATH(JSON, 'data[0]:object.extensions') as object_extensions,
    --GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti"') as ralti,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".format')::string as format,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string as material_id,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string as source,
    GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".url')::string as url--,
    --le.*

from  DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY le 
    --where subjectCode = 'M8.020'
    -- order by event_time DESC
) 
select * from aux    
where 1=1
and ID_ASIGNATURA_RECURS is not null
and ID_CODI_RECURS is not null  
;


-- live events:  
-- 

-- select * from  DB_UOC_PROD.DDP_DOCENCIA.F_LIVE_EVENTS_FLATENED;  -- 8,741,384
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

    GET_PATH(JSON, 'data[0]:object.type')::string as object_type,
    string as material_id,


*/