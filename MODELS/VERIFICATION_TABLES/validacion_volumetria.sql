--###########################################################################################################
-- VALIDACIONES
--###########################################################################################################

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1) MAPPEOS CORRECTOS: Formato / valores correctos en todas las tablas ( mappeos correctos )
describe table DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS; -- extraigo todas las columnas
-- Generate a single SELECT with COUNT(DISTINCT ...) for each field in the table
SELECT 
    COUNT(DISTINCT ID_ASSIGNATURA) AS Count_Distinct_ID_ASSIGNATURA,
    COUNT(DISTINCT ID_SEMESTRE) AS Count_Distinct_ID_SEMESTRE,
    COUNT(DISTINCT ID_CODI_RECURS) AS Count_Distinct_ID_CODI_RECURS,
    COUNT(DISTINCT ID_PERSONA) AS Count_Distinct_ID_PERSONA,
    COUNT(DISTINCT DIM_PERSONA_KEY) AS Count_Distinct_DIM_PERSONA_KEY,
    COUNT(DISTINCT DIM_ASSIGNATURA_KEY) AS Count_Distinct_DIM_ASSIGNATURA_KEY,
    COUNT(DISTINCT DIM_SEMESTRE_KEY) AS Count_Distinct_DIM_SEMESTRE_KEY,
    COUNT(DISTINCT DIM_RECURSOS_APRENENTATGE_KEY) AS Count_Distinct_DIM_RECURSOS_APRENENTATGE_KEY,
    COUNT(DISTINCT ORIGEN_DADES_ACADEMIQUES) AS Count_Distinct_ORIGEN_DADES_ACADEMIQUES,
    COUNT(DISTINCT CODI_RECURS) AS Count_Distinct_CODI_RECURS,
    COUNT(DISTINCT EVENT_CODI_RECURS) AS Count_Distinct_EVENT_CODI_RECURS,
    COUNT(DISTINCT EVENT_TIME) AS Count_Distinct_EVENT_TIME,
    COUNT(DISTINCT EVENT_DATE) AS Count_Distinct_EVENT_DATE,
    COUNT(DISTINCT ACCIO) AS Count_Distinct_ACCIO,
    COUNT(DISTINCT NOM_ACTOR) AS Count_Distinct_NOM_ACTOR,
    COUNT(DISTINCT ACTOR_TIPUS) AS Count_Distinct_ACTOR_TIPUS,
    COUNT(DISTINCT USUARI_DACCES) AS Count_Distinct_USUARI_DACCES,
    COUNT(DISTINCT ID_IDP_USUARI_EVENTS) AS Count_Distinct_ID_IDP_USUARI_EVENTS,
    COUNT(DISTINCT TITOL_ASSIGNATURA) AS Count_Distinct_TITOL_ASSIGNATURA,
    COUNT(DISTINCT ID_CURS_CANVAS) AS Count_Distinct_ID_CURS_CANVAS,
    COUNT(DISTINCT ID_SISTEMA_CURS) AS Count_Distinct_ID_SISTEMA_CURS,
    COUNT(DISTINCT ROL) AS Count_Distinct_ROL,
    COUNT(DISTINCT ESTAT_MEMBRE) AS Count_Distinct_ESTAT_MEMBRE,
    COUNT(DISTINCT TITOL_RECURS) AS Count_Distinct_TITOL_RECURS,
    COUNT(DISTINCT ENLLAC) AS Count_Distinct_ENLLAC,
    COUNT(DISTINCT OBJECT_MEDIATYPE) AS Count_Distinct_OBJECT_MEDIATYPE,
    COUNT(DISTINCT TIPUS_RECURS) AS Count_Distinct_TIPUS_RECURS,
    COUNT(DISTINCT FORMAT_RECURS) AS Count_Distinct_FORMAT_RECURS,
    COUNT(DISTINCT ORIGEN_EVENTS) AS Count_Distinct_ORIGEN_EVENTS,
    COUNT(DISTINCT ENLLAC_URL) AS Count_Distinct_ENLLAC_URL,
    COUNT(DISTINCT USOS_RECURS_ESTUDIANTS) AS Count_Distinct_USOS_RECURS_ESTUDIANTS,
    COUNT(DISTINCT USOS_RECURS_TOTALS) AS Count_Distinct_USOS_RECURS_TOTALS,
    COUNT(DISTINCT ASSIGNATURA_VIGENT_SEMESTER) AS Count_Distinct_ASSIGNATURA_VIGENT_SEMESTER,
    COUNT(DISTINCT CREATION_DATE) AS Count_Distinct_CREATION_DATE,
    COUNT(DISTINCT UPDATE_DATE) AS Count_Distinct_UPDATE_DATE
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;

