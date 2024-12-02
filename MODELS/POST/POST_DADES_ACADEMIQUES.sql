-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES (

    id_assignatura INT,   
    id_semestre INT,   
    id_codi_recurs INT,    

    DIM_ASSIGNATURA_KEY VARCHAR(6), -- String '93.2681.c' is too long and would be truncated 90.998.semic
    DIM_SEMESTRE_KEY INT,    
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15), 
    CODI_RECURS INT, 
    SOURCE_DADES_ACADEMIQUES VARCHAR(5) 
    
) AS 

with aux_temporary_table as (

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
    FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX
)
 
select 
        -- FK
        asignatura.id_assignatura
        , semestre.id_semestre
        , recursos.id_codi_recurs --review 

        , aux_temporary_table.DIM_ASSIGNATURA_KEY
        , aux_temporary_table.DIM_SEMESTRE_KEY
        , aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY
        , aux_temporary_table.CODI_RECURS
        , aux_temporary_table.SOURCE_DADES_ACADEMIQUES

from aux_temporary_table

left join DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA as asignatura 
    on  asignatura.DIM_ASSIGNATURA_KEY = aux_temporary_table.DIM_ASSIGNATURA_KEY

left join DB_UOC_PROD.DD_OD.DIM_SEMESTRE as semestre 
    on semestre.DIM_SEMESTRE_KEY = aux_temporary_table.DIM_SEMESTRE_KEY

left join DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE as recursos 
    on recursos.DIM_RECURSOS_APRENENTATGE_KEY  = aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY