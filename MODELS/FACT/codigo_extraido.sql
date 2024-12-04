Hola Francesc, 

Estamos intentando completar los elementos que nos faltan y que nos has comentado. 

Primero, el area de la asignatura creemos que deberia ser incluida dentro de la dimension  DIM_ASSIGNATURA, nos han comentado que se puede extraer del campo  COD_ESTUDIOS_AREA de la tabla de gat_assignaturas.

Segundo, para completar el area de profesor ( que sera incluido en la fact dades_academiques) me gustaria saber a que nos referimos concretamente con profesor? 
el profesor asociado que hace docencia o el profesor responsable de la asignatura (PRA)?
en caso de que sea el profesor asociado la granularidad de las tablas cambiarian para el linkaje y no estamos seguros de como estructurarlo.
Por el contrario, si el profesor responsable de la asignatura fuera unico, la granularidad de las tablas estaria en el linkaje y podriamos conservar la esctructura. 
En la tabla live_events no soy capaz de extraer informacion de este profesor y no encuentro una tabla maestra asociada, pero si nos ayudas a decidir que opcion necesitas, nos pondremos en contacto con victor para completar la logica correspondiente.