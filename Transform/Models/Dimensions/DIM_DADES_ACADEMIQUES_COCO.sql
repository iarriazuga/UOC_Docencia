-- EXPLOTACION COCO: importante 

--ASSIGANTURES -- ELEMENT FORMACIO -- Trobar l'Assignatura i el seu id intern
-- CODI_FINAL = Codi Assignatura
select * from db_uoc_prod.stg_dadesra.autors_element_formacio limit 10;
-- Trobar l'assignatura en base a un codi B0.911 -> id assignatura a coco 4542
select * from db_uoc_prod.stg_dadesra.autors_element_formacio where codi_final='B0.911' limit 10;
-- assignatura amb productes assciats M2.988 -> 54605
select * from db_uoc_prod.stg_dadesra.autors_element_formacio where codi_final='M2.988' limit 10;

-- PRODUCTES = Materials 
-- Llista de materials existens (Ex. Producte 149299 de la B0.911)
select * from db_uoc_prod.stg_dadesra.autors_producte limit 10;
select * from db_uoc_prod.stg_dadesra.autors_producte where id = 149299;
select * from db_uoc_prod.stg_dadesra.autors_producte where id = 153678;
select * from db_uoc_prod.stg_dadesra.autors_producte where id = 259395;
select * from db_uoc_prod.stg_dadesra.autors_producte where id = 265006;
select * from db_uoc_prod.stg_dadesra.autors_producte where id = 233201;
select * from db_uoc_prod.stg_dadesra.autors_producte where PARAULA_CLAU is not NULL limit 50;
select * from db_uoc_prod.stg_dadesra.autors_producte where codi_recurs_origen is not NULL limit 50;
select * from db_uoc_prod.stg_dadesra.autors_producte where codi_recurs_origen is not NULL limit 50;

-- MÒDULS_PRODUCTES = Relació entre producte i mòdul relacionat
select * from db_uoc_prod.stg_dadesra.autors_moduls_productes where producte_id = 259395;
select * from db_uoc_prod.stg_dadesra.autors_moduls_productes where modul_id = 259397;


-- MÒDULS = Part components d'alguns Produtes
select * from db_uoc_prod.stg_dadesra.autors_modul where id = 259397;
select * from db_uoc_prod.stg_dadesra.autors_modul where obra_id is not null;
select * from db_uoc_prod.stg_dadesra.autors_modul where codi_migracio is not null;
select * from db_uoc_prod.stg_dadesra.autors_modul where obra_id is not null;
select * from db_uoc_prod.stg_dadesra.autors_modul limit 100;


// TO-DO per Xavi: Cal relacionar via 

--  VERSIONS DEL PRODUCTE -- Relaciona el pla de publicació amb el producte
select * from db_uoc_prod.stg_dadesra.autors_productes_versions limit 10;
-- Busco les vesrions del producte 149299
select * from db_uoc_prod.stg_dadesra.autors_productes_versions where producte_id = 149299 limit 10;
-- Busco les vesrions del producte 153678 <- Declació de Barcelonoa
select * from db_uoc_prod.stg_dadesra.autors_productes_versions where producte_id = 153678 limit 10;
-- Productes d'un pla de publicació de la B0.911 que té la Declació de Barcelona - Semestre 20211
select * from db_uoc_prod.stg_dadesra.autors_productes_versions where versio_id = 94420;
-- Tots els productes de l'assignatura B0.911
select * from db_uoc_prod.stg_dadesra.autors_productes_versions where versio_id IN (94420,45763,42122,38629);
-- Productes d'un pla de publicació de la M2.988 amb productes associats
select * from db_uoc_prod.stg_dadesra.autors_productes_versions where versio_id = 127754;

