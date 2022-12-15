Duel.LoadScript("constants.lua")

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

function Card.IsBiometal(c)
  return c:IsCode(table.unpack(BIOMETALS))
end

function Card.IsMegamen(c)
  return c:IsCode(table.unpack(MEGAMEN))
end
