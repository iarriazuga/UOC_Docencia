-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################


-- /**
-- ####################################################################################################
-- TABLE
-- ####################################################################################################
-- **/

-- ####################################################################################################
-- productos_aux         
-- CREATE TABLE RECURSOS_COCO_MODULS
-- ####################################################################################################
-- CREATE TABLE DB_UOC_PROD.DDP_DADESRA.DIM_RECURSOS_COCO_PRODUCT_MODULS AS -- no privileges DDP_DOCENCIA
CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS AS
With productos_aux as ( 
        select                              -- agafa els mateixos camps per conservar la estructura però dades de COCO (taules Autors)
            autors_producte.id as codi_recurs,                      --   autors_producte.ID,                 -- COCO: id del producte
            autors_producte.titol as titol_recurs,                  --   autors_producte.TITOL,                 -- COCO: Títol del producte
            autors_producte.titol as titol_recurs,                  --   autors_producte.TITOL,                 -- COCO: Títol del producte
            'PROPI' as origen_recurs,
            'COCO_PROD' as source,                  
            autors_producte.url as url_idioma_recurs,               -- COCO: Url del Producte
            autors_producte.url as url,                             -- COCO: Url del Producte
            autors_suport_producte_i18n.descripcio as descripcio_suport_recurs,
            autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs,
            autors_tipus_tramesa_i18n.descripcio as DESCRIPCIO,
            initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs,
            autors_producte.producte_origen_id,                     -- COCO: Id del producte origen
            autors_producte.versio_creacio_id,                      -- COCO: Id del pla de publicació en que es va crear
            autors_producte.codi_migracio,                          -- COCO: Codi de migració
            autors_producte.ind_material_propi,                     -- COCO: Per altes de materials no propis
            autors_producte.baixa,                                  -- COCO: Indicador de Baixa
            autors_producte.paraula_clau,                           -- COCO: Paraula Clau
            autors_producte.codi_recurs_origen,                     -- COCO: Codi recurs Origen 
            autors_producte.num_contracte,                          -- COCO: Codi contracte autoria
            autors_producte.data_tancament_real                     -- COCO: Data de producció del material
            
        from db_uoc_prod.stg_dadesra.autors_producte
            
        inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n
            on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id
            and autors_suport_producte_i18n.idioma = 'CAT'
        
        inner join db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n
            on autors_producte.fk_tipus_tramesa_tipus_tra__id = autors_tipus_tramesa_i18n.fk_tipus_tramesa_tipus_tra__id
            and autors_tipus_tramesa_i18n.idioma = 'CAT'
            
        inner join db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n
            on autors_producte.fk_idioma_producte_idioma_id = autors_idioma_producte_i18n.fk_idioma_producte_idioma___id
            and autors_idioma_producte_i18n.idioma = 'CAT'
        
        where ifnull(autors_producte.fk_suport_producte_suport_id,0) != 0
 
            
), 


-- ####################################################################################################
-- MODUL         
-- CREATE TABLE RECURSOS_COCO_MODULS
-- ####################################################################################################

modulos_aux as (
    select
    
    autors_modul.id as id,                          -- coco: mòdul id = producte
    autors_modul.observacions,                      -- coco: mòdul observacions = producte
    autors_modul.modul_origen_id,                   -- coco: mòdul origen
    autors_modul.versio_creacio_id,                 -- coco: mòdul id del pla de publicació en que es va crear = producte
    autors_modul.producte_creacio_id,               -- coco: mòdul id producte creació
    autors_modul.obra_id,                           -- coco: mòdul obra id
    autors_modul.descripcio,                        --coco: mòdul descripció
    autors_modul.codi_migracio,                     -- coco: mòdul codi de migració = producte
    'na'  as titol_recurs,
    'PROPI' as origen_recurs,
    'COCO_MOD' as source,                  
    'na'  as  url_idioma_recurs,
    'na'  as descripcio_suport_recurs,
    'na'  as descripcio_tramesa_recurs,
    'na'  as descripcio_idioma_recurs,

    -- revisar francesc
    'na'  as producte_origen_id,
    'na'  as codi_recurs_origen, 
    'na'  as num_contracte 

    from db_uoc_prod.stg_dadesra.autors_modul autors_modul
 
) 

select  
 
 
    AUTORS_MODUL.ID as codi_recurs,                     -- Id del Mòdulo (Camp ja definit)
    AUTORS_MODUL.DESCRIPCIO as titol_recurs,            -- (Camp ja definit) (Corresponde al campo Título en la tabla Producte)  --> PROBLEMA EN MODULOS, COMO LO SACO / RELACIONO
    'PROPI' as origen_recurs,                           -- Tipus de recurs  (Camp ja definit)
    autors_producte.url as url_idioma_recurs,           -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                                   --> SOLO EN PROD, NO EN MODULOS
    autors_producte.descripcio as descripcio_tramesa_recurs,  --(Campo a recuperar de PRODUCTO)
    autors_producte.descripcio as descripcio_suport_recurs,                 -- (Campo a recuperar de PRODUCTO)
    initcap(autors_producte.descripcio) as descripcio_idioma_recurs,
    AUTORS_MODUL.PRODUCTE_CREACIO_ID,                   --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte

    autors_producte.baixa,                              -- (Campo a recuperar de PRODUCTO) COCO: Indicador de Baixa
    autors_producte.num_contracte,                      -- (Campo a recuperar de PRODUCTO) COCO: Codi contracte autoria
    autors_producte.data_tancament_real,                 -- (Campo a recuperar de PRODUCTO) COCO: Data de producció del material
    AUTORS_MODUL.OBSERVACIONS,                          --  Observacions del mòdul (Campo específico de módulo)
    AUTORS_MODUL.MODUL_ORIGEN_ID,                       -- Id del mòdul que original (Campo específico de módulo)
    coalesce(AUTORS_MODUL.VERSIO_CREACIO_ID, autors_producte.versio_creacio_id) AS VERSIO_CREACIO_ID,               --  (Campo a recuperar de PRODUCTO) COCO: Id del pla de publicació en que es va crear) -- Id del pla de publicació de creació (Campo específico de módulo)
    AUTORS_MODUL.OBRA_ID,                               -- Id de la obra (Campo específico de módulo)
    AUTORS_MODUL.CODI_MIGRACIO                          -- (Corresponde al Codigo migración de producto)


from productos_aux autors_producte
inner join modulos_aux AUTORS_MODUL  on autors_producte.codi_recurs = AUTORS_MODUL.PRODUCTE_CREACIO_ID 


;






-- drop table DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS;