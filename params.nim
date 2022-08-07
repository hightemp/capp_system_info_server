import argparse

var SERVER_HOST* = "0.0.0.0"
var SERVER_PORT* = 8080
var SECRET_KEY* = getEnv("SECRET_KEY", "secret")
var DB_HOST* = getEnv("DB_HOST", "data/dbfile.db")
var DB_DATABASE* = getEnv("DB_DATABASE", "")
var DB_USER* = getEnv("DB_USER", "")
var DB_PASSWORD* = getEnv("DB_PASSWORD", "")