SELECT 
    COUNT( ID_ASSIGNATURA) AS Count__ID_ASSIGNATURA,
    COUNT( ID_SEMESTRE) AS Count__ID_SEMESTRE,
    COUNT( ID_CODI_RECURS) AS Count__ID_CODI_RECURS,
    COUNT( ID_PERSONA) AS Count__ID_PERSONA,
    COUNT( DIM_PERSONA_KEY) AS Count__DIM_PERSONA_KEY,
    COUNT( DIM_ASSIGNATURA_KEY) AS Count__DIM_ASSIGNATURA_KEY,
    COUNT( DIM_SEMESTRE_KEY) AS Count__DIM_SEMESTRE_KEY,
    COUNT( DIM_RECURSOS_APRENENTATGE_KEY) AS Count__DIM_RECURSOS_APRENENTATGE_KEY,
    COUNT( ORIGEN_DADES_ACADEMIQUES) AS Count__ORIGEN_DADES_ACADEMIQUES,
    COUNT( CODI_RECURS) AS Count__CODI_RECURS,
    COUNT( EVENT_CODI_RECURS) AS Count__EVENT_CODI_RECURS,
    COUNT( EVENT_TIME) AS Count__EVENT_TIME,
    COUNT( EVENT_DATE) AS Count__EVENT_DATE,
    COUNT( ACCIO) AS Count__ACCIO,
    COUNT( NOM_ACTOR) AS Count__NOM_ACTOR,
    COUNT( ACTOR_TIPUS) AS Count__ACTOR_TIPUS,
    COUNT( USUARI_DACCES) AS Count__USUARI_DACCES,
    COUNT( ID_IDP_USUARI_EVENTS) AS Count__ID_IDP_USUARI_EVENTS,
    COUNT( TITOL_ASSIGNATURA) AS Count__TITOL_ASSIGNATURA,
    COUNT( ID_CURS_CANVAS) AS Count__ID_CURS_CANVAS,
    COUNT( ID_SISTEMA_CURS) AS Count__ID_SISTEMA_CURS,
    COUNT( ROL) AS Count__ROL,
    COUNT( ESTAT_MEMBRE) AS Count__ESTAT_MEMBRE,
    COUNT( TITOL_RECURS) AS Count__TITOL_RECURS,
    COUNT( ENLLAC) AS Count__ENLLAC,
    COUNT( OBJECT_MEDIATYPE) AS Count__OBJECT_MEDIATYPE,
    COUNT( TIPUS_RECURS) AS Count__TIPUS_RECURS,
    COUNT( FORMAT_RECURS) AS Count__FORMAT_RECURS,
    COUNT( ORIGEN_EVENTS) AS Count__ORIGEN_EVENTS,
    COUNT( ENLLAC_URL) AS Count__ENLLAC_URL,
    COUNT( USOS_RECURS_ESTUDIANTS) AS Count__USOS_RECURS_ESTUDIANTS,
    COUNT( USOS_RECURS_TOTALS) AS Count__USOS_RECURS_TOTALS,
    COUNT( ASSIGNATURA_VIGENT_SEMESTER) AS Count__ASSIGNATURA_VIGENT_SEMESTER,
    COUNT( CREATION_DATE) AS Count__CREATION_DATE,
    COUNT( UPDATE_DATE) AS Count__UPDATE_DATE
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;


/*

COUNT_DISTINCT_ID_ASSIGNATURA	COUNT_DISTINCT_ID_SEMESTRE	COUNT_DISTINCT_ID_CODI_RECURS	COUNT_DISTINCT_ID_PERSONA	COUNT_DISTINCT_DIM_PERSONA_KEY	COUNT_DISTINCT_DIM_ASSIGNATURA_KEY	COUNT_DISTINCT_DIM_SEMESTRE_KEY	COUNT_DISTINCT_DIM_RECURSOS_APRENENTATGE_KEY	COUNT_DISTINCT_ORIGEN_DADES_ACADEMIQUES	COUNT_DISTINCT_CODI_RECURS	COUNT_DISTINCT_EVENT_CODI_RECURS	COUNT_DISTINCT_EVENT_TIME	COUNT_DISTINCT_EVENT_DATE	COUNT_DISTINCT_ACCIO	COUNT_DISTINCT_NOM_ACTOR	COUNT_DISTINCT_ACTOR_TIPUS	COUNT_DISTINCT_USUARI_DACCES	COUNT_DISTINCT_ID_IDP_USUARI_EVENTS	COUNT_DISTINCT_TITOL_ASSIGNATURA	COUNT_DISTINCT_ID_CURS_CANVAS	COUNT_DISTINCT_ID_SISTEMA_CURS	COUNT_DISTINCT_ROL	COUNT_DISTINCT_ESTAT_MEMBRE	COUNT_DISTINCT_TITOL_RECURS	COUNT_DISTINCT_ENLLAC	COUNT_DISTINCT_OBJECT_MEDIATYPE	COUNT_DISTINCT_TIPUS_RECURS	COUNT_DISTINCT_FORMAT_RECURS	COUNT_DISTINCT_ORIGEN_EVENTS	COUNT_DISTINCT_ENLLAC_URL	COUNT_DISTINCT_USOS_RECURS_ESTUDIANTS	COUNT_DISTINCT_USOS_RECURS_TOTALS	COUNT_DISTINCT_ASSIGNATURA_VIGENT_SEMESTER	COUNT_DISTINCT_CREATION_DATE	COUNT_DISTINCT_UPDATE_DATE
15064	77	123087	1057	1059	15797	77	122566	2	116915	39890	11629351	291	1	97999	1	96288	96181	10087	17019	17019	7	1	56866	255095	0	1	51	3	98283	2	2	3	2	2
*/
-- Select only the fields with a single distinct value from the origin table
-- todos los valores son correctos
SELECT 
    ACCIO,
    ACTOR_TIPUS,
    FORMAT_RECURS,
    ORIGEN_EVENTS,
    ASSIGNATURA_VIGENT_SEMESTER,
    CREATION_DATE,
    UPDATE_DATE
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;


