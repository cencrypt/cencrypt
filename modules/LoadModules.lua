local modules = script.Parent

return function(bl)
    for _, module in pairs(modules:GetChildren()) do
        local bled = false
        for _, s in pairs(bl) do
            if module == s then
                bled = true
                break
            end
        end
        if bled == false then
            if module ~= getfenv(2).script then
                getfenv(2)[module.Name] = require(module)
            end
        end
    end
end