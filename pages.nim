
proc page_index(ctx: Context) {.async.} =
    let data = readFile("public/index.html")
    resp htmlResponse(data)

app.get("/", page_index)