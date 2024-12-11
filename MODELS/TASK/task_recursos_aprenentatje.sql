


-- create or replace task DB_UOC_PROD.DDP_DOCENCIA.UPDATE_FACT
-- 	warehouse=WH_DDP_DOCENCIA
-- 	after DB_UOC_PROD.DDP_DOCENCIA.UPDATE_DIMENSIONS
-- 	as CALL DB_UOC_PROD.DDP_DOCENCIA.FULL_DOCENCIA_DATA_LOAD();


--- Uncoment latest: 
create or replace task DB_UOC_PROD.DDP_DOCENCIA.UPDATE_MODEL_RECURS_APRENENTATGE
	-- warehouse=WH_DDP_DOCENCIA
    warehouse=WH_DD_OD
	schedule='USING CRON 30 9 * * * Europe/Madrid'
	as CALL DB_UOC_PROD.DDP_DOCENCIA.FULL_MODEL_RECURS_APRENENTATGE_LOAD();

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DDP_DOCENCIA.FULL_MODEL_RECURS_APRENENTATGE_LOAD()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS begin
let start_time timestamp_ntz := convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz);
let execution_time float;

-- ####### #######
-- ####### #######
-- Aquest procediment aglutina totes les accions necessaries actualitzar les taules de dimensions
-- ####### #######
-- ####### #######

-- -- first dim_related_tables:  
    call db_uoc_prod.DDP_DOCENCIA.stage_recursos_aprenentatge_dimax_loads();
    call DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS_LOADS();
    call DB_UOC_PROD.DDP_DOCENCIA.REMOVE_DUPLICATES_COCO_PROD(); -- delete moduls promoted to products
    call DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE_LOADS();


-- fact table :
    -- stage_tables:
    call DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO_LOADS();
    CALL DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX_LOADS();
    call DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_LOADS(); -- live events

    -- post_tables:
    call DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_LOADS();  --Uncaught exception of type 'STATEMENT_ERROR' on line 8 at position 4 : String 'DIMAX-97097' is too long and would be truncated
    --fact_tables:
    call DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_LOADS();
    call DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG_LOADS();


execution_time := datediff(millisecond, start_time, convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, 'FULL_MODEL_RECURS_APRENENTATGE_LOAD', current_user(), :start_time, :execution_time, 'FULL_MODEL_RECURS_APRENENTATGE_LOAD Success');
    
return 'Update completed successfully';

end;


call DB_UOC_PROD.DDP_DOCENCIA.FULL_MODEL_RECURS_APRENENTATGE_LOAD()



/**


1. Tema usados y no en catálogo -->  recuros que ellos borran ( profesor que existio y todos vienen de coco) 
(ignorar el uso? ) --> esperamos? : 

2. Recursos usados que llegan con source NIU o no informada y existen en Dimax y COCO
--> ignorar la base de dades en uso --> coger la de catalogo --> complicado 1 recurso 1 asignatura : (no hay duplicados)
-- coger codi_recurs --> (Acoran y no habia duplicados --> f_events 4 semestres --> no hay duplicados) --> titulo a la maestra --> puede estar duplicado titulo en la maestra 
--> solucionado



3. Validación de las tablas: --> f_live_events: toni beltran --> codigo 


4. Indicar en dades_academiques_events la fuente (si és un uso o viene de la dim)


*/