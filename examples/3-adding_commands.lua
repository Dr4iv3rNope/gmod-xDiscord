xorlib.Dependency("xdiscord/library")

local DISCORD_APPLICATION_ID = "<bot application id>"
local DISCORD_TOKEN          = "<bot token>"

if MyDiscordClient then
    MyDiscordClient:Shutdown()
end

MyDiscordClient = MyDiscordClient or Discord.Client(DISCORD_APPLICATION_ID, DISCORD_TOKEN)

-- Creating Discord interaction controller to add commands
MyDiscordInteractionController = Discord.InteractionController(MyDiscordClient)

-- Creating interaction command
local printCommand = Discord.InteractionCommand(
    "print", -- Command name that starts with slash (/)
    "Print message in server console", -- Description
    Discord.COMMAND_TYPE_CHAT_INPUT
)

-- Add option
printCommand:AddOption(
    Discord.InteractionCommandOption(
        "text", -- Option name
        "message", -- Display name
        Discord.COMMAND_OPTION_TYPE_STRING -- Option type (see Discord.COMMAND_OPTION_TYPE_*)
    )
    -- Make it required
    :SetRequired()
)

-- Set callback
printCommand:SetCallback(function(interaction, options)
    -- Building full username
    local username = Discord.FormatUsername(
        -- https://discord.com/developers/docs/resources/guild#guild-member-object
        interaction.RawData.member.user.username,
        interaction.RawData.member.user.discriminator
    )

    -- Print our message in console
    print(
        username,
        "wrote to console",
        options.text
    )

    -- Reply message when we're done
    interaction:Message({ content = "Done!" })
end)

-- Register commands!
MyDiscordInteractionController
    :AddCommand(printCommand) -- Our print command
    -- Let's add shutdown command
    :AddCommand(
        Discord.InteractionCommand("restart", "Restart the server!")
            :SetCallback(function(interaction)
                timer.Simple(60, function()
                    game.ConsoleCommand("_restart\n")
                end)

                interaction:Message({ content = "Restarting server in 1 minute..." })
            end)
        -- :SetCallback and other methods returns discord interaction command object
        -- so you can create chain call
    )
    :RegisterBulk()

function MyDiscordClient:OnDispatch(event, data)
    -- Processing any incoming interactions
    MyDiscordInteractionController:ProcessDispatch(event, data)
end

MyDiscordClient:Connect()
