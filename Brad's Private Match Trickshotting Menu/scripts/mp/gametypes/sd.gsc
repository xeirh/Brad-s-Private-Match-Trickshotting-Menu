#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_spectating;
#using scripts\mp\gametypes\brad_menu\_snd;
#using scripts\shared\demo_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace SD;

function main()
{
	globallogic::init();
	util::registerRoundSwitch(0, 9);
	util::registerTimeLimit(0, 1440);
	util::registerScoreLimit(0, 500);
	util::registerRoundLimit(0, 12);
	util::registerRoundWinLimit(0, 10);
	util::registerNumLives(0, 100);
	globallogic::registerFriendlyFireDelay(level.gametype, 15, 0, 1440);
	level.teambased = 1;
	level.overrideTeamScore = 1;
	level.onPrecacheGameType = &onPrecacheGameType;
	level.onStartGameType = &onStartGameType;
	level.onSpawnPlayer = &onSpawnPlayer;
	level.playerSpawnedCB = &sd_playerSpawnedCB;
	level.onPlayerKilled = &onPlayerKilled;
	level.onDeadEvent = &onDeadEvent;
	level.onOneLeftEvent = &onOneLeftEvent;
	level.onTimeLimit = &onTimeLimit;
	level.onRoundSwitch = &onRoundSwitch;
	level.getTeamKillPenalty = &sd_getTeamKillPenalty;
	level.getTeamKillScore = &sd_getTeamKillScore;
	level.isKillBoosting = &sd_isKillBoosting;
	level.figure_out_gametype_friendly_fire = &figureOutGameTypeFriendlyFire;
	level.endGameOnScoreLimit = 0;
	gameobjects::register_allowed_gameobject(level.gametype);
	gameobjects::register_allowed_gameobject("bombzone");
	gameobjects::register_allowed_gameobject("blocker");
	globallogic_audio::set_leader_gametype_dialog("startSearchAndDestroy", "hcStartSearchAndDestroy", "objDestroy", "objDefend");
	if(!SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitscreen())
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "plants", "defuses", "deaths");
	}
	else
	{
		globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "plants", "defuses");
	}
}

function onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "fly_bomb_drop_plr";
	game["bomb_recovered_sound"] = "fly_bomb_pickup_plr";
}

function sd_getTeamKillPenalty(eInflictor, attacker, sMeansOfDeath, weapon)
{
	teamkill_penalty = globallogic_defaults::default_getTeamKillPenalty(eInflictor, attacker, sMeansOfDeath, weapon);
	if(isdefined(self.isDefusing) && self.isDefusing || (isdefined(self.isPlanting) && self.isPlanting))
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	return teamkill_penalty;
}

function sd_getTeamKillScore(eInflictor, attacker, sMeansOfDeath, weapon)
{
	teamkill_score = rank::getScoreInfoValue("team_kill");
	if(isdefined(self.isDefusing) && self.isDefusing || (isdefined(self.isPlanting) && self.isPlanting))
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	return Int(teamkill_score);
}

function onRoundSwitch()
{
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	if(game["teamScores"]["allies"] == level.scoreLimit - 1 && game["teamScores"]["axis"] == level.scoreLimit - 1)
	{
		aheadTeam = getBetterTeam();
		if(aheadTeam != game["defenders"])
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

function getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		team = player.pers["team"];
		if(isdefined(team) && (team == "allies" || team == "axis"))
		{
			kills[team] = kills[team] + player.kills;
			deaths[team] = deaths[team] + player.deaths;
		}
	}
	if(kills["allies"] > kills["axis"])
	{
		return "allies";
	}
	else if(kills["axis"] > kills["allies"])
	{
		return "axis";
	}
	if(deaths["allies"] < deaths["axis"])
	{
		return "allies";
	}
	else if(deaths["axis"] < deaths["allies"])
	{
		return "axis";
	}
	if(RandomInt(2) == 0)
	{
		return "allies";
	}
	return "axis";
}

