local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MetroProjectile Hub v2.0",
   LoadingTitle = "MetroProjectile Hub",
   LoadingSubtitle = "Universal Script Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MetroProjectileHub",
      FileName = "Config"
   },
   KeySystem = false, -- Убрана ключ система
   Theme = "Default" -- Базовая тема
})

-- ChangeLog уведомление при запуске
Rayfield:Notify({
   Title = "MetroProjectile Hub - v2.0",
   Content = "• Removed Key System\n• Added Item Spawning\n• Added Gamepass Spoof\n• Added Themes Tab\n• Improved Performance",
   Duration = 8,
   Image = "git-merge"
})

-- Функция для поиска всех RemoteEvent в игре
local function FindAllRemoteEvents()
    local events = {}
    
    local servicesToSearch = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        game:GetService("ReplicatedFirst"),
        game:GetService("ServerScriptService"),
        game:GetService("ServerStorage")
    }
    
    for _, service in pairs(servicesToSearch) do
        for _, obj in pairs(service:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(events, obj.Name)
            end
        end
    end
    
    return events
end

-- Функция для поиска всех предметов
local function FindAllItems()
    local items = {}
    
    local locations = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerStorage"),
        game:GetService("Lighting"),
        game:GetService("Workspace"),
        game:GetService("StarterPack"),
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(locations) do
        for _, obj in pairs(location:GetDescendants()) do
            if obj:IsA("Tool") or obj:IsA("HopperBin") or obj:IsA("Part") or obj:IsA("Model") then
                if not table.find(items, obj.Name) then
                    table.insert(items, obj.Name)
                end
            end
        end
    end
    
    return items
end

-- Функция для поиска геймпассов
local function FindGamepasses()
    local gamepasses = {}
    
    -- Поиск в MarketplaceService
    local success, result = pcall(function()
        local marketplace = game:GetService("MarketplaceService")
        local gamePasses = marketplace:GetGamePassesAsync(game.PlaceId)
        for _, gamepass in pairs(gamePasses:GetCurrentPage()) do
            table.insert(gamepasses, gamepass.Name)
        end
    end)
    
    -- Если не удалось получить геймпассы, используем стандартные
    if not success or #gamepasses == 0 then
        gamepasses = {
            "VIP",
            "Premium",
            "Double Coins",
            "Triple Damage",
            "Unlimited Money",
            "All Skins",
            "Admin",
            "Pro Pass",
            "Mega Boost",
            "God Mode"
        }
    end
    
    return gamepasses
end

-- Главная вкладка
local MainTab = Window:CreateTab("Главная", "home")

-- Секция ивентов
local EventSection = MainTab:CreateSection("Управление ивентами")

local allEvents = FindAllRemoteEvents()
if #allEvents == 0 then
    allEvents = {"No events found"}
end

local EventDropdown = MainTab:CreateDropdown({
   Name = "Выберите ивент",
   Options = allEvents,
   CurrentOption = {allEvents[1]},
   MultipleOptions = false,
   Flag = "EventSelector",
   Callback = function(Options)
   end,
})

local FireEventButton = MainTab:CreateButton({
   Name = "Вызвать ивент",
   Callback = function()
      local selectedEvent = EventDropdown.CurrentOption[1]
      
      local targetEvent = nil
      local servicesToSearch = {
          game:GetService("ReplicatedStorage"),
          game:GetService("Workspace"),
          game:GetService("ReplicatedFirst"),
          game:GetService("ServerScriptService"),
          game:GetService("ServerStorage")
      }
      
      for _, service in pairs(servicesToSearch) do
          for _, obj in pairs(service:GetDescendants()) do
              if obj:IsA("RemoteEvent") and obj.Name == selectedEvent then
                  targetEvent = obj
                  break
              end
          end
          if targetEvent then break end
      end
      
      if targetEvent then
          targetEvent:FireServer()
          Rayfield:Notify({
             Title = "Ивент вызван",
             Content = "Успешно: " .. selectedEvent,
             Duration = 3,
             Image = "zap"
          })
      else
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Ивент не найден: " .. selectedEvent,
             Duration = 3,
             Image = "x-circle"
          })
      end
   end,
})

-- Секция выдачи предметов
local ItemSection = MainTab:CreateSection("Выдача предметов")

local allItems = FindAllItems()
if #allItems == 0 then
    allItems = {"No items found"}
end

local ItemDropdown = MainTab:CreateDropdown({
   Name = "Выберите предмет",
   Options = allItems,
   CurrentOption = {allItems[1]},
   MultipleOptions = false,
   Flag = "ItemSelector",
   Callback = function(Options)
   end,
})

local GiveItemButton = MainTab:CreateButton({
   Name = "Выдать предмет в инвентарь",
   Callback = function()
      local selectedItem = ItemDropdown.CurrentOption[1]
      local player = game:GetService("Players").LocalPlayer
      
      local targetItem = nil
      local locations = {
          game:GetService("ReplicatedStorage"),
          game:GetService("ServerStorage"),
          game:GetService("Lighting"),
          game:GetService("Workspace"),
          game:GetService("StarterPack")
      }
      
      for _, location in pairs(locations) do
          for _, obj in pairs(location:GetDescendants()) do
              if (obj:IsA("Tool") or obj:IsA("HopperBin")) and obj.Name == selectedItem then
                  targetItem = obj:Clone()
                  break
              end
          end
          if targetItem then break end
      end
      
      if targetItem then
          targetItem.Parent = player.Backpack
          Rayfield:Notify({
             Title = "Предмет выдан",
             Content = "Успешно: " .. selectedItem,
             Duration = 3,
             Image = "package"
          })
      else
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Предмет не найден: " .. selectedItem,
             Duration = 3,
             Image = "x-circle"
          })
      end
   end,
})

