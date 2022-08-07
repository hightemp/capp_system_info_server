
proc api_shell_run_command(ctx: Context) {.async.} =
    var sCommand = ctx.getPostParams("command")

    var oResult = execCmdEx("/bin/bash " & sCommand);
    # return resp $$oResult
    resp jsonResponse(%* { "result": $$oResult })

app.get("/api/shell/run_command", api_shell_run_command)