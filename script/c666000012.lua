-- biometal l

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(AILE_MODEL_X))

  --def up
  DEFUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { AILE_MODEL_X }
