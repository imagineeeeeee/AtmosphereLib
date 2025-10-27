-- Modern Roblox UI Library
-- Usage: local Library = loadstring(game:HttpGet("your_url_here"))()

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utility Functions
local function Tween(obj, props, duration, style, direction)
	local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local tween = TweenService:Create(obj, tweenInfo, props)
	tween:Play()
	return tween
end

local function MakeDraggable(frame, dragHandle)
	local dragging, dragInput, dragStart, startPos

	dragHandle = dragHandle or frame

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.1)
		end
	end)
end

-- Main Window Creation
function Library:CreateWindow(config)
	config = config or {}
	local windowName = config.Name or "UI Library"
	local windowSize = config.Size or UDim2.new(0, 550, 0, 400)

	local window = {
		Tabs = {},
		CurrentTab = nil
	}

	-- Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")

	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = windowSize
	MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
	MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

	-- Title Bar
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 40)
	TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = MainFrame

	local TitleCorner = Instance.new("UICorner")
	TitleCorner.CornerRadius = UDim.new(0, 8)
	TitleCorner.Parent = TitleBar

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, -50, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = windowName
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 16
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = TitleBar

	-- Close Button
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "Close"
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Position = UDim2.new(1, -35, 0, 5)
	CloseButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.TextSize = 20
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.BorderSizePixel = 0
	CloseButton.Parent = TitleBar

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseButton

	CloseButton.MouseEnter:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
	end)

	CloseButton.MouseLeave:Connect(function()
		Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
	end)

	CloseButton.MouseButton1Click:Connect(function()
		Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
		wait(0.3)
		ScreenGui:Destroy()
	end)

	-- Tab Container
	local TabContainer = Instance.new("Frame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 140, 1, -50)
	TabContainer.Position = UDim2.new(0, 10, 0, 45)
	TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 6)
	TabCorner.Parent = TabContainer

	local TabList = Instance.new("UIListLayout")
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Padding = UDim.new(0, 5)
	TabList.Parent = TabContainer

	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingTop = UDim.new(0, 8)
	TabPadding.PaddingLeft = UDim.new(0, 8)
	TabPadding.PaddingRight = UDim.new(0, 8)
	TabPadding.Parent = TabContainer

	-- Content Container
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -170, 1, -50)
	ContentContainer.Position = UDim2.new(0, 160, 0, 45)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Parent = MainFrame

	MakeDraggable(MainFrame, TitleBar)

	-- Create Tab Function
	function window:CreateTab(tabName)
		local tab = {
			Elements = {}
		}

		-- Tab Button
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		TabButton.Text = tabName
		TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TabButton.TextSize = 14
		TabButton.Font = Enum.Font.Gotham
		TabButton.BorderSizePixel = 0
		TabButton.Parent = TabContainer

		local TabButtonCorner = Instance.new("UICorner")
		TabButtonCorner.CornerRadius = UDim.new(0, 6)
		TabButtonCorner.Parent = TabButton

		-- Tab Content
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = tabName .. "Content"
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.Visible = false
		TabContent.Parent = ContentContainer

		local ContentList = Instance.new("UIListLayout")
		ContentList.SortOrder = Enum.SortOrder.LayoutOrder
		ContentList.Padding = UDim.new(0, 8)
		ContentList.Parent = TabContent

		local ContentPadding = Instance.new("UIPadding")
		ContentPadding.PaddingTop = UDim.new(0, 8)
		ContentPadding.PaddingLeft = UDim.new(0, 8)
		ContentPadding.PaddingRight = UDim.new(0, 8)
		ContentPadding.PaddingBottom = UDim.new(0, 8)
		ContentPadding.Parent = TabContent

		ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 16)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, t in pairs(window.Tabs) do
				t.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
				t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
				t.Content.Visible = false
			end

			TabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabContent.Visible = true
			window.CurrentTab = tab
		end)

		TabButton.MouseEnter:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
			end
		end)

		TabButton.MouseLeave:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
			end
		end)

		tab.Button = TabButton
		tab.Content = TabContent
		table.insert(window.Tabs, tab)

		if #window.Tabs == 1 then
			TabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabContent.Visible = true
			window.CurrentTab = tab
		end

		-- Add Button
		function tab:AddButton(config)
			config = config or {}
			local buttonText = config.Name or "Button"
			local callback = config.Callback or function() end

			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.Size = UDim2.new(1, -8, 0, 35)
			Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			Button.Text = buttonText
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 14
			Button.Font = Enum.Font.Gotham
			Button.BorderSizePixel = 0
			Button.Parent = TabContent

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = Button

			Button.MouseEnter:Connect(function()
				Tween(Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
			end)

			Button.MouseLeave:Connect(function()
				Tween(Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.2)
			end)

			Button.MouseButton1Click:Connect(function()
				Tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.1)
				wait(0.1)
				Tween(Button, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.1)
				callback()
			end)

			return Button
		end

		-- Add Toggle
		function tab:AddToggle(config)
			config = config or {}
			local toggleText = config.Name or "Toggle"
			local default = config.Default or false
			local callback = config.Callback or function() end

			local toggleState = default

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "Toggle"
			ToggleFrame.Size = UDim2.new(1, -8, 0, 35)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = TabContent

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = toggleText
			ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleLabel.TextSize = 14
			ToggleLabel.Font = Enum.Font.Gotham
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = ToggleFrame

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(0, 40, 0, 20)
			ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
			ToggleButton.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(50, 50, 55)
			ToggleButton.Text = ""
			ToggleButton.BorderSizePixel = 0
			ToggleButton.Parent = ToggleFrame

			local ToggleButtonCorner = Instance.new("UICorner")
			ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
			ToggleButtonCorner.Parent = ToggleButton

			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleCircle.BorderSizePixel = 0
			ToggleCircle.Parent = ToggleButton

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = ToggleCircle

			ToggleButton.MouseButton1Click:Connect(function()
				toggleState = not toggleState

				if toggleState then
					Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
					Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
				else
					Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
					Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
				end

				callback(toggleState)
			end)

			return {
				Set = function(value)
					toggleState = value
					if toggleState then
						Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
						Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
					else
						Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
						Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
					end
					callback(toggleState)
				end
			}
		end

		-- Add Slider
		function tab:AddSlider(config)
			config = config or {}
			local sliderText = config.Name or "Slider"
			local min = config.Min or 0
			local max = config.Max or 100
			local default = config.Default or min
			local callback = config.Callback or function() end

			local sliderValue = default

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = "Slider"
			SliderFrame.Size = UDim2.new(1, -8, 0, 50)
			SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabContent

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 5)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = sliderText
			SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderLabel.TextSize = 14
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = SliderFrame

			local SliderValue = Instance.new("TextLabel")
			SliderValue.Size = UDim2.new(0, 50, 0, 20)
			SliderValue.Position = UDim2.new(1, -60, 0, 5)
			SliderValue.BackgroundTransparency = 1
			SliderValue.Text = tostring(default)
			SliderValue.TextColor3 = Color3.fromRGB(70, 130, 255)
			SliderValue.TextSize = 14
			SliderValue.Font = Enum.Font.GothamBold
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.Parent = SliderFrame

			local SliderBar = Instance.new("Frame")
			SliderBar.Size = UDim2.new(1, -20, 0, 6)
			SliderBar.Position = UDim2.new(0, 10, 1, -15)
			SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			SliderBar.BorderSizePixel = 0
			SliderBar.Parent = SliderFrame

			local SliderBarCorner = Instance.new("UICorner")
			SliderBarCorner.CornerRadius = UDim.new(1, 0)
			SliderBarCorner.Parent = SliderBar

			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBar

			local SliderFillCorner = Instance.new("UICorner")
			SliderFillCorner.CornerRadius = UDim.new(1, 0)
			SliderFillCorner.Parent = SliderFill

			local dragging = false

			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			SliderBar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					sliderValue = math.floor(min + (max - min) * pos)
					SliderValue.Text = tostring(sliderValue)
					Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
					callback(sliderValue)
				end
			end)

			return {
				Set = function(value)
					sliderValue = math.clamp(value, min, max)
					SliderValue.Text = tostring(sliderValue)
					local pos = (sliderValue - min) / (max - min)
					Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
					callback(sliderValue)
				end
			}
		end

		-- Add Dropdown
		function tab:AddDropdown(config)
			config = config or {}
			local dropdownText = config.Name or "Dropdown"
			local options = config.Options or {"Option 1", "Option 2"}
			local default = config.Default or options[1]
			local callback = config.Callback or function() end

			local selectedOption = default
			local dropdownOpen = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = "Dropdown"
			DropdownFrame.Size = UDim2.new(1, -8, 0, 35)
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = TabContent

			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 6)
			DropdownCorner.Parent = DropdownFrame

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Size = UDim2.new(1, 0, 0, 35)
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Text = ""
			DropdownButton.Parent = DropdownFrame

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Size = UDim2.new(1, -40, 0, 35)
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = dropdownText .. ": " .. selectedOption
			DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownLabel.TextSize = 14
			DropdownLabel.Font = Enum.Font.Gotham
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Parent = DropdownFrame

			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 0, 35)
			Arrow.Position = UDim2.new(1, -30, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "▼"
			Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
			Arrow.TextSize = 12
			Arrow.Font = Enum.Font.Gotham
			Arrow.Parent = DropdownFrame

			local OptionsList = Instance.new("Frame")
			OptionsList.Size = UDim2.new(1, 0, 0, 0)
			OptionsList.Position = UDim2.new(0, 0, 0, 35)
			OptionsList.BackgroundTransparency = 1
			OptionsList.Parent = DropdownFrame

			local OptionsLayout = Instance.new("UIListLayout")
			OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
			OptionsLayout.Parent = OptionsList

			for _, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Size = UDim2.new(1, 0, 0, 30)
				OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
				OptionButton.Text = option
				OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
				OptionButton.TextSize = 13
				OptionButton.Font = Enum.Font.Gotham
				OptionButton.BorderSizePixel = 0
				OptionButton.Parent = OptionsList

				OptionButton.MouseEnter:Connect(function()
					Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.2)
				end)

				OptionButton.MouseLeave:Connect(function()
					Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, 0.2)
				end)

				OptionButton.MouseButton1Click:Connect(function()
					selectedOption = option
					DropdownLabel.Text = dropdownText .. ": " .. selectedOption
					dropdownOpen = false
					Tween(DropdownFrame, {Size = UDim2.new(1, -8, 0, 35)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
					callback(selectedOption)
				end)
			end

			DropdownButton.MouseButton1Click:Connect(function()
				dropdownOpen = not dropdownOpen
				if dropdownOpen then
					local totalHeight = 35 + (#options * 30)
					Tween(DropdownFrame, {Size = UDim2.new(1, -8, 0, totalHeight)}, 0.3)
					Tween(Arrow, {Rotation = 180}, 0.3)
				else
					Tween(DropdownFrame, {Size = UDim2.new(1, -8, 0, 35)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
				end
			end)

			return {
				Set = function(value)
					if table.find(options, value) then
						selectedOption = value
						DropdownLabel.Text = dropdownText .. ": " .. selectedOption
						callback(selectedOption)
					end
				end
			}
		end

		-- Add TextBox
		function tab:AddTextBox(config)
			config = config or {}
			local textboxText = config.Name or "TextBox"
			local default = config.Default or ""
			local placeholder = config.Placeholder or "Enter text..."
			local callback = config.Callback or function() end

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Name = "TextBox"
			TextBoxFrame.Size = UDim2.new(1, -8, 0, 60)
			TextBoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			TextBoxFrame.BorderSizePixel = 0
			TextBoxFrame.Parent = TabContent

			local TextBoxCorner = Instance.new("UICorner")
			TextBoxCorner.CornerRadius = UDim.new(0, 6)
			TextBoxCorner.Parent = TextBoxFrame

			local TextBoxLabel = Instance.new("TextLabel")
			TextBoxLabel.Size = UDim2.new(1, -20, 0, 20)
			TextBoxLabel.Position = UDim2.new(0, 10, 0, 5)
			TextBoxLabel.BackgroundTransparency = 1
			TextBoxLabel.Text = textboxText
			TextBoxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBoxLabel.TextSize = 14
			TextBoxLabel.Font = Enum.Font.Gotham
			TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextBoxLabel.Parent = TextBoxFrame

			local TextBox = Instance.new("TextBox")
			TextBox.Size = UDim2.new(1, -20, 0, 25)
			TextBox.Position = UDim2.new(0, 10, 1, -30)
			TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			TextBox.Text = default
			TextBox.PlaceholderText = placeholder
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			TextBox.TextSize = 13
			TextBox.Font = Enum.Font.Gotham
			TextBox.BorderSizePixel = 0
			TextBox.ClearTextOnFocus = false
			TextBox.Parent = TextBoxFrame

			local TextBoxInnerCorner = Instance.new("UICorner")
			TextBoxInnerCorner.CornerRadius = UDim.new(0, 4)
			TextBoxInnerCorner.Parent = TextBox

			TextBox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					callback(TextBox.Text)
				end
			end)

			return {
				Set = function(value)
					TextBox.Text = value
					callback(value)
				end
			}
		end

		-- Add Label
		function tab:AddLabel(config)
			config = config or {}
			local labelText = config.Text or "Label"

			local Label = Instance.new("TextLabel")
			Label.Name = "Label"
			Label.Size = UDim2.new(1, -8, 0, 30)
			Label.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			Label.Text = labelText
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.Font = Enum.Font.Gotham
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.BorderSizePixel = 0
			Label.Parent = TabContent

			local LabelPadding = Instance.new("UIPadding")
			LabelPadding.PaddingLeft = UDim.new(0, 10)
			LabelPadding.Parent = Label

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = Label

			return {
				Set = function(text)
					Label.Text = text
				end
			}
		end

		-- Add Keybind
		function tab:AddKeybind(config)
			config = config or {}
			local keybindText = config.Name or "Keybind"
			local default = config.Default or Enum.KeyCode.E
			local callback = config.Callback or function() end

			local currentKey = default
			local selecting = false

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Name = "Keybind"
			KeybindFrame.Size = UDim2.new(1, -8, 0, 35)
			KeybindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Parent = TabContent

			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 6)
			KeybindCorner.Parent = KeybindFrame

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
			KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Text = keybindText
			KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindLabel.TextSize = 14
			KeybindLabel.Font = Enum.Font.Gotham
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.Parent = KeybindFrame

			local KeybindButton = Instance.new("TextButton")
			KeybindButton.Size = UDim2.new(0, 60, 0, 25)
			KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
			KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			KeybindButton.Text = currentKey.Name
			KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeybindButton.TextSize = 12
			KeybindButton.Font = Enum.Font.Gotham
			KeybindButton.BorderSizePixel = 0
			KeybindButton.Parent = KeybindFrame

			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
			KeybindButtonCorner.Parent = KeybindButton

			KeybindButton.MouseButton1Click:Connect(function()
				selecting = true
				KeybindButton.Text = "..."
				KeybindButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if selecting and input.UserInputType == Enum.UserInputType.Keyboard then
					currentKey = input.KeyCode
					KeybindButton.Text = currentKey.Name
					KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
					selecting = false
				elseif not gameProcessed and input.KeyCode == currentKey then
					callback()
				end
			end)

			return {
				Set = function(key)
					currentKey = key
					KeybindButton.Text = currentKey.Name
				end
			}
		end

		-- Add ColorPicker
		function tab:AddColorPicker(config)
			config = config or {}
			local pickerText = config.Name or "Color Picker"
			local default = config.Default or Color3.fromRGB(255, 255, 255)
			local callback = config.Callback or function() end

			local currentColor = default

			local PickerFrame = Instance.new("Frame")
			PickerFrame.Name = "ColorPicker"
			PickerFrame.Size = UDim2.new(1, -8, 0, 35)
			PickerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			PickerFrame.BorderSizePixel = 0
			PickerFrame.Parent = TabContent

			local PickerCorner = Instance.new("UICorner")
			PickerCorner.CornerRadius = UDim.new(0, 6)
			PickerCorner.Parent = PickerFrame

			local PickerLabel = Instance.new("TextLabel")
			PickerLabel.Size = UDim2.new(1, -70, 1, 0)
			PickerLabel.Position = UDim2.new(0, 10, 0, 0)
			PickerLabel.BackgroundTransparency = 1
			PickerLabel.Text = pickerText
			PickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			PickerLabel.TextSize = 14
			PickerLabel.Font = Enum.Font.Gotham
			PickerLabel.TextXAlignment = Enum.TextXAlignment.Left
			PickerLabel.Parent = PickerFrame

			local ColorDisplay = Instance.new("TextButton")
			ColorDisplay.Size = UDim2.new(0, 50, 0, 25)
			ColorDisplay.Position = UDim2.new(1, -60, 0.5, -12.5)
			ColorDisplay.BackgroundColor3 = currentColor
			ColorDisplay.Text = ""
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = PickerFrame

			local ColorDisplayCorner = Instance.new("UICorner")
			ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
			ColorDisplayCorner.Parent = ColorDisplay

			ColorDisplay.MouseButton1Click:Connect(function()
				-- Simple color randomizer for demonstration
				currentColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
				ColorDisplay.BackgroundColor3 = currentColor
				callback(currentColor)
			end)

			return {
				Set = function(color)
					currentColor = color
					ColorDisplay.BackgroundColor3 = currentColor
					callback(currentColor)
				end
			}
		end

		-- Add Section
		function tab:AddSection(config)
			config = config or {}
			local sectionText = config.Name or "Section"

			local Section = Instance.new("Frame")
			Section.Name = "Section"
			Section.Size = UDim2.new(1, -8, 0, 25)
			Section.BackgroundTransparency = 1
			Section.BorderSizePixel = 0
			Section.Parent = TabContent

			local SectionLabel = Instance.new("TextLabel")
			SectionLabel.Size = UDim2.new(1, 0, 1, 0)
			SectionLabel.BackgroundTransparency = 1
			SectionLabel.Text = sectionText
			SectionLabel.TextColor3 = Color3.fromRGB(70, 130, 255)
			SectionLabel.TextSize = 16
			SectionLabel.Font = Enum.Font.GothamBold
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
			SectionLabel.Parent = Section

			local Divider = Instance.new("Frame")
			Divider.Size = UDim2.new(1, 0, 0, 2)
			Divider.Position = UDim2.new(0, 0, 1, -2)
			Divider.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
			Divider.BorderSizePixel = 0
			Divider.Parent = Section
		end

		return tab
	end

	-- Notifications
	function window:Notify(config)
		config = config or {}
		local title = config.Title or "Notification"
		local content = config.Content or "This is a notification"
		local duration = config.Duration or 3

		local NotifFrame = Instance.new("Frame")
		NotifFrame.Size = UDim2.new(0, 0, 0, 80)
		NotifFrame.Position = UDim2.new(1, -20, 1, -100)
		NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		NotifFrame.BorderSizePixel = 0
		NotifFrame.Parent = ScreenGui

		local NotifCorner = Instance.new("UICorner")
		NotifCorner.CornerRadius = UDim.new(0, 8)
		NotifCorner.Parent = NotifFrame

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Size = UDim2.new(1, -20, 0, 25)
		NotifTitle.Position = UDim2.new(0, 10, 0, 10)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = title
		NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifTitle.TextSize = 15
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.TextTransparency = 1
		NotifTitle.Parent = NotifFrame

		local NotifContent = Instance.new("TextLabel")
		NotifContent.Size = UDim2.new(1, -20, 0, 35)
		NotifContent.Position = UDim2.new(0, 10, 0, 35)
		NotifContent.BackgroundTransparency = 1
		NotifContent.Text = content
		NotifContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		NotifContent.TextSize = 13
		NotifContent.Font = Enum.Font.Gotham
		NotifContent.TextXAlignment = Enum.TextXAlignment.Left
		NotifContent.TextYAlignment = Enum.TextYAlignment.Top
		NotifContent.TextWrapped = true
		NotifContent.TextTransparency = 1
		NotifContent.Parent = NotifFrame

		Tween(NotifFrame, {Size = UDim2.new(0, 300, 0, 80), Position = UDim2.new(1, -320, 1, -100)}, 0.5)
		Tween(NotifTitle, {TextTransparency = 0}, 0.5)
		Tween(NotifContent, {TextTransparency = 0}, 0.5)

		wait(duration)

		Tween(NotifFrame, {Size = UDim2.new(0, 0, 0, 80), Position = UDim2.new(1, -20, 1, -100)}, 0.5)
		Tween(NotifTitle, {TextTransparency = 1}, 0.5)
		Tween(NotifContent, {TextTransparency = 1}, 0.5)

		wait(0.5)
		NotifFrame:Destroy()
	end

	-- Toggle Window Visibility
	function window:Toggle()
		MainFrame.Visible = not MainFrame.Visible
	end

	-- Destroy Window
	function window:Destroy()
		ScreenGui:Destroy()
	end

	return window
end

return Library
