import std/strutils
import argparse

import params

var p = newParser:
    option("-p", "--port", default=some(getEnv("SERVER_PORT", "8080")), help="Port")
    option("-h", "--host", default=some(getEnv("SERVER_HOST", "0.0.0.0")), help="Host")

    # flag("-a", "--apple")
    # flag("-b", help="Show a banana")
    # arg("name")
    # arg("others", nargs = -1)

try:
    var opts = p.parse(commandLineParams())

    # assert opts.apple == true
    # assert opts.b == false
    # assert opts.output == "foo"
    # assert opts.name == "hi"
    # assert opts.others == @[]

    SERVER_PORT = parseInt(opts.port)
    SERVER_HOST = opts.host

except ShortCircuit as e:
    if e.flag == "argparse_help":
        echo p.help
        quit(1)
except UsageError:
    stderr.writeLine getCurrentExceptionMsg()
    quit(1)

include db
include system_info
include timer
include api
