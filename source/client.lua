local isHunting = false
local remainingTime = 0
local killedAnimals = {}
local animals = {}
local lastHuntTime = 0
local lastHuntEnd = 0 -- Track the time when the last hunt ended
local huntingZoneBlips = {}
local randomAmount = math.random(10, 50)--Will be moved to config soon.
local huntingZoneLocations = Config.huntingZoneLocations
local huntDuration = Config.huntDuration
local huntingZoneRadius = Config.huntingZoneRadius
local DefaultHuntingMessage = Config.DefaultHuntingMessage
local cooldownDuration = Config.cooldownDuration
local animalStatus = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local currentTime = GetGameTimer()

        -- Remove the previous blips
        for _, blip in pairs(huntingZoneBlips) do
            RemoveBlip(blip)
        end

        -- Add blips for all hunting zones
        for i, location in pairs(huntingZoneLocations) do
            local locationCoords = vector3(location.x, location.y, location.z)

            -- Add a blip for the hunting zone
            local huntingZoneBlip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipSprite(huntingZoneBlip, 304) -- Set the blip sprite (304 is the hunting zone icon)
            SetBlipDisplay(huntingZoneBlip, 4)
            SetBlipScale(huntingZoneBlip, 1.0)
            SetBlipColour(huntingZoneBlip, 1) -- Set the blip color (1 is red)
            SetBlipAsShortRange(huntingZoneBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Hunting Zone")
            EndTextCommandSetBlipName(huntingZoneBlip)

            -- Store the blip and location in the table
            huntingZoneBlips[i] = huntingZoneBlip
        end

        for i, location in pairs(huntingZoneLocations) do
            local locationCoords = vector3(location.x, location.y, location.z)
            local distance = #(playerCoords - locationCoords)

            if distance < huntingZoneRadius then
                local currentTime = GetGameTimer()

                if not isHunting and (currentTime - lastHuntEnd) >= cooldownDuration then
                    StartHunt()
                    remainingTime = huntDuration
                end

                if isHunting then
                    local minutes = math.floor(remainingTime / 60)
                    local seconds = remainingTime % 60

                    local text = string.format("~r~Hunting: %02d:%02d", minutes, seconds)
                    DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 2.0, text)
                    remainingTime = remainingTime - 1
                    if remainingTime <= 0 then
                        EndHunt()
                    end
                end
				for _, ped in pairs(animals) do
					if DoesEntityExist(ped) then
						local pedStatus = animalStatus[ped]
						if pedStatus and not killedAnimals[ped] and GetEntityHealth(ped) < pedStatus.health then
							print("Player killed an animal!")
							local playerName = GetPlayerName(PlayerId()) -- Get the player's name
							local animalName = "Deer" -- Replace with the actual animal name
							PlayerKilledAnimal(playerName, animalName, randomAmount)
							killedAnimals[ped] = true
						end
					end
				end
            end
        end
    end
end)

function SpawnAnimals()
    for _, location in pairs(huntingZoneLocations) do
        local x, y, z = location.x, location.y, location.z
        local numDeerToSpawn = math.random(3, 10) -- Generate the random number outside the loop

        for i = 1, numDeerToSpawn do
            local pedModelHash = GetHashKey("a_c_deer")
            local heading = math.random(0, 360)
            local randomX, randomY = x + math.random(-huntingZoneRadius, huntingZoneRadius), y + math.random(-huntingZoneRadius, huntingZoneRadius)
            
            -- Use GET_GROUND_Z_FOR_3D_COORD to get the ground Z-coordinate
            local retval, groundZ = GetGroundZFor_3dCoord(randomX, randomY, z, false)

            if retval then
                local ped = RequestModel(pedModelHash)

                while not HasModelLoaded(pedModelHash) do
                    Citizen.Wait(1)
                end

                local npc = CreatePed(28, pedModelHash, randomX, randomY, groundZ, heading, true, false)
                -- Set the ped as a mission entity to make it persistent
                SetEntityAsMissionEntity(npc, true, true)
				MakeAnimalsRoam()
                SetEntityHeading(npc, heading)
                SetEntityInvincible(npc, false)
                SetEntityCanBeDamaged(npc, true)

                table.insert(animals, npc)
                animalStatus[npc] = {
                    pedModelHash = pedModelHash,
                    health = GetEntityHealth(npc)
                }

                local blip = AddBlipForEntity(npc)
                SetBlipSprite(blip, 442)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 1.0)
                SetBlipColour(blip, 1)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Deer")
                EndTextCommandSetBlipName(blip)
            end

            Citizen.Wait(100)
        end
    end
end

function StartHunt()
    local currentTime = GetGameTimer()

    if (currentTime - lastHuntEnd) >= cooldownDuration then
        isHunting = true
        SendHuntNotification("Hunting", "The hunt has started!")

        Citizen.Wait(500) -- Add a delay to prevent chat message overlap

        SpawnAnimals()
    else
        SendHuntNotification("Hunting", "You must wait for the cooldown before starting a new hunt.")
    end
end

function EndHunt()
    isHunting = false
    SendHuntNotification("Hunting", DefaultHuntingMessage)

    for _, ped in pairs(animals) do
        if DoesEntityExist(ped) then
            SetEntityAsNoLongerNeeded(ped) -- Release the ped entity
        end
    end
    animals = {}
    lastHuntEnd = GetGameTimer()
end

function MakeAnimalsRoam()
    for _, ped in pairs(animals) do
        if DoesEntityExist(ped) then
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local randomX = x + math.random(-10.0, 10.0) -- Adjust the roaming area as needed
            local randomY = y + math.random(-10.0, 10.0) -- Adjust the roaming area as needed

            TaskWanderStandard(ped, 10.0, 10) -- Adjust the radius and time interval as needed
        end
    end
end

function SendHuntNotification(playerName, message)
    TriggerServerEvent('sendHuntNotification', playerName, message)
end

function PlayerKilledAnimal(playerName, animalName, randomAmount)
    SendHuntNotification(playerName, "Killed an animal: " .. animalName)
    TriggerServerEvent('huntRewards', randomAmount)
end

-- Function to draw text in 3D space
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
