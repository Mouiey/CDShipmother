Hook.Add("cdthermalstealth.OnUse", "cdthermalstealth", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.Params.HideInThermalGoggles = true
end)
Hook.Add("cdnothermalstealth.OnUse", "cdnothermalstealth", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.Params.HideInThermalGoggles = false
end)