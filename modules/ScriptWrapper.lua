local modules = script.Parent

require(modules:WaitForChild("LoadModules"))()

local function wrapScript(scr, quickEncrypt)
    local src = scr.Source
    local srcSecure = quickEncrypt(src)
    local srcBytes = CharsBytes.charsToBytes(srcSecure)
    return table.concat({""}, "")
end

local function unwrapScript(str)

end

return {
    wrapScript = wrapScript
}