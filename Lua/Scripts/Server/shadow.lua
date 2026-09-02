local SpawnQueue = {}
local isShadowed={}
Hook.Add("shadowowner.OnUse", "shadow", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    if character == nil or character.Removed then return end
    if isShadowed[character.Info.Name] then return end
    isShadowed[character.Info.Name] = true
    table.insert(SpawnQueue, character)
    --print("Push:", character.Name, "QueueSize:", #SpawnQueue)
    local prefab = AfflictionPrefab.Prefabs["cdisshadowspawnaff1"]
    if prefab ~= nil then
        local aff = prefab.Instantiate(100)   -- 100 = 强度
        character.CharacterHealth.ApplyAffliction(nil, aff)
    end
    --Entity.Spawner.AddCharacterToSpawnQueue(
    --    "Humanshadow2",
    --    character.WorldPosition
    --)
    -- 这里的 character 就是 AFF 的主人
    
end)

Hook.Patch(
"Barotrauma.Character",
"Create",
{
  "Barotrauma.CharacterPrefab",
  "Microsoft.Xna.Framework.Vector2",
  "System.String",
  "Barotrauma.CharacterInfo",
  "System.UInt16",
  "System.Boolean",
  "System.Boolean",
  "System.Boolean",
  "Barotrauma.RagdollParams",
  "System.Boolean"
},
function(instance, ptable)

    -- 只处理 Humanshadow
    if ptable["prefab"].Name ~= "HumanShadow2" then
        return
    end
    --print(
    --    "Create:",
    --    ptable["prefab"].Name,
    --    "QueueSize:",
    --    #SpawnQueue
    --)
    if #SpawnQueue == 0 then
      return
    end
    -- 从队列里取出这次召唤对应的主人
    local character = table.remove(SpawnQueue,1)

    if character == nil or character.Removed then
        return
    end

    ----------------------------------------------------
    -- 深复制 CharacterInfo
    ----------------------------------------------------

    local parentElement = XElement("CharacterInfo")
    local infoElement = character.Info.Save(parentElement)
    local cloneInfo = CharacterInfo(ContentXElement(nil, infoElement))

    ----------------------------------------------------
    -- 保留原作者这两句
    ----------------------------------------------------

    cloneInfo.TeamID = character.TeamID
    cloneInfo.ID = character.ID

    ----------------------------------------------------
    -- 替换Create参数
    ----------------------------------------------------

    ptable["characterInfo"] = cloneInfo

    -- 不生成默认职业装备
    ptable["spawnInitialItems"] = false

end,
Hook.HookMethodType.Before)

local function IsWeapon(item)
    return item.GetComponentString("RangedWeapon") ~= nil
        or item.GetComponentString("MeleeWeapon") ~= nil
        or item.GetComponentString("Projectile") ~= nil   -- 可选
end

local function RemoveItem(item)
  if item == nil or item.Removed then return end

  if Entity.Spawner == nil then
    Timer.Wait(function()
      RemoveItem(item)
    end, 100)

    return
  end

  Entity.Spawner.AddItemToRemoveQueue(item)
end

function GetItemContainerElement(itemPrefab)
  for subElement in itemPrefab.ConfigElement.Elements() do
    for childElement in subElement.Elements() do
      if tostring(childElement.Name) == "ItemContainer" then
        return childElement
      end
    end
    if tostring(subElement.Name) == "ItemContainer" then
      return subElement
    end
  end

  return nil
end

local function GetSlotIconList(item)
  local slotIcons = {}

  local currCapacity = item.GetComponentString("ItemContainer").MainContainerCapacity
  local capacity = item.GetComponentString("ItemContainer").Capacity
  local itemContainer = GetItemContainerElement(item.Prefab)

  if itemContainer == nil then return slotIcons end

  for subElement in itemContainer.Elements() do
    local subElementString = string.lower(tostring(subElement.Name))
    if subElementString == "sloticon" then
      local index = subElement.GetAttributeInt("slotindex", -1)
      for i = 0, capacity - 1 do
        if i == index or index == -1 then
          slotIcons[i] = true
        end
      end
    elseif subElementString == "subcontainer" then
      local subContainerCapacity = subElement.GetAttributeInt("capacity", 1)
      local slotIconElement = subElement.GetChildElement("sloticon")
      if slotIconElement ~= nil then
        for i = currCapacity, currCapacity + subContainerCapacity - 1 do
          slotIcons[i] = true
        end
      end
      currCapacity = currCapacity + subContainerCapacity
    end
  end

  return slotIcons
end

local function CopyInventory(sourceItem, targetItem, onlyCopyItemsWithSlotIcon)
  if sourceItem.OwnInventory == nil then return end

  if onlyCopyItemsWithSlotIcon then
    local slotIcons = GetSlotIconList(sourceItem)
    for item in sourceItem.OwnInventory.AllItemsMod do
      local index = sourceItem.OwnInventory.FindIndex(item)
      if slotIcons[index] then
      -- if sourceItem.GetComponentString("ItemContainer").GetSlotIcon(index) ~= nil then
        Entity.Spawner.AddItemToSpawnQueue(item.Prefab, targetItem.WorldPosition, item.Condition, item.Quality, function(spawnedItem)
          --给内容物也变黑
          spawnedItem.SpriteColor = Color.Black
          --SyncItemProperty(spawnedItem, "SpriteColor")
          if  not spawnedItem.HasTag("medical") then
            spawnedItem.InvulnerableToDamage = true
            spawnedItem.NonPlayerTeamInteractable = true
          end

          if not targetItem.OwnInventory.TryPutItem(spawnedItem, index, true, false, nil) then
            RemoveItem(spawnedItem)
          else
            CopyInventory(item, spawnedItem, onlyCopyItemsWithSlotIcon)
          end
        end)
      end
    end
  else
    for item in sourceItem.OwnInventory.AllItemsMod do
      Entity.Spawner.AddItemToSpawnQueue(item.Prefab, targetItem.OwnInventory, item.Condition, item.Quality, function(spawnedItem)
        --给内容物也变黑
        spawnedItem.SpriteColor = Color.Black
        --SyncItemProperty(spawnedItem, "SpriteColor")

        CopyInventory(item, spawnedItem, onlyCopyItemsWithSlotIcon)
      end)
    end
  end
end

local function SyncItemProperty(item, propertyName)
  if not SERVER then return end

  local property = item.SerializableProperties[Identifier(propertyName)]
  Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(property, item))
