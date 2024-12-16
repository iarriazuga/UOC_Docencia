PRODUCTIVITZACIO CREACIO TAULES 2024/12/13



--------------------------------------------------------

--STAGE
create  TABLE DB_UOC_PROD.DD_OD.AEP_AEP_RECONOCIMIENTOS_TEST (
        SEC_SOLICITUD NUMBER(10,0),
        COD_ELEMENTO_DEST VARCHAR(8),
        NUM_RECONOCIMIENTO NUMBER(10,0),
        ENTIDAD_GESTORA VARCHAR(8),
        FECHA_GENERACION DATE,
        TIPO_ELEMENTO_DEST VARCHAR(2),
        COD_PLAN VARCHAR(8),
        PROCESO_ORIGEN VARCHAR(1),
        TIPO_PROCESO_ORIGEN VARCHAR(1),
        FECHA_ACEPTACION DATE,
        IDP_ACEPTACION NUMBER(10,0),
        ESTADO VARCHAR(1) DEFAULT 'P',
        COD_CALIFICACION VARCHAR(8),
        CALIF_NUMERICA NUMBER(15,4),
        NUM_CREDITOS NUMBER(15,4),
        ASIGNA_CICLO VARCHAR(1),
        ASIGNA_CLASE VARCHAR(1),
        ASIGNA_CURSO VARCHAR(2),
        ASIGNA_ETAPA VARCHAR(2),
        ASIGNA_PERIODO VARCHAR(1),
        ASIGNA_VALOR VARCHAR(2),
        VECES_MATRICULA NUMBER(10,0),
        NUM_CONVOCATORIAS NUMBER(10,0),
        NUM_ANUL_CONV NUMBER(10,0),
        ANY_ACAD_VALIDA VARCHAR(5),
        ANY_ACAD_CARENCIA VARCHAR(5),
        ANY_ACADEMICO VARCHAR(5),
        NUM_MATRICULA NUMBER(10,0),
        FECHA_ANULACION DATE,
        IND_COBRO_MATERIAL VARCHAR(1),
        TIPO_INCORPORACION VARCHAR(1),
        COD_PERFIL_LC VARCHAR(8),
        NUM_CREDITOS_MH NUMBER(15,4),
        COD_TFC VARCHAR(8),
        COD_CONJUNTO NUMBER(10,0),
        IND_TRASPASAR_AEP VARCHAR(1) DEFAULT 'N',
        FECHA_TRASPASO_AEP DATE,
        INTERVIENE_NOTA_FINAL VARCHAR(1),
        TIPO_RECONOCIMIENTO VARCHAR(1),
        TIPO_MOTIVO_DENE VARCHAR(40),
        COD_MOTIVO_DENE VARCHAR(8),
        IDP_ULT_MODIF NUMBER(10,0),
        FECHA_ULT_MODIF DATE,
        PERFIL_ALEGACION VARCHAR(15)
);

create  TABLE DB_UOC_PROD.DD_OD.AEP_AEP_SOLICITUDES_TEST (
        SEC_SOLICITUD NUMBER(10,0),
        NUM_SOL_ACC NUMBER(10,0),
        NUM_EXPEDIENTE NUMBER(10,0),
        COD_OPC_ACC VARCHAR(8)
);

create  or replace TABLE DB_UOC_PROD.DD_OD.EQUIVALENCIAS_VIASOPCS_UOC_EXTERNAS_TEST (
	VIA_ACCES VARCHAR(16777216),
	OPCIO_ACCES VARCHAR(16777216),
	ACCES_SUE VARCHAR(16777216),
	VIA_SIIU VARCHAR(16777216),
	VIA_OFICINA VARCHAR(16777216)
);

