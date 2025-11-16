GO
CREATE PROCEDURE sp_BuscarTurnos
(
    @criterio NVARCHAR(30),
    @valor1 NVARCHAR(100) = NULL,
    @valor2 NVARCHAR(100) = NULL
)
AS
BEGIN
    -- Normalizar criterio
    SET @criterio = LOWER(@criterio);

    ---------------------------------------------------------------------
    -- VALIDACIÓN DE CRITERIO
    ---------------------------------------------------------------------
    IF @criterio NOT IN (
        'dia', 'hora', 'consultorio',
        'paciente_id', 'paciente_nombre', 'paciente_apellido',
        'profesional_id', 'profesional_nombre', 'profesional_apellido',
        'especialidad_id', 'especialidad_nombre',
        'fecha', 'rango_fecha',
        'estado'
    )
    BEGIN
        RAISERROR('Criterio invalido. Criterios validos: dia, hora, consultorio, paciente_id, paciente_nombre, paciente_apellido, profesional_id, profesional_nombre, profesional_apellido, especialidad_id, especialidad_nombre, fecha, rango_fecha, estado.', 16, 1);
        RETURN;
    END

    
    -- QUERIES SEGUN EL CRITERIO:

    
    -- 1) BUSQUEDA POR DÍA
    
    IF @criterio = 'dia'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(dia_semana) = LOWER(@valor1)
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 2) BUSQUEDA POR HORA
    
    IF @criterio = 'hora'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE hora_turno = @valor1
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 3) BUSQUEDA POR CONSULTORIO
    
    IF @criterio = 'consultorio'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(consultorio) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 4) BUSQUEDA POR PACIENTE (ID)
    
    IF @criterio = 'paciente_id'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Paciente WHERE id_paciente = @valor1)
        BEGIN
            RAISERROR('No existe un paciente con ese ID.', 16, 1);
            RETURN;
        END

        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE id_paciente = @valor1
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 5) BUSQUEDA POR PACIENTE NOMBRE (LIKE)
    
    IF @criterio = 'paciente_nombre'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(nombre_paciente) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 6) BUSQUEDA POR PACIENTE APELLIDO (LIKE)
    
    IF @criterio = 'paciente_apellido'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(apellido_paciente) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 7) PROFESIONAL POR ID
    
    IF @criterio = 'profesional_id'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Profesional WHERE id_profesional = @valor1)
        BEGIN
            RAISERROR('No existe un profesional con ese ID.', 16, 1);
            RETURN;
        END

        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE id_profesional = @valor1
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 8) PROFESIONAL NOMBRE (LIKE)
    
    IF @criterio = 'profesional_nombre'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(nombre_profesional) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 9) PROFESIONAL APELLIDO (LIKE)
    
    IF @criterio = 'profesional_apellido'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(apellido_profesional) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 10) ESPECIALIDAD POR ID
    
    IF @criterio = 'especialidad_id'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE id_especialidad = @valor1)
        BEGIN
            RAISERROR('No existe una especialidad con ese ID.', 16, 1);
            RETURN;
        END

        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE id_especialidad = @valor1
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 11) ESPECIALIDAD NOMBRE (LIKE)
    
    IF @criterio = 'especialidad_nombre'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(especialidad) LIKE '%' + LOWER(@valor1) + '%'
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 12) BUSQUEDA POR ESTADO
    
    IF @criterio = 'estado'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE LOWER(estado) = LOWER(@valor1)
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    
    -- 13) BUSQUEDA POR FECHA EXACTA
    
    IF @criterio = 'fecha'
    BEGIN
        SELECT *
        FROM vw_TurnosPorPaciente
        WHERE fecha_turno = @valor1
        ORDER BY fecha_turno, hora_turno;
        RETURN;
    END

    -- 14) BUSQUEDA POR RANGO DE FECHAS
    IF @criterio = 'rango_fecha'
BEGIN
    IF @valor2 IS NULL
    BEGIN
        RAISERROR('Para rango_fecha se requieren dos fechas: valor1 = desde, valor2 = hasta.', 16, 1);
        RETURN;
    END

    IF ISDATE(@valor1) = 0 OR ISDATE(@valor2) = 0
    BEGIN
        RAISERROR('Uno o ambos valores no son fechas validas.', 16, 1);
        RETURN;
    END

    SELECT *
    FROM vw_TurnosPorPaciente
    WHERE fecha_turno BETWEEN CONVERT(date, @valor1) AND CONVERT(date, @valor2)
    ORDER BY fecha_turno, hora_turno;
    RETURN;
