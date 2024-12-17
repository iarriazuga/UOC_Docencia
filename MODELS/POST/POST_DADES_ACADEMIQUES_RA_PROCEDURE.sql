-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_RA 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA(

    DIM_PERSONA_KEY NUMBER(10,0) COMMENT 'Clau DIM_PERSONA_KEY.',
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38, 0) COMMENT 'Clau semestre.',
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15) COMMENT 'Clau recursos d\'aprenentatge.',
    CODI_RECURS NUMBER(38, 0) COMMENT 'Codi del recurs.',
    ORIGEN_DADES_ACADEMIQUES VARCHAR(5) COMMENT 'Font de les dades acadèmiques.', 
    assignatura_vigent_semester VARCHAR(10) COMMENT 'Vigencia de la assignatura en el semestre analitzat.'

);


CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA_LOADS() 
RETURNS VARCHAR(16777216) 
LANGUAGE SQL 
EXECUTE AS CALLER AS 
BEGIN
    -- Declaración de variables
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ); 
    LET execution_time FLOAT;

    -- INSERT: Volcat de registres
    TRUNCATE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA;
    INSERT INTO DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA (
        DIM_PERSONA_KEY,
        DIM_ASSIGNATURA_KEY,
        DIM_SEMESTRE_KEY,
        DIM_RECURSOS_APRENENTATGE_KEY,
        CODI_RECURS,
        ORIGEN_DADES_ACADEMIQUES,
        assignatura_vigent_semester
    )
    with profesores_assignaturas as ( 
        select 
            cod_asignatura 
            , any_academico
            , max(idp) as idp  -- seleccionamos al max profesor : no granularidad 1:1 victor
        from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS
        group by  1,2 
    )
    SELECT 
        -- DIM_KEYS:
        profesores_assignaturas.idp AS DIM_PERSONA_KEY, -- Included to show the professor for the course --> 1:1 relationship -> does not create duplicates
        aux_temporary_table.DIM_ASSIGNATURA_KEY,
        aux_temporary_table.DIM_SEMESTRE_KEY,
        aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY,
        aux_temporary_table.CODI_RECURS,
        aux_temporary_table.ORIGEN_DADES_ACADEMIQUES, 
        case 
            when validez_asig_semestres.any_acad_extincion is null and  validez_asig_semestres.cod_asignatura is null then 'No Info'
            when validez_asig_semestres.any_acad_extincion is null then 'Vigent'
            when validez_asig_semestres.any_acad_extincion >= aux_temporary_table.DIM_SEMESTRE_KEY then 'Vigent'
            else 'No vigent'
        END as assignatura_vigent_semester
    FROM (
        SELECT 
            DIM_ASSIGNATURA_KEY,
            DIM_SEMESTRE_KEY,
            'COCO - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
            CODI_RECURS,
            'COCO' AS ORIGEN_DADES_ACADEMIQUES
        FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO

        UNION ALL

        SELECT     
            DIM_ASSIGNATURA_KEY,
            DIM_SEMESTRE_KEY,
            'DIMAX - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
            CODI_RECURS,
            'DIMAX' AS ORIGEN_DADES_ACADEMIQUES
        FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX
    ) aux_temporary_table
        LEFT JOIN profesores_assignaturas
            ON profesores_assignaturas.cod_asignatura = aux_temporary_table.DIM_ASSIGNATURA_KEY
            AND profesores_assignaturas.any_academico = aux_temporary_table.DIM_SEMESTRE_KEY

        -- VALIDEZ DE LA ASSIGNATURA: 
        left join db_uoc_prod.stg_docencia.gat_asig_semestres validez_asig_semestres
                on  validez_asig_semestres.cod_asignatura = aux_temporary_table.DIM_ASSIGNATURA_KEY
    ;
    -- LOGS
    EXECUTION_TIME := DATEDIFF(MILLISECOND, START_TIME, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));
    INSERT INTO DB_UOC_PROD.DD_OD.PROCEDURES_LOG (
        ID_LOG, PROCEDURE_NAME, EXECUTED_BY, EXECUTION_DATE, EXECUTION_TIME, REMARKS
    )
    VALUES (
        DB_UOC_PROD.DD_OD.SEQUENCIA_ID_LOG.NEXTVAL, 
        'DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA', 
        CURRENT_USER(), 
        :START_TIME, 
        :EXECUTION_TIME, 
        'DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA Success'
    );

    RETURN 'Update completed successfully';
END;

 

-- Procedure Execution
CALL DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA_LOADS() ;

select * from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA;

-- sum anteriores: 
-- STAGE_DADES_ACADEMIQUES_COCO:  1,712,881
-- STAGE_DADES_ACADEMIQUES_DIMAX 3,390,907
-- suma : 5,103,788 