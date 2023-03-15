if Config.QBCore then
    QBCore = exports['qb-core']:GetCoreObject() 
end
local OnStart, OnComplete, OnTimeout, Animation, PropAttach = nil, nil, nil, nil, nil
local prop_net, propTwo_net = false, nil, nil
local Run = false

function clone(object)
    local lookup_table = {}
    local function copy(object) 
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[copy(key)] = copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return copy(object)
end

function MergeConfig(t1, t2)
    local copy = clone(t1)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(copy[k] or false) == "table" then
                MergeConfig(copy[k] or {}, t2[k] or {})
            else
                copy[k] = v
            end
        else
            copy[k] = v
        end
    end
    return copy
end

function LoadAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(1)
        end
    end
end

function Start(text, duration, linear)
    
    local options = MergeConfig(Config, {
        display = true,
        Duration = duration,
        Label = text
    })

    if linear ~= nil then
        options.Type = 'linear'
    end

    options.Async = false

    -- CAN'T SEND FUNCTIONS TO NUI
    options.onStart = nil
    options.onComplete = nil 
    
    OnStart = nil
    OnComplete = nil

    SendNUIMessage(options)

    Run = true

    while Run do
        DisableControls(options)
        Wait(1)
    end
end

function Custom(options)
    if Config.QBCore then
        local PlayerData = QBCore.Functions.GetPlayerData()
        local Controls = {
            disableMovement = Config.DisableControls.disableMovement,
            disableCarMovement = Config.DisableControls.disableCarMovement,
            disableMouse = Config.DisableControls.disableMouse,
            disableCombat = Config.DisableControls.disableCombat,
        }
    
        if options.DisableControls ~= nil then
            Controls = options.DisableControls
        end
        InventoryBusy(true)
    
        options = MergeConfig(Config, options)
    
        options.DisableControls = MergeConfig(Config.DisableControls, Controls)
    
        options.display = true
        
        OnStart = options.onStart
        OnComplete = options.onComplete
        OnTimeout = options.onTimeout
    
        Animation = nil
        if options.Animation ~= nil then
            Animation = options.Animation
        end
    
        PropAttach = nil
        if options.PropAttach ~= nil then
            PropAttach = options.PropAttach
        end
    
        -- CAN'T SEND FUNCTIONS TO NUI
        options.onStart = nil
        options.onComplete = nil
        options.onTimeout = nil
    
        SendNUIMessage(options) 
    
        Run = true
        PlayAnimation(options)
        AttachPropAttach(options)
    
        local cancelKey = Config.CancelKey
    
        if options.cancelKey and tonumber(options.cancelKey) then
            cancelKey = options.cancelKey
        end
    
        if options.Async == false then
            while Run do
    
                local ped = PlayerPedId()
                if options.canCancel then
                    if IsControlJustPressed(0, cancelKey) or IsPedJumping(ped) or IsPedRagdoll(ped) or IsPedClimbing(ped) then
                        InventoryBusy(false)
                        OnComplete(true)
                        TriggerEvent("RadialBar:stop")
                        TriggerEvent("RadialBar:stopred")
                    end
    
                    if PlayerData.metadata['inlaststand'] or PlayerData.metadata['isdead'] or IsPauseMenuActive() then
                        InventoryBusy(false)
                        OnComplete(true)
                        TriggerEvent("RadialBar:stop")
                        TriggerEvent("RadialBar:stopred")
                    end
                end
    
                if options.deadCancel then
                    if PlayerData.metadata['inlaststand'] or PlayerData.metadata['isdead'] then
                        InventoryBusy(false)
                        OnComplete(true)
                        TriggerEvent("RadialBar:stop")
                        TriggerEvent("RadialBar:stopred")
                        print("dead cancel")
                    end
                end
    
                DisableControls(options)
                Wait(1)
            end
    
            StopAnimation()
        else
            CreateThread(function()
                while Run do
                    local ped = PlayerPedId()
                    if options.canCancel then
                        if IsControlJustPressed(0, cancelKey) or IsPedJumping(ped) or IsPedRagdoll(ped) or IsPedClimbing(ped) then
                            InventoryBusy(false)
                            OnComplete(true)
                            TriggerEvent("RadialBar:stop")
                            TriggerEvent("RadialBar:stopred")
                        end
    
                        if PlayerData.metadata['inlaststand'] or PlayerData.metadata['isdead'] or IsPauseMenuActive() then
                            InventoryBusy(false)
                            OnComplete(true)
                            TriggerEvent("RadialBar:stop")
                            TriggerEvent("RadialBar:stopred")
                        end
                    end
    
                    if options.deadCancel then
                        if PlayerData.metadata['inlaststand'] or PlayerData.metadata['isdead'] then
                            InventoryBusy(false)
                            OnComplete(true)
                            TriggerEvent("RadialBar:stop")
                            TriggerEvent("RadialBar:stopred")
                            print("dead cancel")
                        end
                    end
    
                    DisableControls(options)
                    Wait(0)
                end
            end)
        end 
    else
        local Controls = {
            disableMovement = Config.DisableControls.disableMovement,
            disableCarMovement = Config.DisableControls.disableCarMovement,
            disableMouse = Config.DisableControls.disableMouse,
            disableCombat = Config.DisableControls.disableCombat,
        }
    
        if options.DisableControls ~= nil then
            Controls = options.DisableControls
        end
        InventoryBusy(true)
    
        options = MergeConfig(Config, options)
    
        options.DisableControls = MergeConfig(Config.DisableControls, Controls)
    
        options.display = true
        
        OnStart = options.onStart
        OnComplete = options.onComplete
        OnTimeout = options.onTimeout
    
        Animation = nil
        if options.Animation ~= nil then
            Animation = options.Animation
        end
    
        PropAttach = nil
        if options.PropAttach ~= nil then
            PropAttach = options.PropAttach
        end
    
        -- CAN'T SEND FUNCTIONS TO NUI
        options.onStart = nil
        options.onComplete = nil
        options.onTimeout = nil
    
        SendNUIMessage(options) 
    
        Run = true
        PlayAnimation(options)
        AttachPropAttach(options)
    
        local cancelKey = Config.CancelKey
    
        if options.cancelKey and tonumber(options.cancelKey) then
            cancelKey = options.cancelKey
        end
    
        if options.Async == false then
            while Run do
                local ped = PlayerPedId()
                if options.canCancel then
                    if IsControlJustPressed(0, cancelKey) or IsPedJumping(ped) or IsPedRagdoll(ped) or IsPedClimbing(ped) or IsPauseMenuActive() then
                        InventoryBusy(false)
                        OnComplete(true)
                        TriggerEvent("RadialBar:stop")
                        TriggerEvent("RadialBar:stopred")
                    end
                end
    
                if options.deadCancel then
                    if IsEntityDead(ped) then
                        InventoryBusy(false)
                        OnComplete(true)
                        TriggerEvent("RadialBar:stop")
                        TriggerEvent("RadialBar:stopred")
                        print("dead cancel")
                    end
                end
    
                DisableControls(options)
                Wait(1)
            end
    
            StopAnimation()
        else
            CreateThread(function()
                while Run do
                    local ped = PlayerPedId()

                    if options.canCancel then
                        if IsControlJustPressed(0, cancelKey) or IsPedJumping(ped) or IsPedRagdoll(ped) or IsPedClimbing(ped) or IsPauseMenuActive() then
                            InventoryBusy(false)
                            OnComplete(true)
                            TriggerEvent("RadialBar:stop")
                            TriggerEvent("RadialBar:stopred")
                        end
                    end
        
                    if options.deadCancel then
                        if IsEntityDead(ped) then
                            InventoryBusy(false)
                            OnComplete(true)
                            TriggerEvent("RadialBar:stop")
                            TriggerEvent("RadialBar:stopred")
                            print("dead cancel")
                        end
                    end
    
                    DisableControls(options)
                    Wait(0)
                end
            end)
        end
    end  
