--[[
1. Make sure npc_abilities_custom.txt precaches all particles.
2. Edit line 7 and also AlternateParticles:Switch(string) function in line 26.
3. Edit the relevant hero_ability.lua. Example being rider_ability.lua line 272 to 288. 
   Note that Creating/SetParticleControlEnt/Destroying after timer for a given particle choice MUST all be handled within a single if/elif/else condition. 
]]

AlternateParticle = {bell1=0}

function SendChatToPanorama(string)
    local table =
    {
        text = string
    }
    CustomGameEventManager:Send_ServerToAllClients( "player_chat_lua", table )
end


function AlternateParticle:initialise(hero)
  Name = {heroName = PlayerResource:GetSelectedHeroName(hero:GetPlayerOwnerID())}
  setmetatable(Name, self)
  print("Initialize for:", hero:GetName())
  self.__index = self
  return Name
end

function AlternateParticle:Switch(string)
  if string == "-r5bell1 0" then
    self.bell1 = 0
    SendChatToPanorama("Set r5bell1 0")
  end
  if string == "-r5bell1 1" then
    self.bell1 = 1
    SendChatToPanorama("Set r5bell1 1")
  end
  if string == "-r5bell1" then
    SendChatToPanorama("r5bell1 is now "..tostring(self.bell1))
  end
end

