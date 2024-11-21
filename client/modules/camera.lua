Camera = {}
local function setCamera(camera, oldCam)
    if oldCam then
        DestroyCam(oldCam, false)
        RenderScriptCams(false, false, 0, 1, 0)
    end
    local coords = camera.coords
    local rot = camera.rotation
    local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x+0.1, coords.y, coords.z, rot.x, rot.y, rot.z, 80.0, true, 2)
    RenderScriptCams(true, false, 0, true, false)
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, -180.0)
    return cam
end

local function stopCamera(cam)
    DestroyCam(cam, false)
    RenderScriptCams(false, false, 0, true, false)
    ClearFocus()
end

RegisterNetEvent('bl_houserobbery:client:openCamera', function(cameras)
    local index, camera = next(cameras)
    local cam = setCamera(camera)
    local debug = require 'data.config'.debug
    local IsControlPressed = IsControlPressed
    local GetCamRot = GetCamRot
    local SetCamRot = SetCamRot
    local Wait = Wait
    local IsControlJustReleased = IsControlJustReleased
    while true do
        Wait(0)
        if debug then
            local rotation = GetCamRot(cam, 2)
            -- Move camera rotation up
            if IsControlPressed(0, 27) then
                SetCamRot(cam, rotation.x + 0.2, rotation.y, rotation.z, 2)
            end
            -- Move camera rotation down
            if IsControlPressed(0, 173) then
                SetCamRot(cam, rotation.x - 0.2, rotation.y, rotation.z, 2)
            end
            -- Move camera rotation left
            if IsControlPressed(0, 174) then
                SetCamRot(cam, rotation.x, rotation.y, rotation.z + 0.2, 2)
            end
            -- Move camera rotation right
            if IsControlPressed(0, 175) then
                SetCamRot(cam, rotation.x + 0.2, rotation.y, rotation.z - 0.2, 2)
            end
    
            if IsControlPressed(0, 175) then
                SetCamRot(cam, rotation.x + 0.2, rotation.y, rotation.z - 0.2, 2)
            end
        end

        if IsControlJustReleased(0, 44) then -- Q
            index, camera = next(cameras, index+1)
            if not camera then
                index, camera = next(cameras, 1)
            end
            cam = setCamera(camera, cam)
        end

        if IsControlJustReleased(0, 26) then
            stopCamera(cam)
            break
        end
    end
end)
