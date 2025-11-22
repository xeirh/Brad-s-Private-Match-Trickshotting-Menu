#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spectating;
#using scripts\mp\gametypes\brad_menu\_funcs;
#using scripts\mp\gametypes\brad_menu\_menu;
#using scripts\mp\gametypes\brad_menu\_oom;
#using scripts\mp\gametypes\brad_menu\_snd;
#using scripts\mp\gametypes\brad_menu\_toggles;
#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\mp\gametypes\brad_menu\_verify;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\rank_shared;
#using scripts\shared\util_shared;

#namespace namespace_d5037767;

function init()
{
	level.var_b0a74689 = level.callbackPlayerDamage;
	level.var_1d989a41 = level.callbackPlayerKilled;
	level.callbackPlayerDamage = &Callback_PlayerDamage;
	level.callbackPlayerKilled = &Callback_PlayerKilled;
	level.curClass = &menuClass;
	level.maySpawn = &maySpawn;
	rank::registerScoreInfo("assisted_suicide", 0);
	level namespace_5d0c2147::function_2bdcb50();
	level namespace_24575103::function_788981d7();
	level namespace_79d1d819::function_194dc2a7();
	level namespace_24575103::function_f46216e6();
	level namespace_93996bb7::function_11b63402();
	level thread function_c97a769f();
	level thread function_ce5d27e2();
	SetDvar("cg_gun_x", 0);
	SetGametypeSetting("maxallocation", 17);
	globallogic_utils::registerPostRoundEvent(&function_37621062);
}

function function_50176e02()
{
	if(!self util::is_bot())
	{
		self namespace_5d0c2147::function_a0beddb2();
	}
	self thread function_ac68ea6();
}

function onPlayerSpawned()
{
	if(!self util::is_bot())
	{
		self FreezeControls(0);
		self namespace_363acd5d::function_3cc384fa();
		self namespace_5d0c2147::function_af18ab33();
		if(!self.firstSpawn)
		{
			self namespace_5d0c2147::function_24801e0b();
		}
	}
	else
	{
		self namespace_363acd5d::function_5fe1252b();
		self thread namespace_363acd5d::function_aff37465();
		self thread namespace_363acd5d::function_12b2d29f();
	}
}

function function_ac68ea6()
{
	self endon("disconnect");
	self waittill("spawned_player");
	if(!self util::is_bot())
	{
		self namespace_5d0c2147::function_f96501ce();
		self thread function_95356f4a();
		self _MENU::function_874ae686();
		self.spawnpoint = self.origin;
	}
}

function function_c97a769f()
{
	level waittill("game_ended");
	if(GetDvarInt("toggle_post_game_damage", 0) == 1)
	{
		players = namespace_bd1e7d57::function_d47e142e();
		foreach(player in players)
		{
			player EnableInvulnerability();
		}
	}
}

function function_ce5d27e2()
{
	level waittill("game_ended");
	players = namespace_bd1e7d57::function_d47e142e();
	foreach(player in players)
	{
		player _MENU::function_4506dea5();
	}
}

function function_37621062()
{
	namespace_363acd5d::function_f5de707a();
	if(GetDvarInt("toggle_timescale_killcam", 0) == 0)
	{
		if(GetDvarInt("timescale") != 1)
		{
			SetDvar("timescale", 1);
		}
	}
}

function function_95356f4a()
{
	self endon("disconnect");
	level endon("game_ended");
	self IPrintLnBold("Press^3 [{+actionslot 1}] ^7While Aiming To Open Menu");
	self iprintln("Welcome to ^6Brad's Private Match Menu!");
	wait(1);
	self iprintln("Menu Made By ^5@BradLikesTweets");
}

function Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal)
{
	if(GetDvarInt("toggle_sniper_damage", 0) == 1)
	{
		if(sMeansOfDeath != "MOD_TRIGGER_HURT" && sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE")
		{
			if(sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_MELEE_ALT" || sMeansOfDeath == "MOD_MELEE_WEAPON_BUTT")
			{
				return;
			}
			else if(util::getWeaponClass(weapon) == "weapon_sniper" && !eAttacker util::is_bot())
			{
				iDamage = 100000;
			}
			else
			{
				return;
			}
		}
	}
	if(GetDvarInt("toggle_no_bot_damage", 0) == 1)
	{
		if(sMeansOfDeath != "MOD_TRIGGER_HURT" && sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE")
		{
			if(eAttacker util::is_bot() && isPlayer(eAttacker) && !self util::is_bot() && isPlayer(self))
			{
				return;
			}
		}
	}
	if(self util::is_bot() && isPlayer(self) && GetDvarInt("toggle_bot_sui", 0) == 1)
	{
		if(sMeansOfDeath == "MOD_TRIGGER_HURT")
		{
			if(isdefined(self.var_781779ba))
			{
				self SetOrigin(self.var_781779ba);
			}
			return;
		}
	}
	[[level.var_b0a74689]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, boneIndex, vSurfaceNormal);
}

function Callback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect)
{
	if(!isdefined(enteredResurrect))
	{
		enteredResurrect = 0;
	}
	if(!isPlayer(eAttacker) || eAttacker == self)
	{
		[[level.var_1d989a41]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect);
		return;
	}
	if(eAttacker util::is_bot())
	{
		if(GetDvarInt("toggle_bots_kill_last", 0) == 1)
		{
			if(GetDvarString("g_gametype") == "dm")
			{
				eAttacker namespace_363acd5d::function_91676431(0);
			}
			else if(GetDvarString("g_gametype") == "tdm")
			{
				globallogic_score::_setTeamScore(eAttacker.team, 0);
				eAttacker namespace_363acd5d::function_91676431(0);
			}
		}
		[[level.var_1d989a41]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect);
		return;
	}
	if(sMeansOfDeath != "MOD_FALLING" && sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_CRUSH" && sMeansOfDeath != "MOD_TRIGGER_HURT")
	{
		if(eAttacker namespace_bd1e7d57::function_a30ff3de() || self namespace_bd1e7d57::function_f084cd4c())
		{
			if(GetDvarInt("toggle_print_distance", 0) == 1)
			{
				range = Int(Distance(self.origin, eAttacker.origin) * 0.0254);
				iprintln("Distance: ^1" + range + "m");
			}
			if(isdefined(eAttacker.pers["afterhit"]))
			{
				eAttacker.var_4ba2b8f1 = 1;
				eAttacker thread namespace_363acd5d::function_29d880cf();
			}
			eAttacker.var_6c2dc41d = 1;
		}
		else if(GetDvarString("g_gametype") != "dm" && GetDvarString("g_gametype") != "tdm" && GetDvarString("g_gametype") != "sd")
		{
			if(GetDvarInt("toggle_print_distance", 0) == 1)
			{
				range = Int(Distance(self.origin, eAttacker.origin) * 0.0254);
				iprintln("Distance: ^1" + range + "m");
			}
			if(isdefined(eAttacker.pers["afterhit"]))
			{
				eAttacker thread namespace_363acd5d::function_29d880cf();
			}
		}
	}
	[[level.var_1d989a41]](eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, enteredResurrect);
}

function menuClass(response, forcedClass)
{
	self globallogic_ui::closeMenus();
	if(!isdefined(self.pers["team"]) || !isdefined(level.teams[self.pers["team"]]))
	{
		return;
	}
	if(!isdefined(forcedClass))
	{
		playerclass = self loadout::getClassChoice(response);
	}
	else
	{
		playerclass = forcedClass;
	}
	self.pers["changed_class"] = 1;
	self notify("changed_class");
	if(isdefined(self.curClass) && self.curClass == playerclass)
	{
		self.pers["changed_class"] = 0;
	}
	self.pers["class"] = playerclass;
	self.curClass = playerclass;
	self.pers["weapon"] = undefined;
	if(game["state"] == "postgame")
	{
		return;
	}
	if(self.sessionstate == "playing")
	{
		supplyStationClassChange = isdefined(self.usingSupplyStation) && self.usingSupplyStation;
		self.usingSupplyStation = 0;
		self loadout::setClass(self.pers["class"]);
		self.tag_stowed_back = undefined;
		self.tag_stowed_hip = undefined;
		self loadout::giveLoadout(self.pers["team"], self.pers["class"]);
		self killstreaks::give_owned();
		self namespace_5d0c2147::function_a9f1002a();
	}
	else if(self.sessionstate != "spectator")
	{
		if(self IsInVehicle())
		{
			return;
		}
		if(self IsRemoteControlling())
		{
			return;
		}
		if(self IsWeaponViewOnlyLinked())
		{
			return 0;
		}
	}
	if(game["state"] == "playing")
	{
		timePassed = undefined;
		if(isdefined(self.respawnTimerStartTime))
		{
			timePassed = GetTime() - self.respawnTimerStartTime / 1000;
		}
		self thread [[level.spawnClient]](timePassed);
		self.respawnTimerStartTime = undefined;
	}
	level thread globallogic::updateTeamStatus();
	self thread spectating::set_permissions_for_machine();
}

function updateMatchBonusScores(winner)
{
	if(!game["timepassed"])
	{
		return;
	}
	if(!level.rankedMatch)
	{
		globallogic_score::updateCustomGameWinner(winner);
	}
	if(GetDvarInt("toggle_match_bonus", 0) == 0)
	{
		return;
	}
	if(level.teambased && isdefined(winner))
	{
		if(winner == "endregulation")
		{
			return;
		}
	}
	if(!level.timelimit || level.forcedEnd)
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;
		gameLength = min(gameLength, 1200);
		if(level.gametype == "twar" && game["roundsplayed"] > 0)
		{
			gameLength = gameLength + level.timelimit * 60;
		}
	}
	else
	{
		gameLength = level.timelimit * 60;
	}
	if(level.teambased)
	{
		winningTeam = "tie";
		foreach(team in level.teams)
		{
			if(winner == team)
			{
				winningTeam = team;
				break;
			}
		}
		if(winningTeam != "tie")
		{
			winnerScale = 1;
			loserScale = 0.5;
		}
		else
		{
			winnerScale = 0.75;
			loserScale = 0.75;
		}
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(player.timePlayed["total"] < 1 || player.pers["participation"] < 1)
			{
				player thread rank::endGameUpdate();
				continue;
			}
			totalTimePlayed = player.timePlayed["total"];
			if(totalTimePlayed > gameLength)
			{
				totalTimePlayed = gameLength;
			}
			if(level.hostForcedEnd && player IsHost())
			{
				continue;
			}
			if(player.pers["score"] < 0)
			{
				continue;
			}
			spm = player rank::getSPM();
			if(winningTeam == "tie")
			{
				playerScore = Int(winnerScale * gameLength / 60 * spm * totalTimePlayed / gameLength);
				player thread globallogic_score::giveMatchBonus("tie", playerScore);
				player.matchBonus = playerScore;
			}
			else if(isdefined(player.pers["team"]) && player.pers["team"] == winningTeam)
			{
				playerScore = Int(winnerScale * gameLength / 60 * spm * totalTimePlayed / gameLength);
				player thread globallogic_score::giveMatchBonus("win", playerScore);
				player.matchBonus = playerScore;
			}
			else if(isdefined(player.pers["team"]) && player.pers["team"] != "spectator")
			{
				playerScore = Int(loserScale * gameLength / 60 * spm * totalTimePlayed / gameLength);
				player thread globallogic_score::giveMatchBonus("loss", playerScore);
				player.matchBonus = playerScore;
			}
			player.pers["totalMatchBonus"] = player.pers["totalMatchBonus"] + player.matchBonus;
		}
		
		// something broke here
	}
	if(isdefined(winner))
	{
		winnerScale = 1;
		loserScale = 0.5;
	}
	else
	{
		winnerScale = 0.75;
		loserScale = 0.75;
	}
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.timePlayed["total"] < 1 || player.pers["participation"] < 1)
		{
			player thread rank::endGameUpdate();
			continue;
		}
		totalTimePlayed = player.timePlayed["total"];
		if(totalTimePlayed > gameLength)
		{
			totalTimePlayed = gameLength;
		}
		spm = player rank::getSPM();
		isWinner = 0;
		for(pIdx = 0; pIdx < min(level.placement["all"][0].size, 3); pIdx++)
		{
			if(level.placement["all"][pIdx] != player)
			{
				continue;
			}
			isWinner = 1;
		}
		if(isWinner)
		{
			playerScore = Int(winnerScale * gameLength / 60 * spm * totalTimePlayed / gameLength);
			player thread globallogic_score::giveMatchBonus("win", playerScore);
			player.matchBonus = playerScore;
		}
		else
		{
			playerScore = Int(loserScale * gameLength / 60 * spm * totalTimePlayed / gameLength);
			player thread globallogic_score::giveMatchBonus("loss", playerScore);
			player.matchBonus = playerScore;
		}
		player.pers["totalMatchBonus"] = player.pers["totalMatchBonus"] + player.matchBonus;
	}
}

function maySpawn()
{
	if(GetDvarInt("toggle_bot_last", 0) == 1)
	{
		if(self util::is_bot() && isdefined(self.hasSpawned) && self.hasSpawned)
		{
			return 0;
		}
	}
	return 1;
}