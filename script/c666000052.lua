-- crea

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  --pendulum summon
  Pendulum.AddProcedure(c)

  --to hand
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLED)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(s.e1Condition)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  --cannot be material
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
  e2:SetValue(s.e2Value)
  c:RegisterEffect(e2)

  local e3 = e2:Clone()
  e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
  c:RegisterEffect(e3)

  local e4 = e2:Clone()
  e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
  c:RegisterEffect(e4)
end

s.listed_series = { ARCHETYPES.CYBER_ELF }

function s.e1Condition(e, tp, eg, ep, ev, re, r, rp)
  local a = Duel.GetAttacker()
  local d = Duel.GetAttackTarget()
  if not d then return false end
  if d:IsControler(tp) then a, d = d, a end
  return a:IsType(TYPE_NORMAL) and
      not a:IsStatus(STATUS_BATTLE_DESTROYED) and
      d:IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.filter(c)
  return c:IsType(TYPE_EFFECT) and
      c:IsLevelBelow(5) and
      c:IsAbleToHand()
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK,
    0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, g)
  end
end

function s.e2Value(e, c)
  if not c then return false end
  return not c:IsSetCard(ARCHETYPES.CYBER_ELF)
end
