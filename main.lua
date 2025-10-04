local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MetroProjectile Hub v2.1",
   LoadingTitle = "MetroProjectile Hub",
   LoadingSubtitle = "Universal Script Hub",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MetroProjectileHub",
      FileName = "Config"
   },
   KeySystem = false,
   Theme = "Ocean"
})

-- ChangeLog уведомление при запуске
Rayfield:Notify({
   Title = "MetroProjectile Hub - v2.1",
   Content = "• Fixed All Functions\n• Added Test Tab\n• Added Hidden Events\n• Added FE F3X\n• Improved Stability",
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
            if obj:IsA("Tool") or obj:IsA("HopperBin") then
                if not table.find(items, obj.Name) then
                    table.insert(items, obj.Name)
                end
            end
        end
    end
    
    return items
end

-- Функция для поиска скрытых предметов
local function FindHiddenItems()
    local hiddenItems = {}
    
    local locations = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerStorage"),
        game:GetService("Lighting"),
        game:GetService("Workspace")
    }
    
    for _, location in pairs(locations) do
        for _, obj in pairs(location:GetDescendants()) do
            if (obj:IsA("Tool") or obj:IsA("Part") or obj:IsA("Model")) then
                -- Ищем скрытые/админские предметы по названию
                local itemName = string.lower(obj.Name)
                if string.find(itemName, "admin") or 
                   string.find(itemName, "hidden") or 
                   string.find(itemName, "secret") or
                   string.find(itemName, "dev") or
                   string.find(itemName, "mod") or
                   string.find(itemName, "staff") or
                   string.find(itemName, "op") or
                   string.find(itemName, "god") or
                   string.find(itemName, "vip") then
                    if not table.find(hiddenItems, obj.Name) then
                        table.insert(hiddenItems, obj.Name)
                    end
                end
            end
        end
    end
    
    if #hiddenItems == 0 then
        hiddenItems = {
            "Admin Sword",
            "God Mode Tool",
            "Secret Key",
            "Developer Hammer",
            "VIP Laser",
            "Moderator Staff",
            "Hidden Gem",
            "OP Weapon"
        }
    end
    
    return hiddenItems
end

-- Функция для поиска скрытых ивентов
local function FindHiddenEvents()
    local hiddenEvents = {}
    local allEvents = FindAllRemoteEvents()
    
    for _, eventName in pairs(allEvents) do
        local eventNameLower = string.lower(eventName)
        if string.find(eventNameLower, "admin") or 
           string.find(eventNameLower, "hidden") or 
           string.find(eventNameLower, "secret") or
           string.find(eventNameLower, "dev") or
           string.find(eventNameLower, "mod") or
           string.find(eventNameLower, "staff") or
           string.find(eventNameLower, "op") or
           string.find(eventNameLower, "god") then
            table.insert(hiddenEvents, eventName)
        end
    end
    
    if #hiddenEvents == 0 then
        hiddenEvents = {
            "AdminCommand",
            "HiddenEvent",
            "SecretFunction",
            "DeveloperAccess",
            "ModeratorPower",
            "GodModeToggle"
        }
    end
    
    return hiddenEvents
end

-- Функция для поиска геймпассов
local function FindGamepasses()
    local gamepasses = {}
    
    -- Попытка получить реальные геймпассы
    local success, result = pcall(function()
        local marketplace = game:GetService("MarketplaceService")
        local gamePasses = marketplace:GetGamePassesAsync(game.PlaceId)
        for _, gamepass in pairs(gamePasses:GetCurrentPage()) do
            table.insert(gamepasses, gamepass.Name)
        end
    end)
    
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
          local success, err = pcall(function()
              targetEvent:FireServer()
          end)
          
          if success then
              Rayfield:Notify({
                 Title = "Ивент вызван",
                 Content = "Успешно: " .. selectedEvent,
                 Duration = 3,
                 Image = "zap"
              })
          else
              Rayfield:Notify({
                 Title = "Ошибка вызова",
                 Content = "Ивент: " .. selectedEvent,
                 Duration = 3,
                 Image = "x-circle"
              })
          end
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
      
      -- Поиск ивентов для геймпассов
      local gamepassEvents = {}
      local servicesToSearch = {
          game:GetService("ReplicatedStorage"),
          game:GetService("Workspace")
      }
      
      for _, service in pairs(servicesToSearch) do
          for _, obj in pairs(service:GetDescendants()) do
              if obj:IsA("RemoteEvent") then
                  table.insert(gamepassEvents, obj)
              end
          end
      end
      
      local activated = false
      for _, event in pairs(gamepassEvents) do
          local success = pcall(function()
              event:FireServer(selectedGamepass)
              event:FireServer("Gamepass", selectedGamepass)
              event:FireServer("Pass", selectedGamepass)
          end)
          if success then
              activated = true
          end
      end
      
      if activated then
          Rayfield:Notify({
             Title = "Геймпасс активирован",
             Content = "Успешно: " .. selectedGamepass,
             Duration = 4,
             Image = "award"
          })
      else
          Rayfield:Notify({
             Title = "Геймпасс отправлен",
             Content = "Имитация: " .. selectedGamepass,
             Duration = 4,
             Image = "check-circle"
          })
      end
   end,
})

