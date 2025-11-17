INSERT INTO ObraSocial (nombre, porcentaje_cobertura, telefono, direccion) VALUES
('OSDE', 70, '0800-555-6733', 'Av. Alem 1067'),
('Swiss Medical', 65, '0810-333-8477', 'Av. Callao 1995'),
('Galeno', 60, '0800-122-4253', 'Av. Córdoba 1351'),
('IOMA', 50, '0221-429-6800', 'Calle 46 602, La Plata'),
('OSECAC', 55, '0800-888-6732', 'Av. Independencia 2880'),
('Particular', 0, NULL, NULL),
('Emergencias Prepaga', 40, NULL, NULL); -- Obra social económica para probar casos de baja cobertura

INSERT INTO Especialidad (nombre, descripcion) VALUES
('Clínica Médica', 'Generalista'),
('Pediatría', 'Niños'),
('Cardiología', 'Corazón'),
('Dermatología', 'Piel'),
('Traumatología', 'Huesos y músculos'),
('Ginecología', 'Salud femenina');

INSERT INTO Profesional (nombre, apellido, dni, matricula, telefono, email, direccion, activo) VALUES
('María', 'González', '28456789', 'MN-1001', '11-4300-0001', 'maria@med.com', 'Corrientes 123', 1),
('Carlos', 'Ruiz',      '29567890', 'MN-1002', '11-4300-0002', 'carlos@med.com', 'Rivadavia 999', 1),
('Ana', 'Martínez',     '30678901', 'MN-1003', '11-4300-0003', 'ana@med.com', 'Belgrano 450', 1),
('Roberto', 'Funes',    '31789012', 'MN-1004', '11-4300-0004', 'roberto@med.com', 'Callao 1200', 1),
('Laura', 'Sosa',       '32890123', 'MN-1005', '11-4300-0005', 'laura@med.com', 'Córdoba 2100', 1),
('Diego', 'Alonso',     '33901234', 'MN-1006', '11-4300-0006', 'diego@med.com', 'Cabildo 2000', 1),
('Martina', 'Silva',    '35012345', 'MN-1007', '11-4300-0007', 'martina@med.com', 'Libertador 5000', 1);


INSERT INTO Consultorio (nombre, direccion, piso, numero_sala) VALUES
('Central', 'Av. Córdoba 1500', '3', '301'),
('Central', 'Av. Córdoba 1500', '3', '302'),
('Central', 'Av. Córdoba 1500', '4', '401'),
('Belgrano', 'Av. Cabildo 2100', '2', '201'),
('Belgrano', 'Av. Cabildo 2100', '2', '202'),
('Anexo Norte', 'Av. General Paz 150', '1', '102');

INSERT INTO Profesional_Especialidad (id_profesional, id_especialidad, valor_consulta) VALUES
(1,1,15000),(1,4,18000),
(2,2,14000),
(3,3,25000),(3,1,15000),
(4,5,22000),
(5,4,20000),
(6,6,23000),
(7,1,15000),(7,2,17000);


INSERT INTO Paciente (nombre, apellido, dni, fecha_nacimiento, telefono, email, direccion, id_obra_social, nro_afiliado, activo) VALUES
('Juan', 'Pérez', '35123456','1990-03-15','11-5555-1234','jp@x.com','Corrientes 500',1,'1111',1),
('Lucía','Gómez','46234567','2015-05-10','11-5555-2345','lg@x.com','Callao 300',2,'2222',1),
('Roberto','Silva','28123456','1950-08-22','11-5555-3456','rs@x.com','Belgrano 1000',1,'3333',1),
('Elena','Martín','29345678','2001-11-01','11-5555-4567','em@x.com','Rivadavia 800',4,'4444',1),
('Martín','López','31789012','1988-02-19','11-5555-5678','ml@x.com','Córdoba 2500',3,'5555',1),
('Valentina','Ruiz','43890123','2012-08-14','11-5555-6789','vr@x.com','Independencia 800',6,NULL,1),
('Carlos','Duarte','29001122','1980-09-23','11-5555-7788','cd@x.com','Cabildo 2000',7,'9999',0); -- inactivo

