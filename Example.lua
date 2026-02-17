-- New example script written by wally
-- You can suggest changes with a pull request or something

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/j1scxxz-sketch/LinoriaLib/refs/heads/main/Library.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/j1scxxz-sketch/LinoriaLib/refs/heads/main/SaveManager.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/j1scxxz-sketch/LinoriaLib/refs/heads/main/ThemeManager.lua'))()

Library.ItemViewer = {
    Enabled = false;
    CurrentItem = 'Sword';
    Transparency = 0;
    Reflectance = 0;
    Speed = 10;
    Size = 0.05;
    Material = Enum.Material.SmoothPlastic;
}

function Library:CreateItemPart(itemName)
    local model = Instance.new('Model')
    local col = Library.AccentColor
    local mat = Library.ItemViewer.Material
    local refl = Library.ItemViewer.Reflectance
    local trans = Library.ItemViewer.Transparency

    local function makeMesh(meshId, scale, cf)
        local p = Instance.new('Part')
        p.Anchored = true
        p.CanCollide = false
        p.Size = Vector3.new(1, 1, 1)
        p.CFrame = cf or CFrame.new(0, 0, 0)
        p.Color = col
        p.Material = mat
        p.Reflectance = refl
        p.Transparency = trans
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.CastShadow = false
        p.Parent = model

        local mesh = Instance.new('SpecialMesh')
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = meshId
        mesh.TextureId = ''
        mesh.Scale = scale
        mesh.Parent = p
        return p
    end

local s = Library.ItemViewer.Size

    if itemName == 'Sword' then
        makeMesh(
            'rbxassetid://73707751829630',
            Vector3.new(s, s, s),
            CFrame.new(0, 0, 0)
        )

    elseif itemName == 'Heart' then
        makeMesh(
            'rbxassetid://431221919',
            Vector3.new(s, s, s),
            CFrame.new(0, 0, 0)
        )

    elseif itemName == 'Cross' then
        makeMesh(
            'rbxassetid://6599243360',
            Vector3.new(s, s, s),
            CFrame.new(0, 0, 0)
        )

    elseif itemName == 'Catholic Cross' then
        makeMesh(
            'rbxassetid://6599243453',
            Vector3.new(s, s, s),
            CFrame.new(0, 0, 0)
        )
    end

    return model
end

function Library:SetupItemViewer()
    if Library.ItemViewerFrame then
        Library.ItemViewerFrame:Destroy()
        Library.ItemViewerFrame = nil
        Library.ItemViewerSpinning = false
    end

    local size = 200

    local Frame = Instance.new('Frame')
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
    Frame.Size = UDim2.fromOffset(size, size)
    Frame.ZIndex = 5
    Frame.Visible = false
    Frame.Parent = Library.ScreenGui

    local VP = Instance.new('ViewportFrame')
    VP.BackgroundTransparency = 1
    VP.BorderSizePixel = 0
    VP.Size = UDim2.new(1, 0, 1, 0)
    VP.ZIndex = 6
    VP.LightColor = Color3.new(1, 1, 1)
    VP.LightDirection = Vector3.new(-1, -2, -1)
    VP.Ambient = Color3.fromRGB(220, 220, 220)
    VP.Parent = Frame

    local Camera = Instance.new('Camera')
    Camera.CFrame = CFrame.new(Vector3.new(0, 0, 6), Vector3.new(0, 0, 0))
    Camera.FieldOfView = 45
    Camera.Parent = VP
    VP.CurrentCamera = Camera

    Library.ItemViewerFrame = Frame
    Library.ItemViewerVP = VP
    Library.ItemViewerCamera = Camera

    Library:RefreshItemViewer()
end

