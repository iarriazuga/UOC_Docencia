-- -- #################################################################################################
-- -- #################################################################################################
-- -- F_DADES_ACADEMIQUES_DIMAX
-- -- #################################################################################################
-- -- #################################################################################################
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_DIMAX AS  -- DDP_DOCENCIA

with node_structure_aplanation AS ( 
SELECT 
    db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.id_resource,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami,
    db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs,
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
            db_uoc_prod.stg_dadesra.dimax_item_dimax.titol like '%Root Node:PV%' --- eliminamos : Root Node:BIBLIO
        ) 

) , 

node_structure_asignaturas AS ( 
    
    SELECT distinct  
        CAMI_NODE 
        , NODE_RECURS  
        , DIM_ASSIGNATURA_KEY  
 
    FROM node_structure_aplanation  -- 3M
    
    where length (cami_node ) =  25
) 

,  node_structure_resources  AS ( 
    SELECT distinct  
        CAMI_NODE
        , ID_RESOURCE  
        , NODE_CAMI  
        , NODE_RECURS
        , DIM_ASSIGNATURA_KEY AS nombre_resource   
 
        , titol_resource  
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-1) AS node_semestre_root
        , id_recurs2 -- mucho renombre en el titulo de las asignaturas  3.3M  vs 
       
    FROM node_structure_aplanation

    where length(cami_node) >  25
)

,  node_structure_semestres  AS ( 
    SELECT distinct 
        CAMI_NODE
        , ID_RESOURCE  
        , NODE_CAMI  
        , NODE_RECURS
        , NODE_RECURS as node_semestre_root  
        -- , titol
        , REPLACE(titol, 'Root Node:PV', '') as DIM_SEMESTRE_KEY 

    FROM node_structure_aplanation   
    where titol like '%Root Node:PV%' 
 
)   


SELECT distinct 
    node_structure_semestres.DIM_SEMESTRE_KEY
    , node_structure_asignaturas.DIM_ASSIGNATURA_KEY
    , 'DIMAX'|| '-'||  node_structure_resources.ID_RESOURCE as DIM_RECURSOS_APRENENTATGE_KEY

    , node_structure_resources.cami_node
    , node_structure_resources.ID_RESOURCE
    , node_structure_resources.titol_resource   



FROM node_structure_resources --  6,277,408 vs  6,277,242

    inner join node_structure_asignaturas on right(node_structure_resources.cami_node, 25) = node_structure_asignaturas.cami_node 
    inner join node_structure_semestres on  node_structure_resources.node_semestre_root = node_structure_semestres.node_semestre_root 
    -- 1,6k La aplicación tinene 20 años y antes se usaba para otras cosas, está oboslteo lo que está bajo BIBLIO
    -- Hola, correcto el nodo BIBLIO es algo histórico y de cuando Diamx se usaba para otra función.... Ignoaramos el nodo Biblio.

where  node_structure_resources.id_recurs2 is not null 
 
 
 