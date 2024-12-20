
CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.REMOVE_DUPLICATES_COCO_PROD()
RETURNS STRING
LANGUAGE SQL
AS 
$$
BEGIN
    -- Step 1: Create a temporary table to store duplicates
    CREATE OR REPLACE TEMP TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_CLEAN_PROCEDURE AS
    SELECT 
        CODI_RECURS,
        origen_base_dades
    FROM 
        (
            SELECT 
                CODI_RECURS, 
                origen_base_dades,
                ROW_NUMBER() OVER (PARTITION BY CODI_RECURS ORDER BY CODI_RECURS) AS row_num
            FROM 
                DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
        ) AS subquery
    WHERE 
        row_num > 1 AND origen_base_dades = 'COCO_PROD';

    -- Step 2: Delete duplicates using a JOIN
    DELETE FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
    USING DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_CLEAN_PROCEDURE
    WHERE 
        DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS.CODI_RECURS = DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_CLEAN_PROCEDURE.CODI_RECURS
        AND DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS.origen_base_dades = DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_CLEAN_PROCEDURE.origen_base_dades;

    -- Step 3: Drop the temporary table
    -- DROP TABLE IF EXISTS DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_CLEAN_PROCEDURE; --review after 

    RETURN 'Duplicates successfully removed.';
END;
$$;

call DB_UOC_PROD.DDP_DOCENCIA.REMOVE_DUPLICATES_COCO_PROD();


 