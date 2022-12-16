-- ritual omega

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Activate
  -- Ritual.AddProcEqual { handler = c, filter = s.ritualfil, extrafil = s.extrafil, extratg = s.extratg, lv = 99 }

  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.target)
  e1:SetOperation(s.activate)
  c:RegisterEffect(e1)
  if not s.ritual_matching_function then
    s.ritual_matching_function = {}
  end
  s.ritual_matching_function[c] = aux.FilterEqualFunction(Card.IsCode, OMEGA)
end

s.listed_names = { OMEGA, MEGAMAN_ZERO }

-- function s.ritualfil(c)
--   return c:IsCode(OMEGA) and c:IsRitualMonster()
-- end

function s.mfilter(c)
  return not Duel.IsPlayerAffectedByEffect(c:GetControler(), 69832741) and c:IsCode(MEGAMAN_ZERO) and c:IsAbleToRemove()
end

function s.extrafil(e, tp, eg, ep, ev, re, r, rp, chk)
  return Duel.GetMatchingGroup(s.mfilter, tp, LOCATION_GRAVE, 0, nil)
end

-- function s.extratg(e, tp, eg, ep, ev, re, r, rp, chk)
--   if chk == 0 then return true end
--   Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_GRAVE)
-- end

function s.filter(c, e, tp, lp)
  if not c:IsRitualMonster() or not c:IsCode(OMEGA) or not c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, true,
    false) then
    return false
  end
  return lp > c:GetLevel() * 500
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    local lp = Duel.GetLP(tp)
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND, 0, 1, nil, e, tp, lp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp, chk)

  local loc = Duel.GetLocationCount(tp, LOCATION_MZONE)

  Debug.Message(loc)

  if loc <= 0 then return end

  local ingy = s.extrafil(e, tp, eg, ep, ev, re, r, rp, chk):GetCount()

  -- if ingy < 1 then return end

  local lp = Duel.GetLP(tp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local tg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND, 0, 1, 1, nil, e, tp, lp)
  local tc = tg:GetFirst()
  if tc then
    mustpay = true
    Duel.PayLPCost(tp, tc:GetLevel() * 500)
    mustpay = false
    tc:SetMaterial(nil)
    Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, true, false, POS_FACEUP)
    tc:CompleteProcedure()
  end
end
