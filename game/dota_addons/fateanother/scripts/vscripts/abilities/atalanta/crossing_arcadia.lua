atalanta_crossing_arcadia = class({})

function atalanta_crossing_arcadia:GetCastRange()
    return self:GetSpecialValueFor("range")
end

function atalanta_crossing_arcadia:GetAOERadius()
    local caster = self:GetCaster()
    local aoe = self:GetSpecialValueFor("aoe")

    if IsServer() and caster:HasModifier("modifier_tauropolos") then
        local tauropolos = caster:FindAbilityByName("atalanta_tauropolos")
        aoe = aoe + tauropolos:GetSpecialValueFor("bonus_aoe_per_agi") * caster:GetAgility()
    end

    return aoe
end

function atalanta_crossing_arcadia:CastFilterResultLocation(location)
    local caster = self:GetCaster()

    if IsServer() then
        if GridNav:IsBlocked(location) or not GridNav:IsTraversable(location) then
            return UF_FAIL_CUSTOM
        end
    end

    if not caster:HasArrow() then
        return UF_FAIL_CUSTOM
    end

    return UF_SUCCESS
end

function atalanta_crossing_arcadia:GetCustomCastErrorLocation(location)
    if IsServer() then
        if GridNav:IsBlocked(location) or not GridNav:IsTraversable(location) then
            return "#Cannot_Travel"
        end
    end

    return "Not enough arrows..."
end

function atalanta_crossing_arcadia:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local position = self:GetCursorPosition()
    local origin = caster:GetOrigin()
    local forwardVector = caster:GetForwardVector()
    local duration = self:GetSpecialValueFor("jump_time")
    local landDuration = self:GetSpecialValueFor("land_time")
    local hangTime = self:GetSpecialValueFor("hang_time")
    local stunDuration = self:GetSpecialValueFor("stun_duration")
    local initialDelta = Vector(0, 0, 70)
    local gravity = Vector(0, 0, 3)

    giveUnitDataDrivenModifier(caster, caster, "jump_pause", duration + landDuration + hangTime)

    local tick = 0
    local tickInterval = 0.033
    local totalTicks = duration / tickInterval
    local jumpVector = (position - origin) / totalTicks + initialDelta
    local downVector = Vector(0, 0, -1.5) / totalTicks

    Timers:CreateTimer(function()
    tick = tick + 1

        if tick >= totalTicks then
            return
        end

    caster:SetOrigin(caster:GetOrigin() + jumpVector)
    caster:SetForwardVector(caster:GetForwardVector() + downVector)
    jumpVector = jumpVector - gravity

    return tickInterval
    end)

    function OnHit(target)
        target:AddNewModifier(caster, target, "modifier_stunned", {Duration = stunDuration})
    end

    local aoe = self:GetAOERadius()
    local effect = "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf"
    local facing = caster:GetForwardVector() + Vector(0, 0, -2)
    if caster.CrossingArcadiaPlusAcquired then
        local offset = 0.7071 * aoe - 50
        Timers:CreateTimer(duration + 0.1, function()
            caster:ShootArrow({
                Position = position + Vector(-offset, -offset, 0),
                AoE = aoe,
                Delay = 0.2,
                Effect = effect,
                Facing = facing,
                OnHit = OnHit,
            })
        end)

        Timers:CreateTimer(duration + 0.2, function()
            caster:ShootArrow({
                Position = position + Vector(offset, -offset, 0),
                AoE = aoe,
                Delay = 0.2,
                Effect = effect,
                Facing = facing,
                OnHit = OnHit,
                DontUseArrow = true
            })
        end)

        Timers:CreateTimer(duration + 0.3, function()
            caster:ShootArrow({
                Position = position + Vector(0, aoe - 50, 0),
                AoE = aoe,
                Delay = 0.2,
                Effect = effect,
                Facing = facing,
                OnHit = OnHit,
                DontUseArrow = true
            })
        end)
    else
        Timers:CreateTimer(duration + 0.1, function()
            caster:ShootArrow({
                Position = position,
                AoE = aoe,
                Delay = 0.2,
                Effect = effect,
                Facing = facing,
                OnHit = OnHit
            })
        end)
    end

    Timers:CreateTimer(duration + hangTime, function()
        caster:SetForwardVector(forwardVector)
        self:Land(landDuration)
    end)
end

function atalanta_crossing_arcadia:Land(duration)
    local caster = self:GetCaster()
    local ability = self
    local origin = caster:GetOrigin()
    local position = GetGroundPosition(origin, caster)

    local tick = 1
    local tickInterval = 0.033
    local totalTicks = duration / tickInterval
    local jumpVector = (position - origin)
    local tickVector = jumpVector / totalTicks

    Timers:CreateTimer(function()
    tick = tick + 1
    caster:SetOrigin(caster:GetOrigin() + tickVector)
    
        if tick >= totalTicks then
            caster:SetOrigin(GetGroundPosition(caster:GetOrigin(), caster))
            FindClearSpaceForUnit(caster, caster:GetOrigin(), true)
            if caster.CrossingArcadiaPlusAcquired then
                caster:CastLastSpurt()
            end
            return
        end

    return tickInterval
    end)
end

function atalanta_crossing_arcadia:GetCastAnimation()
    return ACT_DOTA_CAST_ABILITY_1
end
