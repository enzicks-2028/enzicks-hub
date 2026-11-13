--[================================================================%]
-- ENZICKS HUB V5.9 - Ultimate Fixed Fly & Liquid Glass FX Edition
--[================================================================%]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Limpar UI anterior
if CoreGui:FindFirstChild("EnzicksHub") then
    CoreGui.EnzicksHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnzicksHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Estados
local infJumpEnabled = false
local noclipEnabled = false
local flyEnabled = false
local spinEnabled = false
local spinSpeed = 25
local espEnabled = false
local aimbotEnabled = false
local aimTargetPart = "Head"
local aimLockStrength = 500
local aimFovRadius = 150

local speedEnabled = false
local speedVal = 16
local speedMethod = "Humanoid"

local jumpEnabled = false
local jumpVal = 50

-- Temas Completos
local Themes = {
    NovaPurple = {
        Main = Color3.fromRGB(18, 16, 26),
        Sidebar = Color3.fromRGB(12, 10, 18),
        Card = Color3.fromRGB(28, 24, 40),
        Accent = Color3.fromRGB(150, 50, 245),
        Text = Color3.fromRGB(240, 235, 255),
        SubText = Color3.fromRGB(150, 140, 175)
    },
    DarkMinimal = {
        Main = Color3.fromRGB(14, 14, 14),
        Sidebar = Color3.fromRGB(8, 8, 8),
        Card = Color3.fromRGB(22, 22, 22),
        Accent = Color3.fromRGB(80, 80, 80),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(140, 140, 140)
    },
    NeonBlue = {
        Main = Color3.fromRGB(10, 18, 28),
        Sidebar = Color3.fromRGB(6, 11, 18),
        Card = Color3.fromRGB(18, 30, 48),
        Accent = Color3.fromRGB(0, 160, 255),
        Text = Color3.fromRGB(220, 240, 255),
        SubText = Color3.fromRGB(140, 175, 200)
    },
    CyberpunkGreen = {
        Main = Color3.fromRGB(12, 22, 16),
        Sidebar = Color3.fromRGB(7, 14, 10),
        Card = Color3.fromRGB(20, 36, 26),
        Accent = Color3.fromRGB(0, 230, 115),
        Text = Color3.fromRGB(220, 255, 235),
        SubText = Color3.fromRGB(130, 180, 150)
    }
}
local currentTheme = Themes.NovaPurple

-- Círculo FOV
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = false
FovCircle.Transparency = 0.6
FovCircle.Thickness = 1.5
FovCircle.Color = currentTheme.Accent
FovCircle.NumSides = 64
FovCircle.Radius = aimFovRadius
FovCircle.Filled = false

-- ==================== JANELA PRINCIPAL ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -180)
MainFrame.BackgroundColor3 = currentTheme.Main
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = currentTheme.Accent
MainStroke.Transparency = 0.3
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = currentTheme.Main
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 2)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "ENZICKS HUB"
TitleLabel.TextColor3 = currentTheme.Text
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Size = UDim2.new(0, 250, 0, 15)
SubTitleLabel.Position = UDim2.new(0, 16, 0, 24)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Font = Enum.Font.Gotham
SubTitleLabel.Text = "V5.9 - liquid glass fx"
SubTitleLabel.TextColor3 = currentTheme.SubText
SubTitleLabel.TextSize = 10
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = currentTheme.Card
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = currentTheme.Text
CloseBtn.TextSize = 16
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -68, 0.5, -13)
MinBtn.BackgroundColor3 = currentTheme.Card
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = currentTheme.Text
MinBtn.TextSize = 16
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Arrastar Janela com Efeito Suave
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Sidebar Esquerda
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = currentTheme.Sidebar
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 6)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.Parent = Sidebar

local UTPad = Instance.new("UIPadding")
UTPad.PaddingTop = UDim.new(0, 12)
UTPad.Parent = Sidebar

-- Container de Conteúdo Direita
local ContainerHolder = Instance.new("Frame")
ContainerHolder.Size = UDim2.new(1, -165, 1, -50)
ContainerHolder.Position = UDim2.new(0, 162, 0, 46)
ContainerHolder.BackgroundTransparency = 1
ContainerHolder.Parent = MainFrame