create or replace TABLE DB_UOC_PROD.DD_OD.EQUIVALENCIES_PAISOS_CONTINENTS_TEST (
	CODI_ISO VARCHAR(16777216),
	PAIS VARCHAR(16777216),
	REGIO VARCHAR(16777216),
	CONTINENT VARCHAR(16777216)
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_ANYS_ACADEMICOS_TEST (
        ANY_ACADEMICO VARCHAR(5),
        DESCRIPCION VARCHAR(30),
        ANY_NATURAL NUMBER(10,0),
        SEMESTRE NUMBER(10,0),
        DESC_VISUAL VARCHAR(12),
        FECHA_INICIO TIMESTAMP_NTZ(9),
        FECHA_FINAL TIMESTAMP_NTZ(9),
        IND_MIGRACION_GATIB VARCHAR(1),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_ASIG_SEMESTRES_TEST (
        COD_ASIGNATURA VARCHAR(8),
        ANY_ACAD_INICIO_DOC VARCHAR(5),
        ANY_ACAD_INI_EEES VARCHAR(5),
	ANY_ACAD_EXTINCION VARCHAR(5),
        IDIOMA_DOCENCIA VARCHAR(3),
        IND_TFC VARCHAR(1),
        IND_PRACTICUM VARCHAR(1),
        IND_AREES VARCHAR(1),
        IND_ANUAL VARCHAR(1),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_ASIGNATURAS_TEST (
        COD_ASIGNATURA VARCHAR(8) NOT NULL,
        DESC_ASIGNATURA VARCHAR(60) NOT NULL,
        TIPO_ASIGNATURA NUMBER(10,0) NOT NULL,
        NUM_CREDITOS NUMBER(15,4) NOT NULL,
        NUM_CREDITOS_TEORICOS NUMBER(15,4),
        NUM_CREDITOS_PRACTICOS NUMBER(15,4),
        VALOR_ASIGNATURA VARCHAR(1) NOT NULL,
        IND_EVAL_CONTINUADA VARCHAR(1),
        IND_EXA_PRESENCIAL VARCHAR(2),
        IND_PRUEBA_CONF VARCHAR(2),
        COD_ESTUDIOS_AREA VARCHAR(8),
        TIPO_EDUCACION VARCHAR(15) NOT NULL DEFAULT 'LRU',
        TIPO_DOCENCIA_DETALLE VARCHAR(10),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_AULAS_ASIG_CONSULTORES_TEST (
        IDP NUMBER(10,0),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_CAB_SOLICITUD_ACC_TEST (
        COD_CENTRO NUMBER(10,0),
        COD_PLAN VARCHAR(16777216),
        NUM_EXPEDIENTE NUMBER(10,0),
        COD_OPC_ACC VARCHAR(16777216),
        IND_TITULADO VARCHAR(16777216),
        IND_APOR_ADJUDICACION VARCHAR(16777216),
        IND_CARTA_COMPROMISO VARCHAR(16777216),
        IND_CONTINUA_ESTUDIOS VARCHAR(16777216),
        IND_EXCEDER_LE VARCHAR(16777216),
        IND_MIGRACION_GATIB VARCHAR(16777216),
        DATA_ASIGNACION_TUTOR TIMESTAMP_NTZ(9) COMMENT 'Data en que s''assigna el tutor.',
        DATA_DESASIGNACION_TUTOR TIMESTAMP_NTZ(9) COMMENT 'Fecha en la que se envia la documentación de acceso.',
        IDP_DINAMIZADOR NUMBER(10,0) COMMENT 'Tutor encargado de asesorar al alumno desde la aceptación de la solicitud de acceso hasta su matrícula',
        FECHA_ENVIO_DOCUM TIMESTAMP_NTZ(9),
        NUM_CREDITOS_APOR NUMBER(15,4),
        INTENCION VARCHAR(16777216),
        IDP_MODIF_INT NUMBER(10,0),

        ID_TRANSACCION_SIS VARCHAR(16777216),
        PRODUCTO_EDICION_SIS VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'

)COMMENT='Tabla que contiene los datos de las diversas solicitudes de acceso para cada uno de los estudiantes.'
;

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_CALIF_CONTINUADA_TEST (
        COD_CALIF_CONT VARCHAR(2),
        DESC_CALIFICACION VARCHAR(20),
        IND_ACTIVO VARCHAR(1),
        IND_PARTICIPA VARCHAR(1),
        IND_SUPERA VARCHAR(1),
        IND_MIGRACION_GATIB VARCHAR(1),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_CALIFICACIONES_TEST (
        COD_CALIFICACION VARCHAR(2),
        DESC_CALIFICACION VARCHAR(20),
        IND_SUPERA VARCHAR(1),
        IND_CONSUME_CONVOCATORIA VARCHAR(1),
        IND_NP VARCHAR(1),
        IND_MH VARCHAR(1),
        IND_AN VARCHAR(1),
        IND_CONVALIDA VARCHAR(1),
        IND_ADAPTA VARCHAR(1),
        VALOR_NUM_MINIMO NUMBER(15,4),
        VALOR_NUM_MAXIMO NUMBER(15,4),
        VALOR_NUM_ASOCIADO NUMBER(15,4),
        IND_PDTE_CALIF VARCHAR(1),
        IND_PARTICIPA VARCHAR(1),
        DESC_CORTA VARCHAR(2),
        IND_CALCULAR_NUMERICA VARCHAR(1),
        IND_NOTA_FINAL_EXPED VARCHAR(1),
        IDP_ULT_MODIF NUMBER(10,0),
        FECHA_ULT_MODIF TIMESTAMP_NTZ(9),
        VALOR_NUM_BECA NUMBER(15,4),
        VALOR_NUM_PE NUMBER(15,4),
        IND_TESIS VARCHAR(1),
        IND_CORRECTO_JUNTA VARCHAR(1),
        IND_MIGRACION_GATIB VARCHAR(1),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_CATEGORITZACIONS_TEST (
        CODI_CATEGORITZACIO VARCHAR(16777216),
        DESCRIPCIO VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_DESCRIPCIONES_TEST (
	CLAVE VARCHAR(100),
	COD_APLICACION VARCHAR(10),
	COD_IDIOMA VARCHAR(3),
	DESCRIPCION VARCHAR(2000),
	IND_MIGRACION_GATIB VARCHAR(1),
	NOM_CAMPO VARCHAR(30),
	NOM_TABLA VARCHAR(30),
	TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
	TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
	IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
	METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
	METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_DISTRIBUIDORS_TEST (
        SEQ_DISTRIBUIDOR NUMBER(38,0),
        DESCRIPCIO VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_ESTUD_TUTOR_HIST_TEST (
        ANY_ACAD_ALTA VARCHAR(5),
        ANY_ACAD_BAJA VARCHAR(5),
        DATA_CANVI TIMESTAMP_NTZ(9),
        IDP_TUTOR NUMBER(22,0),
        NUM_EXPEDIENTE NUMBER(22,0),
        TIPO_TUTOR VARCHAR(3),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_ESTUDIOS_TEST (
        COD_ESTUDIOS NUMBER(10,0),
        TIPO_DOCENCIA_DETALLE VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Relación de estudios.'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_EXP_ASIG_CALIFICACIONES_TEST (
        ANY_ACADEMICO VARCHAR(5),
        CALIF_NUM_CONT NUMBER(22,0),
        CALIF_NUM_CONT_FINAL NUMBER(22,0),
        CALIF_NUMERICA NUMBER(22,0),
        CALIF_NUMERICA_PUB NUMBER(22,0),
        CALIF_NUM_PRACTICA NUMBER(22,0),
        CALIF_NUM_PRES NUMBER(22,0),
        CALIF_NUM_PROP NUMBER(22,0),
        CALIF_NUM_TEORICA NUMBER(22,0),
        CALIF_PRACTICA VARCHAR(2),
        CALIF_TEORICA VARCHAR(2),
        COD_ASIGNATURA VARCHAR(8),
        COD_CALIF_CONF VARCHAR(2),
        COD_CALIF_CONT VARCHAR(2),
        COD_CALIF_CONT_FINAL VARCHAR(2),
        COD_CALIFICACION VARCHAR(2),
        COD_CALIFICACION_PUB VARCHAR(2),
        COD_CALIF_PRES VARCHAR(2),
        COD_CALIF_PROP VARCHAR(2),
        COD_EXAMEN NUMBER(22,0),
        IDP_CORRECTOR NUMBER(22,0),
        NUM_EXPEDIENTE NUMBER(22,0),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_EXP_ASIG_MATRICULAS_TEST (
        NUM_EXPEDIENTE NUMBER(10,0) NOT NULL,
        ANY_ACADEMICO VARCHAR(5) NOT NULL,
        COD_ASIGNATURA VARCHAR(8) NOT NULL,
        FECHA_ANULACION TIMESTAMP_NTZ(9),
        COD_AULA NUMBER(10,0),
        COD_TFC VARCHAR(8),
        IND_SOLO_EXAMEN VARCHAR(1),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_EXP_MATRICULAS_TEST (
        NUM_EXPEDIENTE NUMBER(10,0),
        ANY_ACADEMICO VARCHAR(16777216),
        NUM_MATRICULA NUMBER(10,0),
        ANY_ACAD_VALIDA VARCHAR(16777216),
        FECHA_ANULACION TIMESTAMP_NTZ(9),
        OBSERVACIONES VARCHAR(16777216),
        SELECCION_TRAMESA VARCHAR(16777216) COMMENT 'indica la elección del estudiante en la matrícula respecto a recibir tramesa de las asignaturas matrculadas con tramesa opcional. S: quiso tramesa, N: no quiso tramesa, NULL: no le salió a escoger',
        RESIDENCIA_ESPANYA VARCHAR(16777216) COMMENT 'Indica si el estudiante tiene la residencia oficial en España. Se informa en matrículas de estudiantes extracomunitarios. Valores posibles: S(I), N(O), T(RAMITE)',
        IND_MIGRACION_GATIB VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Matrículas o años académicos por expediente.'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_EXP_MATRICULAS_CATEGMAT_TEST (
        NUM_EXPEDIENTE NUMBER(10,0),
        ANY_ACADEMICO VARCHAR(16777216),
        NUM_MATRICULA NUMBER(10,0),
        CODIGO_CATEGORIZA VARCHAR(16777216),
        DESCRIPCION VARCHAR(16777216),
        NOMBRE_ENTIDAD VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_EXPEDIENTES_TEST (
        NUM_EXPEDIENTE NUMBER(10,0),
        IDP NUMBER(10,0),
        COD_PLAN VARCHAR(16777216),
        NUM_SOL_ACC NUMBER(10,0),
        NOTA_MEDIA NUMBER(15,4),
        ANY_ACAD_TITULO VARCHAR(16777216),
        NOTA_MEDIA_PUNTOS NUMBER(15,4) COMMENT 'Nota mitja de final de carrera per punts',
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla cabecera de expedientes'
;    

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_PERSONAS_ASIGNATURAS_TEST (
        IDP NUMBER(10,0) NOT NULL,
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_PLAN_ACCESOS_TEST (
        COD_PLAN VARCHAR(16777216),
	COD_CENTRO NUMBER(10,0),
        COD_OPC_ACC VARCHAR(16777216),
        COD_VIA_ACC VARCHAR(16777216),
        DESCRIPCION VARCHAR(16777216),
        IND_TITULADO VARCHAR(16777216) COMMENT 'Acceso con recargo',
        SITUACION_SOL_ORIG VARCHAR(16777216) COMMENT 'Situación original en la que se genera la solicitud de acceso',
        IND_ENTREVISTA VARCHAR(16777216) COMMENT 'Permite solicitar entrevista',
        IND_MIGRACION_GATIB VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que contiene las diversas formas de acceder a cada uno de los centros/planes/puntos de entrada, exig'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_PLAN_DATOS_TEST (
        COD_PLAN VARCHAR(16777216),
        NUM_CREDITOS_TEORICOS NUMBER(15,4),
        NUM_CREDITOS_PRACTICOS NUMBER(15,4),
        MIN_CREDITOS_CLASE_TM NUMBER(15,4),
        MIN_CREDITOS_CLASE_OF NUMBER(15,4),
        MIN_CREDITOS_CLASE_PI NUMBER(15,4),
        MIN_CREDITOS_CLASE_LA NUMBER(15,4),
        MIN_CREDITOS_CLASE_C NUMBER(15,4),
        IND_TITULACIONES_PROPIAS VARCHAR(16777216),
        ESTADO_PLAN VARCHAR(16777216),
        NUM_VERSION_PLAN NUMBER(10,0),
        DESCRIPCION VARCHAR(16777216),
        COD_ESTUDIOS NUMBER(10,0),
        FECHA_PUBLICA_OFICIAL TIMESTAMP_NTZ(9),
        DESC_PUBLICA_OFICIAL VARCHAR(16777216),
        CICLO_PLAN NUMBER(10,0),
        IND_CREDITOS_ASIGNATURAS VARCHAR(16777216),
        MIN_CREDITOS_ASIGNATURAS NUMBER(15,4),
        MAX_CREDITOS_ASIGNATURAS NUMBER(15,4),
        CONTA_ELEMENTOS NUMBER(10,0),
        OBSERVACIONES VARCHAR(16777216),
        NUM_CONTROL NUMBER(10,0),
        COD_ESTUDIOS_MEC VARCHAR(16777216),
        IND_VALIDA_INICIO_EXP VARCHAR(16777216),
        MIN_CREDITOS_MEC NUMBER(15,4),
        COD_AREA VARCHAR(16777216),
        NUM_EDICION NUMBER(10,0),
        DESCRIPCION_CER VARCHAR(16777216),
        NUM_CREDITOS_CICLO2 NUMBER(15,4),
        ES_CICLO_12 VARCHAR(16777216) COMMENT 'Indica si el plan de estudios es del primer y segundo ciclo o no',
        TIPO_EDUCACION VARCHAR(16777216),
        IND_VISIBLE_EGIA VARCHAR(16777216),
        IND_CONSECUCION_PARCIAL VARCHAR(16777216) COMMENT 'indica si el plan puede contener o no consecución parcial',
        RATIO_CONVERSIO NUMBER(5,2),
        RATIO_FIDELIZA NUMBER(5,2),
        MAX_ESTUD_TUTOR NUMBER(5,0),
        ID_PROG_BOF NUMBER(10,0),
        IND_INTERUNIVERSITARIO VARCHAR(16777216),
        IDIOMA_DOCENCIA VARCHAR(16777216),
        IND_MIGRACION_GATIB VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Datos de cabecera de un plan de estudios'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_SOL_ANULA_MAT_TEST (
        ANY_ACADEMICO VARCHAR(16777216),
        NUM_EXPEDIENTE NUMBER(10,0),
        NUM_MATRICULA NUMBER(10,0),
        COD_MOTI_ANULACION VARCHAR(16777216),
        FECHA_SOLICITUD TIMESTAMP_NTZ(9),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que recoge las solicitudes recibidas desde WEB o cualquier proceso externo a GAT correspondientes a'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.GAT_VIAS_ACC_TEST (
        COD_VIA_ACC VARCHAR(16777216),
        DESCRIPCION VARCHAR(16777216),
        IND_MIGRACION_GATIB VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que recoge la descripción de cada una de las vías de acceso de Preinscripción. Teóricamente, ninguna'
;

create or replace  TABLE DB_UOC_PROD.DD_OD.PROGRAM_TEST (
        ID_BOF NUMBER(38,0) COMMENT 'Indica l''ID del programa provinent de BOF',
        DES_DENOMINACIO_CA VARCHAR(16777216) COMMENT 'Indica el nom del programa acadèmic en català',
        DES_ESTAT_CA VARCHAR(16777216) COMMENT 'Indica la descripció de l''estat del programa en català',
        DES_VICEGERENCIA_CA VARCHAR(16777216) COMMENT 'Indica la vicegerència responsable del programa en català',
        DES_TIPOLOGIA_CA VARCHAR(16777216) COMMENT 'Indica la descripció de la tipologia del programa en català',
	DES_TOTP VARCHAR(16777216) COMMENT 'Indica si la titulació és pròpia o oficial',
	DES_INICIATIVA VARIANT COMMENT 'Indica el conjunt de programes al qual pertany en format JSON',
        DES_UNITAT_ORGANICA_CA VARCHAR(16777216) COMMENT 'Indica la descripció de la unitat orgànica del programa en català',
        DES_NIVELL_ACADEMIC_CA VARCHAR(16777216) COMMENT 'Indica la descripció del nivell acadèmic en català',
        DES_NIVELL_MECES_CA VARCHAR(16777216) COMMENT 'Indica la descripció del nivell MECES en català',
        DES_LEGISLACIO_CA VARCHAR(16777216) COMMENT 'Indica la descripció de la legislació que està subjecte el programa en català',
        ECTS_A_SUPERAR NUMBER(38,0) COMMENT 'Indica el nombre de ECTS a superar',
        ECTS_DESGLOSSAT_PER_TIPOLOGIA VARIANT COMMENT 'Indica els ECTS a desplegar i desglossats per tipologia en format JSON i en varis idiomes',
        ECTS_A_DESPLEGAR NUMBER(38,0) COMMENT 'Indica el nombre de ECTS a desplegar',
        DES_DIRECTOR_DE_PROGRAMA VARIANT COMMENT 'Indica les dades del director del programa en format JSON',
        DES_RESPONSABLE_ACADEMIC_CA VARCHAR(16777216) COMMENT 'Indica el nom complet del responsable acadèmic',
        DES_MANAGER_DE_PROGRAMA VARIANT COMMENT 'Indica les dades del mànager del programa en format JSON',
        DES_COORDINADORA_CA VARCHAR(16777216) COMMENT 'Indica la descripció de l''entitat coordinadora en català',
        DES_ARREL_PROGRAMA VARCHAR(16777216) COMMENT 'Indica els programes arrel als que pertany, indica si està relacionat amb N o S',
        DES_ESTAT_PRIM_REG VARCHAR(16777216) COMMENT 'En definició',
        DES_ESTAT_SOLICITUD VARCHAR(16777216) COMMENT 'Aprovat CdD, No aprovat CdD',
        DES_ESTAT_PROGRAMA_DISSENY_TITULACIONS_INICI VARCHAR(16777216) COMMENT 'En tràmit de verificació',
        DES_ESTAT_RESULTAT_INFORME_FINAL_VERIFICACIO_AQU VARCHAR(16777216) COMMENT 'Informe final favorable, AQU, Informe final desfavorable AQU',
        DES_ESTAT_PROGRAMA_DISSENY_TITULACIONS_FI VARCHAR(16777216) COMMENT 'Programa Verificat',
        DES_ESTAT_DISSENY_TITULACIONS VARCHAR(16777216) COMMENT 'Autoritzat DE, No autoritzat DE',
        DATA_PREVISIO_IMPLANTACIO_MES NUMBER(38,0) COMMENT 'Indica el mes de la previsió de la implantació del programa',
        DATA_PREVISIO_IMPLANTACIO_ANY NUMBER(38,0) COMMENT 'Indica l''any de la previsió de la implantació del programa',
        DATA_IMPLANTACIO_REAL_MES NUMBER(38,0) COMMENT 'Indica el mes real de la implantació del programa',
        DATA_IMPLANTACIO_REAL_ANY NUMBER(38,0) COMMENT 'Indica l''any real de la implantació del programa',
        DES_ESTAT_PROGRAMA_ACREDITAR_TITULACIONS VARCHAR(16777216) COMMENT 'Programa Acreditat, No acreditat',
        DES_ESTAT_SOLICITUD_EXTINCIO_CICLE_VIDA VARCHAR(16777216) COMMENT 'En extinció / Extingit',
        TS_CARGA_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de càrrega de dades',
        TS_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de les dades',
        TS_DATA_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Indica la data de processament de les dades',
        DES_INICIATIVA_CA VARCHAR(16777216) COMMENT 'Indica el conjunt de programes al qual pertany en català',
        DATA_DE_LINFORME_FINAL_MODIFICACIO_AQU DATE COMMENT 'Indidca la data de l''informe final modificació AQU',
        DATA_VERIFICACIO DATE COMMENT 'Data de la resolució del conssell d''universitats',
        DATA_EXTINCIO DATE COMMENT 'Indica la data del final de l''extinció del programa',
        DATA_INICI_EXTINCIO DATE COMMENT 'Indica la data de l''inici de l''extinció del programa'
)COMMENT='Taula que conté l''última versió actualitzada de tots els programas que s''han guardat al sistema'
;

create  or replace TABLE DB_UOC_PROD.DD_OD.PROGRAM_RELACIONES_TEST (
        ID_BOF NUMBER(38,0) COMMENT 'Indica l''ID del programa associat a les relacions',
        ID_BOF_REL NUMBER(38,0) COMMENT 'Indica l''ID del programa amb el que està relacionat',
        DES_RELACION_CA VARCHAR(16777216) COMMENT 'Descripció de la relació en català',
	DES_RELACION VARIANT COMMENT 'Descripció de la relació en format JSON',
        TS_CARGA_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de càrrega de dades',
        TS_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de les dades',
        TS_DATA_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Indica la data de processament de les dades',
        RELACION_ANY NUMBER(38,0) COMMENT 'Any en que es va crear la relació',
        RELACION_MES NUMBER(38,0) COMMENT 'Mes en que es va crear la relació'
)COMMENT='Taula que conté relacions dels programes que han estat actualitzats al sistema'
;

create  TABLE DB_UOC_PROD.DD_OD.STAGE_DOCENCIA_TEST (
        ID_DOCENCIA NUMBER(20,0) autoincrement start 1 increment 1 noorder COMMENT 'Clau subrogada que identifica de forma unica els registres de la taula.',
        NUM_EXPEDIENT NUMBER(10,0),
        SUPER_EXPEDIENT NUMBER(10,0),
        NUM_MATRICULA NUMBER(10,0),
        IDP NUMBER(10,0),
        NACIONALITAT VARCHAR(256),
        PAIS_NAIXEMENT VARCHAR(256),
        PAIS_RESIDENCIA VARCHAR(256),
        CODI_POSTAL VARCHAR(5),
        IND_LOCALITZACIO NUMBER(4,0),
        COD_PLA VARCHAR(16777216),
        TITULACIO_PROPIA VARCHAR(1),
        TIPUS_DOCENCIA VARCHAR(5),
        VIA_ACCES VARCHAR(254),
        OPCIO_ACCES VARCHAR(254),
        IDP_TUTOR NUMBER(10,0),
        TIPUS_TUTOR VARCHAR(3),
        NUM_SOL_ACC NUMBER(10,0),
        NOTA_MITJANA NUMBER(15,4),
        NOTA_MITJANA_PUNTS NUMBER(15,4),
        ANY_ACAD_TITOL VARCHAR(16777216),
        ANY_ACADEMIC VARCHAR(16777216),
        ANY_ACAD_VALIDA VARCHAR(16777216),
        COD_ASSIGNATURA VARCHAR(8),
        ASSIGNATURA_CURSADA NUMBER(1,0),
        NUM_CREDITS NUMBER(4,1),
        NUM_CREDITS_TEORICS NUMBER(3,1),
        NUM_CREDITS_PRACTICS NUMBER(3,1),
        ASSIGNA_CLASE VARCHAR(1),
        COD_AULA NUMBER(10,0),
        COD_TFC VARCHAR(8),
        IND_SOLS_EXAMEN VARCHAR(1),
        QUALIF_NUM_CONT NUMBER(22,2),
        QUALIF_NUM_CONT_FINAL NUMBER(22,2),
        QUALIF_NUMERICA NUMBER(22,2),
        QUALIF_NUMERICA_PUB NUMBER(22,2),
        QUALIF_NUM_PRACTICA NUMBER(22,2),
        QUALIF_NUM_PRES NUMBER(22,2),
        QUALIF_NUM_PROP NUMBER(22,2),
        QUALIF_NUM_TEORICA NUMBER(22,2),
        QUALIF_PRACTICA VARCHAR(2),
        QUALIF_TEORICA VARCHAR(2),
        COD_QUALIF_CONF VARCHAR(2),
        COD_QUALIF_CONT VARCHAR(2),
        COD_QUALIF_CONT_FINAL VARCHAR(2),
        COD_QUALIFICACIO VARCHAR(2),
        IND_SUPERA VARCHAR(1),
        COD_QUALIFICACIO_PUB VARCHAR(2),
        COD_QUALIF_PRES VARCHAR(2),
        COD_QUALIF_PROP VARCHAR(2),
        COD_EXAMEN NUMBER(22,0),
        IDP_CORRECTOR NUMBER(22,0),
        MATRICULA_ANULADA NUMBER(1,0),
        ASSIGNATURA_ANULADA NUMBER(1,0),
        ASSIGNATURA_CONVALIDADA NUMBER(1,0),
        SEC_SOLICITUD NUMBER(10,0),
        NUM_RECONEIXEMENT NUMBER(5,0),
        DATA_NAIXEMENT TIMESTAMP_NTZ(9),
        CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio.',
        UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio.'
);

create or replace  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_CODIGOS_POSTALES_TEST (
        COD_POBLACION NUMBER(22,0),
        COD_POSTAL VARCHAR(5),
        DESC_LOCALIZACION VARCHAR(60),
        FECHA_BAJA TIMESTAMP_NTZ(9),
        FECHA_CREACION TIMESTAMP_NTZ(9),
        FECHA_MODIFICACION TIMESTAMP_NTZ(9),
        IDP_BAJA NUMBER(22,0),
        IDP_CREACION NUMBER(22,0),
        IDP_MODIFICACION NUMBER(22,0),
        IND_LOCALIZACION NUMBER(22,0),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create TABLE DB_UOC_PROD.DD_OD.TERCERS_COMARCAS_TEST (
        COD_COMUNIDAD NUMBER(10,0) NOT NULL,
        COD_COMARCA NUMBER(10,0) NOT NULL,
        DESCRIPCION VARCHAR(30) NOT NULL,
        IDP_CREACION NUMBER(10,0),
        FECHA_CREACION VARCHAR(16777216),
        IDP_MODIFICACION NUMBER(10,0),
        FECHA_MODIFICACION VARCHAR(16777216),
        IDP_BAJA NUMBER(10,0),
        FECHA_BAJA VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_COMUNIDADES_TEST (
        COD_COMUNIDAD NUMBER(10,0) NOT NULL,
        DESCRIPCION VARCHAR(30) NOT NULL,
        IDP_CREACION NUMBER(10,0),
        FECHA_CREACION TIMESTAMP_NTZ(9),
        IDP_MODIFICACION NUMBER(10,0),
        FECHA_MODIFICACION TIMESTAMP_NTZ(9),
        IDP_BAJA NUMBER(10,0),
        FECHA_BAJA TIMESTAMP_NTZ(9),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_DATOS_PERSONAS_TEST (
        IDP NUMBER(10,0),
        DNI VARCHAR(16777216),
        APELLIDO1 VARCHAR(16777216),
        APELLIDO2 VARCHAR(16777216),
        NOMBRE VARCHAR(16777216),
        FECHA_NACIM TIMESTAMP_NTZ(9),
        COD_PAIS_NACIM VARCHAR(16777216),
        SEXO VARCHAR(16777216),
        NUM_SEGUR_SOCIAL VARCHAR(16777216),
        COD_PAIS_NACION VARCHAR(16777216),
        DNI_COMPACTADO VARCHAR(16777216),
        FECHA_EXPEDICION_DNI TIMESTAMP_NTZ(9),
        FECHA_INSERCION TIMESTAMP_NTZ(9),
        FECHA_ULT_MODIF TIMESTAMP_NTZ(9),
        TELEFONO1 VARCHAR(16777216),
        TELEFONO2 VARCHAR(16777216),
        FAX VARCHAR(16777216),
        E_MAIL VARCHAR(16777216),
        TIPO_PERSONA VARCHAR(16777216),
        COD_IDIOMA_COLABORADOR VARCHAR(16777216),
        PREFIJO_TELEFONO1 VARCHAR(16777216),
        PREFIJO_TELEFONO2 VARCHAR(16777216),
        PREFIJO_FAX VARCHAR(16777216),
        COD_IDIOMA_RELACION VARCHAR(16777216) COMMENT 'Idioma segun el código postal',
        ROBINSON VARCHAR(16777216) COMMENT 'Si està activat indica que la persona no vol rebre cap notificació no acadèmica',
        IND_SANCIONADO_ECONOMIA VARCHAR(16777216) COMMENT 'Indica si la persona està sancionada per economia a causa d''un impagament',
        COMPACTADO_X_ALIAS VARCHAR(16777216),
        VAT_NUMBER VARCHAR(16777216) COMMENT 'Número de identificación de IVA',
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que recoge la información personal , completándose con DIRECCIONES_PERSONAS, DATOS_PAGO_PERSONAS y o.'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_DIRECCIONES_TEST (
        NUM_DIRECCION NUMBER(10,0),
        COD_PAIS VARCHAR(16777216),
        COD_POSTAL VARCHAR(16777216),
        IND_LOCALIZACION NUMBER(10,0),
        IDP_ULT_MODIF NUMBER(10,0) COMMENT 'Usuari de modificació',
        FECHA_ULT_MODIF TIMESTAMP_NTZ(9) COMMENT 'Data de modificació',
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que contiene las diversas direcciones que puede tener un estudiantes: de envío, de curso y habitual.'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_PAISES_TEST (
        COD_PAIS VARCHAR(16777216),
        DESCRIPCION VARCHAR(16777216),
        IND_CONVENIO_SEGURO VARCHAR(16777216),
        IND_BECA_RE VARCHAR(16777216),
        IND_UE VARCHAR(16777216),
        COD_PAIS_SS NUMBER(10,0),
        DESC_NACIONALIDAD VARCHAR(16777216),
        IND_HABITUAL VARCHAR(16777216),
        COD_PAIS_ISO_3166_A3 VARCHAR(16777216),
        IND_ACTIVO VARCHAR(16777216),
        FECHA_BAJA TIMESTAMP_NTZ(9) COMMENT 'Data de baixa',
        IND_CONVENIO_LA_HAYA VARCHAR(16777216) COMMENT 'Indicador de si el paÃ­s pertence al convenio de La Haya',
        IND_ESPACIO_SEPA VARCHAR(16777216),
        IND_PAIS_PRIORITARIO VARCHAR(16777216) COMMENT 'Indicador de si es un país prioritario',
        COD_DIV_TERRITORIAL NUMBER(10,0) COMMENT 'Código de la división territorial al que pertenece el país',
        IND_EXCLUIR_EXTRACOMUNITARIO VARCHAR(16777216),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Tabla que contiene los datos de un país.'
;

create or replace TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_POBLACIONES_TEST (
        COD_POBLACION NUMBER(10,0) NOT NULL,
        DESC_POBLACION VARCHAR(60) NOT NULL,
        COD_PROVINCIA NUMBER(10,0) NOT NULL,
        COD_COMUNIDAD NUMBER(10,0) NOT NULL,
        COD_COMARCA NUMBER(10,0) NOT NULL,
        COD_POBLACION_MEC NUMBER(10,0) NOT NULL,
        IDP_CREACION NUMBER(10,0),
        FECHA_CREACION TIMESTAMP_NTZ(9),
        IDP_MODIFICACION NUMBER(10,0),
        FECHA_MODIFICACION TIMESTAMP_NTZ(9),
        IDP_BAJA NUMBER(10,0),
        FECHA_BAJA TIMESTAMP_NTZ(9),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_PROVINCIAS_TEST (
        COD_PROVINCIA NUMBER(10,0) NOT NULL,
        DESCRIPCION VARCHAR(30) NOT NULL,
        COD_COMUNIDAD NUMBER(10,0) NOT NULL,
        IDP_CREACION NUMBER(10,0),
        FECHA_CREACION TIMESTAMP_NTZ(9),
        IDP_MODIFICACION NUMBER(10,0),
        FECHA_MODIFICACION TIMESTAMP_NTZ(9),
        IDP_BAJA NUMBER(10,0),
        FECHA_BAJA TIMESTAMP_NTZ(9),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_REF_DIRECCIONES_TEST (
        COD_ELEMENTO NUMBER(10,0),
        NUM_DIRECCION NUMBER(10,0),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
)COMMENT='Recoge la asociación entre una persona o entidad de la Universidad y sus diferentes direcciones.'
;

create  TRANSIENT TABLE DB_UOC_PROD.DD_OD.TERCERS_TIPO_DOCUMENTOS_TEST (
        CODIGO VARCHAR(1),
        DESCRIPCION VARCHAR(65),
        TS_CARGA TIMESTAMP_NTZ(9) COMMENT 'Fecha de carga del registro',
        TS_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Fecha de procesamiento del registro',
        IND_LAST NUMBER(38,0) COMMENT 'Indica si pertenece a la ultima carga',
        METADATA_FILENAME VARCHAR(16777216) COMMENT 'Nombre del archivo perteneciente del metadato',
        METADATA_FILE_LAST_MODIFIED TIMESTAMP_NTZ(9) COMMENT 'Fecha de modificacion del metadato'
);

-- POST

create  TABLE DB_UOC_PROD.DD_OD.STAGE_DOCENCIA_POST_TEST (
	ID_DOCENCIA NUMBER(20,0),
	ID_SEMESTRE NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_SEMESTRE.',
	ID_ASSIGNATURA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_ASSIGNATURA.',
	ID_QUALIFICACIO NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_QUALIFICACIO.',
	ID_QUALIFICACIO_CONTINUADA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_QUALIFICACIO_CONTINUADA.',
	ID_EXPEDIENT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_EXPEDIENT.',
	ID_MATRICULA NUMBER(16,0) COMMENT 'Clau unica i numerica que identifica els registres de la dimensio matricula',
	ID_PORTAFOLI_PA NUMBER(16,0) COMMENT 'Clau unica i numerica que identifica els registres de la dimensio portafoli producte academic',
	DIM_PAIS_NACIONALITAT_KEY VARCHAR(256),
	ID_PAIS_NACIONALITAT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_NACIONALITAT.',
	DIM_EXPEDIENT_KEY NUMBER(10,0),
	DIM_MATRICULA_KEY NUMBER(16,0) COMMENT 'Codi unic de matricula: Piolin -> num_matricula  Gat -> CONCAT(em.num_expediente, em.any_academico, em.num_matricula).',
	DIM_PORTAFOLI_PA_KEY VARCHAR(16) COMMENT 'Codi unic de portafoli producte academic',
	ID_PERSONA_ESTUDIANT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PERSONA_ESTUDIANT, que es una vista de la DIM_PERSONA filtrada pels usuaris que disposen del ROL estudiant.',
	DIM_PAIS_NAIXEMENT_KEY VARCHAR(256),
	ID_PAIS_NAIXEMENT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_NAIXEMENT, que és una vista de la DIM_PAIS_RESIDENCIA sense les ubicacions geogràfiques inferiors a país.',
	DIM_PAIS_RESIDENCIA_KEY VARCHAR(256),
	ID_PAIS_RESIDENCIA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_RESIDENCIA.',
	DIM_ACCES_KEY VARCHAR(500),
	ID_ACCES NUMBER(16,0),
	DIM_PERSONA_TUTOR_KEY VARCHAR(20),
	ID_PERSONA_TUTOR NUMBER(16,0),
	IDP_TUTOR NUMBER(10,0),
	TIPUS_TUTOR VARCHAR(3),
	SUPER_EXPEDIENT NUMBER(10,0),
	IDP NUMBER(10,0),
	NUM_SOL_ACC NUMBER(10,0),
	NOTA_MITJANA NUMBER(15,4),
	NOTA_MITJANA_PUNTS NUMBER(15,4),
	ANY_ACAD_TITOL VARCHAR(16777216),
	ANY_ACADEMIC VARCHAR(16777216),
	ANY_ACAD_VALIDA VARCHAR(16777216),
	COD_ASSIGNATURA VARCHAR(8),
	ASSIGNATURA_CURSADA NUMBER(1,0),
	NUM_CREDITS NUMBER(4,1),
	NUM_CREDITS_TEORICS NUMBER(3,1),
	NUM_CREDITS_PRACTICS NUMBER(3,1),
	NUM_MATRICULAS_ASSIGNATURA NUMBER(3,0),
	TIPUS_ESTUDIANT_ASSIGNATURA VARCHAR(256),
	SEMESTRE_RELATIU_EXPEDIENT NUMBER(3,0),
	TIPUS_MATRICULA VARCHAR(256),
	SEMESTRE_RELATIU_SUPER_EXPEDIENT NUMBER(3,0),
	SEMESTRE_RELATIU_UOC NUMBER(3,0),
	TIPUS_MATRICULA_UOC VARCHAR(256),
	ASSIGNA_CLASE VARCHAR(1),
	COD_AULA NUMBER(10,0),
	COD_TFC VARCHAR(8),
	IND_SOLS_EXAMEN VARCHAR(1),
	QUALIF_NUM_CONT NUMBER(22,1),
	QUALIF_NUM_CONT_FINAL NUMBER(22,2),
	QUALIF_NUMERICA NUMBER(22,2),
	QUALIF_NUMERICA_PUB NUMBER(22,2),
	QUALIF_NUM_PRACTICA NUMBER(22,2),
	QUALIF_NUM_PRES NUMBER(22,2),
	QUALIF_NUM_PROP NUMBER(22,2),
	QUALIF_NUM_TEORICA NUMBER(22,2),
	QUALIF_PRACTICA VARCHAR(2),
	QUALIF_TEORICA VARCHAR(2),
	COD_QUALIF_CONF VARCHAR(2),
	DIM_QUALIFICACIO_CONTINUADA_KEY VARCHAR(2),
	COD_QUALIF_CONT VARCHAR(2),
	DIM_QUALIFICACIO_KEY VARCHAR(2),
	IND_SUPERA VARCHAR(1),
	SUPERA_ASSIGNATURA NUMBER(1,0),
	NO_SUPERA_ASSIGNATURA NUMBER(1,0),
	COD_QUALIFICACIO_PUB VARCHAR(2),
	COD_QUALIF_PRES VARCHAR(2),
	COD_QUALIF_PROP VARCHAR(2),
	COD_EXAMEN NUMBER(22,0),
	IDP_CORRECTOR NUMBER(22,0),
	MATRICULA_ANULADA NUMBER(1,0),
	ASSIGNATURA_ANULADA NUMBER(1,0),
	ASSIGNATURA_CONVALIDADA NUMBER(1,0),
	EDAT_RELATIVA NUMBER(4,0),
	GRUP_EDAT VARCHAR(15),
	GRUP_EDAT_2 VARCHAR(15),
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
);

create  TABLE DB_UOC_PROD.DD_OD.TUTOR_UNIC_PERIODE_HIST_TEST (
	NUM_EXPEDIENT NUMBER(20,0) NOT NULL COMMENT 'Número expedient de l''estudiant',
	IDP_TUTOR NUMBER(20,0) NOT NULL COMMENT 'idp del tutor associat a l''expedient de l''estudiant',
	ANY_ACAD_ALTA NUMBER(6,0) NOT NULL COMMENT 'Semestre en què el tutor comença a exercir de tutor sobre l''estudiant',
	ANY_ACAD_BAJA NUMBER(6,0) COMMENT 'Semestre en que el tutor deixa d''exerçir de tutor sobre l''estudiant. Si el valor es null vol dir que encara es el seu tutor',
	TIPO_TUTOR VARCHAR(3) COMMENT 'Indica si el tutor es d''inici (INI) o seguiment (CON)',
	DATA_CANVI TIMESTAMP_NTZ(9) COMMENT 'Data on es produeix un canvi a la fila',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Aquesta taula conte el tutor definitiu d''un número d''expedient per a un període definit pel camp any_acad_alta i any_acad_baja. Aquesta taula no recull els canvis que es produeixen en un mateix període que poden ser deguts a reassignacions de tutor per sobre càrrega o finalització de contracte'
;

--DM

create  TABLE DB_UOC_PROD.DD_OD.DIM_ACCES_TEST (
	ID_ACCES NUMBER(16,0) NOT NULL COMMENT 'Clau única i numèrica que identifica els registres de la dimensió viàs opc acces',
	DIM_ACCES_KEY VARCHAR(500) NOT NULL COMMENT 'Es la clau primaria de la taula',
	TIPO_DOCENCIA VARCHAR(5) NOT NULL,
	ACCES_TITOL_PROPI VARCHAR(2) NOT NULL,
	TIPO_ACCES VARCHAR(256) NOT NULL COMMENT 'Identifica si es tracta de accés a grau',
	VIA_ACCES VARCHAR(256) NOT NULL COMMENT 'Via accés del estudiant a la universitat',
	OPCIO_ACCES VARCHAR(256) NOT NULL COMMENT 'Pendent definició',
	ACCES_SUE VARCHAR(3) NOT NULL COMMENT 'Identifica sí és el seu primer accés al sistema universitàri español: classificació mitjançant via accés',
	VIA_SIIU VARCHAR(256) NOT NULL COMMENT 'Per cada combinatòria entre via i opció classifica la seva equivalència en la via accés definida pel SIIU.',
	VIA_OFICINA VARCHAR(256) NOT NULL COMMENT 'Per cada combinatòria entre via i opció classifica la seva equivalència en la via accés definida per la oficina de preinscripció',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
);

create or replace TABLE DB_UOC_PROD.DD_OD.DIM_ASSIGNATURA_TEST (
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
    DESC_ESTUDIS_AREA VARCHAR(2000) COMMENT 'Descripcio del area de estudios, usada para el area Recurs de aprenentatge, viene de la tabla desc_asignaturas.',
	TIPUS_EDUCACIO VARCHAR(8),
	TIPUS_DOCENCIA_DETALL VARCHAR(8),
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les assignatures ofertades o impartides a la UOC.'
; 

create  TABLE DB_UOC_PROD.DD_OD.DIM_EXPEDIENT_TEST (
	ID_EXPEDIENT NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio expedient',
	DIM_EXPEDIENT_KEY NUMBER(10,0) NOT NULL COMMENT 'Codi unic d expedient que proporciona l enllaç amb la resta d objectes d expedient.',
	COD_CENTRE NUMBER(16,0) COMMENT 'Codi de centre assignat a l expedient',
	CODI_PLA VARCHAR(16) COMMENT 'Codi de pla assignat a l expedient',
	PROVINENT_ADAPTACIO VARCHAR(16) NOT NULL COMMENT 'Permet identificar si un expedient prové d''un expedient previ que ha sigut adaptat',
	TIPOLOGIA_TITOL_PREVI VARCHAR(50) COMMENT 'Si un expedient prové d''un expedient previ adaptat permet identificar quina era la tipologia de titulació d''aquell expedient.',
	PROVINENT_CANVI_CAMPUS VARCHAR(16) NOT NULL COMMENT 'Permet identificar si un expedient prové d''un expedient previ que ha canviat de campus',
	NUMERO_VERSIO_PLA NUMBER(16,0) COMMENT 'Numero de versio assignada al pla vigent',
	SEMESTRE_APERTURA VARCHAR(6) COMMENT 'Camp numeric que identifica el semestre d apertura de l expedient de l alumne.',
	CODI_NODE_ARREL VARCHAR(16) COMMENT 'Codi arrel de l expedient.',
	IND_ESTAT_EXPEDIENT VARCHAR(2) COMMENT 'Codi d estat de l expedient.',
	IND_INCONSISTENT VARCHAR(2) COMMENT 'Indica si el codi d estat de l expedient es inconsistent.',
	IND_CARREGA_INICIAL VARCHAR(2),
	IND_SITUACIO NUMBER(2,0),
	OBSERVACIONS VARCHAR(4000),
	NUM_CONTROL NUMBER(16,0),
	NOTA_MITJANA NUMBER(16,4),
	SEMESTRE_TITULACIO VARCHAR(6),
	MOTIU_ESTAT VARCHAR(2),
	IND_ESTAT_EXPEDIENT_2 VARCHAR(2),
	NUM_EXPEDIENT_REL_1 VARCHAR(16),
	NUM_EXPEDIENT_REL_2 VARCHAR(16),
	NOTA_MITJANA_PUNTS NUMBER(16,4),
	SUPER_EXPEDIENT_V1 NUMBER(16,0) NOT NULL COMMENT 'Codi que permet traçar els expedients relacionats entre si per canvi de campus o adaptacions',
	CREATION_DATE TIMESTAMP_NTZ(9) COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant dels expedients academics per a qualsevol projecte de disponibilitzacio'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_MATRICULA_TEST (
	ID_MATRICULA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio matricula',
	DIM_MATRICULA_KEY NUMBER(16,0) NOT NULL COMMENT 'Codi unic de matricula: Piolin -> num_matricula  Gat -> CONCAT(em.num_expediente, em.any_academico, em.num_matricula)',
	ORIGEN VARCHAR(6) NOT NULL COMMENT 'GAT/PIOLIN',
	DATA_MATRICULA TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data en la que s ha consolidat una matricula. En cas que una matricula s anul.li i es reactivi, la data matricula sera l original',
	DATA_ANULACIO TIMESTAMP_NTZ(9) COMMENT 'Data en la que s anul.la una matricula',
	COD_MOTIU_ANULACIO VARCHAR(8) COMMENT 'Indica el codi d anul.lacio de la matricula',
	COD_CATEGORITZACIO VARCHAR(64) COMMENT 'Identificador del codi de categoritzacio de la matricula',
	DES_CATEGORITZACIO VARCHAR(254) COMMENT 'Descripcio del codi de categoritzacio de la matricula',
	DES_ENTITAT VARCHAR(128),
	DES_DISTRIBUIDOR VARCHAR(128),
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les matricules per a qualsevol projecte de disponibilitzacio'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_PAIS_RESIDENCIA_TEST (
	ID_PAIS_RESIDENCIA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio residencia',
	DIM_PAIS_RESIDENCIA_KEY VARCHAR(100) NOT NULL,
	CONTINENT VARCHAR(254) NOT NULL COMMENT 'Continent al que pertany el pais. Els paisos amb ND son paisos o que no son propiament paisos, no estan reconeguts o ja no existeixen',
	REGIO VARCHAR(254) NOT NULL COMMENT 'regio al que pertany el pais. Els paisos amb ND son paisos o que no son propiament paisos, no estan reconeguts o ja no existeixen',
	CAT_ESP_RESTA VARCHAR(15) NOT NULL COMMENT 'Residencia clasificada en catalunya, resta espanya y resta mon',
	CAT_ESP_CONTINENT_REG VARCHAR(20) COMMENT 'Residencia clasificada en Catalunya,\tEspanya, Europa, Llatinoamèrica, Nordamèrica, Àfrica, Àsia, Oceania',
	PAIS VARCHAR(256) NOT NULL COMMENT 'Literal del país associat al codi UOC',
	COD_PAIS_ISO VARCHAR(3) COMMENT 'Codi ISO asociat al pais',
	DATA_BAIXA_PAIS TIMESTAMP_NTZ(9) COMMENT 'Data on es va donar de baixa el país',
	PAIS_CONVENI_HAIA VARCHAR(2) NOT NULL COMMENT 'Identifica si el país pertany al conveni de la Haia',
	PAIS_ESPAI_SEPA VARCHAR(2) NOT NULL COMMENT 'Identifica si el país pertany al espai sepa',
	PAIS_DIV_TERRITORIAL NUMBER(2,0) NOT NULL COMMENT 'Divisió territorial a la qual pertany el país',
	COMUNITAT_AUTONOMA VARCHAR(256) COMMENT 'Té informat la comunitat autònoma si el país és Espanya',
	PROVINCIA VARCHAR(256) COMMENT 'Te informat la provincia si el país és Espanya',
	COMARCA VARCHAR(256) COMMENT 'Te informat la comarca si el país és Espanya',
	POBLACIO VARCHAR(256) COMMENT 'Te informat la població si el país és Espanya',
	COD_POBLACIO_MEC VARCHAR(8) COMMENT 'Te informat el codi de població mec si el pais es Espanya. Es el codi amb el que treballa el INE',
	COD_POSTAL VARCHAR(5) COMMENT 'Te informat el codi postal si el país es Espanya. Un CP pot pertànyer a diferents poblacions',
	IND_LOCALITZACIO NUMBER(4,0) COMMENT 'Te informat el codi localització asociat a un codi postal si el país es espanya. La combinació de CP i ind_localització es unica',
	LOCALIZACIO VARCHAR(256) COMMENT 'Te informat la localització si el país es Espanya',
	DATA_BAIXA_LOCALITZACIO TIMESTAMP_NTZ(9) COMMENT 'Te informat la data  en que una localització es va donar de baixa si el país es Espanya',
	DATA_MODIFICA_LOCALITZACIO TIMESTAMP_NTZ(9) COMMENT 'Te informat la data en que una localització vaser modificara si el país es Espanya',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les residencies per a qualsevol equip de disponibilització'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_PERSONA_TEST (
	ID_PERSONA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau única que identifica els registres de la dim persona',
	DIM_PERSONA_KEY NUMBER(10,0) NOT NULL COMMENT 'Identificador UOC de la persona',
	ID_PERSONA_UNEIX_30 VARCHAR(30) NOT NULL COMMENT 'Identificador UOC de la persona amb format UNEIX',
	AMB_DIRECCIONS NUMBER(1,0) NOT NULL COMMENT 'Camp que identifica sí el registre té direccions associades. Valor 1 = amb direccions',
	TIPUS_DOCUMENT VARCHAR(256) NOT NULL COMMENT 'Camp que classifica els tipus de document que conte el camp DNI',
	DNI VARCHAR(20) NOT NULL COMMENT 'Camp que conté el nombre identificatiu de la persona. En alguns casos seran DNI, NIE, etc.',
	NIF_UNEIX_10 VARCHAR(10) NOT NULL COMMENT 'Camp que conté el nombre identificatiu de la persona. En alguns casos seran DNI, NIE, etc. amb format UNEIX',
	NIF_UNEIX_20 VARCHAR(20) NOT NULL COMMENT 'Camp que conté el nombre identificatiu de la persona. En alguns casos seran DNI, NIE, etc. amb format UNEIX 2',
	DNI_COMPACTAT VARCHAR(50) COMMENT 'Camp que conté el nombre identificatiu compactat de la persona. En alguns casos seran DNI, NIE, etc',
	NOM VARCHAR(256) NOT NULL COMMENT 'Camp que conté el nom de la persona o empresa',
	NOM_UNEIX_30 VARCHAR(30) NOT NULL COMMENT 'Camp que conté el nom de la persona o empresa amb format UNEIX',
	COGNOM1 VARCHAR(256) COMMENT 'Camp que conté el primer cognom de la persona',
	COGNOM1_UNEIX_30 VARCHAR(30) COMMENT 'Camp que conté el primer cognom de la persona amb format UNEIX',
	COGNOM2 VARCHAR(256) COMMENT 'Camp que conté el segon cognom de la persona',
	COGNOM2_UNEIX_30 VARCHAR(30) COMMENT 'Camp que conté el segon cognom de la persona amb format UNEIX',
	NUM_SEGUR_SOCIAL VARCHAR(50) COMMENT 'Camp que conté el nombre de la seguretat social del registre',
	DATA_EXPEDICIO_DNI TIMESTAMP_NTZ(9) COMMENT 'Camp que conté la data expedició del DNI',
	DATA_INSERCIO TIMESTAMP_NTZ(9),
	DATA_ULT_MODIF TIMESTAMP_NTZ(9),
	PREFIX_TELEFON1 VARCHAR(50) COMMENT 'Camp que conté el prefix del telèfon principal de la persona',
	TELEFON1 VARCHAR(50) COMMENT 'Camp que conté el telefon principal de la persona',
	PREFIX_TELEFON2 VARCHAR(50) COMMENT 'Camp que conté el prefix del telèfon secundari de la persona',
	TELEFON2 VARCHAR(50) COMMENT 'Camp que conté el telefon secundari de la persona',
	PREFIX_FAX VARCHAR(50) COMMENT 'Camp que conté el prefix del fax  de la persona',
	FAX VARCHAR(50) COMMENT 'Camp que conté el fax de la persona',
	E_MAIL VARCHAR(256) COMMENT 'Camp que conté adreça electrònica de la persona',
	TIPUS_PERSONA VARCHAR(2) NOT NULL,
	IDIOMA_COLABORADOR VARCHAR(3) COMMENT 'Camp que conté idioma del col·laborador',
	IDIOMA_RELACIO VARCHAR(3) COMMENT 'Camp que conté idioma de relació de la persona',
	ROBINSON VARCHAR(2) COMMENT 'Té informat un si la persona ha sol·licitat estar a la llista Robinson',
	SANCIONAT_ECONOMIA VARCHAR(2) NOT NULL,
	VAT_NUMBER VARCHAR(20) COMMENT 'Camp que conté el codi identificació fiscal',
	EDAT NUMBER(4,0) COMMENT 'Camp que informa edat de la persona',
	DATA_NAIXEMENT TIMESTAMP_NTZ(9) COMMENT 'Camp que informa la data de naixement de la persona',
	ANY_NAIXEMENT NUMBER(4,0) COMMENT 'Any de naixement de la persona',
	SEXE VARCHAR(4) COMMENT 'Camp que informa del sexe de la persona',
	SEXE_UNEIX VARCHAR(2) COMMENT 'Camp que informa del sexe de la persona amb format UNEIX',
	PAIS VARCHAR(256) COMMENT 'Camp que informa del país de residència habitual de la persona',
	NACIONALITAT VARCHAR(256) COMMENT 'Camp que informa de la nacionalitat de la persona',
	PAIS_NAIXEMENT VARCHAR(256) COMMENT 'Camp que informa del pais de naixement de la persona',
	ROL_ESTUDIANT NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha sigut estudiant en algun moment',
	ROL_PRA NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de PRA',
	ROL_PDC NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de PDC',
	ROL_TUTOR NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de tutor',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
);

create  TABLE DB_UOC_PROD.DD_OD.DIM_PERSONA_TUTOR_TEST (
	ID_PERSONA_TUTOR NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau única que identifica els registres de la dim persona tutor',
	DIM_PERSONA_TUTOR_KEY VARCHAR(16) NOT NULL COMMENT 'Clau primària de la dimensió composta per l''idp del tutor i el tipus de tutor. Un mateix tutor pot ser d''inici o seguiment',
	IDP NUMBER(10,0) NOT NULL COMMENT 'Identificador UOC de la persona',
	AMB_DIRECCIONS NUMBER(1,0) NOT NULL COMMENT 'Camp que identifica sí el registre té direccions associades. Valor 1 = amb direccions',
	TIPUS_DOCUMENT VARCHAR(256) NOT NULL COMMENT 'Camp que classifica els tipus de document que conte el camp DNI',
	PREFIX_TELEFON1 VARCHAR(50) COMMENT 'Camp que conté el prefix del telèfon principal de la persona',
	PREFIX_TELEFON2 VARCHAR(50) COMMENT 'Camp que conté el prefix del telèfon secundari de la persona',
	TIPUS_PERSONA VARCHAR(2) NOT NULL,
	IDIOMA_RELACIO VARCHAR(3) COMMENT 'Camp que conté idioma de relació de la persona',
	ROBINSON VARCHAR(2) COMMENT 'Té informat un si la persona ha sol·licitat estar a la llista Robinson',
	SANCIONAT_ECONOMIA VARCHAR(2) NOT NULL,
	EDAT NUMBER(4,0) COMMENT 'Camp que informa edat de la persona',
	DATA_NAIXEMENT TIMESTAMP_NTZ(9) COMMENT 'Camp que informa la data de naixement de la persona',
	SEXE VARCHAR(4) COMMENT 'Camp que informa del sexe de la persona',
	PAIS VARCHAR(256) COMMENT 'Camp que informa del país de residència habitual de la persona',
	NACIONALITAT VARCHAR(256) COMMENT 'Camp que informa de la nacionalitat de la persona',
	PAIS_NAIXEMENT VARCHAR(256) COMMENT 'Camp que informa del pais de naixement de la persona',
	ROL_ESTUDIANT NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha sigut estudiant en algun moment',
	ROL_PRA NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de PRA',
	ROL_PDC NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de PDC',
	ROL_TUTOR NUMBER(1,0) NOT NULL COMMENT 'Camp que informa amb un 1 si la persona ha tingut en algun moment el rol de tutor',
	TIPUS_TUTOR VARCHAR(3) COMMENT 'Camp  que informa si la persona es tutor inici o continuitat',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informació',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
);

create  TABLE DB_UOC_PROD.DD_OD.DIM_PORTAFOLI_PA_TEST (
	ID_PORTAFOLI_PA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio portafoli producte academic',
	DIM_PORTAFOLI_PA_KEY VARCHAR(16) COMMENT 'Codi unic de portafoli producte academic',
	NUM_CREDITOS_TEORICOS NUMBER(15,4),
	NUM_CREDITOS_PRACTICOS NUMBER(15,4),
	MIN_CREDITOS_CLASE_TM NUMBER(15,4),
	MIN_CREDITOS_CLASE_OF NUMBER(15,4),
	MIN_CREDITOS_CLASE_PI NUMBER(15,4),
	MIN_CREDITOS_CLASE_LA NUMBER(15,4),
	MIN_CREDITOS_CLASE_C NUMBER(15,4),
	IND_TITULACIONES_PROPIAS VARCHAR(16777216),
	ESTADO_PLAN VARCHAR(16777216),
	NUM_VERSION_PLAN NUMBER(10,0),
	DESCRIPCION VARCHAR(16777216),
	COD_ESTUDIOS NUMBER(10,0),
	FECHA_PUBLICA_OFICIAL TIMESTAMP_NTZ(9),
	DESC_PUBLICA_OFICIAL VARCHAR(16777216),
	CICLO_PLAN NUMBER(10,0),
	IND_CREDITOS_ASIGNATURAS VARCHAR(16777216),
	MIN_CREDITOS_ASIGNATURAS NUMBER(15,4),
	MAX_CREDITOS_ASIGNATURAS NUMBER(15,4),
	CONTA_ELEMENTOS NUMBER(10,0),
	OBSERVACIONES VARCHAR(16777216),
	NUM_CONTROL NUMBER(10,0),
	COD_ESTUDIOS_MEC VARCHAR(16777216),
	IND_VALIDA_INICIO_EXP VARCHAR(16777216),
	MIN_CREDITOS_MEC NUMBER(15,4),
	COD_AREA VARCHAR(16777216),
	NUM_EDICION NUMBER(10,0),
	DESCRIPCION_CER VARCHAR(16777216),
	NUM_CREDITOS_CICLO2 NUMBER(15,4),
	ES_CICLO_12 VARCHAR(16777216) COMMENT 'Indica si el plan de estudios es del primer y segundo ciclo o no',
	TIPO_EDUCACION VARCHAR(16777216),
	IND_VISIBLE_EGIA VARCHAR(16777216),
	IND_CONSECUCION_PARCIAL VARCHAR(16777216) COMMENT 'indica si el plan puede contener o no consecución parcial',
	RATIO_CONVERSIO NUMBER(5,2),
	RATIO_FIDELIZA NUMBER(5,2),
	MAX_ESTUD_TUTOR NUMBER(5,0),
	ID_PROG_BOF NUMBER(10,0) COMMENT 'Indica el ID del programa provinent de BOF que apareix a PLAN_DATOS',
	IND_INTERUNIVERSITARIO VARCHAR(16777216),
	IDIOMA_DOCENCIA VARCHAR(16777216),
	IND_MIGRACION_GATIB VARCHAR(16777216),
	ID_BOF_TR NUMBER(38,0) COMMENT 'Indica el ID del programa provinent de BOF mes nou',
	DES_DENOMINACIO_CA_TR VARCHAR(16777216) COMMENT 'Indica el nom del programa académic en català del id_bof_tr',
	DES_UNITAT_ORGANICA_CA_TR VARCHAR(16777216) COMMENT 'Indica la descripcio dels estudis compresos pel programa en català del id_bof_tr',
	DES_TIPOLOGIA_CA_TR VARCHAR(16777216) COMMENT 'Indica la descripcio de la tipologia del programa en català del id_bof_tr',
	DES_INICIATIVA_CA_TR VARCHAR(16777216) COMMENT 'Indica el conjunt de programes al qual pertany en català del id_bof_tr',
	ID_BOF NUMBER(38,0) COMMENT 'Indica el ID del programa provinent de BOF',
	DES_DENOMINACIO_CA VARCHAR(16777216) COMMENT 'Indica el nom del programa académic en català',
	DES_ESTAT_CA VARCHAR(16777216) COMMENT 'Indica la descripcio del estat del programa en català',
	DES_VICEGERENCIA_CA VARCHAR(16777216) COMMENT 'Indica la descripció de la vigeréncia responsable del programa en català',
	DES_TIPOLOGIA_CA VARCHAR(16777216) COMMENT 'Indica la descripcio de la tipologia del programa en català',
	DES_TOTP VARCHAR(16777216) COMMENT 'Indica si la titulació es própia o oficial',
	DES_INICIATIVA_CA VARCHAR(16777216) COMMENT 'Indica el conjunt de programes al qual pertany en català',
	DES_UNITAT_ORGANICA_CA VARCHAR(16777216) COMMENT 'Indica la descripcio dels estudis compresos pel programa en català',
	DES_NIVELL_ACADEMIC_CA VARCHAR(16777216) COMMENT 'Indica la descripció del nivell acadèmic en català',
	DES_NIVELL_MECES_CA VARCHAR(16777216) COMMENT 'Indica la descripció del nivell MECES en català',
	DES_LEGISLACIO_CA VARCHAR(16777216) COMMENT 'Indica la descripció de la legislació que està subjecte el programa en català',
	ECTS_A_SUPERAR NUMBER(38,0) COMMENT 'Indica el nombre de ECTS a superar',
	ECTS_DESGLOSSAT_PER_TIPOLOGIA VARIANT COMMENT 'Indica els ECTS a desplegar i desglossats per tipologia en format JSON i en varis idiomes',
	ECTS_A_DESPLEGAR NUMBER(38,0) COMMENT 'Indica el nombre de ECTS a desplegar',
	DES_DIRECTOR_DE_PROGRAMA VARIANT COMMENT 'Indica les dades del director del programa en format JSON',
	DES_RESPONSABLE_ACADEMIC_CA VARCHAR(16777216) COMMENT 'Indica el nom complet del responsable acadèmic',
	DES_MANAGER_DE_PROGRAMA VARIANT COMMENT 'Indica les dades del manager del programa en format JSON',
	DES_COORDINADORA_CA VARCHAR(16777216) COMMENT 'Indica la descripció de l''entitat coordinadora en català',
	DES_ARREL_PROGRAMA VARCHAR(16777216) COMMENT 'Indica els programes arrel als que pertany, indica si está relacionat amb N o S',
	DES_ESTAT_PRIM_REG VARCHAR(16777216) COMMENT 'En definició',
	DES_ESTAT_SOLICITUD VARCHAR(16777216) COMMENT 'Aprovat CdD, No aprovat CdD',
	DES_ESTAT_PROGRAMA_DISSENY_TITULACIONS_INICI VARCHAR(16777216) COMMENT 'En tràmit de verificació',
	DES_ESTAT_RESULTAT_INFORME_FINAL_VERIFICACIO_AQU VARCHAR(16777216) COMMENT 'Informe final favorable, AQU, Informe final desfavorable AQU',
	DES_ESTAT_PROGRAMA_DISSENY_TITULACIONS_FI VARCHAR(16777216) COMMENT 'Programa Verificat',
	DATA_VERIFICACIO TIMESTAMP_NTZ(9) COMMENT 'Data de la resolució del conssell d''universitats',
	DES_ESTAT_DISSENY_TITULACIONS VARCHAR(16777216) COMMENT 'Autoritzat DE, No autoritzat DE',
	DATA_PREVISIO_IMPLANTACIO_MES NUMBER(38,0) COMMENT 'Indica el mes de la previsió de la implantació del programa',
	DATA_PREVISIO_IMPLANTACIO_ANY NUMBER(38,0) COMMENT 'Indica l''any de la previsió de la implantació del programa',
	DATA_IMPLANTACIO_REAL_MES NUMBER(38,0) COMMENT 'Indica el mes real de la implantació del programa',
	DATA_IMPLANTACIO_REAL_ANY NUMBER(38,0) COMMENT 'Indica l''any real de la implantació del programa',
	DATA_DE_LINFORME_FINAL_MODIFICACIO_AQU TIMESTAMP_NTZ(9) COMMENT 'Indidca la data de l''informe final modificació AQU',
	DES_ESTAT_PROGRAMA_ACREDITAR_TITULACIONS VARCHAR(16777216) COMMENT 'Programa Acreditat, No acreditat',
	DES_ESTAT_SOLICITUD_EXTINCIO_CICLE_VIDA VARCHAR(16777216) COMMENT 'En extinció / Extingit',
	DATA_INICI_EXTINCIO TIMESTAMP_NTZ(9) COMMENT 'Indica la data de l''inici de l''extinció del programa',
	DATA_EXTINCIO TIMESTAMP_NTZ(9) COMMENT 'Indica la data del final de l''extinció del programa',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Aquesta es unda dimensio temporal mentres es constitueix una dimensio portafoli completa amb la traçabilitat de producte academic i comercial'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_QUALIFICACIO_TEST (
	ID_QUALIFICACIO NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio qualificacio',
	DIM_QUALIFICACIO_KEY VARCHAR(6) NOT NULL COMMENT 'Codi UOC de qualificacio.',
	DESC_QUALIFICACIO VARCHAR(256) COMMENT 'Descripcio completa de la qualificacio',
	DESC_QUALIFICACIO_CURTA VARCHAR(256) COMMENT 'Descripcio abreviada de la qualificacio',
	IND_SUPERA VARCHAR(1) COMMENT 'Valor que indica si supera amb exit la qualificacio.',
	IND_CONSUMEIX_CONVOCATORIA VARCHAR(1) COMMENT 'Valor que indica si es conumeix convocatoria per a una assignatura determinada.',
	IND_NP VARCHAR(1) COMMENT 'Valor que indica si s ha presentat a examen.',
	IND_MH VARCHAR(1) COMMENT 'Valor que indica si ha superat la qualificacio amb Matricula d Honor.',
	IND_AN VARCHAR(1) COMMENT 'Valor que indica si ha estat una anulacio.',
	IND_CONVALIDA VARCHAR(1) COMMENT 'Valor que indica si es una convalidacio.',
	IND_ADAPTA VARCHAR(1) COMMENT 'Valor que indica si ha estat adaptada.',
	IND_TESI VARCHAR(1) COMMENT 'Valor que indica si es una Tesi.',
	IND_CORRECTE_JUNTA VARCHAR(1) COMMENT 'Valor que indica si ha estat supervisat per la junta.',
	IND_PDT_QUALIFICACIO VARCHAR(1) COMMENT 'Valor que indica si esta pendent de qualificar.',
	IND_PARTICIPA VARCHAR(1) COMMENT 'Valor que indica si ha participat.',
	IND_CALCULAR_NUMERICA VARCHAR(1) COMMENT 'Valor que indica es tracta de qualificacio numerica.',
	IND_NOTA_FINAL_EXPEDIENT VARCHAR(1) COMMENT 'Valor que indica si es tracta de nota final d expedient.',
	VALOR_NUM_MINIM NUMBER(15,4) COMMENT 'Valor numeric minim de qualificacio.',
	VALOR_NUM_MAXIM NUMBER(15,4) COMMENT 'Valor numeric maxim de qualificacio.',
	VALOR_NUM_ASSOCIAT NUMBER(15,4) COMMENT 'Valor numeric asociat de la qualificacio.',
	VALOR_NUM_BECA NUMBER(15,4) COMMENT 'Valor numeric minim que dona acces a solicitud de beca.',
	VALOR_NUM_PE NUMBER(15,4) COMMENT 'Valor numeric PE.',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les notes de l avaluacio.'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_QUALIFICACIO_CONTINUADA_TEST (
	ID_QUALIFICACIO_CONTINUADA NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio qualificacio',
	DIM_QUALIFICACIO_CONTINUADA_KEY VARCHAR(6) NOT NULL COMMENT 'Codi UOC de qualificacio.',
	DESC_QUALIFICACIO_CONTINUADA VARCHAR(256) COMMENT 'Descripcio completa de la qualificacio',
	IND_ACTIVO_CONTINUADA VARCHAR(1) COMMENT 'Valor que indica si la nota esta activa a l avaluacio.',
	IND_PARTICIPA_CONTINUADA VARCHAR(1) COMMENT 'Valor que indica si l estudiant ha seguit l avaluacio continuada.',
	IND_SUPERA_CONTINUADA VARCHAR(1) COMMENT 'Valor que indica si supera amb exit la qualificacio.',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant de les qualificacions d avaluacio continuada.'
;

create  TABLE DB_UOC_PROD.DD_OD.DIM_SEMESTRE_TEST (
	ID_SEMESTRE NUMBER(16,0) NOT NULL autoincrement start 1 increment 1 noorder COMMENT 'Clau unica i numerica que identifica els registres de la dimensio any academic',
	DIM_SEMESTRE_KEY VARCHAR(6) NOT NULL COMMENT 'Codi UOC any academic. Els anys academics es poden anomenar semestres en alguns equips i departaments. En alguns casos existeix el concepte de 3er any academic, que correspon a formacions adicionals i/o seminaris',
	DESCRIPCIO VARCHAR(256) NOT NULL COMMENT 'Descripcio completa anya academic',
	ANY_NATURAL NUMBER(4,0) NOT NULL COMMENT 'Any natural al que pertany un any academic determinat',
	SEMESTRE NUMBER(1,0) NOT NULL COMMENT 'Camp numeric que identifica el semestre al que pertany un any academic',
	DESCRIPCIO_VISUAL VARCHAR(256) NOT NULL COMMENT 'Descripcio simple i resumida dels anys academics',
	DATA_INICI TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data que dona inici a un any academic determinat',
	DATA_FI TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data fi per a un any academic determinat',
	CURS_ACADEMIC VARCHAR(9) NOT NULL COMMENT 'Curs academic al que pertany el semestre',
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
)COMMENT='Taula que conte la informacio rellevant dels anys academics/semestres per a qualsevol projecte de disponibilitzacio'
;

create  TABLE DB_UOC_PROD.DD_OD.FACT_DOCENCIA_TEST (
	ID_DOCENCIA NUMBER(20,0),
	ID_SEMESTRE NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_SEMESTRE.',
	ID_ASSIGNATURA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_ASSIGNATURA.',
	ID_QUALIFICACIO NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_QUALIFICACIO.',
	ID_QUALIFICACIO_CONTINUADA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_QUALIFICACIO_CONTINUADA.',
	ID_EXPEDIENT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_EXPEDIENT.',
	ID_MATRICULA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_MATRICULA.',
	ID_PORTAFOLI_PA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PORTAFOLI_PA.',
	ID_PERSONA_ESTUDIANT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PERSONA_ESTUDIANT.',
	ID_PAIS_NACIONALITAT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_NACIONALITAT.',
	ID_PAIS_NAIXEMENT NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_NAIXEMENT.',
	ID_PAIS_RESIDENCIA NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PAIS_RESIDENCIA.',
	ID_ACCES NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_ACCES.',
	ID_PERSONA_TUTOR NUMBER(16,0) COMMENT 'Aquest ID correspon a la taula DIM_PERSONA_TUTOR.',
	NOTA_MITJANA NUMBER(15,4),
	NOTA_MITJANA_PUNTS NUMBER(15,4),
	ASSIGNATURA_CURSADA NUMBER(1,0),
	NUM_CREDITS NUMBER(4,1),
	NUM_CREDITS_TEORICS NUMBER(3,1),
	NUM_CREDITS_PRACTICS NUMBER(3,1),
	NUM_MATRICULAS_ASSIGNATURA NUMBER(3,0),
	SEMESTRE_RELATIU_EXPEDIENT NUMBER(3,0),
	SEMESTRE_RELATIU_SUPER_EXPEDIENT NUMBER(3,0),
	SEMESTRE_RELATIU_UOC NUMBER(3,0),
	QUALIF_NUM_CONT NUMBER(22,2),
	QUALIF_NUM_CONT_FINAL NUMBER(22,2),
	QUALIF_NUMERICA NUMBER(22,2),
	QUALIF_NUMERICA_PUB NUMBER(22,2),
	QUALIF_NUM_PRACTICA NUMBER(22,2),
	QUALIF_NUM_PRES NUMBER(22,2),
	QUALIF_NUM_PROP NUMBER(22,2),
	QUALIF_NUM_TEORICA NUMBER(22,2),
	SUPERA_ASSIGNATURA NUMBER(1,0),
	NO_SUPERA_ASSIGNATURA NUMBER(1,0),
	MATRICULA_ANULADA NUMBER(1,0),
	ASSIGNATURA_ANULADA NUMBER(1,0),
	ASSIGNATURA_CONVALIDADA NUMBER(1,0),
	EDAT_RELATIVA NUMBER(4,0) COMMENT 'És l''edat relativa de la persona en el moment de l''esdeveniment. Per calcular-ho s''agafa l''any natural del semestre associat a l''esdeveniment i es resta a l''any de la data de naixement de l''alumne',
	GRUP_EDAT VARCHAR(15),
	GRUP_EDAT_2 VARCHAR(15),
	CREATION_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de creacio del registre de la informacio',
	UPDATE_DATE TIMESTAMP_NTZ(9) NOT NULL COMMENT 'Data de carrega de la informacio'
);

create  TABLE DB_UOC_PROD.DD_OD.PROCEDURES_LOG_TEST (
	ID_LOG NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	PROCEDURE_NAME VARCHAR(255),
	EXECUTED_BY VARCHAR(255),
	EXECUTION_DATE TIMESTAMP_NTZ(9),
	EXECUTION_TIME NUMBER(10,0) COMMENT 'milisegons',
	REMARKS VARCHAR(512),
	primary key (ID_LOG)
);

--------------------------------------------------------------