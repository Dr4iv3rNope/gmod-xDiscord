xorlib.Dependency("xdiscord/library", "sv_setup.lua")

Discord.API_VERSION = 10

-- https://discord.com/developers/docs/topics/opcodes-and-status-codes#gateway

Discord.OPCODE_DISPATCH              = 0  -- [Receive] An event was dispatched.
Discord.OPCODE_HEARTBEAT             = 1  -- [Send/Receive] Fired periodically by the client to keep the connection alive.
Discord.OPCODE_IDENTIFY              = 2  -- [Send] Starts a new session during the initial handshake.
Discord.OPCODE_PRESENCE_UPDATE       = 3  -- [Send] Update the client's presence.
Discord.OPCODE_VOICE_STATE_UPDATE    = 4  -- [Send] Used to join/leave or move between voice channels.
Discord.OPCODE_RESUME                = 6  -- [Send] Resume a previous session that was disconnected.
Discord.OPCODE_RECONNECT             = 7  -- [Receive] You should attempt to reconnect and resume immediately.
Discord.OPCODE_REQUEST_GUILD_MEMBERS = 8  -- [Send] Request information about offline guild members in a large guild.
Discord.OPCODE_INVALID_SESSION       = 9  -- [Receive] The session has been invalidated. You should reconnect and identify/resume accordingly.
Discord.OPCODE_HELLO                 = 10 -- [Receive] Sent immediately after connecting, contains the heartbeat_interval to use.
Discord.OPCODE_HEARTBEAT_ACK         = 11 -- [Receive] Sent in response to receiving a heartbeat to acknowledge that it has been received.

Discord.INTENTS_GUILD                     = bit.lshift(1, 0)
Discord.INTENTS_GUILD_MEMBERS             = bit.lshift(1, 1)
Discord.INTENTS_GUILD_BANS                = bit.lshift(1, 2)
Discord.INTENTS_GUILD_EMOJIS_AND_STICKERS = bit.lshift(1, 3)
Discord.INTENTS_GUILD_INTEGRATIONS        = bit.lshift(1, 4)
Discord.INTENTS_GUILD_WEBHOOKS            = bit.lshift(1, 5)
Discord.INTENTS_GUILD_INVITES             = bit.lshift(1, 6)
Discord.INTENTS_GUILD_VOICE_STATES        = bit.lshift(1, 7)
Discord.INTENTS_GUILD_PRESENCES           = bit.lshift(1, 8)
Discord.INTENTS_GUILD_MESSAGES            = bit.lshift(1, 9)
Discord.INTENTS_GUILD_MESSAGE_REACTIONS   = bit.lshift(1, 10)
Discord.INTENTS_GUILD_MESSAGE_TYPING      = bit.lshift(1, 11)
Discord.INTENTS_DIRECT_MESSAGES           = bit.lshift(1, 12)
Discord.INTENTS_DIRECT_MESSAGE_REACTIONS  = bit.lshift(1, 13)
Discord.INTENTS_DIRECT_MESSAGE_TYPING     = bit.lshift(1, 14)
Discord.INTENTS_GUILD_SCHEDULED_EVENTS    = bit.lshift(1, 15)

Discord.PERMISSION_CREATE_INSTANT_INVITE      = 0x0000000000000001 -- (1 << 0)
Discord.PERMISSION_KICK_MEMBERS               = 0x0000000000000002 -- (1 << 1)
Discord.PERMISSION_BAN_MEMBERS                = 0x0000000000000004 -- (1 << 2)
Discord.PERMISSION_ADMINISTRATOR              = 0x0000000000000008 -- (1 << 3)
Discord.PERMISSION_MANAGE_CHANNELS            = 0x0000000000000010 -- (1 << 4)
Discord.PERMISSION_MANAGE_GUILD               = 0x0000000000000020 -- (1 << 5)
Discord.PERMISSION_ADD_REACTIONS              = 0x0000000000000040 -- (1 << 6)
Discord.PERMISSION_VIEW_AUDIT_LOG             = 0x0000000000000080 -- (1 << 7)
Discord.PERMISSION_PRIORITY_SPEAKER           = 0x0000000000000100 -- (1 << 8)
Discord.PERMISSION_STREAM                     = 0x0000000000000200 -- (1 << 9)
Discord.PERMISSION_VIEW_CHANNEL               = 0x0000000000000400 -- (1 << 10)
Discord.PERMISSION_SEND_MESSAGES              = 0x0000000000000800 -- (1 << 11)
Discord.PERMISSION_SEND_TTS_MESSAGES          = 0x0000000000001000 -- (1 << 12)
Discord.PERMISSION_MANAGE_MESSAGES            = 0x0000000000002000 -- (1 << 13)
Discord.PERMISSION_EMBED_LINKS                = 0x0000000000004000 -- (1 << 14)
Discord.PERMISSION_ATTACH_FILES               = 0x0000000000008000 -- (1 << 15)
Discord.PERMISSION_READ_MESSAGE_HISTORY       = 0x0000000000010000 -- (1 << 16)
Discord.PERMISSION_MENTION_EVERYONE           = 0x0000000000020000 -- (1 << 17)
Discord.PERMISSION_USE_EXTERNAL_EMOJIS        = 0x0000000000040000 -- (1 << 18)
Discord.PERMISSION_VIEW_GUILD_INSIGHTS        = 0x0000000000080000 -- (1 << 19)
Discord.PERMISSION_CONNECT                    = 0x0000000000100000 -- (1 << 20)
Discord.PERMISSION_SPEAK                      = 0x0000000000200000 -- (1 << 21)
Discord.PERMISSION_MUTE_MEMBERS               = 0x0000000000400000 -- (1 << 22)
Discord.PERMISSION_DEAFEN_MEMBERS             = 0x0000000000800000 -- (1 << 23)
Discord.PERMISSION_MOVE_MEMBERS               = 0x0000000001000000 -- (1 << 24)
Discord.PERMISSION_USE_VAD                    = 0x0000000002000000 -- (1 << 25)
Discord.PERMISSION_CHANGE_NICKNAME            = 0x0000000004000000 -- (1 << 26)
Discord.PERMISSION_MANAGE_NICKNAMES           = 0x0000000008000000 -- (1 << 27)
Discord.PERMISSION_MANAGE_ROLES               = 0x0000000010000000 -- (1 << 28)
Discord.PERMISSION_MANAGE_WEBHOOKS            = 0x0000000020000000 -- (1 << 29)
Discord.PERMISSION_MANAGE_EMOJIS_AND_STICKERS = 0x0000000040000000 -- (1 << 30)
Discord.PERMISSION_USE_APPLICATION_COMMANDS   = 0x0000000080000000 -- (1 << 31)
Discord.PERMISSION_REQUEST_TO_SPEAK           = 0x0000000100000000 -- (1 << 32)
Discord.PERMISSION_MANAGE_EVENTS              = 0x0000000200000000 -- (1 << 33)
Discord.PERMISSION_MANAGE_THREADS             = 0x0000000400000000 -- (1 << 34)
Discord.PERMISSION_CREATE_PUBLIC_THREADS      = 0x0000000800000000 -- (1 << 35)
Discord.PERMISSION_CREATE_PRIVATE_THREADS     = 0x0000001000000000 -- (1 << 36)
Discord.PERMISSION_USE_EXTERNAL_STICKERS      = 0x0000002000000000 -- (1 << 37)
Discord.PERMISSION_SEND_MESSAGES_IN_THREADS   = 0x0000004000000000 -- (1 << 38)
Discord.PERMISSION_USE_EMBEDDED_ACTIVITIES    = 0x0000008000000000 -- (1 << 39)
Discord.PERMISSION_MODERATE_MEMBERS           = 0x0000010000000000 -- (1 << 40)

Discord.COMMAND_TYPE_CHAT_INPUT               = 1
Discord.COMMAND_TYPE_USER                     = 2
Discord.COMMAND_TYPE_MESSAGE                  = 3

Discord.COMMAND_OPTION_TYPE_SUB_COMMAND       = 1
Discord.COMMAND_OPTION_TYPE_SUB_COMMAND_GROUP = 2
Discord.COMMAND_OPTION_TYPE_STRING            = 3
Discord.COMMAND_OPTION_TYPE_INTEGER           = 4
Discord.COMMAND_OPTION_TYPE_BOOLEAN           = 5
Discord.COMMAND_OPTION_TYPE_USER              = 6
Discord.COMMAND_OPTION_TYPE_CHANNEL           = 7
Discord.COMMAND_OPTION_TYPE_ROLE              = 8
Discord.COMMAND_OPTION_TYPE_MENTIONABLE       = 9
Discord.COMMAND_OPTION_TYPE_NUMBER            = 10
Discord.COMMAND_OPTION_TYPE_ATTACHMENT        = 11
