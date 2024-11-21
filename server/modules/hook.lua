local hooks = {}

---comment
---@param hookType 'playerEnter' | 'playerExit'
---@param func function
local function registerHouseHook(hookType, func)
    hooks[hookType] = func
end

exports('registerHouseHook', registerHouseHook)

---@param hookType 'playerEnter' | 'playerExit'
function TriggerHouseHook(hookType, source, payLoad)
    local func = hooks[hookType]
    if func then
        local success, result = pcall(func, source, payLoad)
        return not (success and not result)
    end
end