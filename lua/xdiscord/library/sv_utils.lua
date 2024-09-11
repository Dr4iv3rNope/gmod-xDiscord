xorlib.Dependency("xdiscord/library", "sv_setup.lua")

function Discord.ColorFromTable(tbl)
    return Discord.Color(tbl.r, tbl.g, tbl.b)
end

function Discord.Color(r, g, b)
    return bit.bor(
        bit.lshift(r, 16)
        bit.lshift(g, 8),
        b
    )
end

local function indexOrDefault(tbl, default, key, ...)
    local value = tbl[key]

    if value ~= nil then
        if type(value) == "table" then
            return indexOrDefault(value, default, ...)
        else
            return value
        end
    end

    return default
end

function Discord.GetEmbedCharactersCount(embed)
    local count = 0

    count = count + #indexOrDefault(embed, "", "title")
    count = count + #indexOrDefault(embed, "", "description")
    count = count + #indexOrDefault(embed, "", "footer", "text")
    count = count + #indexOrDefault(embed, "", "author", "name")

    for i, field in ipairs(embed.fields or {}) do
        count = count + #indexOrDefault(field, "", "name")
        count = count + #indexOrDefault(field, "", "value")
    end

    return count
end

function Discord.IsEmbedOverflowLimits(embed)
    if #indexOrDefault(embed, "", "title") > 256 then
        return true
    end

    if #indexOrDefault(embed, "", "description") > 4096 then
        return true
    end

    if #indexOrDefault(embed, {}, "fields") > 25 then
        return true
    end

    if #indexOrDefault(embed, "", "footer", "text") > 2048 then
        return true
    end

    if #indexOrDefault(embed, "", "author", "name") > 2048 then
        return true
    end

    for i, field in ipairs(embed.fields or {}) do
        if #indexOrDefault(field, "", "name") > 256 then
            return true
        end

        if #indexOrDefault(field, "", "value") > 1024 then
            return true
        end
    end

    return false
end

function Discord.ToISO8601(time)
    return os.date("%Y%m%dT%H%M%S", time)
end

local escapeCharacters = {
    ["_"] = "\\_",
    ["*"] = "\\*",
    ["~"] = "\\~",
    ["`"] = "\\`",
    ["@"] = "\\@",
    ["#"] = "\\#",
    ["-"] = "\\-",
    ["|"] = "\\|",
    [">"] = "\\>"
}

function Discord.EscapeString(str)
    return string.gsub(str, ".", escapeCharacters)
end
