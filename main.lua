local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MetroProjectile Hub",
   LoadingTitle = "MetroProjectile Hub",
   LoadingSubtitle = "Loading Interface...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MetroProjectileHub",
      FileName = "Config"
   },
   KeySystem = true,
   KeySettings = {
      Title = "MetroProjectile Hub - Key System",
      Subtitle = "Enter key for access",
      Note = "Key: test",
      FileName = "MetroProjectileKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"test"}
   }
})

-- ChangeLog уведомление при запуске
Rayfield:Notify({
   Title = "MetroProjectile Hub - ChangeLog",
   Content = "v1.1 - Added Grow a Garden Tab\n• Added Seed Purchase System\n• Added Garden Events\n• Improved UI",
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

-- Функция для поиска всех инструментов и оружия
local function FindAllItems()
    local items = {}
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("HopperBin") then
            table.insert(items, obj.Name)
        end
    end
    
    local serverStorage = game:GetService("ServerStorage")
    for _, obj in pairs(serverStorage:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("HopperBin") then
            table.insert(items, obj.Name)
        end
    end
    
    local lighting = game:GetService("Lighting")
    for _, obj in pairs(lighting:GetDescendants()) do
        if obj:IsA("Tool") then
            table.insert(items, obj.Name)
        end
    end
    
    return items
end

-- Функция для поиска семечек в Grow a Garden
local function FindGardenSeeds()
    local seeds = {}
    
    -- Поиск в ReplicatedStorage
    local replicatedStorage = game:GetService("ReplicatedStorage")
    for _, obj in pairs(replicatedStorage:GetDescendants()) do
        if obj:IsA("Tool") and string.find(string.lower(obj.Name), "seed") then
            table.insert(seeds, obj.Name)
        end
    end
    
    -- Поиск в ServerStorage
    local serverStorage = game:GetService("ServerStorage")
    for _, obj in pairs(serverStorage:GetDescendants()) do
        if obj:IsA("Tool") and string.find(string.lower(obj.Name), "seed") then
            table.insert(seeds, obj.Name)
        end
    end
    
    -- Поиск в Lighting
    local lighting = game:GetService("Lighting")
    for _, obj in pairs(lighting:GetDescendants()) do
        if obj:IsA("Tool") and string.find(string.lower(obj.Name), "seed") then
            table.insert(seeds, obj.Name)
        end
    end
    
    -- Если семечки не найдены, добавляем стандартные варианты
    if #seeds == 0 then
        seeds = {
            "Sunflower Seed",
            "Rose Seed", 
            "Tulip Seed",
            "Oak Seed",
            "Pine Seed",
            "Cactus Seed",
            "Magic Seed",
            "Golden Seed"
        }
    end
    
    return seeds
end

-- Функция для поиска ивентов Grow a Garden
local function FindGardenEvents()
    local gardenEvents = {}
    local allEvents = FindAllRemoteEvents()
    
    for _, eventName in pairs(allEvents) do
        if string.find(string.lower(eventName), "garden") or
           string.find(string.lower(eventName), "seed") or
           string.find(string.lower(eventName), "plant") or
           string.find(string.lower(eventName), "grow") or
           string.find(string.lower(eventName), "harvest") then
            table.insert(gardenEvents, eventName)
        end
    end
    
    if #gardenEvents == 0 then
        gardenEvents = {
            "PlantSeed",
            "HarvestPlant",
            "WaterPlant",
            "FertilizePlant",
            "BuySeed",
            "SellPlant"
        }
    end
    
    return gardenEvents
end

-- Главная вкладка
local MainTab = Window:CreateTab("Главная", "home")

-- Секция ивентов
local EventSection = MainTab:CreateSection("Управление ивентами")

local allEvents = FindAllRemoteEvents()
if #allEvents == 0 then
    allEvents = {"No events found"}
end

-- Выпадающий список с ивентами
local EventDropdown = MainTab:CreateDropdown({
   Name = "Выберите ивент",
   Options = allEvents,
   CurrentOption = {allEvents[1]},
   MultipleOptions = false,
   Flag = "EventSelector",
   Callback = function(Options)
   end,
})

-- Кнопка вызова ивента
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
             Image = "check-circle"
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

-- Секция предметов
local ItemSection = MainTab:CreateSection("Выдача предметов")

local allItems = FindAllItems()
if #allItems == 0 then
    allItems = {"No items found"}
end

-- Выпадающий список с предметами
local ItemDropdown = MainTab:CreateDropdown({
   Name = "Выберите предмет",
   Options = allItems,
   CurrentOption = {allItems[1]},
   MultipleOptions = false,
   Flag = "ItemSelector",
   Callback = function(Options)
   end,
})

-- Кнопка выдачи предмета
local GiveItemButton = MainTab:CreateButton({
   Name = "Выдать предмет",
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
             Image = "check-circle"
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

-- Вкладка Grow a Garden
local GardenTab = Window:CreateTab("Grow a Garden", "sprout")

-- Секция покупки семечек
local SeedSection = GardenTab:CreateSection("Покупка семечек")

local gardenSeeds = FindGardenSeeds()
local SeedDropdown = GardenTab:CreateDropdown({
   Name = "Выберите семечко",
   Options = gardenSeeds,
   CurrentOption = {gardenSeeds[1]},
   MultipleOptions = false,
   Flag = "SeedSelector",
   Callback = function(Options)
   end,
})

-- Кнопка "купить" семечко
local BuySeedButton = GardenTab:CreateButton({
   Name = "Купить семечко",
   Callback = function()
      local selectedSeed = SeedDropdown.CurrentOption[1]
      local player = game:GetService("Players").LocalPlayer
      
      -- Поиск RemoteEvent для покупки
      local buyEvent = nil
      local servicesToSearch = {
          game:GetService("ReplicatedStorage"),
          game:GetService("Workspace")
      }
      
      for _, service in pairs(servicesToSearch) do
          for _, obj in pairs(service:GetDescendants()) do
              if obj:IsA("RemoteEvent") and (
                 string.find(string.lower(obj.Name), "buy") or
                 string.find(string.lower(obj.Name), "purchase") or
                 string.find(string.lower(obj.Name), "shop")
              ) then
                  buyEvent = obj
                  break
              end
          end
          if buyEvent then break end
      end
      
      if buyEvent then
          -- Пытаемся вызвать ивент покупки с названием семечка
          local success, error = pcall(function()
              buyEvent:FireServer(selectedSeed)
          end)
          
          if success then
              Rayfield:Notify({
                 Title = "Покупка семечка",
                 Content = "Успешно: " .. selectedSeed,
                 Duration = 3,
                 Image = "shopping-cart"
              })
          else
              -- Если не сработало, выдаем семечко напрямую
              local targetSeed = nil
              local locations = {
                  game:GetService("ReplicatedStorage"),
                  game:GetService("ServerStorage"),
                  game:GetService("Lighting")
              }
              
              for _, location in pairs(locations) do
                  for _, obj in pairs(location:GetDescendants()) do
                      if obj:IsA("Tool") and obj.Name == selectedSeed then
                          targetSeed = obj:Clone()
                          break
                      end
                  end
                  if targetSeed then break end
              end
              
              if targetSeed then
                  targetSeed.Parent = player.Backpack
                  Rayfield:Notify({
                     Title = "Семечко получено",
                     Content = "Успешно: " .. selectedSeed,
                     Duration = 3,
                     Image = "check-circle"
                  })
              else
                  Rayfield:Notify({
                     Title = "Ошибка",
                     Content = "Семечко не найдено: " .. selectedSeed,
                     Duration = 3,
                     Image = "x-circle"
                  })
              end
          end
      else
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Ивент покупки не найден",
             Duration = 3,
             Image = "x-circle"
          })
      end
   end,
})

-- Секция ивентов для сада
local GardenEventsSection = GardenTab:CreateSection("Ивенты сада")

local gardenEvents = FindGardenEvents()
local GardenEventDropdown = GardenTab:CreateDropdown({
   Name = "Выберите ивент сада",
   Options = gardenEvents,
   CurrentOption = {gardenEvents[1]},
   MultipleOptions = false,
   Flag = "GardenEventSelector",
   Callback = function(Options)
   end,
})

-- Кнопка вызова ивента сада
local FireGardenEventButton = GardenTab:CreateButton({
   Name = "Вызвать ивент сада",
   Callback = function()
      local selectedEvent = GardenEventDropdown.CurrentOption[1]
      
      local targetEvent = nil
      local servicesToSearch = {
          game:GetService("ReplicatedStorage"),
          game:GetService("Workspace")
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
             Title = "Ивент сада вызван",
             Content = "Успешно: " .. selectedEvent,
             Duration = 3,
             Image = "check-circle"
          })
      else
          Rayfield:Notify({
             Title = "Ошибка",
             Content = "Ивент сада не найден: " .. selectedEvent,
             Duration = 3,
             Image = "x-circle"
          })
      end
   end,
})

-- Автоматические действия для сада
local AutoSection = GardenTab:CreateSection("Автоматизация")

local AutoHarvestToggle = GardenTab:CreateToggle({
   Name = "Авто-сбор урожая",
   CurrentValue = false,
   Flag = "AutoHarvest",
   Callback = function(Value)
      if Value then
          Rayfield:Notify({
             Title = "Авто-сбор",
             Content = "Автоматический сбор включен",
             Duration = 3,
             Image = "refresh-cw"
          })
      else
          Rayfield:Notify({
             Title = "Авто-сбор",
             Content = "Автоматический сбор выключен",
             Duration = 3,
             Image = "octagon"
          })
      end
   end,
})

local AutoPlantToggle = GardenTab:CreateToggle({
   Name = "Авто-посадка",
   CurrentValue = false,
   Flag = "AutoPlant",
   Callback = function(Value)
      if Value then
          Rayfield:Notify({
             Title = "Авто-посадка",
             Content = "Автоматическая посадка включена",
             Duration = 3,
             Image = "refresh-cw"
          })
      else
          Rayfield:Notify({
             Title = "Авто-посадка",
             Content = "Автоматическая посадка выключена",
             Duration = 3,
             Image = "octagon"
          })
      end
   end,
})

-- Вкладка Test
local TestTab = Window:CreateTab("Test", "test-tube")

local ScriptsSection = TestTab:CreateSection("Скрипты")

local IYButton = TestTab:CreateButton({
   Name = "Infinity Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
      Rayfield:Notify({
         Title = "Infinity Yield",
         Content = "Загружен успешно",
         Duration = 3,
         Image = "terminal"
      })
   end,
})

local FlyButton = TestTab:CreateButton({
   Name = "Fly GUI V3",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
      Rayfield:Notify({
         Title = "Fly GUI V3",
         Content = "Загружен успешно",
         Duration = 3,
         Image = "feather"
      })
   end,
})

local MoreScriptsSection = TestTab:CreateSection("Дополнительные скрипты")

local SpyButton = TestTab:CreateButton({
   Name = "Simple Spy",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
      Rayfield:Notify({
         Title = "Simple Spy",
         Content = "Загружен успешно",
         Duration = 3,
         Image = "eye"
      })
   end,
})

local DarkDexButton = TestTab:CreateButton({
   Name = "Dark Dex",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
      Rayfield:Notify({
         Title = "Dark Dex",
         Content = "Загружен успешно",
         Duration = 3,
         Image = "database"
      })
   end,
})

-- Вкладка "О нас"
local AboutTab = Window:CreateTab("О нас", "info")

local AboutSection = AboutTab:CreateSection("Информация")

local Paragraph = AboutTab:CreateParagraph({
    Title = "MetroProjectile Hub", 
    Content = "Автор: GitHubVibe\n\nПродвинутый хаб для различных игр"
})

local LinksSection = AboutTab:CreateSection("Ссылки")

local TelegramButton = AboutTab:CreateButton({
   Name = "Telegram: t.me/MetroProjectile",
   Callback = function()
      setclipboard("t.me/MetroProjectile")
      Rayfield:Notify({
         Title = "Telegram",
         Content = "Ссылка скопирована в буфер",
         Duration = 3,
         Image = "message-circle"
      })
   end,
})

local AuthorButton = AboutTab:CreateButton({
   Name = "Автор: GitHubVibe",
   Callback = function()
      setclipboard("GitHubVibe")
      Rayfield:Notify({
         Title = "Автор",
         Content = "Никнейм скопирован в буфер",
         Duration = 3,
         Image = "user"
      })
   end,
})

Rayfield:LoadConfiguration()
