xorlib.Dependency("xdiscord/library", "sv_setup.lua")

Discord.INTERACTION_COMMAND = Discord.INTERACTION_COMMAND or {}
Discord.INTERACTION_COMMAND.__index = Discord.INTERACTION_COMMAND

function Discord.INTERACTION_COMMAND:AddOption(option)
    if not self._RawData.options then
        self._RawData.options = {}
    end

    table.insert(self._RawData.options, option._RawData)

    return self
end

function Discord.INTERACTION_COMMAND:AddPermission(permission)
    self._RawData.default_member_permissions = (self._RawData.default_member_permissions or 0) + permission

    return self
end

function Discord.INTERACTION_COMMAND:SetCallback(callback)
    x.ExpectFunction(callback)

    self.Callback = callback

    return self
end

function Discord.INTERACTION_COMMAND:Register(client)
    client:Request(
        "POST",
        string.format("/applications/%s/commands", client.ApplicationID),
        self._RawData
    )

    return self
end

function Discord.INTERACTION_COMMAND:Run(client, interaction)
    local options

    if interaction.data.options then
        options = x.MapCopyPairs(
            interaction.data.options,
            function(data)
                return data.value, data.name
            end
        )
    end

    self.Callback(
        Discord.InteractionResponse(client, interaction),
        options
    )
end

function Discord.InteractionCommand(name, description, type)
    x.ExpectString(name)
    x.ExpectString(description)

    return setmetatable({
        Callback = nil,

        _RawData = {
            name = name,
            description = description,
            type = type,
            options = nil,
            --default_member_permissions = 0
        }
    }, Discord.INTERACTION_COMMAND)
end
