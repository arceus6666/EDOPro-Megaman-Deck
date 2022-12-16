-- ritual omega

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  --Activate
  -- Ritual.AddProcEqual{handler=c, filter=s.ritualfil, extrafil=s.extrafil, extratg=s.extratg}
  Ritual.AddProcGreaterCode{handler=c, filter=s.ritualfil, extrafil=s.extrafil, extratg=s.extratg}
end

s.listed_names={OMEGA}

function s.ritualfil(c)
	return c:IsCode(OMEGA) and c:IsRitualMonster()
end

function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) and c:HasLevel() and c:IsCode(MEGAMAN_ZERO)
		and c:IsMonster() and c:IsAbleToRemove()
end

function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
end

function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
