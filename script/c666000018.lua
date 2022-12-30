-- Pandora

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  Pendulum.AddProcedure(c)
  c:EnableUnsummonable()

  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_REVIVE_LIMIT)
  e1:SetCondition(s.e1Condition)
  c:RegisterEffect(e1)

  --Special Summon condition
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EFFECT_SPSUMMON_CONDITION)
  e2:SetValue(s.e2Value)
  c:RegisterEffect(e2)

  --Cannot be destroyed
  local e3 = Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(s.e3Value)
  c:RegisterEffect(e3)

  local e4 = e3:Clone()
  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e4:SetValue(s.e4Value)
  c:RegisterEffect(e4)

  --def
  local e5 = Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD)
  e5:SetCode(EFFECT_UPDATE_DEFENSE)
  e5:SetRange(LOCATION_PZONE)
  e5:SetTargetRange(LOCATION_MZONE, 0)
  e5:SetTarget(s.e5Target)
  e5:SetValue(500)
  c:RegisterEffect(e5)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.e1Condition(e)
  return not e:GetHandler():IsLocation(LOCATION_HAND)
end

function s.e2Value(e, se, sp, st)
  return (st & SUMMON_TYPE_RITUAL) == SUMMON_TYPE_RITUAL or
      ((st & SUMMON_TYPE_PENDULUM) == SUMMON_TYPE_PENDULUM and
          e:GetHandler():IsLocation(LOCATION_HAND))
end

function s.e3Value(e, c)
  return not c:IsType(TYPE_RITUAL)
end

function s.e4Value(e, re, rp)
  return re:IsActiveType(TYPE_MONSTER) and
      not re:IsActiveType(TYPE_RITUAL)
end

function s.e5Target(e, c)
  return c:IsSetCard(ARCHETYPES.MEGAMAN)
end
