x.Assert(x.RequireModule("gwsockets"), "Module gwsockets is required!")
xorlib.Dependency("xdiscord/library", "sv_setup.lua")
xorlib.Dependency("xdiscord/library", "sv_constants.lua")

Discord.CLIENT = Discord.CLIENT or {}
Discord.CLIENT.__index = Discord.CLIENT

function Discord.CLIENT:_StartHeartbeat(sec)
    timer.Create(
        tostring(self) .. "heartbeat",
        sec,
        0,
        function()
            self:Dispatch(1, self._LastSequenceID)
        end
    )
end

function Discord.CLIENT:_StopHeartbeat()
    timer.Remove(tostring(self) .. "heartbeat")
end

function Discord.CLIENT:_StartReconnect(sec)
    if not self.AutoReconnect then return end

    self:Warn("Reconnecting in %d seconds...", sec)

    timer.Create(
        tostring(self) .. "reconnect",
        sec,
        1,
        x.Bind(Discord.CLIENT.Connect, self)
    )
end

function Discord.CLIENT:_StopReconnect()
    timer.Remove(tostring(self) .. "reconnect")
end

function Discord.CLIENT:_Print(fn, fmt, ...)
    fn("[Discord %s] " .. fmt, self._ConsolePrefix, ...)
end

function Discord.CLIENT:Print(fmt, ...)
    self:_Print(x.Print, fmt, ...)
end

function Discord.CLIENT:Warn(fmt, ...)
    self:_Print(x.Warn, fmt, ...)
end

function Discord.CLIENT:Error(fmt, ...)
    self:_Print(x.Error, fmt, ...)
end

function Discord.CLIENT:ErrorNoHalt(fmt, ...)
    self:_Print(x.ErrorNoHalt, fmt, ...)
end

function Discord.CLIENT:ErrorNoHaltWithStack(fmt, ...)
    self:_Print(x.ErrorNoHaltWithStack, fmt, ...)
end

local preDispatch = {
    ["READY"] = function(client, data)
        client.IsReady = true

        client:StartNewSession(data.session_id, data.user)
        client:Print("Ready!")
        client:OnReady(data)
    end
}

local preRawDispatch = {
    [Discord.OPCODE_DISPATCH] = function(client, data)
        local preDispatchFn = preDispatch[data.t]

        if preDispatchFn then
            preDispatchFn(client, data.d)
        end

        client:OnDispatch(data.t, data.d)
    end,

    [Discord.OPCODE_RECONNECT] = function(client)
        client:Print("Discord wants us to reconnect...")

        client:Disconnect()
        client:_StartReconnect(client.AutoReconnectTimeout)
    end,

    [Discord.OPCODE_INVALID_SESSION] = function(client)
        client:Warn("Invalid session")

        client:Disconnect()
        client:CleanupSessionData()
        client:_StartReconnect(client.AutoReconnectTimeout)
    end,

    [Discord.OPCODE_HELLO] = function(client, data)
        client:Print("Hello! Heartbeat interval: %d", data.d.heartbeat_interval)

        if client._LastSequenceID and client._LastSessionID then
            client:Print("Resume last session")

            client:Dispatch(Discord.OPCODE_RESUME, {
                token		= client.Token,
                session_id	= client._LastSessionID,
                seq			= client._LastSequenceID
            })

            client.IsReady = true
            client:OnResume()
        else
            client:Print("Identify myself...")

            client:Dispatch(Discord.OPCODE_IDENTIFY, {
                token	= client.Token,
                intents	= client.Intents,

                properties = {
                    os		= "linux",
                    browser	= "gmdiscordbot",
                    device	= "gmdiscordbot"
                }
            })
        end

        client:_StartHeartbeat(data.d.heartbeat_interval / 1000)
    end
}

function Discord.CLIENT:_SetupWebSocketCallbacks(ws)
    local client = self

    function ws:onConnected()
        client:Print("Connected to the gateway!")

        client:_StopReconnect()
    end

    function ws:onMessage(text)
        local json = util.JSONToTable(text)

        if not json then
            return client:Warn("Failed to parse json: %s", tostring(text))
        end

        local preRawDispatchFn = preRawDispatch[json.op]

        if preRawDispatchFn then
            preRawDispatchFn(client, json)
        end

        if json.op == 0 then -- DISPATCH
            client._LastSequenceID = json.s
        end

        client:OnRawDispatch(json.op, json.d)
    end

    function ws:onError(err)
        client:Warn("Socket error occured: %s", tostring(err))

        client:Disconnect()
        client:_StartReconnect(client.AutoReconnectTimeout)
    end

    function ws:onDisconnected(reason)
        client:Warn("Socket has been disconnected.\nReason: \"%s\"", reason)

        client:Disconnect()
        client:_StartReconnect(client.AutoReconnectTimeout)
    end
end

function Discord.CLIENT:Connect()
    x.Assert(not self:IsConnected(), "Client must be disconnected")

    self.Socket = GWSockets.createWebSocket(string.format("wss://gateway.discord.gg/?v=%d&encoding=json", Discord.API_VERSION))
    self:_SetupWebSocketCallbacks(self.Socket)
    self.Socket:open()

    self:OnSocketOpen()
end

function Discord.CLIENT:Disconnect()
    self:Print("Disconnect")

    self.IsReady = false

    self:_StopHeartbeat()
    self:_StopReconnect()

    if self:IsConnected() then
        self.Socket:closeNow()
    end

    self:OnDisconnect()
end

function Discord.CLIENT:Shutdown()
    self:Print("Shutdown")

    if self.Socket then
        self.Socket.onError = nil
        self.Socket.onDisconnected = nil
    end

    self:Disconnect()
end

function Discord.CLIENT:StartNewSession(sessionID, bot)
    self._ConsolePrefix = string.format(
        "%s#%s",
        bot.username,
        bot.discriminator
    )

    self:Print("Started new session: %s", sessionID)

    self.Bot = bot
    self._LastSequenceID = 0
    self._LastSessionID = sessionID
end

function Discord.CLIENT:CleanupSessionData()
    x.Assert(not self:IsConnected(), "Client must be disconnected")

    self:Print("Cleanup session data")

    self._ConsolePrefix = self.ApplicationID
    self.Bot = nil
    self._LastSequenceID = nil
    self._LastSessionID = nil
end

function Discord.CLIENT:IsConnected()
    return self.Socket and self.Socket:isConnected()
end

function Discord.CLIENT:Dispatch(opcode, data)
    x.Assert(self:IsConnected(), "Discord bot must be connected")

    self.Socket:write(json.encode({
        op = opcode,
        d = data
    }))
end

function Discord.CLIENT:OnSocketOpen()
    -- for override
end

function Discord.CLIENT:OnDisconnect()
    -- for override
end

function Discord.CLIENT:OnRawDispatch(opcode, data)
    -- for override
end

function Discord.CLIENT:OnDispatch(event, data)
    -- for override
end

function Discord.CLIENT:OnReady(data)
    -- for override
end

function Discord.CLIENT:OnResume()
    -- for override
end

function Discord.Client(applicationID, token, ...)
    return setmetatable({
        ApplicationID = applicationID,
        Token = token,
        Intents = bit.bor(0, ...),

        IsReady = false,
        Socket = nil,
        AutoReconnect = true,
        AutoReconnectTimeout = 5,

        _ConsolePrefix = applicationID,
        _LastSequenceID = nil,
        _LastSessionID = nil
    }, Discord.CLIENT)
end
