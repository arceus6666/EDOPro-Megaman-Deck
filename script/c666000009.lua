-- VENT model fx

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  c:EnableReviveLimit()

  --spsummon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_DECK + LOCATION_HAND)
  e1:SetCondition(s.e1Condition)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  --destroy
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCountLimit(1)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)
end

s.listed_names = { VENT_MODEL_X, BIOMETAL_F }

function s.spfilter(c)
  return c:IsCode(VENT_MODEL_X) and c:GetEquipGroup():IsExists(Card.IsCode, 1, nil, BIOMETAL_F)
end

function s.e1Condition(e, c)
  if c == nil then return true end
  return Duel.CheckReleaseGroup(c:GetControler(), s.spfilter, 1, false, 1, true, c, c:GetControler(), nil, false, nil)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, c)
  local g = Duel.SelectReleaseGroup(tp, s.spfilter, 1, 1, false, true, true, c, nil, nil, false, nil)
  if c ~= 0 then
    local tc = Duel.GetAttacker()
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, tc, 1, 0, 0)
  end
  if g then
    g:KeepAlive()
    e:SetLabelObject(g)
    return true
  end
  return false
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp, c)
  local g = e:GetLabelObject()
  if not g then return end
  Duel.Release(g, REASON_COST)
  g:DeleteGroup()
end

function s.desfilter(c, atk)
  return c:IsFaceup() and c:IsAttackBelow(atk)
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  local c = e:GetHandler()
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.desfilter(chkc, c:GetAttack()) end
  if chk == 0 then return Duel.IsExistingTarget(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, c:GetAttack()) end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
  local g = Duel.SelectTarget(tp, s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, c:GetAttack())
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Destroy(tc, REASON_EFFECT)
  end
end