/**ERRORS**/
-- problemas con el campo object_mediatype
SELECT 
    OBJECT_MEDIATYPE -- f_caliper_dummy 
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;

select  ID_ASSIGNATURA , COUNT(*) AS Distinct_TIPUS_RECURS 
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  -- 15,065 asignatura
group by 1
order by 2 desc

/*
 
8684	237769
12356	190808
7534	157414
8105	138036

*/
 
select distinct dim_assignatura.ID_ASSIGNATURA 
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
inner join DB_UOC_PROD.DD_OD.dim_assignatura 
 on dim_assignatura.ID_ASSIGNATURA = FACT_RECURSOS_APRENENTATGE_EVENTS.id_assignatura


select  distinct  FACT_RECURSOS_APRENENTATGE_EVENTS.DIM_ASSIGNATURA_KEY 
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS as FACT_RECURSOS_APRENENTATGE_EVENTS
left join DB_UOC_PROD.DD_OD.dim_assignatura 
 on trim(dim_assignatura.DIM_ASSIGNATURA_KEY)  = trim(FACT_RECURSOS_APRENENTATGE_EVENTS.DIM_ASSIGNATURA_KEY)

where dim_assignatura.ID_ASSIGNATURA is null

--- left join : validation 
select   FACT_RECURSOS_APRENENTATGE_EVENTS.DIM_ASSIGNATURA_KEY 
FROM DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  
where DIM_ASSIGNATURA_KEY is null

describe table DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE; -- extraigo todas las columnas
-- Generate a single SELECT with COUNT(DISTINCT ...) for each field in the table

SELECT 
    COUNT(DISTINCT ID_CODI_RECURS) AS Distinct_ID_CODI_RECURS,
    -- COUNT(DISTINCT DIM_RECURSOS_APRENENTATGE_KEY) AS Distinct_DIM_RECURSOS_APRENENTATGE_KEY,
    -- COUNT(DISTINCT CODI_RECURS) AS Distinct_CODI_RECURS,
    -- COUNT(DISTINCT TITOL_RECURS) AS Distinct_TITOL_RECURS,
    -- COUNT(DISTINCT ORIGEN_RECURS) AS Distinct_ORIGEN_RECURS,
    -- COUNT(DISTINCT TIPUS_RECURS) AS Distinct_TIPUS_RECURS,
    -- COUNT(DISTINCT ORIGEN_BASE_DADES) AS Distinct_ORIGEN_BASE_DADES,
    -- COUNT(DISTINCT LLICENCIA_LPC) AS Distinct_LLICENCIA_LPC,
    -- COUNT(DISTINCT LLICENCIA_LGC) AS Distinct_LLICENCIA_LGC,
    -- COUNT(DISTINCT LLICENCIA_ALTRES) AS Distinct_LLICENCIA_ALTRES,
    -- COUNT(DISTINCT LLICENCIA_BIBLIOTECA) AS Distinct_LLICENCIA_BIBLIOTECA,
    -- COUNT(DISTINCT BAIXA) AS Distinct_BAIXA,
    -- COUNT(DISTINCT DESCRIPCIO_IDIOMA_RECURS) AS Distinct_DESCRIPCIO_IDIOMA_RECURS,
    -- COUNT(DISTINCT FORMAT_RECURS) AS Distinct_FORMAT_RECURS,
    -- COUNT(DISTINCT DATA_INICI_RECURS) AS Distinct_DATA_INICI_RECURS,
    -- COUNT(DISTINCT DATA_CADUCITAT_RECURS) AS Distinct_DATA_CADUCITAT_RECURS,
    -- COUNT(DISTINCT CERCABLE_RECURS) AS Distinct_CERCABLE_RECURS,
    -- COUNT(DISTINCT INDICADOR_PUBLIC_RECURS) AS Distinct_INDICADOR_PUBLIC_RECURS,
    -- COUNT(DISTINCT PUBLICAT_A_RECURS) AS Distinct_PUBLICAT_A_RECURS,
    -- COUNT(DISTINCT ISBN_ISSN_RECURS) AS Distinct_ISBN_ISSN_RECURS,
    -- COUNT(DISTINCT PAGINA_INICI_RECURS) AS Distinct_PAGINA_INICI_RECURS,
    -- COUNT(DISTINCT PAGINA_FINAL_RECURS) AS Distinct_PAGINA_FINAL_RECURS,
    -- COUNT(DISTINCT BASE_DADES_RECURS) AS Distinct_BASE_DADES_RECURS,
    -- COUNT(DISTINCT ELLIBRE_RECURS) AS Distinct_ELLIBRE_RECURS,
    -- COUNT(DISTINCT URL_CAT_RECURS) AS Distinct_URL_CAT_RECURS,
    -- COUNT(DISTINCT URL_CAS_RECURS) AS Distinct_URL_CAS_RECURS,
    -- COUNT(DISTINCT URL_ANG_RECURS) AS Distinct_URL_ANG_RECURS,
    -- COUNT(DISTINCT URL_RECURS_PROPI) AS Distinct_URL_RECURS_PROPI, -- reordenar 
    -- COUNT(DISTINCT TIPUS_GESTIO_RECURS) AS Distinct_TIPUS_GESTIO_RECURS,
    -- COUNT(DISTINCT DESPESA_VARIABLE_RECURS) AS Distinct_DESPESA_VARIABLE_RECURS,
    COUNT(DISTINCT PRODUCTE_CREACIO_ID) AS Distinct_PRODUCTE_CREACIO_ID,
    -- COUNT(DISTINCT DESCRIPCIO_TRAMESA_RECURS) AS Distinct_DESCRIPCIO_TRAMESA_RECURS,
    -- COUNT(DISTINCT NUM_CONTRACTE) AS Distinct_NUM_CONTRACTE,
    -- COUNT(DISTINCT OBSERVACIONS) AS Distinct_OBSERVACIONS,
    COUNT(DISTINCT MODUL_ORIGEN_ID) AS Distinct_MODUL_ORIGEN_ID,
    COUNT(DISTINCT VERSIO_CREACIO_ID) AS Distinct_VERSIO_CREACIO_ID,
    COUNT(DISTINCT OBRA_ID) AS Distinct_OBRA_ID,
    COUNT(DISTINCT CODI_MIGRACIO) AS Distinct_CODI_MIGRACIO,
