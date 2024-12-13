/*
incluir en la documentacion 
*/


create or replace TABLE DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA (
	ID_ASSIGNATURA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio assignatura pels diferents semestres i per idioma docencia',
	DIM_ASSIGNATURA_KEY VARCHAR(8) NOT NULL COMMENT 'Codi UOC d assignatura. El codi assignatura es unic i independent de l idioma en que s imparteix.',
	SEMESTRE_INICI_DOC VARCHAR(6) COMMENT 'Semestre en que dona inici la docencia per a una assignatura determinada.',
	SEMESTRE_EXTINCIO VARCHAR(6) COMMENT 'Semestre en extingueix la docencia per a una assignatura determinada.',
    assignatura_vigent VARCHAR(1) COMMENT 'Flag para determinar si la assignatura es valida o no. S si valida, N si no.',
	SEMESTRE_INI_EEES VARCHAR(6) COMMENT 'Semestre en que dona inici EEES.',
	IDIOMA_DOCENCIA VARCHAR(3) COMMENT 'Idioma en que es impartida una assignatura en concret.',
	DESC_CAT VARCHAR(256) COMMENT 'Descripcio completa de l assignatura en catala.',
	DESC_CAS VARCHAR(256) COMMENT 'Descripcio completa de l assignatura en castella.',
	DESC_ANG VARCHAR(256) COMMENT 'Descripcio completa de l assignatura en angles.',
	DESC_FRA VARCHAR(256) COMMENT 'Descripcio completa de l assignatura en frances.',
	IND_TFC VARCHAR(1) COMMENT 'Indicador de Treball de Fi de Carrera.',
	IND_PRACTICUM VARCHAR(1) COMMENT 'Indicador de Practicum a assignatura.',
	IND_AREES VARCHAR(1) COMMENT 'Indicador Arees a assignatura.',
	IND_ANUAL VARCHAR(1) COMMENT 'Indicador assignatura anual.',
	DESCRIPCIO_ASSIGNATURA VARCHAR(256) COMMENT 'Descripció original de l assignatura.',
	TIPUS_ASSIGNATURA NUMBER(2,0),
	NUM_CREDITS NUMBER(4,2),
	NUM_CREDITS_TEORICS NUMBER(4,2),
	NUM_CREDITS_PRACTICS NUMBER(4,2),
	VALOR_ASSIGNATURA VARCHAR(2),
	IND_EVAL_CONTINUADA VARCHAR(2),
	IND_EXA_PRESENCIAL VARCHAR(2),
	IND_PROVA_CONF VARCHAR(2),
	COD_ESTUDIS_AREA VARCHAR(8),
    DESC_ESTUDIS_AREA VARCHAR(2000) COMMENT 'Descripcio del area de estudios, usada para el area Recurs de aprenentatge, viene de la tabla db_uoc_prod.stg_docencia.gat_descripciones.',
	TIPUS_EDUCACIO VARCHAR(8),
	TIPUS_DOCENCIA_DETALL VARCHAR(8),
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les assignatures ofertades o impartides a la UOC.'
;

CREATE OR REPLACE PROCEDURE DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_LOADS()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 'begin
let start_time timestamp_ntz := convert_timezone(''America/Los_Angeles'',''Europe/Madrid'', current_timestamp()::timestamp_ntz);
let execution_time float;

-- initial_merge : 
merge into DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA
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
on DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.id_assignatura = dim_assignatura_repl.id_assignatura
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
merge into DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA
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
            ifnull(db_uoc_prod.stg_dadesra.gat_asignaturas.cod_asignatura,ifnull(db_uoc_prod.stg_docencia.gat_asig_semestres.cod_asignatura,trim(db_uoc_prod.stg_docencia.gat_descripciones.clave))) as cod_assignatura,
            db_uoc_prod.stg_docencia.gat_asig_semestres.any_acad_inicio_doc,
            db_uoc_prod.stg_docencia.gat_asig_semestres.any_acad_extincion,
            case 
                when db_uoc_prod.stg_docencia.gat_asig_semestres.any_acad_extincion is null then ''S''
                else ''N'' 
            END as assignatura_vigent,
 
            db_uoc_prod.stg_docencia.gat_asig_semestres.any_acad_ini_eees,
            ifnull(db_uoc_prod.stg_docencia.gat_asig_semestres.idioma_docencia,''ND'') as idioma_docencia,
            db_uoc_prod.stg_docencia.gat_descripciones.cod_idioma,
            db_uoc_prod.stg_docencia.gat_descripciones.descripcion,
            db_uoc_prod.stg_docencia.gat_descripciones.clave,
            db_uoc_prod.stg_docencia.gat_asig_semestres.ind_tfc,
            db_uoc_prod.stg_docencia.gat_asig_semestres.ind_practicum,
            db_uoc_prod.stg_docencia.gat_asig_semestres.ind_arees,
            db_uoc_prod.stg_docencia.gat_asig_semestres.ind_anual,
            db_uoc_prod.stg_dadesra.gat_asignaturas.desc_asignatura as descripcio_assignatura,
            db_uoc_prod.stg_dadesra.gat_asignaturas.tipo_asignatura as tipus_assignatura,
            db_uoc_prod.stg_dadesra.gat_asignaturas.num_creditos as num_credits,
            db_uoc_prod.stg_dadesra.gat_asignaturas.num_creditos_teoricos as num_credits_teorics,
            db_uoc_prod.stg_dadesra.gat_asignaturas.num_creditos_practicos as num_credits_practics,
            db_uoc_prod.stg_dadesra.gat_asignaturas.valor_asignatura as valor_assignatura,
            db_uoc_prod.stg_dadesra.gat_asignaturas.ind_eval_continuada,
            db_uoc_prod.stg_dadesra.gat_asignaturas.ind_exa_presencial,
            db_uoc_prod.stg_dadesra.gat_asignaturas.ind_prueba_conf as ind_prova_conf,
            db_uoc_prod.stg_dadesra.gat_asignaturas.cod_estudios_area as cod_estudis_area,
            desc_area_estudis.descripcion as DESC_ESTUDIS_AREA,
            db_uoc_prod.stg_dadesra.gat_asignaturas.tipo_educacion as tipus_educacio,
            db_uoc_prod.stg_dadesra.gat_asignaturas.tipo_docencia_detalle as tipus_docencia_detall,
            db_uoc_prod.stg_docencia.gat_descripciones.nom_tabla,
            db_uoc_prod.stg_docencia.gat_descripciones.nom_campo
        
        from db_uoc_prod.stg_dadesra.gat_asignaturas
            
        left join db_uoc_prod.stg_docencia.gat_asig_semestres
            on db_uoc_prod.stg_docencia.gat_asig_semestres.cod_asignatura = db_uoc_prod.stg_dadesra.gat_asignaturas.cod_asignatura
        
        left join db_uoc_prod.stg_docencia.gat_descripciones
            on db_uoc_prod.stg_dadesra.gat_asignaturas.cod_asignatura = db_uoc_prod.stg_docencia.gat_descripciones.clave -- Anteriormente la clave tenia un trim. En la tabla descripciones algunas claves esta duplicadas lo unico que algunas con 7 caracteres (un espacio extra) y otras 6. Eso hacia duplicar resultados y dar errores
            and db_uoc_prod.stg_docencia.gat_descripciones.nom_tabla = ''ASIGNATURAS''
            and db_uoc_prod.stg_docencia.gat_descripciones.nom_campo = ''DESC_ASIGNATURA''
        
        
        left join db_uoc_prod.stg_docencia.gat_descripciones desc_area_estudis
            on db_uoc_prod.stg_dadesra.gat_asignaturas.cod_estudios_area = desc_area_estudis.clave -- Anteriormente la clave tenia un trim. En la tabla descripciones algunas claves esta duplicadas lo unico que algunas con 7 caracteres (un espacio extra) y otras 6. Eso hacia duplicar resultados y dar errores
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

on DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.dim_assignatura_key = dim_assignatura_orig.cod_assignatura
    --- DANI & INI : 2024/12/12: union campo idiomas no correctos --> comprobacion varias asignaturas pueden tener el mismo idioma: semestre informado vs no informado --> nuevo por no semestre de inicio ( necesario sobreescritura)
    -- and ifnull (DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.semestre_inici_doc,0) = ifnull (dim_assignatura_orig.any_acad_inicio_doc,0)
    -- and DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA.idioma_docencia = dim_assignatura_orig.idioma_docencia  

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


call DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_LOADS();
select * from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA;  -- 18,091


/* -- 18,091

select * from db_uoc_prod.DD_OD.DIM_ASSIGNATURA  -- 18,095
where dim_assignatura_key not in (
    select dim_assignatura_key from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA
);

select dim_assignatura_key, count(*)
from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA 
group by dim_assignatura_key
having count(*) > 1;

select *
from DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA 

select * 
from db_uoc_prod.DD_OD.DIM_ASSIGNATURA 
where dim_assignatura_key in (

'20.675',
'20.560',
'20.559',
'20.674'

)


-- NO ESTA EN NUESTRA TABLA FACT 
select * from DB_UOC_PROD.DDP_DOCENCIA.FACT_RECURSOS_APRENENTATGE_EVENTS
where dim_assignatura_key in (

'20.675',
'20.560',
'20.559',
'20.674'

)


-- comentar con francesc 
--> vigencia en el momento particular -->  
--> flag rango validez en periodo --> 
-- SEMESTRE --> -6 months --> incluyendo >= 

*/


