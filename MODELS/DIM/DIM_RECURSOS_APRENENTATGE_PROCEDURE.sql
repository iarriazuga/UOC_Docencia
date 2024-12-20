
-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE (
    ID_CODI_RECURS INT AUTOINCREMENT PRIMARY KEY, -- identificador automàtic del recurs
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(16) COMMENT 'clau única del recurs',
    CODI_RECURS NUMBER(38,0) COMMENT 'codi identificador del recurs',
    TITOL_RECURS VARCHAR(4000) COMMENT 'títol del recurs',
    ORIGEN_RECURS VARCHAR(256) COMMENT 'origen del recurs',
    TIPUS_RECURS VARCHAR(256) COMMENT 'tipus de recurs',
    ORIGEN_BASE_DADES VARCHAR(9) COMMENT 'indicador de l orígen a la base de dades',
    LLICENCIA_LPC VARCHAR(4) COMMENT 'tipus de llicència LPC del recurs',
    LLICENCIA_LGC VARCHAR(4) COMMENT 'tipus de llicència LGC del recurs',
    LLICENCIA_ALTRES VARCHAR(4) COMMENT 'altres tipus de llicències',
    LLICENCIA_BIBLIOTECA VARCHAR(4) COMMENT 'indicador si és una llicència de biblioteca',
    BAIXA VARCHAR(4) COMMENT 'indicador si el recurs està donat de baixa',
    DESCRIPCIO_IDIOMA_RECURS VARCHAR(2295) COMMENT 'descripció en diferents idiomes',
    FORMAT_RECURS VARCHAR(255) COMMENT 'format del recurs',
    DATA_INICI_RECURS TIMESTAMP_NTZ(9) COMMENT 'data d inici del recurs',
    DATA_CADUCITAT_RECURS TIMESTAMP_NTZ(9) COMMENT 'data de caducitat del recurs',
    CERCABLE_RECURS VARCHAR(4) COMMENT 'indicador si el recurs és cercable',
    INDICADOR_PUBLIC_RECURS VARCHAR(4) COMMENT 'indicador si el recurs és públic',
    PUBLICAT_A_RECURS VARCHAR(4000) COMMENT 'ubicació on es publica el recurs',
    ISBN_ISSN_RECURS VARCHAR(256) COMMENT 'ISBN o ISSN del recurs',
    PAGINA_INICI_RECURS NUMBER(20,0) COMMENT 'pàgina d inici del recurs',
    PAGINA_FINAL_RECURS NUMBER(20,0) COMMENT 'pàgina final del recurs',
    BASE_DADES_RECURS VARCHAR(4000) COMMENT 'base de dades associada al recurs',
    ELLIBRE_RECURS VARCHAR(4000) COMMENT 'detalls de l ebook del recurs',
    URL_CAT_RECURS VARCHAR(4000) COMMENT 'URL en català del recurs',
    URL_CAS_RECURS VARCHAR(4000) COMMENT 'URL en castellà del recurs',
    URL_ANG_RECURS VARCHAR(4000) COMMENT 'URL en anglès del recurs',
    TIPUS_GESTIO_RECURS VARCHAR(5) COMMENT 'tipus de gestió del recurs',
    DESPESA_VARIABLE_RECURS VARCHAR(4) COMMENT 'indicador de despesa variable',
    PRODUCTE_CREACIO_ID NUMBER(18,5) COMMENT 'identificador del producte de creació',
    DESCRIPCIO_TRAMESA_RECURS VARCHAR(255) COMMENT 'descripció de la tramesa associada',
    NUM_CONTRACTE VARCHAR(50) COMMENT 'número del contracte associat',
    OBSERVACIONS VARCHAR(2000) COMMENT 'observacions del recurs',
    MODUL_ORIGEN_ID VARCHAR(255) COMMENT 'mòdul d orígen',
    VERSIO_CREACIO_ID NUMBER(12,0) COMMENT 'identificador de versió de creació',
    OBRA_ID VARCHAR(12) COMMENT 'identificador de l obra',
    CODI_MIGRACIO VARCHAR(255) COMMENT 'codi associat a la migració',
    URL_RECURS_PROPI VARCHAR(500) COMMENT 'URL pròpia del recurs',
    data_creacio TIMESTAMP_NTZ(9) COMMENT 'data de creació',
    UPDATE_DATE TIMESTAMP_NTZ(9) COMMENT 'data d actualització',
    CREATION_DATE TIMESTAMP_NTZ(9) COMMENT 'data de creació original'
);



CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_LOADS() 
RETURNS VARCHAR(16777216) 
LANGUAGE SQL 
EXECUTE AS CALLER AS 
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ); 
    LET execution_time FLOAT;
    
    -- Merge 1: Registro dummy
    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
    USING (
        SELECT
            'ND' AS DIM_RECURSOS_APRENENTATGE_KEY,
            0 AS CODI_RECURS,
            'ND' AS TITOL_RECURS,
            'ND' AS ORIGEN_RECURS,
            'ND' AS TIPUS_RECURS,
            'ND' AS ORIGEN_BASE_DADES,
            'ND' AS LLICENCIA_LPC,
            'ND' AS LLICENCIA_LGC,
            'ND' AS LLICENCIA_ALTRES,
            'ND' AS LLICENCIA_BIBLIOTECA,
            'ND' AS BAIXA,
            'ND' AS DESCRIPCIO_IDIOMA_RECURS,
            'No Disponible' AS FORMAT_RECURS,
            NULL AS DATA_INICI_RECURS,
            NULL AS DATA_CADUCITAT_RECURS,
            'ND' AS CERCABLE_RECURS,
            'ND' AS INDICADOR_PUBLIC_RECURS,
            'ND' AS PUBLICAT_A_RECURS,
            'ND' AS ISBN_ISSN_RECURS,
            0 AS PAGINA_INICI_RECURS,
            0 AS PAGINA_FINAL_RECURS,
            'ND' AS BASE_DADES_RECURS,
            'ND' AS ELLIBRE_RECURS,
            'ND' AS URL_CAT_RECURS,
            'ND' AS URL_CAS_RECURS,
            'ND' AS URL_ANG_RECURS,
            'ND' AS TIPUS_GESTIO_RECURS,
            'ND' AS DESPESA_VARIABLE_RECURS,
            0 AS PRODUCTE_CREACIO_ID,
            'ND' AS DESCRIPCIO_TRAMESA_RECURS,
            'ND' AS NUM_CONTRACTE,
            'ND' AS OBSERVACIONS,
            'ND' AS MODUL_ORIGEN_ID,
            0 AS VERSIO_CREACIO_ID,
            'ND' AS OBRA_ID,
            'ND' AS CODI_MIGRACIO,
            'ND' AS URL_RECURS_PROPI,
            '1970-01-01' AS data_creacio,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS creation_date,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS update_date
            
    ) AS ALIAS_QUERY_IN
    ON (
        ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE.DIM_RECURSOS_APRENENTATGE_KEY
        AND ALIAS_QUERY_IN.CODI_RECURS = DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE.CODI_RECURS
        AND ALIAS_QUERY_IN.ORIGEN_BASE_DADES = DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE.ORIGEN_BASE_DADES
    )
    WHEN NOT MATCHED THEN INSERT (
        DIM_RECURSOS_APRENENTATGE_KEY
        , CODI_RECURS
        , TITOL_RECURS
        , ORIGEN_RECURS
        , TIPUS_RECURS
        , ORIGEN_BASE_DADES
        , LLICENCIA_LPC
        , LLICENCIA_LGC
        , LLICENCIA_ALTRES
        , LLICENCIA_BIBLIOTECA
        , BAIXA
        , DESCRIPCIO_IDIOMA_RECURS
        , FORMAT_RECURS
        , DATA_INICI_RECURS
        , DATA_CADUCITAT_RECURS
        , CERCABLE_RECURS
        , INDICADOR_PUBLIC_RECURS
        , PUBLICAT_A_RECURS
        , ISBN_ISSN_RECURS
        , PAGINA_INICI_RECURS
        , PAGINA_FINAL_RECURS
        , BASE_DADES_RECURS
        , ELLIBRE_RECURS
        , URL_CAT_RECURS
        , URL_CAS_RECURS
        , URL_ANG_RECURS
        , TIPUS_GESTIO_RECURS
        , DESPESA_VARIABLE_RECURS
        , PRODUCTE_CREACIO_ID
        , DESCRIPCIO_TRAMESA_RECURS
        , NUM_CONTRACTE
        , OBSERVACIONS
        , MODUL_ORIGEN_ID
        , VERSIO_CREACIO_ID
        , OBRA_ID
        , CODI_MIGRACIO
        , URL_RECURS_PROPI

        , data_creacio
        , creation_date
        , update_date
    ) VALUES (
        'ND'
        , 0
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'No Disponible'
        , 'No Disponible'
        , NULL
        , NULL
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 0
        , 0
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 0
        , 'ND'
        , 'ND'
        , 'ND'
        , 'ND'
        , 0
        , 'ND'
        , 'ND'
        , 'ND'
        , '1970-01-01' 
        , '1970-01-01' 
        , '1970-01-01' 
 
    );


    -- Merge con registros de dim_coco_productes_moduls y dimax
    MERGE INTO DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE as TARGET
    USING (
        WITH dim_coco_productes_moduls AS (
            SELECT
                'COCO - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
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
                coalesce(descripcio_idioma_recurs, 'No Disponible') as descripcio_idioma_recurs,
                coalesce(DESCRIPCIO_SUPORT_RECURS,'No Disponible') AS FORMAT_RECURS,
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
                PRODUCTE_CREACIO_ID,
                DESCRIPCIO_TRAMESA_RECURS,
                NUM_CONTRACTE,
                OBSERVACIONS,
                case 
                    when MODUL_ORIGEN_ID like 'NA' then 'ND'
                    when MODUL_ORIGEN_ID is null then 'ND'
                    else MODUL_ORIGEN_ID
                end as MODUL_ORIGEN_ID,
                VERSIO_CREACIO_ID,
                OBRA_ID,
                CODI_MIGRACIO,
                URL_IDIOMA_RECURS AS URL_RECURS_PROPI,
                DATA_TANCAMENT_REAL AS data_creacio 


            FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
        ),
        dimax AS (
            SELECT

                --- pk: 
                coalesce('DIMAX - ' || CODI_RECURS, '0') AS DIM_RECURSOS_APRENENTATGE_KEY,
                Coalesce(CODI_RECURS, 0) as CODI_RECURS,

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
                coalesce(FORMAT_RECURS, 'No Disponible') as FORMAT_RECURS ,
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
                            IFF(LLICENCIA_BIBLIOTECA = 'S', 'SUBS', 'ND')
                        )
                    )
                ) AS TIPUS_GESTIO_RECURS,
                DESPESA_VARIABLE_RECURS,
 
                NULL AS PRODUCTE_CREACIO_ID,
                NULL AS DESCRIPCIO_TRAMESA_RECURS,
                '' AS NUM_CONTRACTE,
                '' AS OBSERVACIONS,
                'ND' AS MODUL_ORIGEN_ID,
                0 AS VERSIO_CREACIO_ID,
                '' AS OBRA_ID,
                '' AS CODI_MIGRACIO,
                '' AS URL_RECURS_PROPI,

                data_creacio,


            FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_DIMAX dimax
        )
        SELECT 
            *
            , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) as CREATION_DATE
            , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) as UPDATE_DATE 
        FROM dim_coco_productes_moduls
        
        UNION ALL

        SELECT  
            *
            , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) as CREATION_DATE
            , CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) as UPDATE_DATE 
        FROM dimax
        
    ) SOURCE
    ON TARGET.DIM_RECURSOS_APRENENTATGE_KEY = SOURCE.DIM_RECURSOS_APRENENTATGE_KEY
       AND TARGET.CODI_RECURS = SOURCE.CODI_RECURS
       AND TARGET.ORIGEN_BASE_DADES = SOURCE.ORIGEN_BASE_DADES
    
    WHEN MATCHED THEN 
    UPDATE SET
        TARGET.TITOL_RECURS = SOURCE.TITOL_RECURS
        ,  TARGET.ORIGEN_RECURS = SOURCE.ORIGEN_RECURS
        ,  TARGET.TIPUS_RECURS = SOURCE.TIPUS_RECURS
        ,  TARGET.LLICENCIA_LPC = SOURCE.LLICENCIA_LPC
        ,  TARGET.LLICENCIA_LGC = SOURCE.LLICENCIA_LGC
        ,  TARGET.LLICENCIA_ALTRES = SOURCE.LLICENCIA_ALTRES
        ,  TARGET.LLICENCIA_BIBLIOTECA = SOURCE.LLICENCIA_BIBLIOTECA
        ,  TARGET.BAIXA = SOURCE.BAIXA
        ,  TARGET.DESCRIPCIO_IDIOMA_RECURS = SOURCE.DESCRIPCIO_IDIOMA_RECURS
        ,  TARGET.FORMAT_RECURS = SOURCE.FORMAT_RECURS
        ,  TARGET.DATA_INICI_RECURS = SOURCE.DATA_INICI_RECURS
        ,  TARGET.DATA_CADUCITAT_RECURS = SOURCE.DATA_CADUCITAT_RECURS
        ,  TARGET.CERCABLE_RECURS = SOURCE.CERCABLE_RECURS
        ,  TARGET.INDICADOR_PUBLIC_RECURS = SOURCE.INDICADOR_PUBLIC_RECURS
        ,  TARGET.PUBLICAT_A_RECURS = SOURCE.PUBLICAT_A_RECURS
        ,  TARGET.ISBN_ISSN_RECURS = SOURCE.ISBN_ISSN_RECURS
        ,  TARGET.PAGINA_INICI_RECURS = SOURCE.PAGINA_INICI_RECURS
        ,  TARGET.PAGINA_FINAL_RECURS = SOURCE.PAGINA_FINAL_RECURS
        ,  TARGET.BASE_DADES_RECURS = SOURCE.BASE_DADES_RECURS
        ,  TARGET.ELLIBRE_RECURS = SOURCE.ELLIBRE_RECURS
        ,  TARGET.URL_CAT_RECURS = SOURCE.URL_CAT_RECURS
        ,  TARGET.URL_CAS_RECURS = SOURCE.URL_CAS_RECURS
        ,  TARGET.URL_ANG_RECURS = SOURCE.URL_ANG_RECURS
        ,  TARGET.TIPUS_GESTIO_RECURS = SOURCE.TIPUS_GESTIO_RECURS
        ,  TARGET.DESPESA_VARIABLE_RECURS = SOURCE.DESPESA_VARIABLE_RECURS
        ,  TARGET.PRODUCTE_CREACIO_ID = SOURCE.PRODUCTE_CREACIO_ID
        ,  TARGET.DESCRIPCIO_TRAMESA_RECURS = SOURCE.DESCRIPCIO_TRAMESA_RECURS
        ,  TARGET.NUM_CONTRACTE = SOURCE.NUM_CONTRACTE
        ,  TARGET.OBSERVACIONS = SOURCE.OBSERVACIONS
        ,  TARGET.MODUL_ORIGEN_ID = SOURCE.MODUL_ORIGEN_ID
        ,  TARGET.VERSIO_CREACIO_ID = SOURCE.VERSIO_CREACIO_ID
        ,  TARGET.OBRA_ID = SOURCE.OBRA_ID
        ,  TARGET.CODI_MIGRACIO = SOURCE.CODI_MIGRACIO
        ,  TARGET.URL_RECURS_PROPI = SOURCE.URL_RECURS_PROPI
        ,  TARGET.data_creacio = SOURCE.data_creacio
        ,  TARGET.UPDATE_DATE = CURRENT_TIMESTAMP()

    WHEN NOT MATCHED THEN INSERT (
        DIM_RECURSOS_APRENENTATGE_KEY
        , CODI_RECURS
        , TITOL_RECURS
        , ORIGEN_RECURS
        , TIPUS_RECURS
        , ORIGEN_BASE_DADES
        , LLICENCIA_LPC
        , LLICENCIA_LGC
        , LLICENCIA_ALTRES
        , LLICENCIA_BIBLIOTECA
        , BAIXA
        , DESCRIPCIO_IDIOMA_RECURS
        , FORMAT_RECURS
        , DATA_INICI_RECURS
        , DATA_CADUCITAT_RECURS
        , CERCABLE_RECURS
        , INDICADOR_PUBLIC_RECURS
        , PUBLICAT_A_RECURS
        , ISBN_ISSN_RECURS
        , PAGINA_INICI_RECURS
        , PAGINA_FINAL_RECURS
        , BASE_DADES_RECURS
        , ELLIBRE_RECURS
        , URL_CAT_RECURS
        , URL_CAS_RECURS
        , URL_ANG_RECURS
        , TIPUS_GESTIO_RECURS
        , DESPESA_VARIABLE_RECURS
        , PRODUCTE_CREACIO_ID
        , DESCRIPCIO_TRAMESA_RECURS
        , NUM_CONTRACTE
        , OBSERVACIONS
        , MODUL_ORIGEN_ID
        , VERSIO_CREACIO_ID
        , OBRA_ID
        , CODI_MIGRACIO
        , URL_RECURS_PROPI

        , data_creacio
        , UPDATE_DATE
        , CREATION_DATE 
    ) VALUES (
        SOURCE.DIM_RECURSOS_APRENENTATGE_KEY
        , SOURCE.CODI_RECURS
        , SOURCE.TITOL_RECURS
        , SOURCE.ORIGEN_RECURS
        , SOURCE.TIPUS_RECURS
        , SOURCE.ORIGEN_BASE_DADES
        , SOURCE.LLICENCIA_LPC, SOURCE.LLICENCIA_LGC, SOURCE.LLICENCIA_ALTRES, SOURCE.LLICENCIA_BIBLIOTECA, SOURCE.BAIXA
        , SOURCE.DESCRIPCIO_IDIOMA_RECURS
        , SOURCE.FORMAT_RECURS
        , SOURCE.DATA_INICI_RECURS
        , SOURCE.DATA_CADUCITAT_RECURS
        , SOURCE.CERCABLE_RECURS
        , SOURCE.INDICADOR_PUBLIC_RECURS
        , SOURCE.PUBLICAT_A_RECURS
        , SOURCE.ISBN_ISSN_RECURS
        , SOURCE.PAGINA_INICI_RECURS
        , SOURCE.PAGINA_FINAL_RECURS
        , SOURCE.BASE_DADES_RECURS
        , SOURCE.ELLIBRE_RECURS
        , SOURCE.URL_CAT_RECURS
        , SOURCE.URL_CAS_RECURS
        , SOURCE.URL_ANG_RECURS
        , SOURCE.TIPUS_GESTIO_RECURS
        , SOURCE.DESPESA_VARIABLE_RECURS
        , SOURCE.PRODUCTE_CREACIO_ID
        , SOURCE.DESCRIPCIO_TRAMESA_RECURS
        , SOURCE.NUM_CONTRACTE
        , SOURCE.OBSERVACIONS
        , SOURCE.MODUL_ORIGEN_ID
        , SOURCE.VERSIO_CREACIO_ID
        , SOURCE.OBRA_ID
        , SOURCE.CODI_MIGRACIO
        , SOURCE.URL_RECURS_PROPI

        , SOURCE.data_creacio
        , CURRENT_TIMESTAMP()
        , SOURCE.CREATION_DATE
    );




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
 
 
