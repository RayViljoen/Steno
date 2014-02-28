# ======================================================
#   Gets new emails from imap account
# ======================================================

config = require '../config'
reeder = require './reader'
db     = require './db'

Imap = require 'imap'       # https://github.com/mscdex/node-imap

# Configure new iMap connection
imap = new Imap
    user: config.email
    password: config.password
    tls: config.secure
    host: config.host
    port: config.port
    tlsOptions: { rejectUnauthorized: no }

# Connect to gmail
do imap.connect

do imap.end