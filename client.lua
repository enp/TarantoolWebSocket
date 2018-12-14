#!/usr/bin/env tarantool

local log = require('log')
local websocket = require('websocket')
local json = require('json')

local ws, err = websocket.connect('wss://127.0.0.127:8080', nil, {timeout=3})

if not ws then
    log.info(err)
    return
end

ws:write('HELLO')
local response = ws:read()
log.info(response)
assert(response.data == 'HELLO')