-- data creacio --> 
    COUNT(DISTINCT UPDATE_DATE) AS Distinct_UPDATE_DATE,
    COUNT(DISTINCT CREATION_DATE) AS Distinct_CREATION_DATE
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE; -- extraigo todas las columnas

-- reescribir :   data creacio
-- alinear columnas 
-- comentarios ---> ultimo 
-- truncate de la dim --> recambiar 

select dim_recursos_aprenentatge_key, count(*) 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE  
group by 1
having count(*) > 1

--### codi_recurs: se repiten codi vs base de datos:    219060 - 208930 =  10,130  codi_recurs duplicados
select codi_recurs, max(origen_base_dades), min(origen_base_dades) , count(*) 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE  
group by 1
having count(*) > 1  
 

select distinct tipus_recurs   FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE;

 select  COUNT(DISTINCT TIPUS_RECURS) AS Distinct_TIPUS_RECURS 
 FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE;

 select  TIPUS_RECURS , COUNT(*) AS Distinct_TIPUS_RECURS 
 FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1

/**
'' 	116893 -- blanco 
Documents electrònics	24040
Webs	15612
Audiovisual	10080

*/


 select  ORIGEN_BASE_DADES , COUNT(*) AS Distinct_TIPUS_RECURS 
 FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1



select  ORIGEN_BASE_DADES,  * 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
where ORIGEN_BASE_DADES like '%ND%'


 
select  baixa , COUNT(*) AS Distinct_TIPUS_RECURS 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1
/**
S	4471
N	210534
null	4054
ND	1

*/



select  descripcio_idioma_recurs , COUNT(*) AS Distinct_TIPUS_RECURS 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1

 
/**
Xinès	70
Gallec	9
Anglès	39802
Italià	55
Castellà	93850
Català	79077
Basc	19
null	4580
Francès	1209
Alemany	357
ND	1

*/


select  format_recurs , COUNT(*) AS Distinct_TIPUS_RECURS 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1
order by 2 desc
/*
PDF	78665
HTML	51892
XML	31777
Web	28505
No Disponible	8283
*/



select  DATA_INICI_RECURS , COUNT(*) AS Distinct_TIPUS_RECURS 
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
where ORIGEN_BASE_DADES like 'DIMAX'
group by 1
order by 2 desc
/***

null	206460
2015-09-16 00:00:00.000	1574
2021-09-01 00:00:00.000	857

null dimax : 89566

*/

select data_inici_recurs, count(*)
from  db_uoc_prod.DDP_DOCENCIA.stage_recursos_aprenentatge_dimax  --  null dimax : 89566 
group by 1


--- 
select PUBLICAT_A_RECURS, count(*)
from  db_uoc_prod.DDP_DOCENCIA.stage_recursos_aprenentatge_dimax   
group by 1
order by 2 desc

-- > PUBLICAT_A_RECURS : datos no coherente ( fechas / entidades / titulos ... ) 
select PUBLICAT_A_RECURS, count(*)
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1
order by 2 desc


---### 
select URL_CAT_RECURS, URL_CAS_RECURS ,URL_ANG_RECURS ,  count(*)
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1,2,3
order by 4 desc

 
/***


recursos_coco: (null)			116893
null	null	null	5837
https://www.filmin.es/codigo	https://www.filmin.es/codigo	https://www.filmin.es/codigo	362
https://web.teaediciones.com/COMPETEA.aspx	https://web.teaediciones.com/COMPETEA.aspx	https://web.teaediciones.com/COMPETEA.aspx	36

 */



---### 
select MODUL_ORIGEN_ID ,  count(*)
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1 
order by 2 desc
/*
ND	208084
243968	14
226957	14
243969	14
243971	14

 */

select creation_date ,  count(*)
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1 
order by 2 desc




 select creation_date ,  count(*)
FROM db_uoc_prod.DDP_DOCENCIA.stage_recursos_aprenentatge_dimax

group by 1 
order by 2 desc


select creation_date , origen_base_dades,   count(*)
FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
group by 1 , 2 
order by 3 desc








--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 2) TASK VALIDACION: 
-- validacion recarga diaria 
select count(*)
-- * 
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS 
order by update_date desc 
limit 100;

