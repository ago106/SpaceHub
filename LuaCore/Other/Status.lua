local Status = "Maintenance" --Active/Maintenance
print("[Space Hub]: " .. Status)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if Status == "Maintenance" then
  LocalPlayer:Kick("Script on Maintenance. | " .. getgenv().DiscordFull)
end
