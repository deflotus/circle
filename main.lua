local Settings = shared.Settings or {
    CircleReach = true,
    DamageAmp = false,
    AutoClicker = true,
    Visualizer = true,
    CircleDistance = 10,
    HitDebounce = 0.3,

    KeyBinds = {
        CircleReachToggle = "Z",
        DamageAmpToggle = "X",
        AutoClickerToggle = "C",
        VisualizerToggle = "V",
        IncreaseCircleDistance = "E",
        DecreaseCircleDistance = "Q"
    },

    ColorTheme = Color3.fromRGB(255, 102, 204)
}

local Players, RunService, UserInputService, TweenService = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local DrawingApi = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()
local Random = Random.new()

local NotificationGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
NotificationGui.Name = "penis music"
syn.protect_gui(NotificationGui)

local NotificationFrame = Instance.new("Frame", NotificationGui)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Position = UDim2.new(0, 0, 0, 0)
NotificationFrame.Size = UDim2.new(1, 0, 0, 100)
NotificationFrame.Parent = NotificationGui

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.AnchorPoint = Vector2.new(1, 1)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Position = UDim2.new(1, 0, 1, 20)
NotificationLabel.Size = UDim2.new(1, 0, 0, 20)
NotificationLabel.ZIndex = 1
NotificationLabel.Font = Enum.Font.Code
NotificationLabel.RichText = true
NotificationLabel.LineHeight = 1
NotificationLabel.MaxVisibleGraphemes = -1
NotificationLabel.Text = "bruh moment"
NotificationLabel.TextColor3 = Settings.ColorTheme
NotificationLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
NotificationLabel.TextSize = 16
NotificationLabel.TextWrapped = true
NotificationLabel.TextTransparency = 0
NotificationLabel.TextStrokeTransparency = 0
NotificationLabel.TextXAlignment = Enum.TextXAlignment.Center
NotificationLabel.TextYAlignment = Enum.TextYAlignment.Center
NotificationLabel.Visible = true

local NotificationQueue = {}
local BodyParts = {
    "Left Arm",
    "Right Arm",
    "HumanoidRootPart",
    "Right Leg",
    "Left Leg",
    "Torso",
    "Head" 
}

local function Notification(Text, Expiration)
    table.insert(NotificationQueue, {Text, Expiration})
end

local function GetCharacter(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
        local Exists = true

        for _, BodyPart in next, BodyParts do
            if not Player.Character:FindFirstChild(BodyPart) then
                Exists = false
            end
        end

        if Exists then
            return Player.Character
        end
    end
end

local function GetClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge

    for _, Player in next, Players:GetPlayers() do
        if Player ~= LocalPlayer then
            local Character = GetCharacter(Player)
            local LocalCharacter = GetCharacter(LocalPlayer)
            if Character and LocalCharacter then
                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude

                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end

    return ClosestPlayer, ClosestDistance
end

local function Touch(TouchWith, Touch)
    local Repeat = 3

    if Settings.DamageAmp then
        Repeat = 10
    end

    for _ = 1, Repeat do
        firetouchinterest(TouchWith, Touch, 0)
        task.wait()
        firetouchinterest(TouchWith, Touch, 1)
    end
end

local Visualizer = DrawingApi:New3DCircle()
Visualizer.Visible = false
Visualizer.ZIndex = 1
Visualizer.Transparency = 1
Visualizer.Color = Settings.ColorTheme
Visualizer.Thickness = 1

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed then
        if Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.CircleReachToggle] then
            Settings.CircleReach = not Settings.CircleReach
            Notification("circle reach set to: " .. tostring(Settings.CircleReach), 2)
        elseif Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.DamageAmpToggle] then
            Settings.DamageAmp = not Settings.DamageAmp
            Notification("damage amp set to: " .. tostring(Settings.DamageAmp), 2)
        elseif Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.AutoClickerToggle] then
            Settings.AutoClicker = not Settings.AutoClicker
            Notification("autoclicker set to: " .. tostring(Settings.AutoClicker), 2)
        elseif Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.VisualizerToggle] then
            Settings.Visualizer = not Settings.Visualizer
            Notification("visualizer set to: " .. tostring(Settings.Visualizer), 2)
        elseif Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.DecreaseCircleDistance] then
            Settings.CircleDistance -= 1
            Notification("reach set to: " .. tostring(Settings.CircleDistance), 2)
        elseif Input.KeyCode == Enum.KeyCode[Settings.KeyBinds.IncreaseCircleDistance] then
            Settings.CircleDistance += 1
            Notification("reach set to: " .. tostring(Settings.CircleDistance), 2)
        end
    end
end)

local LastHit = os.clock()

RunService.RenderStepped:Connect(function()
    if GetCharacter(LocalPlayer) then
        local Tool = GetCharacter(LocalPlayer):FindFirstChildOfClass("Tool")
        local ClosestPlayer, Distance = GetClosestPlayer()
        local ClosestCharacter = GetCharacter(ClosestPlayer)

        if Settings.AutoClicker and Tool and Tool.Parent.Name ~= "Backpack" and Tool:FindFirstChild("Handle") then
            Tool:Activate()
        end

        if Settings.Visualizer and Tool and Tool.Parent.Name ~= "Backpack" and Tool:FindFirstChild("Handle") then
            Visualizer.Visible = true
            Visualizer.Position = GetCharacter(LocalPlayer).HumanoidRootPart.Position
            Visualizer.Radius = Settings.CircleDistance
        else
            Visualizer.Visible = false
        end

        if Settings.CircleReach and ClosestPlayer and ClosestCharacter and Distance <= Settings.CircleDistance and Tool and Tool.Parent.Name ~= "Backpack" and Tool:FindFirstChild("Handle") then
            for _, BodyPart in next, BodyParts do
		if Settings.HitDebounce > 0 then
			local Current = os.clock()
                	if Current - LastHit >= math.random(Settings.HitDebounce) + math.random() then
                    		coroutine.wrap(Touch)(Tool.Handle, ClosestCharacter[BodyPart])
                    		LastHit = Current
                	end
		else
			coroutine.wrap(Touch)(Tool.Handle, ClosestCharacter[BodyPart])
		end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if NotificationQueue[1] then
            local String = NotificationQueue[1]

            if String then
                local Label = NotificationLabel:Clone()

                Label.Text = String[1]
                Label.Parent = NotificationFrame

                for _, Message in next, NotificationFrame:GetChildren() do
                    Message:TweenPosition(Message.Position - UDim2.new(0, 0, 0, 20), "Out", "Sine", 0.3, true)
                end

                table.remove(NotificationQueue, 1)

                task.delay(String[2], function()
                    TweenService:Create(Label, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
                    task.wait(1.2)
                    Label:Destroy()
                end)

                task.wait(0.3)
            end
        end
    end
end)