-- config.lua

Config = {}

Config.huntingZoneLocations = {
    { x = 1142.3, y = 111.49, z = 80.88 },
    { x = -763.73, y = 4184.92, z = 180.72 },
    -- Add more hunting zone locations as needed
}
Config.UseND = true
Config.minAnimals = 3
Config.maxAnimals = 10
Config.huntDuration = 6000 -- Duration of the hunting event in seconds (6000 seconds = 100 minutes)
Config.huntingZoneRadius = 150.0 -- Radius around hunting zones to trigger the event
Config.DefaultHuntingMessage = "The hunting event has ended!"
Config.cooldownDuration = 600 -- Cooldown between hunting events in seconds (600 seconds = 10 minutes) -- To be fixed.
Config.HuntIconURL = 'https://i.imgur.com/YuxSbbl.png'

