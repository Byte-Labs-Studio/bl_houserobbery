
lib.callback.register('bl_houserobbery:client:getHouseRecording', function(source, id)
    local activeHouse = ActiveHouses[id]
    if not activeHouse then return end

    return activeHouse.record
end)