-- PLANS DE PUBLICACIÓ
select * from db_uoc_prod.stg_dadesra.autors_versio limit 10;
-- ******  busco plans de publicació del producte 149299 
select * from db_uoc_prod.stg_dadesra.autors_versio where fk_element_formacio_element_id = 4542;
-- assignatura amb productes assciats M2.988 -> pla publ 127754
select * from db_uoc_prod.stg_dadesra.autors_versio where fk_element_formacio_element_id = 54605;
;
-- busco el pla de publicació de la B0.911 amb codi 38608
select * from db_uoc_prod.stg_dadesra.autors_versio where fk_periode_periode_id = 38608;
-- busco el id de versió 38629 que està associat al producte 153678 Declaració de Barcelona
select * from db_uoc_prod.stg_dadesra.autors_versio where id = 38629;
-- busco el pla de publicació 886681 de la B0.911 -> agafa només un procte i n'hi ha 15 -> id resulant 94420 a buscar a verions
select * from db_uoc_prod.stg_dadesra.autors_versio where fk_encarrec_encarrec_id = 88681;
select * from db_uoc_prod.stg_dadesra.autors_versio where fk_encarrec_encarrec_id = 42022;

select count(1) from db_uoc_prod.stg_dadesra.autors_productes_versions; --241043
select count(1) from db_uoc_prod.stg_dadesra.autors_producte; --54875
select count(1) from db_uoc_prod.stg_dadesra.autors_element_formacio; --33584
select count(1) from db_uoc_prod.stg_dadesra.autors_versio; --44747
select * from db_uoc_prod.stg_dadesra.autors_encarrec limit 100;
select * from db_uoc_prod.stg_dadesra.autors_suport_producte_i18n limit 100;
select * from db_uoc_prod.stg_dadesra.autors_tipus_tramesa_i18n limit 100;
select * from db_uoc_prod.stg_dadesra.autors_producte where titol like '%Mòdul 3.%';

select *
from db_uoc_prod.stg_dadesra.autors_productes_versions
inner join db_uoc_prod.stg_dadesra.autors_producte
on db_uoc_prod.stg_dadesra.autors_productes_versions.producte_id = db_uoc_prod.stg_dadesra.autors_producte.id
inner join db_uoc_prod.stg_dadesra.autors_versio
on db_uoc_prod.stg_dadesra.autors_productes_versions.versio_id = db_uoc_prod.stg_dadesra.autors_versio.id
inner join db_uoc_prod.stg_dadesra.autors_element_formacio
on db_uoc_prod.stg_dadesra.autors_versio.fk_element_formacio_element_id = db_uoc_prod.stg_dadesra.autors_element_formacio.id
inner join db_uoc_prod.stg_dadesra.autors_periode
on db_uoc_prod.stg_dadesra.autors_versio.fk_periode_periode_id = db_uoc_prod.stg_dadesra.autors_periode.id
where autors_element_formacio.codi_final = 'M8.020'
-- where db_uoc_prod.stg_dadesra.autors_productes_versions.producte_id = '248075'
-- and db_uoc_prod.stg_dadesra.autors_versio.id = '259397'
-- where db_uoc_prod.stg_dadesra.autors_element_formacio.ind_last = 1
limit 100;

-- Dimensions: PRODUCTE (autors_producte), PLA_PUBLICACIO (autors_versio [versio]), ELEMENTS_FORMACIO (autors_element_formacio [assignatures])

select * from db_uoc_prod.stg_dadesra.autors_periode limit 100; 

select * from db_uoc_prod.stg_dadesra.t_saa_accessos_ra limit 100;

select * from db_uoc_prod.stg_dadesra.live_events_caliper_dummy limit 100;

-- Un pla de publcació en blanc
select * from db_uoc_prod.stg_dadesra.autors_encarrec where id = 123156;
select count(*) from db_uoc_prod.stg_dadesra.autors_encarrec;










