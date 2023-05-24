-- biometal z

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, aux.OR(
    aux.FilterBoolFunction(Card.IsCode, MEGAMEN.AILE_MODEL_X),
    aux.FilterBoolFunction(Card.IsCode, MEGAMEN.VENT_MODEL_X)
  ))

  -- atk up
  ATKUP(c, 1000)

  -- def up
  DEFUP(c, 1000)
end

s.listed_names = { MEGAMEN.AILE_MODEL_X, MEGAMEN.VENT_MODEL_X }
