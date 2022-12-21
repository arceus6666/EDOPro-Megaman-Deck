-- biometal h

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(MEGAMEN.VENT_MODEL_X))

  --equip effect
  DEFUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { MEGAMEN.VENT_MODEL_X }
