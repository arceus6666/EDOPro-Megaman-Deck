-- aeolus

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  Pendulum.AddProcedure(c)
  c:EnableReviveLimit()

  --cannot special summon
  CannotSpecialSummon(c)

  --special summon mm
  local eSpSmMm = Effect.CreateEffect(c)
  eSpSmMm:SetDescription(aux.Stringid(id, 0))
  eSpSmMm:SetCategory(CATEGORY_SPECIAL_SUMMON)
  eSpSmMm:SetType(EFFECT_TYPE_IGNITION)
  eSpSmMm:SetProperty(EFFECT_FLAG_CARD_TARGET)
  eSpSmMm:SetRange(LOCATION_PZONE)
  eSpSmMm:SetTarget(s.eSpSmMmTarget)
  eSpSmMm:SetOperation(s.eSpSmMmOperation)
  c:RegisterEffect(eSpSmMm)

  --plcae self in pendulum
  c:PlaceSelfInPendulumZone(1)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.eSpSmMmFilter(c, e, tp)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and
      c:IsType(TYPE_FUSION + TYPE_SYNCHRO + TYPE_XYZ) and
      c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.eSpSmMmTarget(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsControler(tp) and
        chkc:IsLocation(LOCATION_GRAVE) and
        s.eSpSmMmFilter(chkc, e, tp)
  end
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and
        Duel.IsExistingTarget(s.eSpSmMmFilter, tp, LOCATION_GRAVE, 0, 1,
          nil, e, tp)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
  local g = Duel.SelectTarget(tp, s.eSpSmMmFilter, tp, LOCATION_GRAVE, 0, 1, 1,
    nil, e, tp)
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, 0, 0)
end

function s.eSpSmMmOperation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  local tc = Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and
      Duel.Destroy(c, REASON_EFFECT) ~= 0 and
      tc:IsRelateToEffect(e) then
    Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
  end
end
