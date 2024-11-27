
/**/
select * from auxiliar
where  DIM_SEMESTRE_KEY = 20241
-- and times_used is null  -- 337,177
and times_used is not null  -- 13,616


/* */
-- Tables dim usadas: 
DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE
DB_UOC_PROD.DD_OD.dim_semestre semestre
DB_UOC_PROD.stg_dadesra.autors_element_formacio asignatura

-- tablas fact calculo: 
DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS


-- tablas fact auxiliares: 
DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_DIMAX
DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO



select distinct id_resource from DB_UOC_PROD.DDP_DOCENCIA.STAGE_POST_DADES_ACADEMIQUES_EVENTS
where  DIM_SEMESTRE_KEY = 20241
and times_used is null  -- 48,805
-- and times_used is not null  -- 8,934



/*

ASIGNATRUA DONDE NADIE USA NADA
ID_RESOURCE	 FLAT_EVENTS --> LLEGAN CUANDO SE HACEN LAS JOIN ? 
RECURSOS_ACADEMICOS --> ALGUNO QUE NO ESTE EN NUESTRA DIM? RECURSOS USANDOSE QUE NO 





*/















select  DIM_SEMESTRE_KEY, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events
group by 1 
order by 2 desc

select  DIM_ASSIGNATURA_KEY, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events
group by 1 
order by 2 desc


select  ID_RESOURCE, count(*) 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events
group by 1 
order by 2 desc

select * 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_TRANSFORMED events
where ID_RESOURCE in (
    '284183'	
    ,'107565'	
    ,'283526'	
    ,'97376'	
    ,'82871'	
    ,'64972'	
    ,'76011'	
    ,'268878'	
    ,'95753'	
    ,'83748'	
    ,'66707'	
    ,'100209'	
    ,'96814'	
    ,'117210'	
    ,'31731'
)

/*

'284183'	
,'107565'	
,'283526'	
,'97376'	
,'82871'	
,'64972'	
,'76011'	
,'268878'	
,'95753'	
,'83748'	
,'66707'	
,'100209'	
,'96814'	
,'117210'	
,'31731'	
 


91447	4
93516	4
87742	4
106990	4
62149	4
263965	4
49478	4
93015	4
287492	4
112254	4
59240	4
119242	4
245303	4
70716	4
91127	4
287374	4
51348	4
272929	4
64477	4
65486	4
275286	4
248457	4
86369	4
298277	4
79518	4
286977	4
110622	4
247555	4
289374	4
82584	4
119252	4
258144	4
285440	4
90632	4
87714	4
83885	4
88309	4
94356	4
52932	4
274332	4
220761	4
101499	4
89064	4
98532	4
73271	4
108265	4
294503	4
82646	4
70755	4
110287	4
117456	4
92004	4
273774	4
22497	4
51011	4
89674	4
249342	4
113469	4
98245	4
79371	4
297474	4



*/


/*

dim_catalog --> todos los elementos de producto  --> no tiene asignatura 

SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE 


SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.STAGE_DADES_ACADEMIQUES_COCO 

SELECT 
    asignatura
    , semestre_id
    , codi_producto_coco
    , titulo_prod_coco
    ,  PLAN_ESTUDIOS_BASE
FROM DB_UOC_PROD.DDP_DOCENCIA.DADES_ACADEMIQUES


*/