local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -14, 0, 36)
    tabBtn.BackgroundColor3 = currentTheme.Card
    tabBtn.BackgroundTransparency = 1
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Text = "   " .. name
    tabBtn.TextColor3 = currentTheme.SubText
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 650)
    tabContent.ScrollBarThickness = 2
    tabContent.Parent = ContainerHolder

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            TweenService:Create(t.btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = currentTheme.SubText}):Play()
        end
        tabContent.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15, TextColor3 = currentTheme.Text}):Play()
    end)

    table.insert(tabs, {content = tabContent, btn = tabBtn})
    return tabContent
end

local TabHome = createTab("HOME")
local TabVisuals = createTab("VISUALS")
local TabHitbox = createTab("AIM & HITBOX")
local TabMove = createTab("MOVE")
local TabThemes = createTab("THEMES")
local TabAbout = createTab("ABOUT")

tabs[1].content.Visible = true
tabs[1].btn.TextColor3 = currentTheme.Text
tabs[1].btn.BackgroundColor3 = currentTheme.Card
tabs[1].btn.BackgroundTransparency = 0.15

-- ==================== COMPONENTES COM EFEITOS FX ====================
local function addToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 385, 0, 38)
    btn.BackgroundColor3 = currentTheme.Card
    btn.BackgroundTransparency = 0.2
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "   " .. text .. " [ DESLIGADO ]"
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "   " .. text .. " [ LIGADO ]"
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = currentTheme.Accent, BackgroundTransparency = 0.05}):Play()
        else
            btn.Text = "   " .. text .. " [ DESLIGADO ]"
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = currentTheme.Text, BackgroundTransparency = 0.2}):Play()
        end
        callback(active)
    end)
end

local function addSlider(parent, text, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 385, 0, 48)
    frame.BackgroundColor3 = currentTheme.Card
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -15, 0, 22)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. min
    label.TextColor3 = currentTheme.Text
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBar = Instance.new("TextButton")
    sliderBar.Size = UDim2.new(1, -20, 0, 8)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(45, 38, 65)
    sliderBar.Text = ""
    sliderBar.Parent = frame
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = currentTheme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local draggingSlider = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- ==================== FUNÇÕES DOS MÓDULOS ====================

-- HOME
addToggle(TabHome, "Pulo Infinito", function(v) infJumpEnabled = v end)
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

addToggle(TabHome, "Ativar WalkSpeed", function(v) speedEnabled = v end)
local speedMethodBtn = Instance.new("TextButton")
speedMethodBtn.Size = UDim2.new(0, 385, 0, 38)
speedMethodBtn.BackgroundColor3 = currentTheme.Card
speedMethodBtn.Font = Enum.Font.GothamMedium
speedMethodBtn.Text = "   Modo Speed: Humanoid"
speedMethodBtn.TextColor3 = currentTheme.Text
speedMethodBtn.TextSize = 12
speedMethodBtn.TextXAlignment = Enum.TextXAlignment.Left
speedMethodBtn.Parent = TabHome
Instance.new("UICorner", speedMethodBtn).CornerRadius = UDim.new(0, 6)

speedMethodBtn.MouseButton1Click:Connect(function()
    if speedMethod == "Humanoid" then
        speedMethod = "CFrame"
        speedMethodBtn.Text = "   Modo Speed: CFrame"
    else
        speedMethod = "Humanoid"
        speedMethodBtn.Text = "   Modo Speed: Humanoid"
    end
end)

addSlider(TabHome, "Ajustar WalkSpeed", 16, 250, function(val) speedVal = val end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if speedEnabled then
        if speedMethod == "Humanoid" and hum then
            hum.WalkSpeed = speedVal
        elseif speedMethod == "CFrame" and root and hum and hum.MoveDirection.Magnitude > 0 then
            hum.WalkSpeed = 16
            root.CFrame = root.CFrame + hum.MoveDirection * (speedVal / 50)
        end
    end
end)

addToggle(TabHome, "Ativar JumpPower", function(v) jumpEnabled = v end)
addSlider(TabHome, "Ajustar JumpPower", 50, 350, function(val) jumpVal = val end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if jumpEnabled and hum then
        hum.UseJumpPower = true
        hum.JumpPower = jumpVal
    end
end)

