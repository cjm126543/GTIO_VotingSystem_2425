USE TestDB;
GO

-- Eliminar claves foráneas en las tablas con dependencias
ALTER TABLE dtLogVotos DROP CONSTRAINT DF__dtLogVoto__Fecha__35DCF99B;
ALTER TABLE dtVotos DROP CONSTRAINT DF__dtVotos__Elimina__3118447E;
ALTER TABLE dtKeysPorUsuario DROP CONSTRAINT DF__dtKeysPor__Elimi__3AA1AEB8;

-- Eliminar las tablas secundarias
DROP TABLE IF EXISTS dtLogVotos;
DROP TABLE IF EXISTS dtKeysPorUsuario;
DROP TABLE IF EXISTS dtVotos;

-- Eliminar las claves foráneas en las tablas principales
ALTER TABLE dtUsuarios DROP CONSTRAINT DF__dtUsuario__Elimi__2882FE7D

-- Eliminar las tablas principales
DROP TABLE IF EXISTS dtArtistas;
DROP TABLE IF EXISTS dtUsuarios;
DROP TABLE IF EXISTS msRolesUsuario;

DROP DATABASE TestDB;
GO

