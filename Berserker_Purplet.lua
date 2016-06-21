CombatBerserker = { }
CombatBerserker.__index = CombatBerserker
CombatBerserker.Version = "1.4.8"
CombatBerserker.Author = "Purplet"



setmetatable(CombatBerserker, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CombatBerserker.new()
  local self = setmetatable({}, CombatBerserker)

  self.Mode = 0

  CombatBerserker.ELASTIC_FORCE_IDS = { 1057, 1180, 1181, 1290 }
  CombatBerserker.RAGING_THUNDER_IDS = { 1179, 1178, 1177, 1176, 1175, 1044 }
  CombatBerserker.FRENZIED_DESTROYER_IDS = { 1171, 1170, 1169, 1168, 1167, 1042 }
  CombatBerserker.FEARSOME_TYRANT_IDS = { 1150, 1149, 1032 }
  CombatBerserker.SHAKE_OFF_IDS = { 1294, 1293, 1162, 1040 }
  CombatBerserker.BEASTLY_WIND_SLASH_IDS = { 317, 316, 315, 314 }
  CombatBerserker.HEADBUTT_IDS = { 1292, 1291, 1159, 1038 }
  CombatBerserker.FIERCE_STRIKE_IDS = { 1166, 1165, 1164, 1163, 1041 }
  CombatBerserker.LAVA_PIERCER_IDS = { 215, 214, 213 }

  return self
end



function CombatBerserker:GetMonsterCount()
  local monsters = GetMonsters()
  local monsterCount = 0

  for k, v in pairs(monsters) do
    if v.IsAggro then
      monsterCount = monsterCount + 1
    end

    self.Mode = 0

    if self.Mode == 0 then
      self.Mode = 1
    end
  end

  return monsterCount
end

function CombatBerserker:Roaming()
  local selfPlayer = GetSelfPlayer()
  if not selfPlayer then
    return
  end

  if self.Mode == 0 then
    self.Mode = 1
  end
end


function CombatBerserker:Attack(monsterActor)

  local ELASTIC_FORCE_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.ELASTIC_FORCE_IDS)
  local RAGING_THUNDER_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.RAGING_THUNDER_IDS)
  local FRENZIED_DESTROYER_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.FRENZIED_DESTROYER_IDS)
  local FEARSOME_TYRANT_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.FEARSOME_TYRANT_IDS)
  local SHAKE_OFF_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.SHAKE_OFF_IDS)
  local BEASTLY_WIND_SLASH_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.BEASTLY_WIND_SLASH_IDS)
  local HEADBUTT_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.HEADBUTT_IDS)
  local FIERCE_STRIKE_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.FIERCE_STRIKE_IDS)
  local LAVA_PIERCER_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.LAVA_PIERCER_IDS)


  local selfPlayer = GetSelfPlayer()
  local actorPosition = monsterActor.Position

  ------- Mob Find ----------------------------------------------------------------------
  if monsterActor then

    if actorPosition.Distance3DFromMe > monsterActor.BodySize + 1800 then
      Navigator.MoveTo(actorPosition)
    else
      Navigator.Stop()

      if not selfPlayer.IsActionPending then


        if  RAGING_THUNDER_ID ~= 0 and selfPlayer.Mana > 120 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 450 and
        not selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
          print("Launching Raging Beasst!")
          selfPlayer:SetActionState(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 7000)
          return
        end

        if selfPlayer.Mana > 150 and BEASTLY_WIND_SLASH_ID ~= 0 and selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
          print("Launching Beastly Slash!")
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, 1500)
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 500)
          return
        end

        if FEARSOME_TYRANT_ID ~= 0 and (self:GetMonsterCount() > 3) and selfPlayer.Mana > 100 and selfPlayer.BlackRage == 100 then
          print("Launching Fearsome Tyrant!")
          selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1, 8000)
          if FEARSOME_TYRANT_ID ~= 0 and not selfPlayer:IsSkillOnCooldown(FEARSOME_TYRANT_ID) and (self:GetMonsterCount() > 3) and selfPlayer.Mana > 100 and selfPlayer.BlackRage == 100 then
            selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1, 8000)
            return
          end
          return
        end
        if FIERCE_STRIKE_ID ~= 0 and not selfPlayer:IsSkillLearned(FRENZIED_DESTROYER_ID) and selfPlayer.Mana > 61 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
          print("Launching Fierce Strike!")
          selfPlayer:SetActionState(ACTION_FLAG_SECONDARY_ATTACK , 200)
          return
        end
        if HEADBUTT_ID ~= 0 and not selfPlayer:IsSkillLearned(FRENZIED_DESTROYER_ID) and selfPlayer.Mana > 51 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
          print("Launching HeadButt!")
          selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SECONDARY_ATTACK, 400)
          return
        end
        if LAVA_PIERCER_ID ~= 0 and selfPlayer.Mana > 30 and not selfPlayer:IsSkillOnCooldown(LAVA_PIERCER_ID) and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 1000 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1800 then
          print("Launching Lava Piercer!")
          selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_JUMP, 1000)
          return
        end

        if FRENZIED_DESTROYER_ID ~= 0 and selfPlayer:IsSkillLearned(RAGING_THUNDER_ID) and selfPlayer:IsSkillLearned(FEARSOME_TYRANT_ID) and not selfPlayer.BlackRage == 100 and selfPlayer.Mana >= 60 and selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, 100)

          if FRENZIED_DESTROYER_ID ~= 0 and not selfPlayer.BlackRage == 100 and selfPlayer.Mana >= 60 and string.match(selfPlayer.CurrentActionName, "BT_skill_EarthQuake") then
            print("Launching Frenzied Desrtoyer")
            selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 4200)
            return
          end
          return
        end

        if FRENZIED_DESTROYER_ID ~= 0  and selfPlayer:IsSkillLearned(RAGING_THUNDER_ID) and not selfPlayer:IsSkillLearned(FEARSOME_TYRANT_ID) and selfPlayer.Mana >= 60 and selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, 100)

          if FRENZIED_DESTROYER_ID ~= 0 and selfPlayer.Mana >= 60 and string.match(selfPlayer.CurrentActionName, "BT_skill_EarthQuake") then
            print("Launching Frenzied Desrtoyer")
            selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 4200)
            return
          end
          return
        end

        if FRENZIED_DESTROYER_ID ~= 0 and selfPlayer.Mana >= 60 and not selfPlayer:IsSkillLearned(RAGING_THUNDER_ID) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, 100)

          if FRENZIED_DESTROYER_ID ~= 0 and selfPlayer.Mana >= 60 and string.match(selfPlayer.CurrentActionName, "BT_skill_EarthQuake") and not selfPlayer:IsSkillLearned(RAGING_THUNDER_ID) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
            print("Launching Frenzied Desrtoyer")
            selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 2200)
            return
          end
          return
        end

        if SHAKE_OFF_ID ~= 0 and (self:GetMonsterCount() > 1) and selfPlayer.Stamina >= 70 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
          selfPlayer:SetActionState(ACTION_FLAG_MOVE_LEFT | ACTION_FLAG_SECONDARY_ATTACK, 600)

          if SHAKE_OFF_ID ~= 0 and (self:GetMonsterCount() > 1) and selfPlayer.Stamina >= 70 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 100 then
            print("Launching Shake Off!")