/**ERRORS**/ -- RECARGA DIARIA
/*
-- incrementals : 16648831 vs 16624076 (yesterday)

Vigent	2024-12-18 17:16:08.236	2024-12-19 10:55:14.779
Vigent	2024-12-18 17:16:08.236	2024-12-19 10:55:14.779

*/
 

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3) RECURSOS QUE NO LLEGAN
select distinct codi_recurs
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA -- valido con la tabla completa --> 13,604,836 registros 
where 1=1
-- and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE )
and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA )

/**ERRORS**/
/* 
NO APARECEN EN LA DIM: 6
305213
302378
302376
296708
305233
296716


NO APARECEN EN LA POST: -- 5,268 registros --> problema @Francesc --> dimax 
258345
274926
234014
188220
258112
256394
267839
268873
263412
244943



---############################################################## 
perdemos informacion productos: 
db_uoc_prod.stg_dadesra.autors_productes_versions productos_plan_publicacion -- faltan mod, en esta tabla 
 
select  * 
FROM db_uoc_prod.stg_dadesra.autors_productes_versions 
inner join DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE 
on producte_id = codi_recurs


---##############################################################
select origen_base_dades, count(*)
FROM db_uoc_prod.stg_dadesra.autors_productes_versions 
inner join DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE 
on producte_id = codi_recurs
group by 1

--- REDACTAR CORREO
/*
ORIGEN_BASE_DADES	COUNT(*)
DIMAX	            28418
COCO_PROD	        248597
*/
*/


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 4) ASIGNATURAS QUE NO LLEGAN
select distinct DIM_ASSIGNATURA_KEY
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA -- valido con la tabla completa --> 13,604,836 registros 
where 1=1
and DIM_ASSIGNATURA_KEY not in ( select  distinct DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA )  --5,104,156 asignaturas post -> 15,797 asignaturas diferentes
-- and DIM_ASSIGNATURA_KEY not in ( select    DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA )  --18,091 asignaturas dim -> 18,091 asignaturas diferentes --> no duplicados

/* 
NO APARECEN EN DIM_ASSIGNATURA: -- 2 registros --> problema solucionado @Francesc : Asignaturas antiguas / error formato 
99.807
KK.RRR

*/
 


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--5) DIFERENCIA VALORES QUE NO LLEGAN  
select 
-- *
sum(usos_recurs_totals) as usos_recurs_totals  --- Flateneded: 13,604,836 registros vs 11,663,751 usados
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_AGG
where 1=1
-- and usos_recurs_totals <> 0  --- POST: 5,111,348  solo se usan : 123,250  ( correspondientes 4 ultimos semestres)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--6) ELEMENTOS NUM que no llegan a from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA 
-- justificar diferenncia de  Flateneded: 13,604,836 registros vs 11,660,733 usados  => 1,944,103 

select * 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA 
where codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- justificar   => 1,944,103  vs 1,921,341 se pierden solo con el codi_recurs 



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--7) ELEMENTOS NUM que no llegan a from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA 
-- justificar diferenncia de  Flateneded: 13,604,836 registros vs 11,660,733 usados  => 1,944,103 

select *, dades_academiques.codi_recurs  
FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA  as events  --- 13,604,836
-- select * from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA; --- 5,104,156
LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA  as dades_academiques -- 5,103,788
                    ON dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY
                    AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
                    AND dades_academiques.CODI_RECURS = events.CODI_RECURS

