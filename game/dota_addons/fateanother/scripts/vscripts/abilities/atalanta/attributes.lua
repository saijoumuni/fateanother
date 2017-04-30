atalanta_attribute_arrows_of_the_big_dipper = class({})
LinkLuaModifier("modifier_arrows_of_the_big_dipper", "abilities/atalanta/modifier_arrows_of_the_big_dipper", LUA_MODIFIER_MOTION_NONE)

atalanta_attribute_hunters_mark = class({})
atalanta_attribute_golden_apple = class({})
atalanta_attribute_crossing_arcadia_plus = class({})

function WrapAttributes(ability, attributeName, callback)
    function ability:OnSpellStart()
        local caster = self:GetCaster()
        local player = caster:GetPlayerOwner()
        local hero = caster:GetPlayerOwner():GetAssignedHero()

        hero[attributeName] = true

	local master = hero.MasterUnit
	master:SetMana(master:GetMana() - self:GetManaCost(1))

        if callback then
            callback(self, hero)
        end
    end
end

WrapAttributes(atalanta_attribute_hunters_mark, "HuntersMarkAcquired")
WrapAttributes(atalanta_attribute_golden_apple, "GoldenAppleAcquired")
WrapAttributes(atalanta_attribute_crossing_arcadia_plus, "CrossingArcadiaPlusAcquired")

WrapAttributes(atalanta_attribute_arrows_of_the_big_dipper, "ArrowsOfTheBigDipperAcquired", function(self, hero)
    hero:AddNewModifier(hero, self, "modifier_arrows_of_the_big_dipper", {})
end)
