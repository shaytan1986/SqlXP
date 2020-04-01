use Master
go
set nocount on
go

-- Add/Update sp_SetMinorXP
exec dbo.sp_SetMinorXP
	@TwoPartName = N'dbo.dbo.sp_SetMinorXP',
	@MinorName = N'@TwoPartName',
    @Name = N'name', -- nvarchar(128)
    @Value = 'Value', -- sql_variant
	@Debug = 1,
    @Action = 'U'

-- Drop. If you omit the "@" at the start of a parameter, it will add it for you
exec dbo.sp_SetMinorXP
	@TwoPartName = N'dbo.dbo.sp_SetMinorXP',
	@MinorName = N'@TwoPartName',
    @Name = N'name', -- nvarchar(128)
    @Value = '', -- doesn't matter what this value is if you're dropping it. Can be null, empty, the existing value, or the lyrics to "The Maracarena"
	@Debug = 1,
    @Action = 'D'