-- animal elf

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  --equip
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_EQUIP)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetRange(LOCATION_HAND + LOCATION_MZONE)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  --to hand
  local e2 = Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
  e2:SetCondition(s.e2Condition)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.filter(c)
  return c:IsFaceup() and c:IsSetCard(ARCHETYPES.MEGAMAN)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsLocation(LOCATION_MZONE) and
        chkc:IsControler(tp) and
        s.filter(chkc)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 and
        Duel.IsExistingTarget(s.filter, tp, LOCATION_MZONE, 0, 1,
          e:GetHandler())
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
  Duel.SelectTarget(tp, s.filter, tp, LOCATION_MZONE, 0, 1, 1, e:GetHandler())
  Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
  local tc = Duel.GetFirstTarget()
  if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 or
      tc:GetControler() ~= tp or tc:IsFacedown() or
      not tc:IsRelateToEffect(e) then
    Duel.SendtoGrave(c, REASON_EFFECT)
    return
  end
  Duel.Equip(tp, c, tc, true)

  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_EQUIP_LIMIT)
  e1:SetReset(RESET_EVENT + RESETS_STANDARD)
  e1:SetLabelObject(tc)
  e1:SetValue(s.e1OperationE1Value)
  c:RegisterEffect(e1)

  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetValue(600)
  e2:SetReset(RESET_EVENT + RESETS_STANDARD)
  c:RegisterEffect(e2)
end

function s.e1OperationE1Value(e, c)
  return c == e:GetLabelObject()
end

function s.e2Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.thfilter(c)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and c:IsAbleToHand()
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.thfilter, tp,
      LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK,
    0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, g)
  end
end
