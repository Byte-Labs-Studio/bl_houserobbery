local bl_sprites = exports.bl_sprites
local currentHouse = {
    exitTarget = nil,
    id = 0,
    coords = nil,
    objects = {},
    ptfx = {},
    targets = {},
    sprites = {},
    peds = {},
}

local function addSprite(entity)
    local id = #currentHouse.sprites + 1
    currentHouse.sprites[id] = bl_sprites:spriteOnEntity({
        entity = entity,
        data = id,
        distance = 1.5,
        shape = 'circle',
        scale = 0.025,
        key = 'E',
    })
end

local function removeSprite(sprite, index)
    sprite = sprite or currentHouse.sprites[index]
    if not sprite then return end

    SetEntityAsMissionEntity(sprite.entity, true, true)
    DeleteObject(sprite.entity)
    sprite:removeSprite()

    if sprite then return end
    table.remove(currentHouse.sprites, index)
end

local function removeSprites()
    for _, sprite in ipairs(currentHouse.sprites) do
        removeSprite(sprite)
    end
    currentHouse.sprites = {}
end

local function findModel(model)
    for k,v in ipairs(currentHouse.objects) do
        if GetEntityModel(v) == model then
            return v
        end
    end
end

local function resetCurrentHouse()
    local target = Framework.target
    local exitTarget = currentHouse.exitTarget
    if exitTarget then
        target.removeZone(exitTarget)
    end

    for _,v in ipairs(currentHouse.ptfx) do
        StopParticleFxLooped(v, true)
    end

    for _, entityId in ipairs(currentHouse.objects) do
        target.removeLocalEntity(entityId)
        SetEntityAsMissionEntity(entityId, true, true)
        DeleteObject(entityId)
    end

    for _, entityId in ipairs(currentHouse.peds) do
        SetEntityAsMissionEntity(entityId, true, true)
        DeletePed(entityId)
    end

    removeSprites()

    currentHouse = {
        exitTarget = nil,
        id = 0,
        coords = nil,
        objects = {},
        ptfx = {},
        targets = {},
        sprites = {},
        peds = {},
    }
end

return {
    currentHouse = currentHouse,
    addSprite = addSprite,
    removeSprites = removeSprites,
    removeSprite = removeSprite,
    findModel = findModel,
    resetCurrentHouse = resetCurrentHouse
}