DECLARE 
    @profesional INT,
    @dia INT,
    @inicio TIME,
    @fin TIME,
    @consultorio INT,
    @diaText VARCHAR(20);

-- Config
DECLARE @DuracionMinutos INT = 30;
DECLARE @HoraManianaInicio TIME = '08:00';
DECLARE @HoraManianaFin   TIME = '12:00';
DECLARE @HoraTardeInicio  TIME = '14:00';
DECLARE @HoraTardeFin     TIME = '18:00';
DECLARE @CantConsultorios INT = 3;

-- Tabla con profesionales activos
DECLARE @Profesionales TABLE(id_prof INT);
INSERT INTO @Profesionales SELECT id_profesional FROM Profesional WHERE activo = 1;

-- Cursor
DECLARE cur CURSOR FOR SELECT id_prof FROM @Profesionales;
OPEN cur;
FETCH NEXT FROM cur INTO @profesional;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @dia = 1;  -- Lunes

    WHILE @dia <= 5
    BEGIN
        -- Convertimos número a texto
        SET @diaText =
            CASE @dia
                WHEN 1 THEN 'Lunes'
                WHEN 2 THEN 'Martes'
                WHEN 3 THEN 'Miércoles'
                WHEN 4 THEN 'Jueves'
                WHEN 5 THEN 'Viernes'
            END;

        SET @consultorio = 1;

        WHILE @consultorio <= @CantConsultorios
        BEGIN
            ------------------------------
            -- BLOQUE MAÑANA
            ------------------------------
            SET @inicio = @HoraManianaInicio;

            WHILE DATEADD(MINUTE, @DuracionMinutos, @inicio) <= @HoraManianaFin
            BEGIN
                SET @fin = DATEADD(MINUTE, @DuracionMinutos, @inicio);

                INSERT INTO HorarioAtencion (id_profesional, id_consultorio, id_especialidad, dia_semana, hora_inicio, hora_fin)
                SELECT @profesional, @consultorio, PE.id_especialidad, @diaText, @inicio, @fin
                FROM Profesional_Especialidad PE
                WHERE PE.id_profesional = @profesional;

                SET @inicio = @fin;
            END

            ------------------------------
            -- BLOQUE TARDE
            ------------------------------
            SET @inicio = @HoraTardeInicio;

            WHILE DATEADD(MINUTE, @DuracionMinutos, @inicio) <= @HoraTardeFin
            BEGIN
                SET @fin = DATEADD(MINUTE, @DuracionMinutos, @inicio);

                INSERT INTO HorarioAtencion (id_profesional, id_consultorio, id_especialidad, dia_semana, hora_inicio, hora_fin)
                SELECT @profesional, @consultorio, PE.id_especialidad, @diaText, @inicio, @fin
                FROM Profesional_Especialidad PE
                WHERE PE.id_profesional = @profesional;

                SET @inicio = @fin;
            END

            SET @consultorio += 1;
        END

        SET @dia += 1;
    END

    FETCH NEXT FROM cur INTO @profesional;
END

CLOSE cur;
DEALLOCATE cur;



INSERT INTO Turno (id_paciente,id_horario,id_obra_social,fecha_turno,hora_turno,estado,monto_total) VALUES

-- Finalizados (facturables)
(1, 1, 1, '2025-01-10','08:30','Finalizado',4500),
(2, 5, 2, '2025-01-11','09:00','Finalizado',6300),

-- Confirmados (para probar facturación futura)
(3, 10, 1, '2025-02-12','10:00','Confirmado',7500),
(4, 11, 4, '2025-02-12','10:30','Confirmado',6200),

-- Pendientes
(5, 20, 3, '2025-03-10','11:00','Pendiente',8800),

-- Reprogramación
(6, 25, 1, '2025-03-11','14:00','Pendiente',4590),

-- Cancelado previamente
(7, 30, 7, '2025-03-12','15:00','Cancelado',23000);
