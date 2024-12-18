with aux as (
            SELECT 
                asignatura.id_assignatura,
                semestre.id_semestre,
                recursos.id_codi_recurs,
                dim_persona.id_persona,

                aux_temporary_table.DIM_PERSONA_KEY,
                aux_temporary_table.DIM_ASSIGNATURA_KEY,
                aux_temporary_table.DIM_SEMESTRE_KEY,
                aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY,
                
                aux_temporary_table.ORIGEN_DADES_ACADEMIQUES,
                aux_temporary_table.CODI_RECURS,
                aux_temporary_table.CODI_RECURS AS EVENT_CODI_RECURS,
                aux_temporary_table.EVENT_TIME,
                aux_temporary_table.EVENT_DATE,
                aux_temporary_table.ACCIO,
                aux_temporary_table.NOM_ACTOR,
                aux_temporary_table.ACTOR_TIPUS,
                aux_temporary_table.usuari_dAcces,
                aux_temporary_table.id_idp_usuari_events,
                aux_temporary_table.titol_assignatura,
                aux_temporary_table.id_curs_canvas,
                aux_temporary_table.id_sistema_curs,
                aux_temporary_table.ROL,
                aux_temporary_table.estat_membre,
                aux_temporary_table.titol_recurs,
                aux_temporary_table.enllac,
                aux_temporary_table.OBJECT_MEDIATYPE,
                aux_temporary_table.tipus_recurs,
                aux_temporary_table.format_recurs,
                aux_temporary_table.Origen_events,
                aux_temporary_table.enllac_url,

                CASE WHEN aux_temporary_table.ROL LIKE '["Learner"]' THEN 1 ELSE 0 END AS usos_recurs_estudiants,
                CASE WHEN aux_temporary_table.ROL IS NULL THEN 0 ELSE 1 END AS usos_recurs_totals,
                aux_temporary_table.assignatura_vigent_semester 

            FROM (
                SELECT 
                    dades_academiques.DIM_PERSONA_KEY,
                    dades_academiques.DIM_ASSIGNATURA_KEY,
                    dades_academiques.DIM_SEMESTRE_KEY,
                    dades_academiques.DIM_RECURSOS_APRENENTATGE_KEY,
                    dades_academiques.ORIGEN_DADES_ACADEMIQUES,
                    dades_academiques.CODI_RECURS,
                    events.CODI_RECURS AS EVENT_CODI_RECURS,
                    events.EVENT_TIME,
                    events.EVENT_DATE,
                    events.ACCIO,
                    events.NOM_ACTOR,
                    events.ACTOR_TIPUS,
                    events.usuari_dAcces,
                    events.id_idp_usuari_events,
                    events.titol_assignatura,
                    events.id_curs_canvas,
                    events.id_sistema_curs,
                    events.ROL,
                    events.estat_membre,
                    events.titol_recurs,
                    events.enllac,
                    events.OBJECT_MEDIATYPE,
                    events.tipus_recurs,
                    events.format_recurs,
                    events.Origen_events,
                    events.enllac_url, 
                    dades_academiques.assignatura_vigent_semester 
                     

                FROM DB_UOC_PROD.DDP_DOCENCIA.POST_DADES_ACADEMIQUES_RA dades_academiques -- 5,103,788

                LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA events  --- 16,556,218
                    ON dades_academiques.DIM_ASSIGNATURA_KEY = events.DIM_ASSIGNATURA_KEY
                    AND dades_academiques.DIM_SEMESTRE_KEY = events.DIM_SEMESTRE_KEY
                    AND dades_academiques.CODI_RECURS = events.CODI_RECURS

            ) aux_temporary_table

            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA asignatura 
                ON asignatura.DIM_ASSIGNATURA_KEY = aux_temporary_table.DIM_ASSIGNATURA_KEY
            
            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_SEMESTRE semestre 
                ON semestre.DIM_SEMESTRE_KEY = aux_temporary_table.DIM_SEMESTRE_KEY
            
            LEFT JOIN DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_APRENENTATGE recursos 
                ON recursos.DIM_RECURSOS_APRENENTATGE_KEY = aux_temporary_table.DIM_RECURSOS_APRENENTATGE_KEY

            LEFT JOIN DB_UOC_PROD.DD_OD.DIM_PERSONA dim_persona 
                ON dim_persona.DIM_PERSONA_KEY = aux_temporary_table.DIM_PERSONA_KEY

        ) 
        
        

----~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
select 
    
    0 as DIM_PERSONA_KEY
    , DIM_ASSIGNATURA_KEY
    , DIM_SEMESTRE_KEY
    , codi_recurs
    , EVENT_TIME
    , id_idp_usuari_events
    ,  count(*) as num_events

-- from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS  
from DB_UOC_PROD.DDP_DOCENCIA.STAGE_LIVE_EVENTS_FLATENED_RA
where event_time is not null and id_idp_usuari_events is not null
group by 1,2,3,4,5,6
having count(*) > 1 

        






        ON target.DIM_PERSONA_KEY = source.DIM_PERSONA_KEY
        AND target.DIM_ASSIGNATURA_KEY = source.DIM_ASSIGNATURA_KEY
        AND target.DIM_SEMESTRE_KEY = source.DIM_SEMESTRE_KEY
        AND target.DIM_RECURSOS_APRENENTATGE_KEY = source.DIM_RECURSOS_APRENENTATGE_KEY
        AND target.EVENT_TIME = source.EVENT_TIME 
        AND target.id_idp_usuari_events= source.id_idp_usuari_events



where event_time is not null and id_idp_usuari_events is not null