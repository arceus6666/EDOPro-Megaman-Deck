-- Seraph X

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --xyz summon
  Xyz.AddProcedure(c, nil, 99, 99, s.xyzSummon, aux.Stringid(id, 0))
  c:EnableReviveLimit()

  --immune
  local eImmune = Effect.CreateEffect(c)
  eImmune:SetType(EFFECT_TYPE_SINGLE)
  eImmune:SetCode(EFFECT_IMMUNE_EFFECT)
  eImmune:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  eImmune:SetRange(LOCATION_MZONE)
  eImmune:SetCondition(s.eImmuneCondition)
  eImmune:SetValue(s.eImmuneValue)
  c:RegisterEffect(eImmune)

  --attach material
  local eAttachMaterial = Effect.CreateEffect(c)
  eAttachMaterial:SetDescription(aux.Stringid(id, 1))
  eAttachMaterial:SetType(EFFECT_TYPE_IGNITION)
  eAttachMaterial:SetRange(LOCATION_MZONE)
  eAttachMaterial:SetProperty(EFFECT_FLAG_CARD_TARGET)
  eAttachMaterial:SetCountLimit(1)
  eAttachMaterial:SetCost(s.eAttachMaterialCost)
  eAttachMaterial:SetTarget(s.eAttachMaterialTarget)
  eAttachMaterial:SetOperation(s.eAttachMaterialOperation)
  c:RegisterEffect(eAttachMaterial)

  --destroy
  local eDetachDestroyCard = Effect.CreateEffect(c)
  eDetachDestroyCard:SetDescription(aux.Stringid(id, 2))
  eDetachDestroyCard:SetCategory(CATEGORY_DESTROY)
  eDetachDestroyCard:SetType(EFFECT_TYPE_IGNITION)
  eDetachDestroyCard:SetRange(LOCATION_MZONE)
  eDetachDestroyCard:SetProperty(EFFECT_FLAG_CARD_TARGET)
  eDetachDestroyCard:SetCountLimit(1)
  eDetachDestroyCard:SetCost(s.eDetachDestroyCardCost)
  eDetachDestroyCard:SetTarget(s.eDetachDestroyCardTarget)
  eDetachDestroyCard:SetOperation(s.eDetachDestroyCardOperation)
  c:RegisterEffect(eDetachDestroyCard, false, REGISTER_FLAG_DETACH_XMAT)
end

s.listed_series = { ARCHETYPES.MEGAMAN }

function s.xyzSummon(c, tp, xyzc)
  return c:IsFaceup() and
      -- c:IsSetCard(ARCHETYPES.MEGAMAN, xyzc, SUMMON_TYPE_XYZ, tp) and
      -- c:IsType(TYPE_XYZ, xyzc, SUMMON_TYPE_XYZ, tp) and
      -- not c:IsSummonCode(xyzc, SUMMON_TYPE_XYZ, tp, id)
      c:IsCode(MEGAMEN.COPY_X)
end

function s.imfilter(c)
  return c:IsSetCard(ARCHETYPES.MEGAMAN) and c:IsType(TYPE_FUSION)
end

function s.eImmuneCondition(e)
  return e:GetHandler():GetOverlayGroup():IsExists(s.imfilter, 1, nil)
end

function s.eImmuneValue(e, te)
  return te:GetOwner() ~= e:GetOwner()
end

function s.eAttachMaterialCost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return true end
  Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
end

function s.eAttachMaterialTarget(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  local g = e:GetHandler():GetEquipGroup()
  if chkc then
    return g:IsContains(chkc) and
        chkc:IsCanBeEffectTarget(e)
  end
  if chk == 0 then
    return g:IsExists(Card.IsCanBeEffectTarget, 1, nil, e)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
  local tg = g:FilterSelect(tp, Card.IsCanBeEffectTarget, 1, 2, nil, e)
  Duel.SetTargetCard(tg)
end

function s.mtfilter(c, e)
  return c:IsRelateToEffect(e) and
      not c:IsImmuneToEffect(e)
end

function s.eAttachMaterialOperation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
  local ci = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
  local g = ci:Filter(s.mtfilter, nil, e)
  if #g > 0 then
    Duel.Overlay(c, g)
  end
end

function s.eDetachDestroyCardCost(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then
    return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
  end
  e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
  Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
end

function s.eDetachDestroyCardTarget(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chkc then
    return chkc:IsOnField() and
        chkc:IsControler(1 - tp) and
        chkc:IsFaceup()
  end
  if chk == 0 then
    return Duel.IsExistingTarget(Card.IsFaceup, tp, 0, LOCATION_ONFIELD, 1, nil)
  end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
  local g = Duel.SelectTarget(tp, Card.IsFaceup, tp, 0,
    LOCATION_ONFIELD, 1, 1, nil)
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.eDetachDestroyCardOperation(e, tp, eg, ep, ev, re, r, rp)
  local tc = Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
    Duel.Destroy(tc, REASON_EFFECT)
  end
end
