-- Brainrot Hub PRO - Interface Moderna + ESP Players & Brainrot
-- By veggetogames-svg

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ESP_COLOR = Color3.fromRGB(255,0,0)
local BASE_POSITION = nil
local TP_STEP = 10
local TP_WAIT = 0.05
local SAFE_WALKSPEED = 18
local SAFE_JUMPPOWER = 55

local ESP_BRAIN_ENABLED = false
local ESP_PLAYER_ENABLED = false
local GODMODE_ENABLED = false
local SPEED_ENABLED = false
local JUMP_ENABLED = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHubUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 340)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(27,27,38)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,14)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,38)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🧠 Brainrot Hub PRO"
Title.TextColor3 = Color3.fromRGB(255,0,0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = MainFrame

-- Arraste a interface
local Drag = false
local DragInput, DragStart, StartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Drag = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Drag = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==DragInput and Drag then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

local function makeButton(name, ypos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92,0,0,32)
    btn.Position = UDim2.new(0.04,0,0,ypos)
    btn.BackgroundColor3 = Color3.fromRGB(34,34,44)
    btn.TextColor3 = Color3.fromRGB(255,0,0)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = name
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    return btn
end

local btnSaveBase = makeButton("Salvar Base", 48)
local btnTPBase = makeButton("Teleportar Base", 88)
local btnESPBrain = makeButton("ESP Brainrot [OFF]", 128)
local btnESPPlayer = makeButton("ESP Players [OFF]", 168)
local btnGodmode = makeButton("Godmode [OFF]", 208)
local btnSpeed = makeButton("Velocidade [OFF]", 248)
local btnJump = makeButton("Pulo [OFF]", 288)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,0,0,18)
InfoLabel.Position = UDim2.new(0,0,1,-20)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Pressione DELETE para fechar o HUB"
InfoLabel.TextColor3 = Color3.fromRGB(200,200,200)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 13
InfoLabel.Parent = MainFrame

-- Funções do Hub

local function safeTP(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local current = root.Position
    local steps = math.ceil((targetPos - current).Magnitude / TP_STEP)
    local direction = (targetPos - current).Unit
    for i = 1, steps do
        local newPos = current + direction * TP_STEP * i
        if (newPos - targetPos).Magnitude < TP_STEP then newPos = targetPos end
        root.CFrame = CFrame.new(newPos)
        task.wait(TP_WAIT)
    end
    root.CFrame = CFrame.new(targetPos)
end

local espObjectsBrain, espObjectsPlayer = {}, {}

local function clearESPBrain()
    for _,v in pairs(espObjectsBrain) do v:Destroy() end
    espObjectsBrain = {}
end
local function clearESPPlayer()
    for _,v in pairs(espObjectsPlayer) do v:Destroy() end
    espObjectsPlayer = {}
end

local function updateESPBrain()
    clearESPBrain()
    if not ESP_BRAIN_ENABLED then return end
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("brainrot") and obj:IsA("Model") then
            local head = obj:FindFirstChild("Head")
            if head then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = obj
                highlight.FillColor = ESP_COLOR
                highlight.OutlineColor = ESP_COLOR
                highlight.FillTransparency = 0.7
                highlight.Parent = CoreGui
                table.insert(espObjectsBrain, highlight)

                local bb = Instance.new("BillboardGui")
                bb.Adornee = head
                bb.Size = UDim2.new(0,200,0,50)
                bb.AlwaysOnTop = true
                bb.Parent = CoreGui

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1,0,1,0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = ESP_COLOR
                textLabel.Font = Enum.Font.GothamSemibold
                textLabel.TextSize = 16
                textLabel.TextStrokeTransparency = 0.5

                local tipo = "Normal"
                if obj.Name:lower():find("god") then tipo = "God Brainrot"
                elseif obj.Name:lower():find("rainbow") then tipo = "Rainbow"
                elseif obj.Name:lower():find("secret") then tipo = "Secret"
                end
                local valor = "?"
                if obj:FindFirstChild("Value") then valor = tostring(obj.Value.Value) end

                textLabel.Text = string.format("%s\nValor: %s | Tipo: %s", obj.Name, valor, tipo)
                textLabel.Parent = bb
                table.insert(espObjectsBrain, bb)
            end
        end
    end
end

local function updateESPPlayer()
    clearESPPlayer()
    if not ESP_PLAYER_ENABLED then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChildOfClass("Humanoid") then
            local head = plr.Character.Head
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local highlight = Instance.new("Highlight")
            highlight.Adornee = plr.Character
            highlight.FillColor = ESP_COLOR
            highlight.OutlineColor = ESP_COLOR
            highlight.FillTransparency = 0.7
            highlight.Parent = CoreGui
            table.insert(espObjectsPlayer, highlight)

            local bb = Instance.new("BillboardGui")
            bb.Adornee = head
            bb.Size = UDim2.new(0,160,0,40)
            bb.AlwaysOnTop = true
            bb.Parent = CoreGui

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = ESP_COLOR
            textLabel.Font = Enum.Font.GothamSemibold
            textLabel.TextSize = 14
            textLabel.TextStrokeTransparency = 0.5

            local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude)) or 0
            textLabel.Text = string.format("%s | HP: %d | Dist: %d", plr.DisplayName or plr.Name, hum.Health, dist)
            textLabel.Parent = bb
            table.insert(espObjectsPlayer, bb)
        end
    end
