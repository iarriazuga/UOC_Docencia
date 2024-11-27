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
        db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node
        , dimax_resofite_path_unified.node_cami
        , dimax_resofite_path_unified.node_recurs 
        , db_uoc_prod.stg_dadesra.dimax_item_dimax.titol
        , ARRAY_SIZE(SPLIT(db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node, ';'))  as length_resources
        -- db_uoc_prod.stg_dadesra.dimax_v_recurs.titol AS titol_resource,

 
    FROM dimax_resofite_path_unified   --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax 
        on dimax_resofite_path_unified.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    /*
    
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs 
        on dimax_resofite_path_unified.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra 
        on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400
    */


    where  ( 
        ARRAY_SIZE(SPLIT(db_uoc_prod.stg_dadesra.dimax_item_dimax.cami_node, ';')) = 5 
        or  
        db_uoc_prod.stg_dadesra.dimax_item_dimax.titol like '%Root Node:PV%'  --- evitar semestres   "Root Node:BIBLIO" --> falla la distancia 
    )
) 

, node_structure_asignaturas AS ( 
 
    SELECT distinct-- 3,731,701 vs  3,731,701 vs ( quitando cami node )
 
        SUBSTR(titol, 0, 6) AS DIM_ASSIGNATURA_KEY
        , NODE_CAMI  -- recurso:  
        , SPLIT_PART(CAMI_NODE, ';', ARRAY_SIZE(SPLIT(CAMI_NODE, ';'))-1) AS NODE_RECURS_SEMESTRE -- 355,563  vs 3,465,109
        -- , NODE_RECURS  --  3,465,109 ( identificador del grafo)
        -- , titol  -- ligeramente diferente 3,541,969 vs 3,465,109
 
    FROM node_structure_aplanation   

    where length_resources = 5
 
 

) 


,  node_structure_semestres  AS ( 
    SELECT distinct -- 42

        NODE_RECURS as NODE_RECURS_SEMESTRE  
        , REPLACE(titol, 'Root Node:PV', '') as DIM_SEMESTRE_KEY 

    FROM node_structure_aplanation   
    where titol like '%Root Node:PV%'  --- evitar semestres   "Root Node:BIBLIO" --> falla la distancia 

)   


SELECT   

    'DIMAX'|| '-'||  node_structure_asignaturas.node_cami as DIM_RECURSOS_APRENENTATGE_KEY
    , node_structure_semestres.DIM_SEMESTRE_KEY
    , node_structure_asignaturas.DIM_ASSIGNATURA_KEY

    , node_structure_asignaturas.node_cami as CODI_RECURS --- as recurso de aprendizaje 
    -- , node_structure_asignaturas.NODE_RECURS_SEMESTRE
    -- , node_structure_asignaturas.NODE_RECURS -- eliminamos : genera duplicados  
    -- , node_structure_asignaturas.cami_node -- uso para path : genera duplicados  
    -- , node_structure_asignaturas.titol_resource    -- eliminamos : genera duplicados  

    FROM  node_structure_asignaturas   --- 3,390,446

    inner join node_structure_semestres on  node_structure_asignaturas.NODE_RECURS_SEMESTRE = node_structure_semestres.NODE_RECURS_SEMESTRE  
    



/*

FRANCESC: La aplicación tinene 20 años y antes se usaba para otras cosas, está obsoleto lo que está bajo BIBLIO, es algo histórico y de cuando Diamx se usaba para otra función.... 
Ignoramos el nodo Biblio.

NODE_RECURS_SEMESTRE	COUNT(*)	TITOL  --> cambian los nums 75,569 
30058	                43	        Root Node:PROVES
438561	                15631	    Root Node:FPNOV10
817691	                17331	    Root Node:FPNOV11
384004	                15049	    Root Node:FPMAR10
247308	                13378	    Root Node:FPMAR09
30043	                28285	    Root Node:BIBLIO
768692	                15557	    Root Node:FPMAR11
296535	                15286	    Root Node:FPNOV09

*/