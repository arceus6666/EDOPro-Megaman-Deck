-- Copy x

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()
  Xyz.AddProcedure(c, nil, 8, 2, nil, nil, 99)

  --indestructible
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCondition(s.e1Condition)
  e1:SetValue(1)
  c:RegisterEffect(e1)

  --spsummon
  local e2 = Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetCost(s.e2Cost)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2, false, REGISTER_FLAG_DETACH_XMAT)

  --Draws for each player plus attaching to this card
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_SET_BASE_ATTACK)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(s.e3Value)
  c:RegisterEffect(e3)

  local e4 = Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_SET_BASE_DEFENSE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetValue(s.e4Value)
  c:RegisterEffect(e4)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.e1Condition(e)
  return e:GetHandler():GetOverlayCount() > 0
end

function s.e2Cost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
  end
  e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.spfilter(c, e, tp)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and
      c:IsType(TYPE_NORMAL) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsLocation(LOCATION_GRAVE) and
        chkc:IsControler(tp) and
        s.spfilter(chkc, e, tp)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 1,
          nil, e, tp)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectTarget(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1,
    nil, e, tp)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
  end
end

function s.e3Value(e, c)
  return c:GetOverlayCount() * 800
end

function s.e4Value(e, c)
  return c:GetOverlayCount() * 600
end
