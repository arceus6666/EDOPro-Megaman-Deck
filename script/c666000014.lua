-- biometal h

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(VENT_MODEL_X))

  --equip effect
  DEFUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { VENT_MODEL_X }
