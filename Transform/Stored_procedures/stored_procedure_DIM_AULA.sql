-- Creacio de la sequencia que donara peu a identificador unic de la taula.

create or replace sequence db_uoc_prod.dd_od.dim_aula_id_aula start 1 increment 1;

-- Creacio de la taula DIM_AULA amb les descripcions en els idiomes que es disponibilitzan i els atributs particulars.
-- Pendent de identificar nous requeriments a incloure a la dimensio.

create or replace TABLE db_uoc_prod.dd_od.dim_aula (

	COD_AULA NUMBER(10,0)
	,COD_ASIGNATURA VARCHAR(8)
	,ID_AULA_KEY VARCHAR(18)
    ,CREATION_DATE TIMESTAMP_NTZ(9)
    ,UPDATE_DATE TIMESTAMP_NTZ(9)
);


-- Creacio del procediment de carrega i/o actualització de dades programable
create or replace procedure db_uoc_prod.dd_od.dim_aula_loads()
    returns varchar(16777216)
    language SQL
    execute as caller
    as 
    begin
    
    let start_time timestamp_ntz := convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz);
    let execution_time float;


/*
-- Crea el registre amb ID_AULA_KEY = 0 per poder assignar a qualsevol registre que no estigui correctament identificat.
*/

-- merge into db_uoc_prod.dd_od.dim_aula --inser registro 0
-- using (
--         select 
--             '0' as ID_AULA_KEY, -- convert innto 
--             '0' as COD_ASIGNATURA,
--             0 as COD_AULA,
 
--             convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as CREATION_DATE,
--             convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as UPDATE_DATE
--     ) as dim_aula_rep 
--         on db_uoc_prod.dd_od.dim_aula.ID_AULA_KEY = dim_aula.ID_AULA_KEY
    
--     when matched
--         then update set update_date = convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)

--     when not matched
--         then insert (
--                 ID_AULA_KEY,
--                 COD_ASIGNATURA,
--                 COD_AULA,
                
--                 CREATION_DATE,
--                 UPDATE_DATE
--                 )
--         values (
--                 '0'
--                 ,'0'
--                 , 0
--                 , convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)
--                 ,convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)
--             )
-- ;



merge into db_uoc_prod.dd_od.dim_aula
using (
        select
            dim_aula_orig.COD_AULA || dim_aula_orig.COD_ASIGNATURA as ID_AULA_KEY, 
            dim_aula_orig.COD_ASIGNATURA,
            dim_aula_orig.COD_AULA,
            dim_aula_orig.FECHA_CREACION as CREATION_DATE,
            dim_aula_orig.TS_CARGA as UPDATE_DATE
        from DB_UOC_PROD.STG_DOCENCIA.GAT_AULAS_ASIG dim_aula_orig
    ) as dim_aula_orig
    on db_uoc_prod.dd_od.dim_aula.ID_AULA_KEY = dim_aula_orig.ID_AULA_KEY  --- corrected here
when matched then 
    update set 
    ID_AULA_KEY = dim_aula_orig.ID_AULA_KEY,
    COD_ASIGNATURA = dim_aula_orig.COD_ASIGNATURA,
    COD_AULA = dim_aula_orig.COD_AULA, 
    CREATION_DATE = dim_aula_orig.CREATION_DATE,
    update_date = convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)
when not matched then
    insert (
        ID_AULA_KEY,
        COD_ASIGNATURA,
        COD_AULA,
        CREATION_DATE,
        UPDATE_DATE
    ) 
    values (
        dim_aula_orig.ID_AULA_KEY,
        dim_aula_orig.COD_ASIGNATURA,
        dim_aula_orig.COD_AULA,
        convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz), 
        convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)
    );


execution_time := datediff(millisecond, start_time, convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, 'dim_aula_loads', CURRENT_USER(), :start_time, :execution_time, 'dim_aula Success');
    
return 'Update completed successfully';

end
;


-- Comanda per executar el procediment enmagatzemat al entorn.
call db_uoc_prod.dd_od.dim_aula_loads();

select 'Worksheet de Snowflake almacenado.';

select * from db_uoc_prod.dd_od.dim_aula;

--############################################################################################################################################
/**AUX_VALIDATION_CODE**/ 
--############################################################################################################################################

-- with aux_aula as ( 
-- select  
--     COD_AULA, 
--     cod_asignatura, 
--     COD_AULA || cod_asignatura as ID_AULA_KEY, 
--     count(*)
    
-- from DB_UOC_PROD.STG_DOCENCIA.GAT_AULAS_ASIG
-- group by 1,2,3

-- ) 
-- select count(*) from aux_aula;   --- 30179 

/** related tables **/ 
-- select * from DB_UOC_PROD.STG_DOCENCIA.GAT_AULAS_ASIG
-- DB_UOC_PROD.STG_DOCENCIA.GAT_PLAN_ASIGNATURAS
-- DB_UOC_PROD.STG_DOCENCIA.GAT_EXP_AULAS_ASIG_ESTUDIANTES


-- select * from DB_UOC_PROD.STG_DOCENCIA.GAT_AULAS_ASIG

-- create or replace TRANSIENT TABLE DB_UOC_PROD.STG_DOCENCIA.aux_aula (

-- 	COD_AULA NUMBER(10,0),
-- 	COD_ASIGNATURA VARCHAR(8),
-- 	ID_AULA_KEY  VARCHAR(18),
-- );

-- select * from STG_ENQUESTES.ENQUESTES2_UFI_ITERATIVA_INSTIT_ASIGN LIMIT 100;

 