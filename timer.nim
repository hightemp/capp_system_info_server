
proc fnSaveToDatabase*() =
    var aList = fnGetPartionsInfo()
    withDb:
        for oItem in aList:
            var oMDiskPartition = MDiskPartition(oItem)
            oMDiskPartition.created_at = now()
            db.insert(oMDiskPartition)