/*
DADES_ACADEMIQUES:
    Asignatura
    profesores 
    estudios 
    recursos que usa 


Relacionar tablas: 
- que recursos se acceden ( live_events, cursos, etc)
- que recursos de las asignaturas se usan 


*/


-- CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_DIMAX_DADES_ACADEMIQUES AS  -- DDP_DOCENCIA

with aux as ( 
select 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.id_resource,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs,
    -- db_uoc_prod.stg_dadesra.dimax_resofite_path.ordre,
    db_uoc_prod.stg_dadesra.dimax_item_dimax.titol,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs as id_recurs2,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.titol as titol_resource,
    SUBSTR(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, 0, 6) AS assigntura_codi,

    CAST(YEAR(db_uoc_prod.stg_dadesra.dimax_item_dimax.data) AS VARCHAR(4)) ||  CASE WHEN MONTH(db_uoc_prod.stg_dadesra.dimax_item_dimax.data) <= 6 THEN '1' ELSE '2' END AS SEMESTRE, --- revisar 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.data, 
    -- SUBSTRING(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, CHARINDEX(':PV', db_uoc_prod.stg_dadesra.dimax_item_dimax.titol)  + 3) AS semester,

 
    'DIMAX' AS font 
 
from db_uoc_prod.stg_dadesra.dimax_resofite_path  --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400

where 1=1
and length( cami_node ) >=  25
 

) , 

asignaturas as ( 
    select distinct  
        CAMI_NODE,
        -- ID_RESOURCE, 
        -- NODE_CAMI, 
        NODE_RECURS, 
        ASSIGNTURA_CODI, 
        SEMESTRE, 
        FONT  
    from aux a1 -- 3M
    where 1=1
    and length( cami_node ) =  25
) , 

resources  as ( 
    select distinct  
        CAMI_NODE,
        ID_RESOURCE, 
        NODE_CAMI, 
        NODE_RECURS,
        ASSIGNTURA_CODI as nombre_resource,   
        SEMESTRE, 
        FONT, 
        titol_resource, 
        id_recurs2 -- mucho renombre en el titulo de las asignaturas  3.3M  vs 
       
    from aux a1  
    where 1=1
    and length( cami_node )>  25
)   


-- select * from asignaturas -- 265.9K vs ID_RESOURCE: 617.3K vs NODE_CAMI & NODE_RECURS : 3.3M  vs NODE_CAMI: trae muchos duplicados 
-- select distinct right(resources.cami_node, 25) from  resources  -- 308.8K asignaturas vs  265.9K in asignatura 

 
select distinct 
    ASSIGNTURA_CODI
    , asignaturas.semestre

from resources --  6,277,408 vs  6,277,242

inner join asignaturas on 1=1 
    and right(resources.cami_node, 25) = asignaturas.cami_node --217.6M --> created with 3.3M  vs  265.9K = 5,7M --> asignaturas mantenemos 
    -- and asignaturas.semestre = resources.semestre

where   id_recurs2 is not null 
-- and resources.SEMESTRE >= 20221
 
