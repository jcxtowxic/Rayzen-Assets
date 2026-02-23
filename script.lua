local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- [ LINKS GITHUB ]
local GITHUB_ICON = "https://raw.githubusercontent.com/jcxtowxic/Rayzen-Assets/main/icon.png"
local GITHUB_MENU = "https://raw.githubusercontent.com/jcxtowxic/Rayzen-Assets/main/menu.png"

-- [ SISTEMA DE DOWNLOAD ]
local function LoadAsset(fileName, url)
    local path = "RayzenData/" .. fileName
    if not isfolder("RayzenData") then makefolder("RayzenData") end
    local success, result = pcall(function() return game:HttpGet(url) end)
    if success and result:len() > 0 then
        writefile(path, result)
        return getcustomasset(path)
    end
    return ""
end

local IconAsset = LoadAsset("icon.png", GITHUB_ICON)
local MenuAsset = LoadAsset("menu.png", GITHUB_MENU)

-- [ CONFIGURAÇÕES ]
local JCx_Settings = {
    NoClip = false,
    GodMode = false,
    InfJump = false,
    Fly = false,
    FlySpeed = 50,
    SpeedEnabled = false,
    SpeedValue = 100,
    AntiFling = false,
    SavedPos1 = nil,
    SavedPos2 = nil
}

-- [ INTERFACE ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RayzenMenu_V4"

-- Botão Flutuante
local FloatingBtn = Instance.new("ImageButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 55, 0, 55); FloatingBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
FloatingBtn.BackgroundTransparency = 1; FloatingBtn.Image = IconAsset; FloatingBtn.Draggable = true

-- Janela Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 320); MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundTransparency = 1; MainFrame.Visible = false; MainFrame.Active = true; MainFrame.Draggable = true

-- Fundo menu.png
local BgImg = Instance.new("ImageLabel", MainFrame)
BgImg.Size = UDim2.new(1, 0, 1, 0); BgImg.BackgroundTransparency = 1; BgImg.Image = MenuAsset; BgImg.ZIndex = 1
Instance.new("UICorner", BgImg)

-- Botão Fechar [X]
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 0.5; CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = "GothamBold"
CloseBtn.ZIndex = 10; Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Sidebar e Container
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1; Sidebar.ZIndex = 5
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -145, 1, -65); Container.Position = UDim2.new(0, 130, 0, 50)
Container.BackgroundTransparency = 1; Container.ZIndex = 5

local Tabs = {}
local function CreateTab(name)
    local sc = Instance.new("ScrollingFrame", Container)
    sc.Size = UDim2.new(1, 0, 1, 0); sc.BackgroundTransparency = 1; sc.Visible = false; sc.ZIndex = 6
    sc.ScrollBarThickness = 2; sc.CanvasSize = UDim2.new(0,0,1.5,0); sc.BorderSizePixel = 0
    Instance.new("UIListLayout", sc).Padding = UDim.new(0,5)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 35); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"; btn.TextSize = 10; btn.ZIndex = 6; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for i, v in pairs(Tabs) do v.Visible = (i == name) end end)
    Tabs[name] = sc
    return sc
end

local MoveTab = CreateTab("MOVIMENTO")
local ProtTab = CreateTab("PROTEÇÃO")
local TPTab = CreateTab("TELEPORT")
Tabs["MOVIMENTO"].Visible = true

-- [ WIDGETS ]
local function Toggle(txt, conf, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(0, 0, 0); b.BackgroundTransparency = 0.6; b.ZIndex = 7
    b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(1, 1, 1); b.Font = "Gotham"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        JCx_Settings[conf] = not JCx_Settings[conf]
        b.Text = txt .. ": " .. (JCx_Settings[conf] and "ON" or "OFF")
        b.TextColor3 = JCx_Settings[conf] and Color3.fromRGB(0, 255, 255) or Color3.new(1,1,1)
    end)
end

local function Slider(txt, min, max, conf, parent)
    local sFrame = Instance.new("Frame", parent)
    sFrame.Size = UDim2.new(1, -10, 0, 45); sFrame.BackgroundTransparency = 0.7; sFrame.BackgroundColor3 = Color3.new(0,0,0); sFrame.ZIndex = 7
    Instance.new("UICorner", sFrame)
    local label = Instance.new("TextLabel", sFrame)
    label.Size = UDim2.new(1, 0, 0.5, 0); label.BackgroundTransparency = 1; label.Text = txt .. ": " .. JCx_Settings[conf]
    label.TextColor3 = Color3.new(1,1,1); label.Font = "Gotham"; label.TextSize = 10; label.ZIndex = 8
    local box = Instance.new("TextBox", sFrame)
    box.Size = UDim2.new(0.8, 0, 0.4, 0); box.Position = UDim2.new(0.1, 0, 0.5, 0); box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.Text = tostring(JCx_Settings[conf]); box.TextColor3 = Color3.new(0, 255, 255); box.ZIndex = 8; Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            JCx_Settings[conf] = math.clamp(val, min, max)
            label.Text = txt .. ": " .. JCx_Settings[conf]
        end
    end)
end

local function Action(txt, parent, func)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(0, 150, 150); b.BackgroundTransparency = 0.3; b.ZIndex = 7
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

-- [ ADICIONANDO FUNÇÕES ]
Toggle("Voo (Fly)", "Fly", MoveTab)
Slider("Velocidade Voo", 1, 500, "FlySpeed", MoveTab)
Toggle("Ativar Speed", "SpeedEnabled", MoveTab)
Slider("Velocidade Walk", 16, 500, "SpeedValue", MoveTab)
Toggle("NoClip", "NoClip", MoveTab)
Toggle("Pulo Infinito", "InfJump", MoveTab)

Toggle("God Mode", "GodMode", ProtTab)
Toggle("Anti-Fling", "AntiFling", ProtTab)

Action("Salvar Posição 1", TPTab, function() if LocalPlayer.Character then JCx_Settings.SavedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end)
Action("Teleportar 1", TPTab, function() if JCx_Settings.SavedPos1 then LocalPlayer.Character.HumanoidRootPart.CFrame = JCx_Settings.SavedPos1 end end)
Action("Salvar Posição 2", TPTab, function() if LocalPlayer.Character then JCx_Settings.SavedPos2 = LocalPlayer.Character.HumanoidRootPart.CFrame end end)
Action("Teleportar 2", TPTab, function() if JCx_Settings.SavedPos2 then LocalPlayer.Character.HumanoidRootPart.CFrame = JCx_Settings.SavedPos2 end end)

-- [ LÓGICA CORE ]
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum and JCx_Settings.SpeedEnabled then hum.WalkSpeed = JCx_Settings.SpeedValue end
    
    if JCx_Settings.NoClip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end

    if JCx_Settings.GodMode and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end

    if JCx_Settings.AntiFling and not JCx_Settings.Fly then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end

    -- FLY FIXADO
    if JCx_Settings.Fly then
        if not hrp:FindFirstChild("FlyVel") then
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        end
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
        hrp.FlyVel.Velocity = move.Magnitude > 0 and move.Unit * JCx_Settings.FlySpeed or Vector3.new(0,0,0)
        hrp.FlyGyro.CFrame = Camera.CFrame
    else
        if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if JCx_Settings.InfJump and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(3) end
    end
end)

FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
