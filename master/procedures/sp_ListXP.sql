use master
go
set nocount on
go

drop proc if exists dbo.sp_ListXP
go
create or alter proc dbo.sp_ListXP
	@TwoPartName nvarchar(256),
	@MinorName nvarchar(128) = null,
	@Name nvarchar(128) = null
as
begin

	declare 
		@L0Type	varchar(128) = 'SCHEMA',
		@L0Name	nvarchar(128),
		@L1Type	varchar(128),
		@L1Name	nvarchar(128),
		@L2Type	varchar(128),
		@L2Name	nvarchar(128)

	exec dbo.sp_ResolveXPLevelType
		@TwoPartName = @TwoPartName,
		@L0Name = @L0Name output,
		@L1Type = @L1Type output,
		@L1Name = @L1Name output,
		@L2Type = @L2Type output,
		@Debug = 0

	select
		L0Type = @L0Type, 
		L0Name = @L0Name,
		L1Type = @L1Type,
		L1Name = @L1Name,
		L2Type = iif(@L2Name is null, null, @L2Type),
		L2Name = @L2Name,
		ObjectId = object_id(@L0Name + '.' + @L1Name),
		Name = Name,
		Value = Value,
		ValueType = sql_variant_property(Value, 'basetype')
	from sys.extended_properties
	where @Name is null or @Name = name

end
return
go
exec sys.sp_ms_marksystemobject N'dbo.sp_ListXP'
go
