var buffHasStacks = {
    modifier_lancer_incinerate: true,
    modifier_derange_counter: true,
    modifier_courage_damage_stack_indicator: true,
    modifier_courage_stackable_buff: true,
    modifier_god_hand_stock: true,
    modifier_ta_agi_bonus: true,
    modifier_dark_passage: true,
    modifier_gae_buidhe: true,
    modifier_madness_stack: true,
    modifier_gladiusanus_blauserum: true,
    modifier_fiery_heaven_indicator: true,
    modifier_fiery_heaven_indicator_enemy: true,
    modifier_frigid_heaven_indicator: true,
    modifier_frigid_heaven_indicator_enemy: true,
    modifier_gust_heaven_indicator: true,
    modifier_gust_heaven_indicator_enemy  : true,
    modifier_soulstream_stack: true,
    modifier_mantra_ally: true,
    modifier_mantra_enemy: true,
    modifier_mark_of_fatality: true,
    modifier_furious_chain_buff: true,
    modifier_magic_resistance_ex_shield: true,
    modifier_plains_of_water_int_debuff: true,
    modifier_plains_of_water_int_buff: true,
};

var buffCooldown = {
    modifier_instinct_cooldown: 35,
    modifier_madmans_roar_cooldown: 150,
    modifier_strike_air_cooldown: 60,
    modifier_max_excalibur_cooldown: 150,
    modifier_battle_continuation_cooldown: 60,
    modifier_wesen_gae_bolg_cooldown: 90,
    modifier_max_mana_burst_cooldown: 150,
    modifier_bellerophon_2_cooldown: 100,
    modifier_arrow_rain_cooldown: 180,
    modifier_overedge_cooldown: 60,
    modifier_hrunting_cooldown: 80,
    modifier_quickdraw_cooldown: 60,
    modifier_tsubame_mai_cooldown: 150,
    modifier_delusional_illusion_cooldown: 150,
    modifier_max_enuma_elish_cooldown: 160,
    modifier_hecatic_graea_powered_cooldown: 150,
    modifier_eternal_arms_mastership_cooldown: 45,
    modifier_blessing_of_fairy_cooldown: 45,
    modifier_nuke_cooldown: 150,
    modifier_blood_mark_cooldown: 50,
    modifier_endless_loop_cooldown: 100,
    modifier_rampant_warrior_cooldown: 100,
    modifier_annihilate_cooldown: 140,
    modifier_larret_de_mort_cooldown: 150,
    modifier_fiery_finale_cooldown: 180,
    modifier_laus_saint_cladius_cooldown: 0, // unused
    modifier_invictus_spiritus_cooldown: 60,
    modifier_gawain_blessing_cooldown: 60,
    modifier_meltdown_cooldown: 90,
    modifier_supernova_cooldown: 170,
    modifier_mystic_shackle_cooldown: 30,
    modifier_fates_call_cooldown: 0, // unused
    modifier_polygamist_cooldown: 120,
    modifier_raging_dragon_strike_cooldown: 110,
    modifier_la_pucelle_cooldown: 135,
    modifier_hippogriff_ride_cooldown: 150,
    modifier_story_for_someones_sake_cooldown: 450,
};

function AltClickBuffs() {
    var that = this;

    var buffPanels = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('buffs').Children();
    var debuffPanels = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('debuffs').Children();
    this.BindOnActivate(buffPanels, false);
    this.BindOnActivate(debuffPanels, true);
}

AltClickBuffs.prototype.BindOnActivate = function(panels, isDebuff) {
    var that = this;

    $.Each(panels, function(panel, index) {
        panel.GetChild(0).SetPanelEvent(
            "onactivate",
            function() {
                that.OnActivate(index, isDebuff);
            }
        )
    });
}

AltClickBuffs.prototype.GetVisibleBuffs = function(unit, isDebuff) {
    var visibleBuffs = [];
    var nBuffs = Entities.GetNumBuffs(unit)
    for (var i = 0; i < nBuffs; i++)  {
        var buff = Entities.GetBuff(unit, i)
        if (Buffs.IsDebuff(unit, buff) !== isDebuff
            || Buffs.IsHidden(unit, buff)
            || !Buffs.GetName(unit, buff)) {
            continue;
        }
        visibleBuffs.push(buff);
    }
    return visibleBuffs;
}

AltClickBuffs.prototype.OnActivate = function(index, isDebuff) {
    var unit = Players.GetLocalPlayerPortraitUnit();

    if (!Entities.IsHero(unit) || !GameUI.IsAltDown()) {
        return;
    }

    var visibleBuffs = this.GetVisibleBuffs(unit, isDebuff);
    var buff = visibleBuffs[index];
    if (!buff) {
        return;
    }

    var name = Buffs.GetName(unit, buff);
    var duration = Buffs.GetDuration(unit, buff);
    var remainingTime = Buffs.GetRemainingTime(unit, buff);
    var stackCount = Buffs.GetStackCount(unit, buff);
    var hasStacks = !!buffHasStacks[name];

    var localName = $.Localize("DOTA_Tooltip_" + name);
    var colour = isDebuff ? "_red_" : "_green_";

    var localPlayerId = Game.GetLocalPlayerID();
    var sameTeam = Entities.GetTeamNumber(unit) == Players.GetTeam(localPlayerId);;

    if (sameTeam && unit != Players.GetPlayerHeroEntityIndex(localPlayerId)) {
        return;
    }

    var message = sameTeam
        ? ""
        : "Enemy _gold_" + Entities.GetUnitName(unit) + " ";

    message += "_gray__arrow_ ";

    if (buffCooldown[name]) {
        message += colour + localName + "_default_";
        if (sameTeam) {
            var remainingTime = Math.ceil(remainingTime);
            message += " ( _gold_" + remainingTime + "_default_ second" + (remainingTime == 1 ? "" : "s") + " remain )";
        }
    } else {
        message += "_default_Affected by " + colour + localName + "_default_";
        if (hasStacks) {
            message += " ( _gold_" + stackCount + "_default_ stack" + (stackCount == 1 ? "" : "s") + " )"
        }
    }
    GameEvents.SendCustomGameEventToServer("player_alt_click", {
        message: message,
        ability: this.name,
        unit: unit
    });
}

var altClickBuffs = new AltClickBuffs();

/*
function ChatModifier() {
    this.chatPanel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse('ChatLinesPanel');
    this.lastLine = null;
}

ChatModifier.prototype.UpdateChat = function() {
    var that = this;
    $.Schedule(0.1, function() {
        that.UpdateChat();
    });
    if (this.lastLine !== null && this.chatPanel.GetChildCount() === this.chatPanel.GetChildIndex(this.lastLine)) {
        return;
    }
    var nextLine;
    if (this.lastLine === null || this.chatPanel.GetChildIndex(this.lastLine) === null) {
        nextLine = this.chatPanel.GetChild(0);
    } else {
       nextLine = this.chatPanel.GetChild(this.chatPanel.GetChildIndex(this.lastLine) + 1);
    }
    while (nextLine !== null) {
        this.lastLine = nextLine;
        this.ModifyLine(this.lastLine);
        nextLine = this.chatPanel.GetChild(this.chatPanel.GetChildIndex(this.lastLine) + 1);
    }
}

ChatModifier.prototype.ModifyLine = function(line) {
    var text = line.text;
    $.Msg(line.Children());
}

var chat = new ChatModifier();
chat.UpdateChat();
*/
