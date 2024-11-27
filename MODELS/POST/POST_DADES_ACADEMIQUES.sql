-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES AS 

SELECT 

    DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , ID_RESOURCE as CODI_RECURS
    -- , TITOL_RESOURCE 
    ,  PLAN_ESTUDIOS_BASE
    , 'COCO' AS SOURCE_DADES_ACADEMIQUES

FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO  

union all 

SELECT     
    DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , CODI_RECURS 
    -- , TITOL_RESOURCE 
    , 'NA' AS  PLAN_ESTUDIOS_BASE
    , 'DIMAX' AS SOURCE_DADES_ACADEMIQUES 
FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX 



 

 