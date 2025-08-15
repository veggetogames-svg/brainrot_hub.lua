-- Brainrot Hub - Versão GitHub
-- By Duzinho6969
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Configurações
local ESP_COLOR = Color3.new(1, 0.2, 0.2)
local BRAINROT_NAME = "Brainrot"
local basePosition = Vector3.new(0, 100, 0)

-- Estado
local ESP = false
local GodMode = false
local AutoCollect = false
local Teleporting = false

-- Interface Minimalista
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHub"
ScreenGui.Parent = CoreGui

local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Position = UDim2.new(0, 10, 0.5, -25)
MainButton.Text = "☰"
MainButton.TextSize = 24
MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainButton.TextColor3 = Color3.new(1, 1, 1)
MainButton.Parent = ScreenGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 0)
MenuFrame.Position = UDim2.new(0, 65, 0.5, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MenuFrame.BorderSizePixel = 0
MenuFrame.ClipsDescendants = true
MenuFrame.Parent = ScreenGui

-- Função para criar botões
local function CreateMenuButton(text, yPos, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, yPos)
    button.Text = text
    button.BackgroundColor3 = color
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 12
    button.Parent = MenuFrame
    return button
end

-- Atualizar menu
local function UpdateMenu()
    MenuFrame.Size = UDim2.new(0, 200, 0, 150)
    
    for _, child in ipairs(MenuFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yPos = 5
    local ESPBtn = CreateMenuButton("ESP: "..(ESP and "ON" or "OFF"), yPos, ESP and Color3.fromRGB(0,80,0) or Color3.fromRGB(80,0,0))
    yPos = yPos + 35
    local GodBtn = CreateMenuButton("GOD MODE: "..(GodMode and "ON" or "OFF"), yPos, GodMode and Color3.fromRGB(0,80,0) or Color3.fromRGB(80,0,0))
    yPos = yPos + 35
    local AutoBtn = CreateMenuButton("AUTO BRAINROT: "..(AutoCollect and "ON" or "OFF"), yPos, AutoCollect and Color3.fromRGB(0,80,0) or Color3.fromRGB(80,0,0))
    yPos = yPos + 35
    local SaveBtn = CreateMenuButton("SALVAR BASE", yPos, Color3.fromRGB(0,60,0))
    yPos = yPos + 35
    local TpBtn = CreateMenuButton("TP PARA BASE", yPos, Color3.fromRGB(0,60,120))
    
    -- Toggle ESP
    ESPBtn.MouseButton1Click:Connect(function()
        ESP = not ESP
        UpdateMenu()
        UpdateESP()
    end)
    
    -- Toggle God Mode
    GodBtn.MouseButton1Click:Connect(function()
        GodMode = not GodMode
        UpdateMenu()
        UpdateGodMode()
    end)
    
    -- Toggle Auto Collect
    AutoBtn.MouseButton1Click:Connect(function()
        AutoCollect = not AutoCollect
        UpdateMenu()
        UpdateAutoCollect()
    end)
    
    -- Salvar Base
    SaveBtn.MouseButton1Click:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            basePosition = Player.Character.HumanoidRootPart.Position
            SaveBtn.Text = "BASE SALVA!"
            task.wait(1)
            SaveBtn.Text = "SALVAR BASE"
        end
    end)
    
    -- Teleportar
    TpBtn.MouseButton1Click:Connect(function()
        if Teleporting then return end
        Teleporting = true
        TpBtn.Text = "TELEPORTANDO..."
        
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local root = Player.Character.HumanoidRootPart
            root:SetNetworkOwner(Player)
            task.wait(0.05)
            root.CFrame = CFrame.new(basePosition)
            task.wait(0.1)
            root.CFrame = CFrame.new(basePosition)
        end
        
        task.wait(0.5)
        Teleporting = false
        TpBtn.Text = "TP PARA BASE"
    end)
end

-- Toggle menu
MainButton.MouseButton1Click:Connect(function()
    if MenuFrame.Size.Y.Offset == 0 then
        UpdateMenu()
    else
        MenuFrame.Size = UDim2.new(0, 200, 0, 0)
    end
end)

-- ESP
local function UpdateESP()
    if ESP then
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= Player and plr.Character then
                local highlight = plr.Character:FindFirstChild("BrainrotESP") or Instance.new("Highlight")
                highlight.Name = "BrainrotESP"
                highlight.FillColor = ESP_COLOR
                highlight.OutlineColor = ESP_COLOR
                highlight.FillTransparency = 0.5
                highlight.Adornee = plr.Character
                highlight.Parent = plr.Character
            end
        end
    else
        for _, char in ipairs(workspace:GetDescendants()) do
            if char:IsA("Highlight") and char.Name == "BrainrotESP" then
                char:Destroy()
            end
        end
    end
end

-- God Mode
function UpdateGodMode()
    if Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if GodMode then
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                
                -- Anti-Ragdoll loop
                coroutine.wrap(function()
                    while GodMode and Player.Character and humanoid.Parent do
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        if Player.Character:FindFirstChild("HumanoidRootPart") then
                            Player.Character.HumanoidRootPart.Velocity = Vector3.zero
                        end
                        task.wait(0.1)
                    end
                end)()
            else
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end

-- Auto Collect Brainrot
function UpdateAutoCollect()
    if AutoCollect then
        coroutine.wrap(function()
            while AutoCollect and task.wait(1) do
                if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then continue end
                
                local brainrot = workspace:FindFirstChild(BRAINROT_NAME) or workspace:FindFirstChildWhichIsA("Model", true)
                if brainrot and brainrot:FindFirstChild("Head") then
                    local root = Player.Character.HumanoidRootPart
                    root.CFrame = brainrot.Head.CFrame * CFrame.new(0,0,-2)
                    task.wait(0.3)
                    firetouchinterest(root, brainrot.Head, 0)
                    task.wait(0.1)
                    firetouchinterest(root, brainrot.Head, 1)
                end
            end
        end)()
    end
end

-- Inicializar
Player.CharacterAdded:Connect(function(char)
    if GodMode then
        task.wait(1)
        UpdateGodMode()
    end
end)

-- Iniciar com ESP atualizado
UpdateESP()

-- Fechar o hub com a tecla Delete
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Delete and not processed then
        ScreenGui:Destroy()
    end
end)

print("Brainrot Hub carregado! Pressione Delete para fechar.")
