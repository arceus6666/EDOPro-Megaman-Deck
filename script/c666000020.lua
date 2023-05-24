-- ciel's hope

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Activate
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)
end

function s.filter1(c)
  return c:IsIDGroup(BIOMETALS) and c:IsAbleToHand()
end

function s.filter2(c)
  return c:IsIDGroup(MEGAMEN) and c:IsAbleToHand()
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then return false end
  if chk == 0 then
    return Duel.IsExistingTarget(s.filter1, tp, LOCATION_GRAVE, 0, 1, nil) and
        Duel.IsExistingTarget(s.filter2, tp, LOCATION_GRAVE, 0, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g1 = Duel.SelectTarget(tp, s.filter1, tp, LOCATION_GRAVE, 0, 1, 1, nil)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g2 = Duel.SelectTarget(tp, s.filter2, tp, LOCATION_GRAVE, 0, 1, 1, nil)
  g1:Merge(g2)
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, g1, 2, 0, 0)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
  local sg = g:Filter(Card.IsRelateToEffect, nil, e)
  if #sg > 0 then
    Duel.SendtoHand(sg, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, sg)
  end
end
