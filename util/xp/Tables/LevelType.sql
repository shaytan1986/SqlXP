use util
go
set nocount, xact_abort on
go

/**************************
select top 100 * from xp.LevelType
**************************/
drop table if exists xp.LevelType
create table xp.LevelType
(
    LevelTypeSK int identity(0,1),
    Level tinyint not null 
        constraint CHK__xp_LevelType__Level check (Level <= 2),
    Value varchar(128) not null,
    InsertDateUtc datetime2(0) not null 
        constraint DF__xp_LevelType__InsertDateUtc default sysutcdatetime(),
    UpdateDateUtc datetime2(0) not null 
        constraint DF__xp_LevelType__UpdateDateUtc default sysutcdatetime(),
    
    constraint PKC_xp_LevelType__LevelTypeSK primary key clustered (LevelTypeSK)
)
drop index if exists IXNU__xp_LevelType__Value_Level on xp.LevelType
create unique nonclustered index IXNU__xp_LevelType__Value_Level on xp.LevelType (Value, Level)
go

insert into xp.LevelType
(
    Level,
    Value
)
select *
FROM
(
    values
        (0, 'ASSEMBLY'),
        (0, 'CONTRACT'),
        (0, 'EVENT NOTIFICATION'),
        (0, 'FILEGROUP'),
        (0, 'MESSAGE TYPE'),
        (0, 'PARTITION FUNCTION'),
        (0, 'PARTITION SCHEME'),
        (0, 'REMOTE SERVICE BINDING'),
        (0, 'ROUTE'),
        (0, 'SCHEMA'),
        (0, 'SERVICE'),
        (0, 'USER'),
        (0, 'TRIGGER'),
        (0, 'TYPE'),
        (0, 'PLAN GUIDE'),
        (1, 'AGGREGATE'),
        (1, 'DEFAULT'),
        (1, 'FUNCTION'),
        (1, 'LOGICAL FILE NAME'),
        (1, 'PROCEDURE'),
        (1, 'QUEUE'),
        (1, 'RULE'),
        (1, 'SEQUENCE'),
        (1, 'SYNONYM'),
        (1, 'TABLE'),
        (1, 'TABLE_TYPE'),
        (1, 'TYPE'),
        (1, 'VIEW'),
        (1, 'XML SCHEMA COLLECTION'),
        (2, 'COLUMN'),
        (2, 'CONSTRAINT'),
        (2, 'EVENT NOTIFICATION'),
        (2, 'INDEX'),
        (2, 'PARAMETER'),
        (2, 'TRIGGER')
) a (Level, Type)

go

select top 1000 *
from xp.LevelType