-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_RECURSOS_APRENENTATGE_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS (
    
    ID_ASSIGNATURA NUMBER(16,0) COMMENT 'Identificador de la assignatura.',
    ID_SEMESTRE NUMBER(16,0) COMMENT 'Identificador del semestre.',
    ID_CODI_RECURS NUMBER(38,0) COMMENT 'Identificador del recurs.',
    ID_PERSONA NUMBER(16,0) COMMENT 'Identificador de la persona.',
    
    DIM_PERSONA_KEY NUMBER(10,0) COMMENT 'Clau DIM_PERSONA_KEY.',
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38,0) COMMENT 'Clau semestre.',
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(16) COMMENT 'Clau recursos d aprenentatge.',

    ORIGEN_DADES_ACADEMIQUES VARCHAR(5) COMMENT 'Font de les dades acadèmiques.',
    CODI_RECURS NUMBER(38,0) COMMENT 'Codi del recurs associat.',
    EVENT_CODI_RECURS NUMBER(38,0) COMMENT 'Codi de l esdeveniment associat al recurs.',
    EVENT_TIME VARCHAR(16777216) COMMENT 'Hora de l esdeveniment.',
    EVENT_DATE VARCHAR(16777216) COMMENT 'Data de l esdeveniment.',
    ACCIO VARCHAR(16777216) COMMENT 'Acció realitzada durant l esdeveniment.',
    NOM_ACTOR VARCHAR(16777216) COMMENT 'Nom de l actor involucrat.',
    ACTOR_TIPUS VARCHAR(16777216) COMMENT 'Tipus d actor involucrat.',
    USUARI_DACCES VARCHAR(16777216) COMMENT 'Usuari d accés.',
    id_idp_usuari_events VARCHAR(16777216) COMMENT 'Identificador de l usuari en els esdeveniments.',
    TITOL_ASSIGNATURA VARCHAR(16777216) COMMENT 'Títol de la assignatura associada.',
    ID_CURS_CANVAS VARCHAR(16777216) COMMENT 'Identificador del curs a Canvas.',
    ID_SISTEMA_CURS VARCHAR(16777216) COMMENT 'Identificador del sistema de curs.',
    ROL VARCHAR(16777216) COMMENT 'Rol de l usuari.',
    ESTAT_MEMBRE VARCHAR(16777216) COMMENT 'Estat del membre.',
    TITOL_RECURS VARCHAR(16777216) COMMENT 'Títol del recurs associat.',
    ENLLAC VARCHAR(16777216) COMMENT 'Enllaç al recurs.',
    OBJECT_MEDIATYPE VARCHAR(16777216) COMMENT 'Tipus de mitjà de l objecte.',
    TIPUS_RECURS VARCHAR(16777216) COMMENT 'Tipus de recurs.',
    FORMAT_RECURS VARCHAR(16777216) COMMENT 'Format del recurs.',
    ORIGEN_EVENTS VARCHAR(6) COMMENT 'Origen dels esdeveniments.',
    ENLLAC_URL VARCHAR(16777216) COMMENT 'URL de l enllaç associat.',

    usos_recurs_estudiants NUMBER(38, 0) COMMENT 'Nombre d usos del recurs pels estudiants.',
    usos_recurs_totals NUMBER(38, 0) COMMENT 'Nombre total d usos del recurs.',
    assignatura_vigent_semester VARCHAR(10) COMMENT 'Vigència de la assignatura en el semestre analitzat.',
    
    CREATION_DATE TIMESTAMP_NTZ(9) COMMENT 'Data de creació del registre de la informació.',
    UPDATE_DATE TIMESTAMP_NTZ(9) COMMENT 'Data de càrrega de la informació.'
);


CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_LOADS() 
RETURNS VARCHAR(16777216) 
LANGUAGE SQL 
EXECUTE AS CALLER AS 
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ); 
    LET execution_time FLOAT;

    --merge inicial 
    -- truncate table DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;
    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS AS target
        USING (
            SELECT 
                coalesce(asignatura.id_assignatura, 0) as id_assignatura,
                coalesce(semestre.id_semestre, 0) as id_semestre,
                coalesce(recursos.id_codi_recurs, 1) as id_codi_recurs,
                coalesce(dim_persona.id_persona, 0 ) as id_persona,
 
                aux_temporary_table.DIM_PERSONA_KEY,
                aux_temporary_table.DIM_ASSIGNATURA_KEY,
                aux_temporary_table.DIM_SEMESTRE_KEY,
                aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY,
                
                aux_temporary_table.ORIGEN_DADES_ACADEMIQUES,
                aux_temporary_table.CODI_RECURS,
                aux_temporary_table.EVENT_CODI_RECURS,
                aux_temporary_table.EVENT_TIME,
                aux_temporary_table.EVENT_DATE,
                aux_temporary_table.ACCIO,
                aux_temporary_table.NOM_ACTOR,
                aux_temporary_table.ACTOR_TIPUS,
                aux_temporary_table.usuari_dAcces,
                aux_temporary_table.id_idp_usuari_events,
                aux_temporary_table.titol_assignatura,
                aux_temporary_table.id_curs_canvas,
                aux_temporary_table.id_sistema_curs,
                aux_temporary_table.ROL,
                aux_temporary_table.estat_membre,
                aux_temporary_table.titol_recurs,
                aux_temporary_table.enllac,
                aux_temporary_table.OBJECT_MEDIATYPE,
                aux_temporary_table.tipus_recurs,
                aux_temporary_table.format_recurs,
                aux_temporary_table.Origen_events,
                aux_temporary_table.enllac_url,

                CASE WHEN aux_temporary_table.ROL LIKE '["Learner"]' THEN 1 ELSE 0 END AS usos_recurs_estudiants,
                CASE WHEN aux_temporary_table.ROL IS NULL THEN 0 ELSE 1 END AS usos_recurs_totals,
                aux_temporary_table.assignatura_vigent_semester 

            FROM (
                SELECT 
                    --- keys for fact 
                    coalesce(dades_academiques.DIM_PERSONA_KEY , 0) as dim_persona_key,
                    coalesce( dades_academiques.DIM_ASSIGNATURA_KEY , '0') as DIM_ASSIGNATURA_KEY,
                    coalesce(dades_academiques.DIM_SEMESTRE_KEY , 0) as DIM_SEMESTRE_KEY,
                    coalesce(dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY , '0') as DIM_RECURSOS_APRENENTATGE_KEY,
                    COALESCE(dades_academiques.CODI_RECURS, '0') as CODI_RECURS,
                    COALESCE(events.EVENT_TIME, '1970-01-01') as EVENT_TIME,
                    coalesce(events.id_idp_usuari_events, '0') as id_idp_usuari_events,
                    
                    
 
                    dades_academiques.ORIGEN_DADES_ACADEMIQUES,
                    
                    events.EVENT_DATE, 
                    events.CODI_RECURS AS EVENT_CODI_RECURS,
                    events.ACCIO,
                    events.NOM_ACTOR,
                    events.ACTOR_TIPUS,
                    events.usuari_dAcces,
      
                    events.titol_assignatura,
                    events.id_curs_canvas,
                    events.id_sistema_curs,
                    events.ROL,
                    events.estat_membre,
                    events.titol_recurs,
                    events.enllac,
                    events.OBJECT_MEDIATYPE,
                    events.tipus_recurs,
                    events.format_recurs,
                    events.Origen_events,
                    events.enllac_url, 
                    dades_academiques.assignatura_vigent_semester 
                     

                FROM DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques -- 5,103,788

                LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events  --- 16,556,218
                    ON dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY
                    AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
                    AND dades_academiques.CODI_RECURS = events.CODI_RECURS

            ) aux_temporary_table

            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA asignatura 
                ON asignatura.DIM_ASSIGNATURA_KEY = aux_temporary_table.DIM_ASSIGNATURA_KEY
            
            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_SEMESTRE semestre 
                ON semestre.DIM_SEMESTRE_KEY = aux_temporary_table.DIM_SEMESTRE_KEY
            
            LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE recursos 
                ON recursos.DIM_RECURSOS_APRENENTATGE_KEY = aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY

            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona 
                ON dim_persona.DIM_PERSONA_KEY = aux_temporary_table.DIM_PERSONA_KEY

        ) AS source
            ON target.DIM_PERSONA_KEY = source.DIM_PERSONA_KEY
            AND target.DIM_ASSIGNATURA_KEY = source.DIM_ASSIGNATURA_KEY
            AND target.DIM_SEMESTRE_KEY = source.DIM_SEMESTRE_KEY
            AND target.DIM_RECURSOS_APRENENTATGE_KEY = source.DIM_RECURSOS_APRENENTATGE_KEY
            AND target.EVENT_TIME = source.EVENT_TIME 
            AND target.id_idp_usuari_events= source.id_idp_usuari_events
            AND target.CODI_RECURS = source.CODI_RECURS
                        
        WHEN MATCHED THEN
            UPDATE SET 
            target.ORIGEN_DADES_ACADEMIQUES = source.ORIGEN_DADES_ACADEMIQUES
            , target.EVENT_CODI_RECURS = source.EVENT_CODI_RECURS
            , target.EVENT_DATE = source.EVENT_DATE
            , target.ACCIO = source.ACCIO
            , target.NOM_ACTOR = source.NOM_ACTOR
            , target.ACTOR_TIPUS = source.ACTOR_TIPUS
            , target.usuari_dAcces = source.usuari_dAcces
            , target.titol_assignatura = source.titol_assignatura
            , target.id_curs_canvas = source.id_curs_canvas
            , target.id_sistema_curs = source.id_sistema_curs
            , target.ROL = source.ROL
            , target.estat_membre = source.estat_membre
            , target.titol_recurs = source.titol_recurs
            , target.enllac = source.enllac
            , target.OBJECT_MEDIATYPE = source.OBJECT_MEDIATYPE
            , target.tipus_recurs = source.tipus_recurs
            , target.format_recurs = source.format_recurs
            , target.Origen_events = source.Origen_events
            , target.enllac_url = source.enllac_url
            , target.assignatura_vigent_semester = source.assignatura_vigent_semester
            , target.UPDATE_DATE = CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)

        WHEN NOT MATCHED THEN
            INSERT (
                ID_ASSIGNATURA
                , ID_SEMESTRE
                , ID_CODI_RECURS
                , ID_PERSONA
                , DIM_PERSONA_KEY
                , DIM_ASSIGNATURA_KEY
                , DIM_SEMESTRE_KEY
                , DIM_RECURSOS_APRENENTATGE_KEY
                , ORIGEN_DADES_ACADEMIQUES
                , CODI_RECURS
                , EVENT_CODI_RECURS
                , EVENT_TIME
                , EVENT_DATE
                , ACCIO
                , NOM_ACTOR
                , ACTOR_TIPUS
                , USUARI_DACCES
                , id_idp_usuari_events
                , TITOL_ASSIGNATURA
                , ID_CURS_CANVAS
                , ID_SISTEMA_CURS
                , ROL
                , ESTAT_MEMBRE
                , TITOL_RECURS
                , ENLLAC
                , OBJECT_MEDIATYPE
                , TIPUS_RECURS
                , FORMAT_RECURS
                , ORIGEN_EVENTS
                , ENLLAC_URL
                , usos_recurs_estudiants
                , usos_recurs_totals
                , assignatura_vigent_semester
                , CREATION_DATE
                , UPDATE_DATE
            )
            VALUES (
                source.id_assignatura
                , source.id_semestre
                , source.id_codi_recurs
                , source.id_persona
                , source.DIM_PERSONA_KEY
                , source.DIM_ASSIGNATURA_KEY
                , source.DIM_SEMESTRE_KEY
                , source.DIM_RECURSOS_APRENENTATGE_KEY
                , source.ORIGEN_DADES_ACADEMIQUES
                , source.CODI_RECURS
                , source.EVENT_CODI_RECURS
                , source.EVENT_TIME
                , source.EVENT_DATE
                , source.ACCIO
                , source.NOM_ACTOR
                , source.ACTOR_TIPUS
                , source.usuari_dAcces
                , source.id_idp_usuari_events
                , source.titol_assignatura
                , source.id_curs_canvas
                , source.id_sistema_curs
                , source.ROL
                , source.estat_membre
                , source.titol_recurs
                , source.enllac
                , source.OBJECT_MEDIATYPE
                , source.tipus_recurs
                , source.format_recurs
                , source.Origen_events
                , source.enllac_url
                , source.usos_recurs_estudiants
                , source.usos_recurs_totals
                , source.assignatura_vigent_semester
                , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
                , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
            );



    -- LOGS
    EXECUTION_TIME := DATEDIFF(MILLISECOND, START_TIME, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO DB_UOC_PROD.DD_OD.PROCEDURES_LOG (
        ID_LOG, PROCEDURE_NAME, EXECUTED_BY, EXECUTION_DATE, EXECUTION_TIME, REMARKS
    )
    VALUES (
        DB_UOC_PROD.DD_OD.SEQUENCIA_ID_LOG.NEXTVAL, 
        'DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS', 
        CURRENT_USER(), 
        :START_TIME, 
        :EXECUTION_TIME, 
        'DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS Success'
    );

    RETURN 'Update completed successfully';
END;

 

-- Procedure Execution
CALL DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_LOADS();

 