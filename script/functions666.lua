Duel.LoadScript("constants666.lua")

function FBF(...)
  local codes = { ... }
  local res = {}
  for i, v in ipairs(codes) do
    res[i] = aux.FilterBoolFunction(Card.IsCode, v)
  end
  return aux.OR(table.unpack(res))
end

function ATKUP(c, v)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_EQUIP)
  e:SetCode(EFFECT_UPDATE_ATTACK)
  e:SetValue(v)
  c:RegisterEffect(e)
end

function DEFUP(c, v)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_EQUIP)
  e:SetCode(EFFECT_UPDATE_DEFENSE)
  e:SetValue(v)
  c:RegisterEffect(e)
end

function AvoidCardDestroy(c, v)
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_EQUIP)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
  e2:SetValue(function(e, re, r, rp) return (r & REASON_BATTLE) ~= 0 end)
  c:RegisterEffect(e2)
end

function AvoidDMG(c)
  local e = Effect.CreateEffect(c)
  e:SetType(EFFECT_TYPE_EQUIP)
  e:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
  e:SetValue(1)
  c:RegisterEffect(e)
end

function CannotSpecialSummon(c)
  local e = Effect.CreateEffect(c)
  e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
  e:SetType(EFFECT_TYPE_SINGLE)
  e:SetCode(EFFECT_SPSUMMON_CONDITION)
  e:SetValue(aux.FALSE)
  c:RegisterEffect(e)
end

function Card.IsBiometal(c)
  return c:IsCode(table.unpack(BIOMETALS))
end

function Card.IsMegamen(c)
  return c:IsCode(table.unpack(MEGAMEN))
end

function Card.IsIDGroup(c, ids)
  return c:IsCode(table.unpack(ids))
end

function Card.PlaceSelfInPendulumZone(c, strid)
  local e = Effect.CreateEffect(c)
  e:SetDescription(aux.Stringid(c:GetCardID(), strid))
  e:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e:SetProperty(EFFECT_FLAG_DELAY)
  e:SetCode(EVENT_DESTROYED)
  e:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return r & REASON_EFFECT + REASON_BATTLE ~= 0 and
        c:IsPreviousLocation(LOCATION_MZONE) and
        c:IsFaceup()
  end)
  e:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckPendulumZones(tp) end
  end)
  e:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
    if not Duel.CheckPendulumZones(tp) then return false end
    local ec = e:GetHandler()
    if ec:IsRelateToEffect(e) then
      Duel.MoveToField(ec, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
    end
  end)
  c:RegisterEffect(e)
end
