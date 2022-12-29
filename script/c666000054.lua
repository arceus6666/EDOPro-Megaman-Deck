-- dark elf

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --pendulum summon
  Pendulum.AddProcedure(c, false)
  --synchro summon
  c:EnableReviveLimit()
  Synchro.AddMajesticProcedure(c,
    aux.FilterBoolFunction(Card.IsCode, CYBER_ELFS.CREA), true,
    aux.FilterBoolFunction(Card.IsCode, CYBER_ELFS.PREA), true,
    Synchro.NonTunerEx(Card.IsSetCard, ARCHETYPES.CYBER_ELF), false)

  --Search 1 Ritual Spell from your Deck or GY
  local ep = Effect.CreateEffect(c)
  ep:SetDescription(aux.Stringid(id, 0))
  ep:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
  ep:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
  ep:SetCode(EVENT_PHASE + PHASE_END)
  ep:SetRange(LOCATION_PZONE)
  ep:SetCountLimit(1, id)
  ep:SetTarget(s.epTarget)
  ep:SetOperation(s.epOperation)
  c:RegisterEffect(ep)

  --token
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
  e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EVENT_PHASE + PHASE_END)
  e1:SetCountLimit(1)
  e1:SetCondition(s.e1Condition)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)

  --cannot be destroyed
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e2:SetValue(1)
  c:RegisterEffect(e2)

  --Special summon a cyber-elf
  local e3 = Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id, 0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1, { id, 1 })
  e3:SetRange(LOCATION_MZONE)
  e3:SetTarget(s.e3Target)
  e3:SetOperation(s.e3Operation)
  c:RegisterEffect(e3)
end

s.material = { CYBER_ELFS.CREA, CYBER_ELFS.PREA }
s.listed_names = { CYBER_ELFS.CREA, CYBER_ELFS.PREA, TOKENS.CYBER_ELF, id }
s.listed_series = { ARCHETYPES.CYBER_ELF }
s.synchro_nt_required = 1

function s.thfilter(c)
  return c:IsSetCard(ARCHETYPES.CYBER_ELF) and
      c:IsSpellTrap() and
      c:IsAbleToHand()
end

function s.epTarget(e, tp, eg, ep, ev, re, r, rp, chk)
  local c = e:GetHandler()
  if chk == 0 then
    return Duel.IsExistingMatchingCard(s.thfilter, tp,
      LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil) and
        c:IsAbleToHand()
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 2, tp,
    LOCATION_DECK + LOCATION_GRAVE + LOCATION_PZONE)
end

function s.epOperation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
  local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.thfilter),
    tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
  if #g > 0 and Duel.SendtoHand(g, nil, REASON_EFFECT) > 0 and
      g:GetFirst():IsLocation(LOCATION_HAND) then
    Duel.ConfirmCards(1 - tp, g)
    Duel.BreakEffect()
    if Duel.SendtoHand(c, nil, REASON_EFFECT) > 0 then
      Duel.ConfirmCards(1 - tp, c)
    end
  end
end

function s.e1Condition(e, tp, eg, ep, ev, re, r, rp)
  return Duel.IsTurnPlayer(tp)
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return true end
  Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
      Duel.IsPlayerCanSpecialSummonMonster(tp, TOKENS.CYBER_ELF, 0, TYPES_TOKEN,
        500, 500, 1, RACE_SPELLCASTER, ATTRIBUTE_LIGHT) then
    -- math.randomseed(os.clock() * 100000000000)
    local tkn = Duel.GetRandomNumber(TOKENS.CYBER_ELF, TOKENS.CYBER_ELF + 4)
    local token = Duel.CreateToken(tp, tkn)
    Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
  end
end

function s.filter(c, e, tp)
  -- return c:IsRace(RACE_DRAGON) and
  -- not c:IsCode(id) and
  return c:IsSetCard(ARCHETYPES.CYBER_ELF) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e3Target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingMatchingCard(s.filter, tp,
          LOCATION_GRAVE + LOCATION_HAND, 0, 1, nil, e, tp)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp,
    LOCATION_GRAVE + LOCATION_HAND)
end

function s.e3Operation(e, tp, eg, ep, ev, re, r, rp)
  if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.filter),
    tp, LOCATION_GRAVE + LOCATION_HAND, 0, 1, 1, nil, e, tp)
  if #g > 0 then
    Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
  end
end
