# 🎨 Roblox UI Library

A modern, feature-rich UI library for Roblox with smooth animations and a clean dark theme.

## 📦 Installation

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()
```

## 🚀 Quick Start

```lua
-- Create a window
local Window = Library:CreateWindow({
    Name = "My Script Hub",
    Size = UDim2.new(0, 550, 0, 400)
})

-- Create a tab
local Tab = Window:CreateTab("Main")

-- Add elements
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Clicked!")
    end
})
```

---

## 📚 API Reference

### Library

#### `Library:CreateWindow(config)`
Creates a new window instance.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Window title (default: "UI Library")
  - `Size` (UDim2, optional) - Window size (default: UDim2.new(0, 550, 0, 400))

**Returns:** `Window` object

**Example:**
```lua
local Window = Library:CreateWindow({
    Name = "My Script",
    Size = UDim2.new(0, 600, 0, 450)
})
```

---

### Window

#### `Window:CreateTab(tabName)`
Creates a new tab in the window.

**Parameters:**
- `tabName` (string) - Name of the tab

**Returns:** `Tab` object

**Example:**
```lua
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")
```

---

#### `Window:Notify(config)`
Displays a notification popup.

**Parameters:**
- `config` (table)
  - `Title` (string, optional) - Notification title (default: "Notification")
  - `Content` (string, optional) - Notification message (default: "This is a notification")
  - `Duration` (number, optional) - Display duration in seconds (default: 3)

**Example:**
```lua
Window:Notify({
    Title = "Success",
    Content = "Script loaded successfully!",
    Duration = 5
})
```

---

#### `Window:Toggle()`
Toggles the window visibility on/off.

**Example:**
```lua
Window:Toggle()
```

---

#### `Window:Destroy()`
Destroys the window and removes it from the screen.

**Example:**
```lua
Window:Destroy()
```

---

### Tab

#### `Tab:AddButton(config)`
Adds a clickable button to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Button text (default: "Button")
  - `Callback` (function, optional) - Function to execute on click

**Returns:** `Button` instance

**Example:**
```lua
Tab:AddButton({
    Name = "Execute Script",
    Callback = function()
        print("Script executed!")
    end
})
```

---

#### `Tab:AddToggle(config)`
Adds a toggle switch to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Toggle label (default: "Toggle")
  - `Default` (boolean, optional) - Initial state (default: false)
  - `Callback` (function, optional) - Function to execute on state change, receives `value` (boolean)

**Returns:** `Toggle` object with methods:
- `Set(value)` - Programmatically set toggle state

**Example:**
```lua
local Toggle = Tab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(value)
        print("ESP:", value)
    end
})

-- Set programmatically
Toggle:Set(true)
```

---

#### `Tab:AddSlider(config)`
Adds a slider to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Slider label (default: "Slider")
  - `Min` (number, optional) - Minimum value (default: 0)
  - `Max` (number, optional) - Maximum value (default: 100)
  - `Default` (number, optional) - Initial value (default: Min)
  - `Callback` (function, optional) - Function to execute on value change, receives `value` (number)

**Returns:** `Slider` object with methods:
- `Set(value)` - Programmatically set slider value

**Example:**
```lua
local Slider = Tab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Set programmatically
Slider:Set(50)
```

---

#### `Tab:AddDropdown(config)`
Adds a dropdown menu to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Dropdown label (default: "Dropdown")
  - `Options` (table, optional) - Array of option strings (default: {"Option 1", "Option 2"})
  - `Default` (string, optional) - Initially selected option (default: first option)
  - `Callback` (function, optional) - Function to execute on selection change, receives `selectedOption` (string)

**Returns:** `Dropdown` object with methods:
- `Set(value)` - Programmatically set selected option

**Example:**
```lua
local Dropdown = Tab:AddDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Bow", "Staff"},
    Default = "Sword",
    Callback = function(option)
        print("Selected:", option)
    end
})

