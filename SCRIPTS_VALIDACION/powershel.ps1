Dir *.txt | Rename-Item -NewName { $_.Name -replace '\.txt$', '.sql' }


grinch en todas las empresas o reconducirlo o echarlo manzana podrida contamina al resto de companeros 

/*

create or replace  TABLE DB_UOC_PROD.DD_OD.PROGRAM_RELACIONES_TEST (
 
	ID_BOF NUMBER(38,0) COMMENT 'Indica l''ID del programa associat a les relacions',
	ID_BOF_REL NUMBER(38,0) COMMENT 'Indica l''ID del programa amb el que està relacionat',
	DES_RELACION_CA VARCHAR(16777216) COMMENT 'Descripció de la relació en català',
	DES_RELACION VARIANT COMMENT 'Descripció de la relació en format JSON',
	-- DES_TIPOLOGIA VARCHAR(16777216) COMMENT 'Tipologia de la relació',
	TS_CARGA_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de càrrega de dades',
	TS_DADES TIMESTAMP_NTZ(9) COMMENT 'Indica la data de les dades',
	TS_DATA_PROCESSAMENT TIMESTAMP_NTZ(9) COMMENT 'Indica la data de processament de les dades',
	-- DES_RELACION_ES VARCHAR(16777216) COMMENT 'Descripció de la relació en castellà',
	RELACION_ANY NUMBER(38,0) COMMENT 'Any en que es va crear la relació' 
        -- , 
	-- RELACION_MES NUMBER(38,0) COMMENT 'Mes en que es va crear la relació',
	-- RELACION_ORDRE NUMBER(38,0) COMMENT 'Indica l''odre de la relació',
	-- RELACION_AMBIT VARCHAR(16777216) COMMENT 'Indica l''àmbit de la relació entre els programes'
)COMMENT='Taula que cont� relacions dels programes que han estat actualitzats al sistema'
;
