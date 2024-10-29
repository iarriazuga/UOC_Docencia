
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

-- -- dim_recurs_aprenentatge --> conseguir 3 fuentes 
-- -- locazizar + diagrama + vista aerea de las tablas 
-- -- prefijos tablas origen tienen prefijo STG_ 
-- /*

-- select
--   AUTORS_MODUL.ID, -- COCO: Mòdul id = PRODUCTE
--   AUTORS_MODUL.OBSERVACIONS, -- COCO: Mòdul Observacions = PRODUCTE
--   AUTORS_MODUL.MODUL_ORIGEN_ID, -- COCO: Mòdul origen
--   AUTORS_MODUL.VERSIO_CREACIO_ID, -- COCO: Mòdul Id del pla de publicació en que es va crear = PRODUCTE
--   AUTORS_MODUL.PRODUCTE_CREACIO_ID, -- COCO: Mòdul id producte creació
--   AUTORS_MODUL.OBRA_ID, -- COCO: Mòdul obra id
--   AUTORS_MODUL.DESCRIPCIO, -- COCO: Mòdul descripció
--   AUTORS_MODUL.CODI_MIGRACIO -- COCO: Mòdul Codi de migració = PRODUCTE
-- from db_uoc_prod.stg_dadesra.autors_modul
-- limit 100;

-- */

-- select * from db_uoc_prod.stg_dadesra.dimax_v_recurs dim_max  
-- inner join db_uoc_prod.stg_dadesra.autors_modul aut_mod  on  dim_max.ID_RECURS = aut_mod.ID
-- inner join db_uoc_prod.stg_dadesra.AUTORS_MODULS_PRODUCTES aut_mod_prod  on  aut_mod_prod.PRODUCTE_ID = aut_mod.PRODUCTE_CREACIO_ID




-- create or replace view DB_UOC_PROD.DDP_UNEIX.V_FITXER29_VALORS_BASE2(
-- 	IDP,
-- 	ANY_ACADEMICO,
-- 	DNI,
-- 	COD_PLAN,
-- 	COD_ASIGNATURA,
-- 	DESC_ASIGNATURA,
-- 	NIVELL,
-- 	COD_CALIFICACION,
-- 	IND_SUPERA,
-- 	N,
-- 	COD_AULA,
-- 	CODIGRUP
-- ) as






-- -- procedimiento
-- -- export to csv --> copy to csv --> path aun no visto 

-- -- ## DIMAX
-- select * from db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax limit 100;
 



-- #################################################################################################
-- #################################################################################################
-- INICIO_SQL
-- #################################################################################################
-- #################################################################################################

