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

Camera.setCamera = setCamera
Camera.stopCamera = stopCamera