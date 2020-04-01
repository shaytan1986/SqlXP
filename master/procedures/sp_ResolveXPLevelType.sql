use master
go
set nocount on
go

drop proc if exists dbo.sp_ResolveXPLevelType
go
create or alter proc dbo.sp_ResolveXPLevelType
	@TwoPartName nvarchar(256),
	@Debug bit = 0,
	@L0Name nvarchar(128) = null output,
	@L1Type varchar(128) = null output,
	@L1Name nvarchar(128) = null output,
	@L2Type varchar(128) = null output,
	@ObjectId int = null output
as
begin

	declare 
		@ParsedEntity nvarchar(128),
		@ParsedSchema nvarchar(128)

	select 
		@ParsedEntity = parsename(@TwoPartName, 1),
		@ParsedSchema = parsename(@TwoPartName, 2),
		@ObjectId = object_id(@TwoPartName),
		@L0Name = iif(@ObjectId is null, null, isnull(@ParsedSchema, 'dbo'))

	;with map (L1Type, L2Type) as
	(
		select 'FUNCTION', 'PARAMETER' union all
		select 'PROCEDURE', 'PARAMETER' union all
		select 'TABLE', 'COLUMN' union all
		select 'VIEW', 'COLUMN' union all
		select 'SEQUENCE', null union all
		select 'QUEUE', null
	)
	select
		@L1Type = m.L1Type,
		@L1Name = o.Name,
		@L2Type = m.L2Type
	from sys.objects o
	left outer join map m
		on o.type_desc like '%' + m.L1Type
	where o.object_id = @ObjectId


	if @Debug = 1
		select
			TwoPartName = @TwoPartName,
			L0Name = @L0Name,
			L1Type = @L1Type,
			L1Name = @L1Name,
			L2Type = @L2Type,
			ObjectId = @ObjectId

end
return
go
exec sys.sp_ms_marksystemobject N'dbo.sp_ResolveXPLevelType'
go