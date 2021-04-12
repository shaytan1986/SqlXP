use util
go
set nocount, xact_abort on
go

create or alter view xp.vTypeMap
as

select
    m.TypeMapSK,
    o.ObjectTypeSK,
    ObjectType = o.Type,
    ObjectTypeDesc = o.TypeDesc,
    ObjectTypeComment = o.comment,
    ObjectTypeMinVersion = o.MinVersion,
    Level0TypeSK = l0.LevelTypeSK,
    Leve01Type = l0.Value,
    Level1TypeSK = l1.LevelTypeSK,
    Level1Type = l1.Value,
    Level2TypeSK = l2.LevelTypeSK,
    Level2Type = l2.Value,
    MinorTypeSK = z.LevelTypeSK,
    MinorType = z.Value
from xp.TypeMap m
inner join xp.ObjectType o
    on m.ObjectTypeSK = o.ObjectTypeSK
left outer join xp.LevelType l0
    on m.Level0TypeSK = l0.LevelTypeSK
left outer join xp.LevelType l1
    on m.Level1TypeSK = l1.LevelTypeSK
left outer join xp.LevelType l2
    on m.Level2TypeSK = l2.LevelTypeSK
left outer join xp.LevelType z
    on m.MinorTypeSK = z.LevelTypeSK

GO
select * from xp.vTypeMap