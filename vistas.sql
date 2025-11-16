/*VISTA HORARIOS CON PROFESIONALES*/
GO
CREATE VIEW vw_HorariosProfesionales
AS
SELECT 
    HA.id_horario,
    P.id_profesional,
    P.nombre AS nombre_profesional,
    P.apellido AS apellido_profesional,
    E.id_especialidad,
    E.nombre AS especialidad,
    C.id_consultorio,
    C.nombre AS consultorio,
    C.direccion AS consultorio_direccion,
    C.piso AS consultorio_piso,
    C.numero_sala,
    HA.dia_semana,
    HA.hora_inicio,
    HA.hora_fin
FROM HorarioAtencion HA
INNER JOIN Profesional P
    ON HA.id_profesional = P.id_profesional
INNER JOIN Consultorio C
    ON HA.id_consultorio = C.id_consultorio
INNER JOIN Especialidad E
    ON HA.id_especialidad = E.id_especialidad;
GO

/* - Ver los horarios de un profesional especifico

SELECT *
FROM vw_HorariosProfesionales
WHERE id_profesional = 1;

 -Ver los horarios de una especialidad

SELECT *
FROM vw_HorariosProfesionales
WHERE id_especialidad = 3;

 - Ver en que consultorio atiende un profesional

SELECT nombre_profesional, apellido_profesional, consultorio, dia_semana, hora_inicio, hora_fin
FROM vw_HorariosProfesionales
WHERE id_profesional = 2;

 - Ver horarios ordenados por dia y hora
SELECT *
FROM vw_HorariosProfesionales
ORDER BY dia_semana, hora_inicio;

 - Buscar horarios en un rango horario

Ejemplo: todos los turnos que empiezan antes de las 12:00

SELECT *
FROM vw_HorariosProfesionales
WHERE hora_inicio > '12:00' and;

- Buscar horarios segun consultorio

Ejemplo: consultorio 1

SELECT *
FROM vw_HorariosProfesionales
WHERE id_consultorio = 1;*/

/*VISTA PROFESIONAL POR ESPECIALIDAD*/

GO
CREATE VIEW vw_ProfesionalesPorEspecialidad
AS
SELECT 
    PE.id_profesional,
    P.nombre AS nombre_profesional,
    P.apellido AS apellido_profesional,
    PE.id_especialidad,
    E.nombre AS especialidad,
    E.descripcion AS descripcion_especialidad,
    PE.valor_consulta
FROM Profesional_Especialidad PE
INNER JOIN Profesional P 
    ON PE.id_profesional = P.id_profesional
INNER JOIN Especialidad E
    ON PE.id_especialidad = E.id_especialidad;
GO
/*
 - Ver todo
SELECT *
FROM vw_ProfesionalesPorEspecialidad;

 - Buscar por especialidad

SELECT *
FROM vw_ProfesionalesPorEspecialidad
WHERE id_especialidad = 3;

 - Buscar por profesional

SELECT *
FROM vw_ProfesionalesPorEspecialidad
WHERE id_profesional = 2;
*/

/*VISTAS TURNO PACIENTES*/
GO
CREATE VIEW vw_TurnosPorPaciente
AS
SELECT
    T.id_turno,
    T.fecha_turno,
    T.hora_turno,
    T.estado,
    T.monto_total,

    -- Paciente
    P.id_paciente,
    P.nombre AS nombre_paciente,
    P.apellido AS apellido_paciente,
    P.dni AS dni_paciente,
    P.id_obra_social,
    OS.nombre AS obra_social,
    OS.porcentaje_cobertura,

    -- Horario
    HA.id_horario,
    HA.dia_semana,
    HA.hora_inicio,
    HA.hora_fin,

    -- Profesional
    PR.id_profesional,
    PR.nombre AS nombre_profesional,
    PR.apellido AS apellido_profesional,

    -- Especialidad
    E.id_especialidad,
    E.nombre AS especialidad,

    -- Consultorio
    C.id_consultorio,
    C.nombre AS consultorio,
    C.piso,
    C.numero_sala,
    C.direccion AS direccion_consultorio

FROM Turno T
INNER JOIN Paciente P
    ON T.id_paciente = P.id_paciente
INNER JOIN HorarioAtencion HA
    ON T.id_horario = HA.id_horario
INNER JOIN Profesional PR
    ON HA.id_profesional = PR.id_profesional
INNER JOIN Especialidad E
    ON HA.id_especialidad = E.id_especialidad
LEFT JOIN ObraSocial OS
    ON T.id_obra_social = OS.id_obra_social
INNER JOIN Consultorio C
    ON HA.id_consultorio = C.id_consultorio;
GO

/* - Ver todo

SELECT *
FROM vw_TurnosPorPaciente;

 - Ver turnos de un paciente puntual

SELECT *
FROM vw_TurnosPorPaciente
WHERE id_paciente = 1;

 - Ver turnos por estado
SELECT *
FROM vw_TurnosPorPaciente
WHERE estado = 'Confirmado';

 - Ver turnos ordenados por fecha (para el video queda hermoso)
SELECT *
FROM vw_TurnosPorPaciente
ORDER BY fecha_turno, hora_turno;

 - Mostrar el profesional y especialidad del turno
SELECT 
    nombre_paciente + ' ' + apellido_paciente AS paciente,
    nombre_profesional + ' ' + apellido_profesional AS profesional,
    especialidad,
    fecha_turno,
    hora_turno
FROM vw_TurnosPorPaciente
ORDER BY fecha_turno;
*/


--HORARIOS PERO POR OBRA SOCIAL, SE REPITEN LOS MISMOS HORARIOS SEGUN LOS CONVENIOS ACTIVOS QUE TENGA EL PROFESIONAL DEL TURNO CON OBRAS SOCIALES (PENSADO PARA BUSCAR COBERTURAS)

GO
CREATE OR ALTER VIEW vw_HorariosPorObraSocial
AS
SELECT 
    HA.id_horario,
    P.id_profesional,
    P.nombre AS nombre_profesional,
    P.apellido AS apellido_profesional,

    E.id_especialidad,
    E.nombre AS especialidad,

    C.id_consultorio,
    C.nombre AS consultorio,
    C.direccion AS consultorio_direccion,
    C.piso AS consultorio_piso,
    C.numero_sala,

    OS.id_obra_social,
    OS.nombre AS obra_social,
    OS.porcentaje_cobertura,

    HA.dia_semana,
    HA.hora_inicio,
    HA.hora_fin
FROM HorarioAtencion HA
INNER JOIN Profesional P
    ON HA.id_profesional = P.id_profesional
INNER JOIN Especialidad E
    ON HA.id_especialidad = E.id_especialidad
INNER JOIN Consultorio C
    ON HA.id_consultorio = C.id_consultorio
LEFT JOIN Profesional_ObraSocial PO
    ON P.id_profesional = PO.id_profesional
    AND PO.convenio_activo = 1
LEFT JOIN ObraSocial OS
    ON PO.id_obra_social = OS.id_obra_social;
GO
