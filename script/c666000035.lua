-- omega

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Immune
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(1)
  c:RegisterEffect(e1)

  local e2 = e1:Clone()
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetValue(1)
  c:RegisterEffect(e2)
end
