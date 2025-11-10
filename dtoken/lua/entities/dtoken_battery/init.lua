AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("sh_dtoken_config.lua")

function ENT:Initialize()
    self:SetModel("models/items/car_battery01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
end

function ENT:StartTouch(ent)
    if not IsValid(ent) then return end

    if ent:GetClass() == "dtoken" then -- Sprawdza czy dotyka danego entity
        local currentBattery = ent:GetBattery()
        if currentBattery == 100 then return end 
        ent:SetBattery(100)

        -- ent:EmitSound("items/ammo_pickup.wav") -- Jak bede chciał te se dodam dzwiek
        self:Remove() -- Usuwa sie
    end
end