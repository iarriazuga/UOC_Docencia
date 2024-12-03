-- Define las variables
DEFINE SCHEMA_NAME = 'MI_ESQUEMA';
DEFINE DATABASE_NAME = 'MI_BASE_DATOS';



Pasare:
Ejemplo llamada procedure
Caracteres para sustituir saltos de linea y tabulacion


Ejemplo llamada procedure:
CALL db_uoc_prod.dd_od.CREA_DIM(
    'SELECT ENTIDAD_GESTORA as ENTITAT_GESTORA , ID_EMISOR, ID_TRIBUTO, DESCRIPCION, SUFIJO, GESTION_DUDOSO_PAGO, DIAS_CADUCIDAD, SUFIJO_RAF, IND_MANTENER_FPAGO
        FROM db_uoc_prod.stg_cofros.cofros_tributos', --query genera DIM
    'DB_UOC_PROD.DD_OD.DIM_COFROS_TRIBUTS', --nom taula DIM
    ['ENTITAT_GESTORA', 'ID_EMISOR', 'ID_TRIBUTO'], --camps identificador unic
    [], --camps identificador unic NULLABLES
    'DB_UOC_PROD.DD_OD.STAGE_COFROS_EFECTES_PRODUCTES_POST', --nom taula POST
    'DIM_COFROS', --prefix
    0 --debug (1 true, 0 false)
);


Caracteres para sustituir saltos de linea y tabulacion:

#T# = \t
#NL# = \r\n



create or replace task DB_UOC_PROD.DD_OD.UPDATE_DIMENSIONS
	warehouse=WH_DD_OD
	schedule='USING CRON 30 8 * * * Europe/Madrid'
	as CALL DB_UOC_PROD.DD_OD.FULL_DIMENSIONES_DATA_LOAD();


create or replace task DB_UOC_PROD.DD_OD.UPDATE_FACT
	warehouse=WH_DD_OD
	after DB_UOC_PROD.DD_OD.UPDATE_DIMENSIONS
	as CALL DB_UOC_PROD.DD_OD.FULL_DOCENCIA_DATA_LOAD();

create or replace task DB_UOC_PROD.DD_OD.UPDATE_CALCUL_CREDITS_UNEIX
	warehouse=WH_DD_OD
	after DB_UOC_PROD.DD_OD.UPDATE_FACT
	as CALL DB_UOC_PROD.DD_OD.LK_CREDITS_CURS_ACUMULATS_LOADS();