function Library:RefreshItemViewer()
    if not Library.ItemViewerVP then return end

    for _, v in next, Library.ItemViewerVP:GetChildren() do
        if v:IsA('Model') or v:IsA('BasePart') then
            v:Destroy()
        end
    end

    local model = Library:CreateItemPart(Library.ItemViewer.CurrentItem)
    model.Parent = Library.ItemViewerVP

    for _, p in next, model:GetDescendants() do
        if p:IsA('BasePart') then
            p.Color = Library.AccentColor
            p.Material = Library.ItemViewer.Material
            p.Reflectance = Library.ItemViewer.Reflectance
            p.Transparency = Library.ItemViewer.Transparency
        end
    end

    if not Library.ItemViewerSpinning then
        Library.ItemViewerSpinning = true
        task.spawn(function()
            local angle = 0
            while Library.ItemViewerSpinning and Library.ItemViewerVP and Library.ItemViewerVP.Parent do
                if Library.ItemViewerFrame and Library.ItemViewerFrame.Visible then
                    angle = angle + Library.ItemViewer.Speed * 0.5
                    local rad = math.rad(angle)
                    for _, p in next, Library.ItemViewerVP:GetDescendants() do
                        if p:IsA('BasePart') then
                            p.Color = Library.AccentColor
                        end
                    end
                    Library.ItemViewerCamera.CFrame = CFrame.new(
                        Vector3.new(math.sin(rad) * 6, 1, math.cos(rad) * 6),
                        Vector3.new(0, 0, 0)
                    )
                end
                task.wait(0.016)
            end
            Library.ItemViewerSpinning = false
        end)
    end
end

function Library:ShowItemViewer()
    if Library.ItemViewerFrame then
        Library.ItemViewerFrame.Visible = true
    end
end

function Library:HideItemViewer()
    if Library.ItemViewerFrame then
        Library.ItemViewerFrame.Visible = false
    end
end

function Library:UpdateItemViewerParts()
    if not Library.ItemViewerVP then return end
    for _, p in next, Library.ItemViewerVP:GetDescendants() do
        if p:IsA('BasePart') then
            p.Color = Library.AccentColor
            p.Material = Library.ItemViewer.Material
            p.Reflectance = Library.ItemViewer.Reflectance
            p.Transparency = Library.ItemViewer.Transparency
        end
    end
end

local Window = Library:CreateWindow({
    -- Set Centerf to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Hello from modded linoria boy',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- CALLBACK NOTE:
-- Passing in callback functions via the initial element parameters (i.e. Callback = function(Value)...) works
-- HOWEVER, using Toggles/Options.INDEX:OnChanged(function(Value) ... ) is the RECOMMENDED way to do this.
-- I strongly recommend decoupling UI code from logic code. i.e. Create your UI elements FIRST, and THEN setup :OnChanged functions later.

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Groupbox')

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox('Groupbox')

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle('MyToggle', {
    Text = 'This is a toggle',
    Default = true, -- Default value (true / false)
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

-- Regular Toggle
LeftGroupBox:AddToggle('MyToggle', {
    Text = 'This is a normal toggle',
    Default = true,
    Tooltip = 'This is a tooltip',
    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})

-- Risky Toggle
LeftGroupBox:AddToggle('MyRiskyToggle', {
    Text = 'This is a risky toggle',
    Default = false,
    Tooltip = 'This toggle does something dangerous!',
    Risky = true, -- Makes the text red
    Callback = function(Value)
        print('[cb] MyRiskyToggle changed to:', Value)
    end
})

LeftGroupBox:AddMultiSlider('RangeSlider', {
    Text = 'Value Range',
    Default = { Min = 25, Max = 75 },
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Values)
        print('Min:', Values.Min, 'Max:', Values.Max)
    end
})

LeftGroupBox:AddDualSlider('SpeedSlider', 'JumpSlider', {
    Text = 'Speed',
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '',
    Callback = function(Value)
        -- handle speed change
    end
}, {
    Text = 'Jump',
    Default = 50,
    Min = 0,
    Max = 200,
    Rounding = 0,
    Suffix = '',
    Callback = function(Value)
        -- handle jump change
    end
})

-- Fetching a toggle object for later use:
-- Toggles.MyToggle.Value

-- Toggles is a table added to getgenv() by the library
-- You index Toggles with the specified index, in this case it is 'MyToggle'
-- To get the state of the toggle you do toggle.Value

-- Calls the passed function when the toggle is updated
Toggles.MyToggle:OnChanged(function()
    -- here we get our toggle object & then get its value
    print('MyToggle changed to:', Toggles.MyToggle.Value)
end)

-- This should print to the console: "My toggle state changed! New value: false"
Toggles.MyToggle:SetValue(false)

-- 1/15/23
-- Deprecated old way of creating buttons in favor of using a table
-- Added DoubleClick button functionality

--[[
    Groupbox:AddButton
    Arguments: {
        Text = string,
        Func = function,
        DoubleClick = boolean
        Tooltip = string,
    }

    You can call :AddButton on a button to add a SubButton!
]]

local MyButton = LeftGroupBox:AddButton({
    Text = 'Button',
    Func = function()
        print('You clicked a button!')
    end,
    DoubleClick = false,
    Tooltip = 'This is the main button'
})

local MyButton2 = MyButton:AddButton({
    Text = 'Sub button',
    Func = function()
        print('You clicked a sub button!')
    end,
    DoubleClick = true, -- You will have to click this button twice to trigger the callback
    Tooltip = 'This is the sub button (double click me!)'
})

--[[
    NOTE: You can chain the button methods!
    EXAMPLE:

    LeftGroupBox:AddButton({ Text = 'Kill all', Func = Functions.KillAll, Tooltip = 'This will kill everyone in the game!' })
        :AddButton({ Text = 'Kick all', Func = Functions.KickAll, Tooltip = 'This will kick everyone in the game!' })
]]

-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap
LeftGroupBox:AddLabel('This is a label')
LeftGroupBox:AddLabel('This is a label\n\nwhich wraps its text!', true)

-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
    Groupbox:AddSlider
    Arguments: Idx, SliderOptions

    SliderOptions: {
        Text = string,
        Default = number,
        Min = number,
        Max = number,
        Suffix = string,
        Rounding = number,
        Compact = boolean,
        HideMax = boolean,
    }

    Text, Default, Min, Max, Rounding must be specified.
    Suffix is optional.
    Rounding is the number of decimal places for precision.

    Compact will hide the title label of the Slider

    HideMax will only display the value instead of the value & max value of the slider
    Compact will do the same thing
]]
LeftGroupBox:AddSlider('MySlider', {
    Text = 'This is my slider!',
    Default = 0,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        print('[cb] MySlider was changed! New value:', Value)
    end
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'MySlider'
-- To get the value of the slider you do slider.Value

local Number = Options.MySlider.Value
Options.MySlider:OnChanged(function()
    print('MySlider was changed! New value:', Options.MySlider.Value)
end)

-- This should print to the console: "MySlider was changed! New value: 3"
Options.MySlider:SetValue(3)



-- Groupbox:AddInput
-- Arguments: Idx, Info
LeftGroupBox:AddInput('MyTextbox', {
    Default = 'My textbox!',
    Numeric = false, -- true / false, only allows numbers
    Finished = false, -- true / false, only calls callback when you press enter

    Text = 'This is a textbox',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the textbox

    Placeholder = 'Placeholder text', -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print('[cb] Text updated. New text:', Value)
    end
})

Options.MyTextbox:OnChanged(function()
    print('Text updated. New text:', Options.MyTextbox.Value)
end)

-- Groupbox:AddDropdown
-- Arguments: Idx, Info

LeftGroupBox:AddDropdown('MyDropdown', {
    Values = { 'This', 'is', 'a', 'dropdown' },
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'A dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Dropdown got changed. New value:', Value)
    end
})

Options.MyDropdown:OnChanged(function()
    print('Dropdown got changed. New value:', Options.MyDropdown.Value)
end)

Options.MyDropdown:SetValue('This')

-- Multi dropdowns
LeftGroupBox:AddDropdown('MyMultiDropdown', {
    -- Default is the numeric index (e.g. "This" would be 1 since it if first in the values list)
    -- Default also accepts a string as well

    -- Currently you can not set multiple values with a dropdown

    Values = { 'This', 'is', 'a', 'dropdown' },
    Default = 1,
    Multi = true, -- true / false, allows multiple choices to be selected

    Text = 'A dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Multi dropdown got changed:', Value)
    end
})

Options.MyMultiDropdown:OnChanged(function()
    -- print('Dropdown got changed. New value:', )
    print('Multi dropdown got changed:')
    for key, value in next, Options.MyMultiDropdown.Value do
        print(key, value) -- should print something like This, true
    end
end)

Options.MyMultiDropdown:SetValue({
    This = true,
    is = true,
})

LeftGroupBox:AddDropdown('MyPlayerDropdown', {
    SpecialType = 'Player',
    Text = 'A player dropdown',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Player dropdown got changed:', Value)
    end
})

-- Label:AddColorPicker
-- Arguments: Idx, Info

-- You can also ColorPicker & KeyPicker to a Toggle as well

LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default = Color3.new(0, 1, 0), -- Bright green
    Title = 'Some color', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        print('[cb] Color changed!', Value)
    end
})

Options.ColorPicker:OnChanged(function()
    print('Color changed!', Options.ColorPicker.Value)
    print('Transparency changed!', Options.ColorPicker.Transparency)
end)

Options.ColorPicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

