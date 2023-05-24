-- Aqua Pantheon

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_PHASE + PHASE_STANDBY)
  e1:SetCondition(s.e1Condition)
  e1:SetCost(s.e1Cost)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)
end

s.listed_names = { REPLOIDS.MODIFIED_PANTHEON_AQUA }

function s.e1Condition(e, tp, eg, ep, ev, re, r, rp)
  return tp == Duel.GetTurnPlayer()
end

function s.e1Cost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return e:GetHandler():IsAbleToGraveAsCost() end
  Duel.SendtoGrave(e:GetHandler(), REASON_COST)
end

function s.spfilter(c, e, tp)
  return c:IsCode(REPLOIDS.MODIFIED_PANTHEON_AQUA) and
      c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
  if e:GetHandler():GetSequence() < 5 then ft = ft + 1 end
  if chk == 0 then return ft > 0 and
        Duel.IsExistingMatchingCard(s.spfilter, tp,
          LOCATION_HAND + LOCATION_DECK, 0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp,
    LOCATION_HAND + LOCATION_DECK)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local tc = Duel.SelectMatchingCard(tp, s.spfilter, tp,
    LOCATION_HAND + LOCATION_DECK, 0, 1, 1, nil, e, tp):GetFirst()
  if tc and Duel.SpecialSummon(tc, 1, tp, tp, true, true, POS_FACEUP) > 0 then
    tc:CompleteProcedure()
  end
end
