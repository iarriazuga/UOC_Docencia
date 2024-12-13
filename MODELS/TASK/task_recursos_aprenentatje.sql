


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
    call DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA_LOADS(); -- live events

    -- post_tables:
    call DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA_LOADS();  --Uncaught exception of type 'STATEMENT_ERROR' on line 8 at position 4 : String 'DIMAX-97097' is too long and would be truncated
    --fact_tables:
    call DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_LOADS();
    call DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_RECURSOS_APRENENTATGE_AGG_LOADS();


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

/*



 */
Hola Equipo, 

Hemos estado analizando los requerimientos del area de recursos de aprendizaje y todavia nos quedan 2 requisitos por cumplir: 
1. Incluir la validez de la asignatura en el modelo ( flag: si / no )
2. Incluir el area de la asignatura ( ejemplo: informática, ingeniería, ... area: ingeniería)

Victor nos ha comentado que seria necesario incluir el area de ofertas en el modelo, pero al comentarlo con @Xavi, nos ha comentado que igual era mas interesante incluir estos campos dentro de la tabla de la dim_assignatura.

Al analizar la tabla dim_assignatura, hemos encontrado que estas columnas no existen en la tabla.

Como procederias vosotros? quien es el responsable de la tabla dim_assignatura? 

Si lo hacemos nosotros, nos gustaria tener una sesion con el ultimo que haya modificado la Dim_assignatura ya que creemos que esta tabla puede impactar en un gran numero de modelos. 
En caso contrario como podemos hacer un seguimiento? 


Hola Equipo, 

Os escribo por aqui ya que tenemos algunas dudas relacionadas con la tabla DB_UOC_PROD.STG_DADESRA.LIVE_EVENTS_CALIPER_DUMMY.

Esta tabla es fundamental para incluir los USOS en el modelo de recursos de aprendizaje que estamos desarrollando. 

Pero como el nombre 'DUMMY' nos genera ciertas dudas queremos hacer unas preguntas: 

* Esta tabla va a tener continuidad o se va a actualizar en la UOC?
* Existe una estandarizacion de nombres de estas tablas que podamos referenciar o usar esta como base es correcto? 
* tiene muchos recursos y campos en null, esto es correcto? ( ej:     GET_PATH(JSON, 'data[0]:object.mediatype')::string AS object_mediatype --> esta siempre a null )
* Cada cuanto se recarga esta tabla? 

Quizas seria interesante tener una reunion para comprobar el estado o ver los desarrollos asociados, que os parece hoy a las 15:30?  
