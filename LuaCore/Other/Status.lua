local Status = "Maintenance" -- Active/Maintenance
local DiscordLink = "discord.gg/ktC6dNVxDC"

print("[Space Hub]: " .. Status)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if Status == "Maintenance" then
    local kickMessage = string.format("Space Hub is currently under maintenance.\nPlease check back later.\n\n%s", DiscordLink)
    LocalPlayer:Kick(kickMessage)
    return
end