end

local function godmodeLoop()
    while GODMODE_ENABLED do
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                humanoid.PlatformStand = false
                humanoid.BreakJointsOnDeath = false
                for _,v in pairs(char:GetChildren()) do
                    if v:IsA("Tool") and v.Parent == char then
                        v.CanBeDropped = false
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

local function safeSpeed(on)
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if on then
                humanoid.WalkSpeed = SAFE_WALKSPEED + math.random(-1,2)
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
end

local function safeJump(on)
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if on then
                humanoid.JumpPower = SAFE_JUMPPOWER + math.random(-1,1)
            else
                humanoid.JumpPower = 50
            end
        end
    end
end

btnSaveBase.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        BASE_POSITION = char.HumanoidRootPart.Position
        btnSaveBase.Text = "Base Salva!"
        task.wait(1.5)
        btnSaveBase.Text = "Salvar Base"
    end
end)

btnTPBase.MouseButton1Click:Connect(function()
    if not BASE_POSITION then
        btnTPBase.Text = "Salve a base antes!"
        task.wait(1.5)
        btnTPBase.Text = "Teleportar Base"
        return
    end
    btnTPBase.Text = "Teleportando..."
    safeTP(BASE_POSITION)
    btnTPBase.Text = "Teleportar Base"
end)

btnESPBrain.MouseButton1Click:Connect(function()
    ESP_BRAIN_ENABLED = not ESP_BRAIN_ENABLED
    btnESPBrain.Text = ESP_BRAIN_ENABLED and "ESP Brainrot [ON]" or "ESP Brainrot [OFF]"
    updateESPBrain()
end)

btnESPPlayer.MouseButton1Click:Connect(function()
    ESP_PLAYER_ENABLED = not ESP_PLAYER_ENABLED
    btnESPPlayer.Text = ESP_PLAYER_ENABLED and "ESP Players [ON]" or "ESP Players [OFF]"
    updateESPPlayer()
end)

btnGodmode.MouseButton1Click:Connect(function()
    GODMODE_ENABLED = not GODMODE_ENABLED
    btnGodmode.Text = GODMODE_ENABLED and "Godmode [ON]" or "Godmode [OFF]"
    if GODMODE_ENABLED then godmodeLoop() end
end)

btnSpeed.MouseButton1Click:Connect(function()
    SPEED_ENABLED = not SPEED_ENABLED
    btnSpeed.Text = SPEED_ENABLED and "Velocidade [ON]" or "Velocidade [OFF]"
    safeSpeed(SPEED_ENABLED)
end)

btnJump.MouseButton1Click:Connect(function()
    JUMP_ENABLED = not JUMP_ENABLED
    btnJump.Text = JUMP_ENABLED and "Pulo [ON]" or "Pulo [OFF]"
    safeJump(JUMP_ENABLED)
end)

RunService.RenderStepped:Connect(function()
    if ESP_BRAIN_ENABLED then pcall(updateESPBrain) else clearESPBrain() end
    if ESP_PLAYER_ENABLED then pcall(updateESPPlayer) else clearESPPlayer() end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    safeSpeed(SPEED_ENABLED)
    safeJump(JUMP_ENABLED)
    if GODMODE_ENABLED then godmodeLoop() end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.Delete and not processed then
        ScreenGui:Destroy()
        clearESPBrain()
        clearESPPlayer()
    end
end)

print("Brainrot Hub PRO UI carregado! Pressione DELETE para fechar.")
