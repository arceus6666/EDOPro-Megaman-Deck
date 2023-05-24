-- biometal p

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, FBF(666000003))

  --atk up
  ATKUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { 666000003 }
