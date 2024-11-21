local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomLoggerGui"
screenGui.Parent = playerGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.5, 0) -- 40% width, 50% height
frame.Position = UDim2.new(0.3, 0, 0.25, 0) -- Centered
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0.2, 0, 1, 0) -- 20% width of the frame
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

-- Log Viewer Toggle Button
local logButton = Instance.new("TextButton")
logButton.Size = UDim2.new(1, 0, 0.1, 0) -- Full width of the sidebar, 10% height
logButton.Position = UDim2.new(0, 0, 0, 0)
logButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
logButton.Text = "Toggle Log Viewer"
logButton.TextColor3 = Color3.fromRGB(200, 200, 200)
logButton.TextScaled = true
logButton.Font = Enum.Font.Gotham
logButton.Parent = sidebar

-- Load the logger module
local logger = require(script.Modules.LogViewer)

-- Initialize the logger
logger.Initialize(frame)

-- Connect button to toggle the logger visibility
logButton.MouseButton1Click:Connect(function()
    logger.Toggle()
end)

-- Monitor remotes in ReplicatedStorage
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Hook into RemoteFunction and RemoteEvent
local function hookRemote(remote)
    if remote:IsA("RemoteFunction") then
        logger.AddMessage("[RemoteFunction] Detected: " .. remote.Name)

        -- Log RemoteFunction invoke
        remote.OnClientInvoke = function(...)
            logger.AddMessage("[RemoteFunction] Invoked: " .. remote.Name)
            logger.AddMessage("Arguments: " .. tostring(...))
        end
    elseif remote:IsA("RemoteEvent") then
        logger.AddMessage("[RemoteEvent] Detected: " .. remote.Name)

        -- Log RemoteEvent trigger
        remote.OnClientEvent:Connect(function(...)
            logger.AddMessage("[RemoteEvent] Triggered: " .. remote.Name)
            logger.AddMessage("Arguments: " .. tostring(...))
        end)
    end
end

-- Monitor all current remotes in ReplicatedStorage
for _, remote in pairs(replicatedStorage:GetDescendants()) do
    if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
        hookRemote(remote)
    end
end

-- Monitor newly added remotes in ReplicatedStorage
replicatedStorage.DescendantAdded:Connect(function(remote)
    if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
        hookRemote(remote)
    end
end)

-- LogViewer.lua
local LogViewer = {}

local viewerFrame
local isVisible = false
local logTextBox

function LogViewer.Initialize(parentFrame)
    viewerFrame = Instance.new("Frame")
    viewerFrame.Size = UDim2.new(0.8, 0, 1, 0) -- 80% of the parent frame width
    viewerFrame.Position = UDim2.new(0.2, 0, 0, 0)
    viewerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    viewerFrame.Visible = false -- Initially hidden
    viewerFrame.Parent = parentFrame

    logTextBox = Instance.new("TextBox")
    logTextBox.Size = UDim2.new(1, -10, 1, -10) -- Slight padding
    logTextBox.Position = UDim2.new(0, 5, 0, 5)
    logTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    logTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    logTextBox.TextScaled = false
    logTextBox.Font = Enum.Font.Code
    logTextBox.TextSize = 14
    logTextBox.ClearTextOnFocus = false
    logTextBox.MultiLine = true
    logTextBox.Text = "Log Viewer Initialized...\n"
    logTextBox.Parent = viewerFrame
end

function LogViewer.Toggle()
    if viewerFrame then
        isVisible = not isVisible
        viewerFrame.Visible = isVisible
    end
end

function LogViewer.AddMessage(message)
    if logTextBox then
        logTextBox.Text = logTextBox.Text .. message .. "\n"
        logTextBox.Text = string.sub(logTextBox.Text, -2000) -- Truncate to prevent overflow
    end
end

return LogViewer
