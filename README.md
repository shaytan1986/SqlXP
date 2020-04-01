# Overview
This is a small collection of custom system objects and support files for working with <a href="https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/extended-properties-catalog-views-sys-extended-properties?view=sql-server-ver15">extended properties</a> in SQL Server.

It mainly focuses around eliminating the need to switch between add, update, and drop procedures, and provides helper procedures to reduce the amount of typing for annotating common entities.

Because these procedures are marked as system objects (using the undocumented `sys.sp_ms_marksystemobject` procedure), these can be run from any database, as with any other system stored procedureN

# Objects
## sp_SetExtendedProperty
A wrapper over 
* <a href="https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addextendedproperty-transact-sql?view=sql-server-ver15">sys.sp_addextendedproperty</a>
* <a href="https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-updateextendedproperty-transact-sql?view=sql-server-ver15">sys.sp_updateextendedproperty</a>
* <a href="https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropextendedproperty-transact-sql?view=sql-server-ver15">sys.sp_dropextendedproperty</a>

This can be used as a full replacement for the above three procedures. Later objects in this repository focus on **schema-related objects** (i.e. XPs with `Level0Type = N'SCHEMA'`) to save some typing, but always remember you can fall back to this for *any* supported extended property types.
### @Action
You can switch between behaviors using the `@Action char(1)` parameter which accepts values of 
* (A)dd
* (U)pdate
* (D)rop

All operations are safe to re-run. That is, if you try to add an existing property, it will silently fail
### @Debug
You can output error level 10 messages by setting `@Debug bit = 1` 
Updates will only update the property if the value is different
A warning error is thrown if you update a property to a different data type.

### Standard Parameters
All other parameters relate to the underlying system stored procedures. See official documentation (linked above) for details.

## sp_ResolveXPLevelType
`sp_SetExtendedProperty` uses this proc to turn a two-part qualified object name (e.g. `[schema].[object]`) to:
1. Split the object into its consituent parts
2. Identify the object type that needs to be provided to the various extended property procedures

### Supported Types
The goal here wasn`t (at least initially) to comprehensively cover *all* object types, just schema-related objects. 

That means *all Level0Types That* includes

Level1Type | Level2Type
---|---
`FUNCTION`|`PARAMETER`
`PROCEDURE`|`PARAMETER`
`TABLE`|`COLUMN` 
`VIEW`|`COLUMN` 
`SEQUENCE`|null 
`QUEUE`|null

This has output parameters for all the different *standard parameters* as well as the `@Objectid`. 
Setting `@Debug = 1` will also output them from the procedure

## sp_SetObjectXP
Simplified version of `sp_SetExtendedProperty` which assumes `N'SCHEMA'` as the `Level0Type` and takes in a two-part qualified object name (e.g. `[schema].[object]`). It calls `sp_ResolveXPLevelType` to split that into the *Standard Parameters*

## sp_SetMinorXP
Extended version of `sp_SetObjectXP` which allows for the annotation of *minor entities* (i.e. columns and parameters).

## sp_ListXP
A simplified interface for viewing extended property information which includes friendly names in addition to the normal identifiers (like `major_id` and `minor_id`) which things like `sys.extended_properties` or `sys.fn_listextendedproperties()` output.

# Snippets
I used Redgate SqlPrompt quite a bit, so I included a couple of snippets you can import which make the use of these procs a little easier. There's one for `sp_ListXP` and then two each for `sp_SetObjectXp` and `sp_SetMinorXP`. The two variants are just one which is neatly formatted and qualifies all the parameters (i.e. `xpof`, `xpmf`; "f" for "full", "o" for "Object", "m" for "Minor") and one which is a quick-n-dirty inline version which takes up less space in case you're doing a bunch of them (i.e. `xpo`, `xpm`)

# Samples
There are sample calls for each of these procs in the `Samples` directory.