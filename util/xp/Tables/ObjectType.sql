use util
go
set nocount, xact_abort on
go
/**************************
select top 100 * from xp.ObjectType
**************************/
drop table if exists xp.ObjectType
create table xp.ObjectType
(
    ObjectTypeSK int identity(0,1),
    Type char(2) collate Latin1_General_CI_AS_KS_WS not null,
    TypeDesc nvarchar(60) collate Latin1_General_CI_AS_KS_WS null,
    Comment nvarchar(128) null,
    MinVersion tinyint not null 
        constraint DF__xp_ObjectType__MinVersion default 0,
    InsertDateUtc datetime2(0) not null 
        constraint DF__xp_ObjectType__InsertDateUtc default sysutcdatetime(),
    UpdateDateUtc datetime2(0) not null 
        constraint DF__xp_ObjectType__UpdateDateUtc default sysutcdatetime(),
    
    constraint PKC_xp_ObjectType__ObjectTypeSK primary key clustered (ObjectTypeSK)
)
drop index if exists IXNU__xp_ObjectType__Type on xp.ObjectType
create unique nonclustered index IXNU__xp_ObjectType__Type on xp.ObjectType (Type)
go
GO


insert into xp.ObjectType
(
    Type,
    TypeDesc,
    Comment,
    MinVersion
)
select
    Type,
    TypeDesc,
    Comment,
    MinVersion
FROM
(
    values
    (0, 'AF', 'Aggregate function (CLR)', 'AGGREGATE_FUNCTION'),
    (0, 'C', 'CHECK constraint', 'CHECK_CONSTRAINT'),
    (0, 'D', 'DEFAULT (constraint or stand-alone)', 'DEFAULT_CONSTRAINT'),
    (0, 'F', 'FOREIGN KEY constraint', 'FOREIGN_KEY_CONSTRAINT'),
    (0, 'FN', 'SQL scalar function', 'SQL_SCALAR_FUNCTION'),
    (0, 'FS', 'Assembly (CLR) scalar-function', 'CLR_SCALAR_FUNCTION'),
    (0, 'FT', 'Assembly (CLR) table-valued function', 'CLR_TABLE_VALUED_FUNCTION'),
    (0, 'IF', 'SQL inline table-valued function', 'SQL_INLINE_TABLE_VALUED_FUNCTION'),
    (0, 'IT', 'Internal table', 'INTERNAL_TABLE'),
    (0, 'P', 'SQL Stored Procedure', 'SQL_STORED_PROCEDURE'),
    (0, 'PC', 'Assembly (CLR) stored-procedure', 'CLR_STORED_PROCEDURE'),
    (0, 'PG', 'Plan guide', 'PLAN_GUIDE'),
    (0, 'PK', 'PRIMARY KEY constraint', 'PRIMARY_KEY_CONSTRAINT'),
    (0, 'R', 'Rule (old-style, stand-alone)', 'RULE'),
    (0, 'RF', 'Replication-filter-procedure', 'REPLICATION_FILTER_PROCEDURE'),
    (0, 'S', 'System base table', 'SYSTEM_TABLE'),
    (0, 'SN', 'Synonym', 'SYNONYM'),
    (0, 'SO', 'Sequence object', 'SEQUENCE_OBJECT'),
    (0, 'U', 'Table (user-defined)', 'USER_TABLE'),
    (0, 'V', 'View', 'VIEW'),
    (0, 'EC', 'Edge constraint', 'EDGE_CONSTRAINT'),
    (11, 'SQ', 'Service queue', 'SERVICE_QUEUE'),
    (11, 'TA', 'Assembly (CLR) DML trigger', 'CLR_TRIGGER'),
    (11, 'TF', 'SQL table-valued-function', 'SQL_TABLE_VALUED_FUNCTION'),
    (11, 'TR', 'SQL DML trigger', 'SQL_TRIGGER'),
    (11, 'TT', 'Table type', 'TABLE_TYPE'),
    (11, 'UQ', 'UNIQUE constraint', 'UNIQUE_CONSTRAINT'),
    (11, 'X', 'Extended stored procedure', 'EXTENDED_STORED_PROCEDURE'),
    (13, 'ET', 'External Table', 'EXTERNAL_TABLE')

) a (MinVersion, Type, Comment, TypeDesc)

select top 1000 *
from xp.ObjectType