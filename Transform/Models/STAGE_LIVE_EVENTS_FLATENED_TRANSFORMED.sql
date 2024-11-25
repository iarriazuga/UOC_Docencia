
-- -- #################################################################################################
-- -- #################################################################################################
-- -- FACT_DOCENCIA?
-- -- #################################################################################################
-- -- #################################################################################################
/***
Reutilizar tables de docencia
- fact docencia : semestre + asignatura + estudiante ( posible aula )
- nivel asignatura / docencia / semestre --> nivel estudiante 
6M historica

*/
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED AS 

with temp_table as (
    select 

    SEMESTER as DIM_SEMESTRE_KEY ,  
    MATERIAL_ID as ID_RESOURCE, 
    SOURCE, 
    subjectcode as DIM_ASSIGNATURA_KEY, 
    count(MATERIAL_ID) as TIMES_USED
    
    from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED  -- 8,741,384 vs 123,019

    group by 1,2,3,4
) 
select * from temp_table