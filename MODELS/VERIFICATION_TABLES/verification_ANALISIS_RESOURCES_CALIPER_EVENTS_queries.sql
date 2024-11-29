

-- -- #################################################################################################
-- codi_recurs_origen = 'ERROR'
-- -- #################################################################################################
/*
select codi_recurs_origen , count(*) from codi_recurs_valoration group by 1 order by 2 desc

CODI_RECURS_ORIGEN	COUNT(*)
DIMAX	            33389
COCO	            30859
BOTH	            7290
ERROR	            11
    * not fount in base tables: 
        db_uoc_prod.stg_dadesra.autors_producte  -- coco_prod
        db_uoc_prod.stg_dadesra.autors_modul autors_modul  -- coco_mod
        db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax  -- dimax
        db_uoc_prod.stg_dadesra.dimax_v_recurs -- id_recurs --> origen tables 
    
    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'
*/

select * 
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED 
where 1=1
and codi_recurs in (

    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'

)



-- FROM db_uoc_prod.stg_dadesra.autors_producte  -- 55,848
select * FROM db_uoc_prod.stg_dadesra.autors_producte  
where 1=1
    and id in (

    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'

)


select * FROM db_uoc_prod.stg_dadesra.autors_modul autors_modul  
    -- left join productos_aux autors_producte on autors_producte.codi_recurs = autors_modul.PRODUCTE_CREACIO_ID 
where 1=1
    and id in (

    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'

)



select * 
from db_uoc_prod.stg_dadesra.dimax_v_recurs -- id_recurs --> origen tables 
where 1=1
    and id_recurs in (

    -- and codi_recurs_origen = 'ERROR'
    '302376',
    '305233',
    '302376',
    '305213',
    '305213',
    '302378',
    '302378',
    '296708',
    '296716',
    '305213',
    '305233'

)
