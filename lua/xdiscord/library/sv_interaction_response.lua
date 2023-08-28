xorlib.Dependency("xdiscord/library", "sv_setup.lua")

Discord.INTERACTION_RESPONSE = Discord.INTERACTION_RESPONSE or {}
Discord.INTERACTION_RESPONSE.__index = Discord.INTERACTION_RESPONSE

function Discord.INTERACTION_RESPONSE:Callback(type, data, callback)
    self.Client:Request(
        "POST",
        string.format("/interactions/%s/%s/callback", self.RawData.id, self.RawData.token),
        {
            type = type,
            data = data
        },
        callback
    )

    return self
end

function Discord.INTERACTION_RESPONSE:Message(message, callback)
    return self:Callback(
        4, -- CHANNEL_MESSAGE_WITH_SOURCE
        message,
        callback
    )
end

function Discord.INTERACTION_RESPONSE:DeleteOriginal(callback)
    self.Client:Request(
        "DELETE",
        string.format("/webhooks/%s/%s/messages/@original", self.Client.ApplicationID, self.RawData.token),
        nil,
        callback
    )

    return self
end

function Discord.INTERACTION_RESPONSE:DeleteOriginalAfter(seconds, callback)
    timer.Simple(seconds, function()
        self:DeleteOriginal(callback)
    end)

    return self
end

function Discord.InteractionResponse(client, interaction)
    return setmetatable({
        Client = client,
        RawData = interaction
    }, Discord.INTERACTION_RESPONSE)
end
