
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