END

END
GO


--EJEMPLOS DE USO
/*
    EXEC sp_BuscarTurnos 'dia', 'Lunes';
    EXEC sp_BuscarTurnos 'hora', '10:30';
    EXEC sp_BuscarTurnos 'consultorio', 'Belgrano';
    EXEC sp_BuscarTurnos 'paciente_id', '3';
    EXEC sp_BuscarTurnos 'paciente_nombre', 'Juan';
    EXEC sp_BuscarTurnos 'paciente_apellido', 'Perez';
    EXEC sp_BuscarTurnos 'profesional_id', '1';
    EXEC sp_BuscarTurnos 'profesional_nombre', 'Maria';
    EXEC sp_BuscarTurnos 'profesional_apellido', 'Gonzalez';
    EXEC sp_BuscarTurnos 'especialidad_id', '3';
    EXEC sp_BuscarTurnos 'especialidad_nombre', 'Cardio';
    EXEC sp_BuscarTurnos 'estado', 'Confirmado';
    EXEC sp_BuscarTurnos 'fecha', '2025-11-22';
    EXEC sp_BuscarTurnos 'rango_fecha', '2025-11-01', '2025-11-30';

*/


GO
CREATE OR ALTER PROCEDURE sp_BuscarDisponibilidadTurno
(
    @obraSocialId INT = NULL,              -- NULL = particular
    @tipoFiltro NVARCHAR(20) = NULL,       -- 'especialidad' | 'profesional' | NULL
    @valorFiltro INT = NULL,               -- id segun filtro
    @diaSemana NVARCHAR(15) = NULL,        -- lunes, martes...
    @horaDesde TIME = NULL,                -- hora exacta o desde
    @horaHasta TIME = NULL                 -- hasta (opcional)
)
AS
BEGIN

    -- normalizacion
    SET @tipoFiltro = LOWER(@tipoFiltro);

    -- validacion de tipoFiltro
    IF @tipoFiltro IS NOT NULL AND @tipoFiltro NOT IN ('especialidad', 'profesional')
    BEGIN
        RAISERROR('tipoFiltro invalido. Usar especialidad o profesional.', 16, 1);
        RETURN;
    END

    -- validacion de rango horario
    IF @horaDesde IS NOT NULL AND @horaHasta IS NOT NULL
    BEGIN
        IF @horaHasta < @horaDesde
        BEGIN
            RAISERROR('horaHasta no puede ser menor que horaDesde.', 16, 1);
            RETURN;
        END
    END

    -- consulta principal
    SELECT
        id_horario,
        id_profesional,
        nombre_profesional,
        apellido_profesional,
        id_especialidad,
        especialidad,
        id_consultorio,
        consultorio,
        consultorio_direccion,
        consultorio_piso,
        numero_sala,
        id_obra_social,
        obra_social,
        porcentaje_cobertura,
        dia_semana,
        hora_inicio,
        hora_fin
    FROM vw_HorariosPorObraSocial
    WHERE
        -- filtro por obra social (solo si viene)
        (@obraSocialId IS NULL OR id_obra_social = @obraSocialId)

        -- filtro comun agrupado:
        AND (
                @tipoFiltro IS NULL
                OR (@tipoFiltro = 'especialidad' AND id_especialidad = @valorFiltro)
                OR (@tipoFiltro = 'profesional' AND id_profesional = @valorFiltro)
            )

        -- filtro por dia de semana
        AND (
                @diaSemana IS NULL
                OR LOWER(dia_semana) = LOWER(@diaSemana)
            )

        -- filtro por hora exacta o rango
        AND (
                @horaDesde IS NULL
                OR (
                        @horaHasta IS NULL
                        AND hora_inicio = @horaDesde          -- hora exacta
                   )
                OR (
                        @horaHasta IS NOT NULL
                        AND hora_inicio BETWEEN @horaDesde AND @horaHasta  -- rango
                   )
            )

    ORDER BY dia_semana, hora_inicio, nombre_profesional;

