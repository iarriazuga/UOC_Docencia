CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 (
    -- ID_DIM_D NUMBER(20, 0) IDENTITY(1, 1), -- Auto-increment without sequence
    ID_DIM_D INT AUTOINCREMENT PRIMARY KEY,
    ID_ASSIGNATURA NUMBER(38, 0),
    ID_SEMESTRE NUMBER(38, 0),
    ID_CODI_RECURS NUMBER(38, 0),
    ID_PERSONA NUMBER(38, 0),

    DIM_PERSONA_KEY NUMBER(10,0),
    DIM_ASSIGNATURA_KEY VARCHAR(6),
    DIM_SEMESTRE_KEY NUMBER(38, 0),
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15),
    SOURCE_DADES_ACADEMIQUES VARCHAR(5),
    TIMES_USED NUMBER(18, 0),
    CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL,
    UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL
)
;
 

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
    -- Declaració de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
    LET execution_time FLOAT;

    -- MERGE 1: Registre dummy
    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2
    USING (
        SELECT
            0 AS ID_ASSIGNATURA,
            0 AS ID_SEMESTRE,
            0 AS ID_CODI_RECURS,
            'ND' AS DIM_ASSIGNATURA_KEY,
            0 AS DIM_SEMESTRE_KEY,
            'ND' AS DIM_RECURSOS_APRENENTATGE_KEY,
            'ND' AS SOURCE_DADES_ACADEMIQUES,
            0 AS TIMES_USED,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS CREATION_DATE,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS UPDATE_DATE
    ) AS ALIAS_QUERY_IN
    ON (
        ALIAS_QUERY_IN.ID_ASSIGNATURA = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_ASSIGNATURA AND
        ALIAS_QUERY_IN.ID_SEMESTRE = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_SEMESTRE AND
        ALIAS_QUERY_IN.ID_CODI_RECURS = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_CODI_RECURS AND
        ALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND
        ALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND
        ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY
    )
    WHEN NOT MATCHED THEN
        INSERT (
            ID_ASSIGNATURA, ID_SEMESTRE, ID_CODI_RECURS, DIM_ASSIGNATURA_KEY, DIM_SEMESTRE_KEY,
            DIM_RECURSOS_APRENENTATGE_KEY, SOURCE_DADES_ACADEMIQUES, TIMES_USED, CREATION_DATE, UPDATE_DATE
        )
        VALUES (
            0, 0, 0, 'ND', 0, 'ND', 'ND', 0,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ),
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
        );

    -- MERGE 2: Volcat de registres
    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2
    USING (
        SELECT
            dades_academiques.ID_ASSIGNATURA,
            dades_academiques.ID_SEMESTRE,
            dades_academiques.ID_CODI_RECURS,
            dades_academiques.DIM_ASSIGNATURA_KEY,
            dades_academiques.DIM_SEMESTRE_KEY,
            dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY,
            dades_academiques.SOURCE_DADES_ACADEMIQUES,
            COUNT(dades_academiques.EVENT_CODI_RECURS) AS TIMES_USED
        FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
        GROUP BY 1, 2, 3, 4, 5, 6, 7
    ) AS ALIAS_QUERY_IN
    ON (
        ALIAS_QUERY_IN.ID_ASSIGNATURA = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_ASSIGNATURA AND
        ALIAS_QUERY_IN.ID_SEMESTRE = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_SEMESTRE AND
        ALIAS_QUERY_IN.ID_CODI_RECURS = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_CODI_RECURS AND
        ALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND
        ALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND
        ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY
    )
    WHEN MATCHED AND (
        ALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES <> DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.SOURCE_DADES_ACADEMIQUES OR
        ALIAS_QUERY_IN.TIMES_USED <> DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.TIMES_USED
    ) THEN
        UPDATE SET
            SOURCE_DADES_ACADEMIQUES = ALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES,
            TIMES_USED = ALIAS_QUERY_IN.TIMES_USED,
            UPDATE_DATE = CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    WHEN NOT MATCHED THEN
        INSERT (
            ID_ASSIGNATURA, ID_SEMESTRE, ID_CODI_RECURS, DIM_ASSIGNATURA_KEY, DIM_SEMESTRE_KEY,
            DIM_RECURSOS_APRENENTATGE_KEY, SOURCE_DADES_ACADEMIQUES, TIMES_USED, CREATION_DATE, UPDATE_DATE
        )
        VALUES (
            ALIAS_QUERY_IN.ID_ASSIGNATURA, ALIAS_QUERY_IN.ID_SEMESTRE, ALIAS_QUERY_IN.ID_CODI_RECURS,
            ALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY, ALIAS_QUERY_IN.DIM_SEMESTRE_KEY, ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY,
            ALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES, ALIAS_QUERY_IN.TIMES_USED,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ),
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
        );

    -- LOGS
    execution_time := DATEDIFF(MILLISECOND, start_time, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO db_uoc_prod.dd_od.procedures_log (
        id_log, procedure_name, executed_by, execution_date, execution_time, remarks
    )
    VALUES (
        db_uoc_prod.dd_od.sequencia_id_log.NEXTVAL, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2',
        CURRENT_USER(), :start_time, :execution_time, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 Success'
    );

    RETURN 'Update completed successfully';
END;

-- Consultes addicionals
SELECT MAX(update_date) FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;
SELECT COUNT(*) FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;
SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 LIMIT 10;

-- Truncar taula
TRUNCATE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;

-- Executar procediment
CALL DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS();
