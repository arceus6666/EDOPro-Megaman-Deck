-- Pantheon Unity

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Special summon tokens
  local e1 = Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0, TIMING_END_PHASE)
  e1:SetCost(s.e1Cost)
  e1:SetTarget(s.e1Target)
  e1:SetOperation(s.e1Operation)
  c:RegisterEffect(e1)
end

s.listed_names = { TOKENS.REPLOID }

function s.e1Cost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return Duel.GetActivityCount(tp, ACTIVITY_SUMMON) == 0 and
        Duel.GetActivityCount(tp, ACTIVITY_FLIPSUMMON) == 0 and
        Duel.GetActivityCount(tp, ACTIVITY_SPSUMMON) == 0
  end

  local e1 = Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetReset(RESET_PHASE + PHASE_END)
  e1:SetTargetRange(1, 0)
  e1:SetLabelObject(e)
  e1:SetTarget(s.sumlimit)
  Duel.RegisterEffect(e1, tp)

  local e2 = Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_OATH)
  e2:SetCode(EFFECT_CANNOT_SUMMON)
  e2:SetReset(RESET_PHASE + PHASE_END)
  e2:SetTargetRange(1, 0)
  Duel.RegisterEffect(e2, tp)

  local e3 = e2:Clone()
  e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
  Duel.RegisterEffect(e3, tp)

  local e4 = Effect.CreateEffect(e:GetHandler())
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET +
    EFFECT_FLAG_CLIENT_HINT + EFFECT_FLAG_OATH)
  e4:SetDescription(aux.Stringid(id, 1))
  e4:SetReset(RESET_PHASE + PHASE_END)
  e4:SetTargetRange(1, 0)
  Duel.RegisterEffect(e4, tp)
end

function s.sumlimit(e, c, s, st, sp, tp, se)
  return e:GetLabelObject() ~= se
end

function s.e1Target(e, tp, eg, ep, ev, re, r, rp, chk)
  local limit = Duel.GetLocationCount(tp, LOCATION_MZONE)
  local mx = math.min(limit, 4)
  if chk == 0 then
    return not Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) and
        Duel.IsPlayerCanSpecialSummonMonster(tp, id + 1, 0, TYPES_TOKEN,
          0, 0, 1, RACE_WARRIOR, ATTRIBUTE_EARTH) and
        mx > 0
  end
  Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, mx, 0, 0)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, mx, tp, 0)
end

function s.e1Operation(e, tp, eg, ep, ev, re, r, rp)
  local limit = Duel.GetLocationCount(tp, LOCATION_MZONE)
  local mx = math.min(limit, 4)
  if not Duel.IsPlayerAffectedByEffect(tp, CARD_BLUEEYES_SPIRIT) and
      Duel.IsPlayerCanSpecialSummonMonster(tp, id + 1, 0, TYPES_TOKEN, 0,
        0, 1, RACE_WARRIOR, ATTRIBUTE_EARTH) and
      mx > 0
  then
    for i = 1, mx do
      local token = Duel.CreateToken(tp, id + i)
      Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP_DEFENSE)
    end
    Duel.SpecialSummonComplete()
  end
end