end

function Linear(text, duration)
    Start(text, duration, true)
end

function Stop()
    SendNUIMessage({
        stop = true
    })
end

function DisableControls(options)

    if options.disableMouse then
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end

    if options.disableMovement then
        DisableControlAction(0, 30, true) -- disable left/right
        DisableControlAction(0, 36, true) -- Left CTRL
        DisableControlAction(0, 31, true) -- disable forward/back
        DisableControlAction(0, 36, true) -- INPUT_DUCK
        DisableControlAction(0, 21, true) -- disable sprint
        DisableControlAction(0, 75, true)  -- Disable exit vehicle
        DisableControlAction(27, 75, true) -- Disable exit vehicle 
    end

    if options.disableCarMovement then
        DisableControlAction(0, 63, true) -- veh turn left
        DisableControlAction(0, 64, true) -- veh turn right
        DisableControlAction(0, 71, true) -- veh forward
        DisableControlAction(0, 72, true) -- veh backwards
        DisableControlAction(0, 75, true) -- disable exit vehicle
    end

    if options.disableCombat then
        DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
        DisableControlAction(0, 24, true) -- disable attack
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(1, 37, true) -- disable weapon select
        DisableControlAction(0, 47, true) -- disable weapon
        DisableControlAction(0, 58, true) -- disable weapon
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
    end
