CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_LOADS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS $$
BEGIN
    LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
    LET execution_time FLOAT;

    -- Primer MERGE
    MERGE INTO DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA
    USING (
        SELECT 
            0 AS id_assignatura,
            '00.000' AS dim_assignatura_key,
            '19000' AS semestre_inici_doc,
            '19000' AS semestre_extincio,
            '19000' AS semestre_ini_eees,
            'ND' AS idioma_docencia,
            'ND' AS desc_cat,
            'ND' AS desc_cas,
            'ND' AS desc_ang,
            'ND' AS desc_fra,
            '-' AS ind_tfc,
            '-' AS ind_practicum,
            '-' AS ind_arees,
            '-' AS ind_anual,
            'ND' AS descripcio_assignatura,
            0 AS tipus_assignatura,
            0 AS num_credits,
            0 AS num_credits_teorics,
            0 AS num_credits_practics,
            'ND' AS valor_assignatura,
            'ND' AS ind_eval_continuada,
            'ND' AS ind_exa_presencial,
            'ND' AS ind_prova_conf,
            'ND' AS cod_estudis_area,
            'ND' AS tipus_educacio,
            'ND' AS tipus_docencia_detall,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS creation_date,
            CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS update_date
    ) AS dim_assignatura_repl
    ON DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.id_assignatura = dim_assignatura_repl.id_assignatura
    WHEN MATCHED THEN
        UPDATE SET update_date = CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    WHEN NOT MATCHED THEN
        INSERT (id_assignatura, dim_assignatura_key, semestre_inici_doc, semestre_extincio, semestre_ini_eees, idioma_docencia, desc_cat, desc_cas, desc_ang, desc_fra, ind_tfc, ind_practicum, ind_arees, ind_anual, descripcio_assignatura, tipus_assignatura, num_credits, num_credits_teorics, num_credits_practics, valor_assignatura, ind_eval_continuada, ind_exa_presencial, ind_prova_conf, cod_estudis_area, tipus_educacio, tipus_docencia_detall, creation_date, update_date)
        VALUES (0, '00.000', '19000', '19000', '19000', 'ND', 'ND', 'ND', 'ND', 'ND', '-', '-', '-', '-', 'ND', 0, 0, 0, 0, 'ND', 'ND', 'ND', 'ND', 'ND', 'ND', 'ND', CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ), CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

    -- Segundo MERGE
    MERGE INTO DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA
    USING (
        SELECT 
            load_assignatures.cod_assignatura,
            load_assignatures.any_acad_inicio_doc,
            load_assignatures.any_acad_extincion,
            load_assignatures.any_acad_ini_eees,
            load_assignatures.idioma_docencia,
            load_assignatures."CAT" AS desc_cat,
            load_assignatures."CAS" AS desc_cas,
            load_assignatures."ANG" AS desc_ang,
            load_assignatures."FRA" AS desc_fra,
            load_assignatures.ind_tfc,
            load_assignatures.ind_practicum,
            load_assignatures.ind_arees,
            load_assignatures.ind_anual,
            load_assignatures.descripcio_assignatura,
            load_assignatures.tipus_assignatura,
            load_assignatures.num_credits,
            load_assignatures.num_credits_teorics,
            load_assignatures.num_credits_practics,
            load_assignatures.valor_assignatura,
            load_assignatures.ind_eval_continuada,
            load_assignatures.ind_exa_presencial,
            load_assignatures.ind_prova_conf,
            load_assignatures.cod_estudis_area,
            load_assignatures.tipus_educacio,
            load_assignatures.tipus_docencia_detall
        FROM (
            SELECT 
                -- Subconsulta aquí
            ) PIVOT (MAX(descripcion) FOR cod_idioma IN 
                (SELECT DISTINCT cod_idioma FROM DB_UOC_PROD.STG_DOCENCIA.GAT_DESCRIPCIONES WHERE nom_tabla = 'ASIGNATURAS' AND nom_campo = 'DESC_ASIGNATURA')
            ) AS load_assignatures
        WHERE nom_tabla = 'ASIGNATURAS'
          AND nom_campo = 'DESC_ASIGNATURA'
    ) AS dim_assignatura_orig
    ON DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.dim_assignatura_key = dim_assignatura_orig.cod_assignatura
       AND IFNULL(DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.semestre_inici_doc, 0) = IFNULL(dim_assignatura_orig.any_acad_inicio_doc, 0)
       AND DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.idioma_docencia = dim_assignatura_orig.idioma_docencia
    WHEN MATCHED THEN 
        UPDATE SET 
            dim_assignatura_key = dim_assignatura_orig.cod_assignatura,
            semestre_inici_doc = dim_assignatura_orig.any_acad_inicio_doc,
            -- Más campos aquí
            update_date = CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    WHEN NOT MATCHED THEN
        INSERT (dim_assignatura_key, semestre_inici_doc, ...)
        VALUES (dim_assignatura_orig.cod_assignatura, dim_assignatura_orig.any_acad_inicio_doc, ...);

    -- Registro de ejecución
    execution_time := DATEDIFF(MILLISECOND, start_time, CONVERT_TIMEZONE('America/Los_Angeles', 'Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

    INSERT INTO DB_UOC_PROD.DD_OD.PROCEDURES_LOG (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    VALUES (DB_UOC_PROD.DD_OD.SEQUENCIA_ID_LOG.NEXTVAL, 'dim_assignatura_loads', CURRENT_USER(), :start_time, :execution_time, 'dim_assignatura Success');
    
    RETURN 'Update completed successfully';
END
$$;
 