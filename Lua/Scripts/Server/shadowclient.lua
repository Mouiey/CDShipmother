-- 影子
Hook.Add("cdshadow.OnUse", "cdshadow", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    if not character then return end
    character.Info.Head.SkinColor = Color.Black
    character.Info.Head.HairColor = Color.Black
    character.Info.Head.FacialHairColor = Color.Black
    character.Info:RefreshHead()
    --print("Done")
end)
Hook.Add("cdshadowcloth.OnUse", "cdshadowcloth", function(effect, deltaTime, item, targets, worldPosition)
	--print("Do")
  local character = targets[1]
	for item in character.Inventory.AllItems do
    	local wearable = item:GetComponentString("Wearable")
    	if wearable then
			item.SpriteColor = Color.Black
    	end
	end
	--print("Done")
end)