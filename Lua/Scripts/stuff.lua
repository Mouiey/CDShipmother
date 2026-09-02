function directMessage(txt, sender, recipient, color) 
    local chatMessage = ChatMessage.Create(sender, txt, ChatMessageType.Default, nil, nil)
    chatMessage.Color = color
    Game.SendDirectChatMessage(chatMessage, recipient)
end


function getCharacterClient(character)  
  for key, c in pairs(Client.ClientList) do
    if c.Character == character then return c end
  end
  return nil
end

--[[ compara dos componentes IDcard
function isSameId(id1, id2)   
  if id1 == nil then return 
  else id1 = id1.Components[2] end
  if id1.OwnerName == id2.OwnerName and id1.OwnerJobId == id2.OwnerJobId and id1.OwnerSkinColor == id2.OwnerSkinColor then 
    --print("is same ID")
    return true
  end
  --print("Not same ID")
  return false
end
]]

function isSameId(id1, id2)   
  if id1 == nil then return 
  else id1 = id1.GetComponentString("IdCard") end
  if id1.OwnerName == id2.OwnerName and id1.OwnerJobId == id2.OwnerJobId and id1.OwnerSkinColor == id2.OwnerSkinColor then 
    --print("is same ID")
    return true
  end
  --print("Not same ID")
  return false
end

function isOwner(character, id) 
  if character.Name == id.OwnerName and character.Info.Job.Prefab.Identifier == id.OwnerJobId and character.Info.Head.SkinColor == id.OwnerSkinColor then 
    --print("is owner")
    return true
  end
  --print("Not Owner")
  return false
end
