
-- -- #################################################################################################
-- -- #################################################################################################
-- -- RECURSOS_APRENDIZATJE
-- -- #################################################################################################
-- -- #################################################################################################

-- CREATE TABLE RECURSOS_COCO_PRODUCTES
CREATE TABLE DB_UOC_PROD.DDP_DOCENCIA.DIM_CATALOG AS -- DDP_DOCENCIA  vs  DDP_DADESRA 
With dim_coco_productes_moduls as ( 
    
    select
        source_recurs|| '-' || CODI_RECURS AS ID_CODI_RECURS          
        , CODI_RECURS
        , TITOL_RECURS
        , ORIGEN_RECURS
        , '' AS TIPUS_RECURS -- added: TFG, Exams, Articles (100+ elements)
        , source_recurs

        -- Added: empty in fields from DIMAX
        , '' AS LLICENCIA_LPC
        , '' AS LLICENCIA_LGC
        , '' AS LLICENCIA_ALTRES
        , '' AS LLICENCIA_BIBLIOTECA


        , BAIXA AS WAIT_RECURS -- comentar con xabi 

        , '' AS IDIOMA_RECURS -- Options dimax: en / es / ca
        , '' AS FORMAT_RECURS -- Options dimax: ZIP / PDF / HTML / WORD

        -- not filled in DIMAX 
        , null AS DATA_INICI_RECURS
        , null AS DATA_CADUCITAT_RECURS


        , '' AS CERCABLE_RECURS -- Options dimax: S / N
        , '' AS INDICADOR_PUBLIC_RECURS -- Options dimax: S / N
        , '' AS PUBLICAT_A_RECURS -- Options dimax: option of magazine of publication
        
        -- dades from publication: magazine, journal, newspaper, etc
        , '' AS ISBN_ISSN_RECURS
        , 0  AS PAGINA_INICI_RECURS
        , 0  AS PAGINA_FINAL_RECURS
        , '' AS BASE_DADES_RECURS
        , '' AS ELLIBRE_RECURS
        , '' AS URL_CAT_RECURS
        , '' AS URL_CAS_RECURS
        , '' AS URL_ANG_RECURS
        , '' AS TIPUS_GESTIO_RECURS

        , '' AS DESPESA_VARIABLE_RECURS
        , null AS CREATION_DATE
        , null AS UPDATE_DATE

        -- not exist in DIMAX
        , DESCRIPCIO_TRAMESA_RECURS
        , DESCRIPCIO_SUPORT_RECURS
        , DESCRIPCIO_IDIOMA_RECURS
        , PRODUCTE_CREACIO_ID



        , NUM_CONTRACTE
        , DATA_TANCAMENT_REAL
        , OBSERVACIONS
        , MODUL_ORIGEN_ID
        , VERSIO_CREACIO_ID
        , OBRA_ID
        , CODI_MIGRACIO
        , URL_IDIOMA_RECURS


    from DB_UOC_PROD.DDP_DOCENCIA.DIM_RECURSOS_COCO_PRODUCT_MODULS
                   
), 

-- CREATE TABLE DIMAX
dimax as (

    select
    
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
        , TIPUS_GESTIO_RECURS
        
        , DESPESA_VARIABLE_RECURS
        , CREATION_DATE
        , UPDATE_DATE

        -- fields of coco : publicat al aula 
        , '' AS DESCRIPCIO_TRAMESA_RECURS
        , '' AS DESCRIPCIO_SUPORT_RECURS
        , '' AS DESCRIPCIO_IDIOMA_RECURS
        , 0 AS PRODUCTE_CREACIO_ID
        , '' AS NUM_CONTRACTE
        , null AS DATA_TANCAMENT_REAL
        , '' AS OBSERVACIONS
        , '' AS MODUL_ORIGEN_ID
        , 0 AS VERSIO_CREACIO_ID
        , '' AS OBRA_ID
        , '' AS CODI_MIGRACIO
        , '' AS URL_IDIOMA_RECURS


    from db_uoc_prod.dd_od.stage_recursos_aprenentatge_dimax
 
) 

 
 
select * from dim_coco_productes_moduls

union all 
 
select  * from dimax;

 
 