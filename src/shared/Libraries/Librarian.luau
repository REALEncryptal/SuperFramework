local Librarian = {}

--[[

    Librarian
    Authored by Encryptal

    Librarian allows the quick and easy importing of modules from a shared context.

    2024-03-20
    
]]

function Librarian.Import(Name)
    return require(Librarian.Modules[Name])
end

function Librarian:Init(Paths)
    Librarian.Modules = {}

    for _, Path in ipairs(Paths) do
        for _, Module in ipairs(Path:GetDescendants()) do
            if Module:IsA("ModuleScript") then
                print("Discovered Module:", Module.Name)
                Librarian.Modules[Module.Name] = Module
            end
        end
    end
    
    shared.Import = Librarian.Import
end

return Librarian