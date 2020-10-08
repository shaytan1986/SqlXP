use [util]
go
set nocount, xact_abort on
go

if schema_id('xp') is null
begin
    exec (N'create schema xp')
    raiserror('Created schema: [xp]', 0, 1) with nowait
end
go
