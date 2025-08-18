if game.CoreGui:FindFirstChild("Space Hub Toggle") then
    pcall(function()
        game.CoreGui["Space Hub Toggle"]:Destroy()
    end)
end

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local UiToggle = Instance.new("ScreenGui")
UiToggle.Name = "Space Hub Toggle"
UiToggle.Parent = CoreGui
UiToggle.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 40, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 20)
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.Text = "UI"
Button.TextColor3 = Color3.fromHSV(2/3, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 20
Button.Parent = UiToggle
Button.ZIndex = 1000

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = Button

local hueValue = Instance.new("NumberValue")
hueValue.Parent = Button
local min_hue = 2/3
local max_hue = 0.75
hueValue.Value = min_hue

hueValue.Changed:Connect(function()
    Button.TextColor3 = Color3.fromHSV(hueValue.Value, 1, 1)
end)

task.spawn(function()
    while true do
        local tween = TweenService:Create(hueValue, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Value = max_hue})
        tween:Play()
        tween.Completed:Wait()
        local tween_back = TweenService:Create(hueValue, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Value = min_hue})
        tween_back:Play()
        tween_back.Completed:Wait()
    end
end)

do
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

Button.MouseButton1Click:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    task.wait(0.05)
    print("[Space Hub]: Ui Toggle clicked.")
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
end)
