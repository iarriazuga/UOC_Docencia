/*
DADES_ACADEMIQUES:
    Asignatura
    profesores 
    estudios 
    recursos que usa 


Relacionar tablas: 
- que recursos se acceden ( live_events, cursos, etc)
- que recursos de las asignaturas se usan 



*/
CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DADES_ACADEMIQUES AS  -- DDP_DOCENCIA
select distinct 
    upper(accesos.source)  || '-'|| accesos.material_id as ID_CODI_RECURS,  
    asignatura.cod_asignatura || '-'|| accesos.material_id  as ID_ASIGNATURA_RECURS, 
    
    asignatura.cod_asignatura, 
    asignatura.desc_asignatura, 
    accesos.semester,  -- problema duplicidades 
    accesos.source, 
    accesos.object_id, 
    accesos.object_name, 
    accesos.object_type,
    accesos.material_id
 
from DB_UOC_PROD.STG_DADESRA.GAT_ASIGNATURAS asignatura  

inner join   DB_UOC_PROD.STG_DADESRA.T_SAA_ACCESSOS_RA accesos 
  on accesos.subjectcode = asignatura.cod_asignatura

where upper(accesos.source) || accesos.material_id is not null;
 

--  drop table DB_UOC_PROD.DDP_DOCENCIA.DADES_ACADEMIQUES;
-- select * from DB_UOC_PROD.DDP_DOCENCIA.DADES_ACADEMIQUES