end

function AttachPropAttach()
    if PropAttach ~= nil then
        local player = PlayerPedId()
        if DoesEntityExist(player) and not IsEntityDead(player) then  
            CreateThread(function()
                    if PropAttach.model ~= nil then
                        local ped = PlayerPedId()
                        RequestModel(PropAttach.model)

                        while not HasModelLoaded(GetHashKey(PropAttach.model)) do
                            Wait(0)
                        end

                        local pCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
                        local modelSpawn = CreateObject(GetHashKey(PropAttach.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)
                        print(modelSpawn)
                        local netid = ObjToNet(modelSpawn)
                        SetNetworkIdExistsOnAllMachines(netid, true)
                        NetworkSetNetworkIdDynamic(netid, true)
                        SetNetworkIdCanMigrate(netid, false)
                        if PropAttach.bone == nil then
                            PropAttach.bone = 60309
                        end

                        if PropAttach.coords == nil then
                            PropAttach.coords = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        if PropAttach.rotation == nil then
                            PropAttach.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        AttachEntityToEntity(modelSpawn, ped, GetPedBoneIndex(ped, PropAttach.bone), PropAttach.coords.x, PropAttach.coords.y, PropAttach.coords.z, PropAttach.rotation.x, PropAttach.rotation.y, PropAttach.rotation.z, 1, 1, 0, 1, 0, 1)
                        prop_net = netid

                        if PropAttach.modeltwo ~= nil then
                            RequestModel(PropAttach.modeltwo)
    
                            while not HasModelLoaded(GetHashKey(PropAttach.modeltwo)) do
                                Wait(0)
                            end
    
                            local pCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0)
                            local modelSpawnTwo = CreateObject(GetHashKey(PropAttach.modeltwo), pCoords.x, pCoords.y, pCoords.z, true, true, true)
                            print(modelSpawnTwo)
                            local netidtwo = ObjToNet(modelSpawnTwo)
                            SetNetworkIdExistsOnAllMachines(netidtwo, true)
                            NetworkSetNetworkIdDynamic(netidtwo, true)
                            SetNetworkIdCanMigrate(netidtwo, false)
                            if PropAttach.bonetwo == nil then
                                PropAttach.bonetwo = 60309
                            end
    
                            if PropAttach.coordstwo == nil then
                                PropAttach.coordstwo = { x = 0.0, y = 0.0, z = 0.0 }
                            end
    
                            if PropAttach.rotationtwo == nil then
                                PropAttach.rotationtwo = { x = 0.0, y = 0.0, z = 0.0 }
                            end
                            AttachEntityToEntity(modelSpawnTwo, ped, GetPedBoneIndex(ped, PropAttach.bonetwo), PropAttach.coordstwo.x, PropAttach.coordstwo.y, PropAttach.coordstwo.z, PropAttach.rotationtwo.x, PropAttach.rotationtwo.y, PropAttach.rotationtwo.z, 1, 1, 0, 1, 0, 1)
                            propTwo_net = netidtwo
    
                            
                        end
                    end
            end)
        end
    end 
