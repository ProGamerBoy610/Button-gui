-- Draggable Teleport GUI for Roblox
-- UP/DOWN teleport with toggle button

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
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
titleBar.Name = "TitleBar"
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
titleText.Text = "Teleport"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0.5, -75, 0.5, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "UP"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = toggleButton

-- Button state
local isUp = true

-- Functions
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRootPart()
    local character = getCharacter()
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local function teleportPlayer(direction)
    local rootPart = getRootPart()
    if not rootPart then
        warn("Could not find HumanoidRootPart")
        return
    end
    
    local currentPos = rootPart.Position
    local targetY = direction == "UP" and 172 or -7
    local newPos = Vector3.new(currentPos.X, targetY, currentPos.Z)
    
    -- Method 1: Direct CFrame teleport
    local success1 = pcall(function()
        rootPart.CFrame = CFrame.new(newPos)
    end)

    -- Method 2: Position property (if CFrame fails)
    if not success1 then
        local success2 = pcall(function()
            rootPart.Position = newPos
        end)
        
        -- Method 3: Velocity-based teleport (smoother)
        if not success2 then
            pcall(function()
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = rootPart
                
                rootPart.CFrame = CFrame.new(newPos)
                
                wait(0.1)
                bodyVelocity:Destroy()
            end)
        end
    end

    -- Method 4: Gradual teleport (less detectable)
    spawn(function()
        for i = 1, 10 do
            pcall(function()
                local lerpPos = currentPos:lerp(newPos, i/10)
                rootPart.CFrame = CFrame.new(lerpPos)
            end)
            RunService.Heartbeat:Wait()
        end
    end)

    print("Teleportation attempted to: " .. tostring(newPos))
end

-- Button click event
toggleButton.MouseButton1Click:Connect(function()
    if isUp then
        -- Currently UP, teleport up and change to DOWN
        teleportPlayer("UP")
        toggleButton.Text = "DOWN"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        isUp = false
    else
        -- Currently DOWN, teleport down and change to UP
        teleportPlayer("DOWN")
        toggleButton.Text = "UP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        isUp = true
    end
end)

-- Hover effects
toggleButton.MouseEnter:Connect(function()
    toggleButton.BackgroundColor3 = isUp and Color3.fromRGB(30, 150, 235) or Color3.fromRGB(235, 80, 80)
end)

toggleButton.MouseLeave:Connect(function()
    toggleButton.BackgroundColor3 = isUp and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 100, 100)
end)

print("Teleport GUI loaded successfully!")
