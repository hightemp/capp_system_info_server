
proc api_servers_get_remote(ctx: Context) {.async.} =
    resp jsonResponse(%* "")

app.get("/api/servers/{id}/{group}/{command}", api_servers_get_remote)