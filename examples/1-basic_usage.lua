-- Including xdiscord library
xorlib.Dependency("xdiscord/library")

local DISCORD_APPLICATION_ID = "<bot application id>"
local DISCORD_TOKEN          = "<bot token>"

-- Creating Discord client
MyDiscordClient = Discord.Client(DISCORD_APPLICATION_ID, DISCORD_TOKEN)

--
-- Let's override Discord client callbacks
--

function MyDiscordClient:OnDisconnect()
    -- Called when bot has been disconnected
end

function MyDiscordClient:OnDispatch(event, data)
    -- Called when new event is dispatched
end

function MyDiscordClient:OnReady(data)
    -- Called on "READY" event
    -- https://discord.com/developers/docs/topics/gateway-events#ready
end

function MyDiscordClient:OnResume()
    -- Called on "RESUMED" event
    -- https://discord.com/developers/docs/topics/gateway-events#resumed
    --
    -- Should be treated as :OnReady callback
end

-- Connecting our client to discord!
MyDiscordClient:Connect()
