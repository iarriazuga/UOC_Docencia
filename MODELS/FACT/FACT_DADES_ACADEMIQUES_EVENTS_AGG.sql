-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_EVENTS_SIMPLIFIED 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 (

    ID_ASSIGNATURA NUMBER(38, 0) COMMENT 'Identificador de la assignatura.',
    ID_SEMESTRE NUMBER(38, 0) COMMENT 'Identificador del semestre.',
    ID_CODI_RECURS NUMBER(38, 0) COMMENT 'Identificador del recurs.',

    ID_PERSONA NUMBER(38, 0) COMMENT 'Identificador del persona.',

    DIM_PERSONA_KEY NUMBER(10,0) COMMENT 'Clau DIM_PERSONA_KEY.',
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38, 0) COMMENT 'Clau semestre.',
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15) COMMENT 'Clau recursos d\'aprenentatge.',

    ORIGEN_DADES_ACADEMIQUES VARCHAR(5) COMMENT 'Font de las dades académiques.', 
    usos_recurs_estudiants NUMBER(38, 0),
    usos_recurs_totals NUMBER(38, 0)
) AS 

SELECT 

    dades_academiques.id_assignatura   
    , dades_academiques.id_semestre
    , dades_academiques.id_codi_recurs    
    , dades_academiques.id_persona 

    , dades_academiques.DIM_PERSONA_KEY
    , dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    
    , dades_academiques.ORIGEN_DADES_ACADEMIQUES 
    
    , sum( dades_academiques.usos_recurs_estudiants )  as usos_recurs_estudiants
    , sum( dades_academiques.usos_recurs_totals )  as usos_recurs_totals

FROM  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
group by 1,2,3,4,5,6,7,8,9


 