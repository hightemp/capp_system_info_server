import prologue
import prologue/middlewares/signedcookiesession
import prologue/middlewares/staticfile

import psutil
import psutil/common
import std/json

import params

import std/logging
import std/strformat

import std/marshal
import std/asyncdispatch

import std/osproc

var consoleLog = newConsoleLogger()
var fileLog = newFileLogger("log_errors.log", levelThreshold=lvlError)
var rollingLog = newRollingFileLogger("log_rolling.log")

addHandler(consoleLog)
addHandler(fileLog)
addHandler(rollingLog)

var oSettings = newSettings(
    appName = "capp_system_info_server", 
    debug = true, 
    port = Port(SERVER_PORT),
    address = SERVER_HOST
)

info(&"Listen to: {SERVER_HOST}:{SERVER_PORT} Secret: {params.SECRET_KEY}\n")

proc authWithSecretKey*(sKey: string): HandlerAsync =
    var sLocalKey = sKey
    # info(&"[!] authWithSecretKey - {sKey} \n")
    result = proc(ctx: Context) {.async.} =
        var sSecretKey = ctx.getQueryParams("key", "")
        
        # info(&"[!] {sSecretKey} {sKey} \n")

        if sSecretKey != sLocalKey:
            return
        await switch(ctx)

if (oSettings != nil):
    var app = newApp(oSettings)

    app.use(
        authWithSecretKey(params.SECRET_KEY),
        staticFileMiddleware("public"), 
        sessionMiddleware(oSettings, path = "/")
    )

    include pages
    include api_shell
    include api_current
    include api_history
    include api_servers

    app.run()