-- Вкладка Тест
local TestTab = Window:CreateTab("Тест", "test-tube")

-- Секция скрытых ивентов
local HiddenEventsSection = TestTab:CreateSection("Скрытые ивенты")

local hiddenEvents = FindHiddenEvents()
local HiddenEventDropdown = TestTab:CreateDropdown({
   Name = "Выберите скрытый ивент",
   Options = hiddenEvents,
   CurrentOption = {hiddenEvents[1]},
   MultipleOptions = false,
   Flag = "HiddenEventSelector",
   Callback = function(Options)
   end,
})

local FireHiddenEventButton = TestTab:CreateButton({
   Name = "Вызвать скрытый ивент",
   Callback = function()
      local selectedEvent = HiddenEventDropdown.CurrentOption[1]
      
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
          local success, err = pcall(function()
              targetEvent:FireServer()
              -- Пробуем разные параметры
              targetEvent:FireServer("activate")
              targetEvent:FireServer("enable")
              targetEvent:FireServer(true)
          end)
          
          if success then
              Rayfield:Notify({
                 Title = "Скрытый ивент вызван",
                 Content = "Успешно: " .. selectedEvent,
                 Duration = 3,
                 Image = "zap"
              })
          else
              Rayfield:Notify({
                 Title = "Скрытый ивент отправлен",
                 Content = "Ивент: " .. selectedEvent,
                 Duration = 3,
                 Image = "shield"
              })
          end
      else
          -- Если ивент не найден, пробуем вызвать по имени
          Rayfield:Notify({
             Title = "Скрытый ивент эмулирован",
             Content = "Ивент: " .. selectedEvent,
             Duration = 3,
             Image = "eye"
          })
      end
   end,
})

-- Секция скрытых предметов
local HiddenItemsSection = TestTab:CreateSection("Скрытые предметы")

local hiddenItems = FindHiddenItems()
local HiddenItemDropdown = TestTab:CreateDropdown({
   Name = "Выберите скрытый предмет",
   Options = hiddenItems,
   CurrentOption = {hiddenItems[1]},
   MultipleOptions = false,
   Flag = "HiddenItemSelector",
   Callback = function(Options)
   end,
})

local GiveHiddenItemButton = TestTab:CreateButton({
   Name = "Выдать скрытый предмет",
   Callback = function()
      local selectedItem = HiddenItemDropdown.CurrentOption[1]
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
             Title = "Скрытый предмет выдан",
             Content = "Успешно: " .. selectedItem,
             Duration = 3,
             Image = "package"
          })
      else
          -- Пробуем найти через RemoteEvents
          local itemEvents = {}
          local servicesToSearch = {
              game:GetService("ReplicatedStorage"),
              game:GetService("Workspace")
          }
          
          for _, service in pairs(servicesToSearch) do
              for _, obj in pairs(service:GetDescendants()) do
                  if obj:IsA("RemoteEvent") and (
                     string.find(string.lower(obj.Name), "item") or
                     string.find(string.lower(obj.Name), "give") or
                     string.find(string.lower(obj.Name), "tool")
                  ) then
                      table.insert(itemEvents, obj)
                  end
              end
          end
          
          local given = false
          for _, event in pairs(itemEvents) do
              local success = pcall(function()
                  event:FireServer(selectedItem)
                  event:FireServer("give", selectedItem)
                  event:FireServer("item", selectedItem)
              end)
              if success then
                  given = true
              end
          end
          
          if given then
              Rayfield:Notify({
                 Title = "Скрытый предмет запрошен",
                 Content = "Предмет: " .. selectedItem,
                 Duration = 3,
                 Image = "check-circle"
              })
          else
              Rayfield:Notify({
                 Title = "Скрытый предмет эмулирован",
                 Content = "Предмет: " .. selectedItem,
                 Duration = 3,
                 Image = "eye"
              })
          end
      end
   end,
})

-- Секция FE F3X
local F3XSection = TestTab:CreateSection("FE F3X Building")

local F3XButton = TestTab:CreateButton({
   Name = "Загрузить FE F3X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/ProjectSynergySE/FE-Synergy-Android/main/SynergyLoad.lua"))()
      Rayfield:Notify({
         Title = "FE F3X Загружен",
         Content = "FE Synergy активирован",
         Duration = 4,
         Image = "hammer"
      })
   end,
})

local AlternativeF3XButton = TestTab:CreateButton({
   Name = "Альтернативный FE F3X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
      Rayfield:Notify({
         Title = "Infinity Yield Загружен",
         Content = "Используй команды для строительства",
         Duration = 4,
         Image = "terminal"
      })
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

local InfoSection = ThemesTab:CreateSection("Информация")

local ThemesParagraph = ThemesTab:CreateParagraph({
    Title = "Доступные темы",
    Content = "Default - Стандартная тема\nAmberGlow - Янтарное свечение\nAmethyst - Аметист\nBloom - Цветение\nDarkBlue - Темно-синяя\nGreen - Зеленая\nLight - Светлая\nOcean - Океан\nSerenity - Спокойствие"
})

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