end

function PlayAnimation()
    if Animation ~= nil then
        local player = PlayerPedId()
        if DoesEntityExist(player) and not IsEntityDead(player) then  
            Citizen.CreateThread(function()
                if Animation.task ~= nil then
                    TaskStartScenarioInPlace(player, Animation.task, 0, true)
                else
                    if Animation.animDict ~= nil and Animation.anim ~= nil then
                        
                        if Animation.flag == nil then
                            Animation.flag = 1
                        end

                        RequestAnimDict( Animation.animDict )
                        while not HasAnimDictLoaded( Animation.animDict ) do
                            Wait(1)
                        end
                        TaskPlayAnim( player, Animation.animDict, Animation.anim, 3.0, 1.0, -1, Animation.flag, 0, 0, 0, 0 )
                    end
                end
            end)
        end
    end 
end

function StopAnimation()
    if Animation ~= nil then
        local player = PlayerPedId()
        if DoesEntityExist( player ) and not IsEntityDead( player ) then
            if Animation.task ~= nil then
                ClearPedTasks(player)
            else
                if Animation.animDict ~= nil and Animation.anim ~= nil then
                    StopAnimTask(player, Animation.animDict, Animation.anim, 1.0)
                end
            end
        end
    end

    if prop_net then
        DetachEntity(NetToObj(prop_net), 1, 1)
        DeleteEntity(NetToObj(prop_net))
    end
    if propTwo_net then
        DetachEntity(NetToObj(propTwo_net), 1, 1)
        DeleteEntity(NetToObj(propTwo_net))
    end
    prop_net = nil
    propTwo_net = nil
    ClearPedTasks(PlayerPedId())
end

function Reset()
    Run = false

    SetNuiFocus(false, false)    
end

Reset()

RegisterNUICallback('progress_start', function(data, cb)
    if OnStart ~= nil then
        OnStart()
    end

    cb('ok')
end)

RegisterNUICallback('progress_complete', function(data, cb)
    Reset()

    if OnComplete ~= nil then
        OnComplete()
        StopAnimation()
    end
    
    InventoryBusy(false)
    cb('ok')
end)

RegisterNUICallback('progress_stop', function(data, cb)
    Reset()

    StopAnimation()

    cb('ok')
end)

RegisterNetEvent("RadialBar:start")
RegisterNetEvent("RadialBar:stop")
RegisterNetEvent("RadialBar:custom")
RegisterNetEvent("RadialBar:linear")
RegisterNetEvent("RadialBar:stopred")

AddEventHandler("RadialBar:start", Start)
AddEventHandler("RadialBar:stop", Stop)
AddEventHandler("RadialBar:custom", function(options)
    options.Async = false
    options.onStart = nil
    options.onComplete = nil

    Custom(options)
end)

AddEventHandler("RadialBar:stopred", function()
    Custom({
        Async = false,
        Duration = 500, 
        Label = "Interupted..",
        Color = "rgba(224, 53, 40, 0.5)",
        BGColor = "rgba(224, 53, 40, 1.0)",
        DisableControls = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        },    
    })
end)
AddEventHandler("RadialBar:linear", Linear)


exports('Start', Start)
exports('Custom', Custom)
exports('Stop', Stop)
exports('Linear', Linear)
