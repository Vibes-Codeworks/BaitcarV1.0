local trapActive = false
local triggered = false
local targetBaitCar = nil
local baitCarBlip = {}
local policeCallback = nil

RegisterNetEvent('baitcar:menu')
AddEventHandler('baitcar:menu', function(netId)
    targetBaitCar = netId
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'showMenu' })
end)

-- close on ESC
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)

-- handle menu action
RegisterNUICallback('baitcarAction', function(data, cb)
    local action = data.action
    -- 🔹 Trigger events based on button
    if action == 'activate' then
        TriggerEvent('baitcar:activateBait')
    elseif action == 'lock' then
        TriggerEvent('baitcar:lockdoors')
    elseif action == 'alarm' then
        TriggerEvent('baitcar:alarm')
    elseif action == 'stop' then
        TriggerEvent('baitcar:stopcar')
    elseif action == 'reset' then
        TriggerEvent('baitcar:reset')
    elseif action == 'close' then 
        SetNuiFocus(false,false)
        SendNUIMessage({type = 'hideMenu'})
        targetBaitCar = nil
    end
    cb({})
end)


-- optional: ESC to close UI
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 322) then -- ESC key
            SetNuiFocus(false, false)
            SendNUIMessage({ type = 'hideMenu' })
            
        end
    end
end)


RegisterNetEvent('baitcar:checkPermissionResponse')
AddEventHandler('baitcar:checkPermissionResponse', function(isPolice)
    --print('server responded to client')
    if policeCallback then 
        policeCallback(isPolice)
        policeCallback = nil
    end
    --print('this should be nil:', policeCallback)
end)
function CheckIfPolice(callback)
    --print('callbacktriggered')
    policeCallback = callback
    --print("Callback is:", callback) --this prints 
    TriggerServerEvent('baitcar:checkPermission')
    --print('servereventshould be triggered')-- this prints now 
end

RegisterCommand('baitcar',function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    CheckIfPolice(function(hasPermission)

        if hasPermission and vehicle ~= 0 then 
            local netId = NetworkGetNetworkIdFromEntity(vehicle)

            --send it to the server side
            TriggerServerEvent('baitcar:setBait', netId)

            print('Bait car set! Net ID is: '.. netId)
        else
            print("You're not in a vehicle!")
        end
    end)
end)

function activateGps(baitCar)
    local netId = NetworkGetNetworkIdFromEntity(baitCar)
     if DoesEntityExist(baitCar) then 
        triggerd = true
        local blip = AddBlipForEntity(baitCar)
        baitCarBlip[netId] = blip
        SetBlipSprite(blip, 225) --blip icon
        SetBlipColour(blip, 1) --red
        SetBlipScale(blip, 0.85)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)
    end
end

function activateAlarm(baitCar)
    local alarmtime = Config.AlarmTime

    if DoesEntityExist(baitCar) then
        SetVehicleAlarm(baitCar, true)
        SetVehicleAlarmTimeLeft(baitCar, alarmtime)
    end
end

function lockDoors(baitCar)
    if DoesEntityExist(baitCar) then
        trapActive = true
        SetVehicleDoorsLocked(baitCar, 4)
        while trapActive do 
            DisableControlAction(0, 75, true) --block 'F'
            Wait(0)
        end
    else
        print('doors failed to lock')
    end
end

function setTargetBait(netId)
    if DoesEntityExist(netId) then 
        targetBaitCar = netId
    end
end

RegisterNetEvent('baitcar:activateBait')
AddEventHandler('baitcar:activateBait', function()
       
    local baitCar = NetworkGetEntityFromNetworkId(targetBaitCar)
    
    if DoesEntityExist(baitCar) then
        activateGps(baitCar)
            
        --[[triggered = true

        baitCarBlip = AddBlipForEntity(baitcar)
        SetBlipSprite(blip, 225) --optional: pick custom icon
        SetBlipColour(blip,1)  --red
        SetBlipScale(blip, 0.85)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Bait Car')
        EndTextCommandSetBlipName(blip)

        SetVehicleAlarm(baitcar, true)
        SetVehicleAlarmTimeLeft(baitcar, alarmtime)]]
        
        
    else
        print('[BaitCar] Could not find entity from NetID:' .. tostring(netId))
    end
end)

RegisterNetEvent('baitcar:lockdoors')
AddEventHandler('baitcar:lockdoors', function()
    local baitCar = NetworkGetEntityFromNetworkId(targetBaitCar)
    

    if DoesEntityExist(baitCar) then 
        lockDoors(baitCar)
        --[[trapActive = true
        SetVehicleDoorsLocked(baitCar, 4)
        while trapActive do 
            DisableControlAction(0, 75, true) --block 'F' / exit
            Wait(0)
        end]]
    else
        print('no bait car with netId'.. tostring(netId))
    end
end)

RegisterNetEvent('baitcar:alarm')
AddEventHandler('baitcar:alarm', function()
    local baitCar = NetworkGetEntityFromNetworkId(targetBaitCar)

    if DoesEntityExist(baitCar) then 
        activateAlarm(baitCar)
    else
        print('[BaitCar] Could not find entity from NetID:' .. tostring(netId))
    end

end)

RegisterNetEvent('baitcar:stopcar')
AddEventHandler('baitcar:stopcar', function()
    local baitCar = NetworkGetEntityFromNetworkId(targetBaitCar)
    if DoesEntityExist(baitCar) then 
        SetVehicleEngineOn(baitCar, false, true, true)
        SetVehicleUndriveable(baitCar, true)

        Citizen.CreateThread(function()
            local currentSpeed = GetEntitySpeed(baitCar)
            while currentSpeed > 0.1 do 
                currentSpeed = currentSpeed - 0.5 -- reduce speed gradually
                if currentSpeed < 0 then currentSpeed = 0 end
                SetVehicleForwardSpeed(baitCar, currentSpeed)
                Citizen.Wait(50)
            end
            print(currentSpeed)
            FreezeEntityPosition(baitCar, true)
        end)
    else
        print('No Bait car with netID' .. tostring(netId))
    end
end)

RegisterNetEvent('baitcar:reset')
AddEventHandler('baitcar:reset', function()
    local netId = targetBaitCar
    local baitCar = NetworkGetEntityFromNetworkId(targetBaitCar)
    if DoesEntityExist(baitCar) then
        if baitCarBlip[netId] then 
            RemoveBlip(baitCarBlip[netId])
            baitCarBlip[netId] = nil
        end

        SetVehicleUndriveable(baitCar, false) 
        FreezeEntityPosition(baitCar, false)
        SetVehicleDoorsLocked(baitCar, 0)
        SetVehicleAlarm(baitcar, false)

        trapActive = false
        triggered = false
    else
        print('[BaitCar] Could not find entity from NetID:' .. tostring(netId))
    end
end)

