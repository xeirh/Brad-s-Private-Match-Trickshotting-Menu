#using scripts\codescripts\struct;
#using scripts\mp\_arena;
#using scripts\mp\_behavior_tracker;
#using scripts\mp\_gameadvertisement;
#using scripts\mp\_gamerep;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_weapon_utils;
#using scripts\mp\gametypes\_weapons;
#using scripts\mp\gametypes\brad_menu\_main;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weapons;

#namespace globallogic;

function autoexec __init__sytem__()
{
	system::register("globallogic", &__init__, undefined, "visionset_mgr");
}

function __init__()
{
	if(!isdefined(level.vsmgr_prio_visionset_mpintro))
	{
		level.vsmgr_prio_visionset_mpintro = 5;
	}
	visionset_mgr::register_info("visionset", "mpintro", 1, level.vsmgr_prio_visionset_mpintro, 31, 0, &visionset_mgr::ramp_in_out_thread, 0);
	level.host_migration_activate_visionset_func = &mpintro_visionset_activate_func;
	level.host_migration_deactivate_visionset_func = &mpintro_visionset_deactivate_func;
}

function init()
{
	level.Splitscreen = IsSplitscreen();
	level.xenon = GetDvarString("xenonGame") == "true";
	level.ps3 = GetDvarString("ps3Game") == "true";
	level.wiiu = GetDvarString("wiiuGame") == "true";
	level.orbis = GetDvarString("orbisGame") == "true";
	level.durango = GetDvarString("durangoGame") == "true";
	level.onlineGame = SessionModeIsOnlineGame();
	level.systemLink = SessionModeIsSystemlink();
	level.console = level.xenon || level.ps3 || level.wiiu || level.orbis || level.durango;
	level.rankedMatch = GameModeIsUsingXP();
	level.leagueMatch = 0;
	level.customMatch = GameModeIsMode(1);
	level.arenaMatch = GameModeIsArena();
	level.mpCustomMatch = level.customMatch;
	level.contractsEnabled = !GetGametypeSetting("disableContracts");
	level.contractsEnabled = 0;
	level.disableVehicleBurnDamage = 1;
	level.script = ToLower(GetDvarString("mapname"));
	level.gametype = ToLower(GetDvarString("g_gametype"));
	level.teambased = 0;
	level.teamCount = GetGametypeSetting("teamCount");
	level.multiTeam = level.teamCount > 2;
	level.teams = [];
	level.teamIndex = [];
	teamCount = level.teamCount;
	if(level.teamCount == 1)
	{
		teamCount = 18;
		level.teams["free"] = "free";
	}
	level.teams["allies"] = "allies";
	level.teams["axis"] = "axis";
	level.teamIndex["neutral"] = 0;
	level.teamIndex["allies"] = 1;
	level.teamIndex["axis"] = 2;
	for(teamIndex = 3; teamIndex <= teamCount; teamIndex++)
	{
		level.teams["team" + teamIndex] = "team" + teamIndex;
		level.teamIndex["team" + teamIndex] = teamIndex;
	}
	level.overrideTeamScore = 0;
	level.overridePlayerScore = 0;
	level.displayHalftimeText = 0;
	level.displayRoundEndText = 1;
	level.clampScoreLimit = 1;
	level.endGameOnScoreLimit = 1;
	level.endGameOnTimeLimit = 1;
	level.scoreRoundWinBased = 0;
	level.resetPlayerScoreEveryRound = 0;
	level.doEndgameScoreboard = 1;
	level.gameForfeited = 0;
	level.forceAutoAssign = 0;
	level.halftimeType = "halftime";
	level.halftimeSubCaption = &"MP_SWITCHING_SIDES_CAPS";
	level.lastStatusTime = 0;
	level.wasWinning = [];
	level.lastSlowProcessFrame = 0;
	level.placement = [];
	foreach(team in level.teams)
	{
		level.placement[team] = [];
	}
	level.placement["all"] = [];
	level.postRoundTime = 7;
	level.inOvertime = 0;
	level.defaultOffenseRadius = 560;
	level.defaultOffenseRadiusSQ = level.defaultOffenseRadius * level.defaultOffenseRadius;
	level.dropTeam = GetDvarInt("sv_maxclients");
	level.inFinalKillcam = 0;
	globallogic_ui::init();
	registerDvars();
	loadout::initPerkDvars();
	level.oldschool = GetGametypeSetting("oldschoolMode");
	precache_mp_leaderboards();
	if(!isdefined(game["tiebreaker"]))
	{
		game["tiebreaker"] = 0;
	}
	thread gameadvertisement::init();
	thread gamerep::init();
	thread teamops::init();
	level.disableChallenges = 0;
	if(level.leagueMatch || GetDvarInt("scr_disableChallenges") > 0)
	{
		level.disableChallenges = 1;
	}
	level.disableStatTracking = GetDvarInt("scr_disableStatTracking") > 0;
	setup_callbacks();
	clientfield::register("playercorpse", "firefly_effect", 1, 2, "int");
	clientfield::register("playercorpse", "annihilate_effect", 1, 1, "int");
	clientfield::register("playercorpse", "pineapplegun_effect", 1, 1, "int");
	clientfield::register("actor", "annihilate_effect", 1, 1, "int");
	clientfield::register("actor", "pineapplegun_effect", 1, 1, "int");
	clientfield::register("world", "game_ended", 1, 1, "int");
	clientfield::register("world", "post_game", 1, 1, "int");
	clientfield::register("world", "displayTop3Players", 1, 1, "int");
	clientfield::register("world", "triggerScoreboardCamera", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.hideOutcomeUI", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.remoteKillstreakActivated", 1, 1, "int");
	clientfield::register("world", "playTop0Gesture", 1000, 3, "int");
	clientfield::register("world", "playTop1Gesture", 1000, 3, "int");
	clientfield::register("world", "playTop2Gesture", 1000, 3, "int");
	clientfield::register("clientuimodel", "hudItems.captureCrateState", 5000, 2, "int");
	clientfield::register("clientuimodel", "hudItems.captureCrateTotalTime", 5000, 13, "int");
	level.playersDrivingVehiclesBecomeInvulnerable = 0;
	level.figure_out_attacker = &globallogic_player::figure_out_attacker;
	level.figure_out_friendly_fire = &globallogic_player::figure_out_friendly_fire;
	level.get_base_weapon_param = &weapon_utils::getBaseWeaponParam;
}

function registerDvars()
{
	if(GetDvarString("ui_guncycle") == "")
	{
		SetDvar("ui_guncycle", 0);
	}
	if(GetDvarString("ui_weapon_tiers") == "")
	{
		SetDvar("ui_weapon_tiers", 0);
	}
	SetDvar("ui_text_endreason", "");
	SetMatchFlag("bomb_timer", 0);
	if(GetDvarString("scr_vehicle_damage_scalar") == "")
	{
		SetDvar("scr_vehicle_damage_scalar", "1");
	}
	level.vehicleDamageScalar = GetDvarFloat("scr_vehicle_damage_scalar");
	level.fire_audio_repeat_duration = GetDvarInt("fire_audio_repeat_duration");
	level.fire_audio_random_max_duration = GetDvarInt("fire_audio_random_max_duration");
	teamName = getcustomteamname(level.teamIndex["allies"]);
	if(isdefined(teamName))
	{
		SetDvar("g_customTeamName_Allies", teamName);
	}
	else
	{
		SetDvar("g_customTeamName_Allies", "");
	}
	teamName = getcustomteamname(level.teamIndex["axis"]);
	if(isdefined(teamName))
	{
		SetDvar("g_customTeamName_Axis", teamName);
	}
	else
	{
		SetDvar("g_customTeamName_Axis", "");
	}
}

function blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
{
}

function setup_callbacks()
{
	level.spawnPlayer = &globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = &globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = &globallogic_spawn::spawnClient;
	level.spawnSpectator = &globallogic_spawn::spawnSpectator;
	level.spawnIntermission = &globallogic_spawn::spawnIntermission;
	level.scoreOnGivePlayerScore = &globallogic_score::givePlayerScore;
	level.onPlayerScore = &globallogic_score::default_onPlayerScore;
	level.onTeamScore = &globallogic_score::default_onTeamScore;
	level.waveSpawnTimer = &waveSpawnTimer;
	level.spawnMessage = &globallogic_spawn::default_spawnMessage;
	level.onSpawnPlayer = &blank;
	level.onSpawnPlayer = &Spawning::onSpawnPlayer;
	level.onSpawnSpectator = &globallogic_defaults::default_onSpawnSpectator;
	level.onSpawnIntermission = &globallogic_defaults::default_onSpawnIntermission;
	level.onRespawnDelay = &blank;
	level.onForfeit = &globallogic_defaults::default_onForfeit;
	level.onTimeLimit = &globallogic_defaults::default_onTimeLimit;
	level.onScoreLimit = &globallogic_defaults::default_onScoreLimit;
	level.onRoundScoreLimit = &globallogic_defaults::default_onRoundScoreLimit;
	level.onAliveCountChange = &globallogic_defaults::default_onAliveCountChange;
	level.onDeadEvent = undefined;
	level.onOneLeftEvent = &globallogic_defaults::default_onOneLeftEvent;
	level.giveTeamScore = &globallogic_score::giveTeamScore;
	level.onLastTeamAliveEvent = &globallogic_defaults::default_onLastTeamAliveEvent;
	level.getTimePassed = &globallogic_utils::getTimePassed;
	level.getTimeLimit = &globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = &globallogic_defaults::default_getTeamKillPenalty;
	level.getTeamKillScore = &globallogic_defaults::default_getTeamKillScore;
	level.isKillBoosting = &globallogic_score::default_isKillBoosting;
	level._setTeamScore = &globallogic_score::_setTeamScore;
	level._setPlayerScore = &globallogic_score::_setPlayerScore;
	level._getTeamScore = &globallogic_score::_getTeamScore;
	level._getPlayerScore = &globallogic_score::_getPlayerScore;
	level.resetPlayerScorestreaks = &globallogic_score::resetPlayerScoreChainAndMomentum;
	level.onPrecacheGameType = &blank;
	level.onStartGameType = &blank;
	level.onPlayerConnect = &blank;
	level.onPlayerDisconnect = &blank;
	level.onPlayerDamage = &blank;
	level.onPlayerKilled = &blank;
	level.onPlayerKilledExtraUnthreadedCBs = [];
	level.onTeamOutcomeNotify = &hud_message::teamOutcomeNotify;
	level.onOutcomeNotify = &hud_message::outcomeNotify;
	level.setMatchScoreHUDElemForTeam = &hud_message::setMatchScoreHUDElemForTeam;
	level.onEndGame = &blank;
	level.onRoundEndGame = &globallogic_defaults::default_onRoundEndGame;
	level.determineWinner = &globallogic_defaults::default_determineWinner;
	level.onMedalAwarded = &blank;
	level.dogManagerOnGetDogs = &dogs::dog_manager_get_dogs;
	callback::on_joined_team(&globallogic_player::on_joined_team);
	globallogic_ui::SetupCallbacks();
}

function precache_mp_friend_leaderboards()
{
	hardcoreMode = GetGametypeSetting("hardcoreMode");
	if(!isdefined(hardcoreMode))
	{
		hardcoreMode = 0;
	}
	arenaMode = IsArenaMode();
	postfix = "";
	if(hardcoreMode)
	{
		postfix = "_HC";
	}
	else if(arenaMode)
	{
		postfix = "_ARENA";
	}
	friendLeaderboardA = "LB_MP_FRIEND_A" + postfix;
	friendLeaderboardB = " LB_MP_FRIEND_B" + postfix;
	precacheLeaderboards(friendLeaderboardA + friendLeaderboardB);
}

function precache_mp_anticheat_leaderboards()
{
	hardcoreMode = GetGametypeSetting("hardcoreMode");
	if(!isdefined(hardcoreMode))
	{
		hardcoreMode = 0;
	}
	arenaMode = IsArenaMode();
	postfix = "";
	if(hardcoreMode)
	{
		postfix = "_HC";
	}
	else if(arenaMode)
	{
		postfix = "_ARENA";
	}
	anticheatLeaderboard = "LB_MP_ANTICHEAT_" + level.gametype + postfix;
	if(level.gametype != "fr")
	{
		anticheatLeaderboard = anticheatLeaderboard + " LB_MP_ANTICHEAT_GLOBAL";
	}
	precacheLeaderboards(anticheatLeaderboard);
}

function precache_mp_public_leaderboards()
{
	mapname = GetDvarString("mapname");
	hardcoreMode = GetGametypeSetting("hardcoreMode");
	if(!isdefined(hardcoreMode))
	{
		hardcoreMode = 0;
	}
	arenaMode = IsArenaMode();
	freerunMode = level.gametype == "fr";
	postfix = "";
	if(freerunMode)
	{
		frLeaderboard = " LB_MP_GM_FR_" + GetSubStr(mapname, 3, mapname.size);
		precacheLeaderboards(frLeaderboard);
		return;
	}
	else if(hardcoreMode)
	{
		postfix = "_HC";
	}
	else if(arenaMode)
	{
		postfix = "_ARENA";
	}
	careerLeaderboard = " LB_MP_GB_SCORE" + postfix;
	prestigeLB = " LB_MP_GB_XPPRESTIGE";
	gamemodeLeaderboard = "LB_MP_GM_" + level.gametype + postfix;
	arenaLeaderboard = "";
	if(GameModeIsMode(6))
	{
		arenaSlot = ArenaGetSlot();
		arenaLeaderboard = " LB_MP_ARENA_MASTERS_0" + arenaSlot;
	}
	precacheLeaderboards(gamemodeLeaderboard + careerLeaderboard + prestigeLB + arenaLeaderboard);
}

