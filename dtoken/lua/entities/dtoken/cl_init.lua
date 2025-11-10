include("shared.lua")
include("sh_dtoken_config.lua")
AddCSLuaFile("dtoken/imgui.lua")

local imgui = include("dtoken/imgui.lua")
-- local iconMaterial = Material("user.png")
-- Main Prostokąt
local mainw = 310
local mainh = 310
local liniaspace = 0.85 -- Ten Pasek Ciemny
-- Pasek z Ownerem I Tierem
local ownerw = 310 * 0.85
local ownerh = 80
-- Przycisk Upgrade
local upbuttonx = -100
local upbuttony = 70
local upbuttonw = 200
local upbuttonh = 50
-- Przycisk Withdraw
local wbuttonx = -100
local wbuttony = 15
local wbuttonw = 200
local wbuttonh = 50
-- Pasek gdzie bedzie kasa itp
local moneyw = 200
local moneyh = 70
local moneyx = -100
local moneyy = -60
function ENT:Draw()
    self:DrawModel()
    local printer = net.ReadEntity()
    local money = self:GetTokens()
    local ink = self:GetInk()
    local paper = self:GetPaper()
    local battery = self:GetBattery()
    local tier = self:GetTier()
    local owner = self:Getowning_ent()
    local ownernick = owner:Nick()
    if imgui.Entity3D2D(self, Vector(0,0,10.6), Angle(0,90,0), 0.1) then
        -- Main Prostokąt
        surface.SetDrawColor(60,60,60)
        surface.DrawRect(-154,-165,mainw , mainh)
        -- Obramówka prostokąta
        surface.SetDrawColor(70,70,70)
        surface.DrawRect(-154 * liniaspace,-165 * liniaspace,mainw * liniaspace ,mainh * liniaspace)
        
        -- Pasek z Ownerem, Paskiem
        draw.RoundedBoxEx(12,-130,-140,ownerw,ownerh,Color(90,90,90),false ,false ,true ,true )

        -- Bateria
        draw.RoundedBoxEx(12,-130 * 0.99,-138 * 1.01,ownerw * 0.99 - 1 ,ownerh * 0.2,Color(50,50,50)) -- Cień
        draw.RoundedBoxEx(12,-130 * 0.98 - 1 ,-138 ,ownerw * 0.98 * battery / 100 ,ownerh * 0.18,Color(0,180,0)) -- Pasek Zielon
        draw.SimpleText(battery .. " %","Exo18",0,moneyy * 2.22,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

        -- Ikonka
        --surface.SetMaterial(iconMaterial)
        --surface.DrawTexturedRect(-8, -162, 16, 16)
        -- Nick
        draw.RoundedBox(50,-130 * 0.99 - 1 ,-120 * 1.01 ,ownerw * 0.99 + 1,ownerh * 0.33,Color(70,70,70))
        draw.RoundedBox(50,-130 * 0.98 - 1,-120,ownerw * 0.98 + 1,ownerh * 0.3,Color(80,80,80))
        draw.SimpleText("Owner: " .. ownernick,"Exo24",0,-110,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        -- Tier
        draw.RoundedBox(50,-130 * 0.99 ,-93 * 1.01 ,ownerw * 0.99 ,ownerh * 0.33,Color(70,70,70))
        draw.RoundedBox(50,-130 * 0.98 ,-93,ownerw * 0.98 ,ownerh * 0.3,Color(80,80,80))
        draw.SimpleText("Tier: " .. tier,"Exo24",0,-83,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        -- Przycisk
        draw.RoundedBox(50,upbuttonx,upbuttony,upbuttonw,upbuttonh,Color(200,0,0))
        if imgui.xTextButton(" Menu", "Exo42", upbuttonx, upbuttony - 5, upbuttonw, upbuttonh, 0, Color(210,210,210), Color(140,140,140), Color(111,111,111)) then
            print("yay, we were clicked :D")
            local ent = self
            timer.Simple(0, function()
                if IsValid(ent) then
                    ent:MenuUpgrade()
                end
            end)
        end

        draw.RoundedBox(50,wbuttonx,wbuttony,wbuttonw,wbuttonh,Color(0,180,0))
        if imgui.xTextButton(" Withdraw", "Exo42", wbuttonx, wbuttony - 5, wbuttonw, wbuttonh, 0, Color(210,210,210), Color(140,140,140), Color(111,111,111)) then
            net.Start("DTokenWithdraw")
            net.WriteEntity(self)
            net.SendToServer()
        end
        -- Ilość Kasy Prostokąt
        draw.RoundedBoxEx(50,moneyx,moneyy ,moneyw,moneyh,Color(90,90,90),false,false,true,true)
        -- Drugi Prostokąt na którym sie faktycznie wyswietla 
        draw.RoundedBox(50,moneyx * 0.97,moneyy * 1.03 ,moneyw * 0.97 ,moneyh * 0.98,Color(70,70,70)) -- cień
        draw.RoundedBox(50,moneyx * 0.95,moneyy ,moneyw * 0.95,moneyh * 0.9,Color(80,80,80)) -- prostokąt
        draw.SimpleText("Money: ".. money,"Exo24",0,moneyy * 0.8,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("Ink: " .. ink .. "/" .. DToken.Config.MaxInk,"Exo24",0,moneyy * 0.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText("Paper: ".. paper .. "/" .. DToken.Config.MaxPaper,"Exo24",0,moneyy * 0.2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        imgui.End3D2D()
    end
end

function ENT:MenuUpgrade()
    local scrw, scrh = ScrW(), ScrH()
    local frameW, frameH = scrw * 0.5, scrh * 0.5
    local animTime, animDelay, animEase = 2, 0, 0.1
    local mainColor = Color(70, 70, 70)

    -- GŁÓWNE OKNO
    local mainframe = vgui.Create("DFrame")
    mainframe:ShowCloseButton(false)
    mainframe:MakePopup()
    mainframe:SetDraggable(false)
    mainframe:SetTitle("")
    mainframe:SetSize(0, 0)
    mainframe:Center()

    -- Animacja rozwijania okna
    local isAnimating = true
    mainframe:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        isAnimating = false
    end)

    mainframe.Paint = function(_, w, h)
        surface.SetDrawColor(mainColor)
        surface.DrawRect(0, 0, w, h)
    end

    mainframe.Think = function(me)
        if isAnimating then
            me:Center()
        end
    end

    -- PRZYCISK ZAMKNIĘCIA
    local close = vgui.Create("DButton", mainframe)
    close:SetSize(25, 25)
    close:SetPos(frameW - 25, 0)
    close:SetText("")
    close.DoClick = function()
        mainframe:Close()
    end
    close.Paint = function(_, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(150, 0, 0))
    end

    -- KONTENER GŁÓWNY
    local shell = vgui.Create("DPanel", mainframe)
    shell:SetSize(frameW - 10, frameH - 35)
    shell:SetPos(5, 30)
    shell.Paint = function() end

    -- KONTENER TIERÓW
    local tiersShell = vgui.Create("DPanel", shell)
    tiersShell:SetSize(shell:GetWide() / 4, shell:GetTall())
    tiersShell:SetPos(0, 0)
    tiersShell.Paint = function() end

    local tiers = vgui.Create("DPanelList", tiersShell)
    tiers:SetSize(tiersShell:GetWide(), tiersShell:GetTall())
    tiers:SetPos(0, 0)
    tiers:SetSpacing(0)
    tiers:EnableHorizontal(false)
    tiers:EnableVerticalScrollbar(false)
    tiers.Paint = function() end

    -- GENEROWANIE PRZYCISKÓW TIERÓW
    for k, v in ipairs(DToken.Config.Tiers) do
        local tierButton = vgui.Create("DButton", tiers)
        tiers:AddItem(tierButton)
        tierButton:SetSize(tiers:GetWide(), 70)
        tierButton:SetText("")

        tierButton.DoClick = function()
            print("Upgrade to tier:", k)
            net.Start("DTokenUpgrade")
            net.WriteEntity(self)
            net.WriteInt(k, 32)
            net.SendToServer()
        end

        local hoverLerp = 0
        tierButton.Paint = function(_, w, h)
            -- Animacja hover
            if tierButton:IsHovered() then
                hoverLerp = Lerp(0.05, hoverLerp, w)
            else
                hoverLerp = Lerp(0.05, hoverLerp, 0)
            end

            -- Tło przycisku
            if self:GetTier() >= k then
                -- Tier już kupiony - pełne tło
                draw.RoundedBox(0, 0, 0, w, h, Color(v.color.r, v.color.g, v.color.b, 150))
            else
                -- Tier nie kupiony - animowane tło
                draw.RoundedBox(0, 0, 0, hoverLerp, h, Color(v.color.r, v.color.g, v.color.b, 150))
            end

            -- Tekst "Tier X"
            draw.SimpleText("Tier " .. k, "Exo42", w / 2, h / 2 - 15, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- Obliczanie ceny upgrade'u
            local charge = 0
            for n, m in ipairs(DToken.Config.Tiers) do
                if not IsValid(self) then
                    mainframe:Close()
                    return
                end
                
                -- Sumuj ceny tierów od aktualnego do docelowego
                if n > self:GetTier() and n <= k then
                    charge = charge + m.price
                end
            end

            -- Wyświetlanie ceny lub "BOUGHT"
            local displayText = charge == 0 and "BOUGHT" or charge
            draw.SimpleText(displayText, "Exo42", w / 2, h / 2 -5 , Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end

    -- PANEL INFORMACYJNY
    local info = vgui.Create("DPanel", shell)
    info:SetSize(shell:GetWide() / 4 * 3 - 5, shell:GetTall())
    info:SetPos(shell:GetWide() / 4 + 5, 0)
    info.Paint = function() end

    -- INFORMACJE O WŁAŚCICIELU
    local playerstat = vgui.Create("DPanel", info)
    playerstat:SetSize(info:GetWide(), shell:GetTall() / 4 - 5)
    playerstat:SetPos(0, 0)
    playerstat.Paint = function(_, w, h)
        if not IsValid(self) then
            mainframe:Close()
            return
        end

        local owner = self:Getowning_ent()
        local ownerName = (IsValid(owner) and owner:Nick()) or "Disconnected"
        
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        draw.SimpleText("Owner", "Exo42", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(ownerName, "Exo42", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    -- INFORMACJE O PIENIĄDZACH
    local moneystat = vgui.Create("DPanel", info)
    moneystat:SetSize(info:GetWide(), shell:GetTall() / 4 - 5)
    moneystat:SetPos(0, shell:GetTall() / 4)
    moneystat.Paint = function(_, w, h)
        if not IsValid(self) then
            mainframe:Close()
            return
        end

        local money = self:GetTokens()
        local tier = self:GetTier()
        local ink = self:GetInk()
        local paper = self:GetPaper()

        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        draw.SimpleText("Money", "Exo42", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(money .. "$", "Exo42", w / 2, h / 2, Color(100, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Paper", "Exo42", w / 4, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(paper .. "/" .. DToken.Config.MaxPaper, "Exo42", w / 4, h / 2, Color(100, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Ink", "Exo42", w * .75, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(ink .. "/" .. DToken.Config.MaxInk, "Exo42", w * .75, h / 2, Color(100, 200, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    end
    local batterystat = vgui.Create("DPanel", mainframe)
    batterystat:SetSize(info:GetWide() + 101, shell:GetTall() / 4)
    batterystat:SetPos(100, 0)
    batterystat.Paint = function(_, w, h)
        if not IsValid(self) then
            mainframe:Close()
            return
        end

        local battery = self:GetBattery()
        draw.RoundedBox(100, 0, 0, w, h / 6, Color(10, 20, 10))
        draw.RoundedBox(100, 0, 0, w * battery / 100, h / 6, Color(100, 200, 100,100))
        draw.SimpleText(battery .. "%", "Exo42", w / 2, h / 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end
end