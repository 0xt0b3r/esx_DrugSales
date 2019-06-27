-- Modified Drug Sales By Jay (For PixelLifeRP)

ESX                 = nil
local myJob     = nil
local selling       = false
local has       = false
local copsc     = false

local maxDist = 400.0
local DrugZones = {
    vector3(4.21,-1606.19,29.28),
    vector3(302.4,-2020.2,20.31),
    vector3(-1104.0,-1508.0,4.66),
    vector3(1309.71,-1713.41,54.85),
    vector3(-1232.61,-767.47,18.90),
  }

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  TriggerServerEvent('fetchjob')
end)


RegisterNetEvent('getjob')
AddEventHandler('getjob', function(jobName)
  myJob = jobName
end)


currentped = nil
Citizen.CreateThread(function()

while true do
  Citizen.Wait(0)
  local player = GetPlayerPed(-1)
  local playerloc = GetEntityCoords(player)
  local closest,closestDist
  for k,v in pairs(DrugZones) do
    local dist = GetDistanceBetweenCoords(playerloc.x,playerloc.y,playerloc.z,v.x,v.y,v.z)
    if not closestDist or dist < closestDist then closest = v; closestDist = dist; end
  end
  if closestDist < maxDist then
    local handle, ped = FindFirstPed()
    repeat
      success, ped = FindNextPed(handle)
      local pos = GetEntityCoords(ped)
      local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
      if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
        if DoesEntityExist(ped)then
          if IsPedDeadOrDying(ped) == false then
            if IsPedInAnyVehicle(ped) == false then
              local pedType = GetPedType(ped)
              if pedType ~= 28 and IsPedAPlayer(ped) == false then
                currentped = pos
                if distance <= 2 and ped  ~= GetPlayerPed(-1) and ped ~= oldped then
                  TriggerServerEvent('checkD')
                  if has == true then
                    drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Press ~g~E ~w~to sell drugs", 255, 255, 255, 255)
                    if IsControlJustPressed(1, 86) then
                        oldped = ped
                        SetEntityAsMissionEntity(ped)
                        TaskStandStill(ped, 9.0)
                        pos1 = GetEntityCoords(ped)
                        TriggerServerEvent('drugs:trigger')
                        Citizen.Wait(2850)
                        TriggerEvent('sell')
                        SetPedAsNoLongerNeeded(oldped)
                    end
                  end
                end
              end
            end
          end
        end
      end
    until not success
    EndFindPed(handle)
    end
  end
end)

Citizen.CreateThread(function()
  local blip = false
  local active = false
  local tick = 0
  while true do
    Citizen.Wait(0)
    tick = tick + 1
    if tick % 10 == 0 then TriggerServerEvent('checkD'); end
    if has then  
      local player = GetPlayerPed(-1)
      local playerloc = GetEntityCoords(player)
      local closest,closestDist
      for k,v in pairs(DrugZones) do
        local dist = GetDistanceBetweenCoords(playerloc.x,playerloc.y,playerloc.z,v.x,v.y,v.z)
        if not closestDist or dist < closestDist then closest = v; closestDist = dist; end
      end
      if not blip then
        blip = AddBlipForRadius(closest, maxDist)

        SetBlipHighDetail(blip, true)
        SetBlipColour(blip, 1)
        SetBlipAlpha (blip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drug Zone")
        EndTextCommandSetBlipName(blip)
        active = closest
      elseif closest ~= active or closestDist > maxDist then
        RemoveBlip(blip)
        active = false
        blip = false
      elseif blip and closest == active then   
        local dist = GetDistanceBetweenCoords(playerloc.x,playerloc.y,playerloc.z,closest.x,closest.y,closest.z)
        local newAlpha = math.min((maxDist) - dist, 130)  
        SetBlipAlpha (blip, math.floor(newAlpha))
      end
    else
      if blip or active then
        RemoveBlip(blip)
        active = false
        blip = false
      end
    end
  end
end)

RegisterNetEvent('sell')
AddEventHandler('sell', function()
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)
    local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'], true)

    if distance <= 2 then
      TriggerServerEvent('drugs:sell')
    elseif distance > 2 then
      TriggerServerEvent('sell_dis')
    end
end)


RegisterNetEvent('checkR')
AddEventHandler('checkR', function(test)
  has = test
end)

RegisterNetEvent('notifyc')
AddEventHandler('notifyc', function()

      local coords = GetEntityCoords(GetPlayerPed(-1))

      TriggerServerEvent('esx_phone:send', "police", 'Someone is selling me drugs' , true, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })
end)

RegisterNetEvent('animations')
AddEventHandler('animations', function()
  local pid = PlayerPedId()
  RequestAnimDict("mp_safehouselost@")
  while (not HasAnimDictLoaded("mp_safehouselost@")) do Citizen.Wait(0) end
    medkit = CreateObject(GetHashKey("prop_weed_bottle"), 0, 0, 0, true, true, true) 
	AttachEntityToEntity(medkit, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.09, 0.0, -0.03, 135.0, -100.0, 40.0, true, true, false, true, 1, true)
    TaskPlayAnim(pid,"mp_safehouselost@","package_dropoff",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(750)
    StopAnimTask(pid, "mp_safehouselost@","package_dropoff", 1.0)
	DeleteEntity(medkit)
end)


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
