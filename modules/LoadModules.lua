local modules = script.Parent

return function(bl)
    for _, module in pairs(modules:GetChildren()) do
        getfenv(2)[module.Name] = require(module)
    end
end