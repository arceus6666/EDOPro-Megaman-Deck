-- biometal z

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(
    c,
    nil,
    aux.OR(
      aux.FilterBoolFunction(Card.IsCode, AILE_MODEL_X),
      aux.FilterBoolFunction(Card.IsCode, VENT_MODEL_X)
    )
  )

  --equip effect
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_EQUIP)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(1000)
  c:RegisterEffect(e1)

  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  e2:SetValue(1000)
  c:RegisterEffect(e2)
end

s.listed_names = { AILE_MODEL_X, VENT_MODEL_X }
