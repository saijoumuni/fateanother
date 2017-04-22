function HeroSelection() {
    var that = this;
    this.playerId = Game.GetLocalPlayerID();
    
    this.timeListener = CustomNetTables.SubscribeNetTableListener("selection", function(table, tableKey, data) {
        if (tableKey == "time") {
            that.time = data.time;
        }
    });

    this.availableListener = CustomNetTables.SubscribeNetTableListener("selection", function(table, tableKey, data) {
        if (tableKey == "available") {
            that.availableHeroes = data;
        }
    });

    this.allHeroes = CustomNetTables.GetTableValue("selection", "all");
    this.availableHeroes = CustomNetTables.GetTableValue("selection", "available");

    var timeTable = CustomNetTables.GetTableValue("selection", "time");
    this.time = timeTable && timeTable.time;

    this.container = $.GetContextPanel().FindChild("container");
    this.timeLabel = this.container.FindChildTraverse("time");
    this.heroesPanel = this.container.FindChild("heroes");
}

HeroSelection.prototype.OnHover = function() {
	
}

HeroSelection.prototype.Render = function() {
    this.timeLabel.text = this.time;

    for (var heroName in this.allHeroes) {
        var heroPanel = this.heroesPanel.FindChild(heroName);
        if (heroPanel == null) {
            heroPanel = $.CreatePanel("Image", this.heroesPanel, heroName);
            heroPanel.SetImage("s2r://panorama/images/custom_game/selection/" + heroName + "_png.vtex");
            heroPanel.AddClass("hero");
            this.BindOnActivate(heroPanel, heroName);
        }
        heroPanel.SetHasClass("grayscale", !this.availableHeroes[heroName]);
    }
   
}

HeroSelection.prototype.BindOnActivate = function(panel, hero) {
    panel.SetPanelEvent(
        "onactivate",
        function() {
            GameEvents.SendCustomGameEventToServer("selection_hero_click", {
                playerId: this.playerId,
                hero: hero,
            });
        }
    );
}

HeroSelection.prototype.Update = function() {
    var that = this;

    this.Render();

    var hero = Players.GetPlayerHeroEntityIndex(this.playerId);
    var name = Entities.GetUnitName(hero);
    if (hero !== -1 && name !== "npc_dota_hero_wisp") {
        $.Msg("end");
        this.End();
        return;
    }

    $.Schedule(0.1, function() {
       that.Update();
    })
}

HeroSelection.prototype.End = function() {
    CustomNetTables.UnsubscribeNetTableListener(this.timeListener);
    CustomNetTables.UnsubscribeNetTableListener(this.availableListener);
    // CustomNetTables.UnsubscribeNetTableListener(this.hoverListener);

    this.container.AddClass("Hidden");
}

var selection = new HeroSelection();
selection.Update();