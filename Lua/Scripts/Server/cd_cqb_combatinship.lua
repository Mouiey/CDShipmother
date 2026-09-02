Hook.Patch("Barotrauma.Mission", "End", function(instance, ptable)
    if instance.Completed then return end

    instance.TimesAttempted = 0
end, Hook.HookMethodType.After)

Hook.Add("cd_cqb_combatinship", "Iambecomedeath", function(effect, deltaTime, item, targets, worldPosition)
    local order = Order(OrderPrefab.Prefabs["assaultenemy"]).WithManualPriority(CharacterInfo.HighestManualOrderPriority)

    targets[1].SetOrder(order, true, false)
    targets[1].Speak(TextManager.Get("orderdialogself.fightintruders").Value, ChatMessageType.Default, 1.0)
end)