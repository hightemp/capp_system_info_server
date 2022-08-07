import std/[os, strutils, logging]
import norm/[model, sqlite]

import std/[os, logging, strutils, sequtils, options, sugar, strformat, tables, sets]

when (NimMajor, NimMinor) <= (1, 6):
    from std/macros import newCall, bindSym, nnkDotExpr, newTree, ident
else:
    import std/macros
    export macros

import norm/private/sqlite/[dbtypes, rowutils]
import norm/private/[dot, log]
import norm/model
import norm/pragmas

import params

# var bResult = existsOrCreateDir("data")

putEnv("DB_HOST", DB_HOST)

using dbConn: DbConn

# template key* {.pragma.}

proc dropTablesCustom*[T: Model](obj: T) =
    withDb():
        let qry = "DROP TABLE IF EXISTS $#;" % [T.table]
        db.exec(sql qry)

proc truncateTablesCustom*[T: Model](obj: T) =
    withDb():
        let qry = "DELETE FROM $#;" % [T.table]
        db.exec(sql qry)

proc createTablesCustom*[T: Model](obj: T) =
    withDb():
        ## Create tables for `Model <model.html#Model>`_ and its `Model`_ fields.

        for fld, val in obj[].fieldPairs:
            if val.model.isSome:
                db.createTables(get val.model)

        var colGroups, fkGroups, uniqueGroupCols: seq[string]

        for fld, val in obj[].fieldPairs:
            var colShmParts: seq[string]

            colShmParts.add obj.col(fld)

            colShmParts.add typeof(val).dbType

            when val isnot Option:
                colShmParts.add "NOT NULL"

            when obj.dot(fld).hasCustomPragma(pk):
                colShmParts.add "PRIMARY KEY"

            # when obj.dot(fld).hasCustomPragma(key):
            #     colShmParts.add "KEY"

            when obj.dot(fld).hasCustomPragma(unique):
                colShmParts.add "UNIQUE"

            when obj.dot(fld).hasCustomPragma(uniqueGroup):
                uniqueGroupCols.add obj.col(fld)

            if val.isModel:
                var fkGroup = "FOREIGN KEY($#) REFERENCES $#($#)" %
                    [obj.col(fld), typeof(get val.model).table, typeof(get val.model).col("id")]

                when obj.dot(fld).hasCustomPragma(onDelete):
                    fkGroup &= " ON DELETE " & obj.dot(fld).getCustomPragmaVal(onDelete)

                fkGroups.add fkGroup

            when obj.dot(fld).hasCustomPragma(fk):
                when val isnot SomeInteger and val isnot Option[SomeInteger]:
                    {.fatal: "Pragma fk: field must be SomeInteger. " & fld & " is not SomeInteger.".}
                elif obj.dot(fld).getCustomPragmaVal(fk) isnot Model and obj isnot obj.dot(fld).getCustomPragmaVal(fk):
                    const pragmaValTypeName = $(obj.dot(fld).getCustomPragmaVal(fk))
                    {.fatal: "Pragma fk: value must be a Model. " & pragmaValTypeName & " is not a Model.".}
                elif obj is obj.dot(fld).getCustomPragmaVal(fk):
                    when T.hasCustomPragma(tableName):
                        const selfTableName = '"' & T.getCustomPragmaVal(tableName) & '"'
                    else:
                        const selfTableName = '"' & $T & '"'
                        fkGroups.add "FOREIGN KEY ($#) REFERENCES $#(id)" % [fld, selfTableName]
                else:
                    fkGroups.add "FOREIGN KEY ($#) REFERENCES $#(id)" % [fld, (obj.dot(fld).getCustomPragmaVal(fk)).table]

            colGroups.add colShmParts.join(" ")

        let
            uniqueGroups = if len(uniqueGroupCols) > 0: @["UNIQUE($#)" % uniqueGroupCols.join(", ")] else: @[]
            qry = "CREATE TABLE IF NOT EXISTS $#($#)" % [T.table, (colGroups & fkGroups & uniqueGroups).join(", ")]

        log(qry)

        db.exec(sql qry)

type
    MSettings* = ref object of Model
        name*: string
        value*: string

# withDb:
#     db.createTables(MSettings())

