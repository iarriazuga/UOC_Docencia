-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################
CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS AS
With productos_aux as ( 
        select                               
            
            autors_producte.id as codi_recurs,                      --   autors_producte.ID,                 -- COCO: id del producte
            autors_producte.titol as titol_recurs,                  --   autors_producte.TITOL,                 -- COCO: Títol del producte
            'PROPI' as origen_recurs,
            'COCO_PROD' as source_recurs,
            autors_producte.versio_creacio_id,                      -- COCO: Id del pla de publicació en que es va crear                  
            
            -- INCLUDED 
            autors_producte.id as PRODUCTE_CREACIO_ID,              -- COCO: code of the same parent product  
            autors_producte.producte_origen_id,                     -- COCO: Id del producte origen
            autors_producte.url as url_idioma_recurs,               -- COCO: Url del Producte
            autors_producte.url as url,                             -- COCO: Url del Producte

            autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs,
            autors_suport_producte_i18n.descripcio as descripcio_suport_recurs,
            initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs,
            autors_tipus_tramesa_i18n.descripcio as DESCRIPCIO,
            
            autors_producte.ind_material_propi,                     -- COCO: Per altes de materials no propis
            autors_producte.codi_migracio,                          -- COCO: Codi de migració: included in COCO_MOD
            autors_producte.baixa,                                  -- COCO: Indicador de Baixa
            autors_producte.paraula_clau,                           -- COCO: Paraula Clau
            autors_producte.codi_recurs_origen,                     -- COCO: Codi recurs Origen 
            autors_producte.num_contracte,                          -- COCO: Codi contracte autoria
            autors_producte.data_tancament_real ,                    -- COCO: Data de producció del material

            -- ADDED: check concat all 
            'NA' AS OBSERVACIONS,                                   --  Observacions del mòdul (Campo específico de módulo)
            'NA' AS MODUL_ORIGEN_ID,                                -- Id del mòdul que original (Campo específico de módulo)
            'NA' AS OBRA_ID,                                        -- Id de la obra (Campo específico de módulo)
 
 
        from db_uoc_prod.stg_dadesra.autors_producte
            
        inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n
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

 
,  modulos_aux as (
    SELECT 
        coalesce(autors_modul.ID, autors_producte.codi_recurs) as codi_recurs,                                                  -- Id del Mòdulo (Camp ja definit)
        coalesce(autors_modul.DESCRIPCIO, autors_producte.titol_recurs)  as titol_recurs,                                       -- (Camp ja definit) (Corresponde al campo Título en la tabla Producte)  --> PROBLEMA EN MODULOS, COMO LO SACO / RELACIONO
        'PROPI' as origen_recurs,                                                                                               -- Tipus de recurs  (Camp ja definit)
        CASE 
            when autors_modul.ID is not null then 'COCO_MOD' 
            ELSE 'COCO_PROD' 
        END as source_recurs,                                                                                                   -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                          
        coalesce(autors_modul.versio_creacio_id, autors_producte.versio_creacio_id) as versio_creacio_id,                       -- COCO: Id del pla de publicació en que es va crear

        -- revisar 
        coalesce(autors_modul.PRODUCTE_CREACIO_ID, autors_producte.PRODUCTE_CREACIO_ID)  as PRODUCTE_CREACIO_ID,                --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte
        autors_producte.producte_origen_id,                                                                                     -- COCO: Id del producte origen
        autors_producte.url as url_idioma_recurs,                                                                               -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                                  
        autors_producte.url as url,                                                                                             -- COCO: Url del Producte
        
        -- COMES FROM LEFT JOINS: 
        autors_producte.descripcio_tramesa_recurs as descripcio_tramesa_recurs,                                                                --(Campo a recuperar de PRODUCTO)
        autors_producte.descripcio_suport_recurs as descripcio_suport_recurs,                                                   -- (Campo a recuperar de PRODUCTO)
        initcap(autors_producte.descripcio_idioma_recurs) as descripcio_idioma_recurs,
        autors_producte.DESCRIPCIO as DESCRIPCIO,
        
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
 
    from db_uoc_prod.stg_dadesra.autors_modul autors_modul  
    left join productos_aux autors_producte on autors_producte.codi_recurs = autors_modul.PRODUCTE_CREACIO_ID 

)

select * from modulos_aux -- 51,568 
union all
select * from productos_aux --60,775
 


/*
--#################################################################################################
--COMENTARIOS: 
--#################################################################################################

Duplicados elementos nos quedamos con los del modulo : estos duplicados se deben a que los modulos hann sido promocionados a productos, codigo antiguos 
algunos modulos no tienen producto origen --> tenemso que quedarnos con el modulo aunque el prodcuo este vacio 

-- union all : 112,343 vs 112,336 after duplicates deletion
-- productos : 51,568 
-- modulos   : 60,775
 
--  select * from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS
--  drop table DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS

*/


 
// DELETE DUPLICATES: 
-- Step 1: Create a temporary table with duplicate rows to delete
CREATE TEMPORARY TABLE DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP AS
SELECT 
    codi_recurs,
    source_recurs
FROM 
    (SELECT 
        codi_recurs, 
        source_recurs,
        ROW_NUMBER() OVER(PARTITION BY codi_recurs ORDER BY codi_recurs) AS row_num
     FROM 
        DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS
    ) AS subquery
WHERE 
    row_num > 1 AND source_recurs = 'COCO_PROD';

-- Step 2: Delete the duplicates using the temporary table
DELETE FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS
WHERE (codi_recurs, source_recurs) IN (
    SELECT codi_recurs, source_recurs
    FROM DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP
);

-- Step 3: Drop the temporary table after use
DROP TABLE DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP;



-- select * from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS where codi_recurs = '145195' -- idioma  catalan , recurso = web 
-- select * from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS where codi_recurs = '145193' 

-- modulo : 145195 
-- producto 145193 