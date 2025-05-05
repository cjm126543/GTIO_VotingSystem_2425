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
('Álex', 'Márquez', 'Masculino', 'https://los40.com/resizer/v2/JCNELAJY3RCHDMRNQHZJRXIEMY.jpg?auth=5f9e7d9eec231f3173477ba782cbced30fff50a88578c01b66117e9a475e95ca&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 24/11/1998 en Córdoba. Compositor y coproductor para otros artistas, también trabaja en marketing digital y restauración. Le gusta el surf, el gimnasio, pasear, leer y pasar tiempo con amigos. Su estilo musical abarca Pop, Pop-rock y pop-latino.'),
('Álvaro', 'Mayo', 'Masculino', 'https://los40.com/resizer/v2/MYDWSKSMGNBINGHWNWDCV7S4GE.jpg?auth=b73af7d7bb78ef89eecd856a0d6ee49d99fbae4d650aab03d75dd211dd0b569c&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 04/03/2002 en Sevilla. Estudiante de técnico de sonido, trabaja en una orquesta y canta en un grupo musical. Su hobby es el maquillaje. Su estilo musical incluye Pop internacional, R&B y Soul.'),
('Denna', '', 'Femenino', 'https://los40.com/resizer/v2/2FDQDUT6O5AWBKVTGL7RSEWDMQ.jpg?auth=51ab98925f673d6b32c5f50db13596749769ef6dad471853aa5fcabb5f760e3c&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 30/03/2001 en Ogíjares (Granada). Cantante y actriz, graduada en un doble grado de arte dramático y artes escénicas en ESAEM. Le encanta la cocina y el gimnasio. Su estilo musical es Pop House y urbano.'),
('Bea', '', 'Femenino', 'https://los40.com/resizer/v2/3CPVSTCK65H6JBDB3VAFDW73CE.jpg?auth=a6587e23c2fb1a6867b2d8451671b53957afcf407d41f3edc3399b5630dacc9e&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 25/05/2004 en San Fernando de Henares (Madrid). Estudia Magisterio de Educación Primaria y da clases de música a niños pequeños. Toca el piano y su estilo musical incluye Rock 80s, Soul y Pop.'),
('Paul', 'Thin', 'Masculino', 'https://los40.com/resizer/v2/IR5M32IUMJAKPOXDGTUVOR2RQI.jpg?auth=0b28c117647f06fc1d47a4b624873ee11067529c9490d6f9355066b5011071e9&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 14/12/2002 en Armilla (Granada). Estudiante de Audiovisuales. Sus hobbies son los videojuegos y el cine. Su estilo musical es Reguetón y Hip Hop.'),
('Omar', '', 'Masculino', 'https://los40.com/resizer/v2/RKRCRLU7FZCHZBQLI7JWUNECTI.jpg?auth=3e1883844c855bc0719797f6fe4ff18b7c02be769b30d22d550e360914590af9&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 09/05/1997 en Yunquera de Henares (Guadalajara). Técnico de emergencias sanitarias, preparándose para oposiciones a bombero. Toca el saxo tenor en una charanga y juega al baloncesto. Su estilo musical es cantautor, rock y pop-rock español.'),
('Chiara', '', 'Femenino', 'https://los40.com/resizer/v2/KYNCOI7PKREIFBVBWCNVUEXEH4.jpg?auth=8effb86291b577ab358bc4138174174164523d4243bd412f63493cb99a192f14&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 11/03/2004 en Ciutadella de Menorca. Estudia canto moderno en la ESMUC y canta en hoteles y restaurantes en verano. Compone y toca la guitarra, el piano y el bajo. Su estilo musical incluye Pop, Pop Rock, Soul, R&B y Folk.'),
('Juanjo', 'Bona', 'Masculino', 'https://los40.com/resizer/v2/NYYVS5YPGVFVXGG4Z2JETHROTQ.jpg?auth=c2129e0dba9060ab1c7dd4093c9f8a818d918cfafe0352f2015c2f8a309a6a63&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 10/11/2003 en Magallón (Zaragoza). Estudiante de Ingeniería Naval en Madrid. Le gusta la vida rural y el terraceo. Su estilo musical incluye jotas, rock y musicales.'),
('Salma', '', 'Femenino', 'https://los40.com/resizer/v2/VCX6CUOAXREXFP4ODKUAKC37WU.jpg?auth=ef6235c413e27f61d20c9609c8803f949eaeac355acb0a3180b0c7be47067971&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 04/10/2002 en Mijas (Málaga). Cantante. Toca la guitarra y el piano, y compone. Su estilo musical es Flamenco Pop.'),
('Lucas', '', 'Masculino', 'https://los40.com/resizer/v2/A3I525JXZFGYNCHWUMJPATKW2I.jpg?auth=81d238d34a37de80751d0979f452a169485501ba288bd5aa4cd62dc51df1c521&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 10/11/2000 en Montevideo, Uruguay, y reside en Vallirana (Barcelona). Barbero. Le apasiona cantar. Su estilo musical es Rock Pop y R&B.'),
('Cris', '', 'Masculino', 'https://los40.com/resizer/v2/P6JE3R4WFFHNPJJ2GV3PUFRFGE.jpg?auth=c0fb07a559f02611e24f5c2b834896e3437e5ba78d1fde807a88b99ef5ce8b38&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 20/09/1999 en San Cristóbal de La Laguna (Tenerife). Actor de teatro musical. Sus hobbies son los videojuegos, salir con amigos y jugar al billar. Su estilo musical es RnB, Pop, Soul y Baladas.'),
('Martin', 'Urrutia', 'Masculino', 'https://los40.com/resizer/v2/ODVXIJKLTVHKHH766YHUPT2QOA.jpg?auth=1a6c53bf9b58f1314a6678a648500a791a3d577aa3c6976ae3fde1106932f141&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 30/03/2005 en Getxo (Bizkaia). Estudiante de Arte Dramático. Le gustan las actividades culturales con amigos. Su estilo musical es Pop/Rock Alternativo.'),
('Naiara', '', 'Femenino', 'https://los40.com/resizer/v2/YV2FX3DUNFH6VFEONWW753Y5KA.jpg?auth=313734972115b9e0a00a6b6607bb7a648bda5f28839707dce05935137f934179&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 29/04/1997 en Zaragoza. Cantante de orquesta. Disfruta de ir en coche sola escuchando música. Su estilo musical es variado.'),
('Ruslana', '', 'Femenino', 'https://los40.com/resizer/v2/WXEYW44BPNGUDF4WGOFHEYNKNQ.jpg?auth=f1207243a55480aeb61445f0e4bc592e89d2068f42965a0a5206fbc16509e806&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 10/09/2005 en Madrid. Estudia 2º de Bachiller en Artes Escénicas. Toca el bajo eléctrico, le gusta el arte, la moda, interpretación y baile. Su estilo musical incluye Rock, R&B y Soul.'),
('Suzette', '', 'Femenino', 'https://los40.com/resizer/v2/Q77VSZA6VFAJZJ4DAFM3HCKNMI.jpg?auth=e5b2be13d3af4857792e9601cdb54405b9d01955d9042c08ad863bc4150f2416&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 21/04/2001 en Santa Cruz de Tenerife. Estudia Coaching Administrativo y Empresarial. Le gusta componer, hacer trenzas y patinar. Su estilo musical incluye Soul, R&B, Gospel, Pop, Afro y Jazz.'),
('Violeta', 'Hódar', 'Femenino', 'https://los40.com/resizer/v2/LLCN6CZ46RGALE6FOEL57T2SAM.jpg?auth=87e141ed39131ff5628d8e5422d54819900ce2b8ebc84a654ac2f9190841baaa&quality=70&width=950&height=950&smart=true', 'Concursante de OT 2023. Nació el 23/01/2001 en Motril (Granada). Graduada en Periodismo, Publicidad y Audiovisuales. Le gusta pintar. Su estilo musical es R&B. Tocó el clarinete durante 10 años.');


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



