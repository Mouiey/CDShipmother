Hook.Add("cdteleporttocursor.OnUse", "cdteleporttocursor", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.TeleportTo(character.CursorWorldPosition)
end)
Hook.Add("cdteleporttoship.OnUse", "cdteleporttoship", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.TeleportTo(character.CursorWorldPosition)
end)