local store = require 'client.module.store'
local currentHouse = store.currentHouse
local utils = require 'client.utils'

return function(coords)
    local ghostData = require 'data.ghosts'

    local ghost = utils.spawnLocalObject(ghostData.models[math.random(#ghostData.models)], coords)
    currentHouse.objects[#currentHouse.objects + 1] = ghost
    SetEntityCollision(ghost, false, false)
    SetEntityHeading(ghost, coords.w-180.0)

    local anim = ghostData.anim
    lib.requestAnimDict(anim.dict)
    PlayEntityAnim(ghost, anim.name, anim.dict, 1000.0, true, true, true, 0, 136704)
    RemoveAnimDict(anim.dict)

    local ptfx = ghostData.ptfx
    lib.requestNamedPtfxAsset(ptfx.name)
    UseParticleFxAsset(ptfx.name)
    local ptfxId = StartParticleFxLoopedOnEntity(ptfx.effect, ghost, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 1.0, false, false, false)

    currentHouse.ptfx[#currentHouse.ptfx + 1] = ptfxId
    SetParticleFxLoopedEvolution(ptfxId, 'smoke', 10.0, true)
    RemoveNamedPtfxAsset(ptfx.name)
end