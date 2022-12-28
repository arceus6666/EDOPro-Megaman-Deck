-- aile model zx

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

  --indes
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetValue(1)
  c:RegisterEffect(e2)

  local e3 = e2:Clone()
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e3)

  --atk
  local e4 = Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(id, 0))
  e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EVENT_DAMAGE)
  e4:SetCondition(s.e4Condition)
  e4:SetOperation(s.e4Operation)
  c:RegisterEffect(e4)
end

s.listed_names = { MEGAMEN.AILE_MODEL_X, BIOMETALS.BIOMETAL_Z }

function s.spfilter(c)
  return c:IsCode(MEGAMEN.AILE_MODEL_X) and
      c:GetEquipGroup():IsExists(Card.IsCode, 1, nil, BIOMETALS.BIOMETAL_Z)
end

function s.e1Condition(e, c)
  if c == nil then return true end
  return Duel.CheckReleaseGroup(c:GetControler(), s.spfilter, 1, false,
    1, true, c, c:GetControler(), nil, false, nil)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, c)
  local g = Duel.SelectReleaseGroup(tp, s.spfilter, 1, 1, false, true, true,
    c, nil, nil, false, nil)
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

function s.e4Condition(e, tp, eg, ep, ev, re, r, rp)
  if ep ~= tp then return false end
  if (r & REASON_EFFECT) ~= 0 then return rp ~= tp end
  return e:GetHandler():IsRelateToBattle()
end

function s.e4Operation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(ev)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
  end
end