function precache_mp_custom_leaderboards()
{
	customLeaderboards = "LB_MP_CG_" + level.gametype;
	precacheLeaderboards("LB_MP_CG_GENERAL " + customLeaderboards);
	return;
}

function precache_mp_leaderboards()
{
	if(bot::is_bot_ranked_match())
	{
		return;
	}
	if(level.rankedMatch || level.gametype == "fr")
	{
		precache_mp_public_leaderboards();
		precache_mp_friend_leaderboards();
		precache_mp_anticheat_leaderboards();
	}
	else
	{
		precache_mp_custom_leaderboards();
	}
}

function setvisiblescoreboardcolumns(col1, col2, col3, col4, col5)
{
	if(!level.rankedMatch)
	{
		setscoreboardcolumns(col1, col2, col3, col4, col5, "sbtimeplayed", "shotshit", "shotsmissed", "victory");
	}
	else
	{
		setscoreboardcolumns(col1, col2, col3, col4, col5);
	}
}

function compareTeamByGameStat(gameStat, teamA, teamB, previous_winner_score)
{
	winner = undefined;
	if(teamA == "tie")
	{
		winner = "tie";
		if(previous_winner_score < game[gameStat][teamB])
		{
			winner = teamB;
		}
	}
	else if(game[gameStat][teamA] == game[gameStat][teamB])
	{
		winner = "tie";
	}
	else if(game[gameStat][teamB] > game[gameStat][teamA])
	{
		winner = teamB;
	}
	else
	{
		winner = teamA;
	}
	return winner;
}

function determineTeamWinnerByGameStat(gameStat)
{
	teamKeys = getArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = game[gameStat][winner];
	for(teamIndex = 1; teamIndex < teamKeys.size; teamIndex++)
	{
		winner = compareTeamByGameStat(gameStat, winner, teamKeys[teamIndex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = game[gameStat][winner];
		}
	}
	return winner;
}

function compareTeamByTeamScore(teamA, teamB, previous_winner_score)
{
	winner = undefined;
	teamBScore = [[level._getTeamScore]](teamB);
	if(teamA == "tie")
	{
		winner = "tie";
		if(previous_winner_score < teamBScore)
		{
			winner = teamB;
		}
		return winner;
	}
	teamAScore = [[level._getTeamScore]](teamA);
	if(teamBScore == teamAScore)
	{
		winner = "tie";
	}
	else if(teamBScore > teamAScore)
	{
		winner = teamB;
	}
	else
	{
		winner = teamA;
	}
	return winner;
}

function determineTeamWinnerByTeamScore()
{
	teamKeys = getArrayKeys(level.teams);
	winner = teamKeys[0];
	previous_winner_score = [[level._getTeamScore]](winner);
	for(teamIndex = 1; teamIndex < teamKeys.size; teamIndex++)
	{
		winner = compareTeamByTeamScore(winner, teamKeys[teamIndex], previous_winner_score);
		if(winner != "tie")
		{
			previous_winner_score = [[level._getTeamScore]](winner);
		}
	}
	return winner;
}

function forceEnd(hostsucks)
{
	if(!isdefined(hostsucks))
	{
		hostsucks = 0;
	}
	if(level.hostForcedEnd || level.forcedEnd)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("host ended game", winner);
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
			if(isdefined(winner))
			{
				print("Dev Block strings are not supported" + winner.name);
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
	}
	level.forcedEnd = 1;
	level.hostForcedEnd = 1;
	if(hostsucks)
	{
		endString = &"MP_HOST_SUCKS";
	}
	else if(level.Splitscreen)
	{
		endString = &"MP_ENDED_GAME";
	}
	else
	{
		endString = &"MP_HOST_ENDED_GAME";
	}
	SetMatchFlag("disableIngameMenu", 1);
	SetDvar("ui_text_endreason", endString);
	thread endGame(winner, endString);
}

function killserverPc()
{
	if(level.hostForcedEnd || level.forcedEnd)
	{
		return;
	}
	winner = undefined;
	if(level.teambased)
	{
		winner = determineTeamWinnerByGameStat("teamScores");
		globallogic_utils::logTeamWinString("host ended game", winner);
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
			if(isdefined(winner))
			{
				print("Dev Block strings are not supported" + winner.name);
			}
			else
			{
				print("Dev Block strings are not supported");
			}
		#/
	}
	level.forcedEnd = 1;
	level.hostForcedEnd = 1;
	level.killserver = 1;
	endString = &"MP_HOST_ENDED_GAME";
	/#
		println("Dev Block strings are not supported");
	#/
	thread endGame(winner, endString);
}

function atLeastTwoTeams()
{
	valid_count = 0;
	foreach(team in level.teams)
	{
		if(level.playerCount[team] != 0)
		{
			valid_count++;
		}
	}
	if(valid_count < 2)
	{
		return 0;
	}
	return 1;
}

function checkIfTeamForfeits(team)
{
	if(!game["everExisted"][team])
	{
		return 0;
	}
	if(level.playerCount[team] < 1 && util::totalPlayerCount() > 0)
	{
		return 1;
	}
	return 0;
}

function checkForForfeit()
{
	forfeit_count = 0;
	valid_team = undefined;
	foreach(team in level.teams)
	{
		if(checkIfTeamForfeits(team))
		{
			forfeit_count++;
			if(!level.multiTeam)
			{
				thread [[level.onForfeit]](team);
				return 1;
			}
			continue;
		}
		valid_team = team;
	}
	if(level.multiTeam && forfeit_count == level.teams.size - 1)
	{
		thread [[level.onForfeit]](valid_team);
		return 1;
	}
	return 0;
}

function doSpawnQueueUpdates()
{
	foreach(team in level.teams)
	{
		if(level.spawnQueueModified[team])
		{
			[[level.onAliveCountChange]](team);
		}
	}
}

function isTeamAllDead(team)
{
	return level.everExisted[team] && !level.aliveCount[team] && !level.playerLives[team];
}

function areAllTeamsDead()
{
	foreach(team in level.teams)
	{
		if(!isTeamAllDead(team))
		{
			return 0;
		}
	}
	return 1;
}

function getLastTeamAlive()
{
	count = 0;
	everExistedCount = 0;
	aliveTeam = undefined;
	foreach(team in level.teams)
	{
		if(level.everExisted[team])
		{
			if(!isTeamAllDead(team))
			{
				aliveTeam = team;
				count++;
			}
			everExistedCount++;
		}
	}
	if(everExistedCount > 1 && count == 1)
	{
		return aliveTeam;
	}
	return undefined;
}

function doDeadEventUpdates()
{
	if(level.teambased)
	{
		if(areAllTeamsDead())
		{
			[[level.onDeadEvent]]("all");
			return 1;
		}
		if(!isdefined(level.onDeadEvent))
		{
			lastTeamAlive = getLastTeamAlive();
			if(isdefined(lastTeamAlive))
			{
				[[level.onLastTeamAliveEvent]](lastTeamAlive);
				return 1;
			}
			
            // something broke here
		}
		foreach(team in level.teams)
		{
			if(isTeamAllDead(team))
			{
				[[level.onDeadEvent]](team);
				return 1;
			}
		}
	}
	else if(totalAliveCount() == 0 && totalPlayerLives() == 0 && level.maxPlayerCount > 1)
	{
		[[level.onDeadEvent]]("all");
		return 1;
	}
	return 0;
}

function isOnlyOneLeftAliveOnTeam(team)
{
	return level.lastAliveCount[team] > 1 && level.aliveCount[team] == 1 && level.playerLives[team] == 1;
}

function doOneLeftEventUpdates()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(isOnlyOneLeftAliveOnTeam(team))
			{
				[[level.onOneLeftEvent]](team);
				return 1;
			}
		}
	}
	else if(totalAliveCount() == 1 && totalPlayerLives() == 1 && level.maxPlayerCount > 1)
	{
		[[level.onOneLeftEvent]]("all");
		return 1;
	}
	return 0;
}

function updateGameEvents()
{
	if(level.rankedMatch || level.wagerMatch || level.leagueMatch && !level.inGracePeriod)
	{
		if(level.teambased)
		{
			if(!level.gameForfeited)
			{
				if(game["state"] == "playing" && checkForForfeit())
				{
					return;
				}
			}
			else if(atLeastTwoTeams())
			{
				level.gameForfeited = 0;
				level notify("abort forfeit");
			}
		}
		else if(!level.gameForfeited)
		{
			if(util::totalPlayerCount() == 1 && level.maxPlayerCount > 1)
			{
				thread [[level.onForfeit]]();
				return;
			}
		}
		else if(util::totalPlayerCount() > 1)
		{
			level.gameForfeited = 0;
			level notify("abort forfeit");
		}
	}
	if(!level.playerQueuedRespawn && !level.numLives && !level.inOvertime)
	{
		return;
	}
	if(level.inGracePeriod)
	{
		return;
	}
	if(level.playerQueuedRespawn)
	{
		doSpawnQueueUpdates();
	}
	if(doDeadEventUpdates())
	{
		return;
	}
	if(doOneLeftEventUpdates())
	{
		return;
	}
}

function mpintro_visionset_ramp_hold_func()
{
	level endon("hash_53a1c116");
	while(1)
	{
		for(player_index = 0; player_index < level.players.size; player_index++)
		{
			self visionset_mgr::set_state_active(level.players[player_index], 1);
		}
		wait(0.05);
	}
}

function mpintro_visionset_activate_func()
{
	visionset_mgr::activate("visionset", "mpintro", undefined, 0, &mpintro_visionset_ramp_hold_func, 2);
}

function mpintro_visionset_deactivate_func()
{
	level notify("hash_53a1c116");
}

function matchStartTimer()
{
	mpintro_visionset_activate_func();
	level thread sndSetMatchSnapshot(1);
	waitForPlayers();
	countTime = Int(level.prematchPeriod);
	if(countTime >= 2)
	{
		while(countTime > 0 && !level.gameEnded)
		{
			LUINotifyEvent(&"create_prematch_timer", 1, GetTime() + countTime * 1000);
			if(countTime == 2)
			{
				mpintro_visionset_deactivate_func();
			}
			if(countTime == 3)
			{
				level thread sndSetMatchSnapshot(0);
				foreach(player in level.players)
				{
					if(player.hasSpawned || player.pers["team"] == "spectator")
					{
						player globallogic_audio::set_music_on_player("spawnPreRise");
					}
				}
			}
			countTime--;
			foreach(player in level.players)
			{
				player playlocalsound("uin_start_count_down");
			}
			wait(1);
		}
		LUINotifyEvent(&"prematch_timer_ended", 0);
	}
	else
	{
		mpintro_visionset_deactivate_func();
	}
}

function notifyEndOfGameplay()
{
	level waittill("game_ended");
	level clientfield::set("gameplay_started", 0);
}

function matchStartTimerSkip()
{
	visionSetNaked(GetDvarString("mapname"), 0);
}

function sndSetMatchSnapshot(num)
{
	wait(0.05);
	level clientfield::set("sndMatchSnapshot", num);
}

function notifyTeamWaveSpawn(team, time)
{
	if(time - level.lastWave[team] > level.waveDelay[team] * 1000)
	{
		level notify("wave_respawn_" + team);
		level.lastWave[team] = time;
		level.wavePlayerSpawnIndex[team] = 0;
	}
}

function waveSpawnTimer()
{
	level endon("game_ended");
	while(game["state"] == "playing")
	{
		time = GetTime();
		foreach(team in level.teams)
		{
			notifyTeamWaveSpawn(team, time);
		}
		wait(0.05);
	}
}

function hostIdledOut()
{
	hostPlayer = util::getHostPlayer();
	if(isdefined(hostPlayer) && !hostPlayer.hasSpawned && !isdefined(hostPlayer.selectedClass))
	{
		return 1;
	}
	return 0;
}

function IncrementMatchCompletionStat(gamemode, playedOrHosted, stat)
{
	self AddDStat("gameHistory", gamemode, "modeHistory", playedOrHosted, stat, 1);
}

function SetMatchCompletionStat(gamemode, playedOrHosted, stat)
{
	self SetDStat("gameHistory", gamemode, "modeHistory", playedOrHosted, stat, 1);
}

function getTeamScoreRatio()
{
	playerteam = self.pers["team"];
	score = getTeamScore(playerteam);
	otherTeamScore = 0;
	foreach(team in level.teams)
	{
		if(team == playerteam)
		{
			continue;
		}
		otherTeamScore = otherTeamScore + getTeamScore(team);
	}
	if(level.teams.size > 1)
	{
		otherTeamScore = otherTeamScore / level.teams.size - 1;
	}
	if(otherTeamScore != 0)
	{
		return float(score) / float(otherTeamScore);
	}
	return score;
}

