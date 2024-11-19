
-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################

--  DROP TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_CATALEG

CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_CATALEG AS -- DDP_DOCENCIA  vs  DDP_DADESRA 
With dim_coco_productes_moduls AS ( 
    
    SELECT
        'COCO'|| '-' || CODI_RECURS AS ID_CODI_RECURS  -- no podemos poner source_recurs pq elementos NIU no distinge entre COCO_PROD y COCO_MOD        
        , CODI_RECURS
        , TITOL_RECURS
        , ORIGEN_RECURS
        , '' AS TIPUS_RECURS -- added: TFG, Exams, Articles (100+ elements)
        , source_recurs

        -- Added: empty in fields FROM DIMAX
        , '' AS LLICENCIA_LPC
        , '' AS LLICENCIA_LGC
        , '' AS LLICENCIA_ALTRES
        , '' AS LLICENCIA_BIBLIOTECA


        , BAIXA AS WAIT_RECURS -- comentar con xabi : no se visualiza ( similar a ocultar) para no romper integridad no se muestra en--> establecer el nombre que Francesc nos pase 
        
        -- id_comentario: 6 v_recurs.Idioma_Recurs de dimax i autors_suport_idioma_i18n de COCO en Idioma_Recurs y por lo tanto desparece el suport_idioma de coco
        , descripcio_idioma_recurs AS IDIOMA_RECURS -- Options dimax: en / es / ca

        , DESCRIPCIO_SUPORT_RECURS AS FORMAT_RECURS  -- added: comentario francesc id_comentario: 5

        -- not filled in DIMAX 
        , null AS DATA_INICI_RECURS
        , null AS DATA_CADUCITAT_RECURS


        , '' AS CERCABLE_RECURS -- Options dimax: S / N
        , '' AS INDICADOR_PUBLIC_RECURS -- Options dimax: S / N
        , '' AS PUBLICAT_A_RECURS -- Options dimax: option of magazine of publication
        
        -- dades FROM publication: magazine, journal, newspaper, etc
        , '' AS ISBN_ISSN_RECURS
        , 0  AS PAGINA_INICI_RECURS
        , 0  AS PAGINA_FINAL_RECURS
        , '' AS BASE_DADES_RECURS
        , '' AS ELLIBRE_RECURS
        , '' AS URL_CAT_RECURS
        , '' AS URL_CAS_RECURS
        , '' AS URL_ANG_RECURS
        , 'ND' AS TIPUS_GESTIO_RECURS

        , '' AS DESPESA_VARIABLE_RECURS
        , null AS UPDATE_DATE
        , DATA_TANCAMENT_REAL AS CREATION_DATE -- id_comentario: 8 v_recurs.data_creacio de dimax i data_tancament_real de COCO en creation_date y por lo tanto desparece el data_tancament_real de coco
        , PRODUCTE_CREACIO_ID

        -- not exist in DIMAX
        , DESCRIPCIO_TRAMESA_RECURS --- error: CLASIFIED AS A TIMESTAMP 
        , DESCRIPCIO_IDIOMA_RECURS




        , NUM_CONTRACTE
        , OBSERVACIONS
        , MODUL_ORIGEN_ID
        , VERSIO_CREACIO_ID
        , OBRA_ID
        , CODI_MIGRACIO
        , URL_IDIOMA_RECURS

 
    FROM DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS
                   
), 

