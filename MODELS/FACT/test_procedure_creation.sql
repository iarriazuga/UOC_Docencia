CALL db_uoc_prod.dd_od.CREA_DIM(
    'SELECT 
        ENTIDAD_GESTORA as ENTITAT_GESTORA 
        , ID_EMISOR
        , ID_TRIBUTO
        , DESCRIPCION
        , SUFIJO
        , GESTION_DUDOSO_PAGO
        , DIAS_CADUCIDAD
        , SUFIJO_RAF
        , IND_MANTENER_FPAGO
    FROM db_uoc_prod.stg_cofros.cofros_tributos', --query genera DIM

    'DB_UOC_PROD.DD_OD.DIM_COFROS_TRIBUTS', --nom taula DIM
    
    ['ENTITAT_GESTORA', 'ID_EMISOR', 'ID_TRIBUTO'], --camps identificador unic
    
    [], --camps identificador unic NULLABLES
    
    'DB_UOC_PROD.DD_OD.STAGE_COFROS_EFECTES_PRODUCTES_POST', --nom taula POST
    
    'DIM_COFROS', --prefix
    
    0 --debug (1 true, 0 false)
);


CALL db_uoc_prod.dd_od.CREA_DIM(
    '
SELECT 

    dades_academiques.id_assignatura   
    , dades_academiques.id_semestre
    , dades_academiques.id_codi_recurs    
    , dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , dades_academiques.SOURCE_DADES_ACADEMIQUES 
    , count( dades_academiques.EVENT_CODI_RECURS )  as TIMES_USED
 

FROM  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
group by 1,2,3,4,5,6,7

', --query genera DIM
    'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2', --nom taula DIM
    ['id_assignatura', 'id_semestre', 'id_codi_recurs', 'DIM_ASSIGNATURA_KEY', 'DIM_SEMESTRE_KEY', 'DIM_RECURSOS_APRENENTATGE_KEY'], --camps identificador unic
    [], --camps identificador unic NULLABLES
    'DB_UOC_PROD.DD_OD.AS_TEST', --nom taula POST
    'DIM_COFROS', --prefix
    0 --debug (1 true, 0 false)
);


CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG AS 

with auxiliar as ( 
SELECT 

    dades_academiques.id_assignatura   
    , dades_academiques.id_semestre
    , dades_academiques.id_codi_recurs    
    , dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , dades_academiques.SOURCE_DADES_ACADEMIQUES 
    , count( dades_academiques.EVENT_CODI_RECURS )  as TIMES_USED
 

FROM  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
group by 1,2,3,4,5,6,7

) 

select
    id_assignatura
    , id_semestre
    , id_codi_recurs
    , DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , coalesce(TIMES_USED , 0) as TIMES_USED

from auxiliar
 

CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 ( #NL##T#ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 number(20,0) autoincrement start 1 increment 1 comment 'clau subrogada que identifica de forma unica els registres de la taula.', #NL##T#status VARCHAR(16777216), #NL##T#CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'data de creacio del registre de la informacio.',#NL##T#UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'data de carrega de la informacio.'#NL#);#NL#create or replace procedure DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS() returns varchar(16777216) language sql execute as caller as #NL##T#begin #NL##T##T#--Declaracions variables#NL##T##T#let start_time timestamp_ntz := convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz); #NL##T##T#let execution_time float; #NL##T##T#--merge 1: registre dummy#NL##T##T#merge into DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2#NL##T##T##T#using (#NL##T##T##T##T#select#NL##T##T##T##T##T#'ND' as status,#NL##T##T##T##T##T#convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as creation_date,#NL##T##T##T##T##T#convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as update_date#NL##T##T##T#) as ALIAS_QUERY_IN#NL##T##T##T##T#ON (#NL##T##T##T##T##T#ALIAS_QUERY_IN.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY#NL##T##T##T##T#)#NL##T##T##T#when not matched#NL##T##T##T##T#then insert (status,creation_date,update_date)#NL##T##T##T##T##T#values ('ND',convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz), convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz));#NL##T##T#-- MERGE 2: volcat de registres#NL##T##T#merge into DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2#NL##T##T##T#using (#NL##T##T##T##T#CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG AS 

with auxiliar as ( 
SELECT 

    dades_academiques.id_assignatura   
    , dades_academiques.id_semestre
    , dades_academiques.id_codi_recurs    
    , dades_academiques.DIM_ASSIGNATURA_KEY
    , dades_academiques.DIM_SEMESTRE_KEY
    , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY
    , dades_academiques.SOURCE_DADES_ACADEMIQUES 
    , count( dades_academiques.EVENT_CODI_RECURS )  as TIMES_USED
 

FROM  DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS dades_academiques
group by 1,2,3,4,5,6,7

) 

select
    id_assignatura
    , id_semestre
    , id_codi_recurs
    , DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , DIM_RECURSOS_APRENENTATGE_KEY
    , coalesce(TIMES_USED , 0) as TIMES_USED

from auxiliar#NL##T##T##T#) as ALIAS_QUERY_IN#NL##T##T##T##T# ON (#NL##T##T##T##T##T#ALIAS_QUERY_IN.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND #NL##T##T##T##T##T#ALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY#NL##T##T##T##T#)#NL##T##T##T#when matched AND (#NL##T##T##T##T#ALIAS_QUERY_IN.status <> DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.status#NL##T##T##T#) then#NL##T##T##T##T#update set#NL##T##T##T##T##T#status = ALIAS_QUERY_IN.status,#NL##T##T##T##T##T#update_date = convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)#NL##T##T##T#when not matched#NL##T##T##T##T#then insert (#NL##T##T##T##T##T#status,#NL##T##T##T##T##T#creation_date, update_date#NL##T##T##T##T#) values (#NL##T##T##T##T##T#ALIAS_QUERY_IN.status,#NL##T##T##T##T##T#convert_timezone('America/Los_Angeles','Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ),#NL##T##T##T##T##T#convert_timezone('America/Los_Angeles','Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)#NL##T##T##T##T#);#NL##T##T#--LOGS#NL##T##T#execution_time := datediff(millisecond, start_time, convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz));#NL##T##T#insert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)#NL##T##T#values (db_uoc_prod.dd_od.sequencia_id_log.nextval, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2', current_user(), :start_time, :execution_time, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 Success');#NL##T##T#return 'Update completed successfully';#NL##T#end;#NL#select max(update_date) from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;#NL#select count(*) from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;#NL#select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 limit 10;#NL#truncate table DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2;#NL#-- Comanda per executar el procediment enmagatzemat al entorn.#NL#call DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS();#NL#-- Afegir aquesta declaracio de columna a taula POST i FACT#NL#ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 number(20,0) comment 'Camp que importem de la dimensio DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 per tal de fer de vincle entre els objectes.', #NL#-- Afegir aquesta sentencia UPDATE a la seccio updates del procediment que alimenta la taula POST#NL#UPDATE DB_UOC_PROD.DD_OD.AS_TEST set ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2#NL##T#FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2#NL##T##T#WHERE #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND #NL##T##T##T##T##T#DB_UOC_PROD.DD_OD.AS_TEST.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY#NL##T##T##T##T#;