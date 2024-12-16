-- PRODUCTIVITZACIÓ CREACIÓ PROCEDURES 20241213


/* CREACIO DE PROCEDURES: 28/11/2024

Procedures creats: https://docs.google.com/spreadsheets/d/19SGmqOjpN7uztddJo230dKjyEbea_aTJmcg_LrfEHeQ/edit?gid=1859579877#gid=1859579877
*/


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_ACCES */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_ACCES_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- Carga del registro 0
merge into db_uoc_prod.dd_od.dim_acces_TEST
using (select 0 AS id_acces, ''ND''  as dim_acces_key, ''ND'' as tipo_docencia, ''ND'' as acces_titol_propi, ''ND'' as via_acces, ''ND'' as opcio_acces,''ND'' as tipo_acces, ''ND'' as acces_sue, ''ND'' as via_siiu, ''ND'' via_oficina,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_residencia_repl
on db_uoc_prod.dd_od.dim_acces_TEST.id_acces = dim_residencia_repl.id_acces
when matched 
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched 
then insert (id_acces, dim_acces_key, tipo_docencia, acces_titol_propi, via_acces, opcio_acces, tipo_acces, acces_sue, via_siiu, via_oficina, creation_date, update_date)
values (0,''ND'', ''ND'' , ''ND'', ''ND'' ,''ND'', ''ND'', ''ND'', ''ND'', ''ND'', convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

-- Cargar/actualizar datos

merge into db_uoc_prod.dd_od.dim_acces_TEST
using (SELECT distinct
            tipo_docencia_detalle as tipo_docencia, --CP
            gpd.ind_titulaciones_propias as acces_titol_propi, -- CP
            pac.Via_acces AS Via_acc, --CP
            pac.DESCRIPCION AS opcio_acc, -- CP
            CONCAT(tipo_docencia,acces_titol_propi,Via_acc,opcio_acc) as dim_acces_key,
            case when tipo_docencia_detalle = ''GR'' and ind_titulaciones_propias =''N'' then ''Accès Graus oficials''
                 else ''Altres'' end as tipo_acces,
            case when evue.acces_sue is null and tipo_acces = ''Accès Graus oficials'' then ''ND'' -- Pendiente de clasificar
                 when evue.acces_sue is null and tipo_acces <> ''Accès Graus oficials'' then ''NA''
                 else evue.acces_sue end as acces_sue,
            case when evue.via_siiu is null and tipo_acces = ''Accès Graus oficials'' then ''ND'' -- Pendiente de clasificar
                 when evue.via_siiu is null and tipo_acces <> ''Accès Graus oficials'' then ''NA''
                 else evue.via_siiu end as via_siiu,
            case when via_oficina is null and tipo_acces = ''Accès Graus oficials'' then ''ND'' -- Pendiente de clasificar
                 when via_oficina is null and tipo_acces <> ''Accès Graus oficials'' then ''NA''
                 else via_oficina end as via_oficina
        FROM
            DD_OD.GAT_CAB_SOLICITUD_ACC_TEST csa
        LEFT JOIN (SELECT pa.cod_opc_Acc, pa.DESCRIPCION ,pa.COD_PLAN,pa.COD_CENTRO, va.DESCRIPCION AS Via_acces
                        FROM DD_OD.GAT_PLAN_ACCESOS_TEST pa
                        LEFT JOIN DD_OD.GAT_VIAS_ACC_TEST va ON pa.cod_via_acc = va.cod_via_acc
            ) pac ON pac.cod_opc_Acc = csa.cod_opc_acc AND pac.COD_CENTRO = csa.COD_CENTRO AND pac.COD_PLAN = csa.COD_PLAN
        left join DD_OD.GAT_PLAN_DATOS_TEST as gpd on csa.cod_plan= gpd.cod_plan
        left join DD_OD.GAT_ESTUDIOS_TEST as ges on gpd.cod_estudios = ges.cod_estudios
        left join db_uoc_prod.dd_od.EQUIVALENCIAS_VIASOPCS_UOC_EXTERNAS_TEST as evue on  pac.Via_acces = evue.via_acces and  
                                                                                    pac.descripcion = evue.opcio_acces and tipo_acces = ''Accès Graus oficials'') as origen
on origen.dim_acces_key =  db_uoc_prod.dd_od.dim_acces_TEST.dim_acces_key 
when matched 
then update set dim_acces_key = origen.dim_acces_key, tipo_docencia = origen.tipo_docencia, tipo_acces = origen.tipo_acces, via_acces = origen.Via_acc, opcio_acces= origen.opcio_acc, acces_sue = origen.acces_sue, via_siiu = origen.via_siiu, via_oficina = origen.via_oficina, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (dim_acces_key, tipo_docencia, acces_titol_propi,  via_acces, opcio_acces, tipo_acces, acces_sue,  via_siiu, via_oficina, creation_date, update_date)
values (origen.dim_acces_key, origen.tipo_docencia, origen.acces_titol_propi , origen.Via_acc, origen.opcio_acc, origen.tipo_acces, origen.acces_sue, origen.via_siiu, origen.via_oficina, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_acces_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_vias_acces Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_ASSIGNATURA */
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST_LOADS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- initial_merge : 
merge into DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST
using (
        select 
            0 as id_assignatura
            , ''00.000'' as dim_assignatura_key
            ,''19000'' as semestre_inici_doc
            ,''19000'' as semestre_extincio
            ,''-'' as assignatura_vigent
            ,''19000'' as semestre_ini_eees
            ,''ND'' as idioma_docencia
            ,''ND'' as desc_cat
            ,''ND'' as desc_cas
            ,''ND'' as desc_ang
            ,''ND'' as desc_fra
            ,''-'' as ind_tfc
            ,''-'' as ind_practicum
            ,''-'' as ind_arees
            ,''-'' as ind_anual
            ,''ND'' as descripcio_assignatura
            ,0 as tipus_assignatura
            ,0 as num_credits
            ,0 as num_credits_teorics
            ,0 as num_credits_practics
            ,''ND'' as valor_assignatura
            ,''ND'' as ind_eval_continuada
            ,''ND'' as ind_exa_presencial
            ,''ND'' as ind_prova_conf
            ,''ND'' as cod_estudis_area
            ,''ND'' as DESC_ESTUDIS_AREA
            ,''ND'' as tipus_educacio
            ,''ND'' as tipus_docencia_detall
            , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date
            , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date
    ) as dim_assignatura_repl
on DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST.id_assignatura = dim_assignatura_repl.id_assignatura
when matched
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (
        id_assignatura
        , dim_assignatura_key
        , semestre_inici_doc
        , semestre_extincio
        , assignatura_vigent
        , semestre_ini_eees
        , idioma_docencia
        , desc_cat
        , desc_cas
        , desc_ang
        , desc_fra
        , ind_tfc
        , ind_practicum
        , ind_arees
        , ind_anual
        , descripcio_assignatura
        , tipus_assignatura
        , num_credits
        , num_credits_teorics
        , num_credits_practics
        , valor_assignatura
        , ind_eval_continuada
        , ind_exa_presencial
        , ind_prova_conf
        , cod_estudis_area
        , DESC_ESTUDIS_AREA
        , tipus_educacio
        , tipus_docencia_detall
        , creation_date
        , update_date
    )
values (
        0
        , ''00.000''
        ,''19000''
        ,''19000''
        ,''-''
        ,''1900''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''-''
        ,''-''
        ,''-''
        ,''-''
        ,''ND''
        ,0
        ,0
        ,0
        ,0
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        ,''ND''
        , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
        , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
    ) 
;

-- merge_2 with loads: 
merge into DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST
    using (
        select
        load_assignatures.cod_assignatura,
        load_assignatures.any_acad_inicio_doc,
        load_assignatures.any_acad_extincion,
        load_assignatures.assignatura_vigent,
        load_assignatures.any_acad_ini_eees,
        load_assignatures.idioma_docencia,
        load_assignatures."''CAT''" as desc_cat,
        load_assignatures."''CAS''" as desc_cas,
        load_assignatures."''ANG''" as desc_ang,
        load_assignatures."''FRA''" as desc_fra,
        load_assignatures.ind_tfc,
        load_assignatures.ind_practicum,
        load_assignatures.ind_arees,
        load_assignatures.ind_anual,
        load_assignatures.descripcio_assignatura,
        load_assignatures.tipus_assignatura,
        load_assignatures.num_credits,
        load_assignatures.num_credits_teorics,
        load_assignatures.num_credits_practics,
        load_assignatures.valor_assignatura,
        load_assignatures.ind_eval_continuada,
        load_assignatures.ind_exa_presencial,
        load_assignatures.ind_prova_conf,
        load_assignatures.cod_estudis_area,
        Load_Assignatures.desc_estudis_area,
        load_assignatures.tipus_educacio,
        load_assignatures.tipus_docencia_detall

        from (
            select
            ifnull(asignaturas.cod_asignatura,ifnull(asignaturas_semestres.cod_asignatura,trim(desc_asignaturas.clave))) as cod_assignatura,
            asignaturas_semestres.any_acad_inicio_doc,
            asignaturas_semestres.any_acad_extincion,
            case 
                when asignaturas_semestres.any_acad_extincion is null then ''S''
                else ''N'' 
            END as assignatura_vigent,
 
            asignaturas_semestres.any_acad_ini_eees,
            ifnull(asignaturas_semestres.idioma_docencia,''ND'') as idioma_docencia,
            desc_asignaturas.cod_idioma,
            desc_asignaturas.descripcion,
            desc_asignaturas.clave,
            asignaturas_semestres.ind_tfc,
            asignaturas_semestres.ind_practicum,
            asignaturas_semestres.ind_arees,
            asignaturas_semestres.ind_anual,
            asignaturas.desc_asignatura as descripcio_assignatura,
            asignaturas.tipo_asignatura as tipus_assignatura,
            asignaturas.num_creditos as num_credits,
            asignaturas.num_creditos_teoricos as num_credits_teorics,
            asignaturas.num_creditos_practicos as num_credits_practics,
            asignaturas.valor_asignatura as valor_assignatura,
            asignaturas.ind_eval_continuada,
            asignaturas.ind_exa_presencial,
            asignaturas.ind_prueba_conf as ind_prova_conf,
            asignaturas.cod_estudios_area as cod_estudis_area,
            desc_area_estudis.descripcion as DESC_ESTUDIS_AREA,
            asignaturas.tipo_educacion as tipus_educacio,
            asignaturas.tipo_docencia_detalle as tipus_docencia_detall,
            desc_asignaturas.nom_tabla,
            desc_asignaturas.nom_campo
        
        from db_uoc_prod.DD_OD.gat_asignaturas_TEST as asignaturas
            
        left join db_uoc_prod.DD_OD.gat_asig_semestres_TEST as asignaturas_semestres
            on asignaturas_semestres.cod_asignatura = asignaturas.cod_asignatura
        
        left join db_uoc_prod.DD_OD.gat_descripciones_TEST as desc_asignaturas 
            on asignaturas.cod_asignatura = desc_asignaturas.clave -- Anteriormente la clave tenia un trim. En la tabla descripciones algunas claves esta duplicadas lo unico que algunas con 7 caracteres (un espacio extra) y otras 6. Eso hacia duplicar resultados y dar errores
            and desc_asignaturas.nom_tabla = ''ASIGNATURAS''
            and desc_asignaturas.nom_campo = ''DESC_ASIGNATURA''
        
        
        left join db_uoc_prod.DD_OD.gat_descripciones_TEST  as desc_area_estudis
            on asignaturas.cod_estudios_area = desc_area_estudis.clave -- Anteriormente la clave tenia un trim. En la tabla descripciones algunas claves esta duplicadas lo unico que algunas con 7 caracteres (un espacio extra) y otras 6. Eso hacia duplicar resultados y dar errores
            and desc_area_estudis.cod_idioma = ''CAT''
            and desc_area_estudis.nom_tabla = ''AREAS_ESTUDIOS''



        )
        PIVOT (
            max(descripcion) for cod_idioma
            in (select distinct cod_idioma from db_uoc_prod.stg_docencia.gat_descripciones where nom_tabla = ''ASIGNATURAS'' and nom_campo = ''DESC_ASIGNATURA'' )
        ) as load_assignatures
        
        where nom_tabla = ''ASIGNATURAS''
        and nom_campo = ''DESC_ASIGNATURA''
    ) as dim_assignatura_orig

on DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST.dim_assignatura_key = dim_assignatura_orig.cod_assignatura
    --- DANI & INI : 2024/12/12: union campo idiomas no correctos --> comprobacion varias asignaturas pueden tener el mismo idioma: semestre informado vs no informado --> nuevo por no semestre de inicio ( necesario sobreescritura)
    -- and ifnull (DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST.semestre_inici_doc,0) = ifnull (dim_assignatura_orig.any_acad_inicio_doc,0)
    -- and DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST.idioma_docencia = dim_assignatura_orig.idioma_docencia  

when matched then 
    update set 
        dim_assignatura_key = dim_assignatura_orig.cod_assignatura
        , semestre_inici_doc = dim_assignatura_orig.any_acad_inicio_doc
        , semestre_extincio = dim_assignatura_orig.any_acad_extincion
        , assignatura_vigent = dim_assignatura_orig.assignatura_vigent
        , semestre_ini_eees = dim_assignatura_orig.any_acad_ini_eees
        , idioma_docencia = dim_assignatura_orig.idioma_docencia
        , desc_cat = dim_assignatura_orig.desc_cat
        , desc_cas = dim_assignatura_orig.desc_cas
        , desc_ang = dim_assignatura_orig.desc_ang
        , desc_fra = dim_assignatura_orig.desc_fra
        , ind_tfc = dim_assignatura_orig.ind_tfc
        , ind_practicum = dim_assignatura_orig.ind_practicum
        , ind_arees = dim_assignatura_orig.ind_arees
        , ind_anual = dim_assignatura_orig.ind_anual
        , descripcio_assignatura = dim_assignatura_orig.descripcio_assignatura
        , tipus_assignatura = dim_assignatura_orig.tipus_assignatura
        , num_credits = dim_assignatura_orig.num_credits
        , num_credits_teorics = dim_assignatura_orig.num_credits_teorics
        , num_credits_practics = dim_assignatura_orig.num_credits_practics
        , valor_assignatura = dim_assignatura_orig.valor_assignatura
        , ind_eval_continuada = dim_assignatura_orig.ind_eval_continuada
        , ind_exa_presencial = dim_assignatura_orig.ind_exa_presencial
        , ind_prova_conf = dim_assignatura_orig.ind_prova_conf
        , cod_estudis_area = dim_assignatura_orig.cod_estudis_area
        , DESC_ESTUDIS_AREA = dim_assignatura_orig.DESC_ESTUDIS_AREA
        , tipus_educacio = dim_assignatura_orig.tipus_educacio
        , tipus_docencia_detall = dim_assignatura_orig.tipus_docencia_detall
        , update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz
    )

when not matched then
    insert (
        dim_assignatura_key
        , semestre_inici_doc
        , semestre_extincio
        , assignatura_vigent
        , semestre_ini_eees
        , idioma_docencia
        , desc_cat
        , desc_cas
        , desc_ang
        , desc_fra
        , ind_tfc
        , ind_practicum
        , ind_arees
        , ind_anual
        , descripcio_assignatura
        , tipus_assignatura
        , num_credits
        , num_credits_teorics
        , num_credits_practics
        , valor_assignatura
        , ind_eval_continuada
        , ind_exa_presencial
        , ind_prova_conf
        , cod_estudis_area
        , DESC_ESTUDIS_AREA
        , tipus_educacio
        , tipus_docencia_detall
        , creation_date
        , update_date
    ) 
    
    values (
        dim_assignatura_orig.cod_assignatura
        , dim_assignatura_orig.any_acad_inicio_doc
        , dim_assignatura_orig.any_acad_extincion
        , dim_assignatura_orig.assignatura_vigent
        , dim_assignatura_orig.any_acad_ini_eees
        , dim_assignatura_orig.idioma_docencia
        , dim_assignatura_orig.desc_cat
        , dim_assignatura_orig.desc_cas
        , dim_assignatura_orig.desc_ang
        , dim_assignatura_orig.desc_fra
        , dim_assignatura_orig.ind_tfc
        , dim_assignatura_orig.ind_practicum
        , dim_assignatura_orig.ind_arees
        , dim_assignatura_orig.ind_anual
        , dim_assignatura_orig.descripcio_assignatura
        , dim_assignatura_orig.tipus_assignatura
        , dim_assignatura_orig.num_credits
        , dim_assignatura_orig.num_credits_teorics
        , dim_assignatura_orig.num_credits_practics
        , dim_assignatura_orig.valor_assignatura
        , dim_assignatura_orig.ind_eval_continuada
        , dim_assignatura_orig.ind_exa_presencial
        , dim_assignatura_orig.ind_prova_conf
        , dim_assignatura_orig.cod_estudis_area
        , dim_assignatura_orig.DESC_ESTUDIS_AREA
        , dim_assignatura_orig.tipus_educacio
        , dim_assignatura_orig.tipus_docencia_detall
        , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
        , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
    );

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_assignatura_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_assignatura Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_EXPEDIENT */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_EXPEDIENT_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

merge into db_uoc_prod.dd_od.dim_expedient_TEST
using (select 0 as id_expedient, 0 as dim_expedient_key, 0 as cod_centre, ''ND'' as codi_pla, ''ND'' as provinent_adaptacio , ''ND'' as tipologia_titol_previ, ''ND'' as provinent_canvi_campus ,0 as numero_versio_pla, ''19000'' as semestre_apertura, ''ND'' as codi_node_arrel, ''-'' as ind_estat_expedient, ''-'' as ind_inconsistent, ''-'' as ind_carrega_inicial, 0 as ind_situacio, ''ND'' as observacions, 0 as num_control, null as nota_mitjana, ''19000'' as semestre_titulacio, 0 as motiu_estat, ''-'' as ind_estat_expedient_2, 0 as num_expedient_rel_1, 0 as num_expedient_rel_2, null as nota_mitjana_punts, 0 as super_expedient_v1,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_expedient_repl
on db_uoc_prod.dd_od.dim_expedient_TEST.id_expedient = dim_expedient_repl.id_expedient
when matched
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (id_expedient, dim_expedient_key, cod_centre, codi_pla, provinent_adaptacio, tipologia_titol_previ, provinent_canvi_campus ,numero_versio_pla, semestre_apertura, codi_node_arrel, ind_estat_expedient, ind_inconsistent, ind_carrega_inicial, ind_situacio, observacions, num_control, nota_mitjana, semestre_titulacio, motiu_estat, ind_estat_expedient_2, num_expedient_rel_1, num_expedient_rel_2, nota_mitjana_punts, super_expedient_v1, creation_date, update_date)
values (0, 0, 0, ''ND'',''ND'' ,''ND'', ''ND'', 0, ''19000'', ''ND'', ''-'', ''-'', ''-'', 0, ''ND'', 0, null, ''19000'', 0, ''-'', 0, 0, null, 0, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz))
;


merge into db_uoc_prod.dd_od.dim_expedient_TEST
using (WITH expediente_origen_relacionado AS (
    SELECT 
        e.NUM_EXPEDIENTE,
        COALESCE(e.NUM_EXPEDIENTE_REL1, MIN(e.NUM_EXPEDIENTE) OVER (PARTITION BY e.IDP, pd.COD_ESTUDIOS)) AS super_expediente
    FROM DB_UOC_PROD.DD_OD.GAT_EXPEDIENTES_TEST e
    LEFT JOIN DB_UOC_PROD.DD_OD.GAT_PLAN_DATOS_TEST pd ON e.COD_PLAN = pd.COD_PLAN
    WHERE e.ind_estado_expediente <> ''E'' 
    ), expediente_origen_relacionado2 AS (
        SELECT 
            eor1.num_expediente,
            eor2.super_expediente,
        FROM expediente_origen_relacionado eor1
        LEFT JOIN expediente_origen_relacionado eor2 ON eor1.super_expediente = eor2.num_expediente 
    ) 
select
GAT_EXPEDIENTES_TEST.num_expediente
,ifnull (expediente_origen_relacionado2.super_expediente,GAT_EXPEDIENTES_TEST.num_expediente) as super_expedient_v1
,GAT_EXPEDIENTES_TEST.cod_centro
,GAT_EXPEDIENTES_TEST.cod_plan
,CASE WHEN GAT_EXPEDIENTES_TEST.num_expediente = gat_exp_adapt.num_expediente_rel2 THEN ''Sí'' ELSE ''No'' end as provinent_adaptacio
,PROGRAM_TEST.des_tipologia_ca as tipologia_titol_previ
,CASE WHEN provinent_adaptacio =''No'' and super_expedient_v1 <> GAT_EXPEDIENTES_TEST.num_expediente THEN ''Sí'' ELSE ''No'' end as provinent_canvi_campus
,GAT_EXPEDIENTES_TEST.num_version_plan
,GAT_EXPEDIENTES_TEST.any_acad_apertura
,GAT_EXPEDIENTES_TEST.cod_nodo_raiz
,GAT_EXPEDIENTES_TEST.ind_estado_expediente
,GAT_EXPEDIENTES_TEST.ind_inconsistente
,GAT_EXPEDIENTES_TEST.ind_carga_inicial
,GAT_EXPEDIENTES_TEST.ind_situacion
,GAT_EXPEDIENTES_TEST.observaciones
,GAT_EXPEDIENTES_TEST.num_control
,GAT_EXPEDIENTES_TEST.nota_media
,GAT_EXPEDIENTES_TEST.any_acad_titulo
,GAT_EXPEDIENTES_TEST.motivo_estado
,GAT_EXPEDIENTES_TEST.ind_estado_expediente2
,GAT_EXPEDIENTES_TEST.num_expediente_rel1
,GAT_EXPEDIENTES_TEST.num_expediente_rel2
,GAT_EXPEDIENTES_TEST.nota_media_puntos
from
db_uoc_prod.DD_OD.GAT_EXPEDIENTES_TEST
left join db_uoc_prod.DD_OD.GAT_EXPEDIENTES_TEST as gat_exp_adapt
on GAT_EXPEDIENTES_TEST.num_expediente = gat_exp_adapt.num_expediente_rel2 and
   gat_exp_adapt.ind_estado_expediente = ''Q''
left join db_uoc_prod.DD_OD.GAT_PLAN_DATOS_TEST
on gat_exp_adapt.cod_plan = GAT_PLAN_DATOS_TEST.cod_plan
left join db_uoc_prod.DD_OD.PROGRAM_TEST
on GAT_PLAN_DATOS_TEST.id_prog_bof = PROGRAM_TEST.id_bof
left join expediente_origen_relacionado2 
on GAT_EXPEDIENTES_TEST.num_expediente = expediente_origen_relacionado2.num_expediente
) as dim_expedient_orig
on db_uoc_prod.dd_od.dim_expedient_TEST.dim_expedient_key = dim_expedient_orig.num_expediente
when matched 
then update set 
dim_expedient_key = dim_expedient_orig.num_expediente, cod_centre = dim_expedient_orig.cod_centro, codi_pla = dim_expedient_orig.cod_plan, provinent_adaptacio = dim_expedient_orig.provinent_adaptacio, tipologia_titol_previ = dim_expedient_orig.tipologia_titol_previ, provinent_canvi_campus = dim_expedient_orig.provinent_canvi_campus, numero_versio_pla = dim_expedient_orig.num_version_plan, semestre_apertura = dim_expedient_orig.any_acad_apertura, codi_node_arrel =  dim_expedient_orig.cod_nodo_raiz, ind_estat_expedient = dim_expedient_orig.ind_estado_expediente, ind_inconsistent = dim_expedient_orig.ind_inconsistente, ind_carrega_inicial = dim_expedient_orig.ind_carga_inicial, ind_situacio = dim_expedient_orig.ind_situacion, observacions = dim_expedient_orig.observaciones, num_control = dim_expedient_orig.num_control, nota_mitjana = dim_expedient_orig.nota_media, semestre_titulacio = dim_expedient_orig.any_acad_titulo, motiu_estat =dim_expedient_orig.motivo_estado, ind_estat_expedient_2 = dim_expedient_orig.ind_estado_expediente2, num_expedient_rel_1 = dim_expedient_orig.num_expediente_rel1, num_expedient_rel_2 = dim_expedient_orig.num_expediente_rel2, nota_mitjana_punts = dim_expedient_orig.nota_media_puntos, super_expedient_v1 = dim_expedient_orig.super_expedient_v1, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
insert (dim_expedient_key, cod_centre, codi_pla, provinent_adaptacio, tipologia_titol_previ,provinent_canvi_campus ,numero_versio_pla, semestre_apertura, codi_node_arrel, ind_estat_expedient, ind_inconsistent, ind_carrega_inicial, ind_situacio, observacions, num_control, nota_mitjana, semestre_titulacio, motiu_estat, ind_estat_expedient_2, num_expedient_rel_1, num_expedient_rel_2, nota_mitjana_punts, super_expedient_v1, creation_date, update_date) 
values (dim_expedient_orig.num_expediente, dim_expedient_orig.cod_centro, dim_expedient_orig.cod_plan, dim_expedient_orig.provinent_adaptacio, dim_expedient_orig.tipologia_titol_previ, dim_expedient_orig.provinent_canvi_campus, dim_expedient_orig.num_version_plan, dim_expedient_orig.any_acad_apertura, dim_expedient_orig.cod_nodo_raiz, dim_expedient_orig.ind_estado_expediente, dim_expedient_orig.ind_inconsistente, dim_expedient_orig.ind_carga_inicial, dim_expedient_orig.ind_situacion, dim_expedient_orig.observaciones , dim_expedient_orig.num_control, dim_expedient_orig.nota_media, dim_expedient_orig.any_acad_titulo, dim_expedient_orig.motivo_estado, dim_expedient_orig.ind_estado_expediente2, dim_expedient_orig.num_expediente_rel1, dim_expedient_orig.num_expediente_rel2, dim_expedient_orig.nota_media_puntos, dim_expedient_orig.super_expedient_v1, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_expedient_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_expedient Success'');
    
return ''Update completed successfully'';

end';


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_MATRICULA */   --- OJO REVISAR LES TAULES "EPIOLINI"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_MATRICULA_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'BEGIN
  LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
  LET execution_time FLOAT;
 
  -- Proces que incorpora el registre 0 a la dimensio.
  MERGE INTO db_uoc_prod.dd_od.dim_matricula_TEST AS target
  USING (SELECT 0 AS id_matricula, 
                0 AS dim_matricula_key, 
                ''ND'' AS origen, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_matricula, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_anulacio, 
                ''-'' AS cod_motiu_anulacio, 
                ''ND'' AS cod_categoritzacio, 
                ''ND'' AS des_categoritzacio, 
                ''ND'' AS des_entitat, 
                ''ND'' AS des_distribuidor, 
                CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS creation_date,
                CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS update_date) AS source
  ON target.id_matricula = source.id_matricula
  WHEN MATCHED THEN 
    UPDATE SET update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
  WHEN NOT MATCHED THEN 
    INSERT (id_matricula, dim_matricula_key, origen, data_matricula, data_anulacio, cod_motiu_anulacio, cod_categoritzacio, des_categoritzacio, des_entitat, des_distribuidor, creation_date, update_date)
    VALUES (source.id_matricula, source.dim_matricula_key, source.origen, source.data_matricula, source.data_anulacio, source.cod_motiu_anulacio, source.cod_categoritzacio, source.des_categoritzacio, source.des_entitat, source.des_distribuidor, source.creation_date, source.update_date);

  -- Merge de les matricules de GAT i PIOLIN
  MERGE INTO db_uoc_prod.dd_od.dim_matricula_TEST AS target
  USING (
    SELECT 
      CONCAT(TO_VARCHAR(em.num_expediente), TO_VARCHAR(em.any_academico), TO_VARCHAR(em.num_matricula)) AS dim_matricula_key,
      ''GAT'' AS origen, 
      em.fecha_matricula AS data_matricula,
      em.fecha_anulacion AS data_anulacio,
      CASE WHEN em.fecha_anulacion IS NOT NULL THEN sam.cod_moti_anulacion ELSE NULL END AS cod_motiu_anulacio, 
      exc.codigo_categoriza AS cod_categoritzacio,
      exc.descripcion AS des_categoritzacio,
      exc.nombre_entidad AS des_entitat,
      distr.descripcio AS des_distribuidor
    FROM DB_UOC_PROD.DD_OD.GAT_EXP_MATRICULAS_TEST em
    LEFT JOIN DD_OD.GAT_EXP_MATRICULAS_CATEGMAT_TEST exc ON em.num_expediente = exc.num_expediente AND em.any_academico = exc.any_academico AND em.num_matricula = exc.num_matricula
    LEFT JOIN (
      SELECT cod_moti_anulacion, num_expediente, any_academico, num_matricula, 
             ROW_NUMBER() OVER (PARTITION BY num_expediente, any_academico, num_matricula ORDER BY fecha_solicitud DESC) AS n_anul
      FROM DD_OD.GAT_SOL_ANULA_MAT_TEST
    ) sam ON em.num_expediente = sam.num_expediente AND em.fecha_anulacion IS NOT NULL AND em.any_academico = sam.any_academico AND em.num_matricula = sam.num_matricula AND sam.n_anul = 1
    LEFT JOIN (
      SELECT cat.codi_categoritzacio, distr0.descripcio
      FROM DB_UOC_PROD.DD_OD.GAT_CATEGORITZACIONS_TEST cat
      LEFT JOIN DD_OD.GAT_DISTRIBUIDORS_TEST distr0 ON distr0.seq_distribuidor = cat.seq_distribuidor AND distr0.seq_distribuidor NOT IN (1,4,3,8)
    ) distr ON distr.codi_categoritzacio = exc.codigo_categoriza

/*  UNION ALL 
    
    SELECT 
      TO_VARCHAR(ma.num_matricula) AS dim_matricula_key,
      ''PIOLIN'' AS origen, 
      ma.fecha_matricula AS data_matricula,
      ma.fecha_anulacion AS data_anulacio,
      CASE WHEN em.fecha_anulacion IS NOT NULL THEN sam.cod_motiu_anulacion ELSE NULL END AS cod_motiu_anulacio,
      mc.codigo_categoriza AS cod_categoritzacio,
      mc.descripcion AS des_categoritzacio,
      mc.nombre_entidad AS des_entitat,
      distr.descripcio AS des_distribuidor
    FROM DD_OD.epiolini_matriculas ma
    LEFT JOIN DD_OD.epiolini_matriculas_categoriza mc ON ma.num_matricula = mc.num_matricula
    LEFT JOIN (
      SELECT cat.codi_categoritzacio, distr0.descripcio
      FROM DB_UOC_PROD.DD_OD.GAT_CATEGORITZACIONS_TEST cat
      LEFT JOIN DD_OD.GAT_DISTRIBUIDORS_TEST distr0 ON distr0.seq_distribuidor = cat.seq_distribuidor AND distr0.seq_distribuidor NOT IN (1,4,3,8)
    ) distr ON distr.codi_categoritzacio = mc.codigo_categoriza
    LEFT JOIN (
      SELECT rs.IDENTIFICADOR_SERVICIO, rs.IDP, csce.MOTIVO_ANUL
      FROM DD_OD.epiolini_registro_servicios rs
      LEFT JOIN DD_OD.epiolini_concepto_servicios csce ON csce.cod_cliente != rs.idp AND csce.any_servicio = rs.any_servicio AND csce.num_reg_servicio = rs.num_reg_servicio AND csce.num_concepto = rs.ult_reg_concepto
    ) serv ON serv.idp = ma.idp AND serv.identificador_servicio = ma.num_matricula
*/  ) AS source
  ON target.dim_matricula_key = source.dim_matricula_key
  WHEN MATCHED THEN 
    UPDATE SET dim_matricula_key = source.dim_matricula_key, origen = source.origen, data_matricula = source.data_matricula, data_anulacio = source.data_anulacio, cod_motiu_anulacio = source.cod_motiu_anulacio, cod_categoritzacio = source.cod_categoritzacio, des_categoritzacio = source.des_categoritzacio, des_entitat = source.des_entitat, des_distribuidor =  source.des_distribuidor, update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
  WHEN NOT MATCHED THEN 
    INSERT (dim_matricula_key, origen, data_matricula, data_anulacio, cod_motiu_anulacio, cod_categoritzacio, des_categoritzacio, des_entitat, des_distribuidor, creation_date, update_date)
    VALUES (source.dim_matricula_key, source.origen, source.data_matricula, source.data_anulacio, source.cod_motiu_anulacio, source.cod_categoritzacio, source.des_categoritzacio, source.des_entitat, source.des_distribuidor, 
            CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ), 
            CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

  execution_time := DATEDIFF(MILLISECOND, start_time, CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

  INSERT INTO db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
  VALUES (db_uoc_prod.dd_od.sequencia_id_log.NEXTVAL, ''dim_matricula_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_matricula Success'');

  RETURN ''Update completed successfully'';

END';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_PAIS_RESIDENCIA */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_PAIS_RESIDENCIA_LOADS_TEST ()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- Carga del registre 0
merge into db_uoc_prod.dd_od.dim_pais_residencia_TEST
using (select  0 as id_pais_residencia,''ND00'' as dim_pais_residencia_key,''ND'' AS continent, ''ND'' as regio,  ''ND'' as cat_esp_resta, ''ND'' as cat_esp_continent_reg, ''ND'' as pais, ''ND'' as cod_pais_iso ,NULL as data_baixa_pais, ''ND'' as pais_conveni_haia, ''ND'' as pais_espai_sepa, 0 AS pais_div_territorial, ''ND'' as comunitat_autonoma, ''ND'' as provincia,''ND'' as comarca, ''ND'' as poblacio, 0 AS cod_poblacio_mec, 0 as cod_postal, 0 as ind_localitzacio, ''ND'' as localitzacio, NULL as data_baixa_localitzacio, NULL as data_modifica_localitzacio, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_residencia_repl
on db_uoc_prod.dd_od.dim_pais_residencia_TEST.id_pais_residencia = dim_residencia_repl.id_pais_residencia -- No entiendo lo que hace aqui
when matched 
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (ID_PAIS_RESIDENCIA,DIM_PAIS_RESIDENCIA_KEY, CONTINENT, REGIO, CAT_ESP_RESTA,CAT_ESP_CONTINENT_REG, PAIS,COD_PAIS_ISO, DATA_BAIXA_PAIS, PAIS_CONVENI_HAIA, PAIS_ESPAI_SEPA, PAIS_DIV_TERRITORIAL, COMUNITAT_AUTONOMA, PROVINCIA, COMARCA, POBLACIO, COD_POBLACIO_MEC, COD_POSTAL, IND_LOCALITZACIO, LOCALIZACIO, DATA_BAIXA_LOCALITZACIO, DATA_MODIFICA_LOCALITZACIO, CREATION_DATE, UPDATE_DATE)
values (0 ,''ND00'' ,''ND'', ''ND'',''ND'', ''ND'',''ND'' , ''ND'' ,NULL , ''ND'', ''ND'' , 0 , ''ND'' , ''ND'' ,''ND'' , ''ND'' , 0 , 0 , 0 , ''ND'' , NULL , NULL , convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz),  convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

--Actualizació dades
merge into db_uoc_prod.dd_od.dim_pais_residencia_TEST
using (select 
       case 
            when EPC.CONTINENT is not null then EPC.CONTINENT 
            when EPC.CONTINENT is null then ''ND'' END AS CONTINENT,
       case when  EPC.REGIO is not null then  EPC.REGIO 
            when EPC.REGIO is null then ''ND'' END AS REGIO,
       case when  ccaa = ''Catalunya'' then ''Catalunya''
            when ccaa <> ''Catalunya'' and tp.descripcion = ''Espanya'' then ''Resta Espanya''
            ELSE ''Resta mon'' end as CAT_ESP_RESTA,
        CASE
    -- Primera condición: Si es Europa y Catalunya
        WHEN CONTINENT = ''Europa'' AND CAT_ESP_RESTA = ''Catalunya'' THEN ''Catalunya''
    -- Segunda condición: Si es Europa y Resta Espanya
        WHEN CONTINENT = ''Europa'' AND CAT_ESP_RESTA = ''Resta Espanya'' THEN ''Espanya''
    -- Tercera condición: Si es Europa pero no Catalunya ni Resta Espanya
        WHEN CONTINENT = ''Europa'' AND CAT_ESP_RESTA <> ''Catalunya'' AND CAT_ESP_RESTA <> ''Resta Espanya'' THEN ''Europa''
    -- Condiciones para otros continentes
        WHEN CONTINENT = ''Àfrica'' THEN ''Àfrica''
        WHEN CONTINENT = ''Àsia'' THEN ''Àsia''
        WHEN CONTINENT = ''Oceania'' THEN ''Oceania''
    -- Condición para América del Norte
        WHEN CONTINENT = ''Amèrica'' AND REGIO = ''Amèrica del nord'' THEN ''Nordamèrica''
    -- Condición para Latinoamérica
        WHEN CONTINENT = ''Amèrica'' AND REGIO <> ''Amèrica del nord'' THEN ''Llatinoamèrica''
    -- Valor por defecto si no se cumple ninguna condición
        ELSE ''Desconegut'' END as CAT_ESP_CONTINENT_REG,
       tp.descripcion as pais,
       tp.cod_pais,
       tp.cod_pais_iso_3166_a3 as ISO,
       tp.fecha_baja as baja_pais,
       tp.ind_convenio_la_haya as pais_convenio_haya,
       tp.ind_espacio_sepa as pais_espacio_sepa,
       tp.cod_div_territorial as pais_div_territorial,
       geografia_espanya.cod_pais,
       geografia_espanya.ccaa,
       geografia_espanya.provincia,
       geografia_espanya.comarca,
       geografia_espanya.poblacio,
       geografia_espanya.cod_mec,
       case when geografia_espanya.cod_postal is null then ''99999''
            else geografia_espanya.cod_postal end as cod_postal,
       case when geografia_espanya.ind_localitzacio is null then 0
            else geografia_espanya.ind_localitzacio end as ind_localitzacio,
       case when geografia_espanya.localitzacio is null then ''ND''
            else geografia_espanya.localitzacio end as localitzacio,
       geografia_espanya.baja_localitzacio,
       geografia_espanya.modifica_localitzacio,
       concat(tp.descripcion,ifnull (cod_postal,''99999''),ifnull (ind_localitzacio,0)) as dim_pais_residencia_key
from DB_UOC_PROD.DD_OD.TERCERS_PAISES_TEST as tp
left join (SELECT ''E'' as cod_pais,
       tc.descripcion as ccaa,
       tpr.descripcion as provincia,
       tco.descripcion as comarca,
       tp.desc_poblacion as poblacio, 
       LPAD(tp.cod_poblacion_mec, 5, 0) AS cod_mec,
       tcp.cod_postal,
       tcp.ind_localizacion as ind_localitzacio,
       tcp.desc_localizacion as localitzacio,
       tcp.fecha_baja as baja_localitzacio,
       tcp.fecha_modificacion as modifica_localitzacio,
FROM DB_UOC_PROD.DD_OD.TERCERS_CODIGOS_POSTALES_TEST as tcp
INNER JOIN  DB_UOC_PROD.DD_OD.TERCERS_POBLACIONES_TEST as tp on tcp.cod_poblacion = tp.cod_poblacion 
inner join DB_UOC_PROD.DD_OD.TERCERS_PROVINCIAS_TEST as tpr on tp.cod_provincia = tpr.cod_provincia
inner join DB_UOC_PROD.DD_OD.TERCERS_COMUNIDADES_TEST as tc on tp.cod_comunidad = tc.cod_comunidad
inner join DB_UOC_PROD.DD_OD.TERCERS_COMARCAS_TEST as tco on tp.cod_comarca = tco.cod_comarca and tp.cod_comunidad = tco.cod_comunidad 
) as geografia_espanya
on geografia_espanya.cod_pais = tp.cod_pais
LEFT JOIN DB_UOC_PROD.DD_OD.EQUIVALENCIES_PAISOS_CONTINENTS_TEST as epc
on tp.cod_pais_iso_3166_a3 = epc.CODI_ISO OR tp.descripcion = epc.pais) as origen -- hasta aqui la query origen que llenara la dim
on ifnull(origen.cod_postal, '''') = ifnull(db_uoc_prod.dd_od.dim_pais_residencia_TEST.cod_postal,'''') and 
   ifnull(origen.ind_localitzacio, ''0'') = ifnull(db_uoc_prod.dd_od.dim_pais_residencia_TEST.ind_localitzacio, ''0'') and --es 0 y no '''' por que es un campo numerico
   origen.pais = db_uoc_prod.dd_od.dim_pais_residencia_TEST.pais
when matched
then update set CONTINENT =origen.continent, REGIO = origen.regio, CAT_ESP_RESTA = origen.cat_esp_resta, CAT_ESP_CONTINENT_REG =origen.cat_esp_continent_reg, PAIS = origen.pais, COD_PAIS_ISO = origen.iso, DATA_BAIXA_PAIS = origen.baja_pais, PAIS_CONVENI_HAIA = origen.pais_convenio_haya , PAIS_ESPAI_SEPA = origen.pais_espacio_sepa, PAIS_DIV_TERRITORIAL = origen.pais_div_territorial, COMUNITAT_AUTONOMA =origen.ccaa, PROVINCIA = origen.provincia, COMARCA = origen.comarca, POBLACIO = origen.poblacio, COD_POBLACIO_MEC = origen.cod_mec, COD_POSTAL = origen.cod_postal, IND_LOCALITZACIO = origen.ind_localitzacio, LOCALIZACIO =  origen.localitzacio, DATA_BAIXA_LOCALITZACIO = origen.baja_localitzacio, DATA_MODIFICA_LOCALITZACIO = origen.modifica_localitzacio, DIM_PAIS_RESIDENCIA_KEY = origen.dim_pais_residencia_key,  UPDATE_DATE = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)                
when not matched
then insert (CONTINENT, REGIO, CAT_ESP_RESTA, CAT_ESP_CONTINENT_REG,  PAIS, COD_PAIS_ISO, DATA_BAIXA_PAIS, PAIS_CONVENI_HAIA, PAIS_ESPAI_SEPA, PAIS_DIV_TERRITORIAL, COMUNITAT_AUTONOMA, PROVINCIA, COMARCA, POBLACIO, COD_POBLACIO_MEC, COD_POSTAL, IND_LOCALITZACIO, LOCALIZACIO, DATA_BAIXA_LOCALITZACIO, DATA_MODIFICA_LOCALITZACIO, DIM_PAIS_RESIDENCIA_KEY,CREATION_DATE, UPDATE_DATE)
values(origen.continent, origen.regio,origen.cat_esp_resta,origen.cat_esp_continent_reg, origen.pais,origen.iso, origen.baja_pais, origen.pais_convenio_haya, origen.pais_espacio_sepa, origen.pais_div_territorial, origen.ccaa, origen.provincia, origen.comarca, origen.poblacio, origen.cod_mec, origen.cod_postal, origen.ind_localitzacio, origen.localitzacio, origen.baja_localitzacio, origen.modifica_localitzacio, origen.dim_pais_residencia_key ,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz),  convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));


/*delete from db_uoc_prod.dd_od.dim_pais_residencia_TEST
where cod_postal = ''99999'' and IND_LOCALITZACIO = ''0'' and Pais = ''Espanya''*/;

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_pais_residencia_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_pais_residencia Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_PERSONA */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_PERSONA_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- Carga del registre 0
merge into db_uoc_prod.dd_od.dim_persona_TEST
using (select 0 AS id_persona, 0 AS DIM_PERSONA_KEY, ''0'' AS ID_PERSONA_UNEIX_30,0 AS AMB_DIRECCIONS, ''ND'' AS TIPUS_DOCUMENT, ''ND'' AS DNI, ''ND'' AS NIF_UNEIX_10, ''ND'' AS NIF_UNEIX_20, ''ND'' AS DNI_COMPACTAT, ''ND'' AS NOM,''ND'' AS NOM_UNEIX ,''ND'' AS COGNOM1,''ND'' AS COGNOM1_UNEIX_30 , ''ND'' AS COGNOM2, ''ND'' AS COGNOM2_UNEIX_30 ,''ND'' AS NUM_SEGUR_SOCIAL, NULL AS DATA_EXPEDICIO_DNI, NULL AS DATA_INSERCIO, NULL AS DATA_ULT_MODIF, ''ND'' AS PREFIX_TELEFON1, ''ND'' AS TELEFON1, ''ND'' AS PREFIX_TELEFON2, ''ND'' AS TELEFON2, ''ND'' AS PREFIX_FAX, ''ND'' AS FAX, ''ND'' AS E_MAIL, ''ND'' AS TIPUS_PERSONA, ''ND'' AS IDIOMA_COLABORADOR, ''ND'' AS IDIOMA_RELACIO, ''ND'' AS ROBINSON, ''ND'' AS SANCIONAT_ECONOMIA, ''ND'' AS VAT_NUMBER, 0 AS EDAT, NULL AS DATA_NAIXEMENT, NULL AS ANY_NAIXEMENT, ''ND'' AS SEXE, ''ND'' AS SEXE_UNEIX, ''ND'' AS PAIS, ''ND'' AS NACIONALITAT, ''ND'' AS PAIS_NAIXEMENT, 0 AS ROL_ESTUDIANT, 0 AS ROL_PRA, 0 AS ROL_PDC, 0 AS ROL_TUTOR, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as CREATION_DATE, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as UPDATE_DATE) as dim_persona_repl
on db_uoc_prod.dd_od.dim_persona_TEST.id_persona = dim_persona_repl.id_persona
when matched 
then update set UPDATE_DATE = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (id_persona, DIM_PERSONA_KEY,ID_PERSONA_UNEIX_30, AMB_DIRECCIONS, TIPUS_DOCUMENT, DNI, NIF_UNEIX_10, NIF_UNEIX_20, DNI_COMPACTAT, NOM, NOM_UNEIX_30, COGNOM1, COGNOM1_UNEIX_30, COGNOM2, COGNOM2_UNEIX_30, NUM_SEGUR_SOCIAL, DATA_EXPEDICIO_DNI, DATA_INSERCIO, DATA_ULT_MODIF, PREFIX_TELEFON1, TELEFON1, PREFIX_TELEFON2, TELEFON2, PREFIX_FAX, FAX, E_MAIL, TIPUS_PERSONA, IDIOMA_COLABORADOR, IDIOMA_RELACIO, ROBINSON, SANCIONAT_ECONOMIA, VAT_NUMBER, EDAT, DATA_NAIXEMENT,ANY_NAIXEMENT ,SEXE, SEXE_UNEIX, PAIS, NACIONALITAT, PAIS_NAIXEMENT, ROL_ESTUDIANT, ROL_PRA, ROL_PDC, ROL_TUTOR, CREATION_DATE, UPDATE_DATE)
values (0, 0, ''0'',0, ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'',''ND'', ''ND'', ''ND'' ,''ND'', ''ND'', ''ND'', NULL, NULL, NULL, ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', 0, NULL,NULL,''ND'', ''ND'' ,''ND'', ''ND'', ''ND'', 0, 0, 0, 0, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

--Actualizació dades
merge into db_uoc_prod.dd_od.dim_persona_TEST
using (select tdp.idp,
       rpad(to_varchar(tdp.idp),30,'' '') as id_persona_uneix_30,
       Case when trd.cod_elemento is not null then 1
            else 0 END as con_direcciones,
       ttd.descripcion as tipo_documento,
       tdp.dni,
       rpad(tdp.dni,10,'' '') as nif_uneix_10,
       rpad(tdp.dni,20,'' '') as nif_uneix_20,
       tdp.dni_compactado,
       tdp.nombre,
       left(rpad (tdp.nombre,30, '' ''),30) as nom_uneix_30,
       tdp.apellido1,
       left(rpad (tdp.apellido1, 30, '' ''),30) as cognom1_uneix_30,
       tdp.apellido2,
       left(rpad (tdp.apellido2, 30, '' ''),30) as cognom2_uneix_30,
       tdp.num_segur_social,
       tdp.fecha_expedicion_dni,
       tdp.fecha_insercion,
       tdp.fecha_ult_modif,
       tdp.prefijo_telefono1,
       tdp.telefono1,
       tdp.prefijo_telefono2,
       tdp.telefono2,
       tdp.prefijo_fax,
       tdp.fax,
       tdp.e_mail,
       tdp.tipo_persona,
       tdp.cod_idioma_colaborador, 
       tdp.cod_idioma_relacion,
       tdp.robinson,
       tdp.ind_sancionado_economia,
       tdp.vat_number, --hasta aqui: datos persona gestion/comunicacion
       DATEDIFF(year, tdp.fecha_nacim, CURRENT_DATE) - 
       IFF(
       TO_CHAR(CURRENT_DATE, ''MMDD'') < TO_CHAR(tdp.fecha_nacim, ''MMDD''), 
       1, 
       0) AS Edat, -- Edats pendents de netajar
       tdp.fecha_nacim, 
       to_number(to_char(tdp.fecha_nacim,''YYYY'')) as any_naixement,
       Case when tdp.sexo = ''M'' then ''Home''
            when tdp.sexo =''F'' then''Dona'' 
            else null end as sexe, 
       Case when tdp.sexo = ''M'' then ''H''
            when tdp.sexo = ''F'' then ''D'' 
            else null end as sexe_uneix,     
       --tp1.descripcion as pais_h,
       case when dpr.pais is not null then dpr.pais 
            else tp1.descripcion end as pais ,
       --dpr.poblacio,
       tp3.desc_nacionalidad as nacionalitat,
       --td.cod_pais as cod_pais_h,
       tp2.descripcion as Pais_nacim,
      case when sub.idp is not null then 1
           else 0 end as rol_estudiant,
      case when sub2.idp is not null then 1
           else 0 end as rol_pra,
      case when sub3.idp is not null then 1
           else 0 end as rol_pdc,
      case when sub4.idp_tuTor is not null then 1
           else 0 end as rol_tutor
from DB_UOC_PROD.DD_OD.TERCERS_DATOS_PERSONAS_TEST as tdp
left join DB_UOC_PROD.DD_OD.TERCERS_REF_DIRECCIONES_TEST  as trd on tdp.idp= trd.cod_elemento
left join DB_UOC_PROD.DD_OD.TERCERS_DIRECCIONES_TEST  as td on trd.num_direccion = td.num_direccion
left join DB_UOC_PROD.DD_OD.TERCERS_PAISES_TEST as tp1 on td.cod_pais= tp1.cod_pais
left join DB_UOC_PROD.DD_OD.TERCERS_PAISES_TEST as tp2 on tdp.cod_pais_nacim = tp2.cod_pais
left join DB_UOC_PROD.DD_OD.TERCERS_PAISES_TEST as tp3 on tdp.cod_pais_nacion = tp3.cod_pais
left join db_uoc_prod.dd_od.DIM_PAIS_RESIDENCIA_TEST as dpr 
on  td.cod_postal = dpr.cod_postal and td.ind_localizacion = dpr.ind_localitzacio and tp1.descripcion = dpr.pais
left join (select distinct idp 
          from DB_UOC_PROD.DD_OD.GAT_EXPEDIENTES_TEST
          ) as sub -- Voy a buscar estudiantes
on tdp.idp = sub.idp
left join (select distinct idp
           from  DB_UOC_PROD.DD_OD.GAT_PERSONAS_ASIGNATURAS_TEST
           ) as sub2 -- Voy a buscar pras
on tdp.idp = sub2.idp
left join (select distinct idp
          from DB_UOC_PROD.DD_OD.GAT_AULAS_ASIG_CONSULTORES_TEST
          ) as sub3 --voy a buscar PDC
on tdp.idp = sub3.idp
left join (select distinct idp_tutor
           from DB_UOC_PROD.DD_OD.GAT_ESTUD_TUTOR_HIST_TEST) as sub4
on tdp.idp = sub4.idp_tutor
left join DD_OD.TERCERS_TIPO_DOCUMENTOS_TEST as ttd on  tdp.tipo_documento = ttd.codigo) AS ORIGEN -- Query de origen
ON db_uoc_prod.dd_od.dim_persona_TEST.dim_persona_key = origen.idp
when matched
then update set 
DIM_PERSONA_KEY = origen.IDP, 
ID_PERSONA_UNEIX_30 = origen.ID_PERSONA_UNEIX_30,
AMB_DIRECCIONS = origen.CON_DIRECCIONES, 
TIPUS_DOCUMENT = origen.TIPO_DOCUMENTO, 
DNI = origen.DNI, 
NIF_UNEIX_10 = origen.NIF_UNEIX_10,
NIF_UNEIX_20 = origen.NIF_UNEIX_20,
DNI_COMPACTAT = origen.DNI_COMPACTADO, 
NOM = origen.NOMBRE, 
NOM_UNEIX_30 = origen.NOM_UNEIX_30,
COGNOM1 = origen.APELLIDO1, 
COGNOM1_UNEIX_30 = origen.COGNOM1_UNEIX_30, 
COGNOM2 = origen.APELLIDO2, 
COGNOM2_UNEIX_30 = origen.COGNOM2_UNEIX_30, 
NUM_SEGUR_SOCIAL = origen.NUM_SEGUR_SOCIAL, 
DATA_EXPEDICIO_DNI = origen.FECHA_EXPEDICION_DNI, 
DATA_INSERCIO = origen.FECHA_INSERCION, 
DATA_ULT_MODIF = origen.FECHA_ULT_MODIF, 
PREFIX_TELEFON1 = origen.PREFIJO_TELEFONO1, 
TELEFON1 = origen.TELEFONO1, 
PREFIX_TELEFON2 = origen.PREFIJO_TELEFONO2, 
TELEFON2 = origen.TELEFONO2, 
PREFIX_FAX = origen.PREFIJO_FAX, 
FAX = origen.FAX, 
E_MAIL = origen.E_MAIL, 
TIPUS_PERSONA = origen.TIPO_PERSONA, 
IDIOMA_COLABORADOR = origen.COD_IDIOMA_COLABORADOR, 
IDIOMA_RELACIO = origen.COD_IDIOMA_RELACION, 
ROBINSON = origen.ROBINSON, 
SANCIONAT_ECONOMIA = origen.IND_SANCIONADO_ECONOMIA, 
VAT_NUMBER = origen.VAT_NUMBER, 
EDAT = origen.EDAT, 
DATA_NAIXEMENT = origen.FECHA_NACIM, 
ANY_NAIXEMENT = origen.ANY_NAIXEMENT,
SEXE = origen.SEXE,
SEXE_UNEIX = origen.SEXE_UNEIX,
PAIS = origen.PAIS, 
NACIONALITAT = origen.NACIONALITAT, 
PAIS_NAIXEMENT = origen.PAIS_NACIM, 
ROL_ESTUDIANT = origen.ROL_ESTUDIANT, 
ROL_PRA = origen.ROL_PRA, 
ROL_PDC = origen.ROL_PDC, 
ROL_TUTOR = origen.ROL_TUTOR,  
UPDATE_DATE = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert 
(ID_PERSONA,DIM_PERSONA_KEY, ID_PERSONA_UNEIX_30, AMB_DIRECCIONS, TIPUS_DOCUMENT, DNI, NIF_UNEIX_10, NIF_UNEIX_20, DNI_COMPACTAT, NOM, NOM_UNEIX_30, COGNOM1, COGNOM1_UNEIX_30, COGNOM2, COGNOM2_UNEIX_30, NUM_SEGUR_SOCIAL, DATA_EXPEDICIO_DNI, DATA_INSERCIO, DATA_ULT_MODIF, PREFIX_TELEFON1, TELEFON1, PREFIX_TELEFON2, TELEFON2, PREFIX_FAX, FAX, E_MAIL, TIPUS_PERSONA, IDIOMA_COLABORADOR, IDIOMA_RELACIO, ROBINSON, SANCIONAT_ECONOMIA, VAT_NUMBER, EDAT, DATA_NAIXEMENT, ANY_NAIXEMENT, SEXE, SEXE_UNEIX, PAIS, NACIONALITAT, PAIS_NAIXEMENT, ROL_ESTUDIANT, ROL_PRA, ROL_PDC, ROL_TUTOR, CREATION_DATE, UPDATE_DATE)
values 
(db_uoc_prod.dd_od.sequencia_id_dim_persona.nextval, 
origen.IDP, 
origen.ID_PERSONA_UNEIX_30,
origen.CON_DIRECCIONES, 
origen.TIPO_DOCUMENTO, 
origen.DNI, 
origen.NIF_UNEIX_10,
origen.NIF_UNEIX_20,
origen.DNI_COMPACTADO, 
origen.NOMBRE, 
origen.NOM_UNEIX_30,
origen.APELLIDO1, 
origen.COGNOM1_UNEIX_30, 
origen.APELLIDO2, 
origen.COGNOM2_UNEIX_30, 
origen.NUM_SEGUR_SOCIAL, 
origen.FECHA_EXPEDICION_DNI, 
origen.FECHA_INSERCION, 
origen.FECHA_ULT_MODIF, 
origen.PREFIJO_TELEFONO1, 
origen.TELEFONO1, 
origen.PREFIJO_TELEFONO2, 
origen.TELEFONO2, 
origen.PREFIJO_FAX, 
origen.FAX, 
origen.E_MAIL, 
origen.TIPO_PERSONA, 
origen.COD_IDIOMA_COLABORADOR, 
origen.COD_IDIOMA_RELACION, 
origen.ROBINSON, 
origen.IND_SANCIONADO_ECONOMIA, 
origen.VAT_NUMBER, 
origen.EDAT, 
origen.FECHA_NACIM, 
origen.ANY_NAIXEMENT,
origen.SEXE,
origen.SEXE_UNEIX,
origen.PAIS, 
origen.NACIONALITAT, 
origen.PAIS_NACIM, 
origen.ROL_ESTUDIANT, 
origen.ROL_PRA, 
origen.ROL_PDC, 
origen.ROL_TUTOR,
convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), 
convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));




execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_persona_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_persona_Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_PERSONA_TUTOR */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  or replace PROCEDURE DB_UOC_PROD.DD_OD.DIM_PERSONA_TUTOR_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- Carga del registre 0

MERGE INTO db_uoc_prod.dd_od.dim_persona_tutor_TEST
USING (
       SELECT
       0 AS ID_PERSONA_TUTOR, 
       ''ND'' AS DIM_PERSONA_TUTOR_KEY,
        0 AS IDP, 
        0 AS AMB_DIRECCIONS, 
        ''ND'' AS TIPUS_DOCUMENT, 
        ''ND'' AS PREFIX_TELEFON1, 
        ''ND'' AS PREFIX_TELEFON2, 
        ''ND'' AS TIPUS_PERSONA,  
        ''ND'' AS IDIOMA_RELACIO, 
        ''ND'' AS ROBINSON, 
        ''ND'' AS SANCIONAT_ECONOMIA, 
        0 AS EDAT, 
        NULL AS DATA_NAIXEMENT, 
        ''ND'' AS SEXE, 
        ''ND'' AS PAIS, 
        ''ND'' AS NACIONALITAT, 
        ''ND'' AS PAIS_NAIXEMENT, 
        0 AS ROL_ESTUDIANT, 
        0 AS ROL_PRA, 
        0 AS ROL_PDC, 
        0 AS ROL_TUTOR, 
        ''ND'' AS TIPUS_TUTOR, 
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz) AS CREATION_DATE, 
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz) AS UPDATE_DATE
) AS dim_persona_repl
ON db_uoc_prod.dd_od.dim_persona_tutor_TEST.ID_PERSONA_TUTOR = dim_persona_repl.ID_PERSONA_TUTOR
WHEN MATCHED THEN 
    UPDATE SET UPDATE_DATE = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz)
WHEN NOT MATCHED THEN 
    INSERT (
  ID_PERSONA_TUTOR, DIM_PERSONA_TUTOR_KEY, IDP, AMB_DIRECCIONS, TIPUS_DOCUMENT, PREFIX_TELEFON1, PREFIX_TELEFON2, TIPUS_PERSONA, IDIOMA_RELACIO, ROBINSON, SANCIONAT_ECONOMIA, EDAT, DATA_NAIXEMENT, SEXE, PAIS, NACIONALITAT, PAIS_NAIXEMENT, ROL_ESTUDIANT, ROL_PRA, ROL_PDC, ROL_TUTOR, TIPUS_TUTOR, CREATION_DATE, UPDATE_DATE
    )
    VALUES (
        0, ''ND'',0, 0, ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', ''ND'', 0, NULL, ''ND'', ''ND'', ''ND'', ''ND'', 0, 0, 0, 0, ''ND'', 
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz), 
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz)
    );



--Actualizació dades
merge into db_uoc_prod.dd_od.dim_persona_tutor_TEST
using (select
       concat(dim_persona_key,sub_tipo_tutor.tipo_tutor) as dim_persona_tutor_key,
       dim_persona_key,
       amb_direccions,
       tipus_document,
       prefix_telefon1,
       prefix_telefon2,
       tipus_persona,
       idioma_relacio,
       robinson,
       sancionat_economia,
       edat,
       data_naixement,
       sexe,
       pais,
       nacionalitat,
       pais_naixement,
       rol_estudiant,
       rol_pra,
       rol_pdc,
       rol_tutor,
       sub_tipo_tutor.tipo_tutor,
       creation_date,
       update_date
from db_uoc_prod.dd_od.dim_persona_TEST as dim_persona
inner join (select distinct idp_tutor, tipo_tutor
           from db_uoc_prod.dd_od.tutor_unic_periode_hist_TEST) as sub_tipo_tutor
on dim_persona.dim_persona_key = sub_tipo_tutor. idp_tutor
where rol_tutor = 1) AS ORIGEN -- Query de origen
ON db_uoc_prod.dd_od.dim_persona_tutor_TEST.idp = origen.dim_persona_key and db_uoc_prod.dd_od.dim_persona_tutor_TEST.tipus_tutor = origen.tipo_tutor
when matched
then update set
DIM_PERSONA_TUTOR_KEY = origen.dim_persona_tutor_key,
IDP = origen.dim_persona_key, 
AMB_DIRECCIONS = origen.amb_direccions, 
TIPUS_DOCUMENT = origen.tipus_document, 
PREFIX_TELEFON1 = origen.prefix_telefon1, 
PREFIX_TELEFON2 = origen.prefix_telefon2, 
TIPUS_PERSONA = origen.tipus_persona, 
IDIOMA_RELACIO = origen.idioma_relacio, 
ROBINSON = origen.robinson, 
SANCIONAT_ECONOMIA = origen.sancionat_economia, 
EDAT = origen.edat, 
DATA_NAIXEMENT = origen.data_naixement, 
SEXE = origen.sexe, 
PAIS = origen.pais, 
NACIONALITAT = origen.nacionalitat, 
PAIS_NAIXEMENT = origen.pais_naixement, 
ROL_ESTUDIANT = origen.rol_estudiant, 
ROL_PRA = origen.rol_pra, 
ROL_PDC = origen.rol_pdc, 
ROL_TUTOR = origen.rol_tutor, 
TIPUS_TUTOR = origen.tipo_tutor, 
UPDATE_DATE = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::timestamp_ntz)
when not matched
then insert (DIM_PERSONA_TUTOR_KEY, IDP, AMB_DIRECCIONS, TIPUS_DOCUMENT, PREFIX_TELEFON1, PREFIX_TELEFON2, TIPUS_PERSONA, IDIOMA_RELACIO, ROBINSON, SANCIONAT_ECONOMIA, EDAT, DATA_NAIXEMENT, SEXE, PAIS, NACIONALITAT, PAIS_NAIXEMENT, ROL_ESTUDIANT, ROL_PRA, ROL_PDC, ROL_TUTOR, TIPUS_TUTOR, CREATION_DATE, UPDATE_DATE)
values (origen.dim_persona_tutor_key, origen.dim_persona_key, origen.amb_direccions, origen.tipus_document, origen.prefix_telefon1, origen.prefix_telefon2, origen.tipus_persona, origen.idioma_relacio, origen.robinson, origen.sancionat_economia, origen.edat, origen.data_naixement, origen.sexe, origen.pais, origen.nacionalitat, origen.pais_naixement, origen.rol_estudiant, origen.rol_pra, origen.rol_pdc, origen.rol_tutor, origen.tipo_tutor,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));



execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_persona_tutor_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_persona_tutor_Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_PORTAFOLI_PA */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE or replace  PROCEDURE DB_UOC_PROD.DD_OD.DIM_PORTAFOLI_PA_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'BEGIN
  LET start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
  LET execution_time FLOAT;
 
  -- Proces que incorpora el registre 0 a la dimensio.
  MERGE INTO db_uoc_prod.dd_od.dim_portafoli_pa_TEST AS target
  USING (SELECT 
                0 AS id_portafoli_pa, 
                ''ND'' AS dim_portafoli_pa_key, 
                null AS num_creditos_teoricos,
                null AS num_creditos_practicos,
                null AS min_creditos_clase_tm,
                null AS min_creditos_clase_of,
                null AS min_creditos_clase_pi,
                null AS min_creditos_clase_la,
                null AS min_creditos_clase_c,
                ''ND'' AS ind_titulaciones_propias,
                ''ND'' AS estado_plan,
                null AS num_version_plan,
                ''ND'' AS descripcion,
                null AS cod_estudios,
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS fecha_publica_oficial,
                ''ND'' AS desc_publica_oficial,
                null AS ciclo_plan,
                ''ND'' AS ind_creditos_asignaturas,
                null AS min_creditos_asignaturas,
                null AS max_creditos_asignaturas,
                null AS conta_elementos,
                ''ND'' AS observaciones,
                null AS num_control,
                ''ND'' AS cod_estudios_mec,
                ''ND'' AS ind_valida_inicio_exp,
                null AS min_creditos_mec,
                ''ND'' AS cod_area,
                null AS num_edicion,
                ''ND'' AS descripcion_cer,
                null AS num_creditos_ciclo2,
                ''ND'' AS es_ciclo_12,
                ''ND'' AS tipo_educacion,
                ''ND'' AS ind_visible_egia,
                ''ND'' AS ind_consecucion_parcial,
                null AS ratio_conversio,
                null AS ratio_fideliza,
                null AS max_estud_tutor,
                null AS id_prog_bof,
                ''ND'' AS ind_interuniversitario,
                ''ND'' AS idioma_docencia,
                ''ND'' AS ind_migracion_gatib,
                0 AS id_bof_tr,
                ''ND'' AS des_denominacio_ca_tr,
                ''ND'' AS des_unitat_organica_ca_tr,
                ''ND'' AS des_tipologia_ca_tr,
                ''ND'' AS des_iniciativa_ca_tr,
                0 AS id_bof, 
                ''ND'' AS des_denominacio_ca, 
                ''ND'' AS des_estat_ca, 
                ''ND'' AS des_vicegerencia_ca, 
                ''ND'' AS des_tipologia_ca, 
                ''ND'' AS des_totp, 
                ''ND'' AS des_iniciativa_ca, 
                ''ND'' AS des_unitat_organica_ca, 
                ''ND'' AS des_nivell_academic_ca, 
                ''ND'' AS des_nivell_meces_ca, 
                ''ND'' AS des_legislacio_ca, 
                0 AS ects_a_superar, 
                ''ND''::VARIANT AS ects_desglossat_per_tipologia, 
                0 AS ects_a_desplegar, 
                ''ND''::VARIANT AS des_director_de_programa, 
                ''ND'' AS des_responsable_academic_ca, 
                ''ND''::VARIANT AS des_manager_de_programa, 
                ''ND'' AS des_coordinadora_ca, 
                ''ND'' AS des_arrel_programa, 
                ''ND'' AS des_estat_prim_reg, 
                ''ND'' AS des_estat_solicitud, 
                ''ND'' AS des_estat_programa_disseny_titulacions_inici, 
                ''ND'' AS des_estat_resultat_informe_final_verificacio_aqu, 
                ''ND'' AS des_estat_programa_disseny_titulacions_fi, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_verificacio, 
                ''ND'' AS des_estat_disseny_titulacions, 
                0 AS data_previsio_implantacio_mes, 
                0 AS data_previsio_implantacio_any, 
                0 AS data_implantacio_real_mes, 
                0 AS data_implantacio_real_any, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_de_linforme_final_modificacio_aqu, 
                ''ND'' AS des_estat_programa_acreditar_titulacions, 
                ''ND'' AS des_estat_solicitud_extincio_cicle_vida, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_inici_extincio, 
                ''1900-01-01 00:00:00.000''::TIMESTAMP_NTZ AS data_extincio, 
                CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS creation_date,
                CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) AS update_date
            ) AS source
  ON target.id_portafoli_pa = source.id_portafoli_pa
  WHEN MATCHED THEN 
    UPDATE SET update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
  WHEN NOT MATCHED THEN 
    INSERT (id_portafoli_pa, dim_portafoli_pa_key, num_creditos_teoricos, num_creditos_practicos, min_creditos_clase_tm, min_creditos_clase_of, min_creditos_clase_pi, min_creditos_clase_la, min_creditos_clase_c, ind_titulaciones_propias, estado_plan, num_version_plan, descripcion, cod_estudios, fecha_publica_oficial, desc_publica_oficial, ciclo_plan, ind_creditos_asignaturas, min_creditos_asignaturas, max_creditos_asignaturas, conta_elementos, observaciones, num_control, cod_estudios_mec, ind_valida_inicio_exp, min_creditos_mec, cod_area, num_edicion, descripcion_cer, num_creditos_ciclo2, es_ciclo_12, tipo_educacion, ind_visible_egia, ind_consecucion_parcial, ratio_conversio, ratio_fideliza, max_estud_tutor, id_prog_bof, ind_interuniversitario, idioma_docencia, ind_migracion_gatib,
    id_bof_tr, des_denominacio_ca_tr, des_unitat_organica_ca_tr, des_tipologia_ca_tr, des_iniciativa_ca_tr, id_bof, des_denominacio_ca, des_estat_ca, des_vicegerencia_ca, des_tipologia_ca, des_totp, des_iniciativa_ca, des_unitat_organica_ca, des_nivell_academic_ca, des_nivell_meces_ca, des_legislacio_ca, ects_a_superar, ects_desglossat_per_tipologia, ects_a_desplegar, des_director_de_programa, des_responsable_academic_ca, des_manager_de_programa, des_coordinadora_ca, des_arrel_programa, des_estat_prim_reg, des_estat_solicitud, des_estat_programa_disseny_titulacions_inici, des_estat_resultat_informe_final_verificacio_aqu, des_estat_programa_disseny_titulacions_fi, data_verificacio, des_estat_disseny_titulacions, data_previsio_implantacio_mes, data_previsio_implantacio_any, data_implantacio_real_mes, data_implantacio_real_any, data_de_linforme_final_modificacio_aqu, des_estat_programa_acreditar_titulacions, des_estat_solicitud_extincio_cicle_vida, data_inici_extincio, data_extincio, 
    creation_date, update_date)
    VALUES (
        source.id_portafoli_pa
        , source.dim_portafoli_pa_key
        , source.num_creditos_teoricos
        , source.num_creditos_practicos
        , source.min_creditos_clase_tm
        , source.min_creditos_clase_of
        , source.min_creditos_clase_pi
        , source.min_creditos_clase_la
        , source.min_creditos_clase_c
        , source.ind_titulaciones_propias
        , source.estado_plan
        , source.num_version_plan
        , source.descripcion
        , source.cod_estudios
        , source.fecha_publica_oficial
        , source.desc_publica_oficial
        , source.ciclo_plan
        , source.ind_creditos_asignaturas
        , source.min_creditos_asignaturas
        , source.max_creditos_asignaturas
        , source.conta_elementos
        , source.observaciones
        , source.num_control
        , source.cod_estudios_mec
        , source.ind_valida_inicio_exp
        , source.min_creditos_mec
        , source.cod_area
        , source.num_edicion
        , source.descripcion_cer
        , source.num_creditos_ciclo2
        , source.es_ciclo_12
        , source.tipo_educacion
        , source.ind_visible_egia
        , source.ind_consecucion_parcial
        , source.ratio_conversio
        , source.ratio_fideliza
        , source.max_estud_tutor
        , source.id_prog_bof
        , source.ind_interuniversitario
        , source.idioma_docencia
        , source.ind_migracion_gatib
        , source.id_bof_tr
        , source.des_denominacio_ca_tr
        , source.des_unitat_organica_ca_tr
        , source.des_tipologia_ca_tr
        , source.des_iniciativa_ca_tr
        , source.id_bof
        , source.des_denominacio_ca
        , source.des_estat_ca
        , source.des_vicegerencia_ca
        , source.des_tipologia_ca
        , source.des_totp
        , source.des_iniciativa_ca
        , source.des_unitat_organica_ca
        , source.des_nivell_academic_ca
        , source.des_nivell_meces_ca
        , source.des_legislacio_ca
        , source.ects_a_superar
        , source.ects_desglossat_per_tipologia
        , source.ects_a_desplegar
        , source.des_director_de_programa
        , source.des_responsable_academic_ca
        , source.des_manager_de_programa
        , source.des_coordinadora_ca
        , source.des_arrel_programa
        , source.des_estat_prim_reg
        , source.des_estat_solicitud
        , source.des_estat_programa_disseny_titulacions_inici
        , source.des_estat_resultat_informe_final_verificacio_aqu
        , source.des_estat_programa_disseny_titulacions_fi
        , source.data_verificacio
        , source.des_estat_disseny_titulacions
        , source.data_previsio_implantacio_mes
        , source.data_previsio_implantacio_any
        , source.data_implantacio_real_mes
        , source.data_implantacio_real_any
        , source.data_de_linforme_final_modificacio_aqu
        , source.des_estat_programa_acreditar_titulacions
        , source.des_estat_solicitud_extincio_cicle_vida
        , source.data_inici_extincio
        , source.data_extincio
        , source.creation_date
        , source.update_date

    );

  
  MERGE INTO db_uoc_prod.dd_od.dim_portafoli_pa_TEST  AS target
  USING (
  WITH RECURSIVE Relationship_CTE AS (
    -- Caso base: Seleccionamos todas las filas de la tabla original
    SELECT id_bof, id_bof_rel
    FROM DD_OD.PROGRAM_RELACIONES_TEST
    WHERE
        des_relacion_ca IN (''Adaptació'', ''Evolució'') 
        AND (
            CASE 
                WHEN des_relacion:mes IS NOT NULL AND des_relacion:any IS NOT NULL THEN 
                TO_DATE(CONCAT(des_relacion:any::STRING, ''-'', des_relacion:mes::STRING, ''-01''), ''YYYY-MM-DD'')
            ELSE NULL
            END < CURRENT_DATE
            OR des_relacion:any::STRING IS NULL
            OR des_relacion:mes::STRING IS NULL
        )

    UNION ALL

    -- Caso recursivo: Encontramos la siguiente relación en la cadena
    SELECT r.id_bof, t.id_bof_rel
    FROM Relationship_CTE r
    JOIN DD_OD.PROGRAM_RELACIONES_TEST t
    ON r.id_bof_rel = t.id_bof
    WHERE
        t.des_relacion_ca IN (''Adaptació'', ''Evolució'') 
        AND (
            CASE 
                WHEN t.des_relacion:mes IS NOT NULL AND t.des_relacion:any IS NOT NULL THEN 
                TO_DATE(CONCAT(t.des_relacion:any::STRING, ''-'', t.des_relacion:mes::STRING, ''-01''), ''YYYY-MM-DD'')
            ELSE NULL
            END < CURRENT_DATE
            OR t.des_relacion:any::STRING IS NULL
            OR t.des_relacion:mes::STRING IS NULL
        )
    ),

    Final_Relationships AS (
        -- Seleccionamos la última relación para cada id_bof
        SELECT id_bof, MAX(cte.id_bof_rel) AS id_bof_tr
        FROM Relationship_CTE cte
        GROUP BY id_bof
    ),
    bof_tr AS (
        SELECT bt.* , 
            PROGRAM.des_denominacio_ca AS des_denominacio_ca_tr, 
            PROGRAM.des_tipologia_ca AS des_tipologia_ca_tr, 
            PROGRAM.des_unitat_organica_ca AS des_unitat_organica_ca_tr,
            PROGRAM.des_iniciativa[0]:descripcion:ca::STRING AS des_iniciativa_ca_tr
        FROM (
                SELECT 
                    COALESCE(fr.id_bof_tr, PROGRAM.id_bof) AS id_bof_tr
                    , PROGRAM.*
            FROM DD_OD.PROGRAM_TEST  as PROGRAM
            LEFT JOIN Final_Relationships fr ON fr.id_bof = PROGRAM.id_bof
        ) bt
        LEFT JOIN DD_OD.PROGRAM_TEST  as PROGRAM 
            ON bt.id_bof_tr = PROGRAM.id_bof
    )
    SELECT 
        pd.cod_plan AS dim_portafoli_pa_key, 
        pd.num_creditos_teoricos, 
        pd.num_creditos_practicos, 
        pd.min_creditos_clase_tm, 
        pd.min_creditos_clase_of, 
        pd.min_creditos_clase_pi, 
        pd.min_creditos_clase_la, 
        pd.min_creditos_clase_c, 
        pd.ind_titulaciones_propias, 
        pd.estado_plan, 
        pd.num_version_plan, 
        pd.descripcion, 
        pd.cod_estudios, 
        pd.fecha_publica_oficial, 
        pd.desc_publica_oficial, 
        pd.ciclo_plan, 
        pd.ind_creditos_asignaturas, 
        pd.min_creditos_asignaturas, 
        pd.max_creditos_asignaturas, 
        pd.conta_elementos, 
        pd.observaciones, 
        pd.num_control, 
        pd.cod_estudios_mec, 
        pd.ind_valida_inicio_exp, 
        pd.min_creditos_mec, 
        pd.cod_area, 
        pd.num_edicion, 
        pd.descripcion_cer, 
        pd.num_creditos_ciclo2, 
        pd.es_ciclo_12, 
        pd.tipo_educacion, 
        pd.ind_visible_egia, 
        pd.ind_consecucion_parcial, 
        pd.ratio_conversio, 
        pd.ratio_fideliza, 
        pd.max_estud_tutor, 
        pd.id_prog_bof, 
        pd.ind_interuniversitario, 
        pd.idioma_docencia, 
        pd.ind_migracion_gatib,
        pa.id_bof_tr,
        ifnull (pa.des_denominacio_ca_tr, ''ND'') as des_denominacio_ca_tr, 
        pa.des_unitat_organica_ca_tr,
        pa.des_tipologia_ca_tr, 
        pa.des_iniciativa_ca_tr,
        pa.id_bof, 
        ifnull (pa.des_denominacio_ca, ''ND'') as des_denominacio_ca, 
        pa.des_estat_ca, 
        pa.des_vicegerencia_ca, 
        pa.des_tipologia_ca, 
        pa.des_totp, 
        pa.des_iniciativa[0]:descripcion:ca::STRING AS des_iniciativa_ca, 
        pa.des_unitat_organica_ca, 
        pa.des_nivell_academic_ca, 
        pa.des_nivell_meces_ca,
        pa.des_legislacio_ca, 
        pa.ects_a_superar, 
        pa.ects_desglossat_per_tipologia, 
        pa.ects_a_desplegar, 
        pa.des_director_de_programa, 
        pa.des_responsable_academic_ca,  
        pa.des_manager_de_programa, 
        pa.des_coordinadora_ca, 
        pa.des_arrel_programa, 
        pa.des_estat_prim_reg, 
        pa.des_estat_solicitud, 
        pa.des_estat_programa_disseny_titulacions_inici, 
        pa.des_estat_resultat_informe_final_verificacio_aqu, 
        pa.des_estat_programa_disseny_titulacions_fi, 
        pa.data_verificacio, 
        pa.des_estat_disseny_titulacions, 
        pa.data_previsio_implantacio_mes, 
        pa.data_previsio_implantacio_any, 
        pa.data_implantacio_real_mes, 
        pa.data_implantacio_real_any, 
        pa.data_de_linforme_final_modificacio_aqu, 
        pa.des_estat_programa_acreditar_titulacions, 
        pa.des_estat_solicitud_extincio_cicle_vida, 
        pa.data_inici_extincio, 
        pa.data_extincio
    FROM DD_OD.GAT_PLAN_DATOS_TEST pd
    LEFT JOIN bof_tr pa ON pd.id_prog_bof=pa.id_bof
    ) AS source
    ON target.dim_portafoli_pa_key = source.dim_portafoli_pa_key
  WHEN MATCHED THEN 
    UPDATE SET update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
  WHEN NOT MATCHED THEN 
    INSERT (dim_portafoli_pa_key, num_creditos_teoricos, num_creditos_practicos, min_creditos_clase_tm, min_creditos_clase_of, min_creditos_clase_pi, min_creditos_clase_la, min_creditos_clase_c, ind_titulaciones_propias, estado_plan, num_version_plan, descripcion, cod_estudios, fecha_publica_oficial, desc_publica_oficial, ciclo_plan, ind_creditos_asignaturas, min_creditos_asignaturas, max_creditos_asignaturas, conta_elementos, observaciones, num_control, cod_estudios_mec, ind_valida_inicio_exp, min_creditos_mec, cod_area, num_edicion, descripcion_cer, num_creditos_ciclo2, es_ciclo_12, tipo_educacion, ind_visible_egia, ind_consecucion_parcial, ratio_conversio, ratio_fideliza, max_estud_tutor, id_prog_bof, ind_interuniversitario, idioma_docencia, ind_migracion_gatib, 
    id_bof_tr, des_denominacio_ca_tr, des_unitat_organica_ca_tr, des_tipologia_ca_tr, des_iniciativa_ca_tr,id_bof, des_denominacio_ca, des_estat_ca, des_vicegerencia_ca, des_tipologia_ca, des_totp, des_iniciativa_ca, des_unitat_organica_ca, des_nivell_academic_ca, des_nivell_meces_ca, des_legislacio_ca, ects_a_superar, ects_desglossat_per_tipologia, ects_a_desplegar, des_director_de_programa, des_responsable_academic_ca, des_manager_de_programa, des_coordinadora_ca, des_arrel_programa, des_estat_prim_reg, des_estat_solicitud, des_estat_programa_disseny_titulacions_inici, des_estat_resultat_informe_final_verificacio_aqu, des_estat_programa_disseny_titulacions_fi, data_verificacio, des_estat_disseny_titulacions, data_previsio_implantacio_mes, data_previsio_implantacio_any, data_implantacio_real_mes, data_implantacio_real_any, data_de_linforme_final_modificacio_aqu, des_estat_programa_acreditar_titulacions, des_estat_solicitud_extincio_cicle_vida, data_inici_extincio, data_extincio, 
    creation_date, update_date)
    VALUES (
        source.dim_portafoli_pa_key
        , source.num_creditos_teoricos
        , source.num_creditos_practicos
        , source.min_creditos_clase_tm
        , source.min_creditos_clase_of
        , source.min_creditos_clase_pi
        , source.min_creditos_clase_la
        , source.min_creditos_clase_c
        , source.ind_titulaciones_propias
        , source.estado_plan
        , source.num_version_plan
        , source.descripcion
        , source.cod_estudios
        , source.fecha_publica_oficial
        , source.desc_publica_oficial
        , source.ciclo_plan
        , source.ind_creditos_asignaturas
        , source.min_creditos_asignaturas
        , source.max_creditos_asignaturas
        , source.conta_elementos
        , source.observaciones
        , source.num_control
        , source.cod_estudios_mec
        , source.ind_valida_inicio_exp
        , source.min_creditos_mec
        , source.cod_area
        , source.num_edicion
        , source.descripcion_cer
        , source.num_creditos_ciclo2
        , source.es_ciclo_12
        , source.tipo_educacion
        , source.ind_visible_egia
        , source.ind_consecucion_parcial
        , source.ratio_conversio
        , source.ratio_fideliza
        , source.max_estud_tutor
        , source.id_prog_bof
        , source.ind_interuniversitario
        , source.idioma_docencia
        , source.ind_migracion_gatib
        , source.id_bof_tr
        , source.des_denominacio_ca_tr
        , source.des_unitat_organica_ca_tr
        , source.des_tipologia_ca_tr
        , source.des_iniciativa_ca_tr
        , source.id_bof
        , source.des_denominacio_ca
        , source.des_estat_ca
        , source.des_vicegerencia_ca
        , source.des_tipologia_ca
        , source.des_totp
        , source.des_iniciativa_ca
        , source.des_unitat_organica_ca
        , source.des_nivell_academic_ca
        , source.des_nivell_meces_ca
        , source.des_legislacio_ca
        , source.ects_a_superar
        , source.ects_desglossat_per_tipologia
        , source.ects_a_desplegar
        , source.des_director_de_programa
        , source.des_responsable_academic_ca
        , source.des_manager_de_programa
        , source.des_coordinadora_ca
        , source.des_arrel_programa
        , source.des_estat_prim_reg
        , source.des_estat_solicitud
        , source.des_estat_programa_disseny_titulacions_inici
        , source.des_estat_resultat_informe_final_verificacio_aqu
        , source.des_estat_programa_disseny_titulacions_fi
        , source.data_verificacio
        , source.des_estat_disseny_titulacions
        , source.data_previsio_implantacio_mes
        , source.data_previsio_implantacio_any
        , source.data_implantacio_real_mes
        , source.data_implantacio_real_any
        , source.data_de_linforme_final_modificacio_aqu
        , source.des_estat_programa_acreditar_titulacions
        , source.des_estat_solicitud_extincio_cicle_vida
        , source.data_inici_extincio
        , source.data_extincio
        , CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
        , CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
    );

  execution_time := DATEDIFF(MILLISECOND, start_time, CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

  INSERT INTO db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
  VALUES (db_uoc_prod.dd_od.sequencia_id_log.NEXTVAL, ''dim_portafoli_pa_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_portafoli_pa Success'');

  RETURN ''Update completed successfully'';

END';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_QUALIFICACIO */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_QUALIFICACIO_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

merge into db_uoc_prod.dd_od.dim_qualificacio_TEST
using (select 0 as id_qualificacio, ''ND'' as dim_qualificacio_key,''ND'' as desc_qualificacio, ''ND'' as desc_qualificacio_curta, ''-'' as ind_supera, ''-'' as ind_consumeix_convocatoria, ''-'' as ind_np, ''-'' as ind_mh, ''-'' as ind_an, ''-'' as ind_convalida, ''-'' as ind_adapta, ''-'' as ind_tesi, ''-'' as ind_correcte_junta, ''-'' as ind_pdt_qualificacio, ''-'' as ind_participa, ''-'' as ind_calcular_numerica, ''-'' as ind_nota_final_expedient, 0 as valor_num_minim, 0 as valor_num_maxim, 0 as valor_num_associat, 0 as valor_num_beca, 0 as valor_num_pe, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_qualificacio_repl
on db_uoc_prod.dd_od.dim_qualificacio_TEST.id_qualificacio = dim_qualificacio_repl.id_qualificacio
when matched
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (id_qualificacio, dim_qualificacio_key, desc_qualificacio, desc_qualificacio_curta, ind_supera, ind_consumeix_convocatoria, ind_np, ind_mh, ind_an,  ind_convalida, ind_adapta, ind_tesi, ind_correcte_junta, ind_pdt_qualificacio, ind_participa, ind_calcular_numerica, ind_nota_final_expedient, valor_num_minim, valor_num_maxim, valor_num_associat, valor_num_beca, valor_num_pe, creation_date,  update_date)
values (0, ''ND'',''ND'', ''ND'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', ''-'', 0, 0, 0, 0, 0, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz))
;

merge into db_uoc_prod.dd_od.dim_qualificacio_TEST
using (select cod_calificacion, desc_calificacion, desc_corta, ind_supera, ind_consume_convocatoria, ind_np, ind_mh, ind_an, ind_convalida, ind_adapta, ind_tesis, ind_correcto_junta, valor_num_minimo, valor_num_maximo, valor_num_asociado, ind_pdte_calif, ind_participa, ind_calcular_numerica, ind_nota_final_exped, valor_num_beca, valor_num_pe
from db_uoc_prod.DD_OD.gat_calificaciones_TEST
) as dim_qualificacio_orig
on db_uoc_prod.dd_od.dim_qualificacio_TEST.dim_qualificacio_key = dim_qualificacio_orig.cod_calificacion
when matched then
update set dim_qualificacio_key = dim_qualificacio_orig.cod_calificacion, desc_qualificacio =  dim_qualificacio_orig.desc_calificacion, desc_qualificacio_curta = dim_qualificacio_orig.desc_corta, ind_supera = dim_qualificacio_orig.ind_supera, ind_consumeix_convocatoria = dim_qualificacio_orig.ind_consume_convocatoria, ind_np = dim_qualificacio_orig.ind_np, ind_mh =  dim_qualificacio_orig.ind_mh, ind_an = dim_qualificacio_orig.ind_an,  ind_convalida = dim_qualificacio_orig.ind_convalida, ind_adapta = dim_qualificacio_orig.ind_adapta, ind_tesi = dim_qualificacio_orig.ind_tesis, ind_correcte_junta = dim_qualificacio_orig.ind_correcto_junta, ind_pdt_qualificacio = dim_qualificacio_orig.ind_pdte_calif, ind_participa = dim_qualificacio_orig.ind_participa, ind_calcular_numerica =  dim_qualificacio_orig.ind_calcular_numerica, ind_nota_final_expedient = dim_qualificacio_orig.ind_nota_final_exped, valor_num_minim = dim_qualificacio_orig.valor_num_minimo, valor_num_maxim = dim_qualificacio_orig.valor_num_maximo, valor_num_associat = dim_qualificacio_orig.valor_num_asociado, valor_num_beca =  dim_qualificacio_orig.valor_num_beca, valor_num_pe = dim_qualificacio_orig.valor_num_pe, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
insert (dim_qualificacio_key, desc_qualificacio, desc_qualificacio_curta, ind_supera, ind_consumeix_convocatoria, ind_np, ind_mh, ind_an,  ind_convalida, ind_adapta, ind_tesi, ind_correcte_junta, ind_pdt_qualificacio, ind_participa, ind_calcular_numerica, ind_nota_final_expedient, valor_num_minim, valor_num_maxim, valor_num_associat, valor_num_beca, valor_num_pe, creation_date,  update_date) 
values (dim_qualificacio_orig.cod_calificacion, dim_qualificacio_orig.desc_calificacion, dim_qualificacio_orig.desc_corta, dim_qualificacio_orig.ind_supera, dim_qualificacio_orig.ind_consume_convocatoria, dim_qualificacio_orig.ind_np, dim_qualificacio_orig.ind_mh, dim_qualificacio_orig.ind_an, dim_qualificacio_orig.ind_convalida, dim_qualificacio_orig.ind_adapta, dim_qualificacio_orig.ind_tesis, dim_qualificacio_orig.ind_correcto_junta, dim_qualificacio_orig.ind_pdte_calif, dim_qualificacio_orig.ind_participa, dim_qualificacio_orig.ind_calcular_numerica, dim_qualificacio_orig.ind_nota_final_exped, dim_qualificacio_orig.valor_num_minimo, dim_qualificacio_orig.valor_num_maximo, dim_qualificacio_orig.valor_num_asociado,  dim_qualificacio_orig.valor_num_beca, dim_qualificacio_orig.valor_num_pe, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_qualificacio_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_qualificacio Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_QUALIFICACIO_CONTINUADA */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_QUALIFICACIO_CONTINUADA_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

merge into db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST
using (select 0 as id_qualificacio_continuada, ''ND'' as dim_qualificacio_continuada_key,''ND'' as desc_qualificacio_continuada, ''-'' as ind_activo_continuada, ''-'' as ind_participa_continuada, ''-'' as ind_supera_continuada, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_qualificacio_repl
on db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST.id_qualificacio_continuada = dim_qualificacio_repl.id_qualificacio_continuada
when matched
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (id_qualificacio_continuada, dim_qualificacio_continuada_key, desc_qualificacio_continuada, ind_activo_continuada, ind_participa_continuada, ind_supera_continuada, creation_date,  update_date)
values (0, ''ND'',''ND'', ''-'', ''-'', ''-'', convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz))
;

merge into db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST
using (select cod_calif_cont, desc_calificacion, ind_activo, ind_participa, ind_supera
from db_uoc_prod.DD_OD.GAT_CALIF_CONTINUADA_TEST
) as dim_qualificacio_continuada_orig
on db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST.dim_qualificacio_continuada_key = dim_qualificacio_continuada_orig.cod_calif_cont
when matched then
update set dim_qualificacio_continuada_key = dim_qualificacio_continuada_orig.cod_calif_cont, desc_qualificacio_continuada = dim_qualificacio_continuada_orig.desc_calificacion, ind_activo_continuada = dim_qualificacio_continuada_orig.ind_activo, ind_participa_continuada = dim_qualificacio_continuada_orig.ind_participa, ind_supera_continuada = dim_qualificacio_continuada_orig.ind_supera, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
insert (dim_qualificacio_continuada_key, desc_qualificacio_continuada, ind_activo_continuada, ind_participa_continuada, ind_supera_continuada, creation_date,  update_date) 
values (dim_qualificacio_continuada_orig.cod_calif_cont, dim_qualificacio_continuada_orig.desc_calificacion, dim_qualificacio_continuada_orig.ind_activo, dim_qualificacio_continuada_orig.ind_participa, dim_qualificacio_continuada_orig.ind_supera, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''dim_qualificacio_continuada_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_qualificacio_continuada Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: DIM_SEMESTRE */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.DIM_SEMESTRE_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

merge into db_uoc_prod.dd_od.dim_semestre_TEST
using (select 0 as id_semestre, 19000 as dim_semestre_key,''ND'' as descripcio,1900 as any_natural, 0 as semestre,''ND'' as descripcio_visual,''1900-01-01 00:00:00.000'' as data_inici,''1900-01-01 00:00:00.000'' as data_fi,''1900-1901'' as curs_academic,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as creation_date,convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz) as update_date) as dim_semestre_repl
on db_uoc_prod.dd_od.dim_semestre_TEST.id_semestre = dim_semestre_repl.semestre
when matched
then update set update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched
then insert (id_semestre, dim_semestre_key, descripcio, any_natural, semestre, descripcio_visual, data_inici, data_fi, curs_academic,creation_date, update_date)
values (0,19000,''ND'',1900,0,''ND'',''1900-01-01 00:00:00.000'',''1900-01-01 00:00:00.000'',''1900-1901'',convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz),convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz))
;

merge into db_uoc_prod.dd_od.dim_semestre_TEST
using db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST
on db_uoc_prod.dd_od.dim_semestre_TEST.dim_semestre_key = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_academico
when matched 
then update set 
dim_semestre_key = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_academico, descripcio = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.descripcion, any_natural = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural, semestre =  db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.semestre, descripcio_visual =  db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.desc_visual, data_inici = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.fecha_inicio, data_fi =  db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.fecha_final,curs_academic = db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural || ''-'' || (db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural + 1) ,update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
insert (dim_semestre_key, descripcio, any_natural, semestre, descripcio_visual, data_inici, data_fi, curs_academic,creation_date, update_date) 
values (db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_academico, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.descripcion, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.semestre, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.desc_visual, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.fecha_inicio, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.fecha_final, db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural || ''-'' || (db_uoc_prod.DD_OD.GAT_ANYS_ACADEMICOS_TEST.any_natural + 1),convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz), convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST ( procedure_name, executed_by, execution_date, execution_time, remarks)
    values (''dim_semestre_loads'', CURRENT_USER(), :start_time, :execution_time, ''dim_semestre Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: FACT_DOCENCIA */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.FACT_DOCENCIA_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- Carrega de la taula amb tots els registres de la taula STAGE_DOCENCIA_POST_TEST

-- Carrega de la taula FACT_DOCENCIA des de la taula STAGE_DOCENCIA_POST_TEST. En aquest objecte eliminem qualsevol referencia als codis original i mantenim unicament la informacio dels IDs de les dimensions i els fets quantitatius del proces.
-- El procediment esta pensat com a INSERT or UPDATE es a dir, si existeix el registre actualitza el camp de UPDATE mentre que si no existeix insereix la informacio i actualitza tant el camp de INSERT com el de UPDATE de la taula.
-- Quan estiguem en disposicio de poder actualitzar nomes els registres del periode carregat (malgrat inicialment es carrega tota la informacio des de origen per a cada dia) el procediment funcionara i millorara el seu rendiment de forma optima.

merge into
    db_uoc_prod.dd_od.fact_docencia_TEST
using
(select id_docencia,  
        id_semestre,  
        id_assignatura,  
        id_qualificacio,  
        id_qualificacio_continuada,  
        id_expedient,  
        id_matricula,  
        id_portafoli_pa,  
        id_persona_estudiant,  
        id_pais_nacionalitat,  
        id_pais_naixement,  
        id_pais_residencia,  
        id_acces,  
        id_persona_tutor,  
        nota_mitjana,  
        nota_mitjana_punts,  
        --any_acad_titol,  
        --any_academic,  
        --any_acad_valida,  
        --cod_assignatura,  
        assignatura_cursada,  
        num_credits,  
        num_credits_teorics,  
        num_credits_practics,  
        num_matriculas_assignatura,  
        semestre_relatiu_expedient,  
        semestre_relatiu_super_expedient,  
        semestre_relatiu_uoc,  
       --assigna_clase,  
       --cod_aula,  
       --cod_tfc,  
       --ind_sols_examen,  
        qualif_num_cont,  
        qualif_num_cont_final,  
        qualif_numerica,  
        qualif_numerica_pub,  
        qualif_num_practica,  
        qualif_num_pres,  
        qualif_num_prop,  
        qualif_num_teorica,  
        qualif_practica,  
        qualif_teorica,  
        cod_qualif_conf,  
      --dim_qualificacio_continuada_key,  
        ----cod_qualif_cont,  
      --dim_qualificacio_key,  
      --ind_supera,  
        supera_assignatura,  
        no_supera_assignatura,  
      --cod_qualificacio_pub,  
      --cod_qualif_pres,  
      --cod_qualif_prop,  
      --cod_examen,  
      --idp_corrector,  
        matricula_anulada,  
        assignatura_anulada,  
        assignatura_convalidada,  
        edat_relativa,  
        grup_edat,  
        grup_edat_2
from db_uoc_prod.dd_od.STAGE_DOCENCIA_POST_TEST) as STAGE_DOCENCIA_POST_TEST
on fact_docencia_TEST.id_docencia = STAGE_DOCENCIA_POST_TEST.id_docencia
when matched then
    update
    set
        id_semestre = STAGE_DOCENCIA_POST_TEST.id_semestre,  
        id_assignatura = STAGE_DOCENCIA_POST_TEST.id_assignatura,  
        id_qualificacio = STAGE_DOCENCIA_POST_TEST.id_qualificacio,  
        id_qualificacio_continuada = STAGE_DOCENCIA_POST_TEST.id_qualificacio_continuada,  
        id_expedient = STAGE_DOCENCIA_POST_TEST.id_expedient,  
        id_matricula = STAGE_DOCENCIA_POST_TEST.id_matricula,  
        id_portafoli_pa = STAGE_DOCENCIA_POST_TEST.id_portafoli_pa,  
        id_persona_estudiant = STAGE_DOCENCIA_POST_TEST.id_persona_estudiant,  
        id_pais_nacionalitat = STAGE_DOCENCIA_POST_TEST.id_pais_nacionalitat,  
        id_pais_naixement = STAGE_DOCENCIA_POST_TEST.id_pais_naixement,  
        id_pais_residencia = STAGE_DOCENCIA_POST_TEST.id_pais_residencia,  
        id_acces = STAGE_DOCENCIA_POST_TEST.id_acces,  
        id_persona_tutor = STAGE_DOCENCIA_POST_TEST.id_persona_tutor,  
        nota_mitjana = STAGE_DOCENCIA_POST_TEST.nota_mitjana,  
        nota_mitjana_punts = STAGE_DOCENCIA_POST_TEST.nota_mitjana_punts,  
        assignatura_cursada = STAGE_DOCENCIA_POST_TEST.assignatura_cursada,  
        num_credits = STAGE_DOCENCIA_POST_TEST.num_credits,  
        num_credits_teorics = STAGE_DOCENCIA_POST_TEST.num_credits_teorics,  
        num_credits_practics = STAGE_DOCENCIA_POST_TEST.num_credits_practics,  
        semestre_relatiu_expedient = STAGE_DOCENCIA_POST_TEST.semestre_relatiu_expedient,  
        semestre_relatiu_super_expedient = STAGE_DOCENCIA_POST_TEST.semestre_relatiu_super_expedient,  
        semestre_relatiu_uoc = STAGE_DOCENCIA_POST_TEST.semestre_relatiu_uoc,  
        num_matriculas_assignatura = STAGE_DOCENCIA_POST_TEST.num_matriculas_assignatura,  
        qualif_num_cont = STAGE_DOCENCIA_POST_TEST.qualif_num_cont,  
        qualif_num_cont_final = STAGE_DOCENCIA_POST_TEST.qualif_num_cont_final,  
        qualif_numerica = STAGE_DOCENCIA_POST_TEST.qualif_numerica,  
        qualif_numerica_pub = STAGE_DOCENCIA_POST_TEST.qualif_numerica_pub,  
        qualif_num_practica = STAGE_DOCENCIA_POST_TEST.qualif_num_practica,  
        qualif_num_pres = STAGE_DOCENCIA_POST_TEST.qualif_num_pres,  
        qualif_num_prop = STAGE_DOCENCIA_POST_TEST.qualif_num_prop,  
        qualif_num_teorica = STAGE_DOCENCIA_POST_TEST.qualif_num_teorica,  
        --dim_qualificacio_continuada_key = STAGE_DOCENCIA_POST_TEST.dim_qualificacio_continuada_key,  
        --cod_qualif_cont = STAGE_DOCENCIA_POST_TEST.cod_qualif_cont,  
        --dim_qualificacio_key = STAGE_DOCENCIA_POST_TEST.dim_qualificacio_key,  
        supera_assignatura = STAGE_DOCENCIA_POST_TEST.supera_assignatura,  
        no_supera_assignatura = STAGE_DOCENCIA_POST_TEST.no_supera_assignatura,  
        matricula_anulada = STAGE_DOCENCIA_POST_TEST.matricula_anulada,  
        assignatura_anulada = STAGE_DOCENCIA_POST_TEST.assignatura_anulada,  
        assignatura_convalidada = STAGE_DOCENCIA_POST_TEST.assignatura_convalidada,  
        edat_relativa = STAGE_DOCENCIA_POST_TEST.edat_relativa,  
        grup_edat = STAGE_DOCENCIA_POST_TEST.grup_edat,  
        grup_edat_2 = STAGE_DOCENCIA_POST_TEST.grup_edat_2,  
        update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)  
    WHEN NOT MATCHED THEN
    INSERT
        (id_docencia,  
        id_semestre,  
        id_assignatura,  
        id_qualificacio,  
        id_qualificacio_continuada,  
        id_expedient,  
        id_matricula,  
        id_portafoli_pa,  
        id_persona_estudiant,  
        id_pais_nacionalitat,  
        id_pais_naixement,  
        id_pais_residencia,  
        id_acces,  
        id_persona_tutor,  
        nota_mitjana,  
        nota_mitjana_punts,  
        assignatura_cursada,  
        num_credits,  
        num_credits_teorics,  
        num_credits_practics,  
        semestre_relatiu_expedient,  
        semestre_relatiu_super_expedient,  
        semestre_relatiu_uoc,  
        num_matriculas_assignatura,  
        qualif_num_cont,  
        qualif_num_cont_final,  
        qualif_numerica,  
        qualif_numerica_pub,  
        qualif_num_practica,  
        qualif_num_pres,  
        qualif_num_prop,  
        qualif_num_teorica,  
        --dim_qualificacio_continuada_key,  
        --cod_qualif_cont,  
        --dim_qualificacio_key,  
        supera_assignatura,  
        no_supera_assignatura,  
        matricula_anulada,  
        assignatura_anulada,  
        assignatura_convalidada,  
        edat_relativa,  
        grup_edat,  
        grup_edat_2,  
        creation_date,  
        update_date  
        )
    values
        (STAGE_DOCENCIA_POST_TEST.id_docencia,  
        STAGE_DOCENCIA_POST_TEST.id_semestre,  
        STAGE_DOCENCIA_POST_TEST.id_assignatura,  
        STAGE_DOCENCIA_POST_TEST.id_qualificacio,  
        STAGE_DOCENCIA_POST_TEST.id_qualificacio_continuada,  
        STAGE_DOCENCIA_POST_TEST.id_expedient,  
        STAGE_DOCENCIA_POST_TEST.id_matricula,  
        STAGE_DOCENCIA_POST_TEST.id_portafoli_pa,  
        STAGE_DOCENCIA_POST_TEST.id_persona_estudiant,  
        STAGE_DOCENCIA_POST_TEST.id_pais_nacionalitat,  
        STAGE_DOCENCIA_POST_TEST.id_pais_naixement,  
        STAGE_DOCENCIA_POST_TEST.id_pais_residencia,  
        STAGE_DOCENCIA_POST_TEST.id_acces,  
        STAGE_DOCENCIA_POST_TEST.id_persona_tutor,  
        STAGE_DOCENCIA_POST_TEST.nota_mitjana,  
        STAGE_DOCENCIA_POST_TEST.nota_mitjana_punts,  
        STAGE_DOCENCIA_POST_TEST.assignatura_cursada,  
        STAGE_DOCENCIA_POST_TEST.num_credits,  
        STAGE_DOCENCIA_POST_TEST.num_credits_teorics,  
        STAGE_DOCENCIA_POST_TEST.num_credits_practics,  
        STAGE_DOCENCIA_POST_TEST.semestre_relatiu_expedient,  
        STAGE_DOCENCIA_POST_TEST.semestre_relatiu_super_expedient,  
        STAGE_DOCENCIA_POST_TEST.semestre_relatiu_uoc,  
        STAGE_DOCENCIA_POST_TEST.num_matriculas_assignatura,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_cont,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_cont_final,  
        STAGE_DOCENCIA_POST_TEST.qualif_numerica,  
        STAGE_DOCENCIA_POST_TEST.qualif_numerica_pub,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_practica,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_pres,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_prop,  
        STAGE_DOCENCIA_POST_TEST.qualif_num_teorica,  
        --STAGE_DOCENCIA_POST_TEST.dim_qualificacio_continuada_key,  
        --STAGE_DOCENCIA_POST_TEST.cod_qualif_cont,  
        --STAGE_DOCENCIA_POST_TEST.dim_qualificacio_key,  
        STAGE_DOCENCIA_POST_TEST.supera_assignatura,  
        STAGE_DOCENCIA_POST_TEST.no_supera_assignatura,  
        STAGE_DOCENCIA_POST_TEST.matricula_anulada,  
        STAGE_DOCENCIA_POST_TEST.assignatura_anulada,  
        STAGE_DOCENCIA_POST_TEST.assignatura_convalidada,  
        STAGE_DOCENCIA_POST_TEST.edat_relativa,  
        STAGE_DOCENCIA_POST_TEST.grup_edat,  
        STAGE_DOCENCIA_POST_TEST.grup_edat_2,  
        CONVERT_TIMEZONE(''America/Los_Angeles'',''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ), 
        CONVERT_TIMEZONE(''America/Los_Angeles'',''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ) 
        )
;

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''full_docencia_data_load'', current_user(), :start_time, :execution_time, ''full_docencia_data_load Success'');
    
return ''Update completed successfully'';

end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: STAGE_DOCENCIA  -- ES NECESSITEN 2 PROCEDURES */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE DB_UOC_PROD.DD_OD.STAGE_DOCENCIA_NO_CONVALIDADAS_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;


merge into
    db_uoc_prod.dd_od.stage_docencia_TEST
using
(
select 
gat_expedientes.num_expediente,
dim_expedient.super_expedient_v1 as super_expedient,
gat_exp_matriculas.num_matricula,
gat_expedientes.idp,
tercers_paisos_nacionalitat.desc_nacionalidad as nacionalitat,
tercers_paisos_naixement.descripcion as pais_naixement,
tercers_paisos_residencia.descripcion as pais_residencia,
tercers_direcciones.cod_postal as codi_postal,
tercers_direcciones.ind_localizacion as ind_localitzacio,
gat_expedientes.cod_plan,
gat_plan_datos.ind_titulaciones_propias as titulacio_propia, --CP_dim_acces
gat_estudios.tipo_docencia_detalle as tipus_docencia, -- CP_dim_acces
pac.via_acces as via_acces, -- CP dim_acces
pac.descripcion as opcio_acces, --CP dim_acces
tutor_unic_periode_hist.idp_tutor,
tutor_unic_periode_hist.tipo_tutor,
gat_expedientes.num_sol_acc,
gat_expedientes.nota_media,
gat_expedientes.nota_media_puntos,
gat_expedientes.any_acad_titulo,
gat_exp_matriculas.any_academico,
gat_exp_matriculas.any_acad_valida,
gat_exp_asig_matriculas.cod_asignatura,
1 as assignatura_cursada,
gat_asignaturas.num_creditos,
gat_asignaturas.num_creditos_teoricos,
gat_asignaturas.num_creditos_practicos,
gat_exp_asig_matriculas.asigna_clase,
gat_exp_asig_matriculas.cod_aula,
gat_exp_asig_matriculas.cod_tfc,
gat_exp_asig_matriculas.ind_solo_examen,
gat_exp_asig_calificaciones.calif_num_cont,
gat_exp_asig_calificaciones.calif_num_cont_final,
gat_exp_asig_calificaciones.calif_numerica,
gat_exp_asig_calificaciones.calif_numerica_pub,
gat_exp_asig_calificaciones.calif_num_practica,
gat_exp_asig_calificaciones.calif_num_pres,
gat_exp_asig_calificaciones.calif_num_prop,
gat_exp_asig_calificaciones.calif_num_teorica,
gat_exp_asig_calificaciones.calif_practica,
gat_exp_asig_calificaciones.calif_teorica,
gat_exp_asig_calificaciones.cod_calif_conf,
gat_exp_asig_calificaciones.cod_calif_cont,
gat_exp_asig_calificaciones.cod_calif_cont_final,
gat_exp_asig_calificaciones.cod_calificacion,
gat_calificaciones.ind_supera,
gat_exp_asig_calificaciones.cod_calificacion_pub,
gat_exp_asig_calificaciones.cod_calif_pres,
gat_exp_asig_calificaciones.cod_calif_prop,
gat_exp_asig_calificaciones.cod_examen,
gat_exp_asig_calificaciones.idp_corrector,
iff(to_number(ifnull(to_char(gat_exp_matriculas.fecha_anulacion,''yyyymmdd''::string),0))=0,0,1) as matricula_anulada,
iff(to_number(ifnull(to_char(gat_exp_asig_matriculas.fecha_anulacion,''yyyymmdd''::string),0))=0,0,1) as assignatura_anulada,
0 as assignatura_convalidada,
0 as sec_solicitud,
0 as num_reconocimiento,
tercers_datos_personas.fecha_nacim
from
db_uoc_prod.DD_OD.gat_expedientes_TEST
inner join db_uoc_prod.DD_OD.gat_exp_matriculas_TEST
on gat_expedientes.num_expediente = gat_exp_matriculas.num_expediente
inner join db_uoc_prod.DD_OD.gat_exp_asig_matriculas_TEST -- Al hacer un INNER estamos dejando fuera las matriculas de los estudiantes que convalidan. Cuando queramos incorporarlos necesitaremos hacer un left
on gat_exp_matriculas.num_expediente = gat_exp_asig_matriculas.num_expediente
and gat_exp_matriculas.any_academico = gat_exp_asig_matriculas.any_academico
left outer join db_uoc_prod.DD_OD.gat_exp_asig_calificaciones_TEST
on gat_exp_asig_matriculas.num_expediente = gat_exp_asig_calificaciones.num_expediente
and gat_exp_asig_matriculas.any_academico = gat_exp_asig_calificaciones.any_academico
and gat_exp_asig_matriculas.cod_asignatura = gat_exp_asig_calificaciones.cod_asignatura
left outer join db_uoc_prod.DD_OD.gat_calificaciones_TEST
on gat_exp_asig_calificaciones.cod_calificacion = db_uoc_prod.DD_OD.gat_calificaciones.cod_calificacion
left outer join db_uoc_prod.DD_OD.gat_asignaturas_TEST
on db_uoc_prod.DD_OD.gat_exp_asig_calificaciones.cod_asignatura = db_uoc_prod.DD_OD.gat_asignaturas.cod_asignatura
left outer join db_uoc_prod.DD_OD.tercers_datos_personas_TEST
on db_uoc_prod.DD_OD.gat_expedientes.idp = db_uoc_prod.DD_OD.tercers_datos_personas.idp
left join db_uoc_prod.DD_OD.tercers_paises_TEST as tercers_paisos_nacionalitat -- son left no iners
on db_uoc_prod.DD_OD.tercers_datos_personas.cod_pais_nacion = tercers_paisos_nacionalitat.cod_pais
left join db_uoc_prod.DD_OD.tercers_paises_TEST as tercers_paisos_naixement -- son left no iners / codigo añadido por mi
on db_uoc_prod.DD_OD.tercers_datos_personas.cod_pais_nacim = tercers_paisos_naixement.cod_pais
left join db_uoc_prod.DD_OD.tercers_ref_direcciones_TEST 
on gat_expedientes.idp = tercers_ref_direcciones.cod_elemento
left join db_uoc_prod.DD_OD.tercers_direcciones_TEST
on tercers_ref_direcciones.num_direccion = tercers_direcciones.num_direccion
left join db_uoc_prod.DD_OD.tercers_paises as tercers_paisos_residencia_TEST
on tercers_direcciones.cod_pais = tercers_paisos_residencia.cod_pais
left join DD_OD.gat_plan_datos_TEST
on gat_expedientes.cod_plan = gat_plan_datos.cod_plan
left join DD_OD.gat_estudios_TEST 
on gat_plan_datos.cod_estudios = gat_estudios.cod_estudios
left join DD_OD.gat_cab_solicitud_acc_TEST
on gat_expedientes.num_expediente = gat_cab_solicitud_acc.num_expediente and gat_cab_solicitud_acc.num_expediente  not in (505356, 520316) -- esos dos expedientes tienen 2 accesos y eso hace multiplicar los registros, se deberia corregir en origen.
left join (SELECT distinct pa.cod_opc_Acc, pa.DESCRIPCION ,pa.COD_PLAN,pa.COD_CENTRO, va.DESCRIPCION AS Via_acces 
                        FROM DD_OD.gat_plan_accesos_TEST pa
                        inner JOIN DD_OD.gat_vias_acc_TEST va ON pa.cod_via_acc = va.cod_via_acc
            ) pac -- desc vias i desc opciones acceso
on pac.cod_opc_Acc = gat_cab_solicitud_acc.cod_opc_acc AND pac.COD_CENTRO = gat_cab_solicitud_acc.COD_CENTRO AND pac.COD_PLAN = gat_cab_solicitud_acc.COD_PLAN
left join dim_expedient_TEST 
on gat_expedientes.num_expediente = dim_expedient.dim_expedient_key
left join db_uoc_prod.dd_od.tutor_unic_periode_hist_TEST
on gat_expedientes.num_expediente = tutor_unic_periode_hist.num_expedient and
   (gat_exp_matriculas.any_academico >= any_acad_alta and (gat_exp_matriculas.any_academico < any_acad_baja or any_acad_baja is null))
) as load_docencia
on stage_docencia_TEST.num_expedient = load_docencia.num_expediente
and STAGE_DOCENCIA_TEST.idp =  load_docencia.idp
and STAGE_DOCENCIA_TEST.cod_pla = load_docencia.cod_plan
and STAGE_DOCENCIA_TEST.any_academic = ifnull(load_docencia.any_academico,''19000'')
and STAGE_DOCENCIA_TEST.cod_assignatura = ifnull(load_docencia.cod_asignatura,''00.000'')
and STAGE_DOCENCIA_TEST.num_reconeixement = ifnull(load_docencia.num_reconocimiento,0)
and STAGE_DOCENCIA_TEST.sec_solicitud = ifnull(load_docencia.sec_solicitud,0)
when matched then

    update set
        num_expedient = load_docencia.num_expediente, super_expedient = load_docencia.super_expedient, num_matricula = load_docencia.num_matricula, idp = load_docencia.idp, nacionalitat = load_docencia.nacionalitat, pais_naixement = load_docencia.pais_naixement, pais_residencia = load_docencia.pais_residencia, codi_postal = load_docencia.codi_postal, ind_localitzacio = load_docencia.ind_localitzacio, cod_pla = load_docencia.cod_plan, titulacio_propia = load_docencia.titulacio_propia, tipus_docencia = load_docencia.tipus_docencia, via_acces= load_docencia.via_acces, opcio_acces =load_docencia.opcio_acces,  idp_tutor = load_docencia.idp_tutor, tipus_tutor = load_docencia.tipo_tutor, num_sol_acc = load_docencia.num_sol_acc, nota_mitjana = load_docencia.nota_media, nota_mitjana_punts = load_docencia.nota_media_puntos, any_acad_titol = load_docencia.any_acad_titulo, any_academic = ifnull(load_docencia.any_academico,''19000''), any_acad_valida = load_docencia.any_acad_valida, cod_assignatura = ifnull(load_docencia.cod_asignatura,''00.000''), assignatura_cursada = load_docencia.assignatura_cursada, num_credits = load_docencia.num_creditos, num_credits_teorics = load_docencia.num_creditos_teoricos, num_credits_practics = load_docencia.num_creditos_practicos, assigna_clase = load_docencia.asigna_clase, cod_aula = load_docencia.cod_aula, cod_tfc = load_docencia.cod_tfc, ind_sols_examen = load_docencia.ind_solo_examen, qualif_num_cont = load_docencia.calif_num_cont, qualif_num_cont_final = load_docencia.calif_num_cont_final, qualif_numerica = load_docencia.calif_numerica, qualif_numerica_pub = load_docencia.calif_numerica_pub, qualif_num_practica = load_docencia.calif_num_practica, qualif_num_pres = load_docencia.calif_num_pres, qualif_num_prop = load_docencia.calif_num_prop, qualif_num_teorica = load_docencia.calif_num_teorica, qualif_practica = load_docencia.calif_practica, qualif_teorica = load_docencia.calif_teorica, cod_qualif_conf = load_docencia.cod_calif_conf, cod_qualif_cont = load_docencia.cod_calif_cont, cod_qualif_cont_final = load_docencia.cod_calif_cont_final, cod_qualificacio = load_docencia.cod_calificacion, ind_supera = load_docencia.ind_supera, cod_qualificacio_pub = load_docencia.cod_calificacion_pub, cod_qualif_pres = load_docencia.cod_calif_pres, cod_qualif_prop = load_docencia.cod_calif_prop, cod_examen = load_docencia.cod_examen, idp_corrector = load_docencia.idp_corrector, matricula_anulada = load_docencia.matricula_anulada, assignatura_anulada = load_docencia.assignatura_anulada, assignatura_convalidada = load_docencia.assignatura_convalidada, sec_solicitud = load_docencia.sec_solicitud, num_reconeixement = load_docencia.num_reconocimiento, data_naixement = load_docencia.fecha_nacim, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
    insert
        (
        id_docencia,
    	num_expedient,
        super_expedient,
        num_matricula,
    	idp,
        nacionalitat,
        pais_naixement,
        pais_residencia,
        codi_postal,
        ind_localitzacio,
    	cod_pla,
        titulacio_propia, 
        tipus_docencia, 
        via_acces, 
        opcio_acces,
    	idp_tutor,
        tipus_tutor,
    	num_sol_acc,
    	nota_mitjana,
    	nota_mitjana_punts,
    	any_acad_titol,
    	any_academic,
    	any_acad_valida,
    	cod_assignatura,
        assignatura_cursada,
        num_credits,
        num_credits_teorics,
        num_credits_practics,
    	assigna_clase,
    	cod_aula,
    	cod_tfc,
    	ind_sols_examen,
    	qualif_num_cont,
    	qualif_num_cont_final,
    	qualif_numerica,
    	qualif_numerica_pub,
    	qualif_num_practica,
    	qualif_num_pres,
    	qualif_num_prop,
    	qualif_num_teorica,
    	qualif_practica,
    	qualif_teorica,
    	cod_qualif_conf,
    	cod_qualif_cont,
    	cod_qualif_cont_final,
    	cod_qualificacio,
        ind_supera,
    	cod_qualificacio_pub,
    	cod_qualif_pres,
    	cod_qualif_prop,
    	cod_examen,
    	idp_corrector,
        matricula_anulada,
        assignatura_anulada,
        assignatura_convalidada,
        sec_solicitud,
        num_reconeixement,
        data_naixement,
    	creation_date,
    	update_date
        )
    values
        (
        db_uoc_prod.dd_od.sequencia_id_stage_docencia.nextval,
        load_docencia.num_expediente,
        load_docencia.super_expedient,
        load_docencia.num_matricula,
        load_docencia.idp,
        load_docencia.nacionalitat,
        load_docencia.pais_naixement,
        load_docencia.pais_residencia,
        load_docencia.codi_postal,
        load_docencia.ind_localitzacio,
        load_docencia.cod_plan,
        load_docencia.titulacio_propia, 
        load_docencia.tipus_docencia, 
        load_docencia.via_acces, 
        load_docencia.opcio_acces,
        load_docencia.idp_tutor,
        load_docencia.tipo_tutor,
        load_docencia.num_sol_acc,
        load_docencia.nota_media,
        load_docencia.nota_media_puntos,
        load_docencia.any_acad_titulo,
        ifnull(load_docencia.any_academico,''19000''),
        load_docencia.any_acad_valida,
        ifnull(load_docencia.cod_asignatura,''00.000''),
        load_docencia.assignatura_cursada,
        load_docencia.num_creditos,
        load_docencia.num_creditos_teoricos,
        load_docencia.num_creditos_practicos,
        load_docencia.asigna_clase,
        load_docencia.cod_aula,
        load_docencia.cod_tfc,
        load_docencia.ind_solo_examen,
        load_docencia.calif_num_cont,
        load_docencia.calif_num_cont_final,
        load_docencia.calif_numerica,
        load_docencia.calif_numerica_pub,
        load_docencia.calif_num_practica,
        load_docencia.calif_num_pres,
        load_docencia.calif_num_prop,
        load_docencia.calif_num_teorica,
        load_docencia.calif_practica,
        load_docencia.calif_teorica,
        load_docencia.cod_calif_conf,
        load_docencia.cod_calif_cont,
        load_docencia.cod_calif_cont_final,
        load_docencia.cod_calificacion,
        load_docencia.ind_supera,
        load_docencia.cod_calificacion_pub,
        load_docencia.cod_calif_pres,
        load_docencia.cod_calif_prop,
        load_docencia.cod_examen,
        load_docencia.idp_corrector,
        load_docencia.matricula_anulada,
        load_docencia.assignatura_anulada,
        load_docencia.assignatura_convalidada,
        load_docencia.sec_solicitud,
        load_docencia.num_reconocimiento,
        load_docencia.fecha_nacim,
        convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz),
        convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
        )
;

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''stage_docencia_no_convalidadas_loads'', CURRENT_USER(), :start_time, :execution_time, ''stage_docencia Success'');
    
return ''Update completed successfully'';

end';

CREATE  PROCEDURE DB_UOC_PROD.DD_OD.STAGE_DOCENCIA_CONVALIDADAS_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;




merge into
    db_uoc_prod.dd_od.stage_docencia_TEST
using
(
select 
GAT_EXPEDIENTES_TEST.num_expediente,
dim_expedient_TEST.super_expedient_v1 as super_expedient,
GAT_EXP_MATRICULAS_TEST.num_matricula,
GAT_EXPEDIENTES_TEST.idp,
tercers_paisos_nacionalitat.desc_nacionalidad as nacionalitat,
tercers_paisos_naixement.descripcion as pais_naixement,
tercers_paisos_residencia.descripcion as pais_residencia,
TERCERS_DIRECCIONES_TEST.cod_postal as codi_postal,
TERCERS_DIRECCIONES_TEST.ind_localizacion as ind_localitzacio,
GAT_EXPEDIENTES_TEST.cod_plan,
GAT_PLAN_DATOS_TEST.ind_titulaciones_propias as titulacio_propia,
GAT_ESTUDIOS_TEST.tipo_docencia_detalle as tipus_docencia, 
pac.via_acces as via_acces, 
pac.descripcion as opcio_acces, 
tutor_unic_periode_hist_TEST.idp_tutor,
tutor_unic_periode_hist_TEST.tipo_tutor,
GAT_EXPEDIENTES_TEST.num_sol_acc,
GAT_EXPEDIENTES_TEST.nota_media,
GAT_EXPEDIENTES_TEST.nota_media_puntos,
GAT_EXPEDIENTES_TEST.any_acad_titulo,
GAT_EXP_MATRICULAS_TEST.any_academico,
GAT_EXP_MATRICULAS_TEST.any_acad_valida,
assignatura_convalidada.cod_elemento_dest as cod_asignatura,  
1 as assignatura_cursada, -- y las convalidadas que?
assignatura_convalidada.num_creditos,
assignatura_convalidada.num_creditos_teoricos, 
assignatura_convalidada.num_creditos_practicos, 
assignatura_convalidada.asigna_clase, 
null as cod_aula, 
assignatura_convalidada.cod_tfc, 
null as ind_solo_examen,
null as calif_num_cont, 
null as calif_num_cont_final, 
assignatura_convalidada.calif_numerica as calif_numerica,
assignatura_convalidada.calif_numerica as calif_numerica_pub, 
null as calif_num_practica, 
null as calif_num_pres,
null as calif_num_prop, 
null as calif_num_teorica, 
null as calif_practica, 
null as calif_teorica,
null as cod_calif_conf,
null as cod_calif_cont,
null as cod_calif_cont_final, 
assignatura_convalidada.cod_calificacion, 
assignatura_convalidada.ind_supera,
assignatura_convalidada.cod_calificacion as cod_calificacion_pub ,-- 2 GAT_EXP_ASIG_CALIFICACIONES_TEST.cod_calificacion_pub,
null as cod_calif_pres,
null as cod_calif_prop,
null as cod_examen, 
null as idp_corrector,
iff(to_number(ifnull(to_char(GAT_EXP_MATRICULAS_TEST.fecha_anulacion,''yyyymmdd''::string),0))=0,0,1) as matricula_anulada,
iff(to_number(ifnull(to_char(assignatura_convalidada.fecha_anulacion,''yyyymmdd''::string),0))=0,0,1) as assignatura_anulada, -- 1 
1 as assignatura_convalidada,
assignatura_convalidada.sec_solicitud,
assignatura_convalidada.num_reconocimiento,
TERCERS_DATOS_PERSONAS_TEST.fecha_nacim
from
db_uoc_prod.DD_OD.GAT_EXPEDIENTES_TEST
inner join db_uoc_prod.DD_OD.gat_exp_matriculas_TEST -- num matricula null son expedientes que no matriculan
on gat_expedientes_TEST.num_expediente = gat_exp_matriculas_TEST.num_expediente
inner join (select 
            aep_aep_reconocimientos_TEST.sec_solicitud,
            aep_aep_solicitudes_TEST.num_expediente,
            aep_aep_reconocimientos_TEST.any_academico,
            aep_aep_reconocimientos_TEST.cod_elemento_dest,
            aep_aep_reconocimientos_TEST.cod_tfc,
            aep_aep_reconocimientos_TEST.asigna_clase,
            aep_aep_reconocimientos_TEST.num_creditos,
            aep_aep_reconocimientos_TEST.cod_calificacion,
            aep_aep_reconocimientos_TEST.calif_numerica,
            GAT_CALIFICACIONES_TEST.ind_supera,
            aep_aep_reconocimientos_TEST.fecha_anulacion,
            GAT_ASIGNATURAS_TEST.num_creditos_teoricos,
            GAT_ASIGNATURAS_TEST.num_creditos_practicos,
            aep_aep_reconocimientos_TEST.num_reconocimiento
          from db_uoc_prod.DD_OD.aep_aep_reconocimientos_TEST
          inner join db_uoc_prod.DD_OD.aep_aep_solicitudes_TEST
          on aep_aep_reconocimientos_TEST.sec_solicitud = aep_aep_solicitudes_TEST.sec_solicitud
          left join db_uoc_prod.DD_OD.GAT_CALIFICACIONES_TEST
          on aep_aep_reconocimientos_TEST.cod_calificacion =  GAT_CALIFICACIONES_TEST.cod_calificacion
          left join db_uoc_prod.DD_OD.GAT_ASIGNATURAS_TEST
          on aep_aep_reconocimientos_TEST.cod_elemento_dest = GAT_ASIGNATURAS_TEST.cod_asignatura
          where aep_aep_reconocimientos_TEST.estado = ''A'' and -- solicitudes aceptadas
                aep_aep_reconocimientos_TEST.any_academico is not null AND -- Matriculadas
                aep_aep_reconocimientos_TEST.any_acad_valida is null ) as assignatura_convalidada -- y que no provienen de adaptacion o cambio campus
on GAT_EXPEDIENTES_TEST.num_expediente = assignatura_convalidada.num_expediente 
and GAT_EXP_MATRICULAS_TEST.any_academico = assignatura_convalidada.any_academico
left outer join db_uoc_prod.DD_OD.TERCERS_DATOS_PERSONAS_TEST
on db_uoc_prod.DD_OD.GAT_EXPEDIENTES_TEST.idp = db_uoc_prod.DD_OD.TERCERS_DATOS_PERSONAS_TEST.idp
left join db_uoc_prod.DD_OD.TERCERS_PAISES_TEST as tercers_paisos_nacionalitat -- son left no iners
on db_uoc_prod.DD_OD.TERCERS_DATOS_PERSONAS_TEST.cod_pais_nacion = tercers_paisos_nacionalitat.cod_pais
left join db_uoc_prod.DD_OD.TERCERS_PAISES_TEST as tercers_paisos_naixement -- son left no iners / codigo añadido por mi
on db_uoc_prod.DD_OD.TERCERS_DATOS_PERSONAS_TEST.cod_pais_nacim = tercers_paisos_naixement.cod_pais
left join db_uoc_prod.DD_OD.TERCERS_REF_DIRECCIONES_TEST 
on GAT_EXPEDIENTES_TEST.idp = TERCERS_REF_DIRECCIONES_TEST.cod_elemento
left join db_uoc_prod.DD_OD.TERCERS_DIRECCIONES_TEST
on TERCERS_REF_DIRECCIONES_TEST.num_direccion = TERCERS_DIRECCIONES_TEST.num_direccion
left join db_uoc_prod.DD_OD.TERCERS_PAISES_TEST as tercers_paisos_residencia
on TERCERS_DIRECCIONES_TEST.cod_pais = tercers_paisos_residencia.cod_pais
left join DD_OD.GAT_PLAN_DATOS_TEST
on GAT_EXPEDIENTES_TEST.cod_plan = GAT_PLAN_DATOS_TEST.cod_plan
left join DD_OD.GAT_ESTUDIOS_TEST 
on GAT_PLAN_DATOS_TEST.cod_estudios = GAT_ESTUDIOS_TEST.cod_estudios
left join DD_OD.GAT_CAB_SOLICITUD_ACC_TEST
on GAT_EXPEDIENTES_TEST.num_expediente = GAT_CAB_SOLICITUD_ACC_TEST.num_expediente 
and GAT_CAB_SOLICITUD_ACC_TEST.num_expediente  not in (505356, 520316) --  tienen 2 accesos y  multiplicar los registros, corregir en origen.
left join (SELECT distinct pa.cod_opc_Acc, pa.DESCRIPCION ,pa.COD_PLAN,pa.COD_CENTRO, va.DESCRIPCION AS Via_acces 
                        FROM DD_OD.GAT_PLAN_ACCESOS_TEST pa
                        inner JOIN DD_OD.GAT_VIAS_ACC_TEST va ON pa.cod_via_acc = va.cod_via_acc
            ) pac -- desc vias i desc opciones acceso
on pac.cod_opc_Acc = GAT_CAB_SOLICITUD_ACC_TEST.cod_opc_acc AND pac.COD_CENTRO = GAT_CAB_SOLICITUD_ACC_TEST.COD_CENTRO AND pac.COD_PLAN = gat_cab_solicitud_acc.COD_PLAN
left join dim_expedient_TEST 
on GAT_EXPEDIENTES_TEST.num_expediente = dim_expedient_TEST.dim_expedient_key
left join db_uoc_prod.dd_od.tutor_unic_periode_hist_TEST
on GAT_EXPEDIENTES_TEST.num_expediente = tutor_unic_periode_hist_TEST.num_expedient and
   (GAT_EXP_MATRICULAS_TEST.any_academico >= any_acad_alta and (GAT_EXP_MATRICULAS_TEST.any_academico < any_acad_baja or any_acad_baja is null))
) as  load_docencia
on stage_docencia_TEST.num_expedient = load_docencia.num_expediente
and stage_docencia_TEST.idp =  load_docencia.idp
and stage_docencia_TEST.cod_pla = load_docencia.cod_plan
and stage_docencia_TEST.any_academic = ifnull(load_docencia.any_academico,''19000'')
and stage_docencia_TEST.cod_assignatura = ifnull(load_docencia.cod_asignatura,''00.000'') 
and stage_docencia_TEST.num_reconeixement = ifnull(load_docencia.num_reconocimiento,0)
and stage_docencia_TEST.sec_solicitud = ifnull(load_docencia.sec_solicitud,0)-- no faltaria el aula?
when matched then
        update set
        num_expedient = load_docencia.num_expediente, super_expedient = load_docencia.super_expedient, num_matricula = load_docencia.num_matricula, idp = load_docencia.idp, nacionalitat = load_docencia.nacionalitat, pais_naixement = load_docencia.pais_naixement, pais_residencia = load_docencia.pais_residencia, codi_postal = load_docencia.codi_postal, ind_localitzacio = load_docencia.ind_localitzacio, cod_pla = load_docencia.cod_plan, titulacio_propia = load_docencia.titulacio_propia, tipus_docencia = load_docencia.tipus_docencia, via_acces= load_docencia.via_acces, opcio_acces =load_docencia.opcio_acces,  idp_tutor = load_docencia.idp_tutor, tipus_tutor = load_docencia.tipo_tutor, num_sol_acc = load_docencia.num_sol_acc, nota_mitjana = load_docencia.nota_media, nota_mitjana_punts = load_docencia.nota_media_puntos, any_acad_titol = load_docencia.any_acad_titulo, any_academic = ifnull(load_docencia.any_academico,''19000''), any_acad_valida = load_docencia.any_acad_valida, cod_assignatura = ifnull(load_docencia.cod_asignatura,''00.000''), assignatura_cursada = load_docencia.assignatura_cursada, num_credits = load_docencia.num_creditos, num_credits_teorics = load_docencia.num_creditos_teoricos, num_credits_practics = load_docencia.num_creditos_practicos, assigna_clase = load_docencia.asigna_clase, cod_aula = load_docencia.cod_aula, cod_tfc = load_docencia.cod_tfc, ind_sols_examen = load_docencia.ind_solo_examen, qualif_num_cont = load_docencia.calif_num_cont, qualif_num_cont_final = load_docencia.calif_num_cont_final, qualif_numerica = load_docencia.calif_numerica, qualif_numerica_pub = load_docencia.calif_numerica_pub, qualif_num_practica = load_docencia.calif_num_practica, qualif_num_pres = load_docencia.calif_num_pres, qualif_num_prop = load_docencia.calif_num_prop, qualif_num_teorica = load_docencia.calif_num_teorica, qualif_practica = load_docencia.calif_practica, qualif_teorica = load_docencia.calif_teorica, cod_qualif_conf = load_docencia.cod_calif_conf, cod_qualif_cont = load_docencia.cod_calif_cont, cod_qualif_cont_final = load_docencia.cod_calif_cont_final, cod_qualificacio = load_docencia.cod_calificacion, ind_supera = load_docencia.ind_supera, cod_qualificacio_pub = load_docencia.cod_calificacion_pub, cod_qualif_pres = load_docencia.cod_calif_pres, cod_qualif_prop = load_docencia.cod_calif_prop, cod_examen = load_docencia.cod_examen, idp_corrector = load_docencia.idp_corrector, matricula_anulada = load_docencia.matricula_anulada, assignatura_anulada = load_docencia.assignatura_anulada, assignatura_convalidada = load_docencia.assignatura_convalidada, sec_solicitud = load_docencia.sec_solicitud, num_reconeixement = load_docencia.num_reconocimiento, data_naixement = load_docencia.fecha_nacim, update_date = convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
when not matched then
    insert
        (
        id_docencia,
    	num_expedient,
        super_expedient,
        num_matricula,
    	idp,
        nacionalitat,
        pais_naixement,
        pais_residencia,
        codi_postal,
        ind_localitzacio,
    	cod_pla,
        titulacio_propia, 
        tipus_docencia, 
        via_acces, 
        opcio_acces,
    	idp_tutor,
        tipus_tutor,
    	num_sol_acc,
    	nota_mitjana,
    	nota_mitjana_punts,
    	any_acad_titol,
    	any_academic,
    	any_acad_valida,
    	cod_assignatura,
        assignatura_cursada,
        num_credits,
        num_credits_teorics,
        num_credits_practics,
    	assigna_clase,
    	cod_aula,
    	cod_tfc,
    	ind_sols_examen,
    	qualif_num_cont,
    	qualif_num_cont_final,
    	qualif_numerica,
    	qualif_numerica_pub,
    	qualif_num_practica,
    	qualif_num_pres,
    	qualif_num_prop,
    	qualif_num_teorica,
    	qualif_practica,
    	qualif_teorica,
    	cod_qualif_conf,
    	cod_qualif_cont,
    	cod_qualif_cont_final,
    	cod_qualificacio,
        ind_supera,
    	cod_qualificacio_pub,
    	cod_qualif_pres,
    	cod_qualif_prop,
    	cod_examen,
    	idp_corrector,
        matricula_anulada,
        assignatura_anulada,
        assignatura_convalidada,
        sec_solicitud,
        num_reconeixement,
        data_naixement,
    	creation_date,
    	update_date
        )
    values
        (
        db_uoc_prod.dd_od.sequencia_id_stage_docencia.nextval,
        load_docencia.num_expediente,
        load_docencia.super_expedient,
        load_docencia.num_matricula,
        load_docencia.idp,
        load_docencia.nacionalitat,
        load_docencia.pais_naixement,
        load_docencia.pais_residencia,
        load_docencia.codi_postal,
        load_docencia.ind_localitzacio,
        load_docencia.cod_plan,
        load_docencia.titulacio_propia, 
        load_docencia.tipus_docencia, 
        load_docencia.via_acces, 
        load_docencia.opcio_acces,
        load_docencia.idp_tutor,
        load_docencia.tipo_tutor,
        load_docencia.num_sol_acc,
        load_docencia.nota_media,
        load_docencia.nota_media_puntos,
        load_docencia.any_acad_titulo,
        ifnull(load_docencia.any_academico,''19000''),
        load_docencia.any_acad_valida,
        ifnull(load_docencia.cod_asignatura,''00.000''),
        load_docencia.assignatura_cursada,
        load_docencia.num_creditos,
        load_docencia.num_creditos_teoricos,
        load_docencia.num_creditos_practicos,
        load_docencia.asigna_clase,
        load_docencia.cod_aula,
        load_docencia.cod_tfc,
        load_docencia.ind_solo_examen,
        load_docencia.calif_num_cont,
        load_docencia.calif_num_cont_final,
        load_docencia.calif_numerica,
        load_docencia.calif_numerica_pub,
        load_docencia.calif_num_practica,
        load_docencia.calif_num_pres,
        load_docencia.calif_num_prop,
        load_docencia.calif_num_teorica,
        load_docencia.calif_practica,
        load_docencia.calif_teorica,
        load_docencia.cod_calif_conf,
        load_docencia.cod_calif_cont,
        load_docencia.cod_calif_cont_final,
        load_docencia.cod_calificacion,
        load_docencia.ind_supera,
        load_docencia.cod_calificacion_pub,
        load_docencia.cod_calif_pres,
        load_docencia.cod_calif_prop,
        load_docencia.cod_examen,
        load_docencia.idp_corrector,
        load_docencia.matricula_anulada,
        load_docencia.assignatura_anulada,
        load_docencia.assignatura_convalidada,
        load_docencia.sec_solicitud,
        load_docencia.num_reconocimiento,
        load_docencia.fecha_nacim,
        convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz),
        convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz)
        )

;

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''stage_docencia_convalidadas_loads'', CURRENT_USER(), :start_time, :execution_time, ''stage_docencia Success'');
    
return ''Update completed successfully'';


end';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: tutor_unic_periode_hist  */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DD_OD.TUTOR_UNIC_PERIODE_HIST_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'DECLARE
    start_time TIMESTAMP_NTZ := CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ);
    execution_time FLOAT;
BEGIN

MERGE INTO db_uoc_prod.dd_od.tutor_unic_periode_hist_TEST AS dest
USING (
    WITH base_tutors_unics_periode AS ( 
        SELECT num_expediente, any_acad_alta,
               CASE 
                   WHEN EXISTS (SELECT 1 
                                FROM db_uoc_prod.DD_OD.gat_estud_tutor_hist_TEST 
                                WHERE num_expediente = t.num_expediente 
                                AND any_acad_alta = t.any_acad_alta 
                                AND any_acad_baja IS NULL) THEN NULL
                   ELSE MAX(any_acad_baja)  
               END AS any_acad_baja
        FROM db_uoc_prod.DD_OD.gat_estud_tutor_hist_TEST AS t
        WHERE (any_acad_alta <= any_acad_baja OR any_acad_baja IS NULL) and idp_tutor <> 1
        GROUP BY num_expediente, any_acad_alta

/*Agrupo por numero de expedeinte y año academico de alta y creo el campo año academico de baja con dos logicas:
1. Si existe el año academico de baja null selecciono ese
2. Si no existe, selecione el año academico de baja mas grande asociado a ese año academico de alta
Al hacer estre proceso reduzoco los registros de la tabla a --1,304,214
*/
   ), gat_estud_tutor_hist_post AS (
        SELECT base_tutors_unics_periode.num_expediente,
               idp_tutor, 
               base_tutors_unics_periode.any_acad_alta, 
               base_tutors_unics_periode.any_acad_baja,
               data_canvi,
               tipo_tutor
        FROM base_tutors_unics_periode
        INNER JOIN db_uoc_prod.DD_OD.gat_estud_tutor_hist_TEST
        ON base_tutors_unics_periode.num_expediente = gat_estud_tutor_hist_TEST.num_expediente 
        AND base_tutors_unics_periode.any_acad_alta = gat_estud_tutor_hist_TEST.any_acad_alta 
        AND IFNULL(base_tutors_unics_periode.any_acad_baja,0) = IFNULL(gat_estud_tutor_hist_TEST.any_acad_baja,0)
        where idp_tutor <> 1
/*
De la tabla resultante, en la que hemos limpiado algunos tutores repetidos para un mismo expediente y año academico de alta 
la uno con la tabla de origen y me traigo los siguientes campos: idp_tutor, data_canvi,tipo_tutor
*/
    ), tutors_procesats_no_problematics AS (
        SELECT *
        FROM gat_estud_tutor_hist_post
        WHERE (SELECT COUNT(*)
               FROM gat_estud_tutor_hist_post AS sub
               WHERE gat_estud_tutor_hist_post.num_expediente = sub.num_expediente 
               AND gat_estud_tutor_hist_post.any_acad_alta = sub.any_acad_alta) = 1
        ORDER BY num_expediente, any_acad_alta
/* 
Una vez tengo mi tabla procesada, lo que hago es filtrar aquellos casos que al agrupar solo por el año academico de alta y expediente tengo una unica fila;
- Los que cumplen esta condición son aquellos que de origen ya estaban bien y los que con el proceso inicial hemos logrado solucionar.
a 12/11/2024 son 1,303,423 /1,304,214  Es decir el 99,3% de las filas de la tabla procesada
Alerta; Ahora bien, aqui no estamos teniendo en cuenta los expedeitnes con tutores en periodos superpuestos, con lo que relamente deb ser menso de un 77% correcto
*/
    ), tutors_procesats_problematics AS (
        SELECT *
        FROM gat_estud_tutor_hist_post
        WHERE (SELECT COUNT(*)
               FROM gat_estud_tutor_hist_post AS sub
               WHERE gat_estud_tutor_hist_post.num_expediente = sub.num_expediente 
               AND gat_estud_tutor_hist_post.any_acad_alta = sub.any_acad_alta) > 1
        ORDER BY num_expediente, any_acad_alta
/*
Aqui tendria los que estan mal, 1,751
*/
    ), tutors_procesats_problematics_base AS (
        SELECT distinct num_expediente, 
               any_acad_alta, 
               any_acad_baja, 
               MAX(data_canvi) AS data_canvi
        FROM tutors_procesats_problematics
        GROUP BY num_expediente, any_acad_alta, any_acad_baja

-- Al agruparlo 791 
/*
De los tutores problematicos procesados, miramos de aplicar una nueva logica para intentar limpiar una parte de ellos;
1. La primera parte de la logica es asignar a todos los registros erroneos de un expediente que tiene el mismo anyo academico de alta
la fecha de cambio mayor, para poder utilizarlo en una join posterior
*/
    ), tutors_procesats_problematics_post AS (
        SELECT tppb.num_expediente,
               tppb.any_acad_alta,
               tppb.any_acad_baja,
               tppb.data_canvi,
               idp_tutor,
               tipo_tutor
        FROM tutors_procesats_problematics_base AS tppb
        INNER JOIN tutors_procesats_problematics AS tpp 
        ON tppb.num_expediente = tpp.num_expediente 
        AND tppb.any_acad_alta = tpp.any_acad_alta 
        AND tppb.any_acad_baja = tpp.any_acad_baja 
        AND IFNULL(tppb.data_canvi, ''1900-01-01'') = IFNULL(tpp.data_canvi, ''1900-01-01'')
/*
De los tutores problematicos procesados, miramos de aplicar una nueva logica para intentar limpiar una parte de ellos;
2. La segunda parte de la logica es coger la tabla ceada en el antiguo paso (tutors_procesats_problematics_post) con la de 
tutors_procesats_problematics_base y unirla con un inner join para unicament coger el que tiene la ultima fecha de modificacion
*/
    ), tutores_problematicos_post_corregidos AS (
        SELECT * 
        FROM tutors_procesats_problematics_post
        WHERE (SELECT COUNT(*)
               FROM tutors_procesats_problematics_post AS sub 
               WHERE tutors_procesats_problematics_post.num_expediente = sub.num_expediente 
               AND tutors_procesats_problematics_post.any_acad_alta = sub.any_acad_alta 
               AND tutors_procesats_problematics_post.any_acad_baja = sub.any_acad_baja) = 1

/*
Del total 791 tutores problematicos, logramos resolver con este nuevo procedimiento 754, quedaria pro resolver 37 caso. Ahora bien
no estamos teniendo en cuenta el problema de los periodos superpuestos en expedientes.Por la tanto, tienen que se bastantes mas
*/
    ),datos_unidos as (
     select num_expediente, idp_tutor, any_acad_alta, any_acad_baja,tipo_tutor, data_canvi
     from tutors_procesats_no_problematics
     UNION
     select num_expediente, idp_tutor, any_acad_alta, any_acad_baja,tipo_tutor, data_canvi
     from tutores_problematicos_post_corregidos
/*
En esta parte uno los datos que supuestamente ya son correctos
Tendriamos 1,304,177 de los 1,304,214 inicales
*/
    ), casos_con_nuevos_errores  as (
    SELECT concat (num_expediente,''_'',any_acad_alta) as clave,*
    FROM datos_unidos  
    WHERE datos_unidos.num_expediente IN ( -- donde el numero de expediente tenga el año academico de baja igual a null
        SELECT t2.num_expediente
        FROM datos_unidos t2
        WHERE t2.ANY_ACAD_BAJA IS NULL
        AND t2.ANY_ACAD_ALTA < ( -- y el año academico de alta sea el minimo
            SELECT MIN(t3.ANY_ACAD_ALTA)
            FROM datos_unidos  t3
            WHERE t3.num_expediente = t2.num_expediente
                AND t3.ANY_ACAD_BAJA IS NOT NULL
    ) and datos_unidos.any_acad_baja is not null)


/*Solucio 2: Nos hemos dado cuenta al intentar unir con la fact que hay numeros de expediente en los que el tutor que tiene el valor nulo en el any_acad_baja (es decir el que esta activo) no es el que tiene el año academico de alta mas reciente. Esto es un error dado que tendremos mas de un tutor en  algunos de los periodos definidos por el año academicode alta dando lugar a problemas a la hora de hacer los joins con la fact*

Esta consulta devuelve un conjunto de registros con los expedientes que cumplen con las condiciones siguientes:

Tienen algún año de baja (any_acad_baja no es NULL).
Tienen un año de alta (any_acad_alta) menor que el año académico de alta en el que el estudiante fue dado de baja. */

), datos_unidos_correccion as (
select * 
from datos_unidos
where  concat (num_expediente,''_'',any_acad_alta) not in 
                                                (select clave
                                                from casos_con_nuevos_errores)
                                                
), eliminar_solapados as (
select 
    a.num_expediente,
    a.idp_tutor,
    a.any_acad_alta,
    a.any_acad_baja,
    a.tipo_tutor,
    a.data_canvi,
    -- nueva columna que indica si el período está solapado con otro
    case 
        when b.num_expediente is not null then ''solapado''
        else ''no solapado''
    end as solapado
from 
    datos_unidos_correccion a
left join 
    datos_unidos_correccion b 
on 
    a.num_expediente = b.num_expediente 
    and a.any_acad_alta < coalesce(b.any_acad_baja, a.any_acad_alta + 1)
    and b.any_acad_alta < coalesce(a.any_acad_baja, b.any_acad_alta + 1)
    and a.any_acad_alta != b.any_acad_alta  -- asegura que no sea el mismo registro exacto
where solapado  = ''no solapado''
)
select es.num_expediente,
       es.idp_tutor,
       es.any_acad_alta,
       es.any_acad_baja,
       es.tipo_tutor,
       es.data_canvi
from eliminar_solapados as es
inner join (select num_expediente, 
                   any_acad_baja,
                   max(any_acad_alta) as any_acad_alta_max
            from eliminar_solapados
            group by 1, 2  ) as query_filtro
on es.num_expediente = query_filtro.num_expediente and
   es.any_acad_alta = query_filtro.any_acad_alta_max) AS origen
ON dest.num_expedient = origen.num_expediente
AND dest.any_acad_alta = origen.any_acad_alta
WHEN MATCHED THEN
    UPDATE SET 
        num_expedient = origen.num_expediente, 
        idp_tutor = origen.idp_tutor, 
        any_acad_alta = origen.any_acad_alta, 
        any_acad_baja = origen.any_acad_baja, 
        tipo_tutor = origen.tipo_tutor, 
        data_canvi = origen.data_canvi,  
        update_date = CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
WHEN NOT MATCHED THEN
    INSERT (num_expedient, idp_tutor, any_acad_alta, any_acad_baja, tipo_tutor, data_canvi, creation_date, update_date)
    VALUES (origen.num_expediente, origen.idp_tutor, origen.any_acad_alta, origen.any_acad_baja, origen.tipo_tutor, origen.data_canvi, CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ), CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ));

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.procedures_log (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''tutor_unic_periode_hist'', CURRENT_USER(), :start_time, :execution_time, ''tutor_unic_periode_hist_Success'');
    
RETURN ''Update completed successfully'';

END';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* TAULA DESTÍ: STAGE_DOCENCIA_POST  */  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE DB_UOC_PROD.DD_OD.STAGE_DOCENCIA_POST_LOADS_TEST()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;


/*Creem taules temporals auxiliars per calcular diferents camps de antiguetat
Ho fem amb una taula temporal perquè per calcular el semestre relatiu de l''expedient, super_expedient e idp 
només volem tenir en compte els semestres en què almenys han matriculat una assignatura no convalidada. */

create  temporary table db_uoc_prod.dd_od.semestres_relatius_temporary_table AS
with p as (
select idp,
       super_expedient,
       num_expedient, 
       any_academic, 
       count (case when assignatura_convalidada = 0 and assignatura_anulada = 0 then cod_assignatura  end ) as num_ass_no_convalidada,
       count (case when assignatura_convalidada = 1 and assignatura_anulada = 0 then cod_assignatura  end ) as num_ass_convalidada
from db_uoc_prod.dd_od.stage_docencia_TEST
where matricula_anulada = 0 
group by idp,super_expedient,num_expedient, any_academic
having num_ass_no_convalidada >= 1
)
select *,
       dense_rank () over (partition by num_expedient order by any_academic asc) as semestre_relatiu_expedient,
       dense_rank () over (partition by super_expedient order by any_academic asc) as semestre_relatiu_super_expedient,
       dense_rank () over (partition by idp order by any_academic asc) as semestre_relatiu_uoc
from p
order by 1, 2, 3, 4, 7, 8, 9;

-- Carrega de la taula amb tots els registres de la taula stage_docencia_TEST




merge into
    db_uoc_prod.dd_od.stage_docencia_post_TEST
using
(with query_base as (
select  stage_docencia_TEST.id_docencia,
        concat(to_char(stage_docencia_TEST.num_expedient), to_varchar(stage_docencia_TEST.any_academic), to_char(stage_docencia_TEST.num_matricula)) as dim_matricula_key,
        dim_semestre_TEST.id_semestre,
        ifnull (dim_assignatura_TEST.id_assignatura,0) as id_assignatura,
        dim_qualificacio_TEST.id_qualificacio,
        dim_qualificacio_continuada_TEST.id_qualificacio_continuada,
        dim_expedient_TEST.id_expedient,
        dim_persona_estudiant_TEST.id_persona_estudiant,
        dim_pais_nacionalitat_TEST.id_pais_nacionalitat,
        dim_pais_nacim_TEST.id_pais_naixement,
        dim_matricula_TEST.id_matricula,
        dim_portafoli_pa_TEST.id_portafoli_pa,
        dim_acces_TEST.id_acces,
        ifnull (dim_persona_tutor_TEST.id_persona_tutor,0) as id_persona_tutor,
        stage_docencia_TEST.num_expedient,
        stage_docencia_TEST.super_expedient,
        stage_docencia_TEST.num_matricula,
        stage_docencia_TEST.idp,
        ifnull(stage_docencia_TEST.nacionalitat,''ND'') as nacionalitat,
        ifnull(stage_docencia_TEST.pais_naixement,''ND'') as pais_naixement,
        ifnull(stage_docencia_TEST.pais_residencia, ''ND'') as pais_residencia_dim,
        case 
        when stage_docencia_TEST.pais_residencia <> ''Espanya'' then ''99999''
        when stage_docencia_TEST.codi_postal is null then ''0''
        else TO_VARCHAR (stage_docencia_TEST.codi_postal)
        end as codi_postal_dim,
        ifnull (concat (pais_residencia_dim, codi_postal_dim, ifnull (ind_localitzacio,0)), ''ND00'') as dim_pais_residencia, 
        concat (stage_docencia_TEST.tipus_docencia,stage_docencia_TEST.titulacio_propia,stage_docencia_TEST.via_acces,stage_docencia_TEST.opcio_acces) as dim_acces_key,
        stage_docencia_TEST.cod_pla,
        concat (stage_docencia_TEST.idp_tutor,stage_docencia_TEST.tipus_tutor) as dim_persona_tutor_key,
        stage_docencia_TEST.idp_tutor,
        stage_docencia_TEST.tipus_tutor,
        stage_docencia_TEST.num_sol_acc,
        stage_docencia_TEST.nota_mitjana,
        stage_docencia_TEST.nota_mitjana_punts,
        stage_docencia_TEST.any_acad_titol,
        stage_docencia_TEST.any_academic,
        stage_docencia_TEST.any_acad_valida,
        stage_docencia_TEST.cod_assignatura,
        stage_docencia_TEST.assignatura_cursada,
        stage_docencia_TEST.num_credits,
        stage_docencia_TEST.num_credits_teorics,
        stage_docencia_TEST.num_credits_practics,
        case 
        when stage_docencia_TEST.matricula_anulada = 1 or stage_docencia_TEST.assignatura_anulada = 1 then null
        else stage_docencia_TEST.any_academic
        end as any_acad_calculos,
        case 
        when any_acad_calculos is null then null 
        else dense_rank() over (partition by  stage_docencia_TEST.super_expedient, stage_docencia_TEST.cod_assignatura order by any_acad_calculos asc) 
        end as num_matriculas_assignatura,
        /*case
        when num_matriculas_assignatura = 1 then ''NOU''
        when num_matriculas_assignatura > 1 then ''REPETIDOR''
        else ''ND''
        end as tipus_estudiant_assignatura,*/
        semestres_relatius_temporary_table.semestre_relatiu_expedient,
        /*case
        when semestres_relatius_temporary_table.semestre_relatiu_expedient = 1 then ''NOU''
        when semestres_relatius_temporary_table.semestre_relatiu_expedient > 1 then ''REMATRICULA''
        else ''ND''
        end as tipus_matricula,*/
        semestres_relatius_temporary_table.semestre_relatiu_super_expedient,
        semestres_relatius_temporary_table.semestre_relatiu_uoc,
        /*case
        when semestres_relatius_temporary_table.semestre_relatiu_uoc = 1 then ''NOU''
        when semestres_relatius_temporary_table.semestre_relatiu_uoc > 1 then ''NO_NOU_A_LA_UOC''
        else ''ND''
        end as tipus_matricula_uoc,*/
        stage_docencia_TEST.assigna_clase,
        stage_docencia_TEST.cod_aula,
        stage_docencia_TEST.cod_tfc,
        stage_docencia_TEST.ind_sols_examen,
        stage_docencia_TEST.qualif_num_cont,
        stage_docencia_TEST.qualif_num_cont_final,
        stage_docencia_TEST.qualif_numerica,
        stage_docencia_TEST.qualif_numerica_pub,
        stage_docencia_TEST.qualif_num_practica,
        stage_docencia_TEST.qualif_num_pres,
        stage_docencia_TEST.qualif_num_prop,
        stage_docencia_TEST.qualif_num_teorica,
        stage_docencia_TEST.qualif_practica,
        stage_docencia_TEST.qualif_teorica,
        stage_docencia_TEST.cod_qualif_conf,
        stage_docencia_TEST.cod_qualif_cont,
        stage_docencia_TEST.cod_qualif_cont_final,
        stage_docencia_TEST.cod_qualificacio,
        stage_docencia_TEST.ind_supera,
        case
        when stage_docencia_TEST.ind_supera = ''S'' then 1
        else 0
        end supera_assignatura,
        case
        when stage_docencia_TEST.ind_supera = ''N'' then 1
        else 0
        end no_supera_assignatura,
        stage_docencia_TEST.cod_qualificacio_pub,
        stage_docencia_TEST.cod_qualif_pres,
        stage_docencia_TEST.cod_qualif_prop,
        stage_docencia_TEST.cod_examen,
        stage_docencia_TEST.idp_corrector,
        stage_docencia_TEST.matricula_anulada,
        stage_docencia_TEST.assignatura_anulada,
        stage_docencia_TEST.assignatura_convalidada,
        CAST (lpad(stage_docencia_TEST.any_academic,4) - year (stage_docencia_TEST.data_naixement) as integer) as edat_relativa,
        case 
        when edat_relativa < 15 then ''edat errònia''
        when edat_relativa <= 19 then ''19 o menys''
        when edat_relativa <= 24 then ''20 a 24''
        when edat_relativa <= 29 then ''25 a 29''
        when edat_relativa <= 34 then ''30 a 34''
        when edat_relativa <= 39 then ''35 a 39''
        when edat_relativa <= 44 then ''40 a 44''
        when edat_relativa <= 49 then ''45 a 49''
        when edat_relativa <= 100 then ''50 o més''
        when edat_relativa > 100 then ''edat errònia'' 
        end as grup_edat,
        case 
        when edat_relativa < 15 then ''edat errònia''
        when edat_relativa <= 24 then ''18 a 24''
        when edat_relativa <= 29 then ''25 a 29''
        when edat_relativa <= 39 then ''30 a 39''
        when edat_relativa <= 49 then ''40 a 49''
        when edat_relativa <= 100 then ''majors 50''
        when edat_relativa > 100 then ''edat errònia'' 
        end as grup_edat_2
from db_uoc_prod.dd_od.stage_docencia_TEST
left join db_uoc_prod.dd_od.semestres_relatius_temporary_table
on stage_docencia_TEST.num_expedient = semestres_relatius_temporary_table.num_expedient and 
   stage_docencia_TEST.any_academic = semestres_relatius_temporary_table.any_academic  
inner join db_uoc_prod.dd_od.dim_semestre_TEST
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.any_academic,''19000'') = db_uoc_prod.dd_od.dim_semestre_TEST.dim_semestre_key
left join db_uoc_prod.dd_od.dim_assignatura_TEST
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.cod_assignatura,''00.000'') = db_uoc_prod.dd_od.dim_assignatura_TEST.dim_assignatura_key
inner join db_uoc_prod.dd_od.dim_qualificacio_TEST 
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.cod_qualificacio,''ND'') = db_uoc_prod.dd_od.dim_qualificacio_TEST.dim_qualificacio_key
inner join db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.cod_qualif_cont_final,''ND'') = db_uoc_prod.dd_od.dim_qualificacio_continuada_TEST.dim_qualificacio_continuada_key
inner join db_uoc_prod.dd_od.dim_expedient_TEST
on ifnull (db_uoc_prod.dd_od.stage_docencia_TEST.num_expedient,0) = db_uoc_prod.dd_od.dim_expedient_TEST.dim_expedient_key
inner join db_uoc_prod.dd_od.dim_persona_estudiant_TEST
on ifnull (db_uoc_prod.dd_od.stage_docencia_TEST.idp,0) = db_uoc_prod.dd_od.dim_persona_estudiant_TEST.dim_persona_estudiant_key
inner join db_uoc_prod.dd_od.dim_pais_nacionalitat_TEST
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.nacionalitat,''ND'') = db_uoc_prod.dd_od.dim_pais_nacionalitat_TEST.dim_pais_nacionalitat_key
inner join db_uoc_prod.dd_od.dim_pais_nacim_TEST
on ifnull(db_uoc_prod.dd_od.stage_docencia_TEST.pais_naixement,''ND'') = db_uoc_prod.dd_od.dim_pais_nacim_TEST.dim_pais_naixement_key
inner join db_uoc_prod.dd_od.dim_matricula_TEST
on concat(to_char(stage_docencia_TEST.num_expedient), to_varchar(stage_docencia_TEST.any_academic), to_char(stage_docencia_TEST.num_matricula)) = db_uoc_prod.dd_od.dim_matricula_TEST.dim_matricula_key
inner join db_uoc_prod.dd_od.dim_portafoli_pa_TEST
on ifnull (db_uoc_prod.dd_od.stage_docencia_TEST.cod_pla,''ND'') = db_uoc_prod.dd_od.dim_portafoli_pa_TEST.dim_portafoli_pa_key
inner join db_uoc_prod.dd_od.dim_acces_TEST 
on ifnull (concat (stage_docencia_TEST.tipus_docencia,stage_docencia_TEST.titulacio_propia,stage_docencia_TEST.via_acces,stage_docencia_TEST.opcio_acces),''ND'') = db_uoc_prod.dd_od.dim_acces_TEST.dim_acces_key 
left join db_uoc_prod.dd_od.dim_persona_tutor_TEST -- left por que hay tutores que no existe en persona, probablemente por errores
on ifnull (concat (stage_docencia_TEST.idp_tutor, stage_docencia_TEST.tipus_tutor),''ND'' ) = db_uoc_prod.dd_od.dim_persona_tutor_TEST.dim_persona_tutor_key)
select *,
       ifnull (id_pais_residencia,0)
from query_base
left join db_uoc_prod.dd_od.dim_pais_residencia_TEST 
on query_base.dim_pais_residencia = db_uoc_prod.dd_od.dim_pais_residencia_TEST.dim_pais_residencia_key ) as stage_docencia_TEST
on stage_docencia_TEST_post_TEST.id_docencia = stage_docencia_TEST.id_docencia
when matched then
    update set
    id_semestre = stage_docencia_TEST.id_semestre, 
    id_assignatura = stage_docencia_TEST.id_assignatura, 
    id_qualificacio = stage_docencia_TEST.id_qualificacio, 
    id_qualificacio_continuada = stage_docencia_TEST.id_qualificacio_continuada, 
    id_expedient = stage_docencia_TEST.id_expedient, 
    id_persona_estudiant = stage_docencia_TEST.id_persona_estudiant, 
    id_pais_nacionalitat = stage_docencia_TEST.id_pais_nacionalitat, 
    id_pais_naixement = stage_docencia_TEST.id_pais_naixement, 
    id_matricula = stage_docencia_TEST.id_matricula, 
    id_portafoli_pa = stage_docencia_TEST.id_portafoli_pa, 
    id_acces = stage_docencia_TEST.id_acces, 
    id_persona_tutor = stage_docencia_TEST.id_persona_tutor,
    id_pais_residencia= stage_docencia_TEST.id_pais_residencia,
    dim_expedient_key = stage_docencia_TEST.num_expedient, 
    dim_matricula_key = stage_docencia_TEST.dim_matricula_key,
    dim_portafoli_pa_key = stage_docencia_TEST.cod_pla, 
    idp = stage_docencia_TEST.idp, 
    dim_pais_nacionalitat_key = stage_docencia_TEST.nacionalitat, 
    dim_pais_naixement_key = stage_docencia_TEST.pais_naixement,
    dim_pais_residencia_key = stage_docencia_TEST.dim_pais_residencia,
    dim_acces_key = stage_docencia_TEST.dim_acces_key,
    dim_persona_tutor_key = stage_docencia_TEST.dim_persona_tutor_key,
    super_expedient = stage_docencia_TEST.super_expedient,
    idp_tutor = stage_docencia_TEST.idp_tutor,
    tipus_tutor = stage_docencia_TEST.tipus_tutor,
    num_sol_acc = stage_docencia_TEST.num_sol_acc,
    nota_mitjana = stage_docencia_TEST.nota_mitjana,
    nota_mitjana_punts = stage_docencia_TEST.nota_mitjana_punts,
    any_acad_titol = stage_docencia_TEST.any_acad_titol,
    any_academic = stage_docencia_TEST.any_academic,
    any_acad_valida = stage_docencia_TEST.any_acad_valida,
    cod_assignatura = stage_docencia_TEST.cod_assignatura,
    assignatura_cursada = stage_docencia_TEST.assignatura_cursada,
    num_credits = stage_docencia_TEST.num_credits,
    num_credits_teorics = stage_docencia_TEST.num_credits_teorics,
    num_credits_practics = stage_docencia_TEST.num_credits_practics,
    num_matriculas_assignatura = stage_docencia_TEST.num_matriculas_assignatura,
    tipus_estudiant_assignatura = stage_docencia_TEST.tipus_estudiant_assignatura,
    semestre_relatiu_expedient = stage_docencia_TEST.semestre_relatiu_expedient,
    tipus_matricula = stage_docencia_TEST.tipus_matricula,
    semestre_relatiu_super_expedient = stage_docencia_TEST.semestre_relatiu_super_expedient,
    semestre_relatiu_uoc = stage_docencia_TEST.semestre_relatiu_uoc,
    tipus_matricula_uoc = stage_docencia_TEST.tipus_matricula_uoc,
    assigna_clase = stage_docencia_TEST.assigna_clase,
    cod_aula = stage_docencia_TEST.cod_aula,
    cod_tfc = stage_docencia_TEST.cod_tfc,
    ind_sols_examen = stage_docencia_TEST.ind_sols_examen,
    qualif_num_cont = stage_docencia_TEST.qualif_num_cont,
    qualif_num_cont_final = stage_docencia_TEST.qualif_num_cont_final,
    qualif_numerica = stage_docencia_TEST.qualif_numerica,
    qualif_numerica_pub = stage_docencia_TEST.qualif_numerica_pub,
    qualif_num_practica = stage_docencia_TEST.qualif_num_practica,
    qualif_num_pres = stage_docencia_TEST.qualif_num_pres,
    qualif_num_prop = stage_docencia_TEST.qualif_num_prop,
    qualif_num_teorica = stage_docencia_TEST.qualif_num_teorica,
    qualif_practica = stage_docencia_TEST.qualif_practica,
    qualif_teorica = stage_docencia_TEST.qualif_teorica,
    cod_qualif_conf = stage_docencia_TEST.cod_qualif_conf,
    dim_qualificacio_continuada_key = stage_docencia_TEST.cod_qualif_cont_final,
    cod_qualif_cont = stage_docencia_TEST.cod_qualif_cont,
    dim_qualificacio_key = stage_docencia_TEST.cod_qualificacio,
    ind_supera = stage_docencia_TEST.ind_supera,
    supera_assignatura = stage_docencia_TEST.supera_assignatura,
    no_supera_assignatura = stage_docencia_TEST.no_supera_assignatura,
    cod_qualificacio_pub = stage_docencia_TEST.cod_qualificacio_pub,
    cod_qualif_pres = stage_docencia_TEST.cod_qualif_pres,
    cod_qualif_prop = stage_docencia_TEST.cod_qualif_prop,
    cod_examen = stage_docencia_TEST.cod_examen,
    idp_corrector = stage_docencia_TEST.idp_corrector,
    matricula_anulada = stage_docencia_TEST.matricula_anulada,
    assignatura_anulada = stage_docencia_TEST.assignatura_anulada,
    assignatura_convalidada = stage_docencia_TEST.assignatura_convalidada,
    edat_relativa = stage_docencia_TEST.edat_relativa,
    grup_edat = stage_docencia_TEST.grup_edat,
    grup_edat_2 = stage_docencia_TEST.grup_edat_2,
    update_date = CONVERT_TIMEZONE(''America/Los_Angeles'',''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
WHEN NOT MATCHED THEN
    INSERT
        (id_docencia,
        id_semestre,
        id_assignatura,
        id_qualificacio,
        id_qualificacio_continuada,
        id_expedient,
        id_persona_estudiant,
        id_pais_nacionalitat,
        id_pais_naixement,
        id_matricula,
        id_portafoli_pa,
        id_acces,
        id_persona_tutor,
        id_pais_residencia,
        dim_expedient_key,
        dim_matricula_key,
        dim_portafoli_pa_key,
        idp,
        dim_pais_nacionalitat_key,
        dim_pais_naixement_key,
        dim_pais_residencia_key,
        dim_acces_key,
        super_expedient,
        dim_persona_tutor_key,
        idp_tutor,
        tipus_tutor,
        num_sol_acc,
        nota_mitjana,
        nota_mitjana_punts,
        any_acad_titol,
        any_academic,
        any_acad_valida,
        cod_assignatura,
        assignatura_cursada,
        num_credits,
        num_credits_teorics,
        num_credits_practics,
        num_matriculas_assignatura,
        tipus_estudiant_assignatura,
        semestre_relatiu_expedient,
        tipus_matricula,
        semestre_relatiu_super_expedient,
        semestre_relatiu_uoc,
        tipus_matricula_uoc,
        assigna_clase,
        cod_aula,
        cod_tfc,
        ind_sols_examen,
        qualif_num_cont,
        qualif_num_cont_final,
        qualif_numerica,
        qualif_numerica_pub,
        qualif_num_practica,
        qualif_num_pres,
        qualif_num_prop,
        qualif_num_teorica,
        qualif_practica,
        qualif_teorica,
        cod_qualif_conf,
        dim_qualificacio_continuada_key,
        cod_qualif_cont,
        dim_qualificacio_key,
        ind_supera,
        supera_assignatura,
        no_supera_assignatura,
        cod_qualificacio_pub,
        cod_qualif_pres,
        cod_qualif_prop,
        cod_examen,
        idp_corrector,
        matricula_anulada,
        assignatura_anulada,
        assignatura_convalidada,
        edat_relativa,
        grup_edat,
        grup_edat_2,
        creation_date,
        update_date
        )
    values
        (stage_docencia_TEST.id_docencia,
        stage_docencia_TEST.id_semestre,
        stage_docencia_TEST.id_assignatura,
        stage_docencia_TEST.id_qualificacio,
        stage_docencia_TEST.id_qualificacio_continuada,
        stage_docencia_TEST.id_expedient,
        stage_docencia_TEST.id_persona_estudiant,
        stage_docencia_TEST.id_pais_nacionalitat,
        stage_docencia_TEST.id_pais_naixement,
        stage_docencia_TEST.id_matricula,
        stage_docencia_TEST.id_portafoli_pa,
        stage_docencia_TEST.id_acces,
        stage_docencia_TEST.id_persona_tutor,
        stage_docencia_TEST.id_pais_residencia,
        stage_docencia_TEST.num_expedient,
        stage_docencia_TEST.dim_matricula_key,
        stage_docencia_TEST.cod_pla,
        stage_docencia_TEST.idp,
        stage_docencia_TEST.nacionalitat,
        stage_docencia_TEST.pais_naixement,
        stage_docencia_TEST.dim_pais_residencia,
        stage_docencia_TEST.dim_acces_key,
        stage_docencia_TEST.super_expedient,
        stage_docencia_TEST.dim_persona_tutor_key,
        stage_docencia_TEST.idp_tutor,
        stage_docencia_TEST.tipus_tutor,
        stage_docencia_TEST.num_sol_acc,
        stage_docencia_TEST.nota_mitjana,
        stage_docencia_TEST.nota_mitjana_punts,
        stage_docencia_TEST.any_acad_titol,
        stage_docencia_TEST.any_academic,
        stage_docencia_TEST.any_acad_valida,
        stage_docencia_TEST.cod_assignatura,
        stage_docencia_TEST.assignatura_cursada,
        stage_docencia_TEST.num_credits,
        stage_docencia_TEST.num_credits_teorics,
        stage_docencia_TEST.num_credits_practics,
        stage_docencia_TEST.num_matriculas_assignatura,
        stage_docencia_TEST.tipus_estudiant_assignatura,
        stage_docencia_TEST.semestre_relatiu_expedient,
        stage_docencia_TEST.tipus_matricula,
        stage_docencia_TEST.semestre_relatiu_super_expedient,
        stage_docencia_TEST.semestre_relatiu_uoc,
        stage_docencia_TEST.tipus_matricula_uoc,
        stage_docencia_TEST.assigna_clase,
        stage_docencia_TEST.cod_aula,
        stage_docencia_TEST.cod_tfc,
        stage_docencia_TEST.ind_sols_examen,
        stage_docencia_TEST.qualif_num_cont,
        stage_docencia_TEST.qualif_num_cont_final,
        stage_docencia_TEST.qualif_numerica,
        stage_docencia_TEST.qualif_numerica_pub,
        stage_docencia_TEST.qualif_num_practica,
        stage_docencia_TEST.qualif_num_pres,
        stage_docencia_TEST.qualif_num_prop,
        stage_docencia_TEST.qualif_num_teorica,
        stage_docencia_TEST.qualif_practica,
        stage_docencia_TEST.qualif_teorica,
        stage_docencia_TEST.cod_qualif_conf,
        stage_docencia_TEST.cod_qualif_cont_final,
        stage_docencia_TEST.cod_qualif_cont,
        stage_docencia_TEST.cod_qualificacio,
        stage_docencia_TEST.ind_supera,
        stage_docencia_TEST.supera_assignatura,
        stage_docencia_TEST.no_supera_assignatura,
        stage_docencia_TEST.cod_qualificacio_pub,
        stage_docencia_TEST.cod_qualif_pres,
        stage_docencia_TEST.cod_qualif_prop,
        stage_docencia_TEST.cod_examen,
        stage_docencia_TEST.idp_corrector,
        stage_docencia_TEST.matricula_anulada,
        stage_docencia_TEST.assignatura_anulada,
        stage_docencia_TEST.assignatura_convalidada,
        stage_docencia_TEST.edat_relativa,
        stage_docencia_TEST.grup_edat,
        stage_docencia_TEST.grup_edat_2,
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ),
        CONVERT_TIMEZONE(''America/Los_Angeles'', ''Europe/Madrid'', CURRENT_TIMESTAMP()::TIMESTAMP_NTZ)
        )
;

execution_time := datediff(millisecond, start_time, convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz));

insert into db_uoc_prod.dd_od.PROCEDURES_LOG_TEST (id_log, procedure_name, executed_by, execution_date, execution_time, remarks)
    values (db_uoc_prod.dd_od.sequencia_id_log.nextval, ''stage_docencia_post_loads'', CURRENT_USER(), :start_time, :execution_time, ''stage_docencia_post Success'');
    
return ''Update completed successfully'';

end';