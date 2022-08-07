
proc api_history_list_disk_partitions(ctx: Context) {.async.} =
    let aList = fnGetHistoryData_DiskPartition()
    resp jsonResponse(%* $aList)

app.get("/api/history/list_disk_partitions", api_history_list_disk_partitions)