where dades_academiques.codi_recurs is null -- 1,941,085 --> no cruzan
-- and  events.codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- 1,921,341
-- and events.DIM_ASSIGNATURA_KEY not in ( select  distinct DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- todas las asignaturas estan 
and  events.codi_recurs  in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- 19,744 verificacion contraria --> elementos con no combinacion de codigo , asignatura y periodo


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- EXTRA VALIDATION
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
with temp_table_dim_key as (
    select 
        dades_academiques.DIM_ASSIGNATURA_KEY || dades_academiques.DIM_SEMESTRE_KEY || dades_academiques.CODI_RECURS as concat_key
 
        -- , dades_academiques.DIM_ASSIGNATURA_KEY
        -- , dades_academiques.DIM_SEMESTRE_KEY
        -- , dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY    
 
        , events.DIM_SEMESTRE_KEY
        , events.DIM_ASSIGNATURA_KEY
        , events.CODI_RECURS   

 
        , dades_academiques.CODI_RECURS as REC_CODI_RECURS
        , events.CODI_RECURS as EVENT_CODI_RECURS


 
    -- invers 
    --FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques  
    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events

    left join  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        AND dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 
 

) 

, comprobacion as (
    select * -- source2 , count(*) 

 
    from temp_table_dim_key --- 12,527,830 vs not null  --9,861,422 -- mucho mas cercano 

    where 1=1 
    AND REC_CODI_RECURS is null  --  2,666,408
    -- AND source2 <> 'BOTH'  --- 1,778,133
) 

SELECT distinct EVENT_CODI_RECURS-- * 5,248 resources no aparecen
from comprobacion 
where 1=1 
-- AND DIM_ASSIGNATURA_KEY not in ( select DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA   ) -- all resources included
and EVENT_CODI_RECURS not in ( select Codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- all resources included 1,762,759 vs  1,781,031 (BOTH difference)

/*

null	20232	UX.195	COCO - 299075	null	299075 --> analizamos este
null	20241	UX.195	COCO - 299078	null	299078 
null	20232	21.532	COCO - 300124	null	300124
null	20241	13.544	COCO - 300376	null	300376
null	20232	71.529	DIMAX - 110283	null	110283  --> analizamos este 2
null	20232	71.529	DIMAX - 110283	null	110283
null	20231	78.599	DIMAX - 96421	null	96421
null	20232	21.152	DIMAX - 98638	null	98638
-

*/

SELECT * 
from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques  
where 1=1
    AND dades_academiques.DIM_ASSIGNATURA_KEY = 'UX.195'
    -- AND dades_academiques.DIM_SEMESTRE_KEY = '20232' -- solo 2 recursos para ese semestre --> francesc         299073, 60730
    AND dades_academiques.codi_recurs  in  (
        '299233',
        '299073',
        '282957',
        '60730',
        '299234',
        '52636',
        '278115',
        '52660'
    )

SELECT * 
from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques  
where 1=1
    AND dades_academiques.DIM_ASSIGNATURA_KEY = '71.529'
    AND dades_academiques.DIM_SEMESTRE_KEY = '20232' -- solo 2 recursos para ese semestre --> francesc         299073, 60730
    AND dades_academiques.codi_recurs  in  (
        '299233',
        '299073',
        '282957',
        '60730',
        '299234',
        '52636',
        '278115',
        '52660'
    )



--REVISAR : salen en usos 
select * 
-- from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE -- estan todos 
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO -- no aparecen
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX --- no aparecen 
where codi_recurs in ( 

'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)


-- Coco BASE: 
select * 
FROM db_uoc_prod.stg_dadesra.autors_productes_versions productos_plan_publicacion  -- 247,902 vs  247,90
where PRODUCTE_ID in ( 

'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)



-- DIMAX_BASE: 
select * 
from  db_uoc_prod.stg_dadesra.dimax_resofite_path  -- no aparece 
where node_cami in (
'294864',
'225145',
'294255',
'261666',
'249559',
'144806',
'186555',
'247935',
'221399',
'214717',
'233814',
'249730',
'244609',
'188220',
'244611',
'250928',
'259387',
'247551',
'277255',
'218275',
'141193',
'171873',
'237360',
'218258',
'224895',
'275360',
'177246',
'249103',
'277171',
'258047',
'262444',
'103318',
'260024',
'141757',
'246480'

)



dim_assignatura --> var_assignatura : estado activo en dim_assignatura 

renombrando los esquemas 
* procedimiento_oficial --> tardara 



---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
comentarios post actualizacion: 
*/
---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

select cod_asignatura , any_academico, count(*) 
from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS
group by  1,2
having count(*) > 1 
order by 3 desc 


select * 
from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS  -- 18 profesores
where cod_asignatura = '80.560' and any_academico =20231

---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DUPLICADOS FLATENED --> 303 vs 357 
---~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
select * 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA  
where 1=1
-- and event_time like '2024-12-17 09:47:19.497'   -- revisar duplicados 
-- and event_time like '2024-12-12 06:04:46.252' --2 
-- and event_time like '2024-05-18 06:12:18.091'; --4
and event_time like '2024-04-16 16:10:29.351'; -- registros 8 


select event_time,nom_actor, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA 
group by 1,2
having count(*) > 1;


/*

-- 303 duplicados
03.521	20241	COCO - 298615	2024-12-12 06:04:46.252	2
20.026	20241	COCO - 279634	2024-12-05 15:53:10.073	2
71.500	20241	COCO - 278690	2024-12-16 21:39:46.926	2
86.615	20241	COCO - 276035	2024-10-08 09:49:16.344	2
73.555	20241	COCO - 295623	2024-10-22 16:37:09.768	2
10.176	20232	DIMAX - 108204	2024-05-14 15:54:28.017	2
00.668	20241	COCO - 258591	2024-10-24 16:51:02.348	2
CA.057	20241	COCO - 295911	2024-10-10 12:46:37.193	2
00.668	20241	COCO - 258593	2024-10-12 17:04:19.795	2
10.213	20241	COCO - 289195	2024-11-23 19:15:40.860	2
20.130	20232	DIMAX - 72247	2024-04-09 12:35:28.712	2
18.108	20232	DIMAX - 118344	2024-06-22 15:08:23.981	2
80.197	20241	DIMAX - 66272	2024-11-21 10:42:15.236	2
M4.351	20232	DIMAX - 76912	2024-03-08 10:32:02.847	2
86.614	20232	DIMAX - 66012	2024-03-27 18:58:48.500	2


*/


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--3) Recursos que estan en las tablas de dimension de recursos pero no en las que creamos las stage --> base para el resto 
-- REVISION FRANCESC 
--- ANALISIS DE REGISTROS FALTANTES


with temp_table_dim_key as (
    select 
        dades_academiques.DIM_ASSIGNATURA_KEY || dades_academiques.DIM_SEMESTRE_KEY || dades_academiques.CODI_RECURS as concat_key
 
        , events.DIM_SEMESTRE_KEY
        , events.DIM_ASSIGNATURA_KEY
        , events.CODI_RECURS   

 
        , dades_academiques.CODI_RECURS as REC_CODI_RECURS
        , events.CODI_RECURS as EVENT_CODI_RECURS


 
    -- invers 
    --FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques  
    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events

    left join  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        AND dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 
 

) 

, comprobacion as (
    select * -- source2 , count(*) 
    from temp_table_dim_key --- 12,527,830 vs not null  --9,861,422 -- mucho mas cercano 
    where 1=1 
    AND REC_CODI_RECURS is null   
) 

SELECT distinct EVENT_CODI_RECURS-- * 5,248 resources no aparecen
from comprobacion 
where 1=1 
-- AND DIM_ASSIGNATURA_KEY not in ( select DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA) -- all resources included
and EVENT_CODI_RECURS not in ( select Codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- 


-- recursos que aparecen en events ( stage_live_events) pero no en (post_dades_academiques) el catalogo proporcionado por profesor : -- 5,267 --> count 
/*
245850
274926
200473
192444
255112
267839
232776
124765
244943
166814
247940
243436
144794
258545
263706
137392
194769
214459
275290
234348


*/



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--3) Recursos que estan en las tablas de dimension de recursos pero no en las que creamos las stage --> base para el resto 
-- REVISION FRANCESC 
--- ANALISIS DE REGISTROS FALTANTES
with temp_table_dim_key as (
    select 
        dades_academiques.DIM_ASSIGNATURA_KEY || dades_academiques.DIM_SEMESTRE_KEY || dades_academiques.CODI_RECURS as concat_key
 
        , events.DIM_SEMESTRE_KEY
        , events.DIM_ASSIGNATURA_KEY
        , events.CODI_RECURS   

 
        , dades_academiques.CODI_RECURS as REC_CODI_RECURS
        , events.CODI_RECURS as EVENT_CODI_RECURS


 
    -- invers 
    --FROM  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques  
    FROM  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events

    left join  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques   -- 4 ultimos anos : 8,741,384 vs 123,019 --> datos by semestre, asignatura, producto grouped
        on dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY -- 114,821,250
        AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
        AND dades_academiques.CODI_RECURS = events.CODI_RECURS -- 43k  -- agrupar por 
 

) 

, comprobacion as (
    select * -- source2 , count(*) 
    from temp_table_dim_key --- 12,527,830 vs not null  --9,861,422 -- mucho mas cercano 
    where 1=1 
    AND REC_CODI_RECURS is null   
) 

SELECT distinct DIM_ASSIGNATURA_KEY-- * 5,248 resources no aparecen
from comprobacion 
where 1=1 
AND DIM_ASSIGNATURA_KEY not in ( select DIM_ASSIGNATURA_KEY from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA) -- all resources included
-- and EVENT_CODI_RECURS not in ( select Codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA ) -- 


-- recursos que aparecen en events ( stage_live_events) pero no en (post_dades_academiques) el catalogo proporcionado por profesor : -- 5,267
/*
 


*/



--  posibilidad combinatoria asignatura y recurso 

* --> 12
 --> b0112
 -->  post_dades_academiques --> catalogo ( 12 , b0112  )


--- : 
-- select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;  -- 16,552,336  -- 16,555,471 
-- -- truncate table DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
-- --  select *  from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS_LOADS

select * 
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
where usos_recurs_totals = 0;  -- 4,987,916 

select sum(usos_recurs_totals)
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  -- 11_568_302 / 16_



select *  





---> contestar el mail con la confirmacion --> preparacion de revision 




--- fact validacion ;
---  select count(*) from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS -- 16559844 vs 16559844 vs 16559844

select *  from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS limit 100

--- ver numero de registros --> subiendo --> 

/***

Uncaught exception of type 'STATEMENT_ERROR' on line 8 at position 4 : Duplicate row detected during DML action
Row Values: [8105, 82, 106513, 49627407, 601914, "80.199", 20241, "COCO - 290134", "COCO", 290134, 290134, "2024-10-17 19:50:55.835", "2024-10-17", "NavigatedTo", "Alicia Martinez Barros", "Person", "amartinezbarros", "1461717", "80.199 - Psicología de la percepción y la emoción - Aula 7", "45947", "A_20241_80.199_7", "["Learner"]", "Active", NULL, "https://ralti.uoc.edu/niu/523100/290134", NULL, "DigitalResource", "info", "NIU", NULL, 1, 1, "Vigent", 1734457389508000000, 1734457389508000000]

*/



  --- DIM_PERSONA_KEY, 
-- DIM_ASSIGNATURA_KEY, DIM_SEMESTRE_KEY, codi_recurs,  EVENT_TIME, count(*)
 
--  from  DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA       
-- -- from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
-- group by 1,2,3,4
-- having count(*) > 1 


 -- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA
-- select * from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA  --  13,501,002








select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS order by update_date desc limit 100;  
select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS;  
 







-- >  recurso y la asignatura 
-- 3) RECURSOS QUE NO LLEGAN

with aux as ( 
select distinct codi_recurs
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA -- valido con la tabla completa --> 13,604,836 registros 
where 1=1
-- and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE )
and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA )
) 
--- 
select 
 origen_base_dades, count(*)
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
-- where codi_recurs in  ( select codi_recurs from aux ) 
group by 1
 
