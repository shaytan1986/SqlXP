use util
go
set nocount, xact_abort on
go

drop table if exists #dbtypes
create table #dbtypes
(
    DbName nvarchar(128) not null,
    Type char(2) collate Latin1_General_CI_AS_KS_WS not null,
    TypeDesc varchar(120) collate Latin1_General_CI_AS_KS_WS not null,
    ChildCt int not null,
    ObjectCt int not null
)

drop table if exists #types
create table #types
(
    Type char(2) collate Latin1_General_CI_AS_KS_WS not null,
    TypeDesc varchar(120) collate Latin1_General_CI_AS_KS_WS not null,
    DbCt int not null,
    ObjectCt int not null,
    ParentedCt int not null,
    UnparentedCt as ObjectCt - ParentedCt
)

drop table if exists ##objects
create table ##objects
(
    DbName nvarchar(128) not null,
    ObjectId int not null,
    ParentObjectId int not null,
    HasParent as iif(ParentObjectId = 0, 0, 1),
    Type char(2) collate Latin1_General_CI_AS_KS_WS not null,
    TypeDesc varchar(120) collate Latin1_General_CI_AS_KS_WS not null,
    SchemaName as object_schema_name(ObjectId, db_id(DbName)),
    ObjectName as object_name(ObjectId, db_id(DbName))
)

go
/**************************
1) Get all objects
**************************/
exec sp_msforeachdb N'
use [?]

insert into ##objects
(
    DbName,
    ObjectId,
    ParentObjectId,
    Type,
    TypeDesc
)
select
    DbName = db_name(), 
    ObjectId,
    ParentObjectId,
    Type,
    TypeDesc
from
(
    select 
        ObjectId = object_id,
        ParentObjectId = parent_object_id,
        Type = type,
        TypeDesc = type_desc
    from sys.all_objects
    union
    select 
        ObjectId = object_id,
        ParentObjectId = parent_object_id,
        Type = type,
        TypeDesc = type_desc
    from sys.objects
) a'

/**************************
2) Get Object Counts by Database
**************************/
insert into #dbtypes
(
    DbName,
    Type,
    TypeDesc,
    ChildCt,
    ObjectCt
)
select 
    DbName,
    Type,
    TypeDesc = max(TypeDesc),
    ChildCt = sum(HasParent),
    ObjectCt = count(1)
from ##objects
group by DbName, Type

/**************************
3) Get Object Counts 
**************************/
insert into #types
(
    Type,
    TypeDesc,
    ParentedCt,
    ObjectCt,
    DbCt
)
select 
    Type,
    TypeDesc = max(TypeDesc),
    ParentedCt = sum(ChildCt),
    ObjectCt = sum(ObjectCt),
    DbCt = count(distinct DbName)
from #dbtypes
group by Type


;with map as
(
    select wc, class
    from 
    (
        values
            ('%FUNCTION', 'FUNCTION'),
            ('%TABLE', 'TABLE'),
            ('%PROCEDURE', 'PROCEDURE'),
            ('%CONSTRAINT', 'CONSTRAINT')
    ) a (wc, class)
)
select 
    t.Type,
    t.TypeDesc,
    m.Class,
    t.ObjectCt,
    t.ParentedCt,
    t.UnparentedCt
from #types t
left outer join map m
    on t.typeDesc like m.wc
order by Type


select * 
from ##objects o
left join xp.vTypeMap m
    on o.Type = m.ObjectType
where m.ObjectType is null