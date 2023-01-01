-- aeolus model h

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --fusion material
  c:EnableReviveLimit()
  Fusion.AddProcMix(c, true, true, PSEUDORIODS.HIVOLT, PSEUDORIODS.HURIICAUNE)

  --spsummon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(aux.fuslimit)
  c:RegisterEffect(e1)

  --search
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 0))
  e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetCondition(s.e2Condition)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)

  --Special summon regular aeolus from deck
  local e3 = Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id, 0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetCondition(s.e3Condition)
  e3:SetTarget(s.e3Target)
  e3:SetOperation(s.e3Operation)
  c:RegisterEffect(e3)
end

s.listed_names = {
  BIOMETALS.BIOMETAL_H,
  PSEUDORIODS.HIVOLT,
  PSEUDORIODS.HURIICAUNE
}
s.material_setcode = { 0x8, ARCHETYPES.PSUEDOROID }

function s.e2Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and
      e:GetHandler():IsReason(REASON_BATTLE)
end

function s.filter(c)
  return c:IsCode(BIOMETALS.BIOMETAL_H) and c:IsAbleToHand()
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK,
    0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, g)
  end
end

function s.filter2(c, e, tp)
  return c:IsCode(666000056) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e3Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and
      e:GetHandler():IsReason(REASON_BATTLE)
end

function s.e3Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK,
          0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK)
end

function s.e3Operation(e, tp, eg, ep, ev, re, r, rp)
  local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
  if ft <= 0 then return end
  -- if ft >= 1 then ft = 1 end
  -- if Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) then ft = 1 end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_DECK, 0, 1,
    1, nil, e, tp)

  if #g > 0 then
    -- local t1 = g:GetFirst()
    -- local t2 = g:GetNext()
    Duel.SpecialSummonStep(g:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
    --Cannot be used as synchro material
    -- local e1 = Effect.CreateEffect(e:GetHandler())
    -- e1:SetDescription(3310)
    -- e1:SetType(EFFECT_TYPE_SINGLE)
    -- e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL + EFFECT_FLAG_CLIENT_HINT)
    -- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    -- e1:SetValue(1)
    -- e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
    -- t1:RegisterEffect(e1)
    -- if t2 then
    --   Duel.SpecialSummonStep(t2, 0, tp, tp, false, false, POS_FACEUP)
    --   local e2 = e1:Clone()
    --   t2:RegisterEffect(e2)
    -- end
    Duel.SpecialSummonComplete()
  end
end
