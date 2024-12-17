-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_RECURSOS_APRENENTATGE_EVENTS
-- -- #################################################################################################
-- -- #################################################################################################

-- select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS limit 100;
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS (
    
    ID_ASSIGNATURA NUMBER(16,0),
    ID_SEMESTRE NUMBER(16,0),
    ID_CODI_RECURS NUMBER(38,0),
    ID_PERSONA NUMBER(16,0),
    
    DIM_PERSONA_KEY NUMBER(10,0),
    DIM_ASSIGNATURA_KEY VARCHAR(6),
    DIM_SEMESTRE_KEY NUMBER(38,0),
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15),

    ORIGEN_DADES_ACADEMIQUES VARCHAR(5),
    CODI_RECURS NUMBER(38,0),
    EVENT_CODI_RECURS NUMBER(38,0),
    EVENT_TIME VARCHAR(16777216),
    EVENT_DATE VARCHAR(16777216),
    ACCIO VARCHAR(16777216),
    NOM_ACTOR VARCHAR(16777216),
    ACTOR_TIPUS VARCHAR(16777216),
    USUARI_DACCES VARCHAR(16777216),
    ID_SISTEMA_USUARI VARCHAR(16777216),
    TITOL_ASSIGNATURA VARCHAR(16777216),
    ID_CURS_CANVAS VARCHAR(16777216),
    ID_SISTEMA_CURS VARCHAR(16777216),
    ROL VARCHAR(16777216),
    ESTAT_MEMBRE VARCHAR(16777216),
    TITOL_RECURS VARCHAR(16777216),
    ENLLAC VARCHAR(16777216),
    OBJECT_MEDIATYPE VARCHAR(16777216),
    TIPUS_RECURS VARCHAR(16777216),
    FORMAT_RECURS VARCHAR(16777216),
    ORIGEN_EVENTS VARCHAR(6),
    ENLLAC_URL VARCHAR(16777216),

    usos_recurs_estudiants NUMBER(38, 0),
    usos_recurs_totals NUMBER(38, 0),
    assignatura_vigent_semester VARCHAR(10) COMMENT 'Vigencia de la assignatura en el semestre analitzat.',
    
    CREATION_DATE TIMESTAMP_NTZ(9)   COMMENT 'Data de creació del registre de la informació.',
    UPDATE_DATE TIMESTAMP_NTZ(9)  COMMENT 'Data de càrrega de la informació.'
);

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_LOADS() 
RETURNS VARCHAR(16777216) 
LANGUAGE SQL 
EXECUTE AS CALLER AS 
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ); 
    LET execution_time FLOAT;

    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS AS target
        USING (
            SELECT 
                asignatura.id_assignatura,
                semestre.id_semestre,
                recursos.id_codi_recurs,
                dim_persona.id_persona,

                aux_temporary_table.DIM_PERSONA_KEY,
                aux_temporary_table.DIM_ASSIGNATURA_KEY,
                aux_temporary_table.DIM_SEMESTRE_KEY,
                aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY,
                
                aux_temporary_table.ORIGEN_DADES_ACADEMIQUES,
                aux_temporary_table.CODI_RECURS,
                aux_temporary_table.CODI_RECURS AS EVENT_CODI_RECURS,
                aux_temporary_table.EVENT_TIME,
                aux_temporary_table.EVENT_DATE,
                aux_temporary_table.ACCIO,
                aux_temporary_table.NOM_ACTOR,
                aux_temporary_table.ACTOR_TIPUS,
                aux_temporary_table.usuari_dAcces,
                aux_temporary_table.id_sistema_usuari,
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
                aux_temporary_table.assignatura_vigent_semester,

                CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS CREATION_DATE,
                CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS UPDATE_DATE

            FROM (
                SELECT 
                    dades_academiques.DIM_PERSONA_KEY,
                    dades_academiques.DIM_ASSIGNATURA_KEY,
                    dades_academiques.DIM_SEMESTRE_KEY,
                    dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY,
                    dades_academiques.ORIGEN_DADES_ACADEMIQUES,
                    dades_academiques.CODI_RECURS,
                    events.CODI_RECURS AS EVENT_CODI_RECURS,
                    events.EVENT_TIME,
                    events.EVENT_DATE,
                    events.ACCIO,
                    events.NOM_ACTOR,
                    events.ACTOR_TIPUS,
                    events.usuari_dAcces,
                    events.id_sistema_usuari,
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

                FROM DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques
                LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events
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
        AND target.NOM_ACTOR = source.NOM_ACTOR,
        
        WHEN MATCHED THEN
            UPDATE SET 
                target.EVENT_TIME = source.EVENT_TIME,
                target.EVENT_DATE = source.EVENT_DATE,
                target.ACCIO = source.ACCIO,
                target.UPDATE_DATE = source.UPDATE_DATE

        WHEN NOT MATCHED THEN
            INSERT (
                ID_ASSIGNATURA, ID_SEMESTRE, ID_CODI_RECURS, ID_PERSONA,
                DIM_PERSONA_KEY, DIM_ASSIGNATURA_KEY, DIM_SEMESTRE_KEY, DIM_RECURSOS_APRENENTATGE_KEY,
                ORIGEN_DADES_ACADEMIQUES, CODI_RECURS, EVENT_CODI_RECURS, EVENT_TIME, EVENT_DATE,
                ACCIO, NOM_ACTOR, ACTOR_TIPUS, USUARI_DACCES, ID_SISTEMA_USUARI,
                TITOL_ASSIGNATURA, ID_CURS_CANVAS, ID_SISTEMA_CURS, ROL, ESTAT_MEMBRE,
                TITOL_RECURS, ENLLAC, OBJECT_MEDIATYPE, TIPUS_RECURS, FORMAT_RECURS, ORIGEN_EVENTS,
                ENLLAC_URL, usos_recurs_estudiants, usos_recurs_totals, assignatura_vigent_semester,
                CREATION_DATE, UPDATE_DATE
            )
            VALUES (
                source.id_assignatura, source.id_semestre, source.id_codi_recurs, source.id_persona,
                source.DIM_PERSONA_KEY, source.DIM_ASSIGNATURA_KEY, source.DIM_SEMESTRE_KEY, source.DIM_RECURSOS_APRENENTATGE_KEY,
                source.ORIGEN_DADES_ACADEMIQUES, source.CODI_RECURS, source.EVENT_CODI_RECURS, source.EVENT_TIME, source.EVENT_DATE,
                source.ACCIO, source.NOM_ACTOR, source.ACTOR_TIPUS, source.usuari_dAcces, source.id_sistema_usuari,
                source.titol_assignatura, source.id_curs_canvas, source.id_sistema_curs, source.ROL, source.estat_membre,
                source.titol_recurs, source.enllac, source.OBJECT_MEDIATYPE, source.tipus_recurs, source.format_recurs, source.Origen_events,
                source.enllac_url, source.usos_recurs_estudiants, source.usos_recurs_totals, source.assignatura_vigent_semester,
                source.CREATION_DATE, source.UPDATE_DATE
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



 