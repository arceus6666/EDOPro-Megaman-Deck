-- aile model px

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

  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e2)
end

s.listed_names = { MEGAMEN.AILE_MODEL_X, BIOMETALS.BIOMETAL_P }

function s.spfilter(c)
  return c:IsCode(MEGAMEN.AILE_MODEL_X) and
      c:GetEquipGroup():IsExists(Card.IsCode, 1, nil, BIOMETALS.BIOMETAL_P)
end

function s.e1Condition(e, c)
  if c == nil then return true end
  return Duel.CheckReleaseGroup(c:GetControler(), s.spfilter, 1, false, 1,
    true, c, c:GetControler(), nil, false, nil)
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
