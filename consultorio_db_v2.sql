	
    IF DB_ID('consultorio_db_v2') IS NULL
        CREATE DATABASE consultorio_db_v2;
    GO
    USE consultorio_db_v2;
    GO


    CREATE TABLE Paciente (
        id_paciente INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        apellido NVARCHAR(50) NOT NULL,
        dni NVARCHAR(15) UNIQUE NOT NULL,
        fecha_nacimiento DATE,
        telefono NVARCHAR(20),
        email NVARCHAR(100),
        direccion NVARCHAR(100),
        id_obra_social INT NULL,
        nro_afiliado NVARCHAR(30) NULL,
        activo BIT DEFAULT 1
    );
    GO

    CREATE TABLE ObraSocial (
        id_obra_social INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        porcentaje_cobertura DECIMAL(5,2),
        telefono NVARCHAR(20),
        direccion NVARCHAR(100)
    );
    GO


    CREATE TABLE Profesional (
        id_profesional INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        apellido NVARCHAR(50) NOT NULL,
        dni NVARCHAR(15) UNIQUE NOT NULL,
        matricula NVARCHAR(30) UNIQUE NOT NULL,
        telefono NVARCHAR(20),
        email NVARCHAR(100),
        direccion NVARCHAR(100),
        activo BIT DEFAULT 1
    );
    GO


    CREATE TABLE Especialidad (
        id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50) NOT NULL,
        descripcion NVARCHAR(255)
    );
    GO


    CREATE TABLE Profesional_Especialidad (
        id_profesional INT NOT NULL,
        id_especialidad INT NOT NULL,
        valor_consulta DECIMAL(10,2),
        PRIMARY KEY (id_profesional, id_especialidad),
        FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional),
        FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad)
    );
    GO


    CREATE TABLE Profesional_ObraSocial (
        id_profesional INT NOT NULL,
        id_obra_social INT NOT NULL,
        convenio_activo BIT,
        fecha_inicio DATE,
        PRIMARY KEY (id_profesional, id_obra_social),
        FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional),
        FOREIGN KEY (id_obra_social) REFERENCES ObraSocial(id_obra_social)
    );
    GO


    CREATE TABLE Consultorio (
        id_consultorio INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(50),
        direccion NVARCHAR(100),
        piso NVARCHAR(10),
        numero_sala NVARCHAR(10)
    );
    GO

    CREATE TABLE HorarioAtencion (
        id_horario INT IDENTITY(1,1) PRIMARY KEY,
        id_profesional INT NOT NULL,
        id_consultorio INT NOT NULL,
        id_especialidad INT NOT NULL,
        dia_semana NVARCHAR(15),
        hora_inicio TIME,
        hora_fin TIME,
        FOREIGN KEY (id_profesional) REFERENCES Profesional(id_profesional),
        FOREIGN KEY (id_consultorio) REFERENCES Consultorio(id_consultorio),
        FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad)
    );
    GO


    CREATE TABLE Descuento (
        id_descuento INT IDENTITY(1,1) PRIMARY KEY,
        id_obra_social INT NOT NULL,
        edad_min INT,
        edad_max INT,
        porcentaje_descuento DECIMAL(5,2),
        descripcion NVARCHAR(100),
        FOREIGN KEY (id_obra_social) REFERENCES ObraSocial(id_obra_social)
    );
    GO


    CREATE TABLE Turno (
        id_turno INT IDENTITY(1,1) PRIMARY KEY,
        id_paciente INT NOT NULL,
        id_horario INT NOT NULL,
        id_obra_social INT NULL,
        fecha_turno DATE,
        hora_turno TIME,
        estado NVARCHAR(15),
        monto_total DECIMAL(10,2),
        FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
        FOREIGN KEY (id_horario) REFERENCES HorarioAtencion(id_horario),
        FOREIGN KEY (id_obra_social) REFERENCES ObraSocial(id_obra_social)
    );
    GO


    CREATE TABLE Factura (
        id_factura INT IDENTITY(1,1) PRIMARY KEY,
        id_turno INT NOT NULL,
        monto_base DECIMAL(10,2),
        cobertura_aplicada DECIMAL(5,2),
        descuento_aplicado DECIMAL(5,2),
        monto_total DECIMAL(10,2),
        fecha_emision DATE,
        FOREIGN KEY (id_turno) REFERENCES Turno(id_turno)
    );
    GO


    --VISTAS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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



    --HORARIOS PERO POR OBRA SOCIAL, SE REPITEN LOS MISMOS HORARIOS SEGUN LOS CONVENIOS ACTIVOS QUE TENGA EL PROFESIONAL DEL TURNO CON OBRAS SOCIALES (PENSADO PARA BUSCAR COBERTURAS  )

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

