local utils = {}

function utils.spawnLocalObject(model, coords)
    model = lib.requestModel(model)

    local object = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)

    SetEntityHeading(object, coords.w)
    SetModelAsNoLongerNeeded(model)
    return object
end

function utils.playAnim(data)
    local dict, name = data.dict, data.name
    lib.requestAnimDict(dict)

    TaskPlayAnim(cache.ped, dict, name, 1.0, 1.0, data.duration, 16, 1.0, false, false, false)
end

return utils