end

local function CopyItem(character, item, index)
  if item == nil or item.Removed then return end

  Entity.Spawner.AddItemToSpawnQueue(item.Prefab, character.WorldPosition, item.Condition, item.Quality, function(spawnedItem)
    if not character.Inventory.TryPutItem(spawnedItem, index, true, false, nil) then
      RemoveItem(spawnedItem)
      return
    end

    -- spawnedItem.NonInteractable = true
    if  not spawnedItem.HasTag("medical") then
      spawnedItem.InvulnerableToDamage = true
    end
    spawnedItem.NonPlayerTeamInteractable = true
    spawnedItem.Scale = item.Scale
    spawnedItem.SpriteColor =  Color.Black
    spawnedItem.tags = item.tags

    -- SyncItemProperty(spawnedItem, "NonInteractable")
    SyncItemProperty(spawnedItem, "NonPlayerTeamInteractable")
    SyncItemProperty(spawnedItem, "Scale")
    SyncItemProperty(spawnedItem, "SpriteColor")

    if spawnedItem.GetComponentString("WifiComponent") then
      spawnedItem.GetComponentString("WifiComponent").TeamID = item.GetComponentString("WifiComponent").TeamID
    end

    if spawnedItem.GetComponentString("IdCard") then
      spawnedItem.GetComponentString("IdCard").OwnerName = item.GetComponentString("IdCard").OwnerName
    end

    local invSlotType = character.Inventory.SlotTypes[index + 1]

    if invSlotType == InvSlotType.HealthInterface then
      CopyInventory(item, spawnedItem, false)
    else
      CopyInventory(item, spawnedItem, true)
    end
  end)
end


