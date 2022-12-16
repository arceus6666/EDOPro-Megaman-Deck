-- Modified Pantheon Aqua

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --Cannot special summon
  local e1 = Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e1)

  --special summon
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 2))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_LEAVE_FIELD)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetCondition(s.e2Condition)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)

  --indestructible reploid
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetTargetRange(LOCATION_MZONE, 0)
  e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, ARCHETYPES.REPLOID))
  e3:SetValue(1)
  c:RegisterEffect(e3)

  Debug.Message('reploid: ' .. ARCHETYPES.REPLOID)
end

s.listed_names = { MODIFIED_PANTHEON_AQUA }
s.listed_series = { ARCHETYPES.REPLOID }

function s.filter(c, e, tp)
  return c:IsCode(MODIFIED_PANTHEON_AQUA) and c:IsCanBeSpecialSummoned(e, 0, tp, true, true)
end

function s.e2Condition(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation() ~= LOCATION_DECK
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
        and Duel.IsExistingMatchingCard(s.filter, tp, 0x13, 0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0x13)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.filter), tp, 0x13, 0, 1, 1, nil, e, tp)
  if #g > 0 then
    Duel.SpecialSummon(g, 0, tp, tp, true, true, POS_FACEUP)
  end
end