-- VISUALS
addToggle(TabVisuals, "Player ESP", function(v)
    espEnabled = v
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espEnabled then
                if not p.Character:FindFirstChild("EnzickESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "EnzickESP"
                    hl.FillColor = currentTheme.Accent
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("EnzickESP") then p.Character.EnzickESP:Destroy() end
            end
        end
    end
end)

-- AIM & HITBOX
addToggle(TabHitbox, "Aimbot Ativo (Com FOV)", function(v)
    aimbotEnabled = v
    FovCircle.Visible = v
end)

local aimPartBtn = Instance.new("TextButton")
aimPartBtn.Size = UDim2.new(0, 385, 0, 38)
aimPartBtn.BackgroundColor3 = currentTheme.Card
aimPartBtn.Font = Enum.Font.GothamMedium
aimPartBtn.Text = "   Alvo Aimbot: Head"
aimPartBtn.TextColor3 = currentTheme.Text
aimPartBtn.TextSize = 12
aimPartBtn.TextXAlignment = Enum.TextXAlignment.Left
aimPartBtn.Parent = TabHitbox
Instance.new("UICorner", aimPartBtn).CornerRadius = UDim.new(0, 6)

aimPartBtn.MouseButton1Click:Connect(function()
    if aimTargetPart == "Head" then
        aimTargetPart = "HumanoidRootPart"
        aimPartBtn.Text = "   Alvo Aimbot: Torso"
    else
        aimTargetPart = "Head"
        aimPartBtn.Text = "   Alvo Aimbot: Head"
    end
end)

addSlider(TabHitbox, "Força de Grude (Até 1000)", 1, 1000, function(val) aimLockStrength = val end)
addSlider(TabHitbox, "Tamanho Raio FOV", 50, 400, function(val)
    aimFovRadius = val
    FovCircle.Radius = val
end)

RunService.RenderStepped:Connect(function()
    FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if aimbotEnabled then
        local closest, dist = nil, aimFovRadius
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimTargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local part = p.Character[aimTargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if mag < dist then dist = mag closest = part end
                end
            end
        end
        if closest then
            local lockAlpha = math.clamp(aimLockStrength / 1000, 0.01, 1)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Position), lockAlpha)
        end
    end
end)

-- MOVE (Noclip, Fly Freecam Real 3D sem inversão, Spin)
addToggle(TabMove, "Noclip", function(v) noclipEnabled = v end)
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Fly Freecam Corrigido (Sem inversão de eixos no telemóvel)
addToggle(TabMove, "Fly (Freecam 3D Real)", function(v)
    flyEnabled = v
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if flyEnabled then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "EnzicksFlyVel"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root

        local bg = Instance.new("BodyGyro")
        bg.Name = "EnzicksFlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9e4
        bg.Parent = root

        task.spawn(function()
            local flySpeed = 50
            while flyEnabled and char and root and root.Parent do
                bg.CFrame = Camera.CFrame
                local moveDir = hum.MoveDirection
                local vel = Vector3.new(0, 0, 0)
                
                if moveDir.Magnitude > 0 then
                    -- Converte para espaço local da câmara para corrigir qualquer inversão de joystick no mobile
                    local localDir = Camera.CFrame:VectorToObjectSpace(moveDir)
                    vel = (Camera.CFrame.LookVector * -localDir.Z + Camera.CFrame.RightVector * localDir.X) * flySpeed
                end
                
                bv.Velocity = vel
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    else
        if root:FindFirstChild("EnzicksFlyVel") then root.EnzicksFlyVel:Destroy() end
        if root:FindFirstChild("EnzicksFlyGyro") then root.EnzicksFlyGyro:Destroy() end
    end
end)

addToggle(TabMove, "Spin Bot", function(v) spinEnabled = v end)
addSlider(TabMove, "Velocidade Spin (Até 500)", 10, 500, function(val) spinSpeed = val end)
RunService.RenderStepped:Connect(function()
    if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end)

-- THEMES
local function applyTheme(theme)
    currentTheme = theme
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = theme.Main}):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.3), {Color = theme.Accent}):Play()
    TweenService:Create(TopBar, TweenInfo.new(0.3), {BackgroundColor3 = theme.Main}):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = theme.Sidebar}):Play()
    FovCircle.Color = theme.Accent
