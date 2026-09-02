Hook.Add("cdrevive.OnUse", "cdrevive", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.Revive()
end)
Hook.Add("cdallheal.OnUse", "cdallheal", function(effect, deltaTime, item, targets, worldPosition)
    local character = targets[1]
    character.CharacterHealth.removeNegativeAfflictions()
end)