-- biometal x

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(AILE, VENT))

  --def up
  DEFUP(c, 500)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { AILE, VENT }