end

local function addThemeButton(name, theme)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 385, 0, 38)
    btn.BackgroundColor3 = theme.Accent
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Parent = TabThemes
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() applyTheme(theme) end)
end

addThemeButton("Nova Purple Theme", Themes.NovaPurple)
addThemeButton("Dark Minimal Theme", Themes.DarkMinimal)
addThemeButton("Neon Blue Theme", Themes.NeonBlue)
addThemeButton("Cyberpunk Green Theme", Themes.CyberpunkGreen)

-- ABOUT
local aboutText = Instance.new("TextLabel")
aboutText.Size = UDim2.new(0, 385, 0, 120)
aboutText.BackgroundTransparency = 1
aboutText.Font = Enum.Font.Gotham
aboutText.Text = "ENZICKS HUB V5.9\nCreated by Enzicks\nPowered by Liquid Glass FX\n\nStatus: Online & Undetected"
aboutText.TextColor3 = currentTheme.Text
aboutText.TextSize = 13
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.Parent = TabAbout

-- ==================== BOLINHA FLUTUANTE ====================
local FloatBall = Instance.new("TextButton")
FloatBall.Size = UDim2.new(0, 48, 0, 48)
FloatBall.Position = UDim2.new(0, 20, 0.5, -24)
FloatBall.BackgroundColor3 = currentTheme.Accent
FloatBall.Font = Enum.Font.GothamBold
FloatBall.Text = "EH"
FloatBall.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBall.TextSize = 16
FloatBall.Visible = false
FloatBall.Parent = ScreenGui

Instance.new("UICorner", FloatBall).CornerRadius = UDim.new(1, 0)
local BallStroke = Instance.new("UIStroke")
BallStroke.Color = Color3.fromRGB(255, 255, 255)
BallStroke.Thickness = 2
BallStroke.Parent = FloatBall

local fDragging, fDragStart, fStartPos
FloatBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = FloatBall.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if fDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - fDragStart
        FloatBall.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = false
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 580, 0, 360)
    FloatBall.Visible = true
end)

FloatBall.MouseButton1Click:Connect(function()
    FloatBall.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 580, 0, 360)}):Play()
end)

-- Fechar com confirmação
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 260, 0, 120)
ConfirmFrame.Position = UDim2.new(0.5, -130, 0.5, -60)
ConfirmFrame.BackgroundColor3 = currentTheme.Main
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 30
ConfirmFrame.Parent = ScreenGui
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 10)
local ConfStroke = Instance.new("UIStroke")
ConfStroke.Color = currentTheme.Accent
ConfStroke.Thickness = 1.5
ConfStroke.Parent = ConfirmFrame

local ConfText = Instance.new("TextLabel")
ConfText.Size = UDim2.new(1, 0, 0, 45)
ConfText.Position = UDim2.new(0, 0, 0.15, 0)
ConfText.BackgroundTransparency = 1
ConfText.Font = Enum.Font.GothamBold
ConfText.Text = "Deseja realmente fechar\no Enzicks Hub?"
ConfText.TextColor3 = currentTheme.Text
ConfText.TextSize = 12
ConfText.ZIndex = 31
ConfText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 90, 0, 30)
YesBtn.Position = UDim2.new(0, 25, 0.62, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.Text = "Sim"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextSize = 12
YesBtn.ZIndex = 31
YesBtn.Parent = ConfirmFrame
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 90, 0, 30)
NoBtn.Position = UDim2.new(1, -115, 0.62, 0)
NoBtn.BackgroundColor3 = currentTheme.Card
NoBtn.Font = Enum.Font.GothamBold
NoBtn.Text = "Não"
NoBtn.TextColor3 = currentTheme.Text
NoBtn.TextSize = 12
NoBtn.ZIndex = 31
NoBtn.Parent = ConfirmFrame
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
YesBtn.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("EnzickESP") then
            p.Character.EnzickESP:Destroy()
        end
    end
    FovCircle:Remove()
    ScreenGui:Destroy()
end)
