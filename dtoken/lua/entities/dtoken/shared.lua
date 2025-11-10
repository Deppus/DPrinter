AddCSLuaFile()
DToken = Dtoken or {}

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName   = "DPrinter"
ENT.Spawnable = true
ENT.Category = "DPrinter"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Int", 0, "Tokens" )
    self:NetworkVar("Int", 1, "TokensPerMin")
    self:NetworkVar("Int", 2, "Tier")
    self:NetworkVar("Int", 3, "Battery")
    self:NetworkVar("Int", 4, "Ink")
    self:NetworkVar("Int", 5, "Paper")

end