import std/[sequtils, options, times]
import std/typeinfo
import psutil
import psutil/common

type
    MDiskPartition* = ref object of Model
        created_at: DateTime
        device*: string
        mountpoint*: string
        fstype*: string
        opts*: string
        total*: int
        used*: int
        free*:int
        percent*: float
    
    TDiskPartition = tuple
        created_at: string
        device: string
        mountpoint: string
        fstype: string
        opts: string
        total: int
        used: int
        free:int
        percent: float

# withDb:
#     dropTablesCustom(MDiskPartition())
#     createTablesCustom(MDiskPartition())

proc fnGetPartionsInfo(): seq[MDiskPartition] =
    var mValue = disk_partitions()
    var mResult: seq[MDiskPartition] = @[]

    for iKey, oItem in mValue:
        var oI = MDiskPartition()
        oI.device = oItem.device
        oI.mountpoint = oItem.mountpoint
        oI.fstype = oItem.fstype
        oI.opts = oItem.opts
        var oUsage = disk_usage(oItem.device)
        oI.total = oUsage.total
        oI.used = oUsage.used
        oI.free = oUsage.free
        oI.percent = oUsage.percent
        mResult.add(oI)
    
    return mResult

proc fnGetHistoryData_DiskPartition*(): seq[TDiskPartition] =
    var db = getDb()
    var aRows = db.getAllRows(sql"SELECT * FROM MDiskPartition")

    var aList: seq[TDiskPartition]

    for oRow in aRows:
        var oItem: TDiskPartition
        var oRowClone = oRow

        oItem.created_at=utc(fromUnixFloat(oRowClone[0].f)).format("yyyy-MM-dd")
        oItem.device=oRowClone[1].s
        oItem.mountpoint=oRowClone[2].s
        oItem.fstype=oRowClone[3].s
        oItem.opts=oRowClone[4].s
        oItem.total=oRowClone[5].i.int
        oItem.used=oRowClone[6].i.int
        oItem.free=oRowClone[7].i.int
        oItem.percent=oRowClone[8].f

        aList.add(oItem)
    
    return aList