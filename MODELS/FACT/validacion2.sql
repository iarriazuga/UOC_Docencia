    WITH aux_cte_table AS (
        SELECT 
            GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string AS CODI_RECURS,
            GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string AS DIM_ASSIGNATURA_KEY,
            GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string AS DIM_SEMESTRE_KEY,
            JSON:sendTime::datetime AS event_time,
            JSON:sendTime::date AS event_date,
            JSON:data[0]:action::string AS ACCIO,
            GET_PATH(JSON, 'data[0]:actor.name')::string AS NOM_ACTOR,
            GET_PATH(JSON, 'data[0]:actor.type')::string AS ACTOR_TIPUS,
            GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_login')::string AS usuari_dAcces,
            GET_PATH(JSON, 'data[0]:actor.extensions."com.instructure.canvas".user_sis_id')::string AS id_idp_usuari_events,
            GET_PATH(JSON, 'data[0]:group.name')::string AS titol_assignatura,
            GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".canvasCourseId')::string AS id_curs_canvas,
            GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".sisCourseId')::string AS id_sistema_curs,
            GET_PATH(JSON, 'data[0]:membership.roles.roles')::string AS rol,
            GET_PATH(JSON, 'data[0]:membership.status')::string AS estat_membre,
            GET_PATH(JSON, 'data[0]:object.name')::string AS titol_recurs,
            GET_PATH(JSON, 'data[0]:object.id')::string AS enllac,
            GET_PATH(JSON, 'data[0]:object.mediatype')::string AS object_mediatype,
            GET_PATH(JSON, 'data[0]:object.type')::string AS tipus_recurs,
            GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".format')::string AS format_recurs,
            UPPER(GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".source')::string) AS Origen_events,
            GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".url')::string AS enllac_url
        FROM DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY le
        WHERE GET_PATH(JSON, 'data[0]:object.extensions."edu.uoc.ralti".materialid')::string IS NOT NULL
        AND GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".subjectCode')::string IS NOT NULL
        AND GET_PATH(JSON, 'data[0]:extensions."edu.uoc.ralti".semester')::string IS NOT NULL
    ) , 

    auto_refresh_registration_history as (
        
    SELECT DISTINCT
        LEFT(DIM_ASSIGNATURA_KEY, 6) AS DIM_ASSIGNATURA_KEY,
        TRY_CAST(DIM_SEMESTRE_KEY AS INT) AS DIM_SEMESTRE_KEY,
        TRY_CAST(CODI_RECURS AS INT) AS CODI_RECURS,
        Origen_events,
        EVENT_TIME,
        EVENT_DATE,
        ACCIO,
        NOM_ACTOR,
        ACTOR_TIPUS,
        usuari_dAcces,
        id_idp_usuari_events,
        titol_assignatura,
        id_curs_canvas,
        id_sistema_curs,
        ROL,
        estat_membre,
        titol_recurs,
        enllac,
        OBJECT_MEDIATYPE,
        tipus_recurs,
        format_recurs,
        enllac_url,
        CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ),
        CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    FROM aux_cte_table
    WHERE DIM_ASSIGNATURA_KEY IS NOT NULL
        AND DIM_SEMESTRE_KEY IS NOT NULL
        AND CODI_RECURS IS NOT NULL
    ) 

    select * from auto_refresh_registration_history -- 13,551,516
WHERE event_time is not null and id_idp_usuari_events is not null -- 13,547,110
