use util
go
set nocount, xact_abort on
go

drop table if exists #map
select
    Type = Type collate Latin1_General_CI_AS_KS_WS, Level0Type, Level1Type, Level2Type, LeafLevel, MinorType
into #map
from
(
    values
        ('C ', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('D ', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('EC', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('F ', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('PK', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('UQ', 'SCHEMA', 'TABLE', 'CONSTRAINT', '2', null),
        ('AF', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('FS', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('FT', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('IF', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('FN', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('TF', 'SCHEMA', 'FUNCTION', null, '1', 'PARAMETER'),
        ('PG', 'PLAN GUIDE', null, null, '0', null),
        ('PC', 'SCHEMA', 'PROCEDURE', null, '1', 'PARAMETER'),
        ('X ', 'SCHEMA', 'PROCEDURE', null, '1', 'PARAMETER'),
        ('RF', 'SCHEMA', 'PROCEDURE', null, '1', 'PARAMETER'),
        ('P ', 'SCHEMA', 'PROCEDURE', null, '1', 'PARAMETER'),
        ('SQ', 'SCHEMA', 'QUEUE', null, '1', 'COLUMN'),
        ('R ', 'SCHEMA', 'RULE', null, '1', null),
        ('SO', 'SCHEMA', 'SEQUENCE', null, '1', null),
        ('SN', 'SCHEMA', 'SYNONYM', null, '1', null),
        ('ET', 'SCHEMA', 'TABLE', null, '1', 'COLUMN'),
        ('IT', 'SCHEMA', 'TABLE', null, '1', 'COLUMN'),
        ('S ', 'SCHEMA', 'TABLE', null, '1', 'COLUMN'),
        ('U ', 'SCHEMA', 'TABLE', null, '1', 'COLUMN'),
        ('TA', 'SCHEMA', 'TABLE', 'TRIGGER', '2', null),
        ('TR', 'SCHEMA', 'TABLE', 'TRIGGER', '2', null),
        ('TT', 'SCHEMA', 'TABLE_TYPE', null, '1', 'COLUMN'),
        ('V ', 'SCHEMA', 'VIEW', null, '1', 'COLUMN')
) a (Type, Level0Type, Level1Type, Level2Type, LeafLevel, MinorType)

/**************************
select top 100 * from xp.TypeMap
**************************/
drop table if exists xp.TypeMap
create table xp.TypeMap
(
    TypeMapSK int identity(1,1) 
        constraint PKC_xp_TypeMap__TypeMapSK primary key clustered,
    ObjectTypeSK int not null,
    Level0TypeSK int not null,
    Level1TypeSK int null,
    Level2TypeSK int null,
    MinorTypeSK int null,
    InsertDateUtc datetime2(0) not null 
        constraint DF__xp_TypeMap__InsertDateUtc default sysutcdatetime(),
    UpdateDateUtc datetime2(0) not null 
        constraint DF__xp_TypeMap__UpdateDateUtc default sysutcdatetime()
)
go

insert into xp.TypeMap
(
    ObjectTypeSK,
    Level0TypeSK,
    Level1TypeSK,
    Level2TypeSK,
    MinorTypeSK
)
select
    o.ObjectTypeSK,
    l0.LevelTypeSK,
    l1.LevelTypeSK,
    l2.LevelTypeSK,
    z.LevelTypeSK
from #map m
inner join xp.ObjectType o
    on m.Type = o.type
left outer join xp.LevelType l0
    on m.Level0Type = l0.value
        and l0.Level = 0
left outer join xp.LevelType l1
    on m.Level1Type = l1.value
        and l1.Level = 1
left outer join xp.LevelType l2
    on m.Level2Type = l2.value
        and l2.Level = 2
left outer join xp.LevelType z
    on m.MinorType = z.value
        and z.Level = 2

go

