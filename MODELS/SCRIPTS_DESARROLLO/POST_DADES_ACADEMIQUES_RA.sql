-- -- #################################################################################################
-- -- #################################################################################################
-- -- STAGE_POST_DADES_ACADEMIQUES_RA 
-- -- #################################################################################################
-- -- #################################################################################################

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA2(

    DIM_PERSONA_KEY NUMBER(10,0) COMMENT 'Clau DIM_PERSONA_KEY.', 
    DIM_ASSIGNATURA_KEY VARCHAR(6) COMMENT 'Clau assignatura.',
    DIM_SEMESTRE_KEY NUMBER(38, 0) COMMENT 'Clau semestre.',
    DIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15) COMMENT 'Clau recursos d\'aprenentatge.',
    CODI_RECURS NUMBER(38, 0) COMMENT 'Codi del recurs.',
    ORIGEN_DADES_ACADEMIQUES VARCHAR(5) COMMENT 'Font de les dades acadèmiques.', 
    NUM_MATRICULADOS NUMBER(38,0) COMMENT 'Alumnos matriculados para una asignatura y semestre determinado',
    assignatura_vigent_semester VARCHAR(10) COMMENT 'Vigencia de la assignatura en el semestre analitzat.'
) AS 

with aux_temporary_table as (

    SELECT 
        DIM_ASSIGNATURA_KEY,
        DIM_SEMESTRE_KEY,
        'COCO - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
        CODI_RECURS,
        'COCO' AS ORIGEN_DADES_ACADEMIQUES
    FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO

    UNION ALL

    SELECT     
        DIM_ASSIGNATURA_KEY,
        DIM_SEMESTRE_KEY,
        'DIMAX - ' || CODI_RECURS AS DIM_RECURSOS_APRENENTATGE_KEY,
        CODI_RECURS,
        'DIMAX' AS ORIGEN_DADES_ACADEMIQUES
    FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX
), 

matriculados_asignatura_semestre as (
    -- universo de matriculas y expedientes que no se han anulado  --> diferente numeros de expedientes para una asignatura
    select 
        
        asignaturas.ANY_ACADEMICO AS  DIM_SEMESTRE_KEY
        , asignaturas.COD_ASIGNATURA AS DIM_ASSIGNATURA_KEY
        , count( distinct asignaturas.num_expediente) AS NUM_MATRICULADOS 

    from  db_uoc_prod.stg_mat.gat_exp_matriculas as expediente

    -- Al hacer un INNER estamos dejando fuera las matriculas de los estudiantes que convalidan. Cuando queramos incorporarlos necesitaremos hacer un left
    inner join db_uoc_prod.stg_dadesra.gat_exp_asig_matriculas as asignaturas 
    on expediente.num_expediente = asignaturas.num_expediente
    and expediente.any_academico = asignaturas.any_academico

    where 1=1 
    and expediente.FECHA_ANULACION is null  
    and asignaturas.FECHA_ANULACION is null  

    group by 1,2

)
 
select 

        --DIM_KEYS:
        personas_assignaturas.idp as DIM_PERSONA_KEY -- Incluido para ver el profesor de la asignatura --> Relacion 1:1 -> no genera duplicados
        , aux_temporary_table.DIM_ASSIGNATURA_KEY
        , aux_temporary_table.DIM_SEMESTRE_KEY
        , aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY

        , aux_temporary_table.CODI_RECURS
        , aux_temporary_table.ORIGEN_DADES_ACADEMIQUES
        , matriculados_asignatura_semestre.NUM_MATRICULADOS

        , case 
            when validez_asig_semestres.any_acad_extincion is null and  validez_asig_semestres.cod_asignatura is null then 'No Info'
            when validez_asig_semestres.any_acad_extincion is null then 'Vigent'
            when validez_asig_semestres.any_acad_extincion >= aux_temporary_table.DIM_SEMESTRE_KEY then 'Vigent'
            else 'No vigent'
        END as assignatura_vigent_semester
 

from aux_temporary_table

left join DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS as personas_assignaturas
    on personas_assignaturas.cod_asignatura = aux_temporary_table.DIM_ASSIGNATURA_KEY
    AND personas_assignaturas.any_academico = aux_temporary_table.DIM_SEMESTRE_KEY

-- VALIDEZ DE LA ASSIGNATURA: 
left join db_uoc_prod.stg_docencia.gat_asig_semestres validez_asig_semestres
        on  validez_asig_semestres.cod_asignatura = aux_temporary_table.DIM_ASSIGNATURA_KEY

-- ALUMNOS MATRICULADOS
LEFT JOIN matriculados_asignatura_semestre 
    on matriculados_asignatura_semestre.DIM_ASSIGNATURA_KEY = aux_temporary_table.DIM_ASSIGNATURA_KEY
    AND matriculados_asignatura_semestre.DIM_SEMESTRE_KEY = aux_temporary_table.DIM_SEMESTRE_KEY
 

/*
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
select cod_asignatura, count(*) from aux
-- where assignatura_vigent_semester is null
group by 1
order by 2 desc

Vigent	10750104
No Info 	394073 -- numero exacto de recursos que no cruzan 
No vigent	1968091
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


 
-- desc table  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA

with aux as ( 
select  -- *
    idp,
    any_academico as semester, --? 
    cod_asignatura, 
    nom,  
    cognom1, 
    cognom2
from  DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS gat_personas  -- 312,202
inner join  DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona  -- 1,242,113
on dim_persona.dim_persona_key = gat_personas.idp  -- 312,187 
 
    --> perdemos solo 25 registros = 3 personas -->   30000709, 301100650, 30100462
            -- IDP	        SEMESTER
            -- 30100462	    20052
            -- 301100650	20052
            -- 30000709	    20053
            -- 30000709	    20052
    
 
) 
select semester, cod_asignatura, idp, count(*) 
from aux 
group by 1,2,3
order by 4 desc


describe table DB_UOC_PROD.DD_OD.DIM_PERSONA
 

*/