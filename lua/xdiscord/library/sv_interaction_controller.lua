xorlib.Dependency("xdiscord/library", "sv_setup.lua")

Discord.INTERACTION_CONTROLLER = Discord.INTERACTION_CONTROLLER or {}
Discord.INTERACTION_CONTROLLER.__index = Discord.INTERACTION_CONTROLLER

function Discord.INTERACTION_CONTROLLER:AddCommand(command)
    self.Commands[command._RawData.name] = command

    return self
end

function Discord.INTERACTION_CONTROLLER:RegisterBulk()
    local commands = {}

    for _, command in pairs(self.Commands) do
        table.insert(commands, command._RawData)
    end

    self.Client:Request(
        "PUT",
        string.format("/applications/%s/commands", self.Client.ApplicationID),
        commands
    )

    return self
end

function Discord.INTERACTION_CONTROLLER:ProcessDispatch(event, interaction)
    if event ~= "INTERACTION_CREATE" then return end

    local command = self.Commands[interaction.data.name]
    x.Assert("Created interaction for command \"%s\" but it doesn't exist!", interaction.data.name)

    command:Run(self.Client, interaction)
end

function Discord.InteractionController(client)
    return setmetatable({
        Client = client,
        Commands = {},
    }, Discord.INTERACTION_CONTROLLER)
end
