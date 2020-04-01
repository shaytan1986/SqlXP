use Master
go
set nocount on
go
-- Annotate sp_SetExtendedProperty
exec dbo.sp_SetObjectXP
	@TwoPartName = 'dbo.sp_SetExtendedProperty',
    @Name = N'name',
    @Value = 'Value',
	@Debug = 1,
    @Action = 'A'

-- If you omit the schema, it will assume you meant DBO. 
exec dbo.sp_SetObjectXP
	@TwoPartName = 'sp_SetExtendedProperty',
    @Name = N'name2',
    @Value = 'Value',
	@Debug = 1,
    @Action = 'U'
    