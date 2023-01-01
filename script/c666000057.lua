-- thetis

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --cannot special summon
  CannotSpecialSummon(c)
end