function getHighestScore()
{
	highestScore = -999999999;
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player.score > highestScore)
		{
			highestScore = player.score;
		}
	}
	return highestScore;
}

function getNextHighestScore(score)
{
	highestScore = -999999999;
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player.score >= score)
		{
			continue;
		}
		if(player.score > highestScore)
		{
			highestScore = player.score;
		}
	}
	return highestScore;
}

function RecordPlayStyleInformation()
{
	avgKillDistance = 0;
	percentTimeMoving = 0;
	avgSpeedOfPlayerWhenMoving = 0;
	totalKillDistances = float(self.pers["kill_distances"]);
	numKillDistanceEntries = float(self.pers["num_kill_distance_entries"]);
	timePlayedMoving = float(self.pers["time_played_moving"]);
	timePlayedAlive = float(self.pers["time_played_alive"]);
	totalSpeedsWhenMoving = float(self.pers["total_speeds_when_moving"]);
	numSpeedsWhenMovingEntries = float(self.pers["num_speeds_when_moving_entries"]);
	totalDistanceTravelled = float(self.pers["total_distance_travelled"]);
	movementUpdateCount = float(self.pers["movement_Update_Count"]);
	if(numKillDistanceEntries > 0)
	{
		avgKillDistance = totalKillDistances / numKillDistanceEntries;
	}
	movementUpdateDenom = Int(movementUpdateCount / 5);
	if(movementUpdateDenom > 0)
	{
		percentTimeMoving = numSpeedsWhenMovingEntries / movementUpdateDenom * 100;
	}
	if(numSpeedsWhenMovingEntries > 0)
	{
		avgSpeedOfPlayerWhenMoving = totalSpeedsWhenMoving / numSpeedsWhenMovingEntries;
	}
	recordPlayerStats(self, "totalKillDistances", totalKillDistances);
	recordPlayerStats(self, "numKillDistanceEntries", numKillDistanceEntries);
	recordPlayerStats(self, "timePlayedMoving", timePlayedMoving);
	recordPlayerStats(self, "timePlayedAlive", timePlayedAlive);
	recordPlayerStats(self, "totalSpeedsWhenMoving", totalSpeedsWhenMoving);
	recordPlayerStats(self, "numSpeedsWhenMovingEntries", numSpeedsWhenMovingEntries);
	recordPlayerStats(self, "averageKillDistance", avgKillDistance);
	recordPlayerStats(self, "percentageOfTimeMoving", percentTimeMoving);
	recordPlayerStats(self, "averageSpeedDuringMatch", avgSpeedOfPlayerWhenMoving);
	recordPlayerStats(self, "totalDistanceTravelled", totalDistanceTravelled);
}

function getPlayerByName(name)
{
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player util::is_bot())
		{
			continue;
		}
		if(player.name == name)
		{
			return player;
		}
	}
}

function sendAfterActionReport()
{
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if(player util::is_bot())
		{
			continue;
		}
		Nemesis = player.pers["nemesis_name"];
		if(!isdefined(player.pers["killed_players"][Nemesis]))
		{
			player.pers["killed_players"][Nemesis] = 0;
		}
		if(!isdefined(player.pers["killed_by"][Nemesis]))
		{
			player.pers["killed_by"][Nemesis] = 0;
		}
		spread = player.kills - player.deaths;
		if(player.pers["cur_kill_streak"] > player.pers["best_kill_streak"])
		{
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
		}
		if(level.rankedMatch || level.leagueMatch)
		{
			player persistence::set_after_action_report_stat("privateMatch", 0);
		}
		else
		{
			player persistence::set_after_action_report_stat("privateMatch", 1);
		}
		player setNemesisXuid(player.pers["nemesis_xuid"]);
		player persistence::set_after_action_report_stat("nemesisName", Nemesis);
		player persistence::set_after_action_report_stat("nemesisRank", player.pers["nemesis_rank"]);
		player persistence::set_after_action_report_stat("nemesisRankIcon", player.pers["nemesis_rankIcon"]);
		player persistence::set_after_action_report_stat("nemesisKills", player.pers["killed_players"][Nemesis]);
		player persistence::set_after_action_report_stat("nemesisKilledBy", player.pers["killed_by"][Nemesis]);
		nemesisPlayerEnt = getPlayerByName(Nemesis);
		if(isdefined(nemesisPlayerEnt))
		{
			player persistence::set_after_action_report_stat("nemesisHeroIndex", nemesisPlayerEnt GetCharacterBodyType());
		}
		player persistence::set_after_action_report_stat("bestKillstreak", player.pers["best_kill_streak"]);
		player persistence::set_after_action_report_stat("kills", player.kills);
		player persistence::set_after_action_report_stat("deaths", player.deaths);
		player persistence::set_after_action_report_stat("headshots", player.headshots);
		player persistence::set_after_action_report_stat("score", player.score);
		player persistence::set_after_action_report_stat("xpEarned", Int(player.pers["summary"]["xp"]));
		player persistence::set_after_action_report_stat("cpEarned", Int(player.pers["summary"]["codpoints"]));
		player persistence::set_after_action_report_stat("miscBonus", Int(player.pers["summary"]["challenge"] + player.pers["summary"]["misc"]));
		player persistence::set_after_action_report_stat("matchBonus", Int(player.pers["summary"]["match"]));
		player persistence::set_after_action_report_stat("demoFileID", getDemoFileID());
		player persistence::set_after_action_report_stat("leagueTeamID", player getLeagueTeamID());
		player persistence::set_after_action_report_stat("team", teams::getTeamIndex(player.team));
		alliesScore = globallogic_score::_getTeamScore("allies");
		if(isdefined(alliesScore))
		{
			player persistence::set_after_action_report_stat("alliesScore", alliesScore);
		}
		axisScore = globallogic_score::_getTeamScore("axis");
		if(isdefined(axisScore))
		{
			player persistence::set_after_action_report_stat("axisScore", axisScore);
		}
		player persistence::set_after_action_report_stat("gameTypeRef", level.gametype);
		player persistence::set_after_action_report_stat("mapname", GetDvarString("ui_mapname"));
	}
}

function UpdateAndFinalizeMatchRecord()
{
	for(index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		player globallogic_player::record_special_move_data_for_life(undefined);
		if(player util::is_bot())
		{
			continue;
		}
		player globallogic_player::record_global_mp_stats_for_player_at_match_end();
		Nemesis = player.pers["nemesis_name"];
		if(!isdefined(player.pers["killed_players"][Nemesis]))
		{
			player.pers["killed_players"][Nemesis] = 0;
		}
		if(!isdefined(player.pers["killed_by"][Nemesis]))
		{
			player.pers["killed_by"][Nemesis] = 0;
		}
		spread = player.kills - player.deaths;
		if(player.pers["cur_kill_streak"] > player.pers["best_kill_streak"])
		{
			player.pers["best_kill_streak"] = player.pers["cur_kill_streak"];
		}
		if(level.onlineGame)
		{
			teamScoreRatio = player getTeamScoreRatio();
			scoreboardPosition = getPlacementForPlayer(player);
			if(scoreboardPosition < 0)
			{
				scoreboardPosition = level.players.size;
			}
			player GameHistoryFinishMatch(4, player.kills, player.deaths, player.score, scoreboardPosition, teamScoreRatio);
			placement = level.placement["all"];
			for(otherPlayerIndex = 0; otherPlayerIndex < placement.size; otherPlayerIndex++)
			{
				if(level.placement["all"][otherPlayerIndex] == player)
				{
					recordPlayerStats(player, "position", otherPlayerIndex);
				}
			}
			if(isdefined(player.pers["matchesPlayedStatsTracked"]))
			{
				gamemode = util::GetCurrentGameMode();
				player IncrementMatchCompletionStat(gamemode, "played", "completed");
				if(isdefined(player.pers["matchesHostedStatsTracked"]))
				{
					player IncrementMatchCompletionStat(gamemode, "hosted", "completed");
					player.pers["matchesHostedStatsTracked"] = undefined;
				}
				player.pers["matchesPlayedStatsTracked"] = undefined;
			}
			recordPlayerStats(player, "highestKillStreak", player.pers["best_kill_streak"]);
			recordPlayerStats(player, "numUavCalled", player killstreaks::get_killstreak_usage("uav_used"));
			recordPlayerStats(player, "numDogsCalleD", player killstreaks::get_killstreak_usage("dogs_used"));
			recordPlayerStats(player, "numDogsKills", player.pers["dog_kills"]);
			player RecordPlayStyleInformation();
			recordPlayerMatchEnd(player);
			recordPlayerStats(player, "presentAtEnd", 1);
		}
	}
	finalizeMatchRecord();
}

function gameHistoryPlayerKicked()
{
	teamScoreRatio = self getTeamScoreRatio();
	scoreboardPosition = getPlacementForPlayer(self);
	if(scoreboardPosition < 0)
	{
		scoreboardPosition = level.players.size;
	}
	/#
		Assert(isdefined(self.kills));
	#/
	/#
		Assert(isdefined(self.deaths));
	#/
	/#
		Assert(isdefined(self.score));
	#/
	/#
		Assert(isdefined(scoreboardPosition));
	#/
	/#
		Assert(isdefined(teamScoreRatio));
	#/
	self GameHistoryFinishMatch(2, self.kills, self.deaths, self.score, scoreboardPosition, teamScoreRatio);
	if(isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::GetCurrentGameMode();
		self IncrementMatchCompletionStat(gamemode, "played", "kicked");
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	UploadStats(self);
	wait(1);
}

function gameHistoryPlayerQuit()
{
	teamScoreRatio = self getTeamScoreRatio();
	scoreboardPosition = getPlacementForPlayer(self);
	if(scoreboardPosition < 0)
	{
		scoreboardPosition = level.players.size;
	}
	self GameHistoryFinishMatch(3, self.kills, self.deaths, self.score, scoreboardPosition, teamScoreRatio);
	if(isdefined(self.pers["matchesPlayedStatsTracked"]))
	{
		gamemode = util::GetCurrentGameMode();
		self IncrementMatchCompletionStat(gamemode, "played", "quit");
		if(isdefined(self.pers["matchesHostedStatsTracked"]))
		{
			self IncrementMatchCompletionStat(gamemode, "hosted", "quit");
			self.pers["matchesHostedStatsTracked"] = undefined;
		}
		self.pers["matchesPlayedStatsTracked"] = undefined;
	}
	UploadStats(self);
	if(!self IsHost())
	{
		wait(1);
	}
}

function displayRoundEnd(winner, endReasonText)
{
	if(level.displayRoundEndText)
	{
		if(level.teambased)
		{
			if(winner == "tie")
			{
				demo::gameResultBookmark("round_result", level.teamIndex["neutral"], level.teamIndex["neutral"]);
			}
			else
			{
				demo::gameResultBookmark("round_result", level.teamIndex[winner], level.teamIndex["neutral"]);
			}
		}
		SetMatchFlag("cg_drawSpectatorMessages", 0);
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			if(!util::wasLastRound())
			{
				player notify("round_ended");
			}
			if(!isdefined(player.pers["team"]))
			{
				player [[level.spawnIntermission]](1);
				continue;
			}
			if(level.teambased)
			{
				player thread [[level.onTeamOutcomeNotify]](winner, "roundend", endReasonText);
				player globallogic_audio::set_music_on_player("roundEnd");
			}
			else
			{
				player thread [[level.onOutcomeNotify]](winner, 1, endReasonText);
				player globallogic_audio::set_music_on_player("roundEnd");
			}
			player setClientUIVisibilityFlag("hud_visible", 0);
			player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
		}
	}
	else if(util::wasLastRound())
	{
		roundEndWait(level.roundEndDelay, 0);
	}
	else
	{
		thread globallogic_audio::announce_round_winner(winner, level.roundEndDelay / 4);
		roundEndWait(level.roundEndDelay, 1);
	}
}

function displayRoundSwitch(winner, endReasonText)
{
	switchType = level.halftimeType;
	level thread globallogic_audio::set_music_global("roundSwitch");
	if(switchType == "halftime")
	{
		if(isdefined(level.nextRoundIsOvertime) && level.nextRoundIsOvertime)
		{
			switchType = "overtime";
		}
		else if(level.roundLimit)
		{
			if(game["roundsplayed"] * 2 == level.roundLimit)
			{
				switchType = "halftime";
			}
			else
			{
				switchType = "intermission";
			}
		}
		else if(level.scoreLimit)
		{
			if(isdefined(level.roundSwitch) && level.roundSwitch == 1)
			{
				switchType = "intermission";
			}
			else if(game["roundsplayed"] == level.scoreLimit - 1)
			{
				switchType = "halftime";
			}
			else
			{
				switchType = "intermission";
			}
		}
		else
		{
			switchType = "intermission";
		}
	}
	leaderDialog = globallogic_audio::get_round_switch_dialog(switchType);
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnIntermission]](1);
			continue;
		}
		player globallogic_audio::leader_dialog_on_player(leaderDialog);
		player thread [[level.onTeamOutcomeNotify]](winner, switchType, level.halftimeSubCaption);
		player setClientUIVisibilityFlag("hud_visible", 0);
	}
	roundEndWait(level.halftimeRoundEndDelay, 0);
}