--########################################################--########################################################

with aux as ( 
select distinct codi_recurs
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA -- valido con la tabla completa --> 13,604,836 registros 
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
where 1=1
-- and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE )
and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA )
) 
--- 
select 
 origen_base_dades, count(*)
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE ra_dim
inner join aux 
on aux.codi_recurs = ra
group by 1







--- with aux as ( 
select distinct codi_recurs
-- from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA -- valido con la tabla completa --> 13,604,836 registros 
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
where 1=1
-- and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE )
and codi_recurs not in ( select codi_recurs from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA )
) 
--- 
select 
 origen_base_dades, count(*)
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE ra_dim
inner join aux 
on aux.codi_recurs = ra
group by 1
 


select origen_base_dades, count(*)
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS aux
inner join DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE ra_dim
 on aux.ID_CODI_RECURS = ra_dim.ID_CODI_RECURS
 group by 1

/*
DIMAX	9898126
COCO_PROD	6753527 
 
*/





select distinct dim_assignatura_key
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  -- 15,797

---####################################################################################################################
--- check assignaturas 
select distinct aux_temporary_table.dim_assignatura_key 

from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS as aux_temporary_table

LEFT JOIN DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA asignatura 
    ON asignatura.DIM_ASSIGNATURA_KEY = aux_temporary_table.DIM_ASSIGNATURA_KEY
        
