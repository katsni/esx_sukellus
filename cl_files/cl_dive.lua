local cachedcoords = {}
local tutkitaan = false
local prop = nil
local prap = nil
local varusteetPaalla = false
local happi = 100
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Etsi = function()
    local pelaaja = PlayerPedId()
    TaskStartScenarioInPlace(pelaaja, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    Citizen.Wait(6000)
    ClearPedTasksImmediately(PlayerPedId())
    if tutkitaan then
        ESX.TriggerServerCallback("esx_cat_diving:reward", function(source, cb)
            
        end)
    end
    tutkitaan = false
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function Texti(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

RegisterNetEvent('esx_cat_diving:happimaski')
AddEventHandler('esx_cat_diving:happimaski', function()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	local boneIndex = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)
    exports['progbar']:Progress({
        name = "sukellus_paalle",
        duration = Config.DressingUp.Time,
        label = 'Puetaan happipulloa',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovementSprint = true,
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "move_f@hiking",
            anim = "idle_intro",
            flags = 49,
        }
    }, function(cancelled)
        if not cancelled then
            ESX.Game.SpawnObject('p_s_scuba_mask_s', {
                x = coords.x,
                y = coords.y,
                z = coords.z - 3
            }, function(object)
                prop = object
                ESX.Game.SpawnObject('p_s_scuba_tank_s', {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z - 3
                }, function(object2)
                    prap = object2
                    AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
                    AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
                    SetPedDiesInWater(PlayerPedId(), false)
                    varusteetPaalla = true
                    happi = 100
                    Citizen.CreateThread(function()
                        while varusteetPaalla and happi > 0 do
                            Citizen.Wait(Config.OxygenMask.TimeBetweenDecreasingOxygen)
                            happi = happi - 1
                            if happi == 0 then
                                SetPedDiesInWater(PlayerPedId(), true)
                                varusteetPaalla = false
                            end
                        end
                    end)

                    Citizen.CreateThread(function()
                        local coords = GetEntityCoords(playerPed)
                        while varusteetPaalla and happi > 0 do
                            Citizen.Wait(0)
                            text = ("Happisäiliö "..happi.."%")
                            DrawGenericTextThisFrame()

                            SetTextEntry("STRING")
                            AddTextComponentString(text)
                            DrawText(0.200, 0.955)
                        end
                    end)

                end)
            end)
        end
    end)
end)

RegisterNetEvent("esx_cat_diving:happimaskipois")
AddEventHandler("esx_cat_diving:happimaskipois", function()
    if prap and prop then
        exports['progbar']:Progress({
            name = "sukellus_pois",
            duration = Config.DressingUp.Time,
            label = 'Riisutaan happipulloa',
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovementSprint = true,
                disableMovement = false,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "move_f@hiking",
                anim = "idle_intro",
                flags = 49,
            }
        }, function(cancelled)
            if not cancelled then
                DetachEntity(prap)
                DetachEntity(prop)
                SetPedDiesInWater(PlayerPedId(), true)
                varusteetPaalla = false
                prop = nil
                happi = 0
                prap = nil
            end
        end)
    else
        ESX.ShowNotification("Ei mitään mitä ottaa pois!")
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pdx = GetEntityCoords(PlayerPedId())
        if IsPedSwimmingUnderWater(PlayerPedId()) then
            if GetEntityHeightAboveGround(PlayerPedId()) <= 0.7 then
                Texti(pdx.x, pdx.y, pdx.z, "E - Tutkiaksesi")
                if IsControlJustReleased(0, 38) then
                    tutkitaan = true
                    Etsi()
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if tutkitaan then
            local pdx = GetEntityCoords(PlayerPedId())
            Texti(pdx.x, pdx.y, pdx.z, "X - Lopettaaksesi")
            if IsControlJustReleased(0, 105) then
                ClearPedTasksImmediately(PlayerPedId())
                tutkitaan = false
            end
        else
            Citizen.Wait(500)
        end
    end
end)

local inZone = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local pdx = GetEntityCoords(PlayerPedId())

        if Vdist(pdx, Config.Refill.Coords.x, Config.Refill.Coords.y, Config.Refill.Coords.z) < 5 then
            if Vdist(pdx, Config.Refill.Coords.x, Config.Refill.Coords.y, Config.Refill.Coords.z) < 1.2 then
                inZone = true
            else
                inZone = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inZone then
            if Config.Refill.Cost > 0 then
                Texti(Config.Refill.Coords.x, Config.Refill.Coords.y, Config.Refill.Coords.z, "E - Täytä happipullot hintaan $"..Config.Refill.Cost)
            else
                Texti(Config.Refill.Coords.x, Config.Refill.Coords.y, Config.Refill.Coords.z, "E - Täytä happipullot")
            end
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent("esx_cat_diving:refill")
            end
        else
            Citizen.Wait(500)
        end
    end
end)
