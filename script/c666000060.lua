-- Seraph X

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --xyz summon
  Xyz.AddProcedure(c, nil, 99, 99, s.ovfilter, aux.Stringid(id, 0))
  c:EnableReviveLimit()

  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 2))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetCost(s.descost)
  e2:SetTarget(s.destg)
  e2:SetOperation(s.desop)
  c:RegisterEffect(e2, false, REGISTER_FLAG_DETACH_XMAT)
end

function s.ovfilter(c, tp, xyzc)
  return c:IsFaceup() and
      c:IsSetCard(0x6D6D, xyzc, SUMMON_TYPE_XYZ, tp) and
      c:IsType(TYPE_XYZ, xyzc, SUMMON_TYPE_XYZ, tp) and
      not c:IsSummonCode(xyzc, SUMMON_TYPE_XYZ, tp, id)
end

function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
  end
  e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
  Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsOnField() and
        chkc:IsControler(1 - tp) and
        chkc:IsFaceup()
  end
  if chk == 0 then
    return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
  local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0,
    LOCATION_ONFIELD, 1, 1, nil)
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Destroy(tc, REASON_EFFECT)
  end
end
