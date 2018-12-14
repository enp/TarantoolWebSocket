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
        end
    end

    ws_peers[id] = nil -- remove after disconnection
end)

return {
    push = function (data)
        for _, ws_peer in pairs(ws_peers) do
            ws_peer:write(json.encode(data)) -- send message to all subscribers
        end
    end
}
