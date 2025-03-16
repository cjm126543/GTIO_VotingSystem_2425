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
    Biografia VARCHAR(1000),
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
values('Miguel','Sagaseta de Ilúrdoz','prueba@prueba.es',2,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('David','Muñoz','prueba@prueba.es',1,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Carlos','Jimeno','prueba@prueba.es',1,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Mayra','Nogales','prueba@prueba.es',1,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Iñigo','Varela','prueba@prueba.es',1,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');
insert into dtUsuarios(Nombre,Apellidos,Correo,IDRolUsuario,Contrasenia)
values('Miguel','Sagaseta de Ilúrdoz','prueba@prueba.es',1,'56734720a846860a8b7c280c407c5f0d1eda2ee92d4a68a1d8a027914bd08e21');


INSERT INTO dtArtistas(Nombre, Apellidos, Sexo, LinkFoto, Biografia) VALUES
('Álex', 'Márquez', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 24/11/1998 en Córdoba. Compositor y coproductor para otros artistas, también trabaja en marketing digital y restauración. Le gusta el surf, el gimnasio, pasear, leer y pasar tiempo con amigos. Su estilo musical abarca Pop, Pop-rock y pop-latino.'),
('Álvaro', 'Mayo', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 04/03/2002 en Sevilla. Estudiante de técnico de sonido, trabaja en una orquesta y canta en un grupo musical. Su hobby es el maquillaje. Su estilo musical incluye Pop internacional, R&B y Soul.'),
('Denna', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 30/03/2001 en Ogíjares (Granada). Cantante y actriz, graduada en un doble grado de arte dramático y artes escénicas en ESAEM. Le encanta la cocina y el gimnasio. Su estilo musical es Pop House y urbano.'),
('Bea', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 25/05/2004 en San Fernando de Henares (Madrid). Estudia Magisterio de Educación Primaria y da clases de música a niños pequeños. Toca el piano y su estilo musical incluye Rock 80s, Soul y Pop.'),
('Paul', 'Thin', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 14/12/2002 en Armilla (Granada). Estudiante de Audiovisuales. Sus hobbies son los videojuegos y el cine. Su estilo musical es Reguetón y Hip Hop.'),
('Omar', '', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 09/05/1997 en Yunquera de Henares (Guadalajara). Técnico de emergencias sanitarias, preparándose para oposiciones a bombero. Toca el saxo tenor en una charanga y juega al baloncesto. Su estilo musical es cantautor, rock y pop-rock español.'),
('Chiara', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 11/03/2004 en Ciutadella de Menorca. Estudia canto moderno en la ESMUC y canta en hoteles y restaurantes en verano. Compone y toca la guitarra, el piano y el bajo. Su estilo musical incluye Pop, Pop Rock, Soul, R&B y Folk.'),
('Juanjo', 'Bona', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 10/11/2003 en Magallón (Zaragoza). Estudiante de Ingeniería Naval en Madrid. Le gusta la vida rural y el terraceo. Su estilo musical incluye jotas, rock y musicales.'),
('Salma', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 04/10/2002 en Mijas (Málaga). Cantante. Toca la guitarra y el piano, y compone. Su estilo musical es Flamenco Pop.'),
('Lucas', '', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 10/11/2000 en Montevideo, Uruguay, y reside en Vallirana (Barcelona). Barbero. Le apasiona cantar. Su estilo musical es Rock Pop y R&B.'),
('Cris', '', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 20/09/1999 en San Cristóbal de La Laguna (Tenerife). Actor de teatro musical. Sus hobbies son los videojuegos, salir con amigos y jugar al billar. Su estilo musical es RnB, Pop, Soul y Baladas.'),
('Martin', 'Urrutia', 'Masculino', 'www.google.es', 'Concursante de OT 2023. Nació el 30/03/2005 en Getxo (Bizkaia). Estudiante de Arte Dramático. Le gustan las actividades culturales con amigos. Su estilo musical es Pop/Rock Alternativo.'),
('Naiara', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 29/04/1997 en Zaragoza. Cantante de orquesta. Disfruta de ir en coche sola escuchando música. Su estilo musical es variado.'),
('Ruslana', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 10/09/2005 en Madrid. Estudia 2º de Bachiller en Artes Escénicas. Toca el bajo eléctrico, le gusta el arte, la moda, interpretación y baile. Su estilo musical incluye Rock, R&B y Soul.'),
('Suzette', '', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 21/04/2001 en Santa Cruz de Tenerife. Estudia Coaching Administrativo y Empresarial. Le gusta componer, hacer trenzas y patinar. Su estilo musical incluye Soul, R&B, Gospel, Pop, Afro y Jazz.'),
('Violeta', 'Hódar', 'Femenino', 'www.google.es', 'Concursante de OT 2023. Nació el 23/01/2001 en Motril (Granada). Graduada en Periodismo, Publicidad y Audiovisuales. Le gusta pintar. Su estilo musical es R&B. Tocó el clarinete durante 10 años.');


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



