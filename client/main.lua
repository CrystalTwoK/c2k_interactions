local QBCore = exports['qb-core']:GetCoreObject()

local Markers = {}
local JobMarkers = {}

local PlayerPed = 0
local PlayerPosition = {}

local InteractionKey = Config.Button

local PlayerData = {}

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobData)
    PlayerData.job = JobData
end)


RegisterNetEvent('c2k_interactions:client:registerMarker', function(marker)

    if marker.id == nil then return print('Marker impossibile da creare! --- ID = NIL -------') end

    if marker.action == nil then return print('Marker impossibile da creare! --- ACTION = NIL -------') end

    if marker.pos == nil then return print('Marker impossibile da creare! --- POS = NIL -------') end

    if marker.label == nil then return print('MARKER '..marker.id..' NON REGISTRATO. LABEL INESISTENTE') end

    if marker.img == nil then marker.img = "https://i.imgur.com/CInzFzP.png" end

    if marker.scale == nil then marker.scale = vector3(1.0, 1.0, 1.0) end

    if marker.interactionDistance == nil then marker.interactionDistance = 1.5 end

    if marker.type == nil then marker.type = 'horde_default' end

    if doesMarkerExist(marker) then
        Markers[marker.id] = marker 
        print('MARKER '..marker.id.." TROVATO - SOSTITUZIONE EFFETTUATA CON SUCCESSO")
    else
        if marker then table.insert(Markers, marker) else return print('Marker impossibile da creare! -----------------') end
    end

    if Config.Debug then print(json.encode(Markers)) end
end)

RegisterNetEvent('c2k_interactions:client:deleteMarker', function(markerID)
    for k,marker in ipairs(Markers) do
        if marker.id == markerID then
            table.remove(Markers, k)
            TriggerEvent('c2k_interactions:client:hideNotify', markerID)
            break;
        end
    end

    return;
end)

local timer = 0

Citizen.CreateThread(function()
    while true do
        Wait(timer)

        for i = 1, #Markers do
            local marker = Markers[i]
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), marker.pos, true) <= Config.MarkerDrawDistance then
                if marker.job == nil then
                    DrawMarker(9, marker.pos.x, marker.pos.y, marker.pos.z -0.25, 0.0, 0.0, 0.0, 90.0, 0.0, 00.0, marker.scale.x, marker.scale.y, marker.scale.z, 255, 255, 255, 255, false, false, 2, true, "horde_markers", marker.type, false)
                elseif marker.job.name then
                    if PlayerData.job.name == marker.job.name then
                        if marker.job.grade ~= nil then
                            for idx = 1, #marker.job.grade do
                                if PlayerData.job.grade.level == marker.job.grade[idx] then
                                    DrawMarker(9, marker.pos.x, marker.pos.y, marker.pos.z -0.25, 0.0, 0.0, 0.0, 90.0, 0.0, 00.0, marker.scale.x, marker.scale.y, marker.scale.z, 255, 255, 255, 255, false, false, 2, true, "horde_markers", marker.type, false)
                                end
                            end
                        else
                            DrawMarker(9, marker.pos.x, marker.pos.y, marker.pos.z -0.25, 0.0, 0.0, 0.0, 90.0, 0.0, 00.0, marker.scale.x, marker.scale.y, marker.scale.z, 255, 255, 255, 255, false, false, 2, true, "horde_markers", marker.type, false)
                        end
                    end
                end
            end

            if marker.job == nil then
                showNotification(marker)
            elseif marker.job.name then
                if PlayerData.job.name == marker.job.name then
                    if marker.job.grade ~= nil then
                        for idx = 1, #marker.job.grade do
                            if PlayerData.job.grade.level == marker.job.grade[idx] then
                                showNotification(marker)
                            end
                        end
                    elseif marker.job.grade == nil then
                        showNotification(marker)
                    end
                end
            end

            if marker.canInteract then
                if IsControlJustPressed(0, Keys[InteractionKey]) then
                    marker.action(marker)
                    if Config.Debug then print('ACTION TRIGGERED') end
                end
            end

        end
    end
end)

function showNotification(marker)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), marker.pos, true) <= marker.interactionDistance then
        if marker.canInteract == false then
            marker.canInteract = true 
            marker.notification = true
            TriggerEvent('c2k_interactions:client:showNotify', marker)
            if Config.Debug then print('inside show notify') end
        end
    else 
        marker.canInteract = false 
        if marker.notification then
            marker.notification = false
            TriggerEvent('c2k_interactions:client:hideNotify')
            if Config.Debug then print('inside hide notify') end
        end
    end
end

function getCloserMarker()
    local ped = PlayerPedId()

    local closerDistanceMarker = {}
    local closerDistance = 0

    if #Markers == 0 then return false end

    for idx, marker in pairs(Markers) do
        local pedCoords = GetEntityCoords(ped)
        if idx == 1 then
            closerDistanceMarker = marker
            closerDistance = #(pedCoords - marker.pos)
        elseif idx > 1 then
            if #(pedCoords - marker.pos) <= closerDistance then
                closerDistance = #(pedCoords - marker.pos)
                closerDistanceMarker = marker
            end
        end
    end

    return closerDistanceMarker, closerDistance
end

exports('getCloserMarker', getCloserMarker)

function doesMarkerExist(marker)
    for idx, m in pairs(Markers) do
        if marker.id == m.id then return true end
    end
    
    return false
end