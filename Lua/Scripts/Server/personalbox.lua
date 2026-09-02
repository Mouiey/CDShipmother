dofile(CD_Main.Path .. "/Lua/Scripts/stuff.lua")

Hook.Patch("Barotrauma.Items.Components.ItemContainer", "Equip", function(instance, ptable)
  local character = ptable["character"]
  if character.Inventory.GetItemInLimbSlot(InvSlotType.RightHand) ~= nil then return end
  if instance.Item.Prefab.Identifier ~= "cdpersonalcrate" then return end

  local client = getCharacterClient(character)
  --directMessage("Owner: " .. instance.Item.Components[3].OwnerName, "Personal Crate", client, Color.White)

  local function hasAccess()
    if isOwner(character, instance.Item.Components[3]) or isSameId(character.Inventory.GetItemInLimbSlot(InvSlotType.Card), instance.Item.Components[3]) or character.Inventory.GetItemInLimbSlot(InvSlotType.Card).GetComponentString("IdCard").OwnerJobId == 'cdnormalShipmother' then
      return true
    elseif instance.Item.Components[4].Value ~= "0" then -- memory
      return true
    end
    return false
  end

  if hasAccess() then 
    instance.AllowAccess = true
    --directMessage("Access Granted", "Personal Crate", client, Color.Green)
    return
  end
  instance.AllowAccess = false
  --directMessage("Access Denied", "Personal Crate", client, Color.Red)
end, Hook.HookMethodType.Before)

Hook.Patch("Barotrauma.Items.Components.ItemContainer", "Drop", function(instance, ptable)
  if instance.Item.Prefab.Identifier ~= "cdpersonalcrate" then return end
  if tonumber(instance.Item.Components[4].Value) > 0 then 
    instance.Item.Components[4].Value = tonumber(instance.Item.Components[4].Value) - 1 
  end
  instance.AllowAccess = false
end, Hook.HookMethodType.Before)

Hook.Patch("Barotrauma.Items.Components.Holdable", "OnPicked", {"Barotrauma.Character"}, function(instance, ptable)
  if instance.Item.Prefab.Identifier ~= "cdpersonalcrate" then return end
  local character = ptable["picker"]
  local client = getCharacterClient(character)
  instance.Item.Components[4].Value = "2"       
  --directMessage("CRATE FORCED", "Personal Crate", client, Color.Red)
end, Hook.HookMethodType.Before)
