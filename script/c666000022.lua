-- megaman zero

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --synchro summon
  Synchro.AddProcedure(c, aux.FilterSummonCode(CIEL), 1, 1,
    Synchro.NonTunerEx(Card.IsSetCard, ARCHETYPES.MEGAMAN), 1, 99)
  c:EnableReviveLimit()
  c:SetUniqueOnField(1, 1, id)

  --atk def
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(s.e1Value)
  c:RegisterEffect(e1)
end

--ciel
s.material = { HUMANS.CIEL }

--ciel
s.listed_names = { HUMANS.CIEL }

--megaman
s.listed_series = { ARCHETYPES.MEGAMAN }

function s.filter(c)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and c:IsMonster()
end

function s.e1Value(e, c)
  local g = Duel.GetMatchingGroup(s.filter, c:GetControler(),
    LOCATION_GRAVE, 0, nil)
  local ct = g:GetClassCount(Card.GetCode)
  return ct * 500
end
