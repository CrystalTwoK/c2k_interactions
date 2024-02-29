RegisterNetEvent('c2k_interactions:client:showNotify', function(data)
    SendNUIMessage{
        type = "showNotify",
        label = data.label,
        img = data.img,
        button = Config.Button,
    }
end)

RegisterNetEvent('c2k_interactions:client:hideNotify', function()
    SendNUIMessage{
        type = "hideNotify"
    }
end)