function displayGameEnd(winner, endReasonText)
{
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	SetMatchFlag("cg_drawSpectatorMessages", 0);
	level thread sndSetMatchSnapshot(2);
	util::setClientSysState("levelNotify", "streamFKsl");
	if(level.teambased)
	{
		if(winner == "tie")
		{
			demo::gameResultBookmark("game_result", level.teamIndex["neutral"], level.teamIndex["neutral"]);
		}
		else
		{
			demo::gameResultBookmark("game_result", level.teamIndex[winner], level.teamIndex["neutral"]);
		}
	}
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(!isdefined(player.pers["team"]))
		{
			player [[level.spawnIntermission]](1);
			continue;
		}
		if(level.teambased)
		{
			player thread [[level.onTeamOutcomeNotify]](winner, "gameend", endReasonText);
		}
		else if(!(isdefined(level.Freerun) && level.Freerun))
		{
			player thread [[level.onOutcomeNotify]](winner, 0, endReasonText);
		}
		if(isdefined(level.Freerun) && level.Freerun)
		{
			player globallogic_audio::set_music_on_player("mp_freerun_gameover");
		}
		else if(isdefined(winner) && player == winner)
		{
			player globallogic_audio::set_music_on_player("matchWin");
		}
		else if(!level.Splitscreen)
		{
			player globallogic_audio::set_music_on_player("matchLose");
		}
		player setClientUIVisibilityFlag("hud_visible", 0);
		player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
	}
	thread globallogic_audio::announce_game_winner(winner);
	if(level.teambased)
	{
		players = level.players;
		for(index = 0; index < players.size; index++)
		{
			player = players[index];
			team = player.pers["team"];
			if(level.Splitscreen)
			{
				if(isdefined(level.Freerun) && level.Freerun)
				{
					player globallogic_audio::set_music_on_player("mp_freerun_gameover");
				}
				else if(winner == "tie")
				{
					player globallogic_audio::set_music_on_player("matchDraw");
				}
				else if(winner == team)
				{
					player globallogic_audio::set_music_on_player("matchWin");
				}
				else
				{
					player globallogic_audio::set_music_on_player("matchLose");
				}
				continue;
			}
			if(isdefined(level.Freerun) && level.Freerun)
			{
				player globallogic_audio::set_music_on_player("mp_freerun_gameover");
				continue;
			}
			if(winner == "tie")
			{
				player globallogic_audio::set_music_on_player("matchDraw");
				continue;
			}
			if(winner == team)
			{
				player globallogic_audio::set_music_on_player("matchWin");
				continue;
			}
			player globallogic_audio::set_music_on_player("matchLose");
		}
	}
	roundEndWait(level.postRoundTime, 1);
}

function recordEndGameComScoreEvent(result)
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		globallogic_player::recordEndGameComScoreEventForPlayer(players[index], result);
	}
}

function getEndReasonText()
{
	if(isdefined(level.endReasonText))
	{
		return level.endReasonText;
	}
	if(util::hitRoundLimit() || util::hitRoundWinLimit())
	{
		return game["strings"]["round_limit_reached"];
	}
	else if(util::hitScoreLimit())
	{
		return game["strings"]["score_limit_reached"];
	}
	else if(util::hitRoundScoreLimit())
	{
		return game["strings"]["round_score_limit_reached"];
	}
	if(level.forcedEnd)
	{
		if(level.hostForcedEnd)
		{
			return &"MP_HOST_ENDED_GAME";
		}
		else
		{
			return &"MP_ENDED_GAME";
		}
	}
	return game["strings"]["time_limit_reached"];
}

function resetOutcomeForAllPlayers()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player notify("reset_outcome");
	}
}

function hideOutcomeUIForAllPlayers()
{
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player clientfield::set_player_uimodel("hudItems.hideOutcomeUI", 1);
	}
}

function startNextRound(winner, endReasonText)
{
	if(!util::isOneRound())
	{
		displayRoundEnd(winner, endReasonText);
		globallogic_utils::executePostRoundEvents();
		if(!util::wasLastRound())
		{
			if(checkRoundSwitch())
			{
				if(level.scoreRoundWinBased)
				{
					foreach(team in level.teams)
					{
						[[level._setTeamScore]](team, game["roundswon"][team]);
					}
				}
				displayRoundSwitch(winner, endReasonText);
			}
			if(isdefined(level.nextRoundIsOvertime) && level.nextRoundIsOvertime)
			{
				if(!isdefined(game["overtime_round"]))
				{
					game["overtime_round"] = 1;
				}
				else
				{
					game["overtime_round"]++;
				}
			}
			SetMatchTalkFlag("DeadChatWithDead", level.voip.deadChatWithDead);
			SetMatchTalkFlag("DeadChatWithTeam", level.voip.deadChatWithTeam);
			SetMatchTalkFlag("DeadHearTeamLiving", level.voip.deadHearTeamLiving);
			SetMatchTalkFlag("DeadHearAllLiving", level.voip.deadHearAllLiving);
			SetMatchTalkFlag("EveryoneHearsEveryone", level.voip.everyoneHearsEveryone);
			SetMatchTalkFlag("DeadHearKiller", level.voip.deadHearKiller);
			SetMatchTalkFlag("KillersHearVictim", level.voip.killersHearVictim);
			game["state"] = "playing";
			map_restart(1);
			hideOutcomeUIForAllPlayers();
			return 1;
		}
	}
	return 0;
}

function setTopPlayerStats()
{
	if(level.rankedMatch)
	{
		placement = level.placement["all"];
		topThreePlayers = min(3, placement.size);
		for(index = 0; index < topThreePlayers; index++)
		{
			if(level.placement["all"][index].score)
			{
				if(!index)
				{
					level.placement["all"][index] AddPlayerStatWithGameType("TOPPLAYER", 1);
					level.placement["all"][index] notify("topplayer");
				}
				else
				{
					level.placement["all"][index] notify("nottopplayer");
				}
				level.placement["all"][index] AddPlayerStatWithGameType("TOP3", 1);
				level.placement["all"][index] AddPlayerStat("TOP3ANY", 1);
				if(level.hardcoreMode)
				{
					level.placement["all"][index] AddPlayerStat("TOP3ANY_HC", 1);
				}
				if(level.multiTeam)
				{
					level.placement["all"][index] AddPlayerStat("TOP3ANY_MULTITEAM", 1);
				}
				level.placement["all"][index] notify("top3");
			}
		}
		for(index = 3; index < placement.size; index++)
		{
			level.placement["all"][index] notify("nottop3");
			level.placement["all"][index] notify("nottopplayer");
		}
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				setTopTeamStats(team);
			}
		}
	}
}

function setTopTeamStats(team)
{
	placementTeam = level.placement[team];
	topThreeTeamPlayers = min(3, placementTeam.size);
	if(placementTeam.size < 5)
	{
		return;
	}
	for(index = 0; index < topThreeTeamPlayers; index++)
	{
		if(placementTeam[index].score)
		{
			placementTeam[index] AddPlayerStat("TOP3TEAM", 1);
			placementTeam[index] AddPlayerStat("TOP3ANY", 1);
			if(level.hardcoreMode)
			{
				placementTeam[index] AddPlayerStat("TOP3ANY_HC", 1);
			}
			if(level.multiTeam)
			{
				placementTeam[index] AddPlayerStat("TOP3ANY_MULTITEAM", 1);
			}
			placementTeam[index] AddPlayerStatWithGameType("TOP3TEAM", 1);
		}
	}
}

function figureOutWinningTeam(winner)
{
	if(!isdefined(winner))
	{
		return "tie";
	}
	if(IsEntity(winner))
	{
		if(isdefined(winner.team))
		{
		}
		else
		{
		}
		return "none";
	}
	return winner;
}

function getRoundLength()
{
	if(!level.timelimit || level.forcedEnd)
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;
		gameLength = min(gameLength, 1200);
	}
	else
	{
		gameLength = level.timelimit * 60;
	}
	return gameLength;
}

function awardLootXP()
{
	if(!GetDvarInt("loot_enabled"))
	{
		return;
	}
	var_bd5aeea2 = game["playabletimepassed"] / 1000;
	timePlayed = self getTotalTimePlayed(var_bd5aeea2);
	var_eddf01d9 = 0;
	if(self.pers["participation"] >= 1)
	{
		var_ffe3ec55 = Int(GetDvarInt("loot_cryptokeyCost", 100));
		var_b7c108f6 = Int(GetDvarInt("loot_earnTime", 267));
		var_8a953dea = Int(GetDvarInt("loot_earnPlayThreshold", 10));
		var_730f8a63 = Int(GetDvarInt("loot_earnMax", 10000));
		var_f3830871 = Int(GetDvarInt("loot_earnMin", 0));
		var_da64c2d4 = Int(GetDvarInt("loot_winBonusPercent", 30));
		if(var_bd5aeea2 > 0 && timePlayed > var_8a953dea)
		{
			if(level.arenaMatch)
			{
				draftEnabled = GetGametypeSetting("pregameDraftEnabled") == 1;
				voteEnabled = GetGametypeSetting("pregameItemVoteEnabled") == 1;
				if(draftEnabled && voteEnabled)
				{
					var_8e67772e = GetDvarInt("arena_minPregameCryptoSeconds", 0);
					var_20ef98d0 = GetDvarInt("arena_maxPregameCryptoSeconds", 0);
					if(var_20ef98d0 > 0 && var_8e67772e >= 0 && var_8e67772e <= var_20ef98d0)
					{
						var_54a04ab9 = randomIntRange(var_8e67772e, var_20ef98d0);
						timePlayed = timePlayed + var_54a04ab9;
					}
				}
			}
			var_a8df1c17 = timePlayed / var_b7c108f6;
			var_eddf01d9 = var_ffe3ec55 * var_a8df1c17;
			if(isdefined(self.lootXpMultiplier) && self.lootXpMultiplier == 1)
			{
				var_eddf01d9 = var_eddf01d9 + var_eddf01d9 * var_da64c2d4 / 100;
			}
			var_eddf01d9 = var_eddf01d9 * math::clamp(GetDvarFloat("lootxp_multiplier", 1), 0, 4);
			var_eddf01d9 = Int(var_eddf01d9);
			if(var_eddf01d9 > var_730f8a63)
			{
				var_eddf01d9 = var_730f8a63;
			}
			else if(var_eddf01d9 < var_f3830871)
			{
				var_eddf01d9 = var_f3830871;
			}
			var_8faf2ed5 = self awardOtherLootXP();
			var_eddf01d9 = var_eddf01d9 + var_8faf2ed5;
			if(var_eddf01d9 > 0)
			{
				self function_fac43b6c(1, var_eddf01d9);
			}
			if(var_8faf2ed5 > 0)
			{
				level thread WaitAndUploadStats(self, GetDvarFloat("src_other_lootxp_uploadstat_waittime", 1));
			}
		}
	}
	self setAARStat("lootXpEarned", var_eddf01d9);
	recordPlayerStats(self, "lootXpEarned", var_eddf01d9);
	recordPlayerStats(self, "lootTimePlayed", timePlayed);
}

function WaitAndUploadStats(player, waitTime)
{
	wait(waitTime);
	if(isPlayer(player))
	{
		UploadStats(player);
	}
}

function registerOtherLootXPAwards(func)
{
	if(!isdefined(level.awardOtherLootXPfunctions))
	{
		level.awardOtherLootXPfunctions = [];
	}
	if(!isdefined(level.awardOtherLootXPfunctions))
	{
		level.awardOtherLootXPfunctions = [];
	}
	else if(!IsArray(level.awardOtherLootXPfunctions))
	{
		level.awardOtherLootXPfunctions = Array(level.awardOtherLootXPfunctions);
	}
	level.awardOtherLootXPfunctions[level.awardOtherLootXPfunctions.size] = func;
}

function awardOtherLootXP()
{
	player = self;
	if(!isdefined(level.awardOtherLootXPfunctions))
	{
		return 0;
	}
	if(!isPlayer(player))
	{
		return 0;
	}
	lootXP = 0;
	foreach(func in level.awardOtherLootXPfunctions)
	{
		if(!isdefined(func))
		{
			continue;
		}
		lootXP = lootXP + player [[func]]();
	}
	return lootXP;
}

