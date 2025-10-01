local Status = "Maintenance" -- Active/Maintenance
local DiscordLink = getgenv().DiscordFull or "https://discord.gg/ktC6dNVxDC"

print("[Space Hub]: " .. Status)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if Status == "Maintenance" then
    local kickMessage = string.format("Space Hub is currently under maintenance.\nPlease check back later.\n\nDiscord: %s", DiscordLink)
    LocalPlayer:Kick(kickMessage)
    return
end