-- CREATE TABLE DIMAX
dimax AS (

    SELECT
    
        'DIMAX'|| '-'|| CODI_RECURS AS ID_CODI_RECURS
        , CODI_RECURS
        , TITOL_RECURS
        , ORIGEN_RECURS
        , TIPUS_RECURS
        , 'DIMAX' AS source_recurs

        , LLICENCIA_LPC
        , LLICENCIA_LGC
        , LLICENCIA_ALTRES
        , LLICENCIA_BIBLIOTECA

        , WAIT_RECURS

        , IDIOMA_RECURS
        , FORMAT_RECURS

        , DATA_INICI_RECURS
        , DATA_CADUCITAT_RECURS

        , CERCABLE_RECURS
        , INDICADOR_PUBLIC_RECURS

        , PUBLICAT_A_RECURS
        , ISBN_ISSN_RECURS
        , PAGINA_INICI_RECURS
        , PAGINA_FINAL_RECURS
        , BASE_DADES_RECURS
        , ELLIBRE_RECURS


        , URL_CAT_RECURS
        , URL_CAS_RECURS
        , URL_ANG_RECURS

        // added; comentarios francesc 
        , iff(
            LLICENCIA_lpc = 'S','DRETS'
            ,iff( 
                LLICENCIA_lgc = 'S','DRETS'
                ,iff(
                    LLICENCIA_altres = 'S'
                    ,'DRETS'
                    ,iff(LLICENCIA_biblioteca = 'S','SUBS', '')
                    )
                )
        ) AS TIPUS_GESTIO_RECURS --ND 
        
        , DESPESA_VARIABLE_RECURS
        , CREATION_DATE  
        , UPDATE_DATE
        , NULL AS PRODUCTE_CREACIO_ID

        -- fields of coco : publicat al aula 
        , NULL AS DESCRIPCIO_TRAMESA_RECURS -- CHANGES: 
        , NULL AS DESCRIPCIO_IDIOMA_RECURS


        , '' AS NUM_CONTRACTE
        , '' AS OBSERVACIONS
        , '' AS MODUL_ORIGEN_ID
        , 0 AS VERSIO_CREACIO_ID

        , '' AS OBRA_ID
        , '' AS CODI_MIGRACIO
        , '' AS URL_IDIOMA_RECURS
 

    FROM db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax   
    -- dimax_v_recurs  -- original que viene de la aplicacion 
    -- SELECT * FROM db_uoc_prod.stg_dadesra.dimax_v_recurs

    /*
    
    He visto hay casos que no hay ningún tipo de licencia y necessitaria que el campo tipus_gesió_recurs tenga un ND si no hay datos. Pongo el sql relacionado
iff(dimax_v_recurs.lpc = 'S','DRETS',
    iff(dimax_v_recurs.lgc = 'S','DRETS',
        iff(dimax_v_recurs.altres = 'S','DRETS',
            iff(dimax_v_recurs.biblioteca = 'S','SUBS', '')))) AS tipus_gestio_recurs 


FROM db_uoc_prod.stg_dadesra.dimax_resofite_path  --- registros : 17,303,400
    
    left join db_uoc_prod.stg_dadesra.dimax_item_dimax on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_recurs = db_uoc_prod.stg_dadesra.dimax_item_dimax.id -- 17303400
    left join db_uoc_prod.stg_dadesra.dimax_v_recurs on db_uoc_prod.stg_dadesra.dimax_resofite_path.node_cami = db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs -- 17303400 
    left join db_uoc_prod.stg_dadesra.dimax_recurs_info_extra on db_uoc_prod.stg_dadesra.dimax_v_recurs.id_recurs = db_uoc_prod.stg_dadesra.dimax_recurs_info_extra.id_recurs -- 17303400

SELECT 
    COLUMN_NAME
FROM 
    <NOMBRE_BASE_DATOS>.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = '<NOMBRE_TABLA>'
    AND TABLE_SCHEMA = '<NOMBRE_ESQUEMA>'
ORDER BY 
    COLUMN_NAME ASC;


    */
 
) 


 
SELECT * FROM dim_coco_productes_moduls

union all 
 
SELECT  * FROM dimax;


---######################################################################################################################################################################## 
/*** 
CONCAT: 213,157
DIMAX: 100,821 
COCO: 112,336


id_comentario: 5 LLICENCIA_format de dimax i autors_suport_producte_i18n de COCO en Format_Recurs y por lo tanto desparece el suport_producte de coco
id_comentario: 6 v_recurs.Idioma_Recurs de dimax i autors_suport_idioma_i18n de COCO en Idioma_Recurs y por lo tanto desparece el suport_idioma de coco
id_comentario: 8 v_recurs.data_creacio de dimax i data_tancament_real de COCO en creation_date y por lo tanto desparece el data_tancament_real de coco
***/ 







/***

Ver si en docencia han completado los datos: 

DADES_ACADEMIQUES	Necesito el estudio	Necesito saber de quien depende la asignatura en el semestre correspondiente. Estudios és "Economia i Empresa", "Dret i Ciències Polítiques"
DADES_ACADEMIQUES	Necesito el porfesor responsable (PRA)	Necesesito saber el professor responsable de la asignatura
DADES_ACADEMIQUES	Necesito el número de martículados en la asignatura/semestre	Necesito el número de matriculados para poder tener el % de uso


profesores pueden cambiar
modelo de datos? 


 */