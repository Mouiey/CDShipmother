-- 锁右手
Hook.Add("cdlockrighthand.OnUse", "cdlockrighthand", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    local rightHandItem = character.Inventory.GetItemAt(6)  --左手是5
    local prefab = ItemPrefab.GetItemPrefab("cdarmlockright")
    local handcuffs = character.Inventory.FindItemByIdentifier("cdarmlockright", false)
	if rightHandItem ~= nil and rightHandItem ~= handcuffs then
		rightHandItem.Drop(character)
	end
	Entity.Spawner.AddItemToSpawnQueue(prefab, character.WorldPosition, nil, nil, function(newitem)
		if character.Inventory ~= nil then
			character.Inventory.TryPutItem(newitem, nil, { InvSlotType.RightHand })
--[[ 		elseif character.Inventory ~= nil then
			character.Inventory.TryPutItem(newitem, nil, { InvSlotType.LeftHand }) ]]
		end
	end)
end)
-- 锁左手
Hook.Add("cdlocklefthand.OnUse", "cdlocklefthand", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    local leftHandItem = character.Inventory.GetItemAt(5)  --左手是5
    local prefab = ItemPrefab.GetItemPrefab("cdarmlockleft")
    local handcuffs = character.Inventory.FindItemByIdentifier("cdarmlockleft", false)
	if leftHandItem ~= nil and leftHandItem ~= handcuffs then
		leftHandItem.Drop(character)
	end
	Entity.Spawner.AddItemToSpawnQueue(prefab, character.WorldPosition, nil, nil, function(newitem)
		if character.Inventory ~= nil then
			character.Inventory.TryPutItem(newitem, nil, { InvSlotType.LeftHand })
--[[ 		elseif character.Inventory ~= nil then
			character.Inventory.TryPutItem(newitem, nil, { InvSlotType.LeftHand }) ]]
		end
	end)
end)
-- 释放右手
Hook.Add("cdunlockrighthand.OnUse", "cdunlockrighthand", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    local rightHandItem = character.Inventory.GetItemAt(6)  --左手是5
    local handcuffs = character.Inventory.FindItemByIdentifier("cdarmlockright", false)
	if rightHandItem ~= nil and rightHandItem == handcuffs then
		rightHandItem.Drop(character)
	end
end)
-- 释放左手
Hook.Add("cdunlocklefthand.OnUse", "cdunlocklefthand", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    local leftHandItem = character.Inventory.GetItemAt(5)  --左手是5
    local handcuffs = character.Inventory.FindItemByIdentifier("cdarmlockleft", false)
	if leftHandItem ~= nil and leftHandItem == handcuffs then
		leftHandItem.Drop(character)
	end
end)