-- Creacio de la dimensio de materials de Recursos d Aprenentatge
select
material_id,
autors_producte_id,
titol,
'Propi' as recurs,
suport_producte
from
(
-- Conjunt de materials que disposen de modul existent
select 
ifnull(autors_modul.id,autors_producte.id) as material_id,
autors_producte.id as autors_producte_id,
ifnull(autors_modul.descripcio,autors_producte.titol) as titol,
ifnull(autors_producte.fk_suport_producte_suport_id,0) as suport_producte
from db_uoc_prod.stg_dadesra.autors_producte
left join db_uoc_prod.stg_dadesra.autors_moduls_productes
on autors_producte.id = autors_moduls_productes.producte_id
left join db_uoc_prod.stg_dadesra.autors_modul
on autors_moduls_productes.modul_id = autors_modul.id
-- where autors_producte.id = '214824'
-- where autors_producte.id = '259395'
-- limit 100
union all
-- Unio per identificar tots els registres que contenen moduls pero que tambe han d estar presents
select distinct
autors_producte.id as material_id,
autors_producte.id as autors_producte_id,
autors_producte.titol,
ifnull(autors_producte.fk_suport_producte_suport_id,0) as suport_producte
from db_uoc_prod.stg_dadesra.autors_producte
left join db_uoc_prod.stg_dadesra.autors_moduls_productes
on autors_producte.id = autors_moduls_productes.producte_id
-- inner join db_uoc_prod.stg_dadesra.autors_modul
-- on autors_moduls_productes.modul_id = autors_modul.id
-- where autors_producte.id = '214824'
where ifnull(autors_moduls_productes.producte_id,0) != 0
-- and autors_producte.id = '259395'
-- limit 100
) as moduls_producte;

/*
Generacio de la dimensio:
- pla_publicacio
    - assignatura
        - material
        - aula
*/

select 
moduls_producte.*,
autors_productes_versions.producte_id,
autors_versio.id,
autors_versio.ordre,
-- autors_versio.fk_encarrec_encarrec_id, -- docent que fa l encarrec
autors_periode.codi_extern,
autors_periode.data_inici,
autors_periode.data_fi,
autors_periode.data_publicacio,
autors_element_formacio.codi_final -- codi_assignatura
from db_uoc_prod.stg_dadesra.autors_versio
left join db_uoc_prod.stg_dadesra.autors_periode
on autors_versio.fk_periode_periode_id = autors_periode.id
left join db_uoc_prod.stg_dadesra.autors_element_formacio
on autors_versio.fk_element_formacio_element_id = autors_element_formacio.id
left join db_uoc_prod.stg_dadesra.autors_productes_versions
on autors_productes_versions.versio_id = autors_versio.id
inner join
(select
material_id,
autors_producte_id,
titol,
'Propi' as recurs,
suport_producte
from
(
-- Conjunt de materials que disposen de modul existent
select 
ifnull(autors_modul.id,autors_producte.id) as material_id,
autors_producte.id as autors_producte_id,
ifnull(autors_modul.descripcio,autors_producte.titol) as titol,
ifnull(autors_producte.fk_suport_producte_suport_id,0) as suport_producte
from db_uoc_prod.stg_dadesra.autors_producte
left join db_uoc_prod.stg_dadesra.autors_moduls_productes
on autors_producte.id = autors_moduls_productes.producte_id
left join db_uoc_prod.stg_dadesra.autors_modul
on autors_moduls_productes.modul_id = autors_modul.id
-- where autors_producte.id = '214824'
-- where autors_producte.id = '259395'
-- limit 100
union all
-- Unio per identificar tots els registres que contenen moduls pero que tambe han d estar presents
select distinct
autors_producte.id as material_id,
autors_producte.id as autors_producte_id,
autors_producte.titol,
ifnull(autors_producte.fk_suport_producte_suport_id,0) as suport_producte
from db_uoc_prod.stg_dadesra.autors_producte
left join db_uoc_prod.stg_dadesra.autors_moduls_productes
on autors_producte.id = autors_moduls_productes.producte_id
-- inner join db_uoc_prod.stg_dadesra.autors_modul
-- on autors_moduls_productes.modul_id = autors_modul.id
-- where autors_producte.id = '214824'
where ifnull(autors_moduls_productes.producte_id,0) != 0
-- and autors_producte.id = '259395'
-- limit 100
)) as moduls_producte
on moduls_producte.autors_producte_id = autors_productes_versions.producte_id
where codi_final = 'M8.020'
order by ordre
limit 100
;

select 1;


select * from db_uoc_prod.stg_dadesra.autors_producte limit 10;




select * from db_uoc_prod.stg_dadesra.dim_material_ra where recurs = 'PROPI' limit 100;

select * from db_uoc_prod.stg_dadesra.autors_modul;
select * from db_uoc_prod.stg_dadesra.autors_producte;













