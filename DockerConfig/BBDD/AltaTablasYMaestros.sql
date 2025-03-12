CREATE DATABASE TestDB;
GO

USE TestDB;
GO

CREATE TABLE msRolesUsuario (
    IDRolUsuario INT PRIMARY KEY IDENTITY(1,1),
    DescripcionRol VARCHAR(255) NOT NULL,
    Eliminado BIT DEFAULT 0
);

CREATE TABLE dtUsuarios (
    IDUsuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Correo VARCHAR(100),
    IDRolUsuario INT,
    Contrasenia VARCHAR(100),
    Eliminado BIT DEFAULT 0,
    FOREIGN KEY (IDRolUsuario) REFERENCES msRolesUsuario(IDRolUsuario)
);

CREATE TABLE dtArtistas (
    IDArtista INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Sexo VARCHAR(50) CHECK(Sexo IN ('Masculino', 'Femenino', 'Otro')) NOT NULL,
    LinkFoto VARCHAR(500),
    Biografia TEXT,
    Eliminado BIT DEFAULT 0
);

CREATE TABLE dtVotos (
    IDVoto INT PRIMARY KEY IDENTITY(1,1),
    IDArtista INT,
    IDUsuario INT,
    FechaVoto DATE,
    Eliminado BIT DEFAULT 0,
    FOREIGN KEY (IDArtista) REFERENCES dtArtistas(IDArtista),
    FOREIGN KEY (IDUsuario) REFERENCES dtUsuarios(IDUsuario),
    CONSTRAINT ck_votoPorDiaUsuarioArtista UNIQUE(IDArtista, IDUsuario, FechaVoto)
);

CREATE TABLE dtLogVotos (
    IDAuditoria INT PRIMARY KEY IDENTITY(1,1),
    IDVoto INT,
    Descripcion VARCHAR(100),
    FechaAccion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDVoto) REFERENCES dtVotos(IDVoto)
);

CREATE TABLE dtKeysPorUsuario (
    IDKeysPorUsuario INT PRIMARY KEY IDENTITY(1,1),
    Clave VARCHAR(256),
    IdUsuario INT,
    Eliminado BIT DEFAULT 0,
    FOREIGN KEY (IdUsuario) REFERENCES dtUsuarios(IdUsuario),
    CONSTRAINT ck_unaKeyPorUsuario UNIQUE(Clave, IdUsuario)
);
GO


/******************POBLADO DE TABLAS MAESTRAS Y DATOS DE PRUEBA******************/

insert into MsRolesUsuario(descripcionRol)
values('Sin rol');
insert into MsRolesUsuario(descripcionRol)
values('Administrador');


insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Miguel','Sagaseta de Ilúrdoz','prueba@prueba.es',2,'patata123');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('David','Muñoz','prueba@prueba.es',1,'patata123');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Carlos','Jimeno','prueba@prueba.es',1,'patata123');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Mayra','Nogales','prueba@prueba.es',1,'patata123');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Iñigo','Varela','prueba@prueba.es',1,'patata123');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Miguel','Sagaseta de Ilúrdoz','prueba@prueba.es',1,'patata123');


insert into dtArtistas(Nombre,Apellidos,Sexo,LinkFoto,Biografia)
values('Lucas','a','Masculino','www.google.es','Mató a una mosca');
insert into dtArtistas(Nombre,Apellidos,Sexo,LinkFoto,Biografia)
values('Andrea','b','Femenino','www.google.es','Mató a una mosca');


insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(1,1,'20250226');
insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(1,2,'20250226');
insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(1,3,'20250226');
insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(2,1,'20250226');
insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(2,2,'20250226');
insert into dtVotos(IDArtista,IDUsuario,FechaVoto)
values(2,3,'20250226');

insert into dtKeysPorUsuario(Clave,IDUsuario)
values('bee6e7a8-7e37-49d3-af03-f598d004f827',1);
insert into dtKeysPorUsuario(Clave,IDUsuario)
values('54d8ad30-1d2a-4300-9dc5-2c257ad880d2',2);
GO

