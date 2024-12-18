-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_RA_EVENTS_SIMPLIFIED 
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG (

    ID_ASSIGNATURA NUMBER(38, 0) COMMENT 'Identificador de la assignatura.',
    ID_SEMESTRE NUMBER(38, 0) COMMENT 'Identificador del semestre.',
    ID_CODI_RECURS NUMBER(38, 0) COMMENT 'Identificador del recurs.',

    ID_PERSONA NUMBER(38, 0) COMMENT 'Identificador del persona.',

    DIM_PERSONA_KEY NUMBER(10,0) COMMENT 'Clau DIM_PERSONA_KEY.',
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38, 0) COMMENT 'Clau semestre.',
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(16) COMMENT 'Clau recursos d\'aprenentatge.',

    ORIGEN_DADES_ACADEMIQUES VARCHAR(5) COMMENT 'Font de las dades académiques.', 
    assignatura_vigent_semester VARCHAR(10) COMMENT 'Vigencia de la assignatura en el semestre analitzat.', 

    usos_unics_recurs NUMBER(38, 0),
    usos_recurs_estudiants NUMBER(38, 0),
    usos_recurs_totals NUMBER(38, 0),


    CREATION_DATE TIMESTAMP_NTZ(9)  ,
    UPDATE_DATE TIMESTAMP_NTZ(9)  
)
;
 

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG_LOADS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
    -- Declaració de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
    LET execution_time FLOAT;

    -- INSERT: Volcat de registres
    TRUNCATE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG ;

    INSERT INTO DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG (
        --dims_ids:
        id_assignatura
        , id_semestre
        , id_codi_recurs
        , id_persona
        --dims_keys:
        , DIM_PERSONA_KEY
        , DIM_ASSIGNATURA_KEY
        , DIM_SEMESTRE_KEY
        , DIM_RECURSOS_APRENENTATGE_KEY
        
        , ORIGEN_DADES_ACADEMIQUES
        , assignatura_vigent_semester
        
        , usos_unics_recurs
        , usos_recurs_estudiants
        , usos_recurs_totals


        , CREATION_DATE
        , UPDATE_DATE
    )
    SELECT 
        dades_academiques.id_assignatura
        , dades_academiques.id_semestre
        , dades_academiques.id_codi_recurs
        , dades_academiques.id_persona
        , dades_academiques.DIM_PERSONA_KEY
        , dades_academiques.DIM_ASSIGNATURA_KEY
        , dades_academiques.DIM_SEMESTRE_KEY
        , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
        , dades_academiques.ORIGEN_DADES_ACADEMIQUES
        , dades_academiques.assignatura_vigent_semester
        
        , count( distinct dades_academiques.id_idp_usuari_events) AS usos_unics_recurs 
        , SUM(dades_academiques.usos_recurs_estudiants) AS usos_recurs_estudiants 
        , SUM(dades_academiques.usos_recurs_totals) AS usos_recurs_totals

        , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
        , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    FROM 
        DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS dades_academiques
    GROUP BY 
        dades_academiques.id_assignatura,
        dades_academiques.id_semestre,
        dades_academiques.id_codi_recurs,
        dades_academiques.id_persona,
        dades_academiques.DIM_PERSONA_KEY,
        dades_academiques.DIM_ASSIGNATURA_KEY,
        dades_academiques.DIM_SEMESTRE_KEY,
        dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY,
        dades_academiques.ORIGEN_DADES_ACADEMIQUES,
        dades_academiques.assignatura_vigent_semester
    
    ;

    -- LOGS
    execution_time := DATEDIFF(MILLISECOND, start_time, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO db_uoc_prod.dd_od.procedures_log (
        id_log, procedure_name, executed_by, execution_date, execution_time, remarks
    )
    VALUES (
        db_uoc_prod.dd_od.sequencia_id_log.NEXTVAL, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG',
        CURRENT_USER(), :start_time, :execution_time, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG Success'
    );

    RETURN 'Update completed successfully';
END;

-- Consultes addicionals
CALL DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG_LOADS();
