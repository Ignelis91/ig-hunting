local ped = PlayerPedId()
local vehicle = cache.vehicle

lib.onCache('ped', function(value) ped = value end)
lib.onCache('vehicle', function(value) vehicle = value end)

SetWeaponDamageModifier(`WEAPON_MUSKET`, 0.35)

function createBlip(coords, name, sprite, color, scale)
	local blip = AddBlipForCoord(coords.xyz)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('<font face=\'Roboto\'>'..name)
    EndTextCommandSetBlipName(blip)
end

local sellingPoint = Config.SellingPoint
createBlip(sellingPoint.xyz, 'Medžiotojas', 124, 1, 0.6)

lib.points.new(sellingPoint.xyz, 100.0, {
    onEnter = function(self)
        if not self.npc then
            ESX.Streaming.RequestModel(`s_m_y_ammucity_01`)
            local npc = CreatePed(4, `s_m_y_ammucity_01`, sellingPoint, false, true)
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            SetModelAsNoLongerNeeded(`s_m_y_ammucity_01`)
            self.npc = npc

            exports.ox_target:addLocalEntity(npc, {
                {
                    name = 'ig-hunting:license',
                    icon = 'fa-solid fa-person-rifle',
                    label = 'Nusipirkti medžiotojo licenziją',
                    distance = 2.0,
                    canInteract = function(entity, distance, coords, name, bone)
                        return not vehicle
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('ig-hunting:buyLicense', function(playAnim)
                            if playAnim then
                                ESX.Streaming.RequestAnimDict('friends@laf@ig_5')
                                TaskPlayAnim(ped, 'friends@laf@ig_5', 'nephew', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('friends@laf@ig_5')
                                ESX.Streaming.RequestAnimDict('gestures@f@standing@casual')
                                TaskPlayAnim(data.entity, 'gestures@f@standing@casual', 'gesture_hand_down', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('gestures@f@standing@casual')
                            end
                        end)
                    end,
                },
                {
                    name = 'ig-hunting:meat',
                    icon = 'fa-solid fa-brain',
                    label = 'Parduoti mėsą',
                    distance = 2.0,
                    canInteract = function(entity, distance, coords, name, bone)
                        return not vehicle
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('ig-hunting:sellItem', function(playAnim)
                            if playAnim then
                                ESX.Streaming.RequestAnimDict('friends@laf@ig_5')
                                TaskPlayAnim(ped, 'friends@laf@ig_5', 'nephew', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('friends@laf@ig_5')
                                ESX.Streaming.RequestAnimDict('gestures@f@standing@casual')
                                TaskPlayAnim(data.entity, 'gestures@f@standing@casual', 'gesture_hand_down', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('gestures@f@standing@casual')
                            end
                        end, 'meat')
                    end,
                },
                {
                    name = 'ig-hunting:pelt',
                    icon = 'fa-solid fa-paw',
                    label = 'Parduoti kailį',
                    distance = 2.0,
                    canInteract = function(entity, distance, coords, name, bone)
                        return not vehicle
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('ig-hunting:sellItem', function(playAnim)
                            if playAnim then
                                ESX.Streaming.RequestAnimDict('friends@laf@ig_5')
                                TaskPlayAnim(ped, 'friends@laf@ig_5', 'nephew', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('friends@laf@ig_5')
                                ESX.Streaming.RequestAnimDict('gestures@f@standing@casual')
                                TaskPlayAnim(data.entity, 'gestures@f@standing@casual', 'gesture_hand_down', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('gestures@f@standing@casual')
                            end
                        end, 'pelt')
                    end,
                },
                {
                    name = 'ig-hunting:horns',
                    icon = 'fa-solid fa-bone',
                    label = 'Parduoti ragus',
                    distance = 2.0,
                    canInteract = function(entity, distance, coords, name, bone)
                        return not vehicle
                    end,
                    onSelect = function(data)
                        ESX.TriggerServerCallback('ig-hunting:sellItem', function(playAnim)
                            if playAnim then
                                ESX.Streaming.RequestAnimDict('friends@laf@ig_5')
                                TaskPlayAnim(ped, 'friends@laf@ig_5', 'nephew', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('friends@laf@ig_5')
                                ESX.Streaming.RequestAnimDict('gestures@f@standing@casual')
                                TaskPlayAnim(data.entity, 'gestures@f@standing@casual', 'gesture_hand_down', 2.0, 2.0, 3000, 16, 0.0, false, false, false)
                                RemoveAnimDict('gestures@f@standing@casual')
                            end
                        end, 'horns')
                    end,
                }
            })
        end
    end,
    onExit = function(self)
        if self.npc then
            exports.ox_target:removeLocalEntity(self.npc, { 'ig-hunting:meat', 'ig-hunting:pelt', 'ig-hunting:horns' })
            DeleteEntity(self.npc)
            self.npc = nil
        end
    end
})

for _, pointCoords in pairs(Config.HuntingZones) do
    createBlip(pointCoords, 'Medžioklė', 141, 31, 0.9)
end

CreateThread(function()
    while true do
        Wait(1000)

        local gamePool = GetGamePool('CPed')
        for _, pointCoords in pairs(Config.HuntingZones) do
            if #(GetEntityCoords(cache.ped) - pointCoords) <= 100.0 then
                ensureDeers(pointCoords, gamePool)
                Wait(100)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        local closestEntity, closestDistance = -1, -1

        if not vehicle then
            local pedCoords = GetEntityCoords(ped)

            for _, entity in pairs(GetGamePool('CPed')) do
                if GetEntityModel(entity) == `a_c_deer` then
                    local distance = #(GetEntityCoords(entity) - pedCoords)
                    if IsEntityDead(entity) then
                        if distance <= 3.0 then
                            if distance < closestDistance or closestDistance == -1 then
                                closestEntity, closestDistance = entity, distance
                            end
                        end
                    elseif distance <= 30.0 then
                        if not GetIsTaskActive(entity, 218) then
                            TaskSmartFleePed(entity, ped, 20.0, 5000, true, true)
                        end
                    end
                end
            end
        end

        closestDeer = closestEntity ~= -1 and closestEntity or nil
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local letSleep = true

        if closestDeer then
            local deerCoords = GetEntityCoords(closestDeer)
            if #(GetEntityCoords(ped) - deerCoords) <= 2.0 then
                letSleep = false
                helpText = '~INPUT_CONTEXT~ Išdarinėti gyvuną'

                if IsControlJustPressed(0, 38) then
                    local currentDeer = closestDeer

                    if GetSelectedPedWeapon(ped) ~= `WEAPON_KNIFE` then
                        ESX.ShowNotification('Norint ~b~išdarinėti~s~ gyvūną, turite ~y~turėti~s~ medžioklinį peilį.', 'info')
                    elseif GetPedCauseOfDeath(currentDeer) ~= `WEAPON_MUSKET` then
                        ESX.ShowNotification('Ši stirna buvo nužudyta netinkamai, kad išdarinėti stirną, ji turi būti nušauta su medžiokliniu šautuvu.', 'error')
                    else
                        local deerNetworkId = NetworkGetNetworkIdFromEntity(currentDeer)

                            isBusy = true

                            local timeout = 1000
                            while not NetworkHasControlOfEntity(currentDeer) and timeout > 0 do
                                NetworkRequestControlOfEntity(currentDeer)
                                timeout = timeout - 50
                                Wait(50)
                            end

                            if not NetworkHasControlOfEntity(currentDeer) then
                                isBusy = false
                                return
                            end

                            local progress = lib.progressCircle({
                                duration = 5000,
                                label = 'Išdarinėjate gyvuną',
                                useWhileDead = false,
                                allowRagdoll = false,
                                allowCuffed = false,
                                allowFalling = false,
                                canCancel = true,
                                anim = { dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 0 },
                                disable = { move = true, combat = true }
                            })

                            if progress then
                                ESX.TriggerServerCallback('ig-hunting:deerItems', function(success)
                                    if success then
                                        DeleteEntity(currentDeer)
                                    end
                                end, deerNetworkId)
                            end

                            closestDeer = nil
                            isBusy = false
                    end
                end
            end
        end

        if letSleep then
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(150)
        if helpText then
            exports['j-textui']:Help(helpText)
            helpText = nil
		end
    end
end)

function ensureDeers(pointCoords, gamePool)
    local spawnedDeers = 0

    for _, entity in pairs(gamePool) do
        if GetEntityModel(entity) == `a_c_deer` then
            local entityCoords = GetEntityCoords(entity)
            if #(entityCoords - pointCoords) <= 100.0 and not IsEntityDead(entity) then
                if not GetIsTaskActive(entity, 221) and not GetIsTaskActive(entity, 218) then
                    TaskWanderStandard(entity, 10.0, 10)
                end

                spawnedDeers = spawnedDeers + 1
            end
        end
    end

    if spawnedDeers >= 4 then
        return
    end

    for i = 1, 4 - spawnedDeers do
        ESX.Streaming.RequestModel(`a_c_deer`)

        local spawnCoords = {
            x = pointCoords.x + math.random(-30, 30),
            y = pointCoords.y + math.random(-30, 30),
            z = pointCoords.z
        }
            
        for i = 1, 100 do
            local foundGround, z = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z, i, false)
    
            if foundGround then
                spawnCoords.z = z
                break
            end
        end

        local spawnCoords = vec(spawnCoords.x, spawnCoords.y, spawnCoords.z)
        local spawnedDeer = CreatePed(28, `a_c_deer`, spawnCoords, math.random(360) + 0.0, true, false)
        
        SetEntityProofs(spawnedDeer, false, false, false, true, true, false, false, false)
        SetPedCanRagdoll(spawnedDeer, false)
        TaskWanderStandard(spawnedDeer, 10.0, 10)
        SetModelAsNoLongerNeeded(`a_c_deer`)
    end
end
