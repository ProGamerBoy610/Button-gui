local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlideGui"
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar

titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Glide System"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Create close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 5)
closeButtonCorner.Parent = closeButton

-- Create glide button
local glideButton = Instance.new("TextButton")
glideButton.Name = "GlideButton"
glideButton.Size = UDim2.new(0, 150, 0, 35)
glideButton.Position = UDim2.new(0.5, -75, 0, 40)
glideButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
glideButton.BorderSizePixel = 0
glideButton.Text = "GLIDE"
glideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
glideButton.TextScaled = true
glideButton.Font = Enum.Font.GothamBold
glideButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = glideButton

-- Create timer text
local timerText = Instance.new("TextLabel")
timerText.Name = "TimerText"
timerText.Size = UDim2.new(0, 150, 0, 25)
timerText.Position = UDim2.new(0.5, -75, 0, 85)
timerText.BackgroundTransparency = 1
timerText.Text = "Ready"
timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
timerText.TextScaled = true
timerText.Font = Enum.Font.Gotham
timerText.Parent = mainFrame

-- Gliding variables
local isGliding = false
local glideConnection
local bodyVelocity
local glideTimeLeft = 0
local timerConnection

-- Glide settings
local GLIDE_SPEED = 35
local GLIDE_LIFT = 2
local GLIDE_DURATION = 20

-- Functions
local function getCharacter()
    return player.Character
end

local function getRootPart()
    local character = getCharacter()
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function startGliding()
    if isGliding then return end
    
    local character = getCharacter()
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = getRootPart()
    
    if not humanoid or not rootPart then return end
    
    isGliding = true
    glideTimeLeft = GLIDE_DURATION
    
    -- Create body mover
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = rootPart
    
    -- Set physics state
    humanoid.PlatformStand = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    -- Update button appearance
    glideButton.Text = "UNGLIDE"
    glideButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    
    -- Glide loop
    glideConnection = RunService.Heartbeat:Connect(function()
        if not character.Parent or not rootPart.Parent then
            stopGliding()
            return
        end
        
        -- Get camera direction
        local camera = workspace.CurrentCamera
        local lookDirection = camera.CFrame.LookVector
        
        -- Calculate glide direction (more horizontal)
        local glideDirection = Vector3.new(lookDirection.X, -0.05, lookDirection.Z).Unit
        
        -- Apply velocity with minimal vertical movement
        local velocity = glideDirection * GLIDE_SPEED + Vector3.new(0, GLIDE_LIFT, 0)
        bodyVelocity.Velocity = velocity
        
        -- Rotate player to face direction
        local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(lookDirection.X, 0, look、健康
        rootPart.CFrame = rootPart.CFrame:lerp(targetCFrame, 0.1)
    end)
    
    print("Gliding started!")
end

local function stopGliding()
    if not isGliding then return end
    
    isGliding falso
    glideTimeLeft = 0
    
    if glideConnection then
        glideConnection:Disconnect()
        glideConnection = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    local character = getCharacter()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
    
    -- Update button appearance - ready to use again
    glideButton.Text = "GLIDE"
    glideButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    glideButton.Active = true
    timerText.Text = "Ready"
    
    print("Gliding stopped!")
end

-- Timer system
local function updateTimer()
    if isGliding then
        glideTimeLeft = glideTimeLeft - 1
        timerText.Text = "Time Left: " .. glideTimeLeft .. "s"
        
        if glideTimeLeft <= 0 then
            stopGliding()
        end
    end
end

-- Start timer (proper 1-second intervals)
timerConnection = spawn(function()
    while screenGui.Parent do
        wait(1)
        updateTimer()
    end
end)

-- Button click event
glideButton.MouseButton1Click:Connect(function()
    if not glideButton.Active then return end
    
    if isGliding then
        stopGliding()
    else
        startGliding()
    end
end)

-- Close button event
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Hover effects for glide button
glideButton.MouseEnter:Connect(function()
    if glideButton.Active then
        if isGliding then
            glideButton.BackgroundColor3 = Color3.fromRGB(235, 80, 80)
        else
            glideButton.BackgroundColor3 = Color3.fromRGB(30, 150, 235)
        end
    end
end)

glideButton.MouseLeave:Connect(function()
    if glideButton.Active then
        if isGliding then
            glideButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        else
            glideButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
    end
end)

-- Hover effects for close button
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

-- Cleanup
player.CharacterRemoving:Connect(function()
    stopGliding()
end)

print("Glide GUI with timer loaded successfully!")
