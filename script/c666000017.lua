-- Biometal W

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  Ritual.AddProcGreaterCode(c, 7, nil, MEGAMEN.PANDORA, MEGAMEN.PROMETHEUS)
end