Hook.Add("humanshadow.OnSpawn", "humanshadow.SpawnItems", function(effect, deltaTime, item, targets, worldPosition)
  local character = targets[1]
  if character == nil or character.Removed then return end
  Timer.Wait(function()
  character.SetOriginalTeamAndChangeTeam(CharacterTeamType.None, true)
  
  local prototypeCharacter = Entity.FindEntityByID(character.Info.ID)
  
  if prototypeCharacter == nil or prototypeCharacter.Removed then return end
  if not LuaUserData.IsTargetType(prototypeCharacter, "Barotrauma.Character") then return end
  --if not (prototypeCharacter.IsOnPlayerTeam and prototypeCharacter.IsHuman) then return end


  for affliction in prototypeCharacter.CharacterHealth.GetAllAfflictions() do
    if affliction.Prefab.IsBuff then
      character.CharacterHealth.ApplyAffliction(prototypeCharacter.CharacterHealth.GetAfflictionLimb(affliction), affliction.Prefab.Instantiate(affliction.Strength * character.MaxVitality / 100))
    end
  end

  --character.Info.Head.SkinColor = Color.Black
  --character.Info.Head.HairColor = Color.Black
  --character.Info.Head.FacialHairColor = Color.Black
  --character.Info:RefreshHead()
  --变黑aff
  local shadowaffprefab = AfflictionPrefab.Prefabs["cdisshadow"]
  if shadowaffprefab ~= nil then
      local aff = shadowaffprefab.Instantiate(100)   -- 100 = 强度
      character.CharacterHealth.ApplyAffliction(nil, aff)
  end
  --强化aff
  local shadowstrengthaffprefab = AfflictionPrefab.Prefabs["cdrobotaffshadow"]
  if shadowstrengthaffprefab ~= nil then
      local aff = shadowstrengthaffprefab.Instantiate(100)   -- 100 = 强度
      character.CharacterHealth.ApplyAffliction(nil, aff)
  end

  local isPvPMode = false
  if Game.GameSession and LuaUserData.IsTargetType(Game.GameSession.GameMode, "Barotrauma.PvPMode") then isPvPMode = true end
  --if character.info and character.info.Job then
  --  character.info.Job.GiveJobItems(character, isPvPMode)
  --end

  for _, containedItem in pairs(character.Inventory.AllItemsMod) do
    local index = character.Inventory.FindIndex(containedItem)
    local slotType = character.Inventory.SlotTypes[index + 1]

    if slotType ~= InvSlotType.Card and slotType ~= InvSlotType.Any and not (slotType == InvSlotType.OuterClothes and character.PressureProtection > 0 and not prototypeCharacter.IsProtectedFromPressure) then
      RemoveItem(containedItem)
    end
  end

  for _, containedItem in pairs(prototypeCharacter.Inventory.AllItemsMod) do
    local index = prototypeCharacter.Inventory.FindIndex(containedItem)
    local slotType = prototypeCharacter.Inventory.SlotTypes[index + 1]
    
    if slotType ~= InvSlotType.Card then    
      CopyItem(character, containedItem, index)
    end
    --if slotType ~= InvSlotType.Any then      
    --end
  end

  local order1 = Order(OrderPrefab.Prefabs["assaultenemy"]).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
  local order2 = Order(OrderPrefab.Prefabs["findweapon"]).WithManualPriority(CharacterInfo.HighestManualOrderPriority)
  character.SetOrder(order2, true, false)
  character.SetOrder(order1, true, false)
  end,100)
end)

Hook.Add("humanshadow.OnDeath", "humanshadow.RemoveItems", function(effect, deltaTime, item, targets, worldPosition)
  local character = targets[1]
  if character == nil or character.Removed then return end

  isShadowed[character.Info.Name] = false

  --for heldItem in character.HeldItems do
  --  RemoveItem(heldItem)
  --end
  for item in character.Inventory.AllItemsMod do
    if item.NonPlayerTeamInteractable == true and item.Prefab.Identifier ~= "cdshadowclose" then
      RemoveItem(item)
    end
  end
  character.AddAbilityFlag(AbilityFlags.IgnoredByEnemyAI)
end)

Hook.Add("roundEnd", "Shadow.ClearData", function()

    isShadowed = {}
    SpawnQueue = {}

end)