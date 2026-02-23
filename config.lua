Config = {}

-- ESX Version
Config.versionESX = 'new' --[[
    'old' (Esx 1.1).
    'new' (Esx 1.2, v1 final, legacy or extendedmode).
]]

Config.Locale = 'fr' -- en/fr

--cd_easytime
Config.easytime = true  -- true/false

-- Command
Config.Command = 'tablet' -- Set nil to disabled command !
Config.CommandDescription = 'Open tablet'

-- Item
Config.Item = 'xelyos_bob_tablet' -- Set nil to disabled item !

-- Animation
Config.AnimDict = 'amb@world_human_seat_wall_tablet@female@base'
Config.Prop = 'prop_cs_tablet'
Config.Bone = 28422

-- Icons
Config.weatherIcons = {
    CLOUDS = 'weather-icon fas fa-cloud-sun',
    RAIN = 'weather-icon fas fa-cloud-rain',
    CLEAR = 'weather-icon fas fa-sun',
    OVERCAST = 'weather-icon fas fa-cloud-sun',
    EXTRASUNNY = 'weather-icon fas fa-sun',
    CLEARING = 'weather-icon fas fa-sun',
    NEUTRAL = 'weather-icon fas fa-sun',
    THUNDER = 'weather-icon fas fa-bolt',
    SMOG = 'weather-icon fas fa-smog',
    FOGGY = 'weather-icon fas fa-smog',
    SNOWLIGHT = 'weather-icon fas fa-snowflake',
    SNOW = 'weather-icon fas fa-snowflake',
    BLIZZARD = 'weather-icon fas fa-snowflake',
    XMAS = 'weather-icon fas fa-snowflake',
    HALLOWEEN = 'weather-icon fas fa-cloud-moon',
}

Config.weatherGif = {
    CLOUDS = "background: url('https://i.gifer.com/1427.gif') center/cover;",
    RAIN = "background: url('https://i.gifer.com/73j4.gif') center/cover;",
    CLEAR = "background: url('https://i.gifer.com/Lx0q.gif') center/cover;",
    OVERCAST = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    EXTRASUNNY = "background: url('https://stormandsky.com/gif/15.gif') center/cover;",
    CLEARING = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    NEUTRAL = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    THUNDER = "background: url('https://i.gifer.com/DMI.gif') center/cover;",
    SMOG = "background: url('https://i.gifer.com/7JyC.gif') center/cover;",
    FOGGY = "background: url('https://i.gifer.com/IJNu.gif') center/cover;",
    SNOWLIGHT = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    SNOW = "background: url(' https://i.gifer.com/3g5.gif') center/cover;",
    BLIZZARD = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    XMAS = "background: url('https://stormandsky.com/gif/11.gif') center/cover;",
    HALLOWEEN = "background: url('https://i.gifer.com/AdL.gif') center/cover;",
}