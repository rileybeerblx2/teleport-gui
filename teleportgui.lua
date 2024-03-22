local Players = game:GetService("Players")

-- Function to teleport the local player to another player
local function teleportToPlayer(playerName)
    -- Find the player with the specified username
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer then
        -- Get the character of the target player
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            -- Get the HumanoidRootPart of the target character
            local rootPart = targetCharacter:WaitForChild("HumanoidRootPart")
            
            -- Get the local player's character
            local localCharacter = Players.LocalPlayer.Character
            if localCharacter then
                -- Disable jumping
                localCharacter.Humanoid.Jump = false
                
                -- Teleport the local player's character to the target player's position
                localCharacter:SetPrimaryPartCFrame(CFrame.new(rootPart.Position))
            end
        else
            warn("Target player has no character.")
        end
    else
        warn("Player with username '" .. playerName .. "' not found.")
    end
end

-- Create a ScreenGui to hold the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame for the main GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150) -- Larger size
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Allow dragging
mainFrame.Draggable = true -- Allow the GUI to be dragged
mainFrame.Parent = screenGui

-- GUI Name Label
local guiName = Instance.new("TextLabel")
guiName.Size = UDim2.new(1, 0, 0, 30) -- Height is 30 pixels
guiName.Position = UDim2.new(0, 0, 0, 0) -- Align to top-left corner
guiName.Text = "Teleport GUI" -- Name of the GUI
guiName.TextSize = 18
guiName.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
guiName.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray background color
guiName.BorderColor3 = Color3.fromRGB(0, 0, 0)
guiName.Font = Enum.Font.SourceSansBold -- Use bold font
guiName.Parent = mainFrame

-- Create a TextBox for entering the player username
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0, 40) -- Larger and taller textbox
textBox.Position = UDim2.new(0.1, 0, 0.15, 0) -- Adjust position as needed
textBox.PlaceholderText = "Enter player username..."
textBox.TextScaled = true
textBox.TextWrapped = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Dark gray background color
textBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
textBox.Font = Enum.Font.SourceSans -- Use SourceSans font
textBox.TextSize = 18 -- Larger text size
textBox.Parent = mainFrame

-- Create a TextButton for teleporting
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.8, 0, 0, 40) -- Larger teleport button
teleportButton.Position = UDim2.new(0.1, 0, 0.55, 0) -- Adjust position as needed
teleportButton.Text = "Teleport"
teleportButton.TextSize = 18
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Blue button color
teleportButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.AutoButtonColor = false
teleportButton.Parent = mainFrame

-- Function to handle teleport button click
teleportButton.MouseButton1Click:Connect(function()
    local playerName = textBox.Text
    if playerName ~= "" then
        teleportToPlayer(playerName)
    else
        warn("Please enter a valid player username.")
    end
end)

-- Allow dragging the GUI
local dragInput
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = mainFrame.Position
        
        dragInput = input
        dragInput.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput = nil
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
