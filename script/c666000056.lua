-- aeolus

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --cannot special summon
  CannotSpecialSummon(c)

  --disable effect
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_CHAIN_SOLVING)
  e3:SetRange(LOCATION_MZONE)
  e3:SetOperation(s.disop)
  c:RegisterEffect(e3)

end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
  local tl = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
  if (tl & LOCATION_SZONE) ~= 0 and re:IsActiveType(TYPE_SPELL) then
    Duel.NegateEffect(ev)
  end
end