function endGame(winner, endReasonText)
{
	if(game["state"] == "postgame" || level.gameEnded)
	{
		return;
	}
	if(isdefined(level.onEndGame))
	{
		[[level.onEndGame]](winner);
	}
	if(!isdefined(level.disableOutroVisionSet) || level.disableOutroVisionSet == 0)
	{
		visionSetNaked("mpOutro", 2);
	}
	SetMatchFlag("cg_drawSpectatorMessages", 0);
	SetMatchFlag("game_ended", 1);
	game["state"] = "postgame";
	level.gameEndTime = GetTime();
	level.gameEnded = 1;
	SetDvar("g_gameEnded", 1);
	level.inGracePeriod = 0;
	level notify("game_ended");
	level clientfield::set("game_ended", 1);
	globallogic_audio::flush_dialog();
	foreach(team in level.teams)
	{
		game["lastroundscore"][team] = getTeamScore(team);
	}
	if(util::isRoundBased())
	{
		matchRecordRoundEnd();
	}
	winning_team = figureOutWinningTeam(winner);
	if(isdefined(game["overtime_round"]) && isdefined(game["overtimeroundswon"][winning_team]))
	{
		game["overtimeroundswon"][winning_team]++;
	}
	if(!isdefined(game["overtime_round"]) || util::wasLastRound())
	{
		game["roundsplayed"]++;
		game["roundwinner"][game["roundsplayed"]] = winner;
		if(isdefined(game["roundswon"][winning_team]))
		{
			game["roundswon"][winning_team]++;
		}
	}
	if(isdefined(winner) && isdefined(level.teams[winning_team]))
	{
		level.finalKillCam_winner = winner;
	}
	else
	{
		level.finalKillCam_winner = "none";
	}
	level.finalKillCam_winnerPicked = 1;
	setGameEndTime(0);
	updatePlacement();
	updateRankedMatch(winner);
	players = level.players;
	newTime = GetTime();
	roundlength = getRoundLength();
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	bbGameOver = 0;
	if(util::isOneRound() || util::wasLastRound())
	{
		bbGameOver = 1;
	}
	surveyId = 0;
	if(RandomFloat(1) <= GetDvarFloat("survey_chance"))
	{
		surveyId = randomIntRange(1, GetDvarInt("survey_count") + 1);
	}
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		if(player util::is_bot() || (!isdefined(player.var_4ba2b8f1) && !isdefined(player.pers["freeze_round_end"])))
		{
			player globallogic_player::freezePlayerForRoundEnd();
		}
		player thread roundEndDoF(4);
		player globallogic_ui::freeGameplayHudElems();
		player.pers["lastroundscore"] = player.pointstowin;
		player weapons::update_timings(newTime);
		if(bbGameOver)
		{
			player behaviorTracker::Finalize();
		}
		player bbPlayerMatchEnd(roundlength, endReasonText, bbGameOver);
		player.pers["totalTimePlayed"] = player.pers["totalTimePlayed"] + player.timePlayed["total"];
		if(bbGameOver)
		{
			if(level.leagueMatch)
			{
				player setAARStat("lobbyPopup", "leaguesummary");
			}
			else
			{
				player setAARStat("lobbyPopup", "summary");
			}
		}
		player setAARStat("surveyId", surveyId);
		player setAARStat("hardcore", level.hardcoreMode);
	}
	gamerep::gameRepUpdateInformationForRound();
	thread challenges::roundEnd(winner);
	game_winner = winner;
	if(!util::isOneRound())
	{
		game_winner = [[level.determineWinner]](winner);
	}
	update_top_scorers(game_winner);
	if(startNextRound(winner, endReasonText))
	{
		return;
	}
	if(!util::isOneRound())
	{
		if(isdefined(level.onRoundEndGame))
		{
			winner = [[level.onRoundEndGame]](winner);
		}
		endReasonText = getEndReasonText();
	}
	globallogic_score::updateWinLossStats(winner);
	if(level.rankedMatch || level.arenaMatch)
	{
		thread awardLootXPToPlayers(3, players);
	}
	if(level.arenaMatch)
	{
		arena::match_end(winner);
	}
	result = "";
	if(level.teambased)
	{
		if(winner == "tie")
		{
			result = "draw";
		}
		else
		{
			result = winner;
		}
	}
	else if(!isdefined(winner))
	{
		result = "draw";
	}
	else
	{
		result = winner.team;
	}
	recordGameResult(result);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player globallogic_player::record_misc_player_stats();
	}
	skillUpdate(winner, level.teambased);
	recordLeagueWinner(winner);
	setTopPlayerStats();
	thread challenges::gameEnd(winner);
	UpdateAndFinalizeMatchRecord();
	recordEndGameComScoreEvent(result);
	level.finalGameEnd = 1;
	if(!isdefined(level.skipGameEnd) || !level.skipGameEnd)
	{
		displayGameEnd(winner, endReasonText);
	}
	level.finalGameEnd = undefined;
	if(util::isOneRound())
	{
		globallogic_utils::executePostRoundEvents();
	}
	level.intermission = 1;
	gamerep::gameRepAnalyzeAndReport();
	util::setClientSysState("levelNotify", "fkcs");
	if(persistence::can_set_aar_stat())
	{
		thread sendAfterActionReport();
	}
	stopdemorecording();
	SetMatchTalkFlag("EveryoneHearsEveryone", 1);
	players = level.players;
	for(index = 0; index < players.size; index++)
	{
		player = players[index];
		player notify("reset_outcome", level.inFinalKillcam);
		player thread [[level.spawnIntermission]](0, level.useXCamsForEndGame);
		player setClientUIVisibilityFlag("hud_visible", 1);
	}
	level clientfield::set("post_game", 1);
	doEndGameSequence();
	if(isdefined(level.endGameFunction))
	{
		level thread [[level.endGameFunction]]();
	}
	level notify("sfade");
	/#
		print("Dev Block strings are not supported");
	#/
	if(!isdefined(level.skipGameEnd) || !level.skipGameEnd)
	{
		wait(5);
	}
	if(isdefined(level.end_game_video))
	{
		level thread LUI::play_movie(level.end_game_video.name, "fullscreen", 1);
		wait(level.end_game_video.duration + 4.5);
	}
	exit_level();
}

function awardLootXPToPlayers(delay, players)
{
	wait(delay);
	foreach(player in players)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player awardLootXP();
	}
}

function exit_level()
{
	if(level.exitLevel)
	{
		return;
	}
	level.exitLevel = 1;
	exitLevel(0);
}

function update_top_scorers(winner)
{
	topscorers = [];
	winning_team = figureOutWinningTeam(winner);
	if(level.teambased && isdefined(winner) && isdefined(level.placement[winning_team]))
	{
		topscorers = level.placement[winning_team];
	}
	else
	{
		topscorers = level.placement["all"];
	}
	if(topscorers.size)
	{
		level.doTopScorers = 1;
	}
	else
	{
		level.doTopScorers = 0;
	}
	ClearTopScorers();
	for(i = 0; i < 3 && i < topscorers.size; i++)
	{
		player = topscorers[i];
		player thread checkForGestures(i);
		showcase_weapon = player weapons::showcaseweapon_get();
		tauntIndex = player GetPlayerSelectedTaunt(0);
		gesture0Index = player GetPlayerSelectedGesture(0);
		gesture1Index = player GetPlayerSelectedGesture(1);
		gesture2Index = player GetPlayerSelectedGesture(2);
		if(!isdefined(showcase_weapon))
		{
			SetTopScorer(i, player, tauntIndex, gesture0Index, gesture1Index, gesture2Index, GetWeapon("ar_standard"));
			continue;
		}
		SetTopScorer(i, player, tauntIndex, gesture0Index, gesture1Index, gesture2Index, showcase_weapon["weapon"], showcase_weapon["options"], showcase_weapon["acvi"]);
	}
}

function checkForGestures(topPlayerIndex)
{
	self endon("disconnect");
	fieldName = "playTop" + topPlayerIndex + "Gesture";
	level clientfield::set(fieldName, 7);
	wait(0.05);
	while(1)
	{
		if(self ActionSlotOneButtonPressed())
		{
			self setGestureClientField(fieldName, 0);
		}
		else if(self ActionSlotThreeButtonPressed())
		{
			self setGestureClientField(fieldName, 1);
		}
		else if(self ActionSlotFourButtonPressed())
		{
			self setGestureClientField(fieldName, 2);
		}
		wait(0.05);
	}
}

function setGestureClientField(fieldName, gestureType)
{
	self notify("setGestureClientField");
	self endon("setGestureClientField");
	level clientfield::set(fieldName, gestureType);
	wait(0.05);
	level clientfield::set(fieldName, 7);
}

function doEndGameSequence()
{
	level notify("endgame_sequence");
	preloadingEnabled = GetDvarInt("sv_mapSwitchPreloadFrontend", 0);
	if(level.doTopScorers && isdefined(struct::get("endgame_top_players_struct", "targetname")))
	{
		SetMatchFlag("enable_popups", 1);
		ClearPlayerCorpses();
		level thread sndSetMatchSnapshot(3);
		level thread globallogic_audio::set_music_global("endmatch");
		level clientfield::set("displayTop3Players", 1);
		if(preloadingEnabled)
		{
			SwitchMap_Preload("core_frontend");
		}
		wait(15);
		level clientfield::set("triggerScoreboardCamera", 1);
		wait(5);
		SetMatchFlag("enable_popups", 0);
	}
	else if(level.doEndgameScoreboard)
	{
		if(preloadingEnabled)
		{
			SwitchMap_Preload("core_frontend");
		}
		LUINotifyEvent(&"force_scoreboard", 0);
	}
}

function getTotalTimePlayed(maxLength)
{
	totalTimePlayed = 0;
	if(isdefined(self.pers["totalTimePlayed"]))
	{
		totalTimePlayed = self.pers["totalTimePlayed"];
		if(totalTimePlayed > maxLength)
		{
			totalTimePlayed = maxLength;
		}
	}
	return totalTimePlayed;
}

function getRoundTimePlayed(roundlength)
{
	totalTimePlayed = 0;
	if(isdefined(self.timePlayed) && isdefined(self.timePlayed["total"]))
	{
		totalTimePlayed = self.timePlayed["total"];
		if(totalTimePlayed > roundlength)
		{
			totalTimePlayed = roundlength;
		}
	}
	return totalTimePlayed;
}

function bbPlayerMatchEnd(gameLength, endReasonString, gameOver)
{
}

function roundEndWait(defaultDelay, matchBonus)
{
	notifiesDone = 0;
	while(!notifiesDone)
	{
		players = level.players;
		notifiesDone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingNotify) || !players[index].doingNotify)
			{
				continue;
			}
			notifiesDone = 0;
		}
		wait(0.5);
	}
	if(!matchBonus)
	{
		wait(defaultDelay);
		level notify("round_end_done");
		return;
	}
	wait(defaultDelay / 2);
	level notify("give_match_bonus");
	wait(defaultDelay / 2);
	notifiesDone = 0;
	while(!notifiesDone)
	{
		players = level.players;
		notifiesDone = 1;
		for(index = 0; index < players.size; index++)
		{
			if(!isdefined(players[index].doingNotify) || !players[index].doingNotify)
			{
				continue;
			}
			notifiesDone = 0;
		}
		wait(0.5);
	}
	level notify("round_end_done");
}

function roundEndDoF(time)
{
	self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
}

function checkTimeLimit()
{
	if(isdefined(level.timeLimitOverride) && level.timeLimitOverride)
	{
		return;
	}
	if(game["state"] != "playing")
	{
		setGameEndTime(0);
		return;
	}
	if(level.timelimit <= 0)
	{
		setGameEndTime(0);
		return;
	}
	if(level.inPrematchPeriod)
	{
		setGameEndTime(0);
		return;
	}
	if(isdefined(level.timerPaused) && level.timerPaused)
	{
		timeRemaining = globallogic_utils::getTimeRemaining();
		if(timeRemaining > 30000)
		{
			setGameEndTime(Int(timeRemaining - 999) * -1);
		}
		else
		{
			setGameEndTime(Int(timeRemaining - 99) * -1);
		}
		return;
	}
	if(level.timerStopped)
	{
		setGameEndTime(0);
		return;
	}
	if(!isdefined(level.startTime))
	{
		return;
	}
	timeLeft = globallogic_utils::getTimeRemaining();
	setGameEndTime(GetTime() + Int(timeLeft));
	if(timeLeft > 0)
	{
		return;
	}
	[[level.onTimeLimit]]();
}

function checkScoreLimit()
{
	if(game["state"] != "playing")
	{
		return 0;
	}
	if(level.scoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(!util::any_team_hit_score_limit())
		{
			return 0;
		}
	}
	else if(!isPlayer(self))
	{
		return 0;
	}
	if(self.pointstowin < level.scoreLimit)
	{
		return 0;
	}
	[[level.onScoreLimit]]();
}

function checkSuddenDeathScoreLimit(team)
{
	if(game["state"] != "playing")
	{
		return 0;
	}
	if(level.roundScoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(!game["teamSuddenDeath"][team])
		{
			return 0;
		}
	}
	else
	{
		return 0;
	}
	[[level.onScoreLimit]]();
}

function checkRoundScoreLimit()
{
	if(game["state"] != "playing")
	{
		return 0;
	}
	if(level.roundScoreLimit <= 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		if(!util::any_team_hit_round_score_limit())
		{
			return 0;
		}
	}
	else if(!isPlayer(self))
	{
		return 0;
	}
	roundScoreLimit = util::get_current_round_score_limit();
	if(self.pointstowin < roundScoreLimit)
	{
		return 0;
	}
	[[level.onRoundScoreLimit]]();
}

