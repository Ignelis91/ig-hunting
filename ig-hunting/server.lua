local Lytis = nil
ESX.RegisterServerCallback("ig-hunting:buyLicense", function(source, cb)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()
        if money >= 2000 then
            if xPlayer.get("sex") == 'm' then Lytis = 'Vyras' elseif xPlayer.get("sex") == 'f' then Lytis = 'Moteris' end
                local desc = "  \nVardas: " .. xPlayer.getName() .. "  \nLytis: " .. Lytis  .. "   \nGimimo Metai: " .. xPlayer.get("dateofbirth")
                xPlayer.removeMoney(2000)
                exports.ox_inventory:AddItem(source, 'hunting_license', 1, {description = desc})
                TriggerClientEvent('esx:showNotification', source, "Sekmingai Nusipirkote")
                cb(true)
        else 
            TriggerClientEvent('esx:showNotification', source, "Jums Nepakanka Pinigu")
    end
end)

ESX.RegisterServerCallback("ig-hunting:sellItem", function(source, cb, item)
    local itemas = exports.ox_inventory:GetItem(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
        if itemas and itemas.count > 0 then
        exports.ox_inventory:RemoveItem(source, itemas, itemas.count)
        xPlayer.addAccountMoney('money', Config.ItemPrices[item] * itemas.count)
        cb(true)
    end
end)

ESX.RegisterServerCallback("ig-hunting:deerItems", function(source, cb)
    local meatcount = math.random(1, 5)
    local hornsCount = math.random(1, 4)
    local canCarry = exports.ox_inventory:CanCarryAmount(source, 'meat')
    local pelt = exports.ox_inventory:CanCarryAmount(source, 'pelt')
    local canCarryHorns = exports.ox_inventory:CanCarryAmount(source, 'horns')

        if canCarry >= meatcount then
         if pelt >= 1 then
            if canCarryHorns >= hornsCount then
                exports.ox_inventory:AddItem(source, 'pelt', 1)
                exports.ox_inventory:AddItem(source, 'meat', meatcount)
                exports.ox_inventory:AddItem(source, 'horns', hornsCount)
                cb(true)
                    end
            end
    end
end)
