#!/bin/bash
pword=$1;
user=${2:-"sa"}
dataSource=${3:-"localhost"}
folder="./master/procedures"

sqlcmd -S "$dataSource" -U "$user" -P "$pword" -i "$folder/sp_ResolveXPLevelType.sql"
sqlcmd -S "$dataSource" -U "$user" -P "$pword" -i "$folder/sp_SetExtendedProperty.sql"
sqlcmd -S "$dataSource" -U "$user" -P "$pword" -i "$folder/sp_SetObjectXP.sql"
sqlcmd -S "$dataSource" -U "$user" -P "$pword" -i "$folder/sp_SetMinorXP.sql"
sqlcmd -S "$dataSource" -U "$user" -P "$pword" -i "$folder/sp_ListXP.sql"