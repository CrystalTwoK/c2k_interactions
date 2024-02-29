local QBCore = exports['qb-core']:GetCoreObject();

RegisterNetEvent('c2k_interactions:server:deleteMarker', function(target, markerID)
    if Config.Debug then print('SERVER TRIGGER EVENT RECEIVED') end
    TriggerClientEvent('c2k_interactions:client:deleteMarker', target, markerID)
end)