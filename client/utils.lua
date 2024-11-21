local utils = {}
local state = LocalPlayer.state
state.holdingHouseObject = false

function utils.spawnLocalObject(model, coords, freeze)
    model = lib.requestModel(model)

    local object = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)

    if coords.w then
        SetEntityHeading(object, coords.w)
    end

    if freeze then
        FreezeEntityPosition(freeze, true)
    end
    SetModelAsNoLongerNeeded(model)
    return object
end
---comment
---@param data {model: number, itemName: string}
function utils.carryObject(data) -- todo: slow person steps depend on item weight / add weight limit, if exeeced it will require 2 person to carry
    local model, itemName = data.model, data.itemName

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    model = lib.requestModel(model)

    local object = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, true, false)
    state:set('holdingHouseObject', ObjToNet(object), true)
    CreateThread(function()
        local carryAnimation = require 'data.config'.carryAnimation
        local inventory = Framework.inventory
        lib.requestAnimDict(carryAnimation.dict)

        while DoesEntityExist(object) do
            local found = false
            for _, v in pairs(inventory.playerItems()) do
                if itemName == v.name and v.amount > 0 then
                    found = true
                end
            end

            if not found then
                state:set('holdingHouseObject', nil, true)
                ClearPedTasks(ped)
                SetEntityAsMissionEntity(object, true, true)
                DeleteEntity(object)
                break
            end
            if not IsEntityPlayingAnim(ped, carryAnimation.dict, carryAnimation.name, 3) then
                TaskPlayAnim(ped, carryAnimation.dict, carryAnimation.name, 8.0, 8.0, -1, 50, 0.0, false, false, false)
            end
            Wait(500)
        end

        RemoveAnimDict(carryAnimation.dict)
    end)

    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 18905), 0.1, -0.05, 0.3, 0.0, 80.0, 100.0, true, true, false, true, 2, true)
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
