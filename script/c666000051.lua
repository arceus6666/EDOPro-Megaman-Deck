-- atlas model f

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --fusion material
  c:EnableReviveLimit()
  Fusion.AddProcMix(c, true, true, PSEUDORIODS.FLAMMOLE, PSEUDORIODS.FISTLEO)

  --search
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLE_DESTROYED)
  e1:SetCondition(s.e1Condition)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  --Special summon regular aeolus from deck
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetCondition(s.e2Condition)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)
end

s.listed_names = {
  BIOMETALS.BIOMETAL_F,
  PSEUDORIODS.FLAMMOLE,
  PSEUDORIODS.FISTLEO,
  MEGAMEN.ATLAS
}
s.material_setcode = { 0x8, ARCHETYPES.PSUEDOROID }

function s.e1Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and
      e:GetHandler():IsReason(REASON_BATTLE)
end

function s.filter(c)
  return c:IsCode(BIOMETALS.BIOMETAL_F) and c:IsAbleToHand()
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK,
    0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, g)
  end
end

function s.filter2(c, e, tp)
  return c:IsCode(MEGAMEN.ATLAS) and
      c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function s.e2Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and
      e:GetHandler():IsReason(REASON_BATTLE)
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_DECK,
          0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
  if ft <= 0 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_DECK, 0, 1,
    1, nil, e, tp)
  if #g > 0 then
    Duel.SpecialSummonStep(g:GetFirst(), 0, tp, tp, true, true, POS_FACEUP)
    Duel.SpecialSummonComplete()
  end
end