-- Set programmatically
Dropdown:Set("Bow")
```

---

#### `Tab:AddTextBox(config)`
Adds a text input field to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - TextBox label (default: "TextBox")
  - `Default` (string, optional) - Initial text value (default: "")
  - `Placeholder` (string, optional) - Placeholder text (default: "Enter text...")
  - `Callback` (function, optional) - Function to execute when Enter is pressed, receives `text` (string)

**Returns:** `TextBox` object with methods:
- `Set(value)` - Programmatically set text value

**Example:**
```lua
local TextBox = Tab:AddTextBox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter player name...",
    Callback = function(text)
        print("Entered:", text)
    end
})

-- Set programmatically
TextBox:Set("NewName")
```

---

#### `Tab:AddLabel(config)`
Adds a text label to the tab.

**Parameters:**
- `config` (table)
  - `Text` (string, optional) - Label text (default: "Label")

**Returns:** `Label` object with methods:
- `Set(text)` - Update label text

**Example:**
```lua
local Label = Tab:AddLabel({
    Text = "Version: 1.0.0"
})

-- Update text
Label:Set("Version: 1.0.1")
```

---

#### `Tab:AddKeybind(config)`
Adds a keybind selector to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Keybind label (default: "Keybind")
  - `Default` (Enum.KeyCode, optional) - Initial key (default: Enum.KeyCode.E)
  - `Callback` (function, optional) - Function to execute when key is pressed

**Returns:** `Keybind` object with methods:
- `Set(keyCode)` - Programmatically set keybind

**Example:**
```lua
local Keybind = Tab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:Toggle()
    end
})

-- Set programmatically
Keybind:Set(Enum.KeyCode.LeftControl)
```

---

#### `Tab:AddColorPicker(config)`
Adds a color picker to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Color picker label (default: "Color Picker")
  - `Default` (Color3, optional) - Initial color (default: Color3.fromRGB(255, 255, 255))
  - `Callback` (function, optional) - Function to execute on color change, receives `color` (Color3)

**Returns:** `ColorPicker` object with methods:
- `Set(color)` - Programmatically set color

**Example:**
```lua
local ColorPicker = Tab:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})

-- Set programmatically
ColorPicker:Set(Color3.fromRGB(0, 255, 0))
```

> **Note:** The current color picker uses a simple randomizer for demonstration. Click the color box to randomize the color.

---

#### `Tab:AddSection(config)`
Adds a visual section divider to the tab.

**Parameters:**
- `config` (table)
  - `Name` (string, optional) - Section title (default: "Section")

**Example:**
```lua
Tab:AddSection({
    Name = "Movement Settings"
})
```

---

## 🎯 Complete Example

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()

-- Create window
local Window = Library:CreateWindow({
    Name = "Script Hub v1.0",
    Size = UDim2.new(0, 550, 0, 400)
})

-- Create tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- Main Tab Elements
MainTab:AddSection({Name = "Player"})

MainTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

MainTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

MainTab:AddSection({Name = "Teleports"})

MainTab:AddDropdown({
    Name = "Select Location",
    Options = {"Spawn", "Shop", "Arena"},
    Callback = function(v)
        print("Teleporting to:", v)
    end
})

-- Settings Tab Elements
SettingsTab:AddToggle({
    Name = "UI Notifications",
    Default = true,
    Callback = function(v)
        print("Notifications:", v)
    end
})

local UIKeybind = SettingsTab:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:Toggle()
    end
})

SettingsTab:AddLabel({
    Text = "Made with ❤️"
})

-- Show notification
Window:Notify({
    Title = "Script Loaded",
    Content = "Welcome to Script Hub!",
    Duration = 3
})
```

---

## 🎨 Features

- ✨ Smooth animations with TweenService
- 🎯 Draggable windows
- 🌙 Modern dark theme
- 📱 Clean, intuitive interface
- 🔧 Fully customizable
- 💾 All elements return objects for programmatic control
- 🎭 Hover effects on all interactive elements
- 📊 Scrollable tab content

---

## 📝 Notes

- All callbacks are optional
- All configuration tables are optional with sensible defaults
- Elements can be controlled programmatically after creation
- Window is draggable by the title bar
- Close button smoothly destroys the UI

---

## 🤝 Contributing

Feel free to modify and improve this library for your own projects!

---

## ⚠️ Disclaimer

This library is for educational purposes. Use responsibly and follow Roblox Terms of Service.

---

## 📄 License

Free to use and modify.
