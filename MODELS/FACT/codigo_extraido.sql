CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 (  \r\n\tID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 number(20,0) autoincrement start 1 increment 1 comment 'clau subrogada que identifica de forma unica els registres de la taula.',  \r\n\tID_ASSIGNATURA NUMBER(38,0),  \r\n\tID_SEMESTRE NUMBER(38,0),  \r\n\tID_CODI_RECURS NUMBER(38,0),  \r\n\tDIM_ASSIGNATURA_KEY VARCHAR(6),  \r\n\tDIM_SEMESTRE_KEY NUMBER(38,0),  \r\n\tDIM_RECURSOS_APRENENTATGE_KEY VARCHAR(15),  \r\n\tSOURCE_DADES_ACADEMIQUES VARCHAR(5),  \r\n\tTIMES_USED NUMBER(18,0),  \r\n\tCREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'data de creacio del registre de la informacio.', \r\n\tUPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'data de carrega de la informacio.' \r\n); \r\ncreate or replace procedure DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS() returns varchar(16777216) language sql execute as caller as  \r\n\tbegin  \r\n\t\t--Declaracions variables \r\n\t\tlet start_time timestamp_ntz := convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz);  \r\n\t\tlet execution_time float;  \r\n\t\t--merge 1: registre dummy \r\n\t\tmerge into DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 \r\n\t\t\tusing ( \r\n\t\t\t\tselect \r\n\t\t\t\t\t0 as ID_ASSIGNATURA, \r\n\t\t\t\t\t0 as ID_SEMESTRE, \r\n\t\t\t\t\t0 as ID_CODI_RECURS, \r\n\t\t\t\t\t'ND' as DIM_ASSIGNATURA_KEY, \r\n\t\t\t\t\t0 as DIM_SEMESTRE_KEY, \r\n\t\t\t\t\t'ND' as DIM_RECURSOS_APRENENTATGE_KEY, \r\n\t\t\t\t\t'ND' as SOURCE_DADES_ACADEMIQUES, \r\n\t\t\t\t\t0 as TIMES_USED, \r\n\t\t\t\t\tconvert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as creation_date, \r\n\t\t\t\t\tconvert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) as update_date \r\n\t\t\t) as ALIAS_QUERY_IN \r\n\t\t\t\tON ( \r\n\t\t\t\t\tALIAS_QUERY_IN.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY \r\n\t\t\t\t) \r\n\t\t\twhen not matched \r\n\t\t\t\tthen insert (ID_ASSIGNATURA,ID_SEMESTRE,ID_CODI_RECURS,DIM_ASSIGNATURA_KEY,DIM_SEMESTRE_KEY,DIM_RECURSOS_APRENENTATGE_KEY,SOURCE_DADES_ACADEMIQUES,TIMES_USED,creation_date,update_date) \r\n\t\t\t\t\tvalues (0,0,0,'ND',0,'ND','ND',0,convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz), convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)); \r\n\t\t-- MERGE 2: volcat de registres \r\n\t\tmerge into DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 \r\n\t\t\tusing ( \r\n\t\t\t\t
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

 \r\n\t\t\t) as ALIAS_QUERY_IN \r\n\t\t\t\t ON ( \r\n\t\t\t\t\tALIAS_QUERY_IN.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND  \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY \r\n\t\t\t\t) \r\n\t\t\twhen matched AND ( \r\n\t\t\t\tALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES <> DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.SOURCE_DADES_ACADEMIQUES \r\n\t\t\t\tOR \r\n\t\t\t\tALIAS_QUERY_IN.TIMES_USED <> DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.TIMES_USED \r\n\t\t\t) then \r\n\t\t\t\tupdate set \r\n\t\t\t\t\tSOURCE_DADES_ACADEMIQUES = ALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES, \r\n\t\t\t\t\tTIMES_USED = ALIAS_QUERY_IN.TIMES_USED, \r\n\t\t\t\t\tupdate_date = convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz) \r\n\t\t\twhen not matched \r\n\t\t\t\tthen insert ( \r\n\t\t\t\t\tID_ASSIGNATURA, \r\n\t\t\t\t\tID_SEMESTRE, \r\n\t\t\t\t\tID_CODI_RECURS, \r\n\t\t\t\t\tDIM_ASSIGNATURA_KEY, \r\n\t\t\t\t\tDIM_SEMESTRE_KEY, \r\n\t\t\t\t\tDIM_RECURSOS_APRENENTATGE_KEY, \r\n\t\t\t\t\tSOURCE_DADES_ACADEMIQUES, \r\n\t\t\t\t\tTIMES_USED, \r\n\t\t\t\t\tcreation_date, update_date \r\n\t\t\t\t) values ( \r\n\t\t\t\t\tALIAS_QUERY_IN.ID_ASSIGNATURA, \r\n\t\t\t\t\tALIAS_QUERY_IN.ID_SEMESTRE, \r\n\t\t\t\t\tALIAS_QUERY_IN.ID_CODI_RECURS, \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_ASSIGNATURA_KEY, \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_SEMESTRE_KEY, \r\n\t\t\t\t\tALIAS_QUERY_IN.DIM_RECURSOS_APRENENTATGE_KEY, \r\n\t\t\t\t\tALIAS_QUERY_IN.SOURCE_DADES_ACADEMIQUES, \r\n\t\t\t\t\tALIAS_QUERY_IN.TIMES_USED, \r\n\t\t\t\t\tconvert_timezone('America/Los_Angeles','Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ), \r\n\t\t\t\t\tconvert_timezone('America/Los_Angeles','Europe/Madrid', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) \r\n\t\t\t\t); \r\n\t\t--LOGS \r\n\t\texecution_time := datediff(millisecond, start_time, convert_timezone('America/Los_Angeles','Europe/Madrid', current_timestamp()::timestamp_ntz)); \r\n\t\tinsert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks) \r\n\t\tvalues (db_uoc_prod.dd_od.sequencia_id_log.nextval, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2', current_user(), :start_time, :execution_time, 'DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 Success'); \r\n\t\treturn 'Update completed successfully'; \r\n\tend; \r\nselect max(update_date) from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2; \r\nselect count(*) from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2; \r\nselect * from DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 limit 10; \r\ntruncate table DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2; \r\n-- Comanda per executar el procediment enmagatzemat al entorn. \r\ncall DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2_LOADS(); \r\n-- Afegir aquesta declaracio de columna a taula POST i FACT \r\nID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 number(20,0) comment 'Camp que importem de la dimensio DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 per tal de fer de vincle entre els objectes.',  \r\n-- Afegir aquesta sentencia UPDATE a la seccio updates del procediment que alimenta la taula POST \r\nUPDATE DB_UOC_PROD.DD_OD.AS_TEST set ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.ID_DIM_D.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 \r\n\tFROM DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2 \r\n\t\tWHERE  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.id_assignatura = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_assignatura AND  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.id_semestre = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_semestre AND  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.id_codi_recurs = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.id_codi_recurs AND  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.DIM_ASSIGNATURA_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_ASSIGNATURA_KEY AND  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.DIM_SEMESTRE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_SEMESTRE_KEY AND  \r\n\t\t\t\t\tDB_UOC_PROD.DD_OD.AS_TEST.DIM_RECURSOS_APRENENTATGE_KEY = DB_UOC_PROD.DDP_DOCENCIA.FACT_DADES_ACADEMIQUES_EVENTS_AGG2.DIM_RECURSOS_APRENENTATGE_KEY \r\n\t\t\t\t;