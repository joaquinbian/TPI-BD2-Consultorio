USE consultorio_db_v2;
GO




INSERT INTO ObraSocial (nombre, porcentaje_cobertura, telefono, direccion) VALUES
('OSDE', 70.00, '0800-555-6733', 'Av. Leandro N. Alem 1067, CABA'),
('Swiss Medical', 65.00, '0810-333-8477', 'Av. Callao 1995, CABA'),
('Galeno', 60.00, '0800-122-4253', 'Av. Córdoba 1351, CABA'),
('IOMA', 50.00, '0221-429-6800', 'Calle 46 N° 602, La Plata'),
('OSECAC', 55.00, '0800-888-6732', 'Av. Independencia 2880, CABA'),
('Medifé', 65.00, '0810-999-6334', 'Av. Santa Fe 1611, CABA'),
('Particular', 0.00, NULL, NULL);
GO


INSERT INTO Especialidad (nombre, descripcion) VALUES
('Clínica Médica', 'Atención general de adultos'),
('Pediatría', 'Atención de niños y adolescentes'),
('Cardiología', 'Especialidad en enfermedades del corazón'),
('Traumatología', 'Atención de lesiones músculo-esqueléticas'),
('Dermatología', 'Especialidad en enfermedades de la piel'),
('Ginecología', 'Salud de la mujer'),
('Odontología', 'Salud bucal y dental'),
('Oftalmología', 'Especialidad en enfermedades de la vista');
GO


INSERT INTO Profesional (nombre, apellido, dni, matricula, telefono, email, direccion, activo) VALUES
('María', 'González', '28456789', 'MN-45678', '11-4567-8901', 'mgonzalez@consultorio.com', 'Av. Corrientes 1234, CABA', 1),
('Carlos', 'Rodríguez', '30123456', 'MN-38765', '11-4567-8902', 'crodriguez@consultorio.com', 'Av. Rivadavia 5678, CABA', 1),
('Ana', 'Martínez', '32789012', 'MN-52341', '11-4567-8903', 'amartinez@consultorio.com', 'Av. Belgrano 910, CABA', 1),
('Roberto', 'Fernández', '27654321', 'MN-41289', '11-4567-8904', 'rfernandez@consultorio.com', 'Av. Santa Fe 2345, CABA', 1),
('Laura', 'Sánchez', '31234567', 'MN-49876', '11-4567-8905', 'lsanchez@consultorio.com', 'Av. Callao 678, CABA', 1),
('Diego', 'López', '29876543', 'MN-47123', '11-4567-8906', 'dlopez@consultorio.com', 'Av. Córdoba 3456, CABA', 1);
GO


INSERT INTO Consultorio (nombre, direccion, piso, numero_sala) VALUES
('Consultorio Central', 'Av. Córdoba 1500, CABA', '3', '301'),
('Consultorio Central', 'Av. Córdoba 1500, CABA', '3', '302'),
('Consultorio Central', 'Av. Córdoba 1500, CABA', '4', '401'),
('Consultorio Belgrano', 'Av. Cabildo 2100, CABA', '2', '201'),
('Consultorio Belgrano', 'Av. Cabildo 2100, CABA', '2', '202');
GO


INSERT INTO Profesional_Especialidad (id_profesional, id_especialidad, valor_consulta) VALUES
(1, 1, 15000.00), 
(2, 2, 18000.00),
(3, 3, 25000.00),
(4, 4, 22000.00),
(5, 5, 20000.00),
(6, 6, 23000.00),
(1, 5, 20000.00),
(3, 1, 15000.00);
GO

INSERT INTO Profesional_ObraSocial (id_profesional, id_obra_social, convenio_activo, fecha_inicio) VALUES
(1, 1, 1, '2024-01-01'),
(1, 2, 1, '2024-01-01'),
(1, 3, 1, '2024-01-01'),
(2, 1, 1, '2024-01-01'),
(2, 4, 1, '2024-01-01'),
(3, 1, 1, '2024-01-01'),
(3, 2, 1, '2024-01-01'),
(4, 1, 1, '2024-01-01'),
(4, 5, 1, '2024-01-01'),
(5, 2, 1, '2024-01-01'),
(5, 6, 1, '2024-01-01'),
(6, 1, 1, '2024-01-01'),
(6, 3, 1, '2024-01-01');
GO


INSERT INTO HorarioAtencion (id_profesional, id_consultorio, id_especialidad, dia_semana, hora_inicio, hora_fin) VALUES
(1, 1, 1, 'Lunes', '09:00', '13:00'),
(1, 1, 1, 'Miércoles', '09:00', '13:00'),
(1, 1, 1, 'Viernes', '14:00', '18:00'),
(2, 2, 2, 'Lunes', '14:00', '18:00'),
(2, 2, 2, 'Martes', '09:00', '13:00'),
(2, 2, 2, 'Jueves', '14:00', '18:00'),
(3, 3, 3, 'Martes', '14:00', '18:00'),
(3, 3, 3, 'Jueves', '09:00', '13:00'),
(3, 3, 3, 'Viernes', '09:00', '13:00'),
(4, 4, 4, 'Lunes', '08:00', '12:00'),
(4, 4, 4, 'Miércoles', '14:00', '18:00'),
(4, 4, 4, 'Viernes', '08:00', '12:00'),
(5, 5, 5, 'Martes', '10:00', '14:00'),
(5, 5, 5, 'Jueves', '15:00', '19:00'),
(6, 1, 6, 'Miércoles', '15:00', '19:00'),
(6, 3, 6, 'Viernes', '10:00', '14:00');
GO


