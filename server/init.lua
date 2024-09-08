
RegisterCommand('enterhouse', function(src)
    local house = lib.callback.await('bl_houserobbery:client:checkNearbyHouse', src)
    if not house then return end


    local interiors = require 'data.interiors'
    local interior = interiors[house.interior or interiors.default]
    
end, false)