-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_DADES_ACADEMIQUES_DIMAX
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX AS  -- DDP_DOCENCIA

with dimax_resofite_path_unified AS (  
    select  distinct
        db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs,  
        db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami,
        -- db_uoc_prod.stg_dadesra.dimax_resofite_path.id_resource,
        -- db_uoc_prod.stg_dadesra.dimax_resofite_path.ordre,
    from db_uoc_prod.stg_dadesra.dimax_resofite_path  -- 18,056,913 vs 12,349,852

)
, node_structure_aplanation AS ( 
    SELECT  
        db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node,

        dimax_resofite_path_unified.node_cami as id_resource,  -- id_ que equivale a la tabla de dim_catalog 
        dimax_resofite_path_unified.node_cami,
        dimax_resofite_path_unified.node_recurs, -- same as  db_uoc_prod.stg_dadesra.dimax_item_dimax.id 

        ARRAY_SIZE(SPLIT(db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node, ';'))  as length_resources, 
        
        db_uoc_prod.stg_dadesra.dimax_item_dimax.titol,
        db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs AS id_recurs2,
        db_uoc_prod.stg_dadesra.dimax_v_recurs.titol AS titol_resource,
        SUBSTR(db_uoc_prod.stg_dadesra.dimax_item_dimax.titol, 0, 6) AS DIM_ASSIGNATURA_KEY
 
    FROM dimax_resofite_path_unified   --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax 
        on dimax_resofite_path_unified.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs 
        on dimax_resofite_path_unified.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra 
        on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400
 
) 

 , node_structure_resources  AS ( 
    SELECT distinct  
        CAMI_NODE
        , ID_RESOURCE  
        , NODE_CAMI  
        , NODE_RECURS
        , DIM_ASSIGNATURA_KEY AS nombre_resource   
        , ARRAY_SIZE(SPLIT(cami_node, ';'))  as length_resources
        , titol_resource  
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-1) AS NODE_RECURS_SEMESTRE
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-2) AS NODE_RECURS_intermedio
        , SPLIT_PART(cami_node, ';', ARRAY_SIZE(SPLIT(cami_node, ';'))-3) AS NODE_RECURS_ASSIGNATURA

        , id_recurs2 -- 6,462,779
       
    FROM node_structure_aplanation
    where length_resources > 5

)

, node_structure_asignaturas AS ( 
 
    SELECT distinct
 
        CAMI_NODE
        , NODE_RECURS  
        , DIM_ASSIGNATURA_KEY  
        , ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))  as length_resources
        , titol
        , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-1) AS NODE_RECURS_SEMESTRE
        , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-2) AS NODE_RECURS_intermedio
        , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-3) AS NODE_RECURS_ASSIGNATURA
 
    FROM node_structure_aplanation  -- 3,731,701 vs 310,915 ( with distinct )
    
    where length_resources = 5

 

) 

,  node_structure_semestres  AS ( 
    SELECT distinct -- 148,966

        NODE_RECURS as NODE_RECURS_SEMESTRE  
        , REPLACE(titol, 'Root Node:PV', '') as DIM_SEMESTRE_KEY 

    FROM node_structure_aplanation   
    where titol like '%Root Node:PV%'  --- evitar semestres   "Root Node:BIBLIO" --> falla la distancia 

)   


SELECT   

    'DIMAX'|| '-'||  node_structure_resources.ID_RESOURCE as DIM_RECURSOS_APRENENTATGE_KEY
    , node_structure_semestres.DIM_SEMESTRE_KEY
    , node_structure_asignaturas.DIM_ASSIGNATURA_KEY

    , node_structure_asignaturas.NODE_RECURS_SEMESTRE
    , node_structure_resources.cami_node
    , node_structure_resources.ID_RESOURCE
    , node_structure_resources.titol_resource   


    FROM  node_structure_resources  --- 6_462_779

    inner join node_structure_asignaturas -- 6_462_779 vs inner: 6_462_729 --> se pierden 50 registros
        on node_structure_resources.NODE_RECURS_SEMESTRE = node_structure_asignaturas.NODE_RECURS_SEMESTRE   
            and node_structure_resources.NODE_RECURS_intermedio = node_structure_asignaturas.NODE_RECURS_intermedio 
            and node_structure_resources.NODE_RECURS_ASSIGNATURA = node_structure_asignaturas.NODE_RECURS_ASSIGNATURA 

    inner join node_structure_semestres on  node_structure_resources.NODE_RECURS_SEMESTRE = node_structure_semestres.NODE_RECURS_SEMESTRE  -- 6_462_729 va  6_342_169 --> se pierden  120,560 
    -- 1,6k La aplicación tinene 20 años y antes se usaba para otras cosas, está obsoleto lo que está bajo BIBLIO
    -- Francesc nodo BIBLIO es algo histórico y de cuando Diamx se usaba para otra función.... Ignoramos el nodo Biblio.


/*

NODE_RECURS_SEMESTRE	COUNT(*)	TITOL
30058	                43	        Root Node:PROVES
438561	                15631	    Root Node:FPNOV10
817691	                17331	    Root Node:FPNOV11
384004	                15049	    Root Node:FPMAR10
247308	                13378	    Root Node:FPMAR09
30043	                28285	    Root Node:BIBLIO
768692	                15557	    Root Node:FPMAR11
296535	                15286	    Root Node:FPNOV09

*/