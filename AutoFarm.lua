local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local groupId = 1069446470
local allowedRanks = { [1]=true, [254]=true, [255]=true }
local key = "TBR"
local keyLiberada = false

local KeyWindow = Rayfield:CreateWindow({
   Name = "Skripty X Fox - Key System",
   LoadingTitle = "Sistema de Key",
   LoadingSubtitle = "Digite a key correta",
   ConfigurationSaving = { Enabled = false },
   Discord = {Enabled = false},
   KeySystem = false
})

local KeyTab = KeyWindow:CreateTab("🔑 Key", 4483345998)
KeyTab:CreateInput({
   Name = "Digite a Key",
   PlaceholderText = "Digite a Key...",
   RemoveTextAfterFocusLost = false,
   Callback = function(text)
      local rank = player:GetRankInGroup(groupId)
      if text == key and allowedRanks[rank] then
         keyLiberada = true
         Rayfield:Notify({ Title = "✅ Sucesso", Content = "Hub desbloqueado.", Duration = 3 })
         task.wait(1)
         KeyWindow:Destroy()
      else
         Rayfield:Notify({ Title = "❌ Erro", Content = "Key incorreta ou você não tem permissão.", Duration = 3 })
      end
   end
})

repeat task.wait() until keyLiberada

local Window = Rayfield:CreateWindow({
   Name = "Skripty X Fox",
   LoadingTitle = "Skripty X Fox Hub",
   LoadingSubtitle = "by MxzikaX",
   ConfigurationSaving = { Enabled = true, FolderName = "SkriptyXFoxHub", FileName = "Config" },
   Discord = { Enabled = false },
   KeySystem = false
})

local HomeTab = Window:CreateTab("🏠 Hub Principal", 4483345998)
local rank = player:GetRankInGroup(groupId)
local rankName = (rank == 1 and "Cliente") or (rank == 254 and "Admin") or (rank == 255 and "Criador") or "Visitante"
HomeTab:CreateLabel("👤 Player: "..player.Name)
HomeTab:CreateLabel("💎 Rank: "..rankName)
local fpsLabel = HomeTab:CreateLabel("⚡ FPS: Calculando...")

task.spawn(function()
    while task.wait(1) do
        fpsLabel:Set("⚡ FPS: "..math.floor(workspace:GetRealPhysicsFPS()))
    end
end)

local TBTab = Window:CreateTab("🚍 Transporte Brasil", 4483345998)
local AutoFarmAtivo = false
local autoFarmThread

TBTab:CreateToggle({
    Name = "⚙️ Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmAtivo = Value
        Rayfield:Notify({ Title = "Auto Farm", Content = Value and "✅ Ativado" or "⛔ Desativado", Duration = 3 })
        if Value then
            autoFarmThread = task.spawn(function()
                local stepSize, stepDelay = 25.8, 0.025

                local function getBus()
                    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                    if not humanoid then return nil end
                    local seat = humanoid.SeatPart
                    if seat and seat:IsA("VehicleSeat") and seat.Name == "DriveSeat" then
                        local bus = seat:FindFirstAncestorOfClass("Model")
                        if bus then
                            local basePart = bus.PrimaryPart or bus:FindFirstChildWhichIsA("BasePart")
                            if basePart then
                                bus.PrimaryPart = basePart
                                return bus
                            end
                        end
                    end
                    return nil
                end

                local function autoSit()
                    task.spawn(function()
                        while AutoFarmAtivo do
                            task.wait(1)
                            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                            if humanoid and (not humanoid.SeatPart or humanoid.SeatPart.Name ~= "DriveSeat") then
                                local busModel = workspace:FindFirstChild("Onibus")
                                if busModel then
                                    local seat = busModel:FindFirstChild("DriveSeat", true)
                                    if seat and seat:IsA("VehicleSeat") then
                                        char:MoveTo(seat.Position + Vector3.new(0, 3, 0))
                                        task.wait(0.5)
                                        seat:Sit(humanoid)
                                    end
                                end
                            end
                        end
                    end)
                end

                local function moveBusSafe(bus, targetPos)
                    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                    if not humanoid or not humanoid.SeatPart then return end
                    local startPos = bus.PrimaryPart.Position
                    local totalDist = (targetPos - startPos).Magnitude
                    local steps = math.max(1, math.ceil(totalDist / stepSize))
                    local direction = (targetPos - startPos).Unit * stepSize

                    for i = 1, steps do
                        if not AutoFarmAtivo then return end
                        if not humanoid.SeatPart or humanoid.SeatPart.Name ~= "DriveSeat" then return end
                        local newPos = startPos + (direction * i)
                        if (targetPos - newPos).Magnitude < stepSize then newPos = targetPos end
                        bus:SetPrimaryPartCFrame(CFrame.new(newPos))
                        task.wait(stepDelay)
                    end
                end

                local etapasFolder = workspace:WaitForChild("Onibus")
                local etapas = {}
                for i = 1, 13 do
                    local etapa = etapasFolder:FindFirstChild("etapa" .. i)
                    if etapa and etapa:IsA("BasePart") then etapas[i] = etapa end
                end

                autoSit()

                local etapaAtual = 1
                while AutoFarmAtivo do
                    local bus = getBus()
                    if bus then
                        for i = etapaAtual, #etapas do
                            local etapa = etapas[i]
                            if etapa then
                                moveBusSafe(bus, etapa.Position + Vector3.new(0, 3, 0))
                                task.wait(1.2)
                                etapaAtual = i
                            end
                        end
                        etapaAtual = 1
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

TBTab:CreateParagraph({
    Title = "📖 Tutorial",
    Content = [[
1. Entre no trabalho de motorista.
2. Pegue a rota 203.
3. Ative o Auto Farm no botão acima.
4. Use um auto click clicando por 4 segundos em cima da rota 203.
5. O ônibus vai se mover automaticamente pelos checkpoints.
6. Para parar, desative o botão acima.
]]
})

local MusicTab = Window:CreateTab("🎵 Músicas", 4483345998)
local musicList = {
    "85285606160561","116352618691586","119529247171824","137287837887567","133550069191544",
    "139194175356407","140148511394960","97664737475514","131934738968743","84580272481552",
    "117422401148316","72532582775383","127388169565508","124569204923985","74581892467871",
    "134054234875364","112738768982824","106419749688091","89659499594643","103583530574910",
    "97048507233601","114505292419747","99708065618377","12945030856","12947766229",
    "12883797005","12883792489","12278347066","12196089748","12196087782",
    "12196085179","12196079314","12174280792","11665228582","11644991824",
    "11301027744","11246826492","11246504314","11246060927","10026650627",
    "9894789961","9763023838","9763011195","9763018624","9763010950",
    "9763008191","9573787055","9557912590","9557910306","9552798254",
    "9544944433","9544120801","9542640486","9542617058","9498205199",
    "9213722086","9170280136"
}

for _, id in ipairs(musicList) do
    MusicTab:CreateButton({
        Name = id,
        Callback = function()
            setclipboard(id)
            Rayfield:Notify({ Title = "✅ Copiado", Content = "ID copiado: "..id, Duration = 2 })
        end
    })
end
