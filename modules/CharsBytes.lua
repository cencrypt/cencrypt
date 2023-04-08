local function charsToBytes(str: string, sep: string?)
    local sep = sep or "!"
    local bytes = {}
    string.gsub(str, ".", function(char)
        table.insert(bytes, tostring(string.byte(char)))
        return ""
    end)
    return table.concat(bytes, sep)
end

local function bytesToChars(str: string, sep: string)
    local chars = {}
    string.gsub(str, "[^"..sep.."]+", function(byte)
        table.insert(chars, string.char(tonumber(byte)))
        return ""
    end)
    return table.concat(chars, "")
end

return {
    charsToBytes = charsToBytes,
    bytesToChars = bytesToChars
}