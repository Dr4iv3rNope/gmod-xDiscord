x.Assert(x.RequireModule("chttp"), "Module chttp is required!")
xorlib.Dependency("xdiscord/library", "sv_client.lua")
xorlib.Dependency("xdiscord/library", "sv_constants.lua")
xorlib.Dependency("xdiscord/thirdparty", "sv_json.lua")

function Discord.CLIENT:Request(method, path, data, callback)
    x.ExpectString(method)
    x.ExpectString(path)
    x.ExpectTableOrDefault(data)
    x.ExpectFunctionOrDefault(callback)

    CHTTP({
        method	= method,
        url		= string.format("https://discord.com/api/v%d%s", Discord.API_VERSION, path),
        body	= data and json.encode(data) or nil,
        type	= data and "application/json" or nil,

        headers = {
            ["user-agent"] = "DiscordBot",
            ["authorization"] = string.format("Bot %s", self.Token)
        },

        success = function(code, body)
            local data

            if body then
                local success, output = pcall(json.decode, body)
                data = output

                if not success then
                    self:Warn("Failed to parse json: %s", tostring(body))
                end
            end

            if code < 200 and code >= 300 then
                self:Error("Discord api error (%d): %s", code, tostring(body))
            end

            if data and data.errors then
                self:Warn("Request error: %s (%d)", data.message, data.code)

                --[[for i, err in ipairs(data.errors) do
                    x.Warn("Error #%d (%s): %s", i, err.code, err.message)
                end]]

                return
            end

            if callback then
                callback(data, code)
            end
        end,

        failed = function(reason)
            self:Error("Request failed (%s)\nReason: %s", path, tostring(reason))
        end
    })
end
