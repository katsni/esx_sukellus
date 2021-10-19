local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

ESX.RegisterUsableItem('happimaski', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_cat_diving:happimaski', source)
	xPlayer.removeInventoryItem('happimaski', 1)
    xPlayer.addInventoryItem('emptymask', 1)
end)

RegisterServerEvent("esx_cat_diving:refill")
AddEventHandler("esx_cat_diving:refill", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Config.Refill.Cost then
        if xPlayer.getInventoryItem("emptymask").count > 0 then
            xPlayer.removeInventoryItem('emptymask', 1)
            xPlayer.addInventoryItem('happimaski', 1)
            xPlayer.removeMoney(Config.Refill.Cost)
            xPlayer.showNotification("Täytit happipullon hintaan $"..Config.Refill.Cost)
        else
            xPlayer.showNotification("Sinulla ei ole pulloja mitä täyttää!")
        end
    else
        xPlayer.showNotification("Sinulla ei ole tarpeeksi käteistä!")
    end
end)

ESX.RegisterServerCallback("esx_cat_diving:reward", function(source, cb)
    
    local player = ESX.GetPlayerFromId(source)
    local luck = math.random(0, 1000)

    if luck >= 0 and luck <= 450 then
        TriggerClientEvent("esx:showNotification", source, "Et löytänyt mitään!")
    elseif luck >= 451 and luck <= 800 then
        player.addInventoryItem("coral", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit korallia!")
    elseif luck >= 801 and luck <= 843 then
        player.addInventoryItem("diamond", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit timantin!")
    elseif luck >= 844 and luck <= 847 then
        player.addInventoryItem("lockpick", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit tiirikan!")
    elseif luck >= 848 and luck <= 851 then
        player.addInventoryItem("bulletproof", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit luotiliivit!")
    elseif luck >= 852 and luck <= 854 then
        player.addInventoryItem("coke_pooch", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit kokaiinipussin!")
    elseif luck >= 855 and luck <= 857 then
        player.addInventoryItem("happimaski", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit happimaskin!")
    elseif luck >= 858 and luck <= 861 then
        player.addInventoryItem("radio", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit radion!")
    elseif luck >= 862 and luck <= 890 then
        player.addInventoryItem("coral", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit korallia!")
    elseif luck >= 891 and luck <= 970 then
        TriggerClientEvent("esx:showNotification", source, "Et löytänyt mitään!")
    elseif luck >= 971 and luck <= 974 then
        player.addInventoryItem("siideri", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit siideri tölkin!")
    elseif luck >= 975 and luck <= 977 then
        player.addInventoryItem("washed_stone", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit kiveä!")
    elseif luck >= 978 and luck <= 982 then
        player.addInventoryItem("suppressor", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit äänenvaimentimen!")
    elseif luck >= 983 and luck <= 984 then
        player.addInventoryItem("drill_bit", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit poran terän!")
    elseif luck >= 985 and luck <= 987 then
        player.addInventoryItem("bandage", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit sideharson!")
    elseif luck >= 988 and luck <= 999 then
        TriggerClientEvent("esx:showNotification", source, "Et löytänyt mitään!")
    elseif luck == 1000 then
        player.addWeapon("WEAPON_VINTAGEPISTOL", 1)
        TriggerClientEvent("esx:showNotification", source, "Löysit vanhan pistoolin!")
    end
end)
