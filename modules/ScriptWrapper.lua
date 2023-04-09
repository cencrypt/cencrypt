local modules = script.Parent

require(modules:WaitForChild("LoadModules"))()

local function wrapScript(scr, quickEncrypt)
    local src = scr.Source
    local srcBytes = CharsBytes.charsToBytes(src)
    local srcSecure = quickEncrypt()
end

local function unwrapScript(str)

end

return {
    wrapScript = wrapScript
}