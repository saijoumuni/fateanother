ServantStatistics = {cScroll = 0, bScroll = 0, aScroll = 0, sScroll = 0, exScroll = 0, attr1 = 0, attr2 = 0, attr3 = 0, attr4 = 0, attr5 = 0, shard1 = 0, shard2 = 0, shard3 =0, 
shard4 = 0, damageDealt = 0, damageTaken = 0, damageTakenBR = 0, damageDealtBR = 0, damageNullified = 0, ward = 0, familiar = 0, link = 0, goldWasted = 0, itemValue = 0, qseal = 0, wseal = 0, eseal = 0, rseal = 0, 
kill = 0, tkill=0, death = 0, assist = 0, str = 0, agi = 0, int = 0, atk = 0, armor = 0, hpregen = 0, mpregen = 0, ms = 0}

function ServantStatistics:initialise(hero)
  NameAndID = {heroName = hero:GetName(), steamId = PlayerResource:GetSteamID(hero:GetPlayerOwnerID())}
  setmetatable(NameAndID, self)
  print("Initialize for:", hero:GetName(), PlayerResource:GetSteamID(hero:GetPlayerOwnerID()) )
  self.__index = self
  return NameAndID
end


function ServantStatistics:useC()
  self.cScroll = self.cScroll + 1
end

function ServantStatistics:useB()
  self.bScroll = self.bScroll + 1
end

function ServantStatistics:useA()
  self.aScroll = self.aScroll + 1
end

function ServantStatistics:useS()
  self.sScroll = self.sScroll + 1
end

function ServantStatistics:useEX()
  self.exScroll = self.exScroll + 1
end

function ServantStatistics:useA1()
  self.attr1 = self.attr1 + 1
end

function ServantStatistics:useA2()
  self.attr2 = self.attr2 + 1
end

function ServantStatistics:useA3()
  self.attr3 = self.attr3 + 1
end

function ServantStatistics:useA4()
  self.attr4 = self.attr4 + 1
end

function ServantStatistics:useA5()
  self.attr5 = self.attr5 + 1
end

function ServantStatistics:addStr()
  self.str = self.str + 1
end

function ServantStatistics:addAgi()
  self.agi = self.agi + 1
end

function ServantStatistics:addInt()
  self.int = self.int + 1
end

function ServantStatistics:addAtk()
  self.atk = self.atk + 1
end

function ServantStatistics:addArmor()
  self.armor = self.armor + 1
end

function ServantStatistics:addHPregen()
  self.hpregen = self.hpregen + 1
end

function ServantStatistics:addMPregen()
  self.mpregen = self.mpregen + 1
end

function ServantStatistics:addMS()
  self.ms = self.ms + 1
end

function ServantStatistics:getS1()
  self.shard1 = self.shard1 + 1
end

function ServantStatistics:getS2()
  self.shard2 = self.shard2 + 1
end

function ServantStatistics:getS3()
  self.shard3 = self.shard3 + 1
end

function ServantStatistics:getS4()
  self.shard4 = self.shard4 + 1
end

function ServantStatistics:useWard()
  self.ward = self.ward + 1
end

function ServantStatistics:useFamiliar()
  self.familiar = self.familiar + 1
end

function ServantStatistics:useLink()
  self.link = self.link + 1
end

function ServantStatistics:trueWorth(gold)
  self.itemValue = self.itemValue + gold
end

function ServantStatistics:wastedGold(gold)
  self.goldWasted = self.goldWasted + gold
end

function ServantStatistics:useQSeal()
  self.qseal = self.qseal + 1
end

function ServantStatistics:useWSeal()
  self.wseal = self.wseal + 1
end

function ServantStatistics:useESeal()
  self.eseal = self.eseal + 1
end

function ServantStatistics:useRSeal()
  self.rseal = self.rseal + 1
end

function ServantStatistics:takeActualDamage(damage)
  self.damageTaken = self.damageTaken + damage
end

function ServantStatistics:doActualDamage(damage)
  self.damageDealt = self.damageDealt + damage
end

function ServantStatistics:takeDamageBeforeReduction(damage)
  self.damageTakenBR = self.damageTakenBR + damage
end

function ServantStatistics:doDamageBeforeReduction(damage)
  self.damageDealtBR = self.damageDealtBR + damage
end

function ServantStatistics:onKill()
  self.kill = self.kill + 1
end

function ServantStatistics:onTeamKill()
  self.tkill = self.tkill + 1
end

function ServantStatistics:onDeath()
  self.death = self.death + 1
end

function ServantStatistics:onAssist()
  self.assist = self.assist + 1
end

function ServantStatistics:printconsole()
  print("------------------------------------------------------------------------------------------------------------------------------------------------------------------")
  print("Hero Name:", self.heroName)
  print("Steam ID:", self.steamId)
  print("K/D/A/TeamKill:                                  ", self.kill, self.death, self.assist, self.tkill)
  print("Gold Spent / Value of Items / Gold Wasted:       ", self.itemValue + self.goldWasted, self.itemValue, self.goldWasted)
  print("Actual Damage Dealt/Taken:                       ", self.damageDealt, self.damageTaken)
  print("Before Reduction Damage Dealt/Taken:             ", self.damageDealtBR, self.damageTakenBR)
  print("Q/W/E/R Seal:                                    ", self.qseal, self.wseal, self.eseal, self.rseal)
  print("C/B/A/S/EX:                                      ", self.cScroll, self.bScroll, self.aScroll, self.sScroll, self.exScroll)
  print("Ward/Familiar/Link:                              ", self.ward, self.familiar, self.link)
  print("Str/Agi/Int/Atk/Armor/HPregen/MPregen/MS         ", self.str, self.agi, self.int, self.atk, self.armor, self.hpregen, self.mpregen, self.ms)
  print("(W.I.P) Attributes taken:                        ", self.attr1, self.attr2, self.attr3, self.attr4, self.attr5)
  print("Avarice/Anti-Magic/Replenishment/Prosperity:     ", self.shard1, self.shard2, self.shard3, self.shard4)
  print("------------------------------------------------------------------------------------------------------------------------------------------------------------------")
end

-- local hero = keys.caster:GetPlayerOwner():GetAssignedHero()
-- hero.ServStat:doDamageBeforeReduction(damage)