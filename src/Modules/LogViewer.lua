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
