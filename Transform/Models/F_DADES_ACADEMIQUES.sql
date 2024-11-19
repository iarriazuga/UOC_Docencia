-- -- #################################################################################################
-- -- #################################################################################################
-- -- F_DADES_ACADEMIQUES 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES AS 

SELECT 

    asignatura AS ID_ASIGNATURA
    , semestre_id AS  ID_SEMESTRE
    , codi_producto_coco AS ID_PRODUCTO
    , titulo_prod_coco AS TITULO_PRODUCTO 
    , plan_estudios_base
    , 'COCO' AS SOURCE_DADES_ACADEMIQUES

FROM  DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_COCO  

union all 

SELECT     
    ASSIGNTURA_CODI AS ID_ASIGNATURA
    , SEMESTRE_ASIGNATURA AS  ID_SEMESTRE
    , ID_RESOURCE AS ID_PRODUCTO
    , TITOL_RESOURCE AS TITULO_PRODUCTO 
    , 'NA' AS plan_estudios_base
    , 'DIMAX' AS SOURCE_DADES_ACADEMIQUES 
FROM  DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX  



--################################################################################################# 
/*

select * from DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES


select source_dades_academiques , count(*)  
from DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES 
group  by 1 


SOURCE_DADES_ACADEMIQUES	COUNT(*)
DIMAX	                    3536573 -- distinct 
COCO	                    1913122


*/