local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

-- [ LINKS GITHUB ]
local GITHUB_ICON = "https://raw.githubusercontent.com/jcxtowxic/Rayzen-Assets/main/icon.png"
local GITHUB_MENU = "https://raw.githubusercontent.com/jcxtowxic/Rayzen-Assets/main/menu.png"

-- [ SISTEMA DE DOWNLOAD DE ASSETS ]
local function LoadAsset(fileName, url)
    local path = "RayzenData/" .. fileName
    if not isfolder("RayzenData") then makefolder("RayzenData") end
    if not isfile(path) then
        local success, result = pcall(function() return game:HttpGet(url) end)
        if success then writefile(path, result) else warn("Erro ao baixar: " .. fileName) return "" end
    end
    return getcustomasset(path)
end

local IconAsset = LoadAsset("icon.png", GITHUB_ICON)
local MenuAsset = LoadAsset("menu.png", GITHUB_MENU)

-- [ CONFIGURAÇÕES EM MEMÓRIA ]
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

-- [ INTERFACE PRINCIPAL ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RayzenMenu"
ScreenGui.Enabled = true

local FloatingBtn = Instance.new("ImageButton", ScreenGui)
FloatingBtn.Size = UDim2.new(0, 55, 0, 55); FloatingBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
FloatingBtn.BackgroundTransparency = 1; FloatingBtn.Image = IconAsset; FloatingBtn.Draggable = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 320); MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18); MainFrame.Visible = false; MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255)

local BgImg = Instance.new("ImageLabel", MainFrame)
BgImg.Size = UDim2.new(1, 0, 1, 0); BgImg.BackgroundTransparency = 1; BgImg.Image = MenuAsset
BgImg.ZIndex = 0; Instance.new("UICorner", BgImg)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 100, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 40); Sidebar.BackgroundTransparency = 1; Sidebar.ZIndex = 2
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -130, 1, -50); Container.Position = UDim2.new(0, 120, 0, 40); Container.BackgroundTransparency = 1; Container.ZIndex = 2

local Tabs = {}
local function CreateTab(name)
    local sc = Instance.new("ScrollingFrame", Container)
    sc.Size = UDim2.new(1, 0, 1, 0); sc.BackgroundTransparency = 1; sc.Visible = false; sc.ZIndex = 2
    sc.ScrollBarThickness = 2; sc.CanvasSize = UDim2.new(0,0,2,0); sc.BorderSizePixel = 0
    Instance.new("UIListLayout", sc).Padding = UDim.new(0,5)
    Tabs[name] = sc
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 38); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"; btn.TextSize = 11; btn.ZIndex = 3; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() for i, v in pairs(Tabs) do v.Visible = (i == name) end end)
    return sc
end

local MoveTab = CreateTab("MOVIMENTO")
local ProtTab = CreateTab("PROTEÇÃO")
local TPTab = CreateTab("TELEPORT")
Tabs["MOVIMENTO"].Visible = true -- Começa na aba de movimento

-- [ FUNÇÕES UI ]
local function Toggle(txt, conf, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.ZIndex = 3
    b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        JCx_Settings[conf] = not JCx_Settings[conf]
        b.Text = txt .. ": " .. (JCx_Settings[conf] and "ON" or "OFF")
        b.TextColor3 = JCx_Settings[conf] and Color3.fromRGB(0, 170, 255) or Color3.new(1,1,1)
    end)
end

local function Action(txt, parent, func)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = Color3.fromRGB(0, 150, 150); b.ZIndex = 3
    b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

local function InputNumber(txt, placeholder, parent, confKey)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -10, 0, 35); frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); frame.ZIndex = 3; Instance.new("UICorner", frame)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1; label.Text = txt; label.TextColor3 = Color3.new(1,1,1); label.Font = "GothamBold"; label.TextXAlignment = Enum.TextXAlignment.Left; label.ZIndex = 4
    local box = Instance.new("TextBox", frame); box.Size = UDim2.new(0.3, 0, 0.8, 0); box.Position = UDim2.new(0.65, 0, 0.1, 0); box.BackgroundColor3 = Color3.fromRGB(40, 40, 40); box.Text = tostring(JCx_Settings[confKey]); box.PlaceholderText = placeholder; box.TextColor3 = Color3.new(1,1,1); box.ZIndex = 4; Instance.new("UICorner", box)
    box.FocusLost:Connect(function() local num = tonumber(box.Text) if num then JCx_Settings[confKey] = num else box.Text = tostring(JCx_Settings[confKey]) end end)
end

-- [ CONTEÚDO ]
Toggle("Voo (Fly)", "Fly", MoveTab)
Toggle("Speed Hack", "SpeedEnabled", MoveTab)
InputNumber("Valor Speed", "100", MoveTab, "SpeedValue")
Toggle("Atravessar Paredes", "NoClip", MoveTab)
Toggle("Pulo Infinito", "InfJump", MoveTab)

Toggle("Cura Automática", "GodMode", ProtTab)
Toggle("Anti-Tudo (Fling/Ragdoll)", "AntiFling", ProtTab)

Action("Salvar Pos 1", TPTab, function() if LocalPlayer.Character then JCx_Settings.SavedPos1 = LocalPlayer.Character.HumanoidRootPart.CFrame end end)
Action("Teleport Slot 1", TPTab, function() if JCx_Settings.SavedPos1 then LocalPlayer.Character:SetPrimaryPartCFrame(JCx_Settings.SavedPos1) end end)
Action("Salvar Pos 2", TPTab, function() if LocalPlayer.Character then JCx_Settings.SavedPos2 = LocalPlayer.Character.HumanoidRootPart.CFrame end end)
Action("Teleport Slot 2", TPTab, function() if JCx_Settings.SavedPos2 then LocalPlayer.Character:SetPrimaryPartCFrame(JCx_Settings.SavedPos2) end end)

-- [ LÓGICA CORE ]
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum and JCx_Settings.SpeedEnabled then hum.WalkSpeed = JCx_Settings.SpeedValue end
    if JCx_Settings.NoClip then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    
    if JCx_Settings.GodMode and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end

    if JCx_Settings.AntiFling and hum and hrp then
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end

    -- Fly
    if JCx_Settings.Fly and hrp and hum then
        if not hrp:FindFirstChild("FlyVel") then
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        end
        local flyVec = Vector3.new(0, 0, 0)
        local camCF = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyVec = flyVec + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyVec = flyVec - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyVec = flyVec - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyVec = flyVec + camCF.RightVector end
        if flyVec.Magnitude < 0.1 and hum.MoveDirection.Magnitude > 0 then flyVec = hum.MoveDirection; flyVec = Vector3.new(flyVec.X, camCF.LookVector.Y, flyVec.Z) end
        hrp.FlyVel.Velocity = flyVec.Magnitude > 0 and flyVec.Unit * JCx_Settings.FlySpeed or Vector3.new(0,0,0)
        hrp.FlyGyro.CFrame = camCF
    elseif hrp and hrp:FindFirstChild("FlyVel") then
        hrp.FlyVel:Destroy(); hrp.FlyGyro:Destroy()
    end
end)

-- [ PULO INFINITO ]
UserInputService.JumpRequest:Connect(function() 
    if JCx_Settings.InfJump and LocalPlayer.Character then 
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
    end 
end)

FloatingBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
