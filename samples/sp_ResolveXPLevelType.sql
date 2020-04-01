use Master
go
set nocount on
go

declare 
    @L0Type	varchar(128) = 'SCHEMA',
    @L0Name	nvarchar(128),
    @L1Type	varchar(128),
    @L1Name	nvarchar(128),
    @L2Type	varchar(128),
    @ObjectId int

exec dbo.sp_ResolveXPLevelType
    @TwoPartName = N'dbo.sp_SetExtendedProperty',
    @L0Name = @L0Name output,
    @L1Type = @L1Type output,
    @L1Name = @L1Name output,
    @L2Type = @L2Type output,
    @ObjectId = @ObjectId output,
    @Debug = 1 -- @Debug = 1 will return these values as a result set

-- You can also grab them from the output parameters
select
    TwoPartName = @TwoPartName,
    L0Type = @L0Type,
    L0Name = @L0Name,
    L1Type = @L1Type,
    L1Name = @L1Name,
    L2Type = @L2Type,
    ObjectId = @ObjectId