-- CREATE TABLE RECURSOS_COCO_PRODUCTES
With productos_aux as ( 
        select      // agafa els mateixos camps per conservar la estructura però dades de COCO (taules Autors)
            autors_producte.id as codi_recurs,  //   autors_producte.ID, -- COCO: id del producte
            autors_producte.titol as titol_recurs, //   autors_producte.TITOL, -- COCO: Títol del producte
            'PROPI' as origen_recurs, -- 
            autors_producte.url as url_idioma_recurs, -- COCO: Url del Producte
            autors_suport_producte_i18n.descripcio as descripcio_suport_recurs,
            autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs,
            initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs,
            autors_producte.producte_origen_id, -- COCO: Id del producte origen
            autors_producte.versio_creacio_id, -- COCO: Id del pla de publicació en que es va crear
            autors_producte.codi_migracio, -- COCO: Codi de migració
            autors_producte.ind_material_propi, -- COCO: Per altes de materials no propis
            autors_producte.baixa, -- COCO: Indicador de Baixa
            autors_producte.paraula_clau, -- COCO: Paraula Clau
            autors_producte.codi_recurs_origen, -- COCO: Codi recurs Origen 
            autors_producte.num_contracte, -- COCO: Codi contracte autoria
            autors_producte.data_tancament_real -- COCO: Data de producció del material
            
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
-- MODUL         
-- CREATE TABLE RECURSOS_COCO_MODULS

modulos_aux as (
    select
    
    autors_modul.id as codi_recurs, -- coco: mòdul id = producte
    autors_modul.observacions, -- coco: mòdul observacions = producte
    autors_modul.modul_origen_id, -- coco: mòdul origen
    autors_modul.versio_creacio_id, -- coco: mòdul id del pla de publicació en que es va crear = producte
    autors_modul.producte_creacio_id, -- coco: mòdul id producte creació
    autors_modul.obra_id, -- coco: mòdul obra id
    autors_modul.descripcio, -- coco: mòdul descripció
    autors_modul.codi_migracio, -- coco: mòdul codi de migració = producte
    'na'  as titol_recurs,
    'PROPI' as origen_recurs, -- 
    'na'  as  url_idioma_recurs,
    'na'  as descripcio_suport_recurs,
    'na'  as descripcio_tramesa_recurs,
    'na'  as descripcio_idioma_recurs,

    -- revisar francesc
    'na'  as producte_origen_id,
    'na'  as codi_recurs_origen, 
    'na'  as num_contracte,
    null  as data_tancament_real,

    from db_uoc_prod.stg_dadesra.autors_modul
 
) 





 
select 
    codi_recurs,
    titol_recurs,
    origen_recurs,
    url_idioma_recurs,
    descripcio_suport_recurs,
    descripcio_tramesa_recurs,
    descripcio_idioma_recurs,
    producte_origen_id,
    versio_creacio_id,
    codi_migracio,
    codi_recurs_origen,
    num_contracte,
    data_tancament_real,
    'COCO_PROD' as source  -- columna que indica el origen del registro
from productos_aux



union all 


select 
    codi_recurs,
    titol_recurs,
    origen_recurs,
    url_idioma_recurs,
    descripcio_suport_recurs,
    descripcio_tramesa_recurs,
    descripcio_idioma_recurs,
    producte_origen_id,
    versio_creacio_id,
    codi_migracio,
    codi_recurs_origen,
    num_contracte,
    data_tancament_real,
    'COCO_MOD' as origen  -- columna que indica el origen del registro
from modulos_aux;














AUTORS_MODUL 

AUTORS_MODUL.ID as codi_recurs, -- Id del Mòdulo (Camp ja definit)
AUTORS_MODUL.DESCRIPCIO as titol_recurs, -- (Camp ja definit) (Corresponde al campo Título en la tabla Producte)                --> PROBLEMA EN MODULOS, COMO LO SACO / RELACIONO
'PROPI' as origen_recurs, // Tipus de recurs  (Camp ja definit)
autors_producte.url as url_idioma_recurs*, (Campo a recuperar de PRODUCTO)                                                      --> SOLO EN PROD, NO EN MODULOS
autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs, (Campo a recuperar de PRODUCTO)
autors_suport_producte_i18n.descripcio as descripcio_suport_recurs, (Campo a recuperar de PRODUCTO)
initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs
AUTORS_MODUL.PRODUCTE_CREACIO_ID, --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte
autors_producte.versio_creacio_id, --  (Campo a recuperar de PRODUCTO) COCO: Id del pla de publicació en que es va crear
autors_producte.baixa, -- (Campo a recuperar de PRODUCTO) COCO: Indicador de Baixa
autors_producte.num_contracte, -- (Campo a recuperar de PRODUCTO) COCO: Codi contracte autoria
autors_producte.data_tancament_real -- (Campo a recuperar de PRODUCTO) COCO: Data de producció del material
AUTORS_MODUL.OBSERVACIONS, --  Observacions del mòdul (Campo específico de módulo)
AUTORS_MODUL.MODUL_ORIGEN_ID, -- Id del mòdul que original (Campo específico de módulo)
AUTORS_MODUL.VERSIO_CREACIO_ID, -- Id del pla de publicació de creació (Campo específico de módulo)
AUTORS_MODUL.PRODUCTE_CREACIO_ID, -- Producto padre - fk de producte
AUTORS_MODUL.OBRA_ID, -- Id de la obra (Campo específico de módulo)
AUTORS_MODUL.CODI_MIGRACIO -- (Corresponde al Codigo migración de producto)





With productos_aux as ( 
        select      // agafa els mateixos camps per conservar la estructura però dades de COCO (taules Autors)
            autors_producte.id as codi_recurs,  //   autors_producte.ID, -- COCO: id del producte
            autors_producte.titol as titol_recurs, //   autors_producte.TITOL, -- COCO: Títol del producte
            'PROPI' as origen_recurs, -- 
            autors_producte.url as url_idioma_recurs, -- COCO: Url del Producte
            autors_suport_producte_i18n.descripcio as descripcio_suport_recurs,
            autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs,
            initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs,
            autors_producte.producte_origen_id, -- COCO: Id del producte origen
            autors_producte.versio_creacio_id, -- COCO: Id del pla de publicació en que es va crear
            autors_producte.codi_migracio, -- COCO: Codi de migració
            autors_producte.ind_material_propi, -- COCO: Per altes de materials no propis
            autors_producte.baixa, -- COCO: Indicador de Baixa
            autors_producte.paraula_clau, -- COCO: Paraula Clau
            autors_producte.codi_recurs_origen, -- COCO: Codi recurs Origen 
            autors_producte.num_contracte, -- COCO: Codi contracte autoria
            autors_producte.data_tancament_real -- COCO: Data de producció del material
            
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
 
            
)
 select prod.*    from db_uoc_prod.stg_dadesra.autors_modul modul


inner join productos_aux prod  on prod.codi_recurs = modul.PRODUCTE_CREACIO_ID --- 






