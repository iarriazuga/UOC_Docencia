-- -- #################################################################################################
-- -- #################################################################################################
-- -- F_DADES_ACADEMIQUES_DIMAX
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX AS  -- DDP_DOCENCIA

with node_structure_aplanation AS ( 
SELECT 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node,
    -- db_uoc_prod.stg_dadesra.dimax_resofite_path.id_resource,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami as id_resource,  -- id_ que equivale a la tabla de dim_catalog 
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs, -- same as  db_uoc_prod.stg_dadesra.dimax_item_dimax.id 
    -- db_uoc_prod.stg_dadesra.dimax_resofite_path.ordre,
    db_uoc_prod.stg_dadesra.dimax_item_dimax.titol,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs AS id_recurs2,
    db_uoc_prod.stg_dadesra.dimax_v_recurs.titol AS titol_resource,
    SUBSTR(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, 0, 6) AS DIM_ASSIGNATURA_KEY
 
    FROM db_uoc_prod.stg_dadesra.dimax_resofite_path    --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax 
        on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs 
        on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra 
        on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400

    where 1=1
        and ( 
            length( db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node ) >=  25
            or 
            db_uoc_prod.stg_dadesra.dimax_item_dimax.titol like '%Root Node:PV%' --- eliminamos : Root Node:BIBLIO, usamos like pq hay muchos cami_node en null 
        )  
        and db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs =  69226
        and db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node = ';3067899;3050333;3050332;'
) 

, node_structure_resources  AS ( 
    SELECT distinct  
        CAMI_NODE
        , ID_RESOURCE  
        , NODE_CAMI  
        , NODE_RECURS
        , DIM_ASSIGNATURA_KEY AS nombre_resource   
 
        , titol_resource  
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-1) AS NODE_RECURS_SEMESTRE
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-2) AS NODE_RECURS_intermedio
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-3) AS NODE_RECURS_ASSIGNATURA

        , id_recurs2 -- mucho renombre en el titulo de las asignaturas  3.3M  vs 
       
    FROM node_structure_aplanation

    where length(cami_node) >  25
)

-- , node_structure_asignaturas AS ( 
    
    SELECT    -- 275,315 
        CAMI_NODE , count(*)
        -- , NODE_RECURS  
        -- , DIM_ASSIGNATURA_KEY  
        -- , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-1) AS NODE_RECURS_SEMESTRE
        -- , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-2) AS NODE_RECURS_intermedio
        -- , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-3) AS NODE_RECURS_ASSIGNATURA
 
    FROM node_structure_aplanation  -- 3M
    
    where length (CAMI_NODE ) =  25 or length (CAMI_NODE ) =  24
    group by 1 
    order by 2 desc

) 


,  node_structure_semestres  AS ( 
    SELECT distinct 
        -- CAMI_NODE, 
        ID_RESOURCE  
        , NODE_CAMI  
        , NODE_RECURS
        , NODE_RECURS as NODE_RECURS_SEMESTRE  
        -- , titol
        , REPLACE(titol, 'Root Node:PV', '') as DIM_SEMESTRE_KEY 

    FROM node_structure_aplanation   
    where titol like '%Root Node:PV%' 
 ;3067899;3050333;3050332;
)   


SELECT  -- distinct 6,442,805 vs 6442805
    'DIMAX'|| '-'||  node_structure_resources.ID_RESOURCE as DIM_RECURSOS_APRENENTATGE_KEY

    -- , node_structure_semestres.DIM_SEMESTRE_KEY
    -- , node_structure_asignaturas.DIM_ASSIGNATURA_KEY


    , node_structure_resources.cami_node
    , node_structure_resources.ID_RESOURCE
    , node_structure_resources.titol_resource   



FROM node_structure_resources 

    left join node_structure_asignaturas on right(node_structure_resources.cami_node, 25) = node_structure_asignaturas.cami_node  -- 6,442,805 ( base ) vs 5,893,628 --> perdemos 600K ( same distinct / no distinct )
    -- inner join node_structure_semestres on  node_structure_resources.NODE_RECURS_SEMESTRE = node_structure_semestres.NODE_RECURS_SEMESTRE  -- 5,893,628 ( base ) vs 5,891,997 
    -- 1,6k La aplicación tinene 20 años y antes se usaba para otras cosas, está oboslteo lo que está bajo BIBLIO
    -- Hola, correcto el nodo BIBLIO es algo histórico y de cuando Diamx se usaba para otra función.... Ignoaramos el nodo Biblio.

where  node_structure_asignaturas.cami_node is null
-- and node_structure_resources.id_recurs2 is not null 
 
 
select * from  DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX -- 5,891,899