where asignatura.id_assignatura is null

/*
select * from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA 
where dim_assignatura_key in ( 
50.000
501.02
501.04
501.07
501.10
501.13
501.14
501.15
501.16
501.19
501.28
502.02
504.01
504.02
506.20
506.21
506.22
SL.001
SL.002
SL.003
SL.004
SL.101
UL.040
UL.041
UL.042
UL.043

) 
*/
--- check DIM_SEMESTRE_KEY 
select distinct aux_temporary_table.DIM_SEMESTRE_KEY 

from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS    aux_temporary_table
 
            
            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_SEMESTRE semestre 
                ON semestre.DIM_SEMESTRE_KEY = aux_temporary_table.DIM_SEMESTRE_KEY
where semestre.DIM_SEMESTRE_KEY is null


--- check DIM_RECURSOS_APRENENTATGE_KEY 
select distinct fact_events.DIM_RECURSOS_APRENENTATGE_KEY 

from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS    fact_events

LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE recursos 
-- ON recursos.id_codi_recurs = fact_events.id_codi_recurs
ON recursos.DIM_RECURSOS_APRENENTATGE_KEY = fact_events.DIM_RECURSOS_APRENENTATGE_KEY

where 1=1
-- and  recursos.id_codi_recurs = 1 
and recursos.DIM_RECURSOS_APRENENTATGE_KEY is null

/*
DIMAX - 14314
DIMAX - 105354
DIMAX - 14316
*/




--- check DIM_PERSONA_KEY 
select distinct fact_events.DIM_PERSONA_KEY 

from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS    fact_events  -- 1,059

LEFT JOIN DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona 
    ON dim_persona.DIM_PERSONA_KEY = fact_events.DIM_PERSONA_KEY

where dim_persona.DIM_PERSONA_KEY is null

/*
301100650
30100462
*/

select * from  DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona -- 1,244,767
where dim_persona.DIM_PERSONA_KEY is null

select  fact_events.DIM_PERSONA_KEY, count(*) --1_291_995 -> 10%
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS    fact_events  -- 1,059  -- vs 1,070 
group by 1 order by 2 desc 


select *  
from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS    fact_events  
limit


--####################
with aux  as ( 
        select    
            cod_asignatura 
            , any_academico -- formato semestre
            , max(idp) as idp  -- seleccionamos al max profesor : no granularidad 1:1 victor
        from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS
        group by  1,2 
) 
-- select distinct idp from aux 
select   cod_asignatura , count(*)
from aux 
where cod_asignatura not in ( select dim_assignatura_key from DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA)
group by 1 
order by 2 desc 



--####################
with aux  as ( 
        select    
            cod_asignatura 
            , any_academico -- formato semestre
            , max(idp) as idp  -- seleccionamos al max profesor : no granularidad 1:1 victor
        from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS
        group by  1,2 
) 
 
select   cod_asignatura , idp , any_academico , count(*)  -- 76 combinaciones perdidas 
from aux 
where idp not in ( 
        select   fact_events.DIM_PERSONA_KEY  
        from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  fact_events 
 
        )
group by 1 , 2 , 3
order by 4 desc 
 
--####################
with aux  as ( 
        select    
            cod_asignatura 
            , any_academico -- formato semestre
            , max(idp) as idp  -- seleccionamos al max profesor : no granularidad 1:1 victor
        from DB_UOC_PROD.STG_DADESRA.GAT_PERSONAS_ASIGNATURAS
        group by  1,2 
) 
select distinct cod_asignatura, any_academico , idp
from  aux  as aux -- 283,154 
left  join  DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA fact 

on fact.dim_assignatura_key= aux.cod_asignatura 
and fact.dim_semestre_key = aux.any_academico

where fact.dim_semestre_key is null
 and  idp not in ( 
        select   fact_events.DIM_PERSONA_KEY  
        from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  fact_events 
 
        )


        listado recursos que perdemos 3 no existen dim_recursos_aprenentatge
        post _prod_mod --> dades_academiques 5,200 k --> recursos modulos no contabilizando  
        listado asignaturas que perdemos 733 
        listado asignaturas  y semestre --> no detectando en la post 76 

--> 







LEFT JOIN 

select * from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA asignatura --733
order by  id_assignatura asc  limit 100; 

select *  from DB_UOC_PROD.DD_OD.DIM_SEMESTRE semestre  0 
order by  id_semestre asc  limit 100; 

select id_codi_recurs
from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE recursos  -- 1
order by  id_codi_recurs asc  limit 100; 


select id_persona
from DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona 0
order by  id_persona asc  limit 100; 
