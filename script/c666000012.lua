-- biometal l

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(MEGAMEN.AILE_MODEL_X))

  --def up
  DEFUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { MEGAMEN.AILE_MODEL_X }
