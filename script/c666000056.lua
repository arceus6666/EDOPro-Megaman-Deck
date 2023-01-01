-- aeolus

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --cannot special summon
  CannotSpecialSummon(c)

  --disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)

end

function s.distg(e,c)
	return c:IsSpell()
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
  local tl = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_LOCATION)
  if (tl & LOCATION_SZONE) ~= 0 and re:IsActiveType(TYPE_SPELL) then
    Duel.NegateEffect(ev)
  end
end
