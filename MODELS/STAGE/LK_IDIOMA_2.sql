-- Crear la tabla con todas las columnas y una restricción UNIQUE
CREATE OR REPLACE TABLE DB_UOC_PROD.DDP_DOCENCIA.LK_IDIOMA_2 (
 
    ID_IDIOMA INT PRIMARY KEY COMMENT 'Identificador únic de l idioma.',
    COD_IDIOMA INT NOT NULL COMMENT 'Codi associat a l idioma.',
    DESC_IDIOMA VARCHAR(50) NOT NULL COMMENT 'Descripció completa de l idioma.',
    DESC_IDIOMA_ACRONIM VARCHAR(10) NOT NULL COMMENT 'Acrònim de l idioma.',
    DESC_IDIOMA_ACRONIM_2_LETRAS VARCHAR(2) COMMENT 'Acrònim de dues lletres de l idioma.'
);

-- Insertar los datos iniciales
INSERT INTO DB_UOC_PROD.DDP_DOCENCIA.LK_IDIOMA_2 (ID_IDIOMA, COD_IDIOMA, DESC_IDIOMA, DESC_IDIOMA_ACRONIM, DESC_IDIOMA_ACRONIM_2_LETRAS)
VALUES

(0,     0,      'Sense Informar',   'SEN',      'se'),
(1,     1,      'Català',           'CAT',      'ca'),
(2,     2,      'Castellà',         'CAS',      'es'),
(3,     3,      'Anglès',           'ENG',      'en'),
(4,     4,      'Francès',          'FRA',      'fr'),
(5,     5,      'Basc',             'BAS',      'ba'),
(6,     6,      'Gallec',           'GAL',      'ga'),
(7,     7,      'Alemany',          'ALE',      'de'),
(8,     8,      'Italià',           'ITA',      'it'),
(9,     9,      'Portuguès',        'POR',      'po'),
(10,    10,     'Holandés',         'HOL',      'ho'),
(11,    11,     'Noruec',           'NOR',      'no'),
(12,    12,     'Finlandès',        'FIN',      'fi'),
(13,    13,     'Suec',             'SUE',      'su'),
(20,    20,     'Xinès',            'XIN',      'xi'),
(21,    21,     'Occità',           'OCC',      'oc'),
(22,    22,     'Portuguès',        'POR',      'pt'),
(24,    24,     'Desconocido',      'NULL',     NULL),
(26,    26,     'Gallec',           'GAL',      'gl'),
(30,    30,     'Basc',             'BAS',      'eu');
-- Verificar los datos finales
SELECT * FROM DB_UOC_PROD.DDP_DOCENCIA.LK_IDIOMA_2;

