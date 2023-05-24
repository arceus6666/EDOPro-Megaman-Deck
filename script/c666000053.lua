-- prea

Duel.LoadScript("functions666.lua")
local s, id = GetID()

function s.initial_effect(c)
  --pendulum summon
  Pendulum.AddProcedure(c)

  --pierce
  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_PIERCE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetTargetRange(LOCATION_MZONE, 0)
  e1:SetTarget(s.e1Target)
  c:RegisterEffect(e1)

  --on destroyed
  local e2 = Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(id, 1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetTarget(s.e2Target)
  e2:SetOperation(s.e2Operation)
  c:RegisterEffect(e2)
end

-- s.listed_series = { ARCHETYPES.CYBER_ELF }

function s.e1Target(e, c)
  return c:IsType(TYPE_FUSION)
end

function s.e2Target(e, tp, eg, ep, ev, re, r, rp, chk)
  local bc = e:GetHandler():GetBattleTarget()
  if chk == 0 then return bc:IsRelateToBattle() end
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, bc, 1, 0, 0)
end

function s.e2Operation(e, tp, eg, ep, ev, re, r, rp)
  local bc = e:GetHandler():GetBattleTarget()
  if bc:IsRelateToBattle() then
    Duel.Destroy(bc, REASON_EFFECT)
  end
end
