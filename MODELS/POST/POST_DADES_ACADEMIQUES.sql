-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES (

    DIM_ASSIGNATURA_KEY VARCHAR(6), -- String '93.2681.c' is too long and would be truncated 90.998.semic
    DIM_SEMESTRE_KEY INT,    
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15), 
    CODI_RECURS INT, 
    SOURCE_DADES_ACADEMIQUES VARCHAR(5) 
    
) AS 

SELECT 
    DIM_ASSIGNATURA_KEY,
    DIM_SEMESTRE_KEY,
    DIM_RECURSOS_APRENENTATGE_KEY,
    CODI_RECURS,
    'COCO' AS SOURCE_DADES_ACADEMIQUES
FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO

UNION ALL

SELECT     
    DIM_ASSIGNATURA_KEY,
    DIM_SEMESTRE_KEY,
    DIM_RECURSOS_APRENENTATGE_KEY,
    CODI_RECURS,
    'DIMAX' AS SOURCE_DADES_ACADEMIQUES
FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX;
