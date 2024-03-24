local Librarian = {}

--[[

    Librarian
    Authored by Encryptal

    Librarian allows the quick and easy importing of modules from a shared context.

    2024-03-20
    
]]

function Librarian.Import(Name)
    return Librarian.Modules[Name]
end

function Librarian:Init(...)
    Librarian.Modules = {}

    for _, Module in ipairs({...}) do
        Librarian.Modules[Module.Name] = require(Module)
    end

    shared.Import = Librarian.Import
end

return Librarian