function updateGametypeDvars()
{
	level endon("game_ended");
	while(game["state"] == "playing")
	{
		roundLimit = math::clamp(GetGametypeSetting("roundLimit"), level.roundLimitMin, level.roundLimitMax);
		if(roundLimit != level.roundLimit)
		{
			level.roundLimit = roundLimit;
			level notify("update_roundlimit");
		}
		timelimit = [[level.getTimeLimit]]();
		if(timelimit != level.timelimit)
		{
			level.timelimit = timelimit;
			SetDvar("ui_timelimit", level.timelimit);
			level notify("update_timelimit");
		}
		thread checkTimeLimit();
		scoreLimit = math::clamp(GetGametypeSetting("scoreLimit"), level.scoreLimitMin, level.scoreLimitMax);
		if(scoreLimit != level.scoreLimit)
		{
			level.scoreLimit = scoreLimit;
			SetDvar("ui_scorelimit", level.scoreLimit);
			level notify("update_scorelimit");
		}
		thread checkScoreLimit();
		roundScoreLimit = math::clamp(GetGametypeSetting("roundScoreLimit"), level.roundScoreLimitMin, level.roundScoreLimitMax);
		if(roundScoreLimit != level.roundScoreLimit)
		{
			level.roundScoreLimit = roundScoreLimit;
			level notify("update_roundScoreLimit");
		}
		thread checkRoundScoreLimit();
		if(isdefined(level.startTime))
		{
			if(globallogic_utils::getTimeRemaining() < 3000)
			{
				wait(0.1);
				continue;
			}
		}
		wait(1);
	}
}

function removeDisconnectedPlayerFromPlacement()
{
	numPlayers = level.placement["all"].size;
	found = 0;
	for(i = 0; i < numPlayers; i++)
	{
		if(level.placement["all"][i] == self)
		{
			found = 1;
		}
		if(found)
		{
			level.placement["all"][i] = level.placement["all"][i + 1];
		}
	}
	if(!found)
	{
		return;
	}
	level.placement["all"][numPlayers - 1] = undefined;
	/#
		Assert(level.placement["Dev Block strings are not supported"].size == numPlayers - 1);
	#/
	updateTeamPlacement();
	if(level.teambased)
	{
		return;
	}
	numPlayers = level.placement["all"].size;
	for(i = 0; i < numPlayers; i++)
	{
		player = level.placement["all"][i];
		player notify("update_outcome");
	}
}

function updatePlacement()
{
	if(!level.players.size)
	{
		return;
	}
	level.placement["all"] = [];
	foreach(player in level.players)
	{
		if(!level.teambased || isdefined(level.teams[player.team]))
		{
			level.placement["all"][level.placement["all"].size] = player;
		}
	}
	placementAll = level.placement["all"];
	if(level.teambased)
	{
		for(i = 1; i < placementAll.size; i++)
		{
			player = placementAll[i];
			playerScore = player.score;
			for(j = i - 1; j >= 0 && (playerScore > placementAll[j].score || (playerScore == placementAll[j].score && player.deaths < placementAll[j].deaths)); j--)
			{
				placementAll[j + 1] = placementAll[j];
			}
			placementAll[j + 1] = player;
		}
		
        // something broke here
	}
	for(i = 1; i < placementAll.size; i++)
	{
		player = placementAll[i];
		playerScore = player.pointstowin;
		for(j = i - 1; j >= 0 && (playerScore > placementAll[j].pointstowin || (playerScore == placementAll[j].pointstowin && player.deaths < placementAll[j].deaths) || (playerScore == placementAll[j].pointstowin && player.deaths == placementAll[j].deaths && player.lastKillTime > placementAll[j].lastKillTime)); j--)
		{
			placementAll[j + 1] = placementAll[j];
		}
		placementAll[j + 1] = player;
	}
	level.placement["all"] = placementAll;
	updateTeamPlacement();
}

function updateTeamPlacement()
{
	foreach(team in level.teams)
	{
		placement[team] = [];
	}
	placement["spectator"] = [];
	if(!level.teambased)
	{
		return;
	}
	placementAll = level.placement["all"];
	placementAllSize = placementAll.size;
	for(i = 0; i < placementAllSize; i++)
	{
		player = placementAll[i];
		team = player.pers["team"];
		placement[team][placement[team].size] = player;
	}
	foreach(team in level.teams)
	{
		level.placement[team] = placement[team];
	}
}

function getPlacementForPlayer(player)
{
	updatePlacement();
	playerRank = -1;
	placement = level.placement["all"];
	for(placementIndex = 0; placementIndex < placement.size; placementIndex++)
	{
		if(level.placement["all"][placementIndex] == player)
		{
			playerRank = placementIndex + 1;
			break;
		}
	}
	return playerRank;
}

function isTopScoringPlayer(player)
{
	topScoringPlayer = 0;
	updatePlacement();
	/#
		Assert(level.placement["Dev Block strings are not supported"].size > 0);
	#/
	if(level.placement["all"].size == 0)
	{
		return 0;
	}
	if(level.teambased)
	{
		topScore = level.placement["all"][0].score;
		for(index = 0; index < level.placement["all"].size; index++)
		{
			if(level.placement["all"][index].score == 0)
			{
				break;
			}
			if(topScore > level.placement["all"][index].score)
			{
				break;
			}
			if(player == level.placement["all"][index])
			{
				topScoringPlayer = 1;
				break;
			}
		}
		
        // something broke here
	}
	topScore = level.placement["all"][0].pointstowin;
	for(index = 0; index < level.placement["all"].size; index++)
	{
		if(level.placement["all"][index].pointstowin == 0)
		{
			break;
		}
		if(topScore > level.placement["all"][index].pointstowin)
		{
			break;
		}
		if(player == level.placement["all"][index])
		{
			topScoringPlayer = 1;
			break;
		}
	}
	return topScoringPlayer;
}

function sortDeadPlayers(team)
{
	if(!level.playerQueuedRespawn)
	{
		return;
	}
	for(i = 1; i < level.deadPlayers[team].size; i++)
	{
		player = level.deadPlayers[team][i];
		for(j = i - 1; j >= 0 && player.deathtime < level.deadPlayers[team][j].deathtime; j--)
		{
			level.deadPlayers[team][j + 1] = level.deadPlayers[team][j];
		}
		level.deadPlayers[team][j + 1] = player;
	}
	for(i = 0; i < level.deadPlayers[team].size; i++)
	{
		if(level.deadPlayers[team][i].spawnQueueIndex != i)
		{
			level.spawnQueueModified[team] = 1;
		}
		level.deadPlayers[team][i].spawnQueueIndex = i;
	}
}

function totalAliveCount()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.aliveCount[team];
	}
	return count;
}

function totalPlayerLives()
{
	count = 0;
	foreach(team in level.teams)
	{
		count = count + level.playerLives[team];
	}
	return count;
}

function initTeamVariables(team)
{
	if(!isdefined(level.aliveCount))
	{
		level.aliveCount = [];
	}
	level.aliveCount[team] = 0;
	level.lastAliveCount[team] = 0;
	if(!isdefined(game["everExisted"]))
	{
		game["everExisted"] = [];
	}
	if(!isdefined(game["everExisted"][team]))
	{
		game["everExisted"][team] = 0;
	}
	level.everExisted[team] = 0;
	level.waveDelay[team] = 0;
	level.lastWave[team] = 0;
	level.wavePlayerSpawnIndex[team] = 0;
	resetTeamVariables(team);
}

function resetTeamVariables(team)
{
	level.playerCount[team] = 0;
	level.botsCount[team] = 0;
	level.lastAliveCount[team] = level.aliveCount[team];
	level.aliveCount[team] = 0;
	level.playerLives[team] = 0;
	level.aliveplayers[team] = [];
	level.spawningPlayers[team] = [];
	level.deadPlayers[team] = [];
	level.squads[team] = [];
	level.spawnQueueModified[team] = 0;
}

function updateTeamStatus()
{
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon("game_ended");
	waittillframeend;
	wait(0);
	if(game["state"] == "postgame")
	{
		return;
	}
	resetTimeout();
	foreach(team in level.teams)
	{
		resetTeamVariables(team);
	}
	if(!level.teambased)
	{
		resetTeamVariables("free");
	}
	level.activePlayers = [];
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player) && level.Splitscreen)
		{
			continue;
		}
		if(level.teambased || player.team == "spectator")
		{
			team = player.team;
		}
		else
		{
			team = "free";
		}
		playerclass = player.curClass;
		if(team != "spectator" && (isdefined(playerclass) && playerclass != ""))
		{
			level.playerCount[team]++;
			if(isdefined(player.pers["isBot"]))
			{
				level.botsCount[team]++;
			}
			not_quite_dead = 0;
			if(isdefined(player.overridePlayerDeadStatus))
			{
				not_quite_dead = player [[player.overridePlayerDeadStatus]]();
			}
			if(player.sessionstate == "playing")
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;
				player.spawnQueueIndex = -1;
				if(isalive(player))
				{
					level.aliveplayers[team][level.aliveplayers[team].size] = player;
					level.activePlayers[level.activePlayers.size] = player;
				}
				else
				{
					level.deadPlayers[team][level.deadPlayers[team].size] = player;
				}
				continue;
			}
			if(not_quite_dead)
			{
				level.aliveCount[team]++;
				level.playerLives[team]++;
				level.aliveplayers[team][level.aliveplayers[team].size] = player;
				continue;
			}
			level.deadPlayers[team][level.deadPlayers[team].size] = player;
			if(player globallogic_spawn::maySpawn())
			{
				level.playerLives[team]++;
			}
		}
	}
	totalAlive = totalAliveCount();
	if(totalAlive > level.maxPlayerCount)
	{
		level.maxPlayerCount = totalAlive;
	}
	foreach(team in level.teams)
	{
		if(level.aliveCount[team])
		{
			game["everExisted"][team] = 1;
			level.everExisted[team] = 1;
		}
		sortDeadPlayers(team);
	}
	level updateGameEvents();
}

function updateAliveTimes(team)
{
	level.aliveTimesAverage[team] = 0;
	if(game["state"] == "postgame")
	{
		return;
	}
	total_player_count = 0;
	average_player_spawn_time = 0;
	total_value_count = 0;
	foreach(player in level.aliveplayers[team])
	{
		average_time = 0;
		count = 0;
		foreach(time in player.aliveTimes)
		{
			if(time != 0)
			{
				average_time = average_time + time;
				count++;
			}
		}
		if(count)
		{
			total_value_count = total_value_count + count;
			average_player_spawn_time = average_player_spawn_time + average_time / count;
			total_player_count++;
		}
	}
	foreach(player in level.deadPlayers[team])
	{
		average_time = 0;
		count = 0;
		foreach(time in player.aliveTimes)
		{
			if(time != 0)
			{
				average_time = average_time + time;
				count++;
			}
		}
		if(count)
		{
			total_value_count = total_value_count + count;
			average_player_spawn_time = average_player_spawn_time + average_time / count;
			total_player_count++;
		}
	}
	if(total_player_count == 0 || total_value_count < 3)
	{
		level.aliveTimesAverage[team] = 0;
		return;
	}
	level.aliveTimesAverage[team] = average_player_spawn_time / total_player_count;
}

function updateAllAliveTimes()
{
	foreach(team in level.teams)
	{
		updateAliveTimes(team);
	}
}

function checkTeamScoreLimitSoon(team)
{
	/#
		Assert(isdefined(team));
	#/
	if(level.scoreLimit <= 0)
	{
		return;
	}
	if(!level.teambased)
	{
		return;
	}
	if(globallogic_utils::getTimePassed() < 60000)
	{
		return;
	}
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit(team);
	if(timeLeft < 1)
	{
		level notify("match_ending_soon", "score");
	}
}

function checkPlayerScoreLimitSoon()
{
	/#
		Assert(isPlayer(self));
	#/
	if(level.scoreLimit <= 0)
	{
		return;
	}
	if(level.teambased)
	{
		return;
	}
	if(globallogic_utils::getTimePassed() < 60000)
	{
		return;
	}
	timeLeft = globallogic_utils::getEstimatedTimeUntilScoreLimit(undefined);
	if(timeLeft < 1)
	{
		level notify("match_ending_soon", "score");
	}
}

function timeLimitClock()
{
	level endon("game_ended");
	wait(0.05);
	clockObject = spawn("script_origin", (0, 0, 0));
	while(game["state"] == "playing")
	{
		if(!level.timerStopped && level.timelimit)
		{
			timeLeft = globallogic_utils::getTimeRemaining() / 1000;
			timeLeftInt = Int(timeLeft + 0.5);
			if(timeLeftInt == 601)
			{
				util::clientNotify("notify_10");
			}
			if(timeLeftInt == 301)
			{
				util::clientNotify("notify_5");
			}
			if(timeLeftInt == 60)
			{
				util::clientNotify("notify_1");
			}
			if(timeLeftInt == 12)
			{
				util::clientNotify("notify_count");
			}
			if(timeLeftInt >= 40 && timeLeftInt <= 60)
			{
				level notify("match_ending_soon", "time");
			}
			if(timeLeftInt >= 30 && timeLeftInt <= 40)
			{
				level notify("match_ending_pretty_soon", "time");
			}
			if(timeLeftInt <= 32)
			{
				level notify("match_ending_vox");
			}
			if(timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0))
			{
				level notify("match_ending_very_soon", "time");
				if(timeLeftInt == 0)
				{
					break;
				}
				clockObject playsound("mpl_ui_timer_countdown");
			}
			if(timeLeft - floor(timeLeft) >= 0.05)
			{
				wait(timeLeft - floor(timeLeft));
			}
		}
		wait(1);
	}
}

