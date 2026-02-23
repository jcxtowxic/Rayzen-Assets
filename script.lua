local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- [ LINKS GITHUB - RAYZEN ASSETS ]
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
    else
        return ""
    end
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
ScreenGui.Name = "RayzenMenu_Final"

-- Botão Flutuante
local FloatingBtn = Instance.new("ImageButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 60, 0, 60)
FloatingBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
FloatingBtn.BackgroundTransparency = 1
FloatingBtn.Image = IconAsset
FloatingBtn.Draggable = true

-- Janela Principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundTransparency = 1 
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

-- Imagem de Fundo (menu.png)
local BgImg = Instance.new("ImageLabel", MainFrame)
BgImg.Size = UDim2.new(1, 0, 1, 0)
BgImg.BackgroundTransparency = 1
BgImg.Image = MenuAsset
BgImg.ZIndex = 1
Instance.new("UICorner", BgImg)

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 5

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "RAYZEN MENU | TELEPORTE ATUALIZADO"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = "GothamBlack"
Title.TextSize = 14
Title.TextXAlignment = "Left"
Title.BackgroundTransparency = 1
Title.ZIndex = 6

-- Sidebar e Container
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, -60)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.ZIndex = 5
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -145, 1, -65)
Container.Position = UDim2.new(0, 130, 0, 50)
Container.BackgroundTransparency = 1
Container.ZIndex = 5

local Tabs = {}
local function CreateTab(name)
    local sc = Instance.new("ScrollingFrame", Container)
    sc.Size = UDim2.new(1, 0, 1, 0)
    sc.BackgroundTransparency = 1
    sc.Visible = false
    sc.ZIndex = 6
    sc.ScrollBarThickness = 0
    sc.BorderSizePixel = 0
    Instance.new("UIListLayout", sc).Padding = UDim.new(0,5)
    
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = "GothamBold"
    btn.TextSize = 10
    btn.ZIndex = 6
    Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        for i, v in pairs(Tabs) do v.Visible = (i == name) end
    end)
    Tabs[name] = sc
    return sc
end

local MoveTab = CreateTab("MOVIMENTO")
local ProtTab = CreateTab("PROTEÇÃO")
local TPTab = CreateTab("TELEPORT")
Tabs["MOVIMENTO"].Visible = true

-- Funções Visuais
local function Toggle(txt, conf, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = 0.6
    b.ZIndex = 7
    b.Text = txt .. ": OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = "Gotham"
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        JCx_Settings[conf] = not JCx_Settings[conf]
        b.Text = txt .. ": " .. (JCx_Settings[conf] and "ON" or "OFF")
        b.TextColor3 = JCx_Settings[conf] and Color3.fromRGB(0, 255, 255) or Color3.new(1,1,1)
    end)
end

local function Action(txt, parent, func)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    b.BackgroundTransparency = 0.3
    b.ZIndex = 7
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

-- [ CONTEÚDO ]
Toggle("Voo (Fly)", "Fly", MoveTab)
Toggle("Velocidade", "SpeedEnabled", MoveTab)
Toggle("NoClip", "NoClip", MoveTab)
Toggle("Pulo Infinito", "InfJump", MoveTab)

Toggle("Deus (Vida Inf)", "GodMode", ProtTab)
Toggle("Anti-Fling", "AntiFling", ProtTab)

-- ABA TELEPORTE COM SLOT 1 E 2
Action("Salvar Posição 1", TPTab, function() 
    if LocalPlayer.Character then JCx_Settings.SavedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end 
end)
Action("Teleportar Slot 1", TPTab, function() 
    if JCx_Settings.SavedPos1 then LocalPlayer.Character:SetPrimaryPartCFrame(JCx_Settings.SavedPos1) end 
end)
Action("Salvar Posição 2", TPTab, function() 
    if LocalPlayer.Character then JCx_Settings.SavedPos2 = LocalPlayer.Character.HumanoidRootPart.CFrame end 
end)
Action("Teleportar Slot 2", TPTab, function() 
    if JCx_Settings.SavedPos2 then LocalPlayer.Character:SetPrimaryPartCFrame(JCx_Settings.SavedPos2) end 
end)

-- [ LÓGICA CORE ]
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum and JCx_Settings.SpeedEnabled then hum.WalkSpeed = JCx_Settings.SpeedValue end
    if JCx_Settings.NoClip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if JCx_Settings.GodMode and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
    if JCx_Settings.AntiFling and hrp and hum then
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end
    -- Fly
    if JCx_Settings.Fly and hrp and hum then
        if not hrp:FindFirstChild("FlyVel") then
            Instance.new("BodyVelocity", hrp).Name = "FlyVel"
            Instance.new("BodyGyro", hrp).Name = "FlyGyro"
            hrp.FlyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            hrp.FlyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        end
        local flyVec = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyVec = flyVec + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyVec = flyVec - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyVec = flyVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyVec = flyVec + Camera.CFrame.RightVector end
        hrp.FlyVel.Velocity = flyVec.Magnitude > 0 and flyVec.Unit * JCx_Settings.FlySpeed or Vector3.new(0,0,0)
        hrp.FlyGyro.CFrame = Camera.CFrame
    elseif hrp and hrp:FindFirstChild("FlyVel") then
        hrp.FlyVel:Destroy(); hrp.FlyGyro:Destroy()
    end
end)

UserInputService.JumpRequest:Connect(function() 
    if JCx_Settings.InfJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end 
end)

FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
