

-- francesc
-- listado recursos no matchean / no existen STAGE_LIVE_EVENTS_FLATENED_RA
-- listado asignaturas no matchean / no existen STAGE_LIVE_EVENTS_FLATENED_RA

-- Previa: delete confirmation --> borramos modulos duplicados coco --> francesc 02/12/2024
select * 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_RECURSOS_APRENENTATGE_COCO_PRODUCT_MODULS
where codi_recurs in ( SELECT codi_recurs FROM DB_UOC_PROD.DDP_DOCENCIA.T_COCO_PROD_TEMP_DUPLICATES_TEMP ) 



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1) RECURSOS QUE NO LLEGAN
select * 
from DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS

where 1=1
-- AND SOURCE2 = 'ERROR' -- no aparecen en dimax ni coco  -- 6 : ---> francesc revisa 
and SOURCE2 = 'BOTH'  -- codigo en las 2 pero no sabemos como asignarlo  -- 3,534

select SOURCE2, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_RESOURCES_CALIPER_EVENTS
group by 1
order by 2 desc 


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--2) ASIGNATURAS QUE NO LLEGAN 
select * 
from  DB_UOC_PROD.DDP_DOCENCIA.ANALISIS_ASSIGNATURA_EVENTS
where 1=1
and DIM_ASSIGNATURA_KEY_origen = 'ERROR'

/*

DIM_ASSIGNATURA_KEY	    NUM_EVENTS	DIM_ASSIGNATURA_KEY_ORIGEN
KK.RRR	                14	        ERROR
99.807	                48	        ERROR


-- docente : persona docente --> fact 
asignaturas equivalentes
periodo validez en la asignatura 
* victor : equipo  
* francesc 

*/


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--3) Recursos que estan en las tablas de dimension de recursos pero no en las que creamos las stage --> base para el resto 
-- REVISION FRANCESC 
--- ANALISIS DE REGISTROS FALTANTES
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
 








