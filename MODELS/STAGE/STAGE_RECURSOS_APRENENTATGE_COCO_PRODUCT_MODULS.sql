-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS AS
With productos_aux AS ( 
        SELECT                               
            
            autors_producte.id AS CODI_RECURS,                      --   autors_producte.ID,                 -- COCO: id del producte
            autors_producte.titol AS titol_recurs,                  --   autors_producte.TITOL,                 -- COCO: Títol del producte
            'PROPI' AS origen_recurs,
            'COCO_PROD' AS source_recurs,
            autors_producte.versio_creacio_id,                      -- COCO: Id del pla de publicació en que es va crear                  
            
            -- INCLUDED 
            autors_producte.id AS PRODUCTE_CREACIO_ID,              -- COCO: code of the same parent product  
            autors_producte.producte_origen_id,                     -- COCO: Id del producte origen
            autors_producte.url AS url_idioma_recurs,               -- COCO: Url del Producte
            autors_producte.url AS url,                             -- COCO: Url del Producte

            autors_tipus_tramesa_i18n.descripcio AS descripcio_tramesa_recurs,
            autors_suport_producte_i18n.descripcio AS descripcio_suport_recurs,
            initcap(autors_idioma_producte_i18n.descripcio) AS descripcio_idioma_recurs,
            autors_tipus_tramesa_i18n.descripcio AS DESCRIPCIO,
            
            autors_producte.ind_material_propi,                     -- COCO: Per altes de materials no propis
            autors_producte.codi_migracio,                          -- COCO: Codi de migració: included in COCO_MOD
            autors_producte.baixa,                                  -- COCO: Indicador de Baixa
            autors_producte.paraula_clau,                           -- COCO: Paraula Clau
            autors_producte.codi_recurs_origen,                     -- COCO: Codi recurs Origen 
            autors_producte.num_contracte,                          -- COCO: Codi contracte autoria
            autors_producte.data_tancament_real ,                   -- COCO: Data de producció del material

            -- ADDED: check concat all 
            'NA' AS OBSERVACIONS,                                   --  Observacions del mòdul (Campo específico de módulo)
            'NA' AS MODUL_ORIGEN_ID,                                -- Id del mòdul que original (Campo específico de módulo)
            'NA' AS OBRA_ID,                                        -- Id de la obra (Campo específico de módulo)
 
 
        FROM db_uoc_prod.stg_dadesra.autors_producte  -- 55,848
            
        left join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n  -- 51,711: revisar inner 
            on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id
            and autors_suport_producte_i18n.idioma = 'CAT'
        
        left join db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n
            on autors_producte.fk_tipus_tramesa_tipus_tra__id = autors_tipus_tramesa_i18n.fk_tipus_tramesa_tipus_tra__id
            and autors_tipus_tramesa_i18n.idioma = 'CAT'
            
        left join db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n
            on autors_producte.fk_idioma_producte_idioma_id = autors_idioma_producte_i18n.fk_idioma_producte_idioma___id
            and autors_idioma_producte_i18n.idioma = 'CAT'
        
        -- where ifnull(autors_producte.fk_suport_producte_suport_id,0) != 0
            
)

 
,  modulos_aux AS (
    SELECT 
        coalesce(autors_modul.ID, autors_producte.codi_recurs) AS CODI_RECURS,                                                  -- Id del Mòdulo (Camp ja definit)
        coalesce(autors_modul.DESCRIPCIO, autors_producte.titol_recurs)  AS titol_recurs,                                       -- (Camp ja definit) (Corresponde al campo Título en la tabla Producte)  --> PROBLEMA EN MODULOS, COMO LO SACO / RELACIONO
        'PROPI' AS origen_recurs,                                                                                               -- Tipus de recurs  (Camp ja definit)
        CASE 
            when autors_modul.ID is not null then 'COCO_MOD' 
            ELSE 'COCO_PROD' 
        END AS source_recurs,                                                                                                   -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                          
        coalesce(autors_modul.versio_creacio_id, autors_producte.versio_creacio_id) AS versio_creacio_id,                       -- COCO: Id del pla de publicació en que es va crear

        -- revisar 
        autors_modul.PRODUCTE_CREACIO_ID  AS PRODUCTE_CREACIO_ID,                                                               --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte
        autors_producte.producte_origen_id,                                                                                     -- COCO: Id del producte origen
        autors_producte.url AS url_idioma_recurs,                                                                               -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                                  
        autors_producte.url AS url,                                                                                             -- COCO: Url del Producte
        
        -- COMES FROM LEFT JOINS: 
        autors_producte.descripcio_tramesa_recurs AS descripcio_tramesa_recurs,                                                                --(Campo a recuperar de PRODUCTO)
        autors_producte.descripcio_suport_recurs AS descripcio_suport_recurs,                                                   -- (Campo a recuperar de PRODUCTO)
        initcap(autors_producte.descripcio_idioma_recurs) AS descripcio_idioma_recurs,
        autors_producte.DESCRIPCIO AS DESCRIPCIO,
        
        autors_producte.ind_material_propi,                                                                                     -- COCO: Per altes de materials no propis
        coalesce (autors_modul.CODI_MIGRACIO, autors_producte.codi_migracio) AS CODI_MIGRACIO,                                  -- (Corresponde al Codigo migración de producto) coalesce
        autors_producte.baixa,                                                                                                  -- (Campo a recuperar de PRODUCTO) COCO: Indicador de Baixa
        autors_producte.paraula_clau,                                                                                           -- COCO: Paraula Clau
        autors_producte.codi_recurs_origen,                                                                                     -- COCO: Codi recurs Origen 
        autors_producte.num_contracte,                                                                                          -- (Campo a recuperar de PRODUCTO) COCO: Codi contracte autoria
        autors_producte.data_tancament_real,                                                                                    -- (Campo a recuperar de PRODUCTO) COCO: Data de producció del material
        autors_modul.OBSERVACIONS,                                                                                              --  Observacions del mòdul (Campo específico de módulo)
        autors_modul.MODUL_ORIGEN_ID,                                                                                           -- Id del mòdul que original (Campo específico de módulo)
        autors_modul.OBRA_ID                                                                                                    -- Id de la obra (Campo específico de módulo)
 
    FROM db_uoc_prod.stg_dadesra.autors_modul autors_modul  
    left join productos_aux autors_producte on autors_producte.codi_recurs = autors_modul.PRODUCTE_CREACIO_ID 

)



