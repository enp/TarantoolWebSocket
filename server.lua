#!/usr/bin/env tarantool

local ws = require('websocket')
local json = require('json')
local ws_peers = {}

ws.server('ws://0.0.0.0:8080', function (ws_peer)
    local id = ws_peer.peer:fd()
    table.insert(ws_peers, id, ws_peer) -- save after connection

    while true do
        local message, err = ws_peer:read()
        if not message or message.opcode == nil then
            break
        else
            ws_peer:write(message.data)
        end
    end

    ws_peers[id] = nil -- remove after disconnection
end)
