AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("sh_dtoken_config.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "dtoken" then -- Sprawdza czy dotyka danej klasy
        local currentInk = ent:GetInk()
        if currentInk == DToken.Config.MaxInk then return end 
        local howmuchink = DToken.Config.AddInk
        print(howmuchink)
        local newInk = math.min(currentInk + howmuchink, DToken.Config.MaxInk) -- max 100 tuszu
        ent:SetInk(newInk)

        -- ent:EmitSound("items/ammo_pickup.wav") -- Jak bede chciał te se dodam dzwiek
        self:Remove() -- Usuwa sie
    end
end