SELECT * FROM modulos_aux -- 51,568 
union all
SELECT * FROM productos_aux --60,775
 
;

/*
--#################################################################################################
--COMENTARIOS: 
--#################################################################################################

Duplicados elementos nos quedamos con los del modulo : estos duplicados se deben a que los modulos hann sido promocionados a productos, codigo antiguos 
algunos modulos no tienen producto origen --> tenemso que quedarnos con el modulo aunque el prodcuo este vacio 

-- union all : 112,343 vs 112,336 after duplicates deletion
-- productos : 51,568 
-- modulos   : 60,775
 
--  SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
--  drop table DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS

*/


 
// DELETE DUPLICATES: 
-- Step 1: Create a temporary table with duplicate rows to delete
CREATE OR REPLACE TEMP TABLE DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP AS
SELECT 
    CODI_RECURS,
    source_recurs
FROM 
    (SELECT 
        CODI_RECURS, 
        source_recurs,
        ROW_NUMBER() OVER(PARTITION BY CODI_RECURS ORDER BY CODI_RECURS) AS row_num
     FROM 
        DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
    ) AS subquery
WHERE 
    row_num > 1 AND source_recurs = 'COCO_PROD';

-- Step 2: Delete the duplicates using the temporary table
DELETE FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
WHERE (codi_recurs, source_recurs) IN (
    SELECT CODI_RECURS, source_recurs
    FROM DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP
);

-- Step 3: Drop the temporary table after use
DROP TABLE DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP;

 










