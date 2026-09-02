local function HasAffliction(character,identifier,minamount)
    if character==nil or character.CharacterHealth==nil then return false end

    local aff = character.CharacterHealth.GetAffliction(identifier)
    local res = false
    if(aff~=nil) then
        res = aff.Strength >= (minamount or 0.5)
    end
    return res
end

local function lerp(a,b,t)  --定义函数
	return a* (1- t) + b * t  --啊吧啊吧啊吧
end


Hook.Patch("Barotrauma.Character", "ControlLocalPlayer", function(instance, ptable)  --补Hook
    local character = instance  --变量

    if not character then return end  
    if Game.GameSession.IsTabMenuOpen then return end
    if GUI.GUI.PauseMenuOpen then return end
    if GUI.KeyboardDispatcher.Subscriber then return end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("cd_farsight",true,2) or character.HasEquippedItem("tsm_farsight",true,4)) and not character.SelectedItem then
    		Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.999)
            , 415)
    end


end, Hook.HookMethodType.After)