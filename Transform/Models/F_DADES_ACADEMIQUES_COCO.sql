-- -- #################################################################################################
-- -- #################################################################################################
-- -- F_DADES_ACADEMIQUES_COCO
-- -- #################################################################################################
-- -- #################################################################################################
 
CREATE  OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.F_DADES_ACADEMIQUES_COCO AS 
with cross_semestre_asignatura AS (
    
    SELECT 
        semestre.DIM_SEMESTRE_KEY
        , asignatura.codi_final AS DIM_ASSIGNATURA_KEY
     
    FROM DB_UOC_PROD.DD_OD.dim_semestre semestre
    cross join   db_uoc_prod.stg_dadesra.autors_element_formacio asignatura 
    
    where 1=1 
        and semestre.DIM_SEMESTRE_KEY is not null 
        and asignatura.codi_final is not null
    
    order by 2,1

)

, semestres_informados AS (

    SELECT 
    
        plan_publicacion.id || ' - ' || semestre.CODI_EXTERN AS plan_estudios_base
        , asignatura.CODI_FINAL AS  DIM_ASSIGNATURA_KEY
        , coco_products.id  AS ID_RESOURCE 
        , coco_products.TITOL AS TITOL_RESOURCE
        ,  semestre.CODI_EXTERN AS DIM_SEMESTRE_KEY
        , * 
     -- completar distinct de estas tablas --> SELECT * 
    FROM db_uoc_prod.stg_dadesra.autors_productes_versions productos_plan_publicacion  -- 247,364 
    
    inner join  db_uoc_prod.stg_dadesra.autors_versio plan_publicacion 
        on plan_publicacion.id =  productos_plan_publicacion.versio_id
    
    inner join  db_uoc_prod.stg_dadesra.autors_element_formacio  asignatura 
    on  asignatura.id = plan_publicacion.fk_element_formacio_element_id
    
    inner join  db_uoc_prod.stg_dadesra.autors_producte coco_products 
    on  coco_products.id = productos_plan_publicacion.PRODUCTE_ID 
    
    inner join db_uoc_prod.stg_dadesra.autors_periode semestre  
    on semestre.id = plan_publicacion.FK_PERIODE_PERIODE_ID -- no dupliciteis 247,364
 
    where 1=1  -- 247,364

    -- and coco_products.id  is null   -- 0 

)
,  cross_semestres_informados AS ( 
        SELECT  
            cross_semestre_asignatura.DIM_ASSIGNATURA_KEY
            , cross_semestre_asignatura.DIM_SEMESTRE_KEY
            , semestres_informados.ID_RESOURCE
            , semestres_informados.TITOL_RESOURCE
            , semestres_informados.plan_estudios_base
        
        FROM  cross_semestre_asignatura
        left join semestres_informados 
            on cross_semestre_asignatura.DIM_ASSIGNATURA_KEY = semestres_informados.DIM_ASSIGNATURA_KEY
                and cross_semestre_asignatura.DIM_SEMESTRE_KEY = semestres_informados.DIM_SEMESTRE_KEY
        -- where  cross_semestre_asignatura.asignatura = 'B0.911'
        
        order by  cross_semestre_asignatura.DIM_ASSIGNATURA_KEY , cross_semestre_asignatura.DIM_SEMESTRE_KEY desc

) 
 


, informed_semesters AS (
    SELECT distinct --- 246,045
        DIM_ASSIGNATURA_KEY,
        DIM_SEMESTRE_KEY AS informed_DIM_SEMESTRE_KEY,
        ID_RESOURCE,
        TITOL_RESOURCE,
        plan_estudios_base
    FROM cross_semestres_informados
    WHERE TITOL_RESOURCE IS NOT NULL
)

, ultimo_semestre_informado AS (
    SELECT
        csi.DIM_ASSIGNATURA_KEY,
        csi.DIM_SEMESTRE_KEY,
        
        -- nulls created : no plan de estudios
        csi.ID_RESOURCE,
        csi.TITOL_RESOURCE,
        
        csi.plan_estudios_base,
        CASE 
            when csi.TITOL_RESOURCE is not null then NULL 
            else (
        
                SELECT  max( is2.informed_DIM_SEMESTRE_KEY ) 
                FROM informed_semesters is2
                WHERE is2.DIM_ASSIGNATURA_KEY = csi.DIM_ASSIGNATURA_KEY AND is2.informed_DIM_SEMESTRE_KEY <= csi.DIM_SEMESTRE_KEY
            )
        end AS last_informed_semestre
    FROM cross_semestres_informados csi
)

, propagacion_ultimo_semestre_informado AS (
    SELECT
        swr.DIM_ASSIGNATURA_KEY,
        swr.DIM_SEMESTRE_KEY, -- fecha  : castear 
        COALESCE(swr.ID_RESOURCE, inf.ID_RESOURCE) AS ID_RESOURCE, -- recurso : dimax 
        COALESCE(swr.TITOL_RESOURCE, inf.TITOL_RESOURCE) AS TITOL_RESOURCE,
        COALESCE(swr.plan_estudios_base, inf.plan_estudios_base) AS plan_estudios_base
        
    FROM ultimo_semestre_informado swr
    LEFT JOIN informed_semesters inf
        ON swr.DIM_ASSIGNATURA_KEY = inf.DIM_ASSIGNATURA_KEY
        AND swr.last_informed_semestre = inf.informed_DIM_SEMESTRE_KEY
)

SELECT 

    propagacion_ultimo_semestre_informado.DIM_ASSIGNATURA_KEY
    , propagacion_ultimo_semestre_informado.DIM_SEMESTRE_KEY
    , 'COCO'|| '-'|| propagacion_ultimo_semestre_informado.ID_RESOURCE as DIM_RECURSOS_APRENENTATGE_KEY

    , propagacion_ultimo_semestre_informado.ID_RESOURCE
    , propagacion_ultimo_semestre_informado.TITOL_RESOURCE
    , propagacion_ultimo_semestre_informado.plan_estudios_base
 
FROM propagacion_ultimo_semestre_informado

 -- no tienen plan de estudios asociado: crossjoin genera los campos inicio semestre, tomamos a partir del primer plan de estudios  
where propagacion_ultimo_semestre_informado.ID_RESOURCE is not null --  2.9M vs  1.9M

ORDER BY DIM_ASSIGNATURA_KEY, DIM_SEMESTRE_KEY;


 