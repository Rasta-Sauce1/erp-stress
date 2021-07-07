---= erp-framework =---
local debug = Config.debug
local resourceName = GetCurrentResourceName()
local speeding = 0
local mph = 2.236936
local isInVehicle = false
local walkTimer = 0

--= verify debug =--
Citizen.CreateThread(function()
    local shown = false
    Citizen.Wait(0)
    if debug and not shown then
        Citizen.Wait(5500)
        print('erp-stress debug enabled')
    end
end)

--= add stress for shooting =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local shooting = IsPedShooting(ped)
        local cooldown = Config.shootingCooldown * 1000
        local stress = Config.shootingStress        
        if shooting and Config.shootingAddsStress then
            TriggerEvent('esx_status:add', 'stress', (stress * 10000))            
            if debug then
                print(stress .. ' stress given for shooting by ' .. resourceName)
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {
                        'erp-stress debug: ',
                        'stress added for shooting'
                    }
                })
            end
            Citizen.Wait(cooldown)
        end
    end
end)

--= add stress for fighting
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local fighting = IsPedInMeleeCombat(ped)
        local stress = Config.fightingStress
        local cooldown = Config.fightingCooldown * 1000

        if Config.fightingAddsStress and fighting then
            TriggerEvent('esx_status:add', 'stress', stress * 10000)
            if debug then
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'erp-stress debug ', stress .. ' stress added for fighting '}
                })
            end
            Citizen.Wait(cooldown)
        end
    end
end)

--= add stress for being stunned =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local stunned = IsPedBeingStunned(ped, 0)
        local stress = Config.stunnedStress
        local cooldown = Config.stunnedCooldown * 1000

        if stunned and Config.beingStunnedAddsStress then
            TriggerEvent('esx_status:add', 'stress', stress * 10000)
            if debug then
                TriggerEvent('chat:addMessage', {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'erp-needs debug', stress .. ' stress added for getting stunned', ' '}                    
                })
            end
            Citizen.Wait(cooldown)
        end
    end
end)

--= add stress for speeding =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local stress = Config.speedingStress
        local cooldown = Config.speedingCooldown * 1000
        
        if Config.speedingAddsStress then

            if speeding == 1 then
                TriggerEvent('esx_status:add', 'stress', stress * 10000)

                if debug then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0 ,0},
                        multiline = true,
                        args = {'erp-stress debug ', stress .. ' stress given for speeding: ' .. speeding}
                    })
                end
                Citizen.Wait(cooldown)

            elseif speeding == 2 then
                TriggerEvent('esx_status:add', 'stress', stress * 10000 * 1.5)

                if debug then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0 ,0},
                        multiline = true,
                        args = {'erp-stress debug ', stress * 1.5 .. ' stress given for speeding: ' .. speeding}
                    })
                end
                Citizen.Wait(cooldown)

            elseif speeding == 3 then
                TriggerEvent('esx_status:add', 'stress', stress * 10000 * 2)

                if debug then
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0 ,0},
                        multiline = true,
                        args = {'erp-stress debug ', stress * 2 .. ' stress given for speeding: ' .. speeding}
                    })
                end
                Citizen.Wait(cooldown)

            end
        end
    end
end)

--= remove stress for swimming =--

--= remove stress for walking =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local walking = IsPedWalking(ped)
        local stress = Config.walkingStress
        local cooldown = Config.walkingCooldown * 1000        

        if Config.walkingRemovesStress then
            if not isInVehicle then
                if walking and walkTimer > 5 then
                    TriggerEvent('esx_status:remove', 'stress', stress * 10000)

                    if debug then
                        TriggerEvent('chat:addMessage', {
                            color = {255, 0, 0},
                            multiline = true,
                            args = {'erp-stress debug ', stress .. ' stress removed for walking'}
                        })
                    end
                    Citizen.Wait(cooldown)
                end
            end        
        end        
    end
end)

--= speeding =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local speed = GetEntitySpeed(veh) * mph

        if not isInVehicle then
            speeding = 0
        end

        if isInVehicle then
            if speed < 100 then
                speeding = 0
            elseif speed >= 100 and speed < 150 then
                speeding = 1
            elseif speed >=150 and speed < 200 then
                speeding = 2
            elseif speed > 200 then
                speeding = 3
            else
                speeding = 0
            end
        end
        
        -- if debug then
        --     if isInVehicle then
        --         TriggerEvent('chat:addMessage', {
        --             color = {255, 0, 0},
        --             multiline = true,
        --             args = {
        --                 'erp-stress',
        --                 'speeding: ' .. speeding .. ' speed: ' .. speed
        --             }
        --         })
        --         Citizen.Wait(5000)
        --     end        
    end
end)

--= walkTimer =--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local isInVehicle = IsPedInAnyVehicle(ped, false)
        local walking = IsPedWalking(ped)

        if not isInVehicle and walking then
            walkTimer = walkTimer + 1
        else
            walkTimer = 0
        end
        Citizen.Wait(1000)
    end
end)

