-- biometal x

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(MEGAMEN.AILE, MEGAMEN.VENT))

  --def up
  DEFUP(c, 500)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { MEGAMEN.AILE, MEGAMEN.VENT }
