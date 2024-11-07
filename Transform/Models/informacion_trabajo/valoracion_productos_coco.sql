-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################
 
-- CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS AS
With productos_aux as ( --que hace unico a un recurso 
        select                              -- agafa els mateixos camps per conservar la estructura però dades de COCO (taules Autors)
            autors_producte.id as codi_recurs,                      --   autors_producte.ID,                 -- COCO: id del producte
            autors_producte.titol as titol_recurs,                  --   autors_producte.TITOL,                 -- COCO: Títol del producte
            'PROPI' as origen_recurs,
            'COCO_PROD' as source_recurs,
            autors_producte.versio_creacio_id,                      -- COCO: Id del pla de publicació en que es va crear                  
            -- revisar 
            'AUTORS_MODUL.PRODUCTE_CREACIO_ID' as codi_recurs2,                   --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte
            autors_producte.producte_origen_id,                     -- COCO: Id del producte origen


            autors_producte.url as url_idioma_recurs,               -- COCO: Url del Producte
            autors_producte.url as url,                             -- COCO: Url del Producte
            
            autors_suport_producte_i18n.descripcio as descripcio_suport_recurs,
            autors_tipus_tramesa_i18n.descripcio as descripcio_tramesa_recurs,
            autors_tipus_tramesa_i18n.descripcio as DESCRIPCIO,
            initcap(autors_idioma_producte_i18n.descripcio) as descripcio_idioma_recurs,

            
            autors_producte.producte_origen_id,                     -- COCO: Id del producte origen
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
    SELECT 
    
        AUTORS_MODUL.ID as codi_recurs,                     -- Id del Mòdulo (Camp ja definit)
        AUTORS_MODUL.DESCRIPCIO as titol_recurs,            -- (Camp ja definit) (Corresponde al campo Título en la tabla Producte)  --> PROBLEMA EN MODULOS, COMO LO SACO / RELACIONO
        'PROPI' as origen_recurs,                           -- Tipus de recurs  (Camp ja definit)
        'COCO_MOD'  as source_recurs,                       -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                                   --> SOLO EN PROD, NO EN MODULOS
        AUTORS_MODUL.versio_creacio_id,                      -- COCO: Id del pla de publicació en que es va crear
        -- revisar 
        AUTORS_MODUL.PRODUCTE_CREACIO_ID as codi_recurs2,                   --  (Campo a recuperar de PRODUCTO) Producto padre - fk de producte
        autors_producte.producte_origen_id,                     -- COCO: Id del producte origen
        
        autors_producte.url as url_idioma_recurs,           -- url_idioma_recurs* : NO VALID (Campo a recuperar de PRODUCTO)                                                   --> SOLO EN PROD, NO EN MODULOS
        autors_producte.url as url,                             -- COCO: Url del Producte
        autors_producte.descripcio as descripcio_tramesa_recurs,  --(Campo a recuperar de PRODUCTO)
        autors_producte.descripcio as descripcio_suport_recurs,                 -- (Campo a recuperar de PRODUCTO)
        initcap(autors_producte.descripcio) as descripcio_idioma_recurs,
        autors_producte.descripcio_tramesa_recurs as descripcio_tramesa_recurs,
        autors_producte.DESCRIPCIO as DESCRIPCIO,
        autors_producte.codi_migracio,                          -- COCO: Codi de migració
        autors_producte.ind_material_propi,                     -- COCO: Per altes de materials no propis
        autors_producte.baixa,                                  -- COCO: Indicador de Baixa
        autors_producte.baixa,                              -- (Campo a recuperar de PRODUCTO) COCO: Indicador de Baixa
        autors_producte.paraula_clau,                           -- COCO: Paraula Clau
        autors_producte.codi_recurs_origen,                     -- COCO: Codi recurs Origen 
        autors_producte.num_contracte,                      -- (Campo a recuperar de PRODUCTO) COCO: Codi contracte autoria
        autors_producte.data_tancament_real,                 -- (Campo a recuperar de PRODUCTO) COCO: Data de producció del material



        AUTORS_MODUL.OBSERVACIONS,                          --  Observacions del mòdul (Campo específico de módulo)
        AUTORS_MODUL.MODUL_ORIGEN_ID,                       -- Id del mòdul que original (Campo específico de módulo)
        AUTORS_MODUL.OBRA_ID,                               -- Id de la obra (Campo específico de módulo)
        AUTORS_MODUL.CODI_MIGRACIO                          -- (Corresponde al Codigo migración de producto)


/*
    -- revisar francesc
    'na'  as producte_origen_id,
    'na'  as codi_recurs_origen, 
    'na'  as num_contracte 
    
    etl
    pre - stg: cargar    
    post - tranfrom --> idilicamente de un incremental  ( insert no uptdate )
    dim / fact  - transformacion --> estandarizacion  

    1 ; 
*/
    AUTORS_MODUL.id as id,                          -- coco: mòdul id = producte
    AUTORS_MODUL.observacions,                      -- coco: mòdul observacions = producte
    AUTORS_MODUL.modul_origen_id,                   -- coco: mòdul origen
    AUTORS_MODUL.versio_creacio_id,                 -- coco: mòdul id del pla de publicació en que es va crear = producte
    AUTORS_MODUL.producte_creacio_id,               -- coco: mòdul id producte creació
    AUTORS_MODUL.obra_id,                           -- coco: mòdul obra id
    AUTORS_MODUL.descripcio,                        --coco: mòdul descripció
    AUTORS_MODUL.codi_migracio,                     -- coco: mòdul codi de migració = producte

 
from productos_aux autors_producte
inner join db_uoc_prod.stg_dadesra.AUTORS_MODUL AUTORS_MODUL  on autors_producte.codi_recurs = AUTORS_MODUL.PRODUCTE_CREACIO_ID 

    
) 