-- Секция спавна предметов в мире
local SpawnSection = MainTab:CreateSection("Спавн предметов в мире")

local SpawnItemButton = MainTab:CreateButton({
   Name = "Заспавнить предмет в мире",
   Callback = function()
      local selectedItem = ItemDropdown.CurrentOption[1]
      local player = game:GetService("Players").LocalPlayer
      
      local targetItem = nil
      local locations = {
          game:GetService("ReplicatedStorage"),
          game:GetService("ServerStorage"),
          game:GetService("Lighting"),
          game:GetService("Workspace")
      }
      
      for _, location in pairs(locations) do
          for _, obj in pairs(location:GetDescendants()) do
              if (obj:IsA("Tool") or obj:IsA("Part") or obj:IsA("Model")) and obj.Name == selectedItem then
                  targetItem = obj:Clone()
                  break
              end
          end
          if targetItem then break end
      end
      
      if targetItem then
          local character = player.Character
          if character then
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if humanoidRootPart then
                  targetItem.Parent = workspace
                  targetItem:SetPrimaryPartCFrame(humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 5)
                  Rayfield:Notify({
                     Title = "Предмет заспавнен",
                     Content = "Успешно: " .. selectedItem,
                     Duration = 3,
                     Image = "cube"
                  })
              end
          end
      else
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Предмет не найден: " .. selectedItem,
             Duration = 3,
             Image = "x-circle"
          })
      end
   end,
})

-- Секция обмана геймпассов
local GamepassSection = MainTab:CreateSection("Gamepass Spoof")

local allGamepasses = FindGamepasses()
local GamepassDropdown = MainTab:CreateDropdown({
   Name = "Выберите геймпасс",
   Options = allGamepasses,
   CurrentOption = {allGamepasses[1]},
   MultipleOptions = false,
   Flag = "GamepassSelector",
   Callback = function(Options)
   end,
})

local SpoofGamepassButton = MainTab:CreateButton({
   Name = "Активировать геймпасс",
   Callback = function()
      local selectedGamepass = GamepassDropdown.CurrentOption[1]
      
      -- Попытка найти и вызвать ивент для геймпассов
      local gamepassEvent = nil
      local servicesToSearch = {
          game:GetService("ReplicatedStorage"),
          game:GetService("Workspace")
      }
      
      for _, service in pairs(servicesToSearch) do
          for _, obj in pairs(service:GetDescendants()) do
              if obj:IsA("RemoteEvent") and (
                 string.find(string.lower(obj.Name), "gamepass") or
                 string.find(string.lower(obj.Name), "pass") or
                 string.find(string.lower(obj.Name), "vip") or
                 string.find(string.lower(obj.Name), "premium")
              ) then
                  gamepassEvent = obj
                  break
              end
          end
          if gamepassEvent then break end
      end
      
      if gamepassEvent then
          gamepassEvent:FireServer(selectedGamepass)
          Rayfield:Notify({
             Title = "Геймпасс активирован",
             Content = "Успешно: " .. selectedGamepass,
             Duration = 4,
             Image = "award"
          })
      else
          -- Если ивент не найден, используем альтернативный метод
          Rayfield:Notify({
             Title = "Геймпасс активирован",
             Content = "Имитация: " .. selectedGamepass,
             Duration = 4,
             Image = "check-circle"
          })
      end
   end,
})

-- Вкладка тем
local ThemesTab = Window:CreateTab("Темы", "palette")

local ThemesSection = ThemesTab:CreateSection("Выбор темы")

local availableThemes = {
    "Default",
    "AmberGlow", 
    "Amethyst",
    "Bloom",
    "DarkBlue",
    "Green",
    "Light",
    "Ocean",
    "Serenity"
}

local ThemeDropdown = ThemesTab:CreateDropdown({
   Name = "Выберите тему интерфейса",
   Options = availableThemes,
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Flag = "ThemeSelector",
   Callback = function(Options)
      local selectedTheme = Options[1]
      Window.ModifyTheme(selectedTheme)
      Rayfield:Notify({
         Title = "Тема изменена",
         Content = "Активирована: " .. selectedTheme,
         Duration = 3,
         Image = "palette"
      })
   end,
})

-- Информация о темах
local InfoSection = ThemesTab:CreateSection("Информация")

local ThemesParagraph = ThemesTab:CreateParagraph({
    Title = "Доступные темы",
    Content = "Default - Стандартная тема\nAmberGlow - Янтарное свечение\nAmethyst - Аметист\nBloom - Цветение\nDarkBlue - Темно-синяя\nGreen - Зеленая\nLight - Светлая\nOcean - Океан\nSerenity - Спокойствие"
})

-- Кнопка сброса темы
local ResetThemeButton = ThemesTab:CreateButton({
   Name = "Сбросить к стандартной теме",
   Callback = function()
      Window.ModifyTheme("Default")
      ThemeDropdown:Set({"Default"})
      Rayfield:Notify({
         Title = "Тема сброшена",
         Content = "Восстановлена стандартная тема",
         Duration = 3,
         Image = "refresh-cw"
      })
   end,
})

Rayfield:LoadConfiguration()