---Factura Completa
GO
---Factura Completa
GO
CREATE OR ALTER VIEW vw_Facturas
AS
SELECT 
    F.id_factura,
    F.fecha_emision,
    F.monto_base,
    F.cobertura_aplicada,
    F.descuento_aplicado,
    F.monto_total,

    T.id_turno,
    T.fecha_turno,
    T.hora_turno,
    T.estado,

    P.id_paciente,
    P.nombre AS nombre_paciente,
    P.apellido AS apellido_paciente,
    P.dni,

    PR.id_profesional,
    PR.nombre AS nombre_profesional,
    PR.apellido AS apellido_profesional,

    E.nombre AS especialidad,
    OS.nombre AS obra_social

FROM Factura F
INNER JOIN Turno T ON F.id_turno = T.id_turno
INNER JOIN Paciente P ON T.id_paciente = P.id_paciente
INNER JOIN HorarioAtencion HA ON T.id_horario = HA.id_horario
INNER JOIN Profesional PR ON HA.id_profesional = PR.id_profesional
INNER JOIN Especialidad E ON HA.id_especialidad = E.id_especialidad
LEFT JOIN ObraSocial OS ON T.id_obra_social = OS.id_obra_social;
GO


    -- Resumenes Contables 

    CREATE OR ALTER VIEW v_resumen_obras_sociales AS
    SELECT 
        OS.id_obra_social,
        OS.nombre AS obra_social,
        OS.porcentaje_cobertura,
        
        -- Estadísticas de turnos
        COUNT(T.id_turno) AS total_turnos,
        COUNT(CASE WHEN T.estado = 'Finalizado' THEN 1 END) AS turnos_finalizados,
        COUNT(CASE WHEN T.estado = 'Confirmado' THEN 1 END) AS turnos_confirmados,
        COUNT(CASE WHEN T.estado = 'Pendiente' THEN 1 END) AS turnos_pendientes,
        COUNT(CASE WHEN T.estado = 'Cancelado' THEN 1 END) AS turnos_cancelados,
        
        -- Estadísticas financieras
        ISNULL(SUM(F.monto_total), 0) AS total_recaudado,
        ISNULL(AVG(F.monto_total), 0) AS promedio_por_turno,
        ISNULL(MAX(F.monto_total), 0) AS factura_maxima,
        ISNULL(MIN(F.monto_total), 0) AS factura_minima,
        
        -- Pacientes únicos
        COUNT(DISTINCT T.id_paciente) AS pacientes_unicos

    FROM ObraSocial OS
    LEFT JOIN Turno T ON OS.id_obra_social = T.id_obra_social
    LEFT JOIN Factura F ON T.id_turno = F.id_turno
    GROUP BY OS.id_obra_social, OS.nombre, OS.porcentaje_cobertura;
    GO

    --STORE PROCEDURES///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    --Insertar Horarios < Turnos
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

            ---------------------------------------------------------
            -- 1) Validaciones basicas de parametros
            ---------------------------------------------------------
            IF @cantidad_partes <= 0
                THROW 50001, 'La cantidad de partes debe ser mayor a 0.', 1;

            -- Horarios en bloques de 30 minutos (HH:00 o HH:30) sin segundos
            IF DATEPART(SECOND, @hora_inicio) <> 0
            OR DATEPART(SECOND, @hora_fin) <> 0
            OR DATEPART(MINUTE, @hora_inicio) NOT IN (0, 30)
            OR DATEPART(MINUTE, @hora_fin) NOT IN (0, 30)
            BEGIN
                THROW 50002,
                    'Los horarios deben estar en bloques de 30 minutos (HH:00 o HH:30) sin segundos.',
                    1;
            END

            DECLARE @duracion_min INT = DATEDIFF(MINUTE, @hora_inicio, @hora_fin);

            -- Inicio < Fin
            IF @duracion_min <= 0
                THROW 50003, 'La hora de fin debe ser mayor a la de inicio.', 1;

            -- No mas de 60 minutos
            IF @duracion_min > 60
                THROW 50004, 'El rango total no puede superar los 60 minutos.', 1;

            -- Duracion multiplo de 30
            IF @duracion_min % 30 <> 0
                THROW 50005, 'La diferencia entre inicio y fin debe ser multiplo de 30 minutos.', 1;

            -- Divisible en partes iguales
            IF @duracion_min % @cantidad_partes <> 0
                THROW 50006, 'El rango horario no se puede dividir en partes iguales con esa cantidad de partes.', 1;

            DECLARE @duracion_parte INT = @duracion_min / @cantidad_partes;

            -- Cada parte minimo 30 minutos y multiplo de 30
            IF @duracion_parte < 30 OR @duracion_parte % 30 <> 0
                THROW 50007, 'Cada parte debe ser de al menos 30 minutos y multiplo de 30.', 1;

            ---------------------------------------------------------
            -- 2) Validar existencia de profesional, consultorio, especialidad
            ---------------------------------------------------------
            IF NOT EXISTS (SELECT 1 FROM Profesional WHERE id_profesional = @id_profesional)
                THROW 50008, 'El profesional no existe.', 1;

            IF NOT EXISTS (SELECT 1 FROM Consultorio WHERE id_consultorio = @id_consultorio)
                THROW 50009, 'El consultorio no existe.', 1;

            IF NOT EXISTS (SELECT 1 FROM Especialidad WHERE id_especialidad = @id_especialidad)
                THROW 50010, 'La especialidad no existe.', 1;

            ---------------------------------------------------------
            -- 3) Transaccion para insertar las partes
            ---------------------------------------------------------
            BEGIN TRAN;

            DECLARE
                @i INT = 0,
                @ini_parte TIME(0),
                @fin_parte TIME(0);

            WHILE @i < @cantidad_partes
            BEGIN
                SET @ini_parte = DATEADD(MINUTE, @i * @duracion_parte, @hora_inicio);
                SET @fin_parte = DATEADD(MINUTE, (@i + 1) * @duracion_parte, @hora_inicio);

                -------------------------------------------------
                -- 3.a) Validar superposicion para el profesional
                -------------------------------------------------
                IF EXISTS (
                    SELECT 1
                    FROM HorarioAtencion ha
                    WHERE ha.id_profesional = @id_profesional
                    AND ha.dia_semana = @dia_semana
                    -- solapamiento de rangos de tiempo:
                    AND NOT (ha.hora_fin <= @ini_parte OR ha.hora_inicio >= @fin_parte)
                )
                BEGIN
                    THROW 50011,
                        'El profesional ya tiene un horario que se superpone en ese rango.',
                        1;
                END

                -------------------------------------------------
                -- 3.b) Validar superposicion para el consultorio
                -------------------------------------------------
                IF EXISTS (
                    SELECT 1
                    FROM HorarioAtencion ha
                    WHERE ha.id_consultorio = @id_consultorio
                    AND ha.dia_semana = @dia_semana
                    -- solapamiento de rangos
                    AND NOT (ha.hora_fin <= @ini_parte OR ha.hora_inicio >= @fin_parte)
                )
                BEGIN
                    THROW 50012,
                        'El consultorio ya esta ocupado en ese rango.',
                        1;
                END

                -------------------------------------------------
                -- 3.c) Insertar la parte
                -------------------------------------------------
                INSERT INTO HorarioAtencion
                    (id_profesional, id_consultorio, id_especialidad,
                    dia_semana, hora_inicio, hora_fin)
                VALUES
                    (@id_profesional, @id_consultorio, @id_especialidad,
                    @dia_semana, @ini_parte, @fin_parte);

                SET @i += 1;
            END

            COMMIT TRAN;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRAN;

            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END CATCH
    END;
    GO

    -- Insertar Turnos < Facturas

    --FUNCION NECESARIA PARA INSERTAR TURNOS - CALCULA EDAD PACIENTE
    CREATE OR ALTER FUNCTION dbo.fn_CalcularEdad
    (
        @fecha_nacimiento DATE
    )
    RETURNS INT
    AS
    BEGIN
        DECLARE @edad INT;

        -- Edad basica por diferencia de anios
        SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());

        -- Ajuste: si todavia no cumplio este anio, restamos 1
        IF (GETDATE() < DATEADD(YEAR, @edad, @fecha_nacimiento))
            SET @edad = @edad - 1;

        RETURN @edad;
    END;
    GO



    --FUNCION NECESARIA PARA INSERTAR TURNOS - CALCULA MONTO A PAGAR POR EL TURNO SEGUN DESCUENTOS Y CONVENIOS CORRESPONDIENTES
    CREATE OR ALTER FUNCTION dbo.fn_CalcularMontoTurno
    (
        @id_turno INT
    )
    RETURNS DECIMAL(10,2)
    AS
    BEGIN
        DECLARE
            @id_paciente INT,
            @id_horario INT,
            @id_obra_social INT,
            @fecha_turno DATE,
            @id_profesional INT,
            @id_especialidad INT,
            @monto_base DECIMAL(10,2),
            @edad INT,
            @tiene_convenio BIT,
            @porc_cobertura DECIMAL(5,2),
            @porc_descuento DECIMAL(5,2),
            @monto_cobertura DECIMAL(10,2),
            @monto_luego_cob DECIMAL(10,2),
            @monto_descuento DECIMAL(10,2),
            @monto_total DECIMAL(10,2);

        -- 1) Datos del turno
        SELECT 
            @id_paciente    = id_paciente,
            @id_horario     = id_horario,
            @id_obra_social = id_obra_social,
            @fecha_turno    = fecha_turno
        FROM Turno
        WHERE id_turno = @id_turno;

        IF @id_paciente IS NULL
            RETURN NULL;

        -- 2) Edad del paciente
        SELECT @edad = dbo.fn_CalcularEdad(fecha_nacimiento)
        FROM Paciente
        WHERE id_paciente = @id_paciente;

        -- 3) Profesional + Especialidad
        SELECT 
            @id_profesional = id_profesional,
            @id_especialidad = id_especialidad
        FROM HorarioAtencion
        WHERE id_horario = @id_horario;

        -- 4) Monto base
        SELECT @monto_base = valor_consulta
        FROM Profesional_Especialidad
        WHERE id_profesional = @id_profesional
        AND id_especialidad = @id_especialidad;

        IF @monto_base IS NULL
            RETURN NULL;

        -- 5) Determinar si hay convenio profesional-OS
        SELECT @tiene_convenio = CASE WHEN EXISTS (
            SELECT 1 
            FROM Profesional_ObraSocial
            WHERE id_profesional = @id_profesional
            AND id_obra_social = @id_obra_social
            AND convenio_activo = 1
        ) THEN 1 ELSE 0 END;

        -- 6) Si NO HAY convenio → no cobertura ni descuento
        IF @tiene_convenio = 0
        BEGIN
            RETURN @monto_base;
        END;

        -- 7) Porcentaje cobertura (entero tipo 70 = 70%)
        SELECT @porc_cobertura = porcentaje_cobertura
        FROM ObraSocial
        WHERE id_obra_social = @id_obra_social;

        -- 8) Porcentaje descuento segun edad (entero tipo 15 = 15%)
        SELECT @porc_descuento =
            ISNULL(
                (SELECT TOP 1 porcentaje_descuento
                FROM Descuento
                WHERE id_obra_social = @id_obra_social
                AND @edad BETWEEN edad_min AND edad_max
                ORDER BY porcentaje_descuento DESC),
            0);

        -- 9) Calculos
        SET @monto_cobertura = ROUND(@monto_base * (@porc_cobertura / 100.0), 2);
        SET @monto_luego_cob = @monto_base - @monto_cobertura;

        SET @monto_descuento = ROUND(@monto_luego_cob * (@porc_descuento / 100.0), 2);
        SET @monto_total     = @monto_luego_cob - @monto_descuento;

        RETURN @monto_total;
    END;
    GO


    -- Creacion del turno con validaciones que corresponden a la capa turno y usando las funciones definidas////////////////////////////////////////////////////////////////////////////////

    GO
    CREATE OR ALTER PROCEDURE sp_CrearTurno
    (
        @id_paciente INT,
        @id_horario INT,
        @fecha_turno DATE,
        @obra_social_id INT = NULL   -- puede ser NULL = particular
    )
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE
            @hora_turno TIME,
            @monto_total DECIMAL(10,2),
            @id_turno_temp INT;

        -------------------------------------------------------------------
        -- 1) VALIDAR PACIENTE
        -------------------------------------------------------------------
        IF NOT EXISTS (SELECT 1 FROM Paciente WHERE id_paciente = @id_paciente)
        BEGIN
            RAISERROR('El paciente no existe.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Paciente WHERE id_paciente = @id_paciente AND activo = 0)
        BEGIN
            RAISERROR('El paciente no esta activo.', 16, 1);
            RETURN;
        END

        -------------------------------------------------------------------
        -- 2) VALIDAR HORARIO
        -------------------------------------------------------------------
        IF NOT EXISTS (SELECT 1 FROM HorarioAtencion WHERE id_horario = @id_horario)
        BEGIN
            RAISERROR('El horario de atencion no existe.', 16, 1);
            RETURN;
        END

        -- obtener hora_turno desde el horario (hora_inicio)
        SELECT @hora_turno = hora_inicio
        FROM HorarioAtencion
        WHERE id_horario = @id_horario;

        -------------------------------------------------------------------
        -- 3) VALIDAR FECHA DEL TURNO
        -------------------------------------------------------------------
        IF @fecha_turno < CAST(GETDATE() AS DATE)
        BEGIN
            RAISERROR('La fecha del turno no puede ser anterior a hoy.', 16, 1);
            RETURN;
        END

        -------------------------------------------------------------------
        -- 4) HACER UN INSERT PROVISORIO PARA CALCULAR EL MONTO
        -------------------------------------------------------------------
        INSERT INTO Turno (id_paciente, id_horario, id_obra_social, fecha_turno, hora_turno, estado, monto_total)
        VALUES (@id_paciente, @id_horario, @obra_social_id, @fecha_turno, @hora_turno, 'Pendiente', 0);

        SET @id_turno_temp = SCOPE_IDENTITY();

        -------------------------------------------------------------------
        -- 5) CALCULAR MONTO DEL TURNO
        -------------------------------------------------------------------
        SELECT @monto_total = dbo.fn_CalcularMontoTurno(@id_turno_temp);

        IF @monto_total IS NULL
        BEGIN
            RAISERROR('No se pudo calcular el monto del turno.', 16, 1);

            -- retroceder el turno creado temporalmente
            DELETE FROM Turno WHERE id_turno = @id_turno_temp;

            RETURN;
        END

        -------------------------------------------------------------------
        -- 6) ACTUALIZAR MONTO
        -------------------------------------------------------------------
        UPDATE Turno
        SET monto_total = @monto_total
        WHERE id_turno = @id_turno_temp;

        -------------------------------------------------------------------
        -- 7) CONFIRMAR OK
        -------------------------------------------------------------------
        SELECT 
            id_turno = @id_turno_temp,
            mensaje = 'Turno creado correctamente.',
            monto_total = @monto_total;
    END
    GO


    --Trigger para Facturacion - Crear Factura//////////////////////////////////////////////////////////////////

    GO

    CREATE OR ALTER TRIGGER t_FinalizarTurno
    ON Turno
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        --------------------------------------------------------------
        -- 1) Detectar únicamente cambios de estado → Finalizado
        --------------------------------------------------------------
        IF NOT EXISTS (
            SELECT 1
            FROM inserted I
            INNER JOIN deleted D ON I.id_turno = D.id_turno
            WHERE D.estado <> 'Finalizado'
            AND I.estado = 'Finalizado'
        )
            RETURN;

        --------------------------------------------------------------
        -- 2) Insertar factura SOLO si no existe una factura previa
        --------------------------------------------------------------
        INSERT INTO Factura (
            id_turno,
            monto_base,
            cobertura_aplicada,
            descuento_aplicado,
            monto_total,
            fecha_emision
        )
        SELECT  
            I.id_turno,

            -- MONTO BASE
            PE.valor_consulta AS monto_base,

            -- COBERTURA (si había convenio → cobertura, sino 0)
            CASE 
                WHEN PO.convenio_activo = 1 THEN OS.porcentaje_cobertura
                ELSE 0
            END AS cobertura_aplicada,

            -- DESCUENTO (si había convenio y coincidía edad → descuento, sino 0)
            ISNULL(
                (
                    SELECT TOP 1 d.porcentaje_descuento
                    FROM Descuento d
                    WHERE d.id_obra_social = I.id_obra_social
                    AND dbo.fn_CalcularEdad(P.fecha_nacimiento)
                            BETWEEN d.edad_min AND d.edad_max
                    ORDER BY d.porcentaje_descuento DESC
                ),
            0) AS descuento_aplicado,

            -- MONTO TOTAL YA CALCULADO EN EL TURNO
            I.monto_total,

            CAST(GETDATE() AS DATE) AS fecha_emision

        FROM inserted I
        INNER JOIN deleted D ON I.id_turno = D.id_turno
        INNER JOIN Paciente P ON I.id_paciente = P.id_paciente
        INNER JOIN HorarioAtencion HA ON I.id_horario = HA.id_horario
        INNER JOIN Profesional_Especialidad PE 
            ON HA.id_profesional = PE.id_profesional
        AND HA.id_especialidad = PE.id_especialidad
        LEFT JOIN ObraSocial OS ON I.id_obra_social = OS.id_obra_social
        LEFT JOIN Profesional_ObraSocial PO 
            ON PO.id_profesional = HA.id_profesional
        AND PO.id_obra_social = I.id_obra_social
        AND PO.convenio_activo = 1

        WHERE I.estado = 'Finalizado'
        AND D.estado <> 'Finalizado'
        AND NOT EXISTS (SELECT 1 FROM Factura F WHERE F.id_turno = I.id_turno);

    END;
    GO


    --- STORE PROCEDURES PARA BUSQUEDAS CON PARAMETROS DINAMICOS

    ---BUSQUEDA DE TURNOS DINAMICA
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
    --BUSQUEDA DISPONIBILIDAD DE TURNO DINAMICO
  GO
