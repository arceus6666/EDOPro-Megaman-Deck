-- Pandora

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Cannot be destroyed
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(s.e1Value)
  c:RegisterEffect(e1)

  local e2 = e1:Clone()
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetValue(s.e2Value)
  c:RegisterEffect(e2)
end

function s.e1Value(e, c)
  return not c:IsType(TYPE_RITUAL)
end

function s.e2Value(e, re, rp)
  return re:IsActiveType(TYPE_MONSTER) and
      not re:IsActiveType(TYPE_RITUAL)
end
