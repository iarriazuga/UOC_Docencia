-- Crear la tabla lookup


with descripciones as (


select 
Clave, DESCRIPCION
--* 
-- Clave, max(DESCRIPCION)  as DESCRIPCION 
from   DB_UOC_PROD.STG_DOCENCIA.GAT_DESCRIPCIONES descripciones  --- 22,337

WHERE 1=1
and descripciones.cod_idioma = 'CAT'
and descripciones.nom_tabla = 'AREAS_ESTUDIOS'
--   AND LENGTH(descripciones.clave) = 3
--   and try_cast(descripciones.clave as int) is   null
--   AND  (descripciones.clave) = 'PSI'

-- group by 1 
)

 

 
select *  
from   db_uoc_prod.dd_od.dim_assignatura   assignatura-- 18,095
left join   descripciones  --- 22,337
on descripciones.clave = assignatura.COD_ESTUDIS_AREA
 


 select  DESCRIPCION, length(descripcion)
--* 
-- Clave, max(DESCRIPCION)  as DESCRIPCION 
from   DB_UOC_PROD.STG_DOCENCIA.GAT_DESCRIPCIONES descripciones  --- 22,337

WHERE 1=1
and descripciones.cod_idioma = 'CAT'
and descripciones.nom_tabla = 'AREAS_ESTUDIOS'

order by length(descripcion) desc 
--   AND LENGTH(descripciones.clave) = 3


DESCRIBE TABLE DB_UOC_PROD.STG_DOCENCIA.GAT_DESCRIPCIONES;