END
GO


/*
    EXEC sp_InsertHorarioAtencionPartido
    @id_profesional   = 1,
    @id_consultorio   = 1,
    @id_especialidad  = 1,
    @dia_semana       = 'Lunes',
    @hora_inicio      = '09:00',
    @hora_fin         = '12:00',
    @cantidad_partes  = 3;
*/

CREATE OR ALTER PROCEDURE sp_InsertHorarioAtencionPartido
(
    @id_profesional   INT,
    @id_consultorio   INT,
    @id_especialidad  INT,
    @dia_semana       NVARCHAR(20),
    @hora_inicio      TIME(0),
    @hora_fin         TIME(0),
    @cantidad_partes  INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validaciones
        IF @cantidad_partes <= 0
            THROW 50001, 'La cantidad de partes debe ser mayor a 0', 1;

        -- Horas en bloques de 30 minutos
        IF DATEPART(SECOND, @hora_inicio) <> 0
           OR DATEPART(SECOND, @hora_fin) <> 0
           OR DATEPART(MINUTE, @hora_inicio) NOT IN (0, 30)
           OR DATEPART(MINUTE, @hora_fin) NOT IN (0, 30)
        BEGIN
            THROW 50002, 'Los horarios deben estar en bloques de 30 minutos (Ejemplo: HH:00 o HH:30)', 1;
        END

        -- Inicio < Fin
        DECLARE @duracion_min INT = DATEDIFF(MINUTE, @hora_inicio, @hora_fin);

        IF @duracion_min <= 0
            THROW 50003, 'La hora de fin debe ser mayor a la de inicio.', 1;

        -- Duracion multiplo de 30
        IF @duracion_min % 30 <> 0
            THROW 50004, 'La diferencia entre inicio y fin debe ser multiplo de 30 minutos', 1;

        -- Duracion divisible en partes iguales
        IF @duracion_min % @cantidad_partes <> 0
            THROW 50005, 'El rango horario no se puede dividir en partes iguales con esa cantidad de partes', 1;

        DECLARE @duracion_parte INT = @duracion_min / @cantidad_partes;

        -- Cada parte minimo 30 minutos y multiplo de 30
        IF @duracion_parte < 30 OR @duracion_parte % 30 <> 0
            THROW 50006, 'Cada parte debe ser de al menos 30 minutos y multiplo de 30.', 1;

        -- Iniciamos la transaccion
        BEGIN TRAN;

        DECLARE
            @i INT = 0,
            @ini_parte TIME(0),
            @fin_parte TIME(0);

        WHILE @i < @cantidad_partes
        BEGIN
            SET @ini_parte = DATEADD(MINUTE, @i * @duracion_parte, @hora_inicio);
            SET @fin_parte = DATEADD(MINUTE, (@i + 1) * @duracion_parte, @hora_inicio);

            -- 1. Validamos que el profesional no tenga ya ese horario
            IF EXISTS (
                SELECT 1
                FROM HorarioAtencion ha
                WHERE ha.id_profesional   = @id_profesional
                  AND ha.dia_semana      = @dia_semana
                  AND ha.hora_inicio      = @ini_parte
                  AND ha.hora_fin        = @fin_parte
            )
            BEGIN
                THROW 50007, 'Ya existe un horario identico para este profesional.', 1;
            END

            -- 2. Validamos que el consultorio este libre para ese horario
            IF EXISTS (
                SELECT 1
                FROM HorarioAtencion ha
                WHERE ha.dia_semana      = @dia_semana
                  AND ha.hora_inicio      = @ini_parte
                  AND ha.hora_fin        = @fin_parte
                  AND ha.id_consultorio <> @id_consultorio
                  AND ha.id_profesional  <> @id_profesional
            )
            BEGIN
                THROW 50008, 'El consultrorio esta ocupado en ese horario.', 1;
            END

            -- 3) Insertamos
            INSERT INTO HorarioAtencion
                (id_profesional, id_consultorio, id_especialidad, dia_semana, hora_inicio, hora_fin)
            VALUES
                (@id_profesional, @id_consultorio, @id_especialidad, @dia_semana, @ini_parte, @fin_parte);

            SET @i += 1;
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        -- Repropagamos el error con el mensaje original
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END CATCH
END;
GO