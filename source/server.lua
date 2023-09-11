NDCore = exports["ND_Core"]:GetCoreObject()
-- Function to send chat bubble notifications
function SendHuntNotification(playerName, message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.8); border-radius: 3px;">' ..
                   '<img src="' .. Config.HuntIconURL .. '" style="width: 30px; height: 30px; vertical-align: middle;"> ' ..
                   '<b>{0}</b> <br> {1}</div>',
        args = { playerName, message }
    })
end

-- Register a server event to send hunt notifications from the client
RegisterServerEvent('sendHuntNotification')
AddEventHandler('sendHuntNotification', function(playerName, message)
    local source = source
    SendHuntNotification(playerName, message)
end)

-- Define the server event for giving hunting rewards
RegisterServerEvent('huntRewards')
AddEventHandler('huntRewards', function(randomAmount)
    local src = source -- Get the source (player ID) of the event caller

    if Config.UseND then
        -- Use NDCore to add money
        NDCore.Functions.AddMoney(randomAmount, src, "cash", "Hunting Reward")
    else
        -- Specify the alternative action here, or remove this block if not needed
        -- Example: TriggerEvent('my_custom_economy:addMoney', src, randomAmount)
    end

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.8); border-radius: 3px;">' ..
                   '<img src="' .. Config.HuntIconURL .. '" style="width: 30px; height: 30px; vertical-align: middle;"> ' ..
                   '<b>{0}</b> <br> {1}</div>',
        args = { "Hunting", "You have won $" .. randomAmount .. " for hunting a Deer" }
    })
end)




