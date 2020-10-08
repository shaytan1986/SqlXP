use master
go
set nocount on
go
if db_id('util') is null
begin
    create database util
    raiserror('Created database: [util]', 0, 1) with nowait
end
go
use util
go
