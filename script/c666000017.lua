-- Biometal W

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  Ritual.AddProcGreaterCode(c, 7, nil, 666000018, 666000019)
  -- Ritual.AddProcGreaterCode(c, 7, nil, 666000019)
end
