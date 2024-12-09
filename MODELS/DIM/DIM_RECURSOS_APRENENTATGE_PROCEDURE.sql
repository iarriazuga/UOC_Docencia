
-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################
 
 

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE (
    ID_CODI_RECURS  INT AUTOINCREMENT PRIMARY KEY,
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(16777216),
    CODI_RECURS NUMBER(25,5),
    TITOL_RECURS VARCHAR(4000),
    ORIGEN_RECURS VARCHAR(256),
    TIPUS_RECURS VARCHAR(256),
    ORIGEN_BASE_DADES VARCHAR(9),
    LLICENCIA_LPC VARCHAR(4),
    LLICENCIA_LGC VARCHAR(4),
    LLICENCIA_ALTRES VARCHAR(4),
    LLICENCIA_BIBLIOTECA VARCHAR(4),
    BAIXA VARCHAR(4),
    DESCRIPCIO_IDIOMA_RECURS VARCHAR(2295),
    FORMAT_RECURS VARCHAR(255),
    DATA_INICI_RECURS TIMESTAMP_NTZ(9),
    DATA_CADUCITAT_RECURS TIMESTAMP_NTZ(9),
    CERCABLE_RECURS VARCHAR(4),
    INDICADOR_PUBLIC_RECURS VARCHAR(4),
    PUBLICAT_A_RECURS VARCHAR(4000),
    ISBN_ISSN_RECURS VARCHAR(256),
    PAGINA_INICI_RECURS NUMBER(20,0),
    PAGINA_FINAL_RECURS NUMBER(20,0),
    BASE_DADES_RECURS VARCHAR(4000),
    ELLIBRE_RECURS VARCHAR(4000),
    URL_CAT_RECURS VARCHAR(4000),
    URL_CAS_RECURS VARCHAR(4000),
    URL_ANG_RECURS VARCHAR(4000),
    TIPUS_GESTIO_RECURS VARCHAR(5),
    DESPESA_VARIABLE_RECURS VARCHAR(4),
    UPDATE_DATE TIMESTAMP_NTZ(9),
    CREATION_DATE TIMESTAMP_NTZ(9),
    PRODUCTE_CREACIO_ID NUMBER(18,5),
    DESCRIPCIO_TRAMESA_RECURS VARCHAR(255),
    NUM_CONTRACTE VARCHAR(50),
    OBSERVACIONS VARCHAR(2000),
    MODUL_ORIGEN_ID VARCHAR(255),
    VERSIO_CREACIO_ID NUMBER(12,0),
    OBRA_ID VARCHAR(12),
    CODI_MIGRACIO VARCHAR(255),
    URL_RECURS_PROPI VARCHAR(500)
);

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_LOADS() 
RETURNS VARCHAR(16777216) 
LANGUAGE SQL 
EXECUTE AS CALLER AS 
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ); 
    LET execution_time FLOAT;

    -- INSERT: Volcat de registres
    TRUNCATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE;
    INSERT INTO DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE (
 
        DIM_RECURSOS_APRENENTATGE_KEY,
        CODI_RECURS,
        TITOL_RECURS,
        ORIGEN_RECURS,
        TIPUS_RECURS,
        origen_base_dades,
        LLICENCIA_LPC,
        LLICENCIA_LGC,
        LLICENCIA_ALTRES,
        LLICENCIA_BIBLIOTECA,
        BAIXA,
        DESCRIPCIO_IDIOMA_RECURS,
        FORMAT_RECURS,
        DATA_INICI_RECURS,
        DATA_CADUCITAT_RECURS,
        CERCABLE_RECURS,
        INDICADOR_PUBLIC_RECURS,
        PUBLICAT_A_RECURS,
        ISBN_ISSN_RECURS,
        PAGINA_INICI_RECURS,
        PAGINA_FINAL_RECURS,
        BASE_DADES_RECURS,
        ELLIBRE_RECURS,
        URL_CAT_RECURS,
        URL_CAS_RECURS,
        URL_ANG_RECURS,
        TIPUS_GESTIO_RECURS,
        DESPESA_VARIABLE_RECURS,
        UPDATE_DATE,
        CREATION_DATE,
        PRODUCTE_CREACIO_ID,
        DESCRIPCIO_TRAMESA_RECURS,
        NUM_CONTRACTE,
        OBSERVACIONS,
        MODUL_ORIGEN_ID,
        VERSIO_CREACIO_ID,
        OBRA_ID,
        CODI_MIGRACIO,
        URL_RECURS_PROPI
    )
    WITH dim_coco_productes_moduls AS (
        SELECT
            'COCO' || ' - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
            CODI_RECURS,
            TITOL_RECURS,
            ORIGEN_RECURS,
            '' AS TIPUS_RECURS,
            origen_base_dades,
            '' AS LLICENCIA_LPC,
            '' AS LLICENCIA_LGC,
            '' AS LLICENCIA_ALTRES,
            '' AS LLICENCIA_BIBLIOTECA,
            BAIXA,
            descripcio_idioma_recurs,
            DESCRIPCIO_SUPORT_RECURS AS FORMAT_RECURS,
            NULL AS DATA_INICI_RECURS,
            NULL AS DATA_CADUCITAT_RECURS,
            '' AS CERCABLE_RECURS,
            '' AS INDICADOR_PUBLIC_RECURS,
            '' AS PUBLICAT_A_RECURS,
            '' AS ISBN_ISSN_RECURS,
            0 AS PAGINA_INICI_RECURS,
            0 AS PAGINA_FINAL_RECURS,
            '' AS BASE_DADES_RECURS,
            '' AS ELLIBRE_RECURS,
            '' AS URL_CAT_RECURS,
            '' AS URL_CAS_RECURS,
            '' AS URL_ANG_RECURS,
            'ND' AS TIPUS_GESTIO_RECURS,
            '' AS DESPESA_VARIABLE_RECURS,
            NULL AS UPDATE_DATE,
            DATA_TANCAMENT_REAL AS CREATION_DATE,
            PRODUCTE_CREACIO_ID,
            DESCRIPCIO_TRAMESA_RECURS,
            NUM_CONTRACTE,
            OBSERVACIONS,
            MODUL_ORIGEN_ID,
            VERSIO_CREACIO_ID,
            OBRA_ID,
            CODI_MIGRACIO,
            URL_IDIOMA_RECURS AS URL_RECURS_PROPI
        FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
    ),
    dimax AS (
        SELECT
 
            'DIMAX' || ' - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
            CODI_RECURS,
            TITOL_RECURS,
            ORIGEN_RECURS,
            TIPUS_RECURS,
            'DIMAX' AS origen_base_dades,
            LLICENCIA_LPC,
            LLICENCIA_LGC,
            LLICENCIA_ALTRES,
            LLICENCIA_BIBLIOTECA,
            WAIT_RECURS AS BAIXA,
            dimax.idioma_recurs AS DESCRIPCIO_IDIOMA_RECURS,
            FORMAT_RECURS,
            DATA_INICI_RECURS,
            DATA_CADUCITAT_RECURS,
            CERCABLE_RECURS,
            INDICADOR_PUBLIC_RECURS,
            PUBLICAT_A_RECURS,
            ISBN_ISSN_RECURS,
            PAGINA_INICI_RECURS,
            PAGINA_FINAL_RECURS,
            BASE_DADES_RECURS,
            ELLIBRE_RECURS,
            URL_CAT_RECURS,
            URL_CAS_RECURS,
            URL_ANG_RECURS,
            IFF(
                LLICENCIA_LPC = 'S', 'DRETS',
                IFF(
                    LLICENCIA_LGC = 'S', 'DRETS',
                    IFF(
                        LLICENCIA_ALTRES = 'S', 'DRETS',
                        IFF(LLICENCIA_BIBLIOTECA = 'S', 'SUBS', '')
                    )
                )
            ) AS TIPUS_GESTIO_RECURS,
            DESPESA_VARIABLE_RECURS,
            CREATION_DATE,
            UPDATE_DATE,
            NULL AS PRODUCTE_CREACIO_ID,
            NULL AS DESCRIPCIO_TRAMESA_RECURS,
            '' AS NUM_CONTRACTE,
            '' AS OBSERVACIONS,
            '' AS MODUL_ORIGEN_ID,
            0 AS VERSIO_CREACIO_ID,
            '' AS OBRA_ID,
            '' AS CODI_MIGRACIO,
            '' AS URL_RECURS_PROPI
        FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_DIMAX dimax
    )
    SELECT * FROM dim_coco_productes_moduls
    UNION ALL
    SELECT * FROM dimax;


    -- LOGS
    EXECUTION_TIME := DATEDIFF(MILLISECOND, START_TIME, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO DB_UOC_PROD.DD_OD.PROCEDURES_LOG (
        ID_LOG, PROCEDURE_NAME, EXECUTED_BY, EXECUTION_DATE, EXECUTION_TIME, REMARKS
    )
    VALUES (
        DB_UOC_PROD.DD_OD.SEQUENCIA_ID_LOG.NEXTVAL, 
        'DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE', 
        CURRENT_USER(), 
        :START_TIME, 
        :EXECUTION_TIME, 
        'DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE Success'
    );

    RETURN 'Update completed successfully';
END;

 

-- Procedure Execution
CALL DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_LOADS();




 