function timeLimitClock_Intermission(waitTime)
{
	setGameEndTime(GetTime() + Int(waitTime * 1000));
	clockObject = spawn("script_origin", (0, 0, 0));
	if(waitTime >= 10)
	{
		wait(waitTime - 10);
	}
	for(;;)
	{
		clockObject playsound("mpl_ui_timer_countdown");
		wait(1);
	}
}

function recordBreadcrumbData()
{
	level endon("game_ended");
	while(1)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isalive(player))
			{
				RecordBreadcrumbDataForPlayer(player, player.lastShotBy);
			}
		}
		wait(2);
	}
}

function startGame()
{
	thread globallogic_utils::gameTimer();
	level.timerStopped = 0;
	level.playableTimerStopped = 0;
	SetMatchTalkFlag("DeadChatWithDead", level.voip.deadChatWithDead);
	SetMatchTalkFlag("DeadChatWithTeam", level.voip.deadChatWithTeam);
	SetMatchTalkFlag("DeadHearTeamLiving", level.voip.deadHearTeamLiving);
	SetMatchTalkFlag("DeadHearAllLiving", level.voip.deadHearAllLiving);
	SetMatchTalkFlag("EveryoneHearsEveryone", level.voip.everyoneHearsEveryone);
	SetMatchTalkFlag("DeadHearKiller", level.voip.deadHearKiller);
	SetMatchTalkFlag("KillersHearVictim", level.voip.killersHearVictim);
	ClearTopScorers();
	if(isdefined(level.custom_prematch_period))
	{
		[[level.custom_prematch_period]]();
	}
	else
	{
		prematchPeriod();
	}
	level notify("prematch_over");
	level.prematch_over = 1;
	level clientfield::set("gameplay_started", 1);
	thread notifyEndOfGameplay();
	thread timeLimitClock();
	thread gracePeriod();
	thread watchMatchEndingSoon();
	thread globallogic_audio::announcerController();
	thread globallogic_audio::sndMusicFunctions();
	thread recordBreadcrumbData();
	if(util::isRoundBased())
	{
		if(util::getRoundsPlayed() == 0)
		{
			recordMatchBegin();
		}
		matchRecordRoundStart();
		if(isdefined(game["overtime_round"]))
		{
			matchRecordOvertimeRound();
		}
	}
	else
	{
		recordMatchBegin();
	}
}

function isPrematchRequirementConditionMet(activeTeamCount)
{
	if(level.prematchRequirement == 0)
	{
		return 1;
	}
	if(level.teambased)
	{
		if(activeTeamCount.size <= 1)
		{
			return 0;
		}
		foreach(teamCount in activeTeamCount)
		{
			if(teamCount != level.prematchRequirement)
			{
				return 0;
			}
		}
	}
	else if(activeTeamCount["free"] != level.prematchRequirement)
	{
		return 0;
	}
	return 1;
}

function waitForPlayers()
{
	level endon("game_ended");
	startTime = GetTime();
	playerReady = 0;
	activePlayerCount = 0;
	acceptTestClient = 0;
	activeTeamCount = [];
	player_ready = [];
	while(!playerReady || activePlayerCount == 0 || !isPrematchRequirementConditionMet(activeTeamCount))
	{
		activePlayerCount = 0;
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				activeTeamCount[team] = 0;
			}
		}
		else
		{
			activeTeamCount["free"] = 0;
		}
		temp_player_ready = [];
		foreach(player in level.players)
		{
			if(player IsTestClient() && acceptTestClient == 0)
			{
				continue;
			}
			if(player.team != "spectator")
			{
				activePlayerCount++;
				player_num = player GetEntityNumber();
				if(isdefined(player_ready[player_num]))
				{
					temp_player_ready[player_num] = player_ready[player_num];
				}
				else
				{
					temp_player_ready[player_num] = GetTime();
				}
				if(temp_player_ready[player_num] + 5000 < GetTime() || player isStreamerReady(-1, 1))
				{
					if(level.teambased)
					{
						activeTeamCount[player.team]++;
					}
					else
					{
						activeTeamCount["free"]++;
					}
				}
			}
			if(player isStreamerReady(-1, 1))
			{
				if(playerReady == 0)
				{
					level notify("first_player_ready", player);
				}
				playerReady = 1;
			}
		}
		player_read = temp_player_ready;
		wait(0.05);
		if(GetTime() - startTime > 20000)
		{
			if(level.rankedMatch == 0 && level.arenaMatch == 0)
			{
				acceptTestClient = 1;
			}
		}
		if(level.rankedMatch && GetTime() - startTime > 120000)
		{
			exit_level();
			while(1)
			{
				wait(10);
			}
		}
	}
}

function prematchWaitingForPlayers()
{
	if(level.prematchRequirement != 0)
	{
		level waittill("first_player_ready", player);
		LUINotifyEvent(&"prematch_waiting_for_players");
	}
}

function prematchPeriod()
{
	SetMatchFlag("hud_hardcore", level.hardcoreMode);
	level endon("game_ended");
	globallogic_audio::sndMusicSetRandomizer();
	if(level.prematchPeriod > 0)
	{
		thread matchStartTimer();
		thread prematchWaitingForPlayers();
		waitForPlayers();
		wait(level.prematchPeriod);
	}
	else
	{
		matchStartTimerSkip();
		wait(0.05);
	}
	level.inPrematchPeriod = 0;
	level thread sndSetMatchSnapshot(0);
	for(index = 0; index < level.players.size; index++)
	{
		level.players[index] util::freeze_player_controls(0);
		level.players[index] enableWeapons();
	}
	if(game["state"] != "playing")
	{
		return;
	}
}

function gracePeriod()
{
	level endon("game_ended");
	if(isdefined(level.gracePeriodFunc))
	{
		[[level.gracePeriodFunc]]();
	}
	else
	{
		wait(level.gracePeriod);
	}
	level notify("grace_period_ending");
	wait(0.05);
	level.inGracePeriod = 0;
	if(game["state"] != "playing")
	{
		return;
	}
	if(level.numLives)
	{
		players = level.players;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player.hasSpawned && player.sessionteam != "spectator" && !isalive(player))
			{
				player.statusicon = "hud_status_dead";
			}
		}
	}
	level thread updateTeamStatus();
	level thread updateAllAliveTimes();
}

function watchMatchEndingSoon()
{
	SetDvar("xblive_matchEndingSoon", 0);
	level waittill("match_ending_soon", reason);
	SetDvar("xblive_matchEndingSoon", 1);
}

function assertTeamVariables()
{
	foreach(team in level.teams)
	{
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team + "Dev Block strings are not supported"]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"]["Dev Block strings are not supported" + team]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"]["Dev Block strings are not supported" + team]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
		/#
			Assert(isdefined(game["Dev Block strings are not supported"][team]), "Dev Block strings are not supported" + team + "Dev Block strings are not supported");
		#/
	}
}

function anyTeamHasWaveDelay()
{
	foreach(team in level.teams)
	{
		if(level.waveDelay[team])
		{
			return 1;
		}
	}
	return 0;
}

