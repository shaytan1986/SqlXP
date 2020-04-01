use master
go
set nocount on
go

-- Create a property
exec dbo.sp_SetExtendedProperty
    @Name = N'name', -- nvarchar(128)
    @Value = 'Value', -- sql_variant
    @L0Type = 'SCHEMA', -- varchar(128)
    @L0Name = 'dbo', -- nvarchar(128)
    @L1Type = 'PROCEDURE', -- varchar(128)
    @L1Name = 'sp_SetExtendedProperty', -- nvarchar(128)
    @L2Type = null, -- varchar(128)
    @L2Name = null, -- nvarchar(128)
    @Action = 'A', -- char(1)
    @Debug = 1 -- bit

-- Update that property
-- if you run this twice, the second one wont' actually do anything (NoOp)
-- Notice I changed the @Value to an NVARCHAR here. This will throw a warning message but not fail
exec dbo.sp_SetExtendedProperty
    @Name = N'name', -- nvarchar(128)
    @Value = N'ValueChanged', -- sql_variant
    @L0Type = 'SCHEMA', -- varchar(128)
    @L0Name = 'dbo', -- nvarchar(128)
    @L1Type = 'PROCEDURE', -- varchar(128)
    @L1Name = 'sp_SetExtendedProperty', -- nvarchar(128)
    @L2Type = null, -- varchar(128)
    @L2Name = null, -- nvarchar(128)
    @Action = 'U', -- char(1)
    @Debug = 1 -- bit

-- Drop the property
exec dbo.sp_SetExtendedProperty
    @Name = N'name', -- nvarchar(128)
    @Value = null,  -- doesn't matter what this value is if you're dropping it. Can be null, empty, the existing value, or the lyrics to "Who Let The Dogs Out?"
    @L0Type = 'SCHEMA', -- varchar(128)
    @L0Name = 'dbo', -- nvarchar(128)
    @L1Type = 'PROCEDURE', -- varchar(128)
    @L1Name = 'sp_SetExtendedProperty', -- nvarchar(128)
    @L2Type = null, -- varchar(128)
    @L2Name = null, -- nvarchar(128)
    @Action = 'D', -- char(1)
    @Debug = 1 -- bit

