local loaded = false
local timer = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(timer)
        if not HasStreamedTextureDictLoaded("horde_markers") then
            RequestStreamedTextureDict("horde_markers", true)
            while not HasStreamedTextureDictLoaded("horde_markers") do
                Wait(1)
            end
        end
    end
end)