function Callback_StartGameType()
{
	level.prematchRequirement = 0;
	level.prematchPeriod = 0;
	level.intermission = 0;
	SetMatchFlag("cg_drawSpectatorMessages", 1);
	SetMatchFlag("game_ended", 0);
	if(!isdefined(game["gamestarted"]))
	{
		if(!isdefined(game["allies"]))
		{
			game["allies"] = "seals";
		}
		if(!isdefined(game["axis"]))
		{
			game["axis"] = "pmc";
		}
		if(!isdefined(game["attackers"]))
		{
			game["attackers"] = "allies";
		}
		if(!isdefined(game["defenders"]))
		{
			game["defenders"] = "axis";
		}
		/#
			Assert(game["Dev Block strings are not supported"] != game["Dev Block strings are not supported"]);
		#/
		foreach(team in level.teams)
		{
			if(!isdefined(game[team]))
			{
				game[team] = "pmc";
			}
		}
		if(!isdefined(game["state"]))
		{
			game["state"] = "playing";
		}
		SetDvar("cg_thirdPersonAngle", 354);
		game["strings"]["press_to_spawn"] = &"PLATFORM_PRESS_TO_SPAWN";
		if(level.teambased)
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		else
		{
			game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_PLAYERS";
			game["strings"]["opponent_forfeiting_in"] = &"MP_OPPONENT_FORFEITING_IN";
		}
		game["strings"]["match_starting_in"] = &"MP_MATCH_STARTING_IN";
		game["strings"]["spawn_next_round"] = &"MP_SPAWN_NEXT_ROUND";
		game["strings"]["waiting_to_spawn"] = &"MP_WAITING_TO_SPAWN";
		game["strings"]["waiting_to_spawn_ss"] = &"MP_WAITING_TO_SPAWN_SS";
		game["strings"]["you_will_spawn"] = &"MP_YOU_WILL_RESPAWN";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["change_class"] = &"MP_CHANGE_CLASS_NEXT_SPAWN";
		game["strings"]["last_stand"] = &"MPUI_LAST_STAND";
		game["strings"]["cowards_way"] = &"PLATFORM_COWARDS_WAY_OUT";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";
		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";
		game["strings"]["players_forfeited"] = &"MP_PLAYERS_FORFEITED";
		game["strings"]["other_teams_forfeited"] = &"MP_OTHER_TEAMS_FORFEITED";
		assertTeamVariables();
		[[level.onPrecacheGameType]]();
		game["gamestarted"] = 1;
		game["totalKills"] = 0;
		foreach(team in level.teams)
		{
			if(!isdefined(game["migratedHost"]))
			{
				game["teamScores"][team] = 0;
			}
			game["teamSuddenDeath"][team] = 0;
			game["totalKillsTeam"][team] = 0;
		}
		level.prematchRequirement = GetGametypeSetting("prematchRequirement");
		level.prematchPeriod = GetGametypeSetting("prematchperiod");
		if(GetDvarInt("xblive_clanmatch") != 0)
		{
			foreach(team in level.teams)
			{
				game["icons"][team] = "composite_emblem_team_axis";
			}
			game["icons"]["allies"] = "composite_emblem_team_allies";
			game["icons"]["axis"] = "composite_emblem_team_axis";
		}
	}
	else if(!level.Splitscreen)
	{
		level.prematchPeriod = GetGametypeSetting("preroundperiod");
	}
	if(!isdefined(game["timepassed"]))
	{
		game["timepassed"] = 0;
	}
	if(!isdefined(game["playabletimepassed"]))
	{
		game["playabletimepassed"] = 0;
	}
	if(!isdefined(game["roundsplayed"]))
	{
		game["roundsplayed"] = 0;
	}
	SetRoundsPlayed(game["roundsplayed"]);
	if(isdefined(game["overtime_round"]))
	{
		SetRoundsPlayed(game["roundsplayed"] + game["overtime_round"] - 1);
		SetMatchFlag("overtime", 1);
	}
	else
	{
		SetMatchFlag("overtime", 0);
	}
	if(!isdefined(game["roundwinner"]))
	{
		game["roundwinner"] = [];
	}
	if(!isdefined(game["lastroundscore"]))
	{
		game["lastroundscore"] = [];
	}
	if(!isdefined(game["roundswon"]))
	{
		game["roundswon"] = [];
	}
	if(!isdefined(game["roundswon"]["tie"]))
	{
		game["roundswon"]["tie"] = 0;
	}
	if(!isdefined(game["overtimeroundswon"]))
	{
		game["overtimeroundswon"] = [];
	}
	if(!isdefined(game["overtimeroundswon"]["tie"]))
	{
		game["overtimeroundswon"]["tie"] = 0;
	}
	foreach(team in level.teams)
	{
		if(!isdefined(game["roundswon"][team]))
		{
			game["roundswon"][team] = 0;
		}
		if(!isdefined(game["overtimeroundswon"][team]))
		{
			game["overtimeroundswon"][team] = 0;
		}
		level.teamSpawnPoints[team] = [];
		level.spawn_point_team_class_names[team] = [];
	}
	level.skipVote = 0;
	level.gameEnded = 0;
	level.exitLevel = 0;
	SetDvar("g_gameEnded", 0);
	level.objIDStart = 0;
	level.forcedEnd = 0;
	level.hostForcedEnd = 0;
	level.hardcoreMode = GetGametypeSetting("hardcoreMode");
	if(level.hardcoreMode)
	{
		/#
			print("Dev Block strings are not supported");
		#/
		if(!isdefined(level.friendlyFireDelayTime))
		{
			level.friendlyFireDelayTime = 0;
		}
	}
	if(GetDvarString("scr_max_rank") == "")
	{
		SetDvar("scr_max_rank", "0");
	}
	level.rankCap = GetDvarInt("scr_max_rank");
	if(GetDvarString("scr_min_prestige") == "")
	{
		SetDvar("scr_min_prestige", "0");
	}
	level.minPrestige = GetDvarInt("scr_min_prestige");
	level.useStartSpawns = 1;
	level.alwaysUseStartSpawns = 0;
	level.useXCamsForEndGame = 1;
	level.cumulativeRoundScores = GetGametypeSetting("cumulativeRoundScores");
	level.allowHitMarkers = GetGametypeSetting("allowhitmarkers");
	level.playerQueuedRespawn = GetGametypeSetting("playerQueuedRespawn");
	level.playerForceRespawn = GetGametypeSetting("playerForceRespawn");
	level.roundStartExplosiveDelay = GetGametypeSetting("roundStartExplosiveDelay");
	level.roundStartKillstreakDelay = GetGametypeSetting("roundStartKillstreakDelay");
	level.perksEnabled = GetGametypeSetting("perksEnabled");
	level.disableAttachments = GetGametypeSetting("disableAttachments");
	level.disableTacInsert = GetGametypeSetting("disableTacInsert");
	level.disableCAC = GetGametypeSetting("disableCAC");
	level.disableClassSelection = GetGametypeSetting("disableClassSelection");
	level.disableWeaponDrop = GetGametypeSetting("disableweapondrop");
	level.onlyHeadShots = GetGametypeSetting("onlyHeadshots");
	level.minimumAllowedTeamKills = GetGametypeSetting("teamKillPunishCount") - 1;
	level.teamKillReducedPenalty = GetGametypeSetting("teamKillReducedPenalty");
	level.teamKillPointLoss = GetGametypeSetting("teamKillPointLoss");
	level.teamKillSpawnDelay = GetGametypeSetting("teamKillSpawnDelay");
	level.deathPointLoss = GetGametypeSetting("deathPointLoss");
	level.leaderBonus = GetGametypeSetting("leaderBonus");
	level.forceradar = GetGametypeSetting("forceRadar");
	level.playerSprintTime = GetGametypeSetting("playerSprintTime");
	level.bulletDamageScalar = GetGametypeSetting("bulletDamageScalar");
	level.playerMaxHealth = GetGametypeSetting("playerMaxHealth");
	level.playerHealthRegenTime = GetGametypeSetting("playerHealthRegenTime");
	level.scoreResetOnDeath = GetGametypeSetting("scoreResetOnDeath");
	level.playerRespawnDelay = GetGametypeSetting("playerRespawnDelay");
	level.playerIncrementalRespawnDelay = GetGametypeSetting("incrementalSpawnDelay");
	level.playerObjectiveHeldRespawnDelay = GetGametypeSetting("playerObjectiveHeldRespawnDelay");
	level.waveRespawnDelay = GetGametypeSetting("waveRespawnDelay");
	level.suicideSpawnDelay = GetGametypeSetting("spawnsuicidepenalty");
	level.teamKilledSpawnDelay = GetGametypeSetting("spawnteamkilledpenalty");
	level.maxSuicidesBeforeKick = GetGametypeSetting("maxsuicidesbeforekick");
	level.spectateType = GetGametypeSetting("spectateType");
	level.voip = spawnstruct();
	level.voip.deadChatWithDead = GetGametypeSetting("voipDeadChatWithDead");
	level.voip.deadChatWithTeam = GetGametypeSetting("voipDeadChatWithTeam");
	level.voip.deadHearAllLiving = GetGametypeSetting("voipDeadHearAllLiving");
	level.voip.deadHearTeamLiving = GetGametypeSetting("voipDeadHearTeamLiving");
	level.voip.everyoneHearsEveryone = GetGametypeSetting("voipEveryoneHearsEveryone");
	level.voip.deadHearKiller = GetGametypeSetting("voipDeadHearKiller");
	level.voip.killersHearVictim = GetGametypeSetting("voipKillersHearVictim");
	level.droppedTagRespawn = GetGametypeSetting("droppedTagRespawn");
	if(isdefined(level.droppedTagRespawn) && level.droppedTagRespawn)
	{
		dogtags::init();
	}
	gameobjects::main();
	callback::callback("hash_cc62acca");
	thread hud_message::init();
	foreach(team in level.teams)
	{
		initTeamVariables(team);
	}
	if(!level.teambased)
	{
		initTeamVariables("free");
	}
	level.maxPlayerCount = 0;
	level.activePlayers = [];
	level.aliveTimeMaxCount = 3;
	level.aliveTimesAverage = [];
	foreach(team in level.teams)
	{
		level.aliveTimesAverage[team] = 0;
	}
	if(!isdefined(level.livesDoNotReset) || !level.livesDoNotReset)
	{
		foreach(team in level.teams)
		{
			game[team + "_lives"] = level.numTeamLives;
		}
	}
	level.allowAnnouncer = GetGametypeSetting("allowAnnouncer");
	if(!isdefined(level.timelimit))
	{
		util::registerTimeLimit(1, 1440);
	}
	if(!isdefined(level.scoreLimit))
	{
		util::registerScoreLimit(1, 500);
	}
	if(!isdefined(level.roundScoreLimit))
	{
		util::registerRoundScoreLimit(0, 500);
	}
	if(!isdefined(level.roundLimit))
	{
		util::registerRoundLimit(0, 10);
	}
	if(!isdefined(level.roundWinLimit))
	{
		util::registerRoundWinLimit(0, 10);
	}
	globallogic_utils::registerPostRoundEvent(&killcam::post_round_final_killcam);
	waveDelay = level.waveRespawnDelay;
	if(waveDelay)
	{
		foreach(team in level.teams)
		{
			level.waveDelay[team] = waveDelay;
			level.lastWave[team] = 0;
		}
		level thread [[level.waveSpawnTimer]]();
	}
	level.inPrematchPeriod = 1;
	if(level.prematchPeriod > 2 && level.rankedMatch)
	{
		level.prematchPeriod = level.prematchPeriod + RandomFloat(4) - 2;
	}
	if(level.numLives || anyTeamHasWaveDelay() || level.playerQueuedRespawn)
	{
		level.gracePeriod = 15;
	}
	else
	{
		level.gracePeriod = 5;
	}
	level.inGracePeriod = 1;
	level.roundEndDelay = 5;
	level.halftimeRoundEndDelay = 3;
	globallogic_score::updateAllTeamScores();
	level.killstreaksenabled = 1;
	level.missileLockPlaySpaceCheckEnabled = 1;
	level.missileLockPlaySpaceCheckExtraRadius = 5000;
	if(GetDvarString("scr_game_rankenabled") == "")
	{
		SetDvar("scr_game_rankenabled", 1);
	}
	level.rankEnabled = GetDvarInt("scr_game_rankenabled");
	if(GetDvarString("scr_game_medalsenabled") == "")
	{
		SetDvar("scr_game_medalsenabled", 1);
	}
	level.medalsEnabled = GetDvarInt("scr_game_medalsenabled");
	if(level.hardcoreMode && level.rankedMatch && GetDvarString("scr_game_friendlyFireDelay") == "")
	{
		SetDvar("scr_game_friendlyFireDelay", 1);
	}
	level.friendlyFireDelay = GetDvarInt("scr_game_friendlyFireDelay");
	[[level.onStartGameType]]();
	if(GetDvarInt("custom_killstreak_mode") == 1)
	{
		level.killstreaksenabled = 0;
	}
	level thread killcam::do_final_killcam();
	thread startGame();
	level thread updateGametypeDvars();
	level thread simple_hostmigration::UpdateHostMigrationData();
}

function registerFriendlyFireDelay(dvarString, defaultValue, minValue, maxValue)
{
	dvarString = "scr_" + dvarString + "_friendlyFireDelayTime";
	if(GetDvarString(dvarString) == "")
	{
		SetDvar(dvarString, defaultValue);
	}
	if(GetDvarInt(dvarString) > maxValue)
	{
		SetDvar(dvarString, maxValue);
	}
	else if(GetDvarInt(dvarString) < minValue)
	{
		SetDvar(dvarString, minValue);
	}
	level.friendlyFireDelayTime = GetDvarInt(dvarString);
}

function checkRoundSwitch()
{
	if(!isdefined(level.roundSwitch) || !level.roundSwitch)
	{
		return 0;
	}
	if(!isdefined(level.onRoundSwitch))
	{
		return 0;
	}
	/#
		Assert(game["Dev Block strings are not supported"] > 0);
	#/
	if(game["roundsplayed"] % level.roundSwitch == 0)
	{
		[[level.onRoundSwitch]]();
		return 1;
	}
	return 0;
}

function listenForGameEnd()
{
	self waittill("host_sucks_end_game");
	level.skipVote = 1;
	if(!level.gameEnded)
	{
		level thread forceEnd(1);
	}
}

function getKillStreaks(player)
{
	for(killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++)
	{
		killstreak[killstreakNum] = "killstreak_null";
	}
	if(isPlayer(player) && level.disableClassSelection != 1 && !isdefined(player.pers["isBot"]) && isdefined(player.killstreak))
	{
		currentKillstreak = 0;
		for(killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++)
		{
			if(isdefined(player.killstreak[killstreakNum]))
			{
				killstreak[currentKillstreak] = player.killstreak[killstreakNum];
				currentKillstreak++;
			}
		}
	}
	return killstreak;
}

function updateRankedMatch(winner)
{
	if(level.rankedMatch)
	{
		if(hostIdledOut())
		{
			level.hostForcedEnd = 1;
			/#
				print("Dev Block strings are not supported");
			#/
			endLobby();
		}
	}
	namespace_d5037767::updateMatchBonusScores(winner);
}

function annihilatorGunPlayerKillEffect(attacker, weapon)
{
	if(weapon.fusetime != 0)
	{
		wait(weapon.fusetime * 0.001);
	}
	else
	{
		wait(0.45);
	}
	if(!isdefined(self))
	{
		return;
	}
	self playsoundtoplayer("evt_annihilation", attacker);
	self playsoundtoallbutplayer("evt_annihilation_npc", attacker);
	CodeSetClientField(self, "annihilate_effect", 1);
	self shake_and_rumble(0, 0.3, 0.75, 1);
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

function annihilatorGunActorKillEffect(attacker, weapon)
{
	self waittill("actor_corpse", body);
	if(weapon.fusetime != 0)
	{
		wait(weapon.fusetime * 0.001);
	}
	else
	{
		wait(0.45);
	}
	if(!isdefined(self))
	{
		return;
	}
	self playsoundtoplayer("evt_annihilation", attacker);
	self playsoundtoallbutplayer("evt_annihilation_npc", attacker);
	if(!isdefined(body))
	{
		return;
	}
	CodeSetClientField(body, "annihilate_effect", 1);
	body shake_and_rumble(0, 0.6, 0.2, 1);
	body notsolid();
	body ghost();
}

function pineappleGunPlayerKillEffect(attacker)
{
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	CodeSetClientField(self, "pineapplegun_effect", 1);
	self shake_and_rumble(0, 0.3, 0.35, 1);
	wait(0.1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

function BowPlayerKillEffect()
{
	wait(0.05);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	CodeSetClientField(self, "annihilate_effect", 1);
	self shake_and_rumble(0, 0.3, 0.35, 1);
	if(!isdefined(self))
	{
		return;
	}
	self notsolid();
	self ghost();
}

function pineappleGunActorKillEffect()
{
	self waittill("actor_corpse", body);
	wait(0.75);
	if(!isdefined(self))
	{
		return;
	}
	playsoundatposition("evt_annihilation_npc", self.origin);
	if(!isdefined(body))
	{
		return;
	}
	CodeSetClientField(body, "pineapplegun_effect", 1);
	body shake_and_rumble(0, 0.3, 0.75, 1);
	body notsolid();
	body ghost();
}

function shake_and_rumble(n_delay, shake_size, shake_time, rumble_num)
{
	if(isdefined(n_delay) && n_delay > 0)
	{
		wait(n_delay);
	}
	nMagnitude = shake_size;
	nduration = shake_time;
	nRadius = 500;
	v_pos = self.origin;
	Earthquake(nMagnitude, nduration, v_pos, nRadius);
	for(i = 0; i < rumble_num; i++)
	{
		self PlayRumbleOnEntity("damage_heavy");
		wait(0.1);
	}
}

function DoWeaponSpecificKillEffects(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(weapon.name == "hero_pineapplegun" && isPlayer(attacker) && sMeansOfDeath == "MOD_GRENADE")
	{
		attacker playlocalsound("wpn_pineapple_grenade_explode_flesh_2D");
	}
}

function DoWeaponSpecificCorpseEffects(body, eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime)
{
	if(weapon.doannihilate && isPlayer(attacker) && (sMeansOfDeath == "MOD_IMPACT" || sMeansOfDeath == "MOD_GRENADE"))
	{
		if(IsActor(body))
		{
			body thread annihilatorGunActorKillEffect(attacker, weapon);
		}
		else
		{
			body thread annihilatorGunPlayerKillEffect(attacker, weapon);
		}
	}
	else if(sMeansOfDeath == "MOD_BURNED")
	{
		if(!IsActor(body))
		{
			body thread BurnCorpse();
		}
	}
	else if(weapon.isHeroWeapon == 1 && isPlayer(attacker))
	{
		if(weapon.name == "hero_firefly_swarm")
		{
			value = RandomInt(2) + 1;
			if(!IsActor(body))
			{
				CodeSetClientField(body, "firefly_effect", value);
			}
		}
	}
}

function BurnCorpse()
{
	self endon("death");
	CodeSetClientField(self, "burned_effect", 1);
	wait(3);
	CodeSetClientField(self, "burned_effect", 0);
}