CREATE OR ALTER PROCEDURE sp_BuscarDisponibilidadTurno
(
    @obraSocialId INT = NULL,              
    @tipoFiltro NVARCHAR(20) = NULL,      
    @valorFiltro INT = NULL,               
    @diaSemana NVARCHAR(15) = NULL,        
    @horaDesde TIME = NULL,                
    @horaHasta TIME = NULL                 
)
AS
BEGIN

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
    FROM vw_HorariosPorObraSocial H
    WHERE
        (@obraSocialId IS NULL OR id_obra_social = @obraSocialId)

        AND (
                @tipoFiltro IS NULL
                OR (@tipoFiltro = 'especialidad' AND id_especialidad = @valorFiltro)
                OR (@tipoFiltro = 'profesional' AND id_profesional = @valorFiltro)
            )

        AND (
                @diaSemana IS NULL
                OR LOWER(dia_semana) = LOWER(@diaSemana)
            )

        AND (
                @horaDesde IS NULL
                OR (
                        @horaHasta IS NULL
                        AND hora_inicio = @horaDesde
                    )
                OR (
                        @horaHasta IS NOT NULL
                        AND hora_inicio BETWEEN @horaDesde AND @horaHasta
                    )
            )

        --  excluir horarios ya tomados
        AND NOT EXISTS (
            SELECT 1
            FROM Turno T
            WHERE T.id_horario = H.id_horario
              AND T.estado IN ('Pendiente', 'Confirmado', 'Finalizado') --cancelado vuelve a estar ready
        )

    ORDER BY dia_semana, hora_inicio, nombre_profesional;

END
GO


GO

CREATE TRIGGER t_BajaPaciente ON Paciente
INSTEAD OF DELETE
AS BEGIN
    -- Si en la tabla deleted no encontramos ningun paciente activo, estan todos eliminados, no haremos nada
    IF NOT EXISTS(
        SELECT 1 FROM deleted D WHERE D.activo = 1
    )
    BEGIN
        PRINT('No hay pacientes a eliminar')
        ROLLBACK TRANSACTION
        RETURN
    END

    -- hacemos la baja logica de todos los pacientes a los que se quiera eliminar
    -- que estaban activos
    UPDATE P SET P.activo = 0 FROM Paciente P 
    INNER JOIN deleted D ON P.id_paciente = D.id_paciente
    WHERE D.activo = 1

    -- cambiamos sus turnos futuros que no estaban finalizados a cancelado
    UPDATE T
    SET T.estado = 'Cancelado'
    FROM Turno T
    INNER JOIN deleted D ON T.id_paciente = D.id_paciente
    WHERE D.activo = 1                              
      AND T.estado IN ('Pendiente', 'Confirmado')   
      AND T.fecha_turno >= CAST(GETDATE() AS DATE); 
    
END