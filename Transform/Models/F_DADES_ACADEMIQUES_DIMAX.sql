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


CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX AS  -- DDP_DOCENCIA

with aux AS ( 
SELECT 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.id_resource,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs,
    -- db_uoc_prod.stg_dadesra.dimax_resofite_path.ordre,
    db_uoc_prod.stg_dadesra.dimax_item_dimax.titol,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs AS id_recurs2,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.titol AS titol_resource,
    SUBSTR(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, 0, 6) AS assigntura_codi,

    CAST(YEAR(db_uoc_prod.stg_dadesra.dimax_item_dimax.data) AS VARCHAR(4)) ||  CASE WHEN MONTH(db_uoc_prod.stg_dadesra.dimax_item_dimax.data) <= 6 THEN '1' ELSE '2' END AS SEMESTRE, --- revisar 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.data, 
    -- SUBSTRING(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, CHARINDEX(':PV', db_uoc_prod.stg_dadesra.dimax_item_dimax.titol)  + 3) AS semester,

 


    'DIMAX' AS font 
 
FROM db_uoc_prod.stg_dadesra.dimax_resofite_path  --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400

where 1=1
and length( cami_node ) >=  25
 

) , 

asignaturas AS ( 
    SELECT distinct  
        CAMI_NODE,
        -- ID_RESOURCE, 
        -- NODE_CAMI, 
        NODE_RECURS, 
        ASSIGNTURA_CODI, 
        SEMESTRE, 
        FONT  
    FROM aux a1 -- 3M
    where 1=1
    and length( cami_node ) =  25
) 

,  resources  AS ( 
    SELECT distinct  
        CAMI_NODE,
        ID_RESOURCE, 
        NODE_CAMI, 
        NODE_RECURS,
        ASSIGNTURA_CODI AS nombre_resource,   
        SEMESTRE, 
        FONT, 
        titol_resource, 
        id_recurs2 -- mucho renombre en el titulo de las asignaturas  3.3M  vs 
       
    FROM aux a1  
    where 1=1
    and length( cami_node )>  25
)   


-- SELECT * FROM asignaturas -- 265.9K vs ID_RESOURCE: 617.3K vs NODE_CAMI & NODE_RECURS : 3.3M  vs NODE_CAMI: trae muchos duplicados 
-- SELECT distinct right(resources.cami_node, 25) FROM  resources  -- 308.8K asignaturas vs  265.9K in asignatura 

 
SELECT distinct 
    resources.semestre
    , resources.ID_RESOURCE
    , resources.titol_resource   
    , ASSIGNTURA_CODI
    , asignaturas.semestre AS semestre_asignatura

FROM resources --  6,277,408 vs  6,277,242

inner join asignaturas 
    on 1=1 
        and right(resources.cami_node, 25) = asignaturas.cami_node 
        --217.6M --> created with 3.3M  vs  265.9K = 5,7M --> asignaturas mantenemos 
        -- and asignaturas.semestre = resources.semestre

where  id_recurs2 is not null 
-- and resources.SEMESTRE >= 20221
 
-- SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX  --- 

/*

    asignatura
    , semestre_id
    , codi_producto_coco
    , titulo_prod_coco
    , plan_estudios_base

*/