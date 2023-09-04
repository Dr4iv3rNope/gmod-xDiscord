--
-- Shutting down discord client is very important
-- if you're hot reloading lua file, otherwise we
-- wont be able to create new discord client!
--

xorlib.Dependency("xdiscord/library")

local DISCORD_APPLICATION_ID = "<bot application id>"
local DISCORD_TOKEN          = "<bot token>"

-- Checking if our discord client exists
if MyDiscordClient then
    -- Force shutdown client
    MyDiscordClient:Shutdown()
end

MyDiscordClient = MyDiscordClient or Discord.Client(DISCORD_APPLICATION_ID, DISCORD_TOKEN)

-- ...

MyDiscordClient:Connect()
