-- aile model x

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

  --double atk
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_EXTRA_ATTACK)
  e2:SetValue(1)
  c:RegisterEffect(e2)
end

s.listed_names = { MEGAMEN.AILE, BIOMETALS.BIOMETAL_X }

-- check if aile is equipped wiht biometal x
function s.spfilter(c, tp)
  return c:IsCode(MEGAMEN.AILE) and
      c:GetEquipGroup():IsExists(Card.IsCode, 1, nil, BIOMETALS.BIOMETAL_X)
end

-- checks if can summon
function s.e1Condition(e, c)
  if c == nil then return true end
  return Duel.CheckReleaseGroup(c:GetControler(), s.spfilter, 1,
    false, 1, true, c, c:GetControler(), nil, false, nil)
end

-- makes spsummon
function s.e1Target(e, tp, eg, ep, ev, re, r, rp, c)
  local g = Duel.SelectReleaseGroup(tp, s.spfilter, 1, 1, false,
    true, true, c, nil, nil, false, nil)
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