-- Label:AddKeyPicker
-- Arguments: Idx, Info

LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'MB2', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Toggle', -- Modes: Always, Toggle, Hold

    Text = 'Auto lockpick safes', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        print('[cb] Keybind clicked!', Value)
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print('[cb] Keybind changed!', New)
    end
})

-- OnClick is only fired when you press the keybind and the mode is Toggle
-- Otherwise, you will have to use Keybind:GetState()
Options.KeyPicker:OnClick(function()
    print('Keybind clicked!', Options.KeyPicker:GetState())
end)

Options.KeyPicker:OnChanged(function()
    print('Keybind changed!', Options.KeyPicker.Value)
end)

task.spawn(function()
    while true do
        wait(1)

        -- example for checking if a keybind is being pressed
        local state = Options.KeyPicker:GetState()
        if state then
            print('KeyPicker is being held down')
        end

        if Library.Unloaded then break end
    end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Toggle' }) -- Sets keybind to MB2, mode to Hold

-- Long text label to demonstrate UI scrolling behaviour.
local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox('Groupbox #2');
LeftGroupBox2:AddLabel('Oh no...\nThis label spans multiple lines!\n\nWe\'re gonna run out of UI space...\nJust kidding! Scroll down!\n\n\nHello from below!', true)

local TabBox = Tabs.Main:AddRightTabbox() -- Add Tabbox on right side

-- Anything we can do in a Groupbox, we can do in a Tabbox tab (AddToggle, AddSlider, AddLabel, etc etc...)
local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Tab1 Toggle' });

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Tab2 Toggle' });

-- Dependency boxes let us control the visibility of UI elements depending on another UI elements state.
-- e.g. we have a 'Feature Enabled' toggle, and we only want to show that features sliders, dropdowns etc when it's enabled!
-- Dependency box example:
local RightGroupbox = Tabs.Main:AddRightGroupbox('Groupbox #3');
RightGroupbox:AddToggle('ControlToggle', { Text = 'Dependency box toggle' });

local Depbox = RightGroupbox:AddDependencyBox();
Depbox:AddToggle('DepboxToggle', { Text = 'Sub-dependency box toggle' });

-- We can also nest dependency boxes!
-- When we do this, our SupDepbox automatically relies on the visiblity of the Depbox - on top of whatever additional dependencies we set
local SubDepbox = Depbox:AddDependencyBox();
SubDepbox:AddSlider('DepboxSlider', { Text = 'Slider', Default = 50, Min = 0, Max = 100, Rounding = 0 });
SubDepbox:AddDropdown('DepboxDropdown', { Text = 'Dropdown', Default = 1, Values = {'a', 'b', 'c'} });

Depbox:SetupDependencies({
    { Toggles.ControlToggle, true } -- We can also pass `false` if we only want our features to show when the toggle is off!
});

SubDepbox:SetupDependencies({
    { Toggles.DepboxToggle, true }
});

-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('LinoriaLib demo | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true; -- todo: add a function for this

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

-- DisplayConfig: hook these values into your ESP/HUD system
Library.DisplayConfig = {
    ClipDescendants = false,
    ClipPastDistance = 200,
    ForceColors = {
        Color3.fromRGB(255, 100, 100),
        Color3.fromRGB(100, 255, 100),
        Color3.fromRGB(100, 100, 255),
        Color3.fromRGB(255, 255, 100),
    },
    PosX = 50,
    PosY = 60,
    Transparency = 25,
    Alignment = 'Center',
    BarSide = 'Bottom',
    SortOrder = 'Default',
}

-- Left side: Notifications tabbox
local DisplayTabbox = Tabs['UI Settings']:AddLeftTabbox()
local NotifTab = DisplayTabbox:AddTab('Notifications')

-- Notifications Tab
NotifTab:AddToggle('NotifClipDescendants', {
    Text = 'Clip Descendants',
    Default = false,
    Tooltip = 'Clips notifications to the notification area bounds',
    Callback = function(Value)
        Library.NotificationArea.ClipsDescendants = Value
    end
})

NotifTab:AddLabel('Force Color')
    :AddColorPicker('NotifForceColor1', {
        Default = Color3.fromRGB(255, 100, 100),
        Title = 'Notif Color 1',
        Callback = function(Value)
            -- This color is used as the accent bar on notifications
            Library.NotifAccentColor1 = Value
        end
    })
    :AddColorPicker('NotifForceColor2', {
        Default = Color3.fromRGB(100, 255, 100),
        Title = 'Notif Color 2',
        Callback = function(Value)
            Library.NotifAccentColor2 = Value
        end
    })
    :AddColorPicker('NotifForceColor3', {
        Default = Color3.fromRGB(100, 100, 255),
        Title = 'Notif Color 3',
        Callback = function(Value)
            Library.NotifAccentColor3 = Value
        end
    })
    :AddColorPicker('NotifForceColor4', {
        Default = Color3.fromRGB(255, 255, 100),
        Title = 'Notif Color 4',
        Callback = function(Value)
            Library.NotifAccentColor4 = Value
        end
    })

NotifTab:AddSlider('NotifClipPastDistance', {
    Text = 'Clip Past Distance',
    Default = 200,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Suffix = 'px',
    Callback = function(Value)
        Library.NotificationArea.Size = UDim2.new(0, 300, 0, Value)
    end
})

NotifTab:AddDualSlider('NotifPosX', 'NotifPosY', {
    Text = 'Position X',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Library.NotificationArea.Position = UDim2.new(
            Value / 100,
            0,
            Library.NotificationArea.Position.Y.Scale,
            Library.NotificationArea.Position.Y.Offset
        )
    end
}, {
    Text = 'Position Y',
    Default = 5,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Library.NotificationArea.Position = UDim2.new(
            Library.NotificationArea.Position.X.Scale,
            Library.NotificationArea.Position.X.Offset,
            Value / 100,
            0
        )
    end
})

NotifTab:AddSlider('NotifTransparency', {
    Text = 'Transparency',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Library.NotifBackgroundTransparency = Value / 100
    end
})

NotifTab:AddDropdown('NotifAlignment', {
    Values = { 'Left', 'Center', 'Right' },
    Default = 1,
    Multi = false,
    Text = 'Alignment',
    Callback = function(Value)
        local layout = Library.NotificationArea:FindFirstChildWhichIsA('UIListLayout')
        if layout then
            if Value == 'Left' then
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            elseif Value == 'Center' then
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            elseif Value == 'Right' then
                layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            end
        end
    end
})

NotifTab:AddDropdown('NotifBarSide', {
    Values = { 'Top', 'Bottom', 'Left', 'Right' },
    Default = 3,
    Multi = false,
    Text = 'Bar Side',
    Tooltip = 'Which side the accent color bar appears on notifications',
    Callback = function(Value)
        Library.NotifBarSide = Value
    end
})

NotifTab:AddDropdown('NotifSortOrder', {
    Values = { 'Default', 'Text Length' },
    Default = 1,
    Multi = false,
    Text = 'Sort Order',
    Callback = function(Value)
        Library.NotifSortOrder = Value
        local layout = Library.NotificationArea:FindFirstChildWhichIsA('UIListLayout')
        if layout then
            layout.SortOrder = Value == 'Text Length' 
                and Enum.SortOrder.Name 
                or Enum.SortOrder.LayoutOrder
        end
    end
})

NotifTab:AddDivider()

NotifTab:AddInput('NotifText', {
    Default = 'Hello from LinoriaLib!',
    Numeric = false,
    Finished = false,
    Text = 'Notification Text',
    Placeholder = 'Enter notification text...',
})

NotifTab:AddSlider('NotifDuration', {
    Text = 'Duration (seconds)',
    Default = 3,
    Min = 1,
    Max = 10,
    Rounding = 0,
})

NotifTab:AddButton({
    Text = 'Send Notification',
    Func = function()
        Library:Notify(Options.NotifText.Value, Options.NotifDuration.Value)
    end,
    Tooltip = 'Sends a test notification'
})

-- Right side: Themes + Background (with Glow) tabbox
local ThemeTabbox = Tabs['UI Settings']:AddRightTabbox()
local ThemesTab = ThemeTabbox:AddTab('Themes')
local BackgroundTab = ThemeTabbox:AddTab('Background')

-- Themes Tab
ThemesTab:AddLabel('Main Color'):AddColorPicker('MainColorPicker', {
    Default = Library.MainColor,
    Title = 'Main Color',
    Callback = function(Value)
        Library.MainColor = Value
        Library:UpdateColorsUsingRegistry()
    end
})

ThemesTab:AddLabel('Accent Color'):AddColorPicker('AccentColorPicker', {
    Default = Library.AccentColor,
    Title = 'Accent Color',
    Callback = function(Value)
        Library.AccentColor = Value
        Library.AccentColorDark = Library:GetDarkerColor(Value)
        Library:UpdateColorsUsingRegistry()
    end
})

ThemesTab:AddLabel('Background Color'):AddColorPicker('BackgroundColorPicker', {
    Default = Library.BackgroundColor,
    Title = 'Background Color',
    Callback = function(Value)
        Library.BackgroundColor = Value
        Library:UpdateColorsUsingRegistry()
    end
})

ThemesTab:AddLabel('Outline Color'):AddColorPicker('OutlineColorPicker', {
    Default = Library.OutlineColor,
    Title = 'Outline Color',
    Callback = function(Value)
        Library.OutlineColor = Value
        Library:UpdateColorsUsingRegistry()
    end
})

ThemesTab:AddLabel('Text Color'):AddColorPicker('TextColorPicker', {
    Default = Library.FontColor,
    Title = 'Text Color',
    Callback = function(Value)
        Library.FontColor = Value
        Library:UpdateColorsUsingRegistry()
    end
})

ThemesTab:AddLabel('Risk Text Color'):AddColorPicker('RiskColorPicker', {
    Default = Library.RiskColor,
    Title = 'Risk Text Color',
    Callback = function(Value)
        Library.RiskColor = Value
        Library:UpdateColorsUsingRegistry()
    end
})

-- Background Tab (UI Blur + Glow)
BackgroundTab:AddToggle('UIBlurEnabled', {
    Text = 'UI Blur',
    Default = false,
    Tooltip = 'Applies a blur effect behind the UI',
    Callback = function(Value)
        Library:SetUIBlur(Value, Options.BlurTransparency.Value / 100)
    end
})

BackgroundTab:AddSlider('BlurTransparency', {
    Text = 'Blur Strength',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        if Toggles.UIBlurEnabled.Value then
            Library:SetBlurTransparency(Value / 100)
        end
    end
})


BackgroundTab:AddToggle('ItemViewerEnabled', {
    Text = 'Item Viewer',
    Default = false,
    Tooltip = 'Shows a spinning 3D item when the menu is open',
    Callback = function(Value)
        Library.ItemViewer.Enabled = Value
        if Value then
            if not Library.ItemViewerFrame then
                Library:SetupItemViewer()
            end
            if Library.MenuOpen then
                Library:ShowItemViewer()
            end
        else
            Library:HideItemViewer()
        end
    end
})

BackgroundTab:AddDropdown('ItemViewerItem', {
    Values = { 'Sword', 'Heart', 'Cross', 'Catholic Cross' },
    Default = 1,
    Multi = false,
    Text = 'Item',
    Callback = function(Value)
        Library.ItemViewer.CurrentItem = Value
        Library:RefreshItemViewer()
    end
})

BackgroundTab:AddDropdown('ItemViewerMaterial', {
    Values = { 'SmoothPlastic', 'Neon', 'Metal', 'Glass', 'DiamondPlate', 'Granite', 'Marble' },
    Default = 1,
    Multi = false,
    Text = 'Material',
    Callback = function(Value)
        local matMap = {
            SmoothPlastic = Enum.Material.SmoothPlastic,
            Neon = Enum.Material.Neon,
            Metal = Enum.Material.Metal,
            Glass = Enum.Material.Glass,
            DiamondPlate = Enum.Material.DiamondPlate,
            Granite = Enum.Material.Granite,
            Marble = Enum.Material.Marble,
        }
        Library.ItemViewer.Material = matMap[Value] or Enum.Material.SmoothPlastic
        Library:UpdateItemViewerParts()
    end
})

BackgroundTab:AddDualSlider('ItemTransparency', 'ItemReflectance', {
    Text = 'Transparency',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Library.ItemViewer.Transparency = Value / 100
        Library:UpdateItemViewerParts()
    end
}, {
    Text = 'Reflectance',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Library.ItemViewer.Reflectance = Value / 100
        Library:UpdateItemViewerParts()
    end
})

BackgroundTab:AddSlider('ItemViewerSpeed', {
    Text = 'Spin Speed',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        Library.ItemViewer.Speed = Value
    end
})

BackgroundTab:AddSlider('ItemViewerSize', {
    Text = 'Item Size',
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        Library.ItemViewer.Size = Value / 100
        Library:RefreshItemViewer()
    end
})

-- Addons
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

-- Initialize item viewer (hidden by default, shows when enabled + menu opens)
Library:SetupItemViewer()
