AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("sh_dtoken_config.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "dtoken" then -- Sprawdza czy dotyka danego entity
        local currentPaper = ent:GetPaper()
        if currentPaper == DToken.Config.MaxPaper then return end 
        local newPaper = math.min(currentPaper + DToken.Config.AddPaper, DToken.Config.MaxPaper) -- max 100 papieru
        ent:SetPaper(newPaper)

        -- ent:EmitSound("items/ammo_pickup.wav") -- Jak bede chciał te se dodam dzwiek
        self:Remove() -- Usuwa sie
    end
end