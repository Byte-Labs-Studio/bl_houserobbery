local utils = {}

function utils.spawnLocalObject(model, coords)
    model = lib.requestModel(model)

    local object = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)

    if coords.w then
        SetEntityHeading(object, coords.w)
    end
    SetModelAsNoLongerNeeded(model)
    return object
end

function utils.playAnim(data)
    local dict, name = data.dict, data.name
    local ped = cache.ped
    lib.requestAnimDict(dict)

    TaskPlayAnim(ped, dict, name, 1.0, 1.0, data.duration, 16, 0.0, false, false, false)

    RemoveAnimDict(dict)

    Wait(500)
    while IsEntityPlayingAnim(ped, dict, name, 3) do
        Wait(100)
    end
    ClearPedTasks(ped)
end


utils.takeObjectControl = lib.addKeybind({
    name = 'housing_robbery_thief',
    disabled = true,
    description = 'press E to take housing objects',
    defaultKey = 'E',
})

return utils