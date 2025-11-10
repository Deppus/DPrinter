AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("sh_dtoken_config.lua")
util.AddNetworkString("DTokenWithdraw")
util.AddNetworkString("DTokenUpgrade")

function ENT:Initialize()
    self:SetModel("models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self.maxmoney = 1000
    self.tokensup = 1
    if self:GetTier() == 0 then
		self:SetTier(1)
	end
    self:SetBattery(100)
    self:SetInk(5)
    self:SetPaper(5)
    self:PrintMoney() -- Musi być na koncu bo pierw sie musza te self. wziasc zinicjalizować
    self:Battery()
end

function ENT:PrintMoney()
    battery = self:GetBattery()
    ink = self:GetInk()
    paper = self:GetPaper()
    if !IsValid(self) then return end
    timer.Simple(DToken.Config.PrintInterval, function() -- co sekunde loop ( weryfikuje czy nikt sie nie chce podszyc pod entity )
        if IsValid(self) then
                self:PrintMoney()
        end
    end)
    if ink <= 0 or paper <= 0 or battery <= 0 then return end
    local currentTier = self:GetTier()
    local tierData = DToken.Config.Tiers[currentTier]
        if tierData then
            self.tokensup = tierData.amount
        end
    local tokens = self:GetTokens() or 0
    tokens = math.min(tokens + self.tokensup, self.maxmoney)
    if battery ~= 0 then -- jezeli bateria nie jest 0
        self:SetTokens(tokens)
        self:SetPaper(paper - 1)
        self:SetInk(ink - 1)
    end
end

function ENT:Battery()
        local ink = self:GetInk()
        local paper = self:GetPaper()
		if not IsValid(self) then return end
		-- Used to trigger the next battery decrease
		timer.Simple(DToken.Config.BatteryTime, function()
			if not IsValid(self) then return end
			    self:Battery()
		end)
        if ink <= 0 or paper <= 0 or battery <= 0 then return end
		-- Decreases battery if it is >0
		if self:GetBattery() == 0 then return end
		self:SetBattery(self:GetBattery()-1)
end


net.Receive( "DTokenWithdraw", function( len, ply )
    local ent = net.ReadEntity()
    if !IsValid(ent) then return end

    local money = ent:GetTokens()
    ply:addMoney(money)
    ent:SetTokens(0)

end )

net.Receive( "DTokenUpgrade", function( len, ply )
    local ent = net.ReadEntity()
    if !IsValid(ent) then return end
    local id = net.ReadInt(32)
    local itemData = DToken.Config.Tiers[id]
    if not itemData then return end
    
    print("Przed Zakupem")
    local charge = itemData.price
    print(charge)
    print(ent:GetTier())
    
    -- Sprawdzamy czy id odpowiada następnemu tierowi
    if id ~= ent:GetTier() + 1 then 
        print("No nie - zły tier")
        return
    end
    
    -- Sprawdzamy czy gracz ma wystarczająco pieniędzy
    if ply:getDarkRPVar("money") >= charge then
        print("Kupuje")
        ent:SetTier(id)
        ply:addMoney(-charge)
    else
        print("Za mało pieniędzy")
    end
end )
