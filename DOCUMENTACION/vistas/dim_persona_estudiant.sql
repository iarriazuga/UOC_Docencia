create or replace view DB_UOC_PROD.DD_OD.DIM_PERSONA_ESTUDIANT(
	ID_PERSONA_ESTUDIANT,
	DIM_PERSONA_ESTUDIANT_KEY,
	AMB_DIRECCIONS,
	TIPUS_DOCUMENT,
	PREFIX_TELEFON1,
	PREFIX_TELEFON2,
	TIPUS_PERSONA,
	IDIOMA_RELACIO,
	ROBINSON,
	SANCIONAT_ECONOMIA,
	EDAT,
	DATA_NAIXEMENT,
	SEXE,
	PAIS,
	NACIONALITAT,
	PAIS_NAIXEMENT,
	ROL_ESTUDIANT,
	ROL_PRA,
	ROL_PDC,
	ROL_TUTOR,
	CREATION_DATE,
	UPDATE_DATE
) COMMENT='Dimensió persona estudiant creada mitjançant la dim persona. Nomes conte les persones que en algun moment han sigut estudiants. Es a dir, tenen un expedient'
 AS 
SELECT id_persona AS id_persona_estudiant,
       dim_persona_key AS dim_persona_estudiant_key,
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
       creation_date,
       update_date
FROM DB_UOC_PROD.DD_OD.dim_persona
where rol_estudiant = 1;