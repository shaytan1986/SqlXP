use master
go
set nocount on
go

drop proc if exists dbo.sp_SetExtendedProperty
go
create or alter proc dbo.sp_SetExtendedProperty
	@Name nvarchar(128),
	@Value sql_variant = null,
	@L0Type	varchar(128) = null,
	@L0Name	nvarchar(128) = null,
	@L1Type	varchar(128) = null,
	@L1Name	nvarchar(128) = null,
	@L2Type	varchar(128) = null,
	@L2Name	nvarchar(128) = null,
	@Action char(1) = 'A',
	@Debug bit = 0
as
begin

declare 
	@OldValue sql_variant,
	@OldValueType nvarchar(128),
	@ValueType nvarchar(128) = convert(nvarchar(128), sql_variant_property(@Value, 'basetype')),
	@msg nvarchar(2000),
	@NoOp bit = 1

begin try

	select 
		@OldValue = value,
		@OldValueType = convert(nvarchar(128), sql_variant_property(value, 'basetype'))
	from sys.fn_listextendedproperty
	(
		@Name, 
		@L0Type, 
		@L0Name, 
		@L1Type, 
		@L1Name, 
		@L2Type, 
		@L2Name
	)

	if @OldValueType != @ValueType
		raiserror('WARNING: Type Change Detected. Old Type: %s, New Type: %s', 10, 1, @OldValueType, @ValueType)

	/*****************************
	DROPS
	*****************************/
	if @Action = 'D'
	begin
		if @OldValue is not null
			begin
				exec sys.sp_dropextendedproperty
					@Name = @Name,
					@Level0Type = @L0Type,
					@Level0Name = @L0Name,
					@Level1Type = @L1Type,
					@Level1Name = @L1Name,
					@Level2Type = @L2Type,
					@Level2Name = @L2Name
				select @NoOp = 0
			end
		else if @Debug = 1
			raiserror('No value for @Name: %s exists to Drop.', 10, 1, @Name)
	end

	/*****************************
	UPDATES
	*****************************/
	if @Action = 'U'
	begin
		if @OldValue is null
			begin
				select @Action = 'A'

				if @Debug = 1
					raiserror('No value for @Name: %s exists to Update; changing @Action to "A".', 10, 1, @Name)
			end
		else if @OldValue != @Value
			begin

				exec sys.sp_updateextendedproperty
					@Name = @Name,
					@Value = @Value,
					@Level0Type = @L0Type,
					@Level0Name = @L0Name,
					@Level1Type = @L1Type,
					@Level1Name = @L1Name,
					@Level2Type = @L2Type,
					@Level2Name = @L2Name
				select @NoOp = 0
			end
		else if @Debug = 1
			raiserror('Value exists for @Name: %s but it matches the existing value; no action taken.', 10, 1, @Name)
	end

	/*****************************
	ADDS
	*****************************/
	if @Action = 'A'
	begin
		if @OldValue is null
			begin
				exec sys.sp_addextendedproperty
					@Name = @Name,
					@Value = @Value,
					@Level0Type = @L0Type,
					@Level0Name = @L0Name,
					@Level1Type = @L1Type,
					@Level1Name = @L1Name,
					@Level2Type = @L2Type,
					@Level2Name = @L2Name
				select @NoOp = 0
			end
		else if @Debug = 1
			raiserror('Value alrady exists for @Name: %s; no action taken', 10, 1, @Name)
	end

	if @Debug = 1
		select 
			Action = @Action, 
			OldValue = @OldValue,
			OldValueType = @OldValueType,
			NewValue = @Value,
			NewValueType = @ValueType,
			NoOp = @NoOp
		from sys.fn_listextendedproperty
		(
			@Name, 
			@L0Type, 
			@L0Name, 
			@L1Type, 
			@L1Name, 
			@L2Type, 
			@L2Name
		)

end try
begin catch
	
	if @@trancount > 0
	    rollback tran
	;throw
	
end catch
end
return
go
exec sys.sp_ms_marksystemobject N'dbo.sp_SetExtendedProperty'
go

