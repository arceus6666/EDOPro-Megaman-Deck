--Ciel

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --to deck
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_GRAVE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1, id)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)
end

s.listed_series = { 0x6D6D }

function s.tdfilter(c)
  return c:IsSetCard(0x6D6D) and c:IsLevelBelow(6) and c:IsAbleToDeck()
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc
  then return chkc:IsLocation(LOCATION_GRAVE)
        and chkc:IsControler(tp)
        and s.tdfilter(chkc)
  end
  if chk == 0
  then return e:GetHandler():IsAbleToHand()
        and Duel.IsExistingTarget(s.tdfilter, tp, LOCATION_GRAVE, 0, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
  local g = Duel.SelectTarget(tp, s.tdfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
  Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, e:GetHandler(), 1, 0, 0)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  local c = e:GetHandler()
  if tc
      and tc:IsRelateToEffect(e)
      and Duel.SendtoDeck(tc, nil, 2, REASON_EFFECT) ~= 0
      and tc:IsLocation(LOCATION_DECK + LOCATION_EXTRA)
      and c:IsRelateToEffect(e)
  then
    Duel.SendtoHand(c, nil, REASON_EFFECT)
  end
end
