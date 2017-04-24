HeroSelection = HeroSelection or class({})

function HeroSelection:constructor()
    self.Picked = {}

    local heroList = LoadKeyValues("scripts/npc/herolist.txt")
    heroList["npc_dota_hero_wisp"] = nil
    self.AvailableHeroes = heroList

    self.HoveredHeroes = {}

    self.HoverListener = CustomGameEventManager:RegisterListener("selection_hero_hover", function(id, ...)
       Dynamic_Wrap(self, "OnHover")(self, ...) 
    end)
    self.ClickListener = CustomGameEventManager:RegisterListener("selection_hero_click", function(id, ...)
       Dynamic_Wrap(self, "OnClick")(self, ...) 
    end)

    self.Time = 60

    CustomNetTables:SetTableValue("selection", "all", self.AvailableHeroes)
    CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
    CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
    CustomNetTables:SetTableValue("selection", "time", {time = self.Time})
end

function HeroSelection:UpdateTime()
    self.Time = math.max(self.Time - 1, 0)
    CustomNetTables:SetTableValue("selection", "time", {time = self.Time})

    if self.Time > 0 then
        Timers:CreateTimer(1.0, function()
            self:UpdateTime()
        end)
    end
end

function HeroSelection:OnHover(args)
    local playerId = args.playerId
    local hero = args.hero

    self.HoveredHeroes[playerId] = hero

    CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
end

function HeroSelection:OnClick(args)
    local playerId = args.playerId
    local hero = args.hero

    local player = PlayerResource:GetPlayer(playerId)
    local currentHero = player:GetAssignedHero()

    if currentHero == nil or currentHero:GetName() ~= "npc_dota_hero_wisp" or self.Picked[playerId] or not self.AvailableHeroes[hero] then
        return
    end

    self.AvailableHeroes[hero] = nil
    self.HoveredHeroes[playerId] = nil

    self.Picked[playerId] = true

    local oldHero = PlayerResource:GetSelectedHeroEntity(playerId)
    oldHero:SetRespawnsDisabled(true)
    UTIL_Remove(oldHero)

    PlayerResource:ReplaceHeroWith(playerId, hero, 3000, 0)

    CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
    CustomNetTables:SetTableValue("selection", "hovered", self.HoveredHeroes)
end

function HeroSelection:RemoveHero(hero)
    self.AvailableHeroes[hero] = nil

    CustomNetTables:SetTableValue("selection", "available", self.AvailableHeroes)
end