INSERT INTO Paciente (nombre, apellido, dni, fecha_nacimiento, telefono, email, direccion, id_obra_social, nro_afiliado, activo) VALUES
('Juan', 'Pérez', '35123456', '1990-03-15', '11-5555-1234', 'jperez@email.com', 'Av. Corrientes 500, CABA', 1, '1234567890', 1),
('Sofía', 'Ramírez', '40234567', '2005-07-22', '11-5555-2345', 'sramirez@email.com', 'Av. Santa Fe 1200, CABA', 2, '2345678901', 1),
('Miguel', 'Torres', '28345678', '1985-11-10', '11-5555-3456', 'mtorres@email.com', 'Av. Rivadavia 2300, CABA', 1, '3456789012', 1),
('Carolina', 'Díaz', '42456789', '2010-02-18', '11-5555-4567', 'cdiaz@email.com', 'Av. Callao 800, CABA', 4, '4567890123', 1),
('Roberto', 'Gómez', '25567890', '1978-09-05', '11-5555-5678', 'rgomez@email.com', 'Av. Belgrano 1500, CABA', 3, '5678901234', 1),
('Lucía', 'Morales', '38678901', '1995-12-30', '11-5555-6789', 'lmorales@email.com', 'Av. Córdoba 2100, CABA', 5, '6789012345', 1),
('Fernando', 'Silva', '31789012', '1988-04-25', '11-5555-7890', 'fsilva@email.com', 'Av. Cabildo 1800, CABA', 2, '7890123456', 1),
('Valentina', 'Castro', '43890123', '2012-08-14', '11-5555-8901', 'vcastro@email.com', 'Av. Pueyrredón 900, CABA', 1, '8901234567', 1),
('Andrés', 'Ruiz', '29901234', '1982-06-20', '11-5555-9012', 'aruiz@email.com', 'Av. Independencia 1100, CABA', 6, '9012345678', 1),
('Martina', 'Vargas', '39012345', '1998-01-07', '11-5555-0123', 'mvargas@email.com', 'Av. Corrientes 3000, CABA', 7, NULL, 1);
GO


INSERT INTO Descuento (id_obra_social, edad_min, edad_max, porcentaje_descuento, descripcion) VALUES
(1, 0, 12, 15.00, 'Descuento pediátrico OSDE'),
(1, 65, 120, 20.00, 'Descuento tercera edad OSDE'),
(2, 0, 12, 10.00, 'Descuento pediátrico Swiss Medical'),
(3, 0, 12, 12.00, 'Descuento pediátrico Galeno'),
(4, 0, 18, 20.00, 'Descuento menor IOMA'),
(4, 65, 120, 25.00, 'Descuento jubilados IOMA'),
(5, 65, 120, 15.00, 'Descuento tercera edad OSECAC');
GO


INSERT INTO Turno (id_paciente, id_horario, id_obra_social, fecha_turno, hora_turno, estado, monto_total) VALUES
(1, 1, 1, '2025-01-15', '09:30', 'Finalizado', 4500.00),
(2, 4, 2, '2025-01-15', '14:30', 'Finalizado', 6300.00),
(3, 7, 1, '2025-01-16', '15:00', 'Finalizado', 7500.00),
(4, 5, 4, '2025-01-17', '09:30', 'Finalizado', 7200.00),
(5, 10, 3, '2025-01-19', '08:30', 'Finalizado', 8800.00),

(6, 12, 5, '2025-11-18', '10:30', 'Confirmado', 11000.00),
(7, 2, 2, '2025-11-20', '10:00', 'Confirmado', 6300.00),
(8, 4, 1, '2025-11-22', '15:00', 'Confirmado', 4590.00),
(9, 8, 6, '2025-11-25', '10:30', 'Confirmado', 8050.00),
(10, 15, 7, '2025-11-27', '16:00', 'Confirmado', 23000.00),

(1, 3, 1, '2025-11-29', '15:00', 'Pendiente', 4500.00),
(3, 7, 1, '2025-12-02', '16:00', 'Pendiente', 7500.00),

(2, 6, 2, '2025-11-21', '09:30', 'Cancelado', 6300.00);
GO


INSERT INTO Factura (id_turno, monto_base, cobertura_aplicada, descuento_aplicado, monto_total, fecha_emision) VALUES
(1, 15000.00, 70.00, 0.00, 4500.00, '2025-01-15'),
(2, 18000.00, 65.00, 0.00, 6300.00, '2025-01-15'),
(3, 25000.00, 70.00, 0.00, 7500.00, '2025-01-16'),
(4, 18000.00, 50.00, 10.00, 7200.00, '2025-01-17'),
(5, 22000.00, 60.00, 0.00, 8800.00, '2025-01-19');
GO
