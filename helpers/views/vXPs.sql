/*****************************
select top 1000 *
from dbo.vXPs
*****************************/
drop view if exists dbo.vXPs
go
create or alter view dbo.vXPs
as
select
    ObjectId = b.object_id,
    ObjectName = b.name,
    ObjectType = b.type,
    ObjectTypeDesc = b.type_desc,
    MinorId = isnull(c.column_id, p.parameter_id),
    MinorName = isnull(c.name, p.name),
    MinorType = case
        when c.object_id is not null then 'COLUMN'
        when p.object_id is not null then 'PARAMETER'
        else null
    end,
    PropName = a.name,
    PropValue = a.value    
from sys.extended_properties a
inner join sys.objects b
    on a.major_id = b.object_id
left join sys.columns c
    on b.object_id = c.object_id
        and a.minor_id = c.column_id
left outer join sys.parameters p
    on b.object_id = p.object_id
        and a.minor_id = p.parameter_id


go