   -- Ana fonksiyon
local function RivalsCheat()
    -- Oyuncu ve yerel değişkenler
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    local camera = game.Workspace.CurrentCamera
    local runService = game:GetService("RunService")
    local userInput = game:GetService("UserInputService")
    local guiService = game:GetService("GuiService")
    
    -- Ayarlar (Varsayılan)
    local settings = {
        Aimbot = true,
        SilentAim = true,
        AimFOV = 120,
        AimSmoothness = 0.3,
        AimPart = "Head",
        ESP = true,
        BoxESP = true,
        NameESP = true,
        HealthESP = true,
        TracerESP = true,
        Wallbang = true,
        Ragebot = false,
        TeamCheck = true,
        VisibleCheck = true,
        HitSound = true,
        AutoClaim = true
    }
    
    -- GUI oluştur
    local function CreateGUI()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RivalsCheatGUI"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player.PlayerGui
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 250, 0, 400)
        mainFrame.Position = UDim2.new(0, 10, 0, 10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.BackgroundTransparency = 0.1
        mainFrame.BorderSizePixel = 0
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = screenGui
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        title.Text = "Rivals Cheat v1.0"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = mainFrame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 25, 0, 25)
        closeBtn.Position = UDim2.new(1, -30, 0, 3)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextScaled = true
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Parent = mainFrame
        closeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, -35)
        scroll.Position = UDim2.new(0, 0, 0, 35)
        scroll.BackgroundTransparency = 1
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ScrollBarThickness = 5
        scroll.Parent = mainFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll
        
        local toggleMap = {}
        local function AddToggle(text, key, default)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            frame.BackgroundTransparency = 0.3
            frame.Parent = scroll
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 50, 1, -5)
            btn.Position = UDim2.new(1, -55, 0, 2.5)
            btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            btn.Text = default and "AÇIK" or "KAPALI"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.Parent = frame
            
            toggleMap[key] = {
                btn = btn,
                value = default,
                label = label,
                frame = frame
            }
            
            btn.MouseButton1Click:Connect(function()
                toggleMap[key].value = not toggleMap[key].value
                local val = toggleMap[key].value
                settings[key] = val
                btn.BackgroundColor3 = val and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
                btn.Text = val and "AÇIK" or "KAPALI"
            end)
            
            scroll.CanvasSize = UDim2.new(0, 0, 0, scroll.CanvasSize.Y.Offset + 35)
        end
        
        -- Toggle'ları ekle
        AddToggle("Aimbot", "Aimbot", true)
        AddToggle("Silent Aim", "SilentAim", true)
        AddToggle("Ragebot", "Ragebot", false)
        AddToggle("Kutu ESP", "BoxESP", true)
        AddToggle("İsim ESP", "NameESP", true)
        AddToggle("Sağlık ESP", "HealthESP", true)
        AddToggle("Çizgi ESP", "TracerESP", true)
        AddToggle("Takım Kontrolü", "TeamCheck", true)
        AddToggle("Duvardan Vur", "Wallbang", true)
        AddToggle("Hit Sound", "HitSound", true)
        AddToggle("Auto Claim", "AutoClaim", true)
        
        -- Taşıma işlevi
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil
        
        mainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        mainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        userInput.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    -- ESP işlevleri
    local espObjects = {}
    local function CreateESP(plr)
        if espObjects[plr] then
            for _, v in pairs(espObjects[plr]) do
                v:Destroy()
            end
            espObjects[plr] = nil
        end
        
        if not plr or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local character = plr.Character
        local rootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChild("Humanoid")
        
        local espTable = {}
        
        -- Kutu ESP
        if settings.BoxESP then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 5, 1)
            box.Adornee = rootPart
            box.Color3 = plr.TeamColor and plr.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            box.Transparency = 0.5
            box.ZIndex = 5
            box.Visible = true
            box.Parent = rootPart
            table.insert(espTable, box)
        end
        
        -- İsim ESP
        if settings.NameESP then
            local nameLabel = Instance.new("BillboardGui")
            nameLabel.Size = UDim2.new(0, 200, 0, 30)
            nameLabel.Adornee = rootPart
            nameLabel.AlwaysOnTop = true
            nameLabel.StudsOffset = Vector3.new(0, 3.5, 0)
            nameLabel.Parent = rootPart
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = plr.Name
            textLabel.TextColor3 = plr.TeamColor and plr.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextStrokeTransparency = 0.3
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.Parent = nameLabel
            
            table.insert(espTable, nameLabel)
        end
        
        -- Sağlık ESP
        if settings.HealthESP and humanoid then
            local healthGui = Instance.new("BillboardGui")
            healthGui.Size = UDim2.new(0, 100, 0, 10)
            healthGui.Adornee = rootPart
            healthGui.AlwaysOnTop = true
            healthGui.StudsOffset = Vector3.new(0, -2.5, 0)
            healthGui.Parent = rootPart
            
            local healthBar = Instance.new("Frame")
            healthBar.Size = UDim2.new(1, 0, 1, 0)
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            healthBar.Parent = healthGui
            
            local healthBg = Instance.new("Frame")
            healthBg.Size = UDim2.new(1, 0, 1, 0)
            healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            healthBg.BackgroundTransparency = 0.5
            healthBg.Parent = healthGui
            
            local function updateHealth()
                if humanoid and humanoid.Parent then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.fromRGB(
                        200 - 200 * healthPercent,
                        200 * healthPercent,
                        0
                    )
                end
            end
            
            humanoid:GetPropertyChangedSignal("Health"):Connect(updateHealth)
            updateHealth()
            
            table.insert(espTable, healthGui)
        end
        
        -- Çizgi ESP (Tracer)
        if settings.TracerESP then
            local line = Instance.new("LineHandleAdornment")
            line.Thickness = 1
            line.Color3 = plr.TeamColor and plr.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            line.Transparency = 0.5
            line.Adornee = rootPart
            line.Length = 50
            line.Parent = rootPart
            table.insert(espTable, line)
        end
        
        espObjects[plr] = espTable
    end
    
    -- Aimbot işlevleri
    local function GetClosestPlayer()
        local closest = nil
        local closestDist = settings.AimFOV
        
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return nil
        end
        
        local rootPart = character.HumanoidRootPart
        local rootPos = rootPart.Position
        
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if settings.TeamCheck and plr.Team == player.Team then
                    continue
                end
                
                local targetRoot = plr.Character.HumanoidRootPart
                local targetPos = targetRoot.Position
                
                -- Görüş kontrolü
                if settings.VisibleCheck then
                    local ray = Ray.new(camera.CFrame.Position, (targetPos - camera.CFrame.Position).Unit * 500)
                    local hit, pos = game.Workspace:FindPartOnRay(ray, character)
                    if hit and hit.Parent ~= plr.Character then
                        continue
                    end
                end
                
                -- Ekran konumu ve FOV kontrolü
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                if not onScreen then
                    continue
                end
                
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                
                if dist < closestDist then
                    closestDist = dist
                    closest = plr
                end
            end
        end
        
        return closest
    end
    
    -- Aimbot hesaplama
    local function GetAimAngle(target)
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return nil
        end
        
        local rootPart = character.HumanoidRootPart
        local targetPart = target.Character:FindFirstChild(settings.AimPart) or target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
        
        if not targetPart then
            return nil
        end
        
        local targetPos = targetPart.Position
        if settings.Wallbang then
            targetPos = targetPos + Vector3.new(0, 0.5, 0)
        end
        
        local rootPos = rootPart.Position
        local direction = (targetPos - rootPos).Unit
        local angle = math.atan2(direction.Y, math.sqrt(direction.X^2 + direction.Z^2))
        local yaw = math.atan2(direction.X, direction.Z)
        
        return yaw, angle
    end
    
    -- Ragebot / Silent Aim
    local function ApplyAim(target)
        if not target or not settings.Aimbot then
            return
        end
        
        if settings.Ragebot then
            -- Ragebot: Anında nişan al
            local yaw, angle = GetAimAngle(target)
            if yaw and angle then
                local newCFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(angle, 0, 0)
                camera.CFrame = newCFrame
            end
        elseif settings.SilentAim then
            -- Silent Aim: Mouse yönünü değiştir
            local character = player.Character
            if not character then return end
            
            local rootPart = character.HumanoidRootPart
            local targetPart = target.Character:FindFirstChild(settings.AimPart) or target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
            
            if not targetPart then return end
            
            local targetPos = targetPart.Position
            local rootPos = rootPart.Position
            
            if settings.Wallbang then
                targetPos = targetPos + Vector3.new(0, 0.5, 0)
            end
            
            local direction = (targetPos - rootPos).Unit
            local yaw = math.atan2(direction.X, direction.Z)
            local angle = math.atan2(direction.Y, math.sqrt(direction.X^2 + direction.Z^2))
            
            local smoothFactor = settings.AimSmoothness
            local currentYaw = camera.CFrame:ToEulerAnglesYXZ()
            
            local newYaw = currentYaw + (yaw - currentYaw) * smoothFactor
            local newAngle = currentYaw + (angle - currentYaw) * smoothFactor
            
            camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(0, newYaw, 0) * CFrame.Angles(newAngle, 0, 0)
        end
    end
    
    -- Hit Sound
    local function PlayHitSound()
        if not settings.HitSound then return end
        
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9120381588" -- Kısa vuruş sesi
        sound.Volume = 0.5
        sound.Parent = game.Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 1)
    end
    
    -- Auto Claim
    local function AutoClaimRewards()
        if not settings.AutoClaim then return end
        
        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:find("Claim") then
                pcall(function()
                    v:FireServer()
                end)
            end
        end
    end
    
    -- Döngü
    runService.RenderStepped:Connect(function()
        -- ESP Güncelle
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[plr] then
                    CreateESP(plr)
                end
            else
                if espObjects[plr] then
                    for _, v in pairs(espObjects[plr]) do
                        v:Destroy()
                    end
                    espObjects[plr] = nil
                end
            end
        end
        
        -- Aimbot
        if settings.Aimbot then
            local target = GetClosestPlayer()
            if target then
                ApplyAim(target)
            end
        end
        
        -- Auto Claim
        AutoClaimRewards()
    end)
    
    -- Yeni oyuncu eklendiğinde ESP oluştur
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            CreateESP(plr)
        end)
    end)
    
    -- GUI'yi oluştur
    CreateGUI()
    
    -- Başlangıçta mevcut oyunculara ESP ekle
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character then
                CreateESP(plr)
            end
            plr.CharacterAdded:Connect(function()
                CreateESP(plr)
            end)
        end
    end
    
    print("Rivals Cheat başlatıldı! GUI ekranda.")
end

-- Hata yakalama ile çalıştır
pcall(RivalsCheat)
