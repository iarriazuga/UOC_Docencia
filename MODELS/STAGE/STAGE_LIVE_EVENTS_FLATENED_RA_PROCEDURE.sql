
-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_LIVE_EVENTS_FLATENED_RA
-- -- #################################################################################################
-- -- #################################################################################################
 
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA (
 
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38, 0) COMMENT 'Clau semestre.',
    -- DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(16) COMMENT 'Clau recursos d aprenentatge.', -- Inclòs segons indicació
    CODI_RECURS INT COMMENT 'Codi del recurs acadèmic.',
    Origen_events VARCHAR(6) COMMENT 'Origen dels esdeveniments.',
    EVENT_TIME DATETIME COMMENT 'Hora de l esdeveniment.',
    EVENT_DATE DATE COMMENT 'Data de l esdeveniment.',
    ACCIO VARCHAR(16777216) COMMENT 'Acció realitzada durant l esdeveniment.',
    NOM_ACTOR VARCHAR(16777216) COMMENT 'Nom de l actor involucrat.',
    ACTOR_TIPUS VARCHAR(16777216) COMMENT 'Tipus d actor involucrat.',
    usuari_dAcces VARCHAR(16777216) COMMENT 'Usuari d accés.',
    id_idp_usuari_events VARCHAR(16777216) COMMENT 'Identificador de l usuari en els esdeveniments.',
    titol_assignatura VARCHAR(16777216) COMMENT 'Títol de la assignatura associada.',
    id_curs_canvas VARCHAR(16777216) COMMENT 'Identificador del curs a Canvas.',
    id_sistema_curs VARCHAR(16777216) COMMENT 'Identificador del sistema de curs.',
    ROL VARCHAR(16777216) COMMENT 'Rol de l usuari.',
    estat_membre VARCHAR(16777216) COMMENT 'Estat del membre.',
    titol_recurs VARCHAR(16777216) COMMENT 'Títol del recurs associat.',
    enllac VARCHAR(16777216) COMMENT 'Enllaç al recurs.',
    OBJECT_MEDIATYPE VARCHAR(16777216) COMMENT 'Tipus de mitjà de l objecte.',
    tipus_recurs VARCHAR(16777216) COMMENT 'Tipus de recurs.',
    format_recurs VARCHAR(16777216) COMMENT 'Format del recurs.',
    enllac_url VARCHAR(16777216) COMMENT 'URL de l enllaç associat.',
    creation_date TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creació del registre de la informació.',
    update_date TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de càrrega de la informació.'
);



CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA_LOADS(input_date DATE)
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
    LET execution_time FLOAT;

    -- INSERT: Volcat de registres
    TRUNCATE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA;

    INSERT INTO DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA  (
        DIM_ASSIGNATURA_KEY,
        DIM_SEMESTRE_KEY,
        CODI_RECURS,
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
        creation_date,
        update_date
    )
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
    )
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
        AND EVENT_DATE >= :input_date
    
    ;


    -- LOGS
    EXECUTION_TIME := DATEDIFF(MILLISECOND, START_TIME, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO DB_UOC_PROD.DD_OD.PROCEDURES_LOG (
        ID_LOG, PROCEDURE_NAME, EXECUTED_BY, EXECUTION_DATE, EXECUTION_TIME, REMARKS
    )
    VALUES (
        DB_UOC_PROD.DD_OD.SEQUENCIA_ID_LOG.NEXTVAL, 
        'DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA', 
        CURRENT_USER(), 
        :START_TIME, 
        :EXECUTION_TIME, 
        'DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA Success'
    );

    RETURN 'Update completed successfully';
END;

 

-- Procedure Execution
CALL DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA_LOADS(DATEADD(DAY, -1, CURRENT_DATE()));


-- CALL DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA_LOADS('1970-01-01');











