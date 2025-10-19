local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local NotificationService = {}

local SCREEN_OFFSET = UDim2.new(1, -20, 1, -20)
local NOTIFICATION_WIDTH = 350
local NOTIFICATION_HEIGHT = 100
local PADDING = 15
local ANIMATION_SPEED = 0.25
local MAX_NOTIFICATIONS = 15

local COLORS = {
    Success = Color3.fromRGB(46, 204, 113),
    Error = Color3.fromRGB(231, 76, 60),
    Warning = Color3.fromRGB(241, 196, 15),
    Info = Color3.fromRGB(52, 152, 219),
    Background = Color3.fromRGB(30, 30, 30),
    Text = Color3.fromRGB(240, 240, 240),
    SecondaryText = Color3.fromRGB(180, 180, 180),
    Shadow = Color3.fromRGB(10, 10, 10)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotificationSystem"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local NotificationsContainer = Instance.new("Frame")
NotificationsContainer.Name = "NotificationsContainer"
NotificationsContainer.BackgroundTransparency = 1
NotificationsContainer.Size = UDim2.new(0, NOTIFICATION_WIDTH + PADDING*2, 1, 0)
NotificationsContainer.Position = SCREEN_OFFSET
NotificationsContainer.AnchorPoint = Vector2.new(1, 1)
NotificationsContainer.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NotificationsContainer
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.Padding = UDim.new(0, PADDING)

local function createNotification(title, description, color, duration, notificationType)
    local notifications = NotificationsContainer:GetChildren()
    local notificationCount = 0
    
    for _, child in ipairs(notifications) do
        if child:IsA("Frame") and child.Name == "Notification" then
            notificationCount = notificationCount + 1
            local moveTween = TweenService:Create(
                child,
                TweenInfo.new(ANIMATION_SPEED/2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 0, 0, -((NOTIFICATION_HEIGHT + PADDING) * notificationCount))}
            )
            moveTween:Play()
        end
    end
    
    if notificationCount >= MAX_NOTIFICATIONS then
        local oldestNotification
        for _, child in ipairs(notifications) do
            if child:IsA("Frame") and child.Name == "Notification" then
                oldestNotification = child
                break
            end
        end
        if oldestNotification then oldestNotification:Destroy() end
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notification.BackgroundTransparency = 0
    notification.Size = UDim2.new(1, -PADDING*2, 0, NOTIFICATION_HEIGHT)
    notification.Position = UDim2.new(0, 0, 2, 0)
    notification.ClipsDescendants = true
    notification.ZIndex = 100
    notification.Parent = NotificationsContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 4, 1, -8)
    accentBar.Position = UDim2.new(0, 4, 0, 4)
    accentBar.ZIndex = notification.ZIndex + 1
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accentBar
    accentBar.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = string.upper(title)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = color
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.Size = UDim2.new(1, -24, 0, 20)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.ZIndex = notification.ZIndex + 1
    titleLabel.Parent = notification
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, -16, 0, 1)
    divider.Position = UDim2.new(0, 8, 0, 32)
    divider.ZIndex = notification.ZIndex + 1
    divider.Parent = notification
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Text = description
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    descLabel.TextSize = 13
    descLabel.TextTransparency = 0
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 12, 0, 36)
    descLabel.Size = UDim2.new(1, -24, 1, -44)
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    descLabel.ZIndex = notification.ZIndex + 1
    descLabel.Parent = notification
    
    local timerBar = Instance.new("Frame")
    timerBar.Name = "TimerBar"
    timerBar.BackgroundColor3 = color
    timerBar.BorderSizePixel = 0
    timerBar.Size = UDim2.new(1, -8, 0, 2)
    timerBar.Position = UDim2.new(0, 4, 1, -4)
    timerBar.ZIndex = notification.ZIndex + 1
    local timerCorner = Instance.new("UICorner")
    timerCorner.CornerRadius = UDim.new(0, 1)
    timerCorner.Parent = timerBar
    timerBar.Parent = notification
    
    local appearTween = TweenService:Create(
        notification,
        TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 1, -NOTIFICATION_HEIGHT)}
    )
    appearTween:Play()
    
    local timerTween = TweenService:Create(
        timerBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 2)}
    )
    timerTween:Play()
    
    task.delay(duration, function()
        local disappearTween = TweenService:Create(
            notification,
            TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {
                Position = UDim2.new(0, 0, 2, 0),
                BackgroundTransparency = 1
            }
        )
        
        for _, child in ipairs(notification:GetDescendants()) do
            if child:IsA("TextLabel") then
                TweenService:Create(
                    child,
                    TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {TextTransparency = 1}
                ):Play()
            elseif child:IsA("Frame") and child ~= timerBar then
                TweenService:Create(
                    child,
                    TweenInfo.new(ANIMATION_SPEED, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {BackgroundTransparency = 1}
                ):Play()
            end
        end
        
        disappearTween:Play()
        disappearTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

function NotificationService.Notify(duration, title, description, notificationType)
    local color = COLORS.Info
    if notificationType == "Success" then color = COLORS.Success
    elseif notificationType == "Error" then color = COLORS.Error
    elseif notificationType == "Warning" then color = COLORS.Warning end
    
    createNotification(title, description, color, duration, notificationType)
end

return NotificationService
