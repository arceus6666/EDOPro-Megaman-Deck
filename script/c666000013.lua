-- biometal p

Duel.LoadScript("functions.lua")
local s, id = GetID()

function s.initial_effect(c)
  aux.AddEquipProcedure(c, nil, aux.FBF(MEGAMEN.AILE_MODEL_X))

  --atk up
  ATKUP(c, 700)

  --avoid destroy
  AvoidCardDestroy(c)

  --avoid dmg
  AvoidDMG(c)
end

s.listed_names = { MEGAMEN.AILE_MODEL_X }

MEGAMEN = {
  AILE            = 666000001,
  VENT            = 666000002,
  AILE_MODEL_X    = 666000003,
  VENT_MODEL_X    = 666000004,
  AILE_MODEL_LX   = 666000005,
  AILE_MODEL_PX   = 666000006,
  AILE_MODEL_ZX   = 666000007,
  VENT_MODEL_HX   = 666000008,
  VENT_MODEL_FX   = 666000009,
  VENT_MODEL_ZX   = 666000010,
  PANDORA         = 666000018,
  PROMETHEUS      = 666000019,
  MEGAMAN_ZERO    = 666000022,
  COPY_X          = 666000033,
  OMEGA           = 666000035,
  AEOLUS_MODEL_H  = 666000042,
  THETIS_MODEL_L  = 666000045,
  SIARNAQ_MODEL_P = 666000048,
  ATLAS_MODEL_F   = 666000051,
  AEOLUS          = 666000056,
  THETIS          = 666000057,
  SIARNAQ         = 666000058,
  ATLAS           = 666000059,
  SERAPH_X        = 666000060
}