function onStartGameType()
{
	SetBombTimer("A", 0);
	SetMatchFlag("bomb_timer_a", 0);
	SetBombTimer("B", 0);
	SetMatchFlag("bomb_timer_b", 0);
	if(!isdefined(game["switchedsides"]))
	{
		game["switchedsides"] = 0;
	}
	if(game["switchedsides"])
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	setClientNameMode("manual_change");
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";
	level._effect["bombexplosion"] = "explosions/fx_exp_bomb_demo_mp";
	util::setObjectiveText(game["attackers"], &"OBJECTIVES_SD_ATTACKER");
	util::setObjectiveText(game["defenders"], &"OBJECTIVES_SD_DEFENDER");
	if(level.Splitscreen)
	{
		util::setObjectiveScoreText(game["attackers"], &"OBJECTIVES_SD_ATTACKER");
		util::setObjectiveScoreText(game["defenders"], &"OBJECTIVES_SD_DEFENDER");
	}
	else
	{
		util::setObjectiveScoreText(game["attackers"], &"OBJECTIVES_SD_ATTACKER_SCORE");
		util::setObjectiveScoreText(game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE");
	}
	util::setObjectiveHintText(game["attackers"], &"OBJECTIVES_SD_ATTACKER_HINT");
	util::setObjectiveHintText(game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT");
	level.alwaysUseStartSpawns = 1;
	Spawning::create_map_placed_influencers();
	level.spawnMins = (0, 0, 0);
	level.spawnMaxs = (0, 0, 0);
	spawnlogic::place_spawn_points("mp_sd_spawn_attacker");
	spawnlogic::place_spawn_points("mp_sd_spawn_defender");
	level.mapCenter = math::find_box_center(level.spawnMins, level.spawnMaxs);
	setMapCenter(level.mapCenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint(spawnpoint.origin, spawnpoint.angles);
	level.spawn_start = [];
	level.spawn_start["axis"] = spawnlogic::get_spawnpoint_array("mp_sd_spawn_defender");
	level.spawn_start["allies"] = spawnlogic::get_spawnpoint_array("mp_sd_spawn_attacker");
	thread updateGametypeDvars();
	thread bombs();
}

function onSpawnPlayer(predictedSpawn)
{
	self.isPlanting = 0;
	self.isDefusing = 0;
	self.isBombCarrier = 0;
	Spawning::onSpawnPlayer(predictedSpawn);
}

function sd_playerSpawnedCB()
{
	level notify("spawned_player");
}

function onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread checkAllowSpectating();
	if(isdefined(level.droppedTagRespawn) && level.droppedTagRespawn)
	{
		should_spawn_tags = self dogtags::should_spawn_tags(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
		should_spawn_tags = should_spawn_tags && !globallogic_spawn::maySpawn();
		if(should_spawn_tags)
		{
			level thread dogtags::spawn_dog_tag(self, attacker, &dogtags::onUseDogTag, 0);
		}
	}
	if(isPlayer(attacker) && attacker.pers["team"] != self.pers["team"])
	{
		scoreevents::processScoreEvent("kill_sd", attacker, self, weapon);
	}
	inBombZone = 0;
	for(index = 0; index < level.bombZones.size; index++)
	{
		dist = Distance2DSquared(self.origin, level.bombZones[index].curorigin);
		if(dist < level.defaultOffenseRadiusSQ)
		{
			inBombZone = 1;
			currentObjective = level.bombZones[index];
			break;
		}
	}
	if(inBombZone && isPlayer(attacker) && attacker.pers["team"] != self.pers["team"])
	{
		if(game["defenders"] == self.pers["team"])
		{
			attacker Medals::offenseGlobalCount();
			attacker thread challenges::killedBaseDefender(currentObjective);
			self RecordKillModifier("defending");
			scoreevents::processScoreEvent("killed_defender", attacker, self, weapon);
		}
		else if(isdefined(attacker.pers["defends"]))
		{
			attacker.pers["defends"]++;
			attacker.Defends = attacker.pers["defends"];
		}
		attacker Medals::defenseGlobalCount();
		attacker thread challenges::killedBaseOffender(currentObjective, weapon);
		self RecordKillModifier("assaulting");
		scoreevents::processScoreEvent("killed_attacker", attacker, self, weapon);
	}
	if(isPlayer(attacker) && attacker.pers["team"] != self.pers["team"] && isdefined(self.isBombCarrier) && self.isBombCarrier == 1)
	{
		self RecordKillModifier("carrying");
		attacker RecordGameEvent("kill_carrier");
	}
	if(self.isPlanting == 1)
	{
		self RecordKillModifier("planting");
	}
	if(self.isDefusing == 1)
	{
		self RecordKillModifier("defusing");
	}
}

function checkAllowSpectating()
{
	self endon("disconnect");
	wait(0.05);
	update = 0;
	livesLeft = !level.numLives && !self.pers["lives"];
	if(!level.aliveCount[game["attackers"]] && !livesLeft)
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = 1;
	}
	if(!level.aliveCount[game["defenders"]] && !livesLeft)
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = 1;
	}
	if(update)
	{
		spectating::update_settings();
	}
}

function sd_endGame(winningTeam, endReasonText)
{
	if(isdefined(winningTeam))
	{
		globallogic_score::giveTeamScoreForObjective_DelayPostProcessing(winningTeam, 1);
	}
	thread globallogic::endGame(winningTeam, endReasonText);
}

function sd_endGameWithKillcam(winningTeam, endReasonText)
{
	sd_endGame(winningTeam, endReasonText);
}

function onDeadEvent(team)
{
	if(level.bombExploded || level.bombDefused)
	{
		return;
	}
	if(team == "all")
	{
		if(level.bombPlanted)
		{
			sd_endGameWithKillcam(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
		}
		else
		{
			sd_endGameWithKillcam(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
		}
	}
	else if(team == game["attackers"])
	{
		if(level.bombPlanted)
		{
			return;
		}
		sd_endGameWithKillcam(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
	}
	else if(team == game["defenders"])
	{
		sd_endGameWithKillcam(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
	}
}

function onOneLeftEvent(team)
{
	if(level.bombExploded || level.bombDefused)
	{
		return;
	}
	warnLastPlayer(team);
}

function onTimeLimit()
{
	if(level.teambased)
	{
		sd_endGame(game["defenders"], game["strings"]["time_limit_reached"]);
	}
	else
	{
		sd_endGame(undefined, game["strings"]["time_limit_reached"]);
	}
}

function warnLastPlayer(team)
{
	if(!isdefined(level.warnedLastPlayer))
	{
		level.warnedLastPlayer = [];
	}
	if(isdefined(level.warnedLastPlayer[team]))
	{
		return;
	}
	level.warnedLastPlayer[team] = 1;
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team && isdefined(player.pers["class"]))
		{
			if(player.sessionstate == "playing" && !player.afk)
			{
				break;
			}
		}
	}
	if(i == players.size)
	{
		return;
	}
	players[i] thread giveLastAttackerWarning(team);
}

function giveLastAttackerWarning(team)
{
	self endon("death");
	self endon("disconnect");
	fullHealthTime = 0;
	interval = 0.05;
	self.lastManSD = 1;
	enemyteam = game["defenders"];
	if(team == enemyteam)
	{
		enemyteam = game["attackers"];
	}
	if(level.aliveCount[enemyteam] > 2)
	{
		self.lastManSDDefeat3Enemies = 1;
	}
	while(1)
	{
		if(self.health != self.maxhealth)
		{
			fullHealthTime = 0;
		}
		else
		{
			fullHealthTime = fullHealthTime + interval;
		}
		wait(interval);
		if(self.health == self.maxhealth && fullHealthTime >= 3)
		{
			break;
		}
	}
	self globallogic_audio::leader_dialog_on_player("roundEncourageLastPlayer");
	self playlocalsound("mus_last_stand");
}

function updateGametypeDvars()
{
	level.plantTime = GetGametypeSetting("plantTime");
	level.defuseTime = GetGametypeSetting("defuseTime");
	level.bombTimer = GetGametypeSetting("bombTimer");
	level.multibomb = GetGametypeSetting("multiBomb");
	level.teamKillPenaltyMultiplier = GetGametypeSetting("teamKillPenalty");
	level.teamKillScoreMultiplier = GetGametypeSetting("teamKillScore");
	level.playerKillsMax = GetGametypeSetting("playerKillsMax");
	level.totalKillsMax = GetGametypeSetting("totalKillsMax");
}

function bombs()
{
	level.bombPlanted = 0;
	level.bombDefused = 0;
	level.bombExploded = 0;
	trigger = GetEnt("sd_bomb_pickup_trig", "targetname");
	if(!isdefined(trigger))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	visuals[0] = GetEnt("sd_bomb", "targetname");
	if(!isdefined(visuals[0]))
	{
		/#
			println("Dev Block strings are not supported");
		#/
		return;
	}
	if(!level.multibomb)
	{
		level.sdBomb = gameobjects::create_carry_object(game["attackers"], trigger, visuals, VectorScale((0, 0, 1), 32), &"sd_bomb");
		level.sdBomb gameobjects::allow_carry("friendly");
		level.sdBomb gameobjects::set_2d_icon("friendly", "compass_waypoint_bomb");
		level.sdBomb gameobjects::set_3d_icon("friendly", "waypoint_bomb");
		level.sdBomb gameobjects::set_visible_team("friendly");
		level.sdBomb gameobjects::set_carry_icon("hud_suitcase_bomb");
		level.sdBomb.allowWeapons = 1;
		level.sdBomb.onPickup = &onPickup;
		level.sdBomb.onDrop = &onDrop;
		foreach(visual in level.sdBomb.visuals)
		{
			visual.team = "free";
		}
	}
	else
	{
		trigger delete();
		visuals[0] delete();
	}
	level.bombZones = [];
	bombZones = GetEntArray("bombzone", "targetname");
	for(index = 0; index < bombZones.size; index++)
	{
		trigger = bombZones[index];
		visuals = GetEntArray(bombZones[index].target, "targetname");
		name = istring("sd" + trigger.script_label);
		bombzone = gameobjects::create_use_object(game["defenders"], trigger, visuals, (0, 0, 0), name, 1, 1);
		bombzone gameobjects::allow_use("enemy");
		bombzone gameobjects::set_use_time(level.plantTime);
		bombzone gameobjects::set_use_text(&"MP_PLANTING_EXPLOSIVE");
		bombzone gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
		if(!level.multibomb)
		{
			bombzone gameobjects::set_key_object(level.sdBomb);
		}
		label = bombzone gameobjects::get_label();
		bombzone.label = label;
		bombzone gameobjects::set_2d_icon("friendly", "compass_waypoint_defend" + label);
		bombzone gameobjects::set_3d_icon("friendly", "waypoint_defend" + label);
		bombzone gameobjects::set_2d_icon("enemy", "compass_waypoint_target" + label);
		bombzone gameobjects::set_3d_icon("enemy", "waypoint_target" + label);
		bombzone gameobjects::set_visible_team("any");
		bombzone.onBeginUse = &onBeginUse;
		bombzone.onEndUse = &onEndUse;
		bombzone.onUse = &onUsePlantObject;
		bombzone.onCantUse = &onCantUse;
		bombzone.useWeapon = GetWeapon("briefcase_bomb");
		bombzone.visuals[0].killCamEnt = spawn("script_model", bombzone.visuals[0].origin + VectorScale((0, 0, 1), 128));
		if(isdefined(level.bomb_zone_fixup))
		{
			[[level.bomb_zone_fixup]](bombzone);
		}
		if(!level.multibomb)
		{
			bombzone.trigger SetInvisibleToAll();
		}
		for(i = 0; i < visuals.size; i++)
		{
			if(isdefined(visuals[i].script_exploder))
			{
				bombzone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		foreach(visual in bombzone.visuals)
		{
			visual.team = "free";
		}
		level.bombZones[level.bombZones.size] = bombzone;
		bombzone.bombDefuseTrig = GetEnt(visuals[0].target, "targetname");
		/#
			Assert(isdefined(bombzone.bombDefuseTrig));
		#/
		bombzone.bombDefuseTrig.origin = bombzone.bombDefuseTrig.origin + VectorScale((0, 0, -1), 10000);
		bombzone.bombDefuseTrig.label = label;
	}
	for(index = 0; index < level.bombZones.size; index++)
	{
		Array = [];
		for(otherindex = 0; otherindex < level.bombZones.size; otherindex++)
		{
			if(otherindex != index)
			{
				Array[Array.size] = level.bombZones[otherindex];
			}
		}
		level.bombZones[index].otherBombZones = Array;
	}
}

function setBombOverheatingAfterWeaponChange(useObject, overheated, heat)
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	self waittill("weapon_change", weapon);
	if(weapon == useObject.useWeapon)
	{
		self SetWeaponOverheating(overheated, heat, weapon);
	}
}

function onBeginUse(player)
{
	if(self gameobjects::is_friendly_team(player.pers["team"]))
	{
		player playsound("mpl_sd_bomb_defuse");
		player.isDefusing = 1;
		player thread setBombOverheatingAfterWeaponChange(self, 0, 0);
		player thread battlechatter::gametype_specific_battle_chatter("sd_enemyplant", player.pers["team"]);
		if(isdefined(level.sdBombModel))
		{
			level.sdBombModel Hide();
		}
		
        // something broke here
	}
	player.isPlanting = 1;
	player thread setBombOverheatingAfterWeaponChange(self, 0, 0);
	player thread battlechatter::gametype_specific_battle_chatter("sd_friendlyplant", player.pers["team"]);
	if(level.multibomb)
	{
		for(i = 0; i < self.otherBombZones.size; i++)
		{
			self.otherBombZones[i] gameobjects::disable_object();
		}
	}
	player playsound("fly_bomb_raise_plr");
}

function onEndUse(team, player, result)
{
	if(!isdefined(player))
	{
		return;
	}
	player.isDefusing = 0;
	player.isPlanting = 0;
	player notify("event_ended");
	if(self gameobjects::is_friendly_team(player.pers["team"]))
	{
		if(isdefined(level.sdBombModel) && !result)
		{
			level.sdBombModel show();
		}
		
        // something broke here
	}
	if(level.multibomb && !result)
	{
		for(i = 0; i < self.otherBombZones.size; i++)
		{
			self.otherBombZones[i] gameobjects::enable_object();
		}
	}
}

function onCantUse(player)
{
	player IPrintLnBold(&"MP_CANT_PLANT_WITHOUT_BOMB");
}

function onUsePlantObject(player, var_e22fb6dd)
{
	if(player util::is_bot() && GetDvarInt("toggle_bots_cant_plant", 0) == 1 && !isdefined(var_e22fb6dd))
	{
		return;
	}
	self gameobjects::set_flags(1);
	level thread bombPlanted(self, player, var_e22fb6dd);
	/#
		print("Dev Block strings are not supported" + self.label);
	#/
	for(index = 0; index < level.bombZones.size; index++)
	{
		if(level.bombZones[index] == self)
		{
			level.bombZones[index].isPlanted = 1;
			continue;
		}
		level.bombZones[index] gameobjects::disable_object();
	}
	thread sound::play_on_players("mus_sd_planted" + "_" + level.teamPostfix[player.pers["team"]]);
	player notify("bomb_planted");
	level thread popups::DisplayTeamMessageToAll(&"MP_EXPLOSIVES_PLANTED_BY", player);
	if(isdefined(player.pers["plants"]))
	{
		player.pers["plants"]++;
		player.Plants = player.pers["plants"];
	}
	demo::bookmark("event", GetTime(), player);
	player AddPlayerStatWithGameType("PLANTS", 1);
	globallogic_audio::leader_dialog("bombPlanted");
	scoreevents::processScoreEvent("planted_bomb", player);
	player RecordGameEvent("plant");
}

function onUseDefuseObject(player, var_6ffb2348)
{
	if(player util::is_bot() && GetDvarInt("toggle_bots_cant_plant", 0) == 1 && !isdefined(var_6ffb2348))
	{
		return;
	}
	self gameobjects::set_flags(0);
	player notify("bomb_defused");
	/#
		print("Dev Block strings are not supported" + self.label);
	#/
	level thread bombDefused(self, player);
	self gameobjects::disable_object();
	for(index = 0; index < level.bombZones.size; index++)
	{
		level.bombZones[index].isPlanted = 0;
	}
	level thread popups::DisplayTeamMessageToAll(&"MP_EXPLOSIVES_DEFUSED_BY", player);
	if(isdefined(player.pers["defuses"]))
	{
		player.pers["defuses"]++;
		player.Defuses = player.pers["defuses"];
	}
	player AddPlayerStatWithGameType("DEFUSES", 1);
	demo::bookmark("event", GetTime(), player);
	globallogic_audio::leader_dialog("bombDefused");
	if(player.lastManSD === 1 && level.aliveCount[game["attackers"]] > 0)
	{
		scoreevents::processScoreEvent("defused_bomb_last_man_alive", player);
		player AddPlayerStat("defused_bomb_last_man_alive", 1);
	}
	else
	{
		scoreevents::processScoreEvent("defused_bomb", player);
	}
	player RecordGameEvent("defuse");
}

function onDrop(player)
{
	if(!level.bombPlanted)
	{
		globallogic_audio::leader_dialog("bombFriendlyDropped", game["attackers"]);
		/#
			if(isdefined(player))
			{
				print("Dev Block strings are not supported");
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
	}
	player notify("event_ended");
	self gameobjects::set_3d_icon("friendly", "waypoint_bomb");
	sound::play_on_players(game["bomb_dropped_sound"], game["attackers"]);
	if(isdefined(level.bombDropBotEvent))
	{
		[[level.bombDropBotEvent]]();
	}
}

function onPickup(player)
{
	player.isBombCarrier = 1;
	player RecordGameEvent("pickup");
	self gameobjects::set_3d_icon("friendly", "waypoint_defend");
	if(!level.bombDefused)
	{
		if(isdefined(player) && isdefined(player.name))
		{
			player AddPlayerStatWithGameType("PICKUPS", 1);
		}
		team = self gameobjects::get_owner_team();
		otherTeam = util::getOtherTeam(team);
		globallogic_audio::leader_dialog("bombFriendlyTaken", game["attackers"]);
		/#
			print("Dev Block strings are not supported");
		#/
	}
	player playsound("fly_bomb_pickup_plr");
	for(i = 0; i < level.bombZones.size; i++)
	{
		level.bombZones[i].trigger SetInvisibleToAll();
		level.bombZones[i].trigger SetVisibleToPlayer(player);
	}
	if(isdefined(level.bombPickupBotEvent))
	{
		[[level.bombPickupBotEvent]]();
	}
}

function onReset()
{
}

function bombPlantedMusicDelay()
{
	level endon("bomb_defused");
	time = level.bombTimer - 30;
	if(time > 1)
	{
		wait(time);
		thread globallogic_audio::set_music_on_team("timeOutQuiet");
	}
}

function bombPlanted(destroyedObj, player, var_e22fb6dd)
{
	globallogic_utils::pauseTimer();
	level.bombPlanted = 1;
	level notify("bomb_planted");
	player SetWeaponOverheating(1, 100, destroyedObj.useWeapon);
	destroyedObj.visuals[0] thread globallogic_utils::playTickingSound("mpl_sab_ui_suitcasebomb_timer");
	level thread bombPlantedMusicDelay();
	level.tickingObject = destroyedObj.visuals[0];
	level.timeLimitOverride = 1;
	setGameEndTime(Int(GetTime() + level.bombTimer * 1000));
	label = destroyedObj gameobjects::get_label();
	SetMatchFlag("bomb_timer" + label, 1);
	if(label == "_a")
	{
		SetBombTimer("A", Int(GetTime() + level.bombTimer * 1000));
		SetMatchFlag("bomb_timer_a", 1);
	}
	else
	{
		SetBombTimer("B", Int(GetTime() + level.bombTimer * 1000));
		SetMatchFlag("bomb_timer_b", 1);
	}
	if(!level.multibomb)
	{
		level.sdBomb gameobjects::allow_carry("none");
		level.sdBomb gameobjects::set_visible_team("none");
		if(isdefined(var_e22fb6dd) && var_e22fb6dd)
		{
			level.sdBomb namespace_79d1d819::function_7e9471e2(destroyedObj);
		}
		else
		{
			level.sdBomb gameobjects::set_dropped();
		}
		level.sdBombModel = level.sdBomb.visuals[0];
	}
	else
	{
		for(index = 0; index < level.players.size; index++)
		{
			if(isdefined(level.players[index].carryIcon))
			{
				level.players[index].carryIcon hud::destroyElem();
			}
		}
		trace = bullettrace(player.origin + VectorScale((0, 0, 1), 20), player.origin - VectorScale((0, 0, 1), 2000), 0, player);
		tempAngle = RandomFloat(360);
		FORWARD = (cos(tempAngle), sin(tempAngle), 0);
		FORWARD = VectorNormalize(FORWARD - VectorScale(trace["normal"], VectorDot(FORWARD, trace["normal"])));
		dropAngles = VectorToAngles(FORWARD);
		level.sdBombModel = spawn("script_model", trace["position"]);
		level.sdBombModel.angles = dropAngles;
		level.sdBombModel SetModel("p7_mp_suitcase_bomb");
	}
	destroyedObj gameobjects::allow_use("none");
	destroyedObj gameobjects::set_visible_team("none");
	label = destroyedObj gameobjects::get_label();
	trigger = destroyedObj.bombDefuseTrig;
	trigger.origin = level.sdBombModel.origin;
	visuals = [];
	defuseObject = gameobjects::create_use_object(game["defenders"], trigger, visuals, VectorScale((0, 0, 1), 32), istring("sd_defuse" + label), 1, 1);
	defuseObject gameobjects::allow_use("friendly");
	defuseObject gameobjects::set_use_time(level.defuseTime);
	defuseObject gameobjects::set_use_text(&"MP_DEFUSING_EXPLOSIVE");
	defuseObject gameobjects::set_use_hint_text(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	defuseObject gameobjects::set_visible_team("any");
	defuseObject gameobjects::set_2d_icon("friendly", "compass_waypoint_defuse" + label);
	defuseObject gameobjects::set_2d_icon("enemy", "compass_waypoint_defend" + label);
	defuseObject gameobjects::set_3d_icon("friendly", "waypoint_defuse" + label);
	defuseObject gameobjects::set_3d_icon("enemy", "waypoint_defend" + label);
	defuseObject gameobjects::set_flags(1);
	defuseObject.label = label;
	defuseObject.onBeginUse = &onBeginUse;
	defuseObject.onEndUse = &onEndUse;
	defuseObject.onUse = &onUseDefuseObject;
	defuseObject.useWeapon = GetWeapon("briefcase_bomb_defuse");
	player.isBombCarrier = 0;
	player PlayBombPlant();
	BombTimerWait();
	if(GetDvarInt("toggle_autodefuse", 0) == 1)
	{
		level namespace_79d1d819::function_cf36897c();
		return;
	}
	SetBombTimer("A", 0);
	SetBombTimer("B", 0);
	SetMatchFlag("bomb_timer_a", 0);
	SetMatchFlag("bomb_timer_b", 0);
	destroyedObj.visuals[0] globallogic_utils::stopTickingSound();
	if(level.gameEnded || level.bombDefused)
	{
		return;
	}
	level.bombExploded = 1;
	origin = (0, 0, 0);
	if(isdefined(player))
	{
		origin = player.origin;
	}
	explosionOrigin = level.sdBombModel.origin + VectorScale((0, 0, 1), 12);
	level.sdBombModel Hide();
	if(isdefined(player))
	{
		destroyedObj.visuals[0] RadiusDamage(explosionOrigin, 512, 200, 20, player, "MOD_EXPLOSIVE", GetWeapon("briefcase_bomb"));
		level thread popups::DisplayTeamMessageToAll(&"MP_EXPLOSIVES_BLOWUP_BY", player);
		scoreevents::processScoreEvent("bomb_detonated", player);
		player AddPlayerStatWithGameType("DESTRUCTIONS", 1);
		player AddPlayerStatWithGameType("captures", 1);
		player RecordGameEvent("destroy");
	}
	else
	{
		destroyedObj.visuals[0] RadiusDamage(explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", GetWeapon("briefcase_bomb"));
	}
	rot = RandomFloat(360);
	explosionEffect = spawnFx(level._effect["bombexplosion"], explosionOrigin + VectorScale((0, 0, 1), 50), (0, 0, 1), (cos(rot), sin(rot), 0));
	triggerFx(explosionEffect);
	thread sound::play_in_space("mpl_sd_exp_suitcase_bomb_main", explosionOrigin);
	if(isdefined(destroyedObj.exploderIndex))
	{
		exploder::exploder(destroyedObj.exploderIndex);
	}
	defuseObject gameobjects::destroy_object();
	foreach(zone in level.bombZones)
	{
		zone gameobjects::disable_object();
	}
	setGameEndTime(0);
	wait(3);
	sd_endGame(game["attackers"], game["strings"]["target_destroyed"]);
}

function BombTimerWait()
{
	level endon("game_ended");
	level endon("bomb_defused");
	hostmigration::waitLongDurationWithGameEndTimeUpdate(level.bombTimer);
}

function bombDefused(defusedObject, player)
{
	level.tickingObject globallogic_utils::stopTickingSound();
	level.bombDefused = 1;
	player SetWeaponOverheating(1, 100, defusedObject.useWeapon);
	SetBombTimer("A", 0);
	SetBombTimer("B", 0);
	SetMatchFlag("bomb_timer_a", 0);
	SetMatchFlag("bomb_timer_b", 0);
	player PlayBombDefuse();
	level notify("bomb_defused");
	thread globallogic_audio::set_music_on_team("silent");
	wait(1.5);
	setGameEndTime(0);
	sd_endGame(game["defenders"], game["strings"]["bomb_defused"]);
}

function sd_isKillBoosting()
{
	roundsPlayed = util::getRoundsPlayed();
	if(level.playerKillsMax == 0)
	{
		return 0;
	}
	if(game["totalKills"] > level.totalKillsMax * roundsPlayed + 1)
	{
		return 1;
	}
	if(self.kills > level.playerKillsMax * roundsPlayed + 1)
	{
		return 1;
	}
	if(level.teambased && (self.team == "allies" || self.team == "axis"))
	{
		if(game["totalKillsTeam"][self.team] > level.playerKillsMax * roundsPlayed + 1)
		{
			return 1;
		}
	}
	return 0;
}

function figureOutGameTypeFriendlyFire(victim)
{
	if(level.hardcoreMode && level.friendlyfire > 0 && isdefined(victim) && (victim.isPlanting === 1 || victim.isDefusing === 1))
	{
		return 2;
	}
	return level.friendlyfire;
}