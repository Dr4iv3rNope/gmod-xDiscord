xorlib.Dependency("xdiscord/library", "sv_setup.lua")

Discord.INTERACTION_COMMAND_OPTION = Discord.INTERACTION_COMMAND_OPTION or {}
Discord.INTERACTION_COMMAND_OPTION.__index = Discord.INTERACTION_COMMAND_OPTION

function Discord.INTERACTION_COMMAND_OPTION:SetRequired()
    self._RawData.required = true

    return self
end

function Discord.InteractionCommandOption(name, description, type)
    return setmetatable({
        Callback = nil,

        _RawData = {
            name = name,
            description = description,
            type = type,
            options = {}
        }
    }, Discord.INTERACTION_COMMAND_OPTION)
end
