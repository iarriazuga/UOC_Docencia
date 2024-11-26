-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES AS 

SELECT 

    DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    -- , ID_RESOURCE
    , TITOL_RESOURCE 
    , plan_estudios_base
    , 'COCO' AS SOURCE_DADES_ACADEMIQUES

FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO  

union all 

SELECT     
    DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , ID_RESOURCE 
    , TITOL_RESOURCE 
    , 'NA' AS plan_estudios_base
    , 'DIMAX' AS SOURCE_DADES_ACADEMIQUES 
FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX 



 

 