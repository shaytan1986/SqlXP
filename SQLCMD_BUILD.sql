use Master
go
set nocount on
go
/*
This script executes the procedures using SQLCMD :r commands
- YOU MUST RUN THIS IN SQLCMD MODE (in SSMS, go Query -> SQLCMD Mode)
- YOU MUST REPLACE VALUE OF THE ${dir} VARIABLE WITH THE ROOT DIRECTORY OF THE REPO (where this file lives)
*/
:setvar dir "C:\Users\GTower\source\repos\Shaytan1986\SqlXP\"
print '$(dir)'
:r $(dir)"master\procedures\sp_SetExtendedProperty.sql"
:r $(dir)"master\procedures\sp_ResolveXPLevelType.sql"
:r $(dir)"master\procedures\sp_SetObjectXP.sql"
:r $(dir)"master\procedures\sp_SetMinorXP.sql"
:r $(dir)"master\procedures\sp_ListXP.sql"