select * from modulos_aux
UNION ALL
select * from productos_aux
 
 


;

-- drop table DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS;

select  titol, count(*) 
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

-- where titol like 'Orientaciones'
group by 1 
order by 2 desc 

limit 100;


select * -- titol, count(*) 
from db_uoc_prod.stg_dadesra.autors_producte
where titol like 'Orientaciones'



--- 
select count(*) as numero , '1' as src from db_uoc_prod.stg_dadesra.autors_producte union all  -- autors_suport_producte_i18n
select count(*) as numero , '2' as src from db_uoc_prod.stg_dadesra.autors_suport_producte_i18n  union all        
select count(*) as numero , '3' as src from db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n union all 
select count(*) as numero , '4' as src from db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n  

/*

NUMERO	SRC
55610	 1
93	     2
4	     3
13	     4

*/


select    count(*) 
from db_uoc_prod.stg_dadesra.autors_producte

inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 
on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id -- vs 197397 
            and autors_suport_producte_i18n.idioma = 'CAT'  -- 51568 




select   * -- distinct idioma, descripcio  
from  db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 


select    * 
from db_uoc_prod.stg_dadesra.autors_producte

inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 
on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id -- vs 197397 
            and autors_suport_producte_i18n.idioma = 'CAT'  -- 51568 


            
select    * --- distinct FK_IDIOMA_PRODUCTE_IDIOMA_ID
from db_uoc_prod.stg_dadesra.autors_producte
/*

FK_IDIOMA_PRODUCTE_IDIOMA_ID
2
3
1
4
Null 
62
61
*/
 









select  db_uoc_prod.stg_dadesra.autors_producte.id , count(*)
from db_uoc_prod.stg_dadesra.autors_producte

inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 
on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id -- vs 197397 
            and autors_suport_producte_i18n.idioma = 'CAT'  -- 51568 

group by 1  having count(*) > 1


-- no duplicadoss







select  db_uoc_prod.stg_dadesra.autors_producte.id , count(*)
from db_uoc_prod.stg_dadesra.autors_producte

inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 
on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id -- vs 197397 tipo de productos  
            and autors_suport_producte_i18n.idioma = 'CAT'  -- 51568 

        
        inner join db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n
            on autors_producte.fk_tipus_tramesa_tipus_tra__id = autors_tipus_tramesa_i18n.fk_tipus_tramesa_tipus_tra__id
            and autors_tipus_tramesa_i18n.idioma = 'CAT' -- no duplicates 
            
        inner join db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n
            on autors_producte.fk_idioma_producte_idioma_id = autors_idioma_producte_i18n.fk_idioma_producte_idioma___id
            and autors_idioma_producte_i18n.idioma = 'CAT'

            
group by 1  having count(*) > 1


/*** RECURSOS ***/
select  *
from db_uoc_prod.stg_dadesra.autors_producte

inner join db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 
on autors_producte.fk_suport_producte_suport_id = autors_suport_producte_i18n.fk_suport_producte_suport_id -- vs 197397 tipo de productos  
            and autors_suport_producte_i18n.idioma = 'CAT'  -- 51568 

        
        inner join db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n
            on autors_producte.fk_tipus_tramesa_tipus_tra__id = autors_tipus_tramesa_i18n.fk_tipus_tramesa_tipus_tra__id
            and autors_tipus_tramesa_i18n.idioma = 'CAT' -- no duplicates  35,257
            
        inner join db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n
            on autors_producte.fk_idioma_producte_idioma_id = autors_idioma_producte_i18n.fk_idioma_producte_idioma___id
            and autors_idioma_producte_i18n.idioma = 'CAT'  -- 35,238 




select * from  db_uoc_prod.stg_dadesra.autors_suport_producte_i18n 

/*
Cd-Rom programaire
Cd-Rom software
Cd-Rom software
Cd-Rom programari
Informatique
Computer
Informático
Informàtic
Word
Word

*/

select * from db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n
/*
Publicació a l'aula
Publicación en el aula
Tramesa postal
Tramesa postal

*/


select * from db_uoc_prod.stg_dadesra.autors_idioma_producte_i18n
/*

alemán
alemany
chino
xinès
japonès
català

*/



with aux as (

select AUTORS_MODUL.ID as ID_test from db_uoc_prod.stg_dadesra.AUTORS_MODUL AUTORS_MODUL  inner join db_uoc_prod.stg_dadesra.autors_producte on autors_producte.id = AUTORS_MODUL.PRODUCTE_CREACIO_ID 
union all 
select autors_producte.id as ID_test from   db_uoc_prod.stg_dadesra.autors_producte   


)
select ID_test, count(*) from aux 
group by 1
having count (*) > 1



select * from db_uoc_prod.stg_dadesra.AUTORS_MODUL 
where  db_uoc_prod.stg_dadesra.AUTORS_MODUL.ID like '122668'

select * from  db_uoc_prod.stg_dadesra.autors_producte  
where db_uoc_prod.stg_dadesra.autors_producte .ID like '122668'

select * from db_uoc_prod.stg_dadesra.AUTORS_MODUL 
where  db_uoc_prod.stg_dadesra.AUTORS_MODUL.PRODUCTE_CREACIO_ID like '122635'

select * from  db_uoc_prod.stg_dadesra.autors_producte  
where db_uoc_prod.stg_dadesra.autors_producte.ID like '122635'

select count(*) 
from db_uoc_prod.stg_dadesra.AUTORS_MODUL 
inner join db_uoc_prod.stg_dadesra.autors_producte on autors_producte.id = AUTORS_MODUL.ID 





with aux as (

select AUTORS_MODUL.ID as ID_test from db_uoc_prod.stg_dadesra.AUTORS_MODUL AUTORS_MODUL  inner join db_uoc_prod.stg_dadesra.autors_producte on autors_producte.id = AUTORS_MODUL.PRODUCTE_CREACIO_ID 
union all 
select autors_producte.id as ID_test from   db_uoc_prod.stg_dadesra.autors_producte   


)
select ID_test, count(*) from aux 
group by 1
having count (*) > 1


 