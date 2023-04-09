local modules = script.Parent

return function()
    for _, module in pairs(modules:GetChildren()) do
        if module ~= getfenv(2).script then
            getfenv(2)[module.Name] = require(module)
        end
    end
end