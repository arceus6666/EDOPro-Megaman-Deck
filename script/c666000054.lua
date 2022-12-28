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
  local e4 = Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e4:SetValue(1)
  c:RegisterEffect(e4)

end

s.material = { CYBER_ELFS.CREA, CYBER_ELFS.PREA }
s.listed_names = { CYBER_ELFS.CREA, CYBER_ELFS.PREA, TOKENS.CYBER_ELF }
s.listed_series = { ARCHETYPES.CYBER_ELF }
s.synchro_nt_required = 1

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
        500, 500, 1, ARCHETYPES.CYBER_ELF, ATTRIBUTE_LIGHT) then
    -- math.randomseed(os.clock() * 100000000000)
    local tkn = Duel.GetRandomNumber(TOKENS.CYBER_ELF, TOKENS.CYBER_ELF + 5)
    local token = Duel.CreateToken(tp, tkn)
    Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
  end
end
