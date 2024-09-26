local peds = {}
local store = require 'client.module.store'

---@param pedsData Peds[]
function peds.create(pedsData)
    local count = 0
    for i = 1, #pedsData do
        local pedData = pedsData[i]
        local chance = pedData.chance
        if chance > 0 and math.random(100) <= chance then
            local coords = pedData.coords
            local model = pedData.model

            lib.requestModel(model)
            local ped = CreatePed(2, model, coords.x, coords.y, coords.z, coords.w, false, false)
            SetModelAsNoLongerNeeded(model)

            count+=1
            store.currentHouse.peds[count] = ped

            local anim = pedData.anim
            lib.requestAnimDict(anim.dict)
            TaskPlayAnim(ped, anim.dict, anim.name, 1.0, 1.0, -1, 2, 0.0, false, false, false)
            RemoveAnimDict(anim.dict)
        end
    end

end

return peds