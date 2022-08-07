
proc api_list_boot_time(ctx: Context) {.async.} =
    let mValue = boot_time()
    resp jsonResponse(%* mValue)

proc api_list_uptime(ctx: Context) {.async.} =
    let mValue = uptime()
    resp jsonResponse(%* mValue)

proc api_list_pids(ctx: Context) {.async.} =
    let mValue = pids()
    resp jsonResponse(%* mValue)

proc api_list_users(ctx: Context) {.async.} =
    let mValue = users()
    resp jsonResponse(%* mValue)

proc api_list_cpu_times(ctx: Context) {.async.} =
    let mValue = cpu_times()
    resp jsonResponse(%* mValue)

proc api_list_per_cpu_times(ctx: Context) {.async.} =
    let mValue = per_cpu_times()
    resp jsonResponse(%* mValue)

proc api_list_virtual_memory(ctx: Context) {.async.} =
    let mValue = virtual_memory()
    resp jsonResponse(%* mValue)

proc api_list_swap_memory(ctx: Context) {.async.} =
    let mValue = swap_memory()
    resp jsonResponse(%* mValue)

type DiskPartitionExtended = ref object
    disk_partition: DiskPartition
    disk_usage: DiskUsage

proc api_list_disk_partitions(ctx: Context) {.async.} =
    var mValue = disk_partitions()
    var mResult: seq[DiskPartitionExtended] = @[]

    for iKey, oItem in mValue:
        var oI = DiskPartitionExtended()
        oI.disk_partition = oItem
        oI.disk_usage = disk_usage(oItem.device)
        mResult.add(oI)

    resp jsonResponse(%* mResult)

proc api_list_per_nic_net_io_counters(ctx: Context) {.async.} =
    let mValue = per_nic_net_io_counters()
    resp jsonResponse(%* mValue)

proc api_list_net_if_stats(ctx: Context) {.async.} =
    let mValue = net_if_stats()
    resp jsonResponse(%* mValue)

proc api_list_per_disk_io_counters(ctx: Context) {.async.} =
    let mValue = per_disk_io_counters()
    resp jsonResponse(%* mValue)

proc api_list_mounts(ctx: Context) {.async.} =
    let aList = disk_partitions()
    resp jsonResponse(%* aList)

app.get("/api/current/list_boot_time", api_list_boot_time)
app.get("/api/current/list_uptime", api_list_uptime)
app.get("/api/current/list_pids", api_list_pids)
app.get("/api/current/list_users", api_list_users)
app.get("/api/current/list_cpu_times", api_list_cpu_times)
app.get("/api/current/list_per_cpu_times", api_list_per_cpu_times)
app.get("/api/current/list_virtual_memory", api_list_virtual_memory)
app.get("/api/current/list_swap_memory", api_list_swap_memory)
app.get("/api/current/list_disk_partitions", api_list_disk_partitions)
app.get("/api/current/list_per_nic_net_io_counters", api_list_per_nic_net_io_counters)
app.get("/api/current/list_net_if_stats", api_list_net_if_stats)
app.get("/api/current/list_per_disk_io_counters", api_list_per_disk_io_counters)