use master
go
set nocount on
go

drop proc if exists dbo.sp_SetMinorXP
go
create or alter proc dbo.sp_SetMinorXP
	@TwoPartName nvarchar(256),
	@MinorName nvarchar(128),
	@Name nvarchar(128),
	@Value sql_variant,
	@Action char(1) = 'A',
	@Debug bit = 0
as
begin

	declare 
		@L0Type	varchar(128) = 'SCHEMA',
		@L0Name	nvarchar(128),
		@L1Type	varchar(128),
		@L1Name	nvarchar(128),
		@L2Type	varchar(128),
		@L2Name	nvarchar(128),
		@ObjectId int

	exec dbo.sp_ResolveXPLevelType
		@TwoPartName = @TwoPartName,
		@L0Name = @L0Name output,
		@L1Type = @L1Type output,
		@L1Name = @L1Name output,
		@L2Type = @L2Type output,
		@ObjectId = @ObjectId output,
		@Debug = 0


	if @L2Type = 'PARAMETER' and @MinorName not like '@%'
	begin
		raiserror('@MinorName: %s of type PARAMETER does not start with "@". Prepending one.', 10, 1, @MinorName)
		select @MinorName = '@' + @MinorName
	end

	select @L2Name = @MinorName

	if @Debug = 1
		select
			TwoPartName = @TwoPartName,
			L0Name = @L0Name,
			L1Type = @L1Type,
			L1Name = @L1Name,
			L2Type = @L2Type,
			L2Name = @L2Name,
            Action = @Action,
			ObjectId = @ObjectId


	exec dbo.sp_SetExtendedProperty
		@Name = @Name,
		@Value = @Value,
		@L0Type = @L0Type,
		@L0Name = @L0Name,
		@L1Type = @L1Type,
		@L1Name = @L1Name,
		@L2Type = @L2Type,
		@L2Name = @L2Name,
        @Action = @Action,
		@Debug = @Debug


end
return
go
exec sys.sp_ms_marksystemobject N'dbo.sp_SetMinorXP'
go