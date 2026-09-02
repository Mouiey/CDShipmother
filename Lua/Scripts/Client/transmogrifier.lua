if SERVER then return end
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Wearable"], "wearableSprites")
-- 所有的OnUse Hook应该只执行一次，而不是一直执行
local isExecuted={}
Hook.Add("momo_origin", function(_, _, item)
    --print("睁眼")
    if not isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(20,0,180,300)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.75,0.23)
    isExecuted[item.ID] = false
end)
Hook.Add("momo_close", function(_, _, item)
    --print("闭眼")
    if isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(220,0,180,300)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.75,0.23)
    isExecuted[item.ID] = true
end)
Hook.Add("lg_origin", function(_, _, item)
    --print("睁眼")
    if not isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(15,0,180,260)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.77,0.235)
    isExecuted[item.ID] = false
end)
Hook.Add("lg_close", function(_, _, item)
    --print("闭眼")
    if isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(215,0,180,260)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.77,0.235)
    isExecuted[item.ID] = true
end)
Hook.Add("ly_origin", function(_, _, item)
    --print("睁眼")
    if not isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(15,0,180,260)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.77,0.238)
    isExecuted[item.ID] = false
end)
Hook.Add("ly_close", function(_, _, item)
    --print("闭眼")
    if isExecuted[item.ID] then return end
    local itemComponent = item.GetComponentString("Wearable")
    if itemComponent.wearableSprites[1].Sprite == nil then return end
    itemComponent.wearableSprites[1].Sprite.SourceRect=Rectangle(215,0,180,260)
    itemComponent.wearableSprites[1].Sprite.RelativeOrigin=Vector2(0.77,0.238)
    isExecuted[item.ID] = true
end)