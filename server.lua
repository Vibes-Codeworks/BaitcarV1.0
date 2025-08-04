local baitCars = {}

RegisterNetEvent('baitcar:setBait')
AddEventHandler('baitcar:setBait', function(netId)
    local src = source 
    baitCars[netId] = { PlantedBy = src }
    print('Stored bait car with NetID:', netId)
end)
RegisterCommand('baitmenu', function(source, args, rawCommand)
    local src = source
    local netId = tonumber(args[1])

    if IsPlayerPolice(src) and baitCars[netId] then 
        TriggerClientEvent('baitcar:menu', source, netId)
    else
        print('[BaitCar] You do not have access to this menu')
    end

end)

RegisterCommand('activatebait', function(source, args, rawCommand)
    local netId = tonumber(args[1])
    if baitCars[netId] then 
        TriggerClientEvent('baitcar:activateBait', source, netId)
        print('Bait car',netID,'triggered')
    else
        print('No bait car found with NetID:', netId)
    end
end)

RegisterCommand('stopcar', function(source, args, rawCommand)
        local netId = tonumber(args[1])
    if baitCars[netId] then 
        TriggerClientEvent('baitcar:freezecar', source, netId)
    else
       print('No bait car found with NetID:', netId)
    end
end)

RegisterCommand('lockbait', function(source, args, rawCommand)
        local netId = tonumber(args[1])
        if baitCars[netId] then  
            TriggerClientEvent('baitcar:lockdoors', source, netId)
        else
            print('No bait car found with NetID:', netId)
        end
end)

RegisterCommand('resetbait', function(source, args, rawCommand)
    local netId = tonumber(args[1])
    if baitCars[netId] then 
        TriggerClientEvent('baitcar:reset', source, netId)
    else
        print('No bait car found with NetID:', netId)
    end
end)

RegisterCommand('removebait', function(source, args, rawCommand)
    local netId = tonumber(args[1])
    --local license = GetPlayerIdentifierByType(source, 'license')
    if baitCars[netId] and IsPlayerPolice(source) then 
        baitCars[netId] = nil
        print('Removed bait car with NetId:', netId)
    else
        print('No bait car found or not authorized')
    end
end)

RegisterCommand('checkbait', function(source)
    --local license = GetPlayerIdentifierByType(source,'license')
    
    if IsPlayerPolice(source) then 
        print(tostring(baitCars))
    end
end)

RegisterNetEvent('baitcar:checkPermission')
AddEventHandler('baitcar:checkPermission', function()
    local playerId = source
    local isPolice = IsPlayerPolice(playerId)
    --print('checkpermission event fired server side') -- this prints 
    TriggerClientEvent('baitcar:checkPermissionResponse', playerId, isPolice)
    --print('server triggerd perm response')
    --print(isPolice)
end)


function IsPlayerPolice(playerId)
    local license = GetPlayerIdentifierByType(playerId, 'license')
    --print(license) --this prints  

    for _, id in ipairs(Config.Police) do
        if id == license then 
            --print("match found")
            return true
        end
    end
    
    return false

end