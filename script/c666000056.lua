-- aeolus

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  Pendulum.AddProcedure(c)
  c:EnableReviveLimit()

  --cannot special summon
  CannotSpecialSummon(c)

  --special summon
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_PZONE)
  e2:SetTarget(s.sptg)
  e2:SetOperation(s.spop)
  c:RegisterEffect(e2)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.spfilter(c, e, tp)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and
      c:IsType(TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsControler(tp) and
        chkc:IsLocation(LOCATION_GRAVE) and
        s.spfilter(chkc, e, tp)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingTarget(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectTarget(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1,
    nil, e, tp)
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  local tc = Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and
      Duel.Destroy(c, REASON_EFFECT) ~= 0 and
      tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
  end
end
