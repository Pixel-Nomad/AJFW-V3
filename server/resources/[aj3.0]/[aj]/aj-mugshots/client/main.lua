for i=1, #Config.data do
    Config.Mugshots[i] = Config.data[i]
    Config.Mugshots[i].target.targetoptions.options[1].event = "aj-mugshots:client:takemugshot"
    Config.Mugshots[i].target.targetoptions.options[1].type = "client"
    Config.Mugshots[i].target.targetoptions.options[1].index = i
    if Config.Debug then
        print("index: "..i.." for "..Config.Mugshots[i].BoardHeader)
    end
end

local AJFW = exports['aj-base']:GetCoreObject()

local mugshotInProgress = false
local createdCamera = 0
local MugshotArray = {}
local PlayerData = {}
local Cache = {}
local board_scaleform = nil
local pedc = vector3(0,0,0)
local board = nil
local overlay = nil
local handle = nil

local function LoadScaleform (scaleform)
	local handle = RequestScaleformMovie(scaleform)
	if handle ~= 0 then
		while not HasScaleformMovieLoaded(handle) do
			Wait(0)
		end
	end
	return handle
end

local function CreateNamedRenderTargetForModel(name, model)
	local handle = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end
	return handle
end

local function PrepBoard()
    CreateThread(function()
        board_scaleform = LoadScaleform("mugshot_board_01")
        handle = CreateNamedRenderTargetForModel("ID_Text", `prop_police_id_text`)
        while handle do
            HideHudAndRadarThisFrame()
            SetTextRenderId(handle)
            Set_2dLayer(4)
            SetScriptGfxDrawBehindPausemenu(1)
            DrawScaleformMovie(board_scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
            SetScriptGfxDrawBehindPausemenu(0)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            SetScriptGfxDrawBehindPausemenu(1)
            SetScriptGfxDrawBehindPausemenu(0)
            Wait(0)
        end
    end)
end

local function CallScaleformMethod(scaleform, method, ...)
	local t
	local args = { ... }
	BeginScaleformMovieMethod(scaleform, method)
	for k, v in ipairs(args) do
		t = type(v)
		if t == 'string' then
			PushScaleformMovieMethodParameterString(v)
		elseif t == 'number' then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == 'boolean' then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end


local function MakeBoard(index)
    print(Config.Mugshots[index])
    local title = Config.Mugshots[index].BoardHeader
    local center = PlayerData.charinfo.firstname.. " ".. PlayerData.charinfo.lastname
    local footer = PlayerData.citizenid
    local header = PlayerData.charinfo.birthdate
	CallScaleformMethod(board_scaleform, 'SET_BOARD', title, center, footer, header, 0, 1337, 116)
end

local function MugShotCamera(index)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, Config.Mugshots[index].camera.x, Config.Mugshots[index].camera.y, Config.Mugshots[index].camera.z)
    SetCamRot(cam, Config.Mugshots[index].camera.r.x, Config.Mugshots[index].camera.r.y, Config.Mugshots[index].camera.r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam
    CreateThread(function()
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        SetPauseMenuActive(false)
        while mugshotInProgress do
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 46, true)
            Wait(1)
        end
    end)
end

local function PlayerBoard()
    local ped = PlayerPedId()
	RequestModel(`prop_police_id_board`)
	RequestModel(`prop_police_id_text`)
	while not HasModelLoaded(`prop_police_id_board`) or not HasModelLoaded(`prop_police_id_text`) do 
        Wait(1) 
    end
	board = CreateObject(`prop_police_id_board`, pedc, true, true, false)
	overlay = CreateObject(`prop_police_id_text`, pedc, true, true, false)
	AttachEntityToEntity(overlay, board, -1, 4103, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	SetModelAsNoLongerNeeded(`prop_police_id_board`)
	SetModelAsNoLongerNeeded(`prop_police_id_text`)
    SetCurrentPedWeapon(ped, `weapon_unarmed`, 1)
	ClearPedWetness(ped)
	ClearPedBloodDamage(ped)
	AttachEntityToEntity(board, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
end

local function TakeMugShot()
    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, 'files[]', {encoding = 'jpg'}, function(data)
        local resp = json.decode(data)
        MugshotArray[#MugshotArray+1] = resp.attachments[1].url
    end)
end

local function PhotoProcess(index)
    local ped = PlayerPedId()
    local rotation = Config.Mugshots[index].heading
    for photo = 1, Config.Mugshots[index].side, 1 do
        Wait(Config.Mugshots[index].Wait)
        TakeMugShot()
        PlaySoundFromCoord(-1, "SHUTTER_FLASH", Config.Mugshots[index].camera.x, Config.Mugshots[index].camera.y, Config.Mugshots[index].camera.z, "CAMERA_FLASH_SOUNDSET", true, 5, 0)
        Wait(Config.Mugshots[index].Wait)
        rotation = rotation - 90.0
        SetEntityHeading(ped, rotation)
    end
end

local function DestoryCamera()
    local ped = PlayerPedId()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    SetFocusEntity(ped)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
    DeleteObject(overlay)
    DeleteObject(board)
    handle = nil
    createdCamera = 0
end

RegisterNetEvent("aj-mugshots:client:trigger", function(index)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    pedc = pos

    PlayerData = AJFW.Functions.GetPlayerData()

    MugshotArray = {}
    mugshotInProgress = true

    local animDict = 'mp_character_creation@lineup@male_a'
    AJFW.Functions.RequestAnimDict(animDict)

    PrepBoard()

    Wait(250)

    MakeBoard(index)

    MugShotCamera(index)

    SetEntityCoords(ped, Config.Mugshots[index].location)
    SetEntityHeading(ped, Config.Mugshots[index].heading)

    PlayerBoard()

    TaskPlayAnim(ped, animDict, "loop_raised", 8.0, 8.0, -1, 49, 0, false, false, false)

    PhotoProcess(index)

    if createdCamera ~= 0 then
        DestoryCamera()
        SetEntityHeading(ped, suspectheading)
        ClearPedSecondaryTask(GetPlayerPed(ped))
    end

    mugshotInProgress = false
end)

RegisterNetEvent("aj-mugshots:client:takemugshot",function(args)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local player, distance = AJFW.Functions.GetClosestPlayer(pos)
    if player ~= -1 and distance < 2.0 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent('aj-mugshots:server:triggerSuspect', playerId, args.index)
    end
end)

if Config.Debug then
    RegisterCommand("testMughshotself", function(_,args)
        TriggerEvent('aj-mugshots:client:trigger', tonumber(args[1]))
    end)
end


CreateThread(function()
    for i = 1, #Config.Mugshots do
        local object = Config.Mugshots[i]
        if not Cache[object.target.options.name] then
            Cache[object.target.options.name] = true
            exports['aj-target']:AddBoxZone(
                object.target.options.name, 
                object.target.location, 
                object.target.length, 
                object.target.width, 
                object.target.options, 
                object.target.targetoptions
            )
        else
            print(object.target.options.name.." Already registered once")
        end
    end
end)