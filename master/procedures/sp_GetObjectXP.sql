use master
go
set nocount on
go

/**********************************************************
* dbo.sp_GetObjectXP
* Creator:      TRIO\GTower
* Created:      2:05 PM
* Description:	Utility proc for accessing extended properties of a specific object (specifically, intended for @@procid)
* Sample Usage

        -- Adds a sample extended property to this object
        exec dbo.sp_SetObjectXP N'dbo.sp_GetObjectXP', N'Test', 'Foo', 'U', 0
        go

        declare 
            @ObjectId int = object_id('dbo.sp_GetObjectXP'),
            @Name nvarchar(128) = 'Test',
            @Value sql_variant,
            @ValueType nvarchar(128),
            @ValueExists bit,
            @TypeCheckWildcard nvarchar(128) = '%int',
            @TypeCheckMatches bit

        exec dbo.sp_GetObjectXP
            @ObjectId = @ObjectId,
            @Name = @Name,
            @Value = @Value output,
            @ValueType = @ValueType output,
            @ValueExists = @ValueExists output,
            @Results = 0,
            @TypeCheckWildcard = @TypeCheckWildcard,
            @TypeCheckMatches = @TypeCheckMatches output

        select
            Name = @Name,
            Value = @Value,
            ValueExists = @ValueExists,
            ValueType = @ValueType,    
            TypeCheckWildcard = @TypeCheckWildcard,
            TypeCheckMatches = @TypeCheckMatches

        exec dbo.sp_GetObjectXP
            @ObjectId = @ObjectId,
            @Name = N'NOT_AN_XP',
            @Results = 1,
            @TypeCheckWildcard = '%int'

* Modifications
User            Date        Comment
-----------------------------------------------------------

**********************************************************/
create or alter procedure dbo.sp_GetObjectXP
    @ObjectId int, -- the object for which you want to get an XP
    @Name nvarchar(128), -- the xp name to get
    @Value sql_variant = null output, -- the value (if it exists) of the specified XP
    @ValueType nvarchar(128) = null output, -- the BaseType of @Value
    @ValueExists bit = null output, -- Flag indicating whether the value was actually found
    @Results bit = 0, -- 1 will return a result set with the sought info.
    @TypeCheckWildcard nvarchar(128) = null, -- A wildcard expression which, if provided, will be tested against the @ValueType to check if they match
    @TypeCheckMatches bit = null output -- Indicates the result of the @TypeCheckWildcard. Will be null if @TypeCheckWildcard is null
as
begin

    select 
        @Value = Value,
        @ValueType = try_convert(nvarchar(128), sql_variant_property(value, 'BaseType'))
    from sys.extended_properties
    where major_id = @ObjectId
        and minor_id = 0
        and class = 1
        and name = @Name

    select 
        @ValueExists = @@rowcount,
        @TypeCheckMatches = case
            when @TypeCheckWildcard is null then null
            when @ValueType like @TypeCheckWildcard then 1
            else 0
        end
    
    if @Results = 1
    begin

        select
            DbName = db_name(),
            ObjectId = @ObjectId,
            Name = @Name,
            ValueExists = @ValueExists,
            Value = @Value,
            ValueType = @ValueType,
            TypeCheckWildcard = @TypeCheckWildcard,
            TypeCheckMatches = @TypeCheckMatches

    end

end
return
go

exec sys.sp_MS_marksystemobject N'dbo.sp_GetObjectXP'
go
