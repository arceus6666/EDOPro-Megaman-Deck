-- thetis model l

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --fusion material
  c:EnableReviveLimit()
  Fusion.AddProcMix(c, true, true, PSEUDORIODS.LURERRE, PSEUDORIODS.LEGANCHOR)

  --spsummon condition
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(aux.fuslimit)
  c:RegisterEffect(e1)

  --search
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 0))
  e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetCondition(s.e2Condition)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)
end

s.listed_names = {
  BIOMETALS.BIOMETAL_L,
  PSEUDORIODS.LURERRE,
  PSEUDORIODS.LEGANCHOR
}
s.material_setcode = { 0x8, ARCHETYPES.PSUEDOROID }

function s.e2Condition(e, tp, eg, ep, ev, re, r, rp)
  return e:GetHandler():IsLocation(LOCATION_GRAVE) and
      e:GetHandler():IsReason(REASON_BATTLE)
end

function s.filter(c)
  return c:IsCode(BIOMETALS.BIOMETAL_L) and c:IsAbleToHand()
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK,
    0, 1, 1, nil)
  if #g > 0 then
    Duel.SendtoHand(g, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, g)
  end
end
