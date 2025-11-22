#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\brad_menu\_binds;
#using scripts\mp\gametypes\brad_menu\_menu;
#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\util_shared;

#namespace namespace_363acd5d;

function function_218731d8()
{
	self TakeAllWeapons();
}

function function_a98af669(amount)
{
	self endon("disconnect");
	self endon("hash_fd52dce9");
	i = 0;
	foreach(player in level.players)
	{
		if(player util::is_bot())
		{
			player function_91676431(amount);
			i++;
		}
	}
	if(i != 0)
	{
		self namespace_bd1e7d57::message("Bot Kills Set to^1 " + amount);
	}
	else
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
	}
	self notify("hash_fd52dce9");
}

function function_cd990b08()
{
	timescale = GetDvarFloat("toggle_timescale", 1);
	if(timescale == 1)
	{
		SetDvar("timescale", "0.5");
		level namespace_bd1e7d57::message("Timescale Set To ^5Slow ^3(0.5)");
		SetDvar("toggle_timescale", 0.5);
	}
	else if(timescale == 0.5)
	{
		SetDvar("timescale", "0.3");
		level namespace_bd1e7d57::message("Timescale Set To ^3Very Slow ^3(0.3)");
		SetDvar("toggle_timescale", 0.3);
	}
	else if(timescale == 0.3)
	{
		SetDvar("timescale", "0.1");
		level namespace_bd1e7d57::message("Timescale Set To ^1Extremely Slow ^3(0.1)");
		SetDvar("toggle_timescale", 0.1);
	}
	else
	{
		SetDvar("timescale", "1");
		level namespace_bd1e7d57::message("Timescale Set To ^2Normal ^3(1)");
		SetDvar("toggle_timescale", 1);
	}
}

function function_bed32f9f()
{
	self endon("disconnect");
	if(GetDvarString("g_gametype") == "dm")
	{
		var_43867041 = GetGametypeSetting("scorelimit");
		last = var_43867041 - 1;
		self function_91676431(last);
		self namespace_bd1e7d57::message("You're at ^6Last!");
	}
	else if(GetDvarString("g_gametype") == "tdm")
	{
		var_43867041 = GetGametypeSetting("scorelimit");
		last = var_43867041 - 1;
		self thread globallogic_score::_setTeamScore(self.team, last);
		self function_91676431(last);
		self namespace_bd1e7d57::message("Your team is at ^6Last!");
	}
	else
	{
		self namespace_bd1e7d57::message("^1Gamemode not supported!");
	}
}

function function_86226dd0()
{
	self endon("disconnect");
	var_43867041 = GetGametypeSetting("scorelimit");
	last = var_43867041 - 1;
	if(GetDvarString("g_gametype") == "dm")
	{
		if(self.kills < last)
		{
			var_c58f441a = self.kills + 1;
			self function_91676431(var_c58f441a);
			self namespace_bd1e7d57::message("^2Added^7 1 Kill");
		}
		else if(self.kills == last)
		{
			self namespace_bd1e7d57::message("You're at ^1Last!");
		}
		else
		{
			self namespace_bd1e7d57::message("^1Gamemode not supported!");
		}
	}
	else if(GetDvarString("g_gametype") == "tdm")
	{
		teamScore = self globallogic_score::_getTeamScore(self.team);
		if(teamScore < last)
		{
			var_26c3df31 = teamScore + 1;
			self thread globallogic_score::_setTeamScore(self.team, var_26c3df31);
			self function_91676431(var_26c3df31);
			self namespace_bd1e7d57::message("^2Added^7 1 Kill");
		}
		else if(teamScore == last)
		{
			self namespace_bd1e7d57::message("You're at ^1Last!");
		}
		else
		{
			self namespace_bd1e7d57::message("^1Gamemode not supported!");
		}
	}
	else
	{
		self namespace_bd1e7d57::message("^1Gamemode not supported!");
	}
}

function function_c04897bd()
{
	self endon("disconnect");
	if(GetDvarString("g_gametype") == "dm")
	{
		if(self.kills > 0)
		{
			var_d7fd065f = self.kills - 1;
			self function_91676431(var_d7fd065f);
			self namespace_bd1e7d57::message("^1Removed^7 1 Kill");
		}
		else if(self.kills == 0)
		{
			self namespace_bd1e7d57::message("You're at^1 0!");
		}
		else
		{
			self namespace_bd1e7d57::message("^1Gamemode not supported!");
		}
	}
	else if(GetDvarString("g_gametype") == "tdm")
	{
		teamScore = self globallogic_score::_getTeamScore(self.team);
		if(teamScore > 0)
		{
			var_5dd9d6f0 = teamScore - 1;
			self thread globallogic_score::_setTeamScore(self.team, var_5dd9d6f0);
			self function_91676431(var_5dd9d6f0);
			self namespace_bd1e7d57::message("^1Removed^7 1 Kill");
		}
		else if(teamScore == 0)
		{
			self namespace_bd1e7d57::message("You're at^1 0!");
		}
		else
		{
			self namespace_bd1e7d57::message("^1Gamemode not supported!");
		}
	}
	else
	{
		self namespace_bd1e7d57::message("^1Gamemode not supported!");
	}
}

function function_91676431(kills)
{
	self.kills = kills;
	self.score = kills * 100;
	self.pointstowin = kills;
	self.pers["kills"] = kills;
	self.pers["score"] = kills * 100;
	self.pers["pointstowin"] = kills;
}

function function_4ed51df1(amount)
{
	var_4a259694 = GetGametypeSetting("timelimit");
	var_4a259694 = var_4a259694 + amount;
	SetGametypeSetting("timelimit", var_4a259694);
	level namespace_bd1e7d57::message("^2Added ^7" + amount + " Minute(s)");
}

function function_5c15baa7(amount)
{
	var_4a259694 = GetGametypeSetting("timelimit");
	var_4a259694 = var_4a259694 - amount;
	SetGametypeSetting("timelimit", var_4a259694);
	level namespace_bd1e7d57::message("^1Removed ^7" + amount + " Minute(s)");
}

function function_6f9a4d9a()
{
	if(!isdefined(self.pers["save_load"]))
	{
		self.pers["save_load"] = 1;
		self namespace_bd1e7d57::message("Save & Load Bind ^2Enabled");
		self namespace_bd1e7d57::message("Press ^3[{+actionslot 1}] + [{+melee}] ^7to Save", 1);
		self namespace_bd1e7d57::message("Press ^3[{+actionslot 2}] + [{+melee}] ^7to Load", 1);
		self thread function_d3444e8c();
	}
	else
	{
		self.pers["save_load"] = undefined;
		self namespace_bd1e7d57::message("Save & Load Bind ^1Disabled");
		self notify("hash_1397b6c9");
	}
}

function function_d3444e8c()
{
	self endon("hash_1397b6c9");
	self endon("disconnect");
	while(self ActionSlotOneButtonPressed() && self meleeButtonPressed())
	{
		self function_5fefc250(!isdefined(self.pers["bind_text"]));
		wait(0.5);
		if(self ActionSlotTwoButtonPressed() && self meleeButtonPressed() && isdefined(self.pers["saved_pos"]))
		{
			self function_3b5807e5(0);
			wait(0.5);
		}
		wait(0.05);
	}
}

function function_c0f1bb67()
{
	if(!isdefined(self.pers["saved_pos"]))
	{
		self namespace_bd1e7d57::message("^1Postion Must Be Saved To Enable");
		return;
	}
	if(!isdefined(self.pers["load_on_spawn"]))
	{
		self.pers["load_on_spawn"] = 1;
		self namespace_bd1e7d57::message("Load On Spawn ^2Enabled");
	}
	else
	{
		self.pers["load_on_spawn"] = undefined;
		self namespace_bd1e7d57::message("Load On Spawn ^1Disabled");
	}
}

function function_5fefc250(print)
{
	if(!isdefined(print))
	{
		print = 0;
	}
	self.pers["saved_origin"] = self.origin;
	self.pers["saved_angles"] = self.angles;
	self.pers["saved_pos"] = 1;
	if(print)
	{
		self namespace_bd1e7d57::message("Position ^2Saved");
	}
}

function function_3b5807e5(print)
{
	if(!isdefined(print))
	{
		print = 0;
	}
	if(!isdefined(self.pers["saved_pos"]))
	{
		self namespace_bd1e7d57::message("^1Position Not Saved!");
		return;
	}
	self SetOrigin(self.pers["saved_origin"]);
	self SetPlayerAngles(self.pers["saved_angles"]);
	if(print)
	{
		self namespace_bd1e7d57::message("Position ^2Loaded");
	}
}

function function_bf8eb08c(print)
{
	if(!isdefined(print))
	{
		print = 0;
	}
	self.pers["saved_pos"] = undefined;
	self.pers["saved_origin"] = undefined;
	self.pers["saved_angles"] = undefined;
	if(print)
	{
		self namespace_bd1e7d57::message("Position ^1Reset");
	}
}

function UFOMode()
{
	if(!isdefined(self.pers["ufo"]))
	{
		self thread function_c7249b63();
		self.pers["ufo"] = 1;
		self namespace_bd1e7d57::message("UFO Mode ^2Enabled");
		self namespace_bd1e7d57::message("Press ^3[{+smoke}] ^7to Fly", 1);
		self namespace_bd1e7d57::message("Hold ^3[{+breath_sprint}] ^7to Fly Faster", 1);
	}
	else
	{
		self notify("hash_e767c32c");
		self.pers["ufo"] = undefined;
		if(isdefined(self.var_a04f939e))
		{
			self.var_a04f939e delete();
		}
		self namespace_bd1e7d57::message("UFO Mode ^1Disabled");
	}
}

function function_c7249b63()
{
	self endon("disconnect");
	self endon("hash_e767c32c");
	var_e46cbf99 = 0;
	var_618efcac = 25;
	self.var_a04f939e = spawn("script_model", self.origin);
	self.var_a04f939e.angles = self.angles;
	while(self SecondaryOffhandButtonPressed())
	{
		self playerLinkTo(self.var_a04f939e);
		self EnableInvulnerability();
		var_e46cbf99 = 1;
		if(self SprintButtonPressed())
		{
			var_618efcac = 50;
		}
		else
		{
			var_618efcac = 25;
		}
		continue;
		if(var_e46cbf99 == 1)
		{
			self Unlink();
			if(!isdefined(self.pers["godmode"]))
			{
				self DisableInvulnerability();
			}
			var_e46cbf99 = 0;
		}
		if(var_e46cbf99 == 1)
		{
			fly = self.origin + VectorScale(AnglesToForward(self getPlayerAngles()), var_618efcac);
			self.var_a04f939e moveto(fly, 0.01);
			self.var_a04f939e.angles = self.angles;
		}
		wait(0.05);
	}
}

function function_d6b609b4()
{
	if(!isdefined(self.pers["invisible"]))
	{
		self.pers["invisible"] = 1;
		self Hide();
		self namespace_bd1e7d57::message("Invisibility ^2Enabled");
	}
	else
	{
		self.pers["invisible"] = undefined;
		self show();
		self namespace_bd1e7d57::message("Invisibility ^1Disabled");
	}
}

function function_459c2a05()
{
	if(!isdefined(self.pers["godmode"]))
	{
		self.pers["godmode"] = 1;
		self EnableInvulnerability();
		self namespace_bd1e7d57::message("God Mode ^2Enabled");
	}
	else
	{
		self.pers["godmode"] = undefined;
		self DisableInvulnerability();
		self namespace_bd1e7d57::message("God Mode ^1Disabled");
	}
}

function function_32bcf614()
{
	if(!isdefined(self.pers["floaters"]))
	{
		self thread function_f3f32dcd();
		self.pers["floaters"] = 1;
		self namespace_bd1e7d57::message("Floaters ^2Enabled");
	}
	else
	{
		self.pers["floaters"] = undefined;
		self notify("hash_422aa0c");
		self namespace_bd1e7d57::message("Floaters ^1Disabled");
	}
}

function function_f3f32dcd()
{
	self endon("disconnect");
	self endon("hash_422aa0c");
	level waittill("game_ended");
	if(self IsOnGround())
	{
		return;
	}
	float = spawn("script_model", self.origin);
	float.angles = self.angles;
	GROUNDPOS = bullettrace(self.origin, self.origin - VectorScale((0, 0, 1), 5000), 0, self)["position"];
	self playerLinkTo(float);
	if(isdefined(self.pers["afterhit"]))
	{
		wait(0.35);
	}
	self globallogic_player::freezePlayerForRoundEnd();
	while(self.origin[2] < GROUNDPOS[2])
	{
		self notify("hash_422aa0c");
		var_e9b5e04a = float.origin - VectorScale((0, 0, 1), 0.5);
		float moveto(var_e9b5e04a, 0.01);
		wait(0.01);
	}
}

function function_5fa6a50(a)
{
	bot::add_bots(a);
	self namespace_bd1e7d57::message("^2Spawned ^7" + a + " Bot(s)");
}

function streaks(var_3da1b631)
{
	self endon("disconnect");
	self thread globallogic_score::_setPlayerMomentum(self, 9999);
	if(!isdefined(self.pers["bind_text"]) || var_3da1b631)
	{
		self namespace_bd1e7d57::message("Streaks ^2Given");
	}
}

function function_6529a157()
{
	self endon("hash_9c06561a");
	self endon("disconnect");
	while(self ActionSlotThreeButtonPressed() && self meleeButtonPressed() && isdefined(self.pers["streaks_bind"]))
	{
		self thread streaks(0);
		wait(0.5);
		if(self ActionSlotFourButtonPressed() && self meleeButtonPressed() && isdefined(self.pers["streaks_bind"]))
		{
			self thread giveHeroWeapon(0);
			wait(0.5);
		}
		wait(0.05);
	}
}

function function_747e240b()
{
	self endon("disconnect");
	if(!isdefined(self.pers["streaks_bind"]))
	{
		self.pers["streaks_bind"] = 1;
		self namespace_bd1e7d57::message("Streaks/Specialist Bind ^2Enabled");
		self namespace_bd1e7d57::message("Press ^3[{+actionslot 3}] + [{+melee}]^7 to give Streaks", 1);
		self namespace_bd1e7d57::message("Press ^3[{+actionslot 4}] + [{+melee}]^7 to give Specialist", 1);
		self thread function_6529a157();
	}
	else
	{
		self.pers["streaks_bind"] = undefined;
		self namespace_bd1e7d57::message("Streaks/Specialist Bind ^1Disabled");
		self notify("hash_9c06561a");
	}
}

function function_7eba5f5d()
{
	self endon("disconnect");
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		kick(bot GetEntityNumber(), "EXE_PLAYERKICKED");
		wait(0.05);
	}
	self namespace_bd1e7d57::message("All Bots ^1Kicked");
}

function function_6598a964()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	var_be1e0790 = [];
	foreach(bot in bots)
	{
		if(bot.team == self.team)
		{
			var_be1e0790[var_be1e0790.size] = bot;
		}
	}
	if(var_be1e0790.size == 0)
	{
		var_be1e0790 = bots;
	}
	var_6ad82752 = var_be1e0790[RandomInt(var_be1e0790.size)];
	kick(var_6ad82752 GetEntityNumber(), "EXE_PLAYERKICKED");
	self namespace_bd1e7d57::message("Bot ^1Kicked");
}

function function_36e1f78()
{
	bots = namespace_bd1e7d57::function_a426e654("alive");
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots alive :(");
		return;
	}
	var_be1e0790 = [];
	foreach(bot in bots)
	{
		if(level.teambased && bot.team != self.team)
		{
			var_be1e0790[var_be1e0790.size] = bot;
		}
	}
	if(var_be1e0790.size == 0)
	{
		var_be1e0790 = bots;
	}
	var_6e953fcf = var_be1e0790[RandomInt(var_be1e0790.size)];
	var_6e953fcf SetOrigin(self namespace_bd1e7d57::function_d3902d4c());
	var_6e953fcf FreezeControls(1);
	self namespace_bd1e7d57::message("^2Teleported ^7Bot: " + var_6e953fcf.name);
}

function function_4f02155f()
{
	bots = namespace_bd1e7d57::function_a426e654("alive");
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots alive :(");
		return;
	}
	foreach(bot in bots)
	{
		bot SetOrigin(self namespace_bd1e7d57::function_d3902d4c());
	}
	self namespace_bd1e7d57::message("^2Teleported ^7All Bots");
}

function RevivePlayer(player)
{
	if(isalive(player))
	{
		self namespace_bd1e7d57::message("^1" + player.name + " is already alive!");
		return;
	}
	player thread [[level.spawnPlayer]]();
	self namespace_bd1e7d57::message("^2Revived ^7" + player.name);
}

function killplayer(player)
{
	if(isdefined(player))
	{
		if(!isalive(player))
		{
			self namespace_bd1e7d57::message("^1Player is not alive!");
			return;
		}
		player suicide();
		self namespace_bd1e7d57::message(player namespace_bd1e7d57::getName() + " ^1Killed");
		return;
	}
	self suicide();
}

function function_5d805918(player)
{
	name = player namespace_bd1e7d57::getName();
	kick(player GetEntityNumber(), "EXE_PLAYERKICKED");
	self namespace_bd1e7d57::message(name + " ^1Kicked");
	wait(0.05);
	self _MENU::function_9f479280("Players Menu");
}

function function_b76292e4(player)
{
	if(!isalive(player))
	{
		self namespace_bd1e7d57::message("^1Player is not alive!");
		return;
	}
	self SetOrigin(player.origin);
	self SetPlayerAngles(player.angles);
	self namespace_bd1e7d57::message("^2Teleported ^7to: " + player namespace_bd1e7d57::getName());
}

function function_284a6726(player)
{
	if(!isalive(player))
	{
		self namespace_bd1e7d57::message("^1Player is not alive!");
		return;
	}
	player SetOrigin(self.origin);
	player SetPlayerAngles(self.angles);
	self namespace_bd1e7d57::message("^2Teleported ^7" + player namespace_bd1e7d57::getName() + " to You");
}

function function_31211fac(player)
{
	if(!isalive(player))
	{
		self namespace_bd1e7d57::message("^1Player is not alive!");
		return;
	}
	player SetOrigin(self namespace_bd1e7d57::function_d3902d4c());
	self namespace_bd1e7d57::message("^2Teleported ^7" + player namespace_bd1e7d57::getName() + " to Crosshairs");
}

function function_864b3c9f(player)
{
	if(!isalive(player))
	{
		self namespace_bd1e7d57::message("^1Player is not alive!");
		return;
	}
	player FreezeControls(1);
	self namespace_bd1e7d57::message(player namespace_bd1e7d57::getName() + " ^2Frozen");
}

function function_a735567e(player)
{
	if(!isalive(player))
	{
		self namespace_bd1e7d57::message("^1Player is not alive!");
		return;
	}
	player FreezeControls(0);
	player FreezeControlsAllowLook(0);
	self namespace_bd1e7d57::message(player namespace_bd1e7d57::getName() + " ^1Unfrozen");
}

function maxAmmo()
{
	var_a4ca8789 = self GetCurrentWeapon();
	sec = self getCurrentOffhand();
	self giveMaxAmmo(var_a4ca8789);
	self giveMaxAmmo(sec);
	self namespace_bd1e7d57::message("Ammo ^2Refilled");
}

function function_15af110b()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		bot FreezeControls(1);
	}
	self namespace_bd1e7d57::message("Freeze Bots Position ^2Enabled");
}

function function_6193775c()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		bot FreezeControls(0);
	}
	self namespace_bd1e7d57::message("Freeze Bots Position ^1Disabled");
}

function function_52b3eff2()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		bot.pers["spawn_position"] = bot.origin;
	}
	self namespace_bd1e7d57::message("Bots Spawn Position ^2Saved");
}

function function_4198eede()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		bot.pers["spawn_position"] = undefined;
	}
	self namespace_bd1e7d57::message("Bots Spawn Position ^2Reset");
}

function function_c4698fe6()
{
	bots = namespace_bd1e7d57::function_a426e654();
	if(bots.size == 0)
	{
		self namespace_bd1e7d57::message("^1No Bots :(");
		return;
	}
	foreach(bot in bots)
	{
		bot SetPlayerAngles(VectorToAngles(self GetTagOrigin("j_head") - bot GetTagOrigin("j_head")));
	}
	self namespace_bd1e7d57::message("Bots are looking at ^6You");
}
function function_5fe1252b()
{
	if(isdefined(self.pers["spawn_position"]))
	{
		self SetOrigin(self.pers["spawn_position"]);
		self FreezeControls(1);
	}
}

function dropweapon()
{
	self dropItem(self GetCurrentWeapon());
	self namespace_bd1e7d57::message("Weapon ^1Dropped");
}


function function_e11e9b0f()
{
	self TakeWeapon(self GetCurrentWeapon());
	self namespace_bd1e7d57::message("Weapon ^1Taken");
}

function function_62a143c3(var_3da1b631)
{
	if(var_3da1b631)
	{
		self namespace_bd1e7d57::message("Magazine Set to^1 1");
	}
	self SetWeaponAmmoClip(self GetCurrentWeapon(), 1);
}

function function_fcb76e97(weaponName)
{
	options = self GetWeaponOptions(self GetCurrentWeapon());
	if(!isdefined(self.pers["third_weapon"]))
	{
		self dropItem(self GetCurrentWeapon());
	}
	weapon = GetWeapon(weaponName);
	self GiveWeapon(weapon, options);
	self giveMaxAmmo(weapon);
	self SwitchToWeapon(weapon);
	self namespace_bd1e7d57::message(weaponName + " ^2Given");
}

function function_3ceeb21d()
{
	var_68f6b1c7 = GetDvarInt("toggle_pickup_radius", 128);
	if(var_68f6b1c7 == 128)
	{
		SetDvar("toggle_pickup_radius", 240);
		SetDvar("player_useRadius", 240);
		level namespace_bd1e7d57::message("Pickup Radius set to ^6Far ^1(6m)");
	}
	else if(var_68f6b1c7 == 240)
	{
		SetDvar("toggle_pickup_radius", 400);
		SetDvar("player_useRadius", 400);
		level namespace_bd1e7d57::message("Pickup Radius set to ^6Very Far ^1(9m)");
	}
	else
	{
		SetDvar("toggle_pickup_radius", 128);
		SetDvar("player_useRadius", 128);
		level namespace_bd1e7d57::message("Pickup Radius set to ^6Normal ^1(3m)");
	}
}

function function_87f998db()
{
	if(GetDvarInt("toggle_sniper_damage", 0) == 0)
	{
		SetDvar("toggle_sniper_damage", 1);
		level namespace_bd1e7d57::message("Sniper Only Damage ^2Enabled");
	}
	else
	{
		SetDvar("toggle_sniper_damage", 0);
		level namespace_bd1e7d57::message("Sniper Only Damage ^1Disabled");
	}
}

function function_df9ec412()
{
	if(GetDvarInt("toggle_post_game_damage", 0) == 0)
	{
		SetDvar("toggle_post_game_damage", 1);
		level namespace_bd1e7d57::message("Post Game Damage ^1Disabled");
	}
	else
	{
		SetDvar("toggle_post_game_damage", 0);
		level namespace_bd1e7d57::message("Post Game Damage ^2Enabled");
	}
}

function function_c86649fd()
{
	if(GetDvarInt("toggle_timescale_killcam", 0) == 0)
	{
		SetDvar("toggle_timescale_killcam", 1);
		level namespace_bd1e7d57::message("Timescale During Killcam ^2Enabled");
	}
	else
	{
		SetDvar("toggle_timescale_killcam", 0);
		level namespace_bd1e7d57::message("Timescale During Killcam ^1Disabled");
	}
}

function function_3c485487()
{
	if(!isdefined(self.pers["third_weapon"]))
	{
		self.pers["third_weapon"] = 1;
		self namespace_bd1e7d57::message("Drop Current Weapon ^1Disabled");
	}
	else
	{
		self.pers["third_weapon"] = undefined;
		self namespace_bd1e7d57::message("Drop Current Weapon ^2Enabled");
	}
}

function function_c77163ab()
{
	if(!isdefined(self.pers["freeze_round_end"]))
	{
		self.pers["freeze_round_end"] = 1;
		self thread function_69dae33f();
		self namespace_bd1e7d57::message("MW2 Round End Freeze ^2Enabled");
	}
	else
	{
		self notify("hash_e850e50c");
		self.pers["freeze_round_end"] = undefined;
		self namespace_bd1e7d57::message("MW2 Round End Freeze ^1Disabled");
	}
}

function function_69dae33f()
{
	self endon("disconnect");
	self endon("hash_e850e50c");
	level waittill("game_ended");
	wait(1.5);
	self FreezeControls(1);
}

function help()
{
	self endon("disconnect");
	self namespace_bd1e7d57::message("Press^3 [{+actionslot 1}] ^7While Aiming To Open Menu");
	wait(1);
	self namespace_bd1e7d57::message("Press^3 [{+activate}] ^7To Select", 1);
	wait(1);
	self namespace_bd1e7d57::message("Press^3 [{+actionslot 1}] ^7To Go Up", 1);
	wait(1);
	self namespace_bd1e7d57::message("Press^3 [{+actionslot 2}] ^7To Go Down", 1);
	wait(1);
	self namespace_bd1e7d57::message("Press^3 [{+stance}] ^7To Go Back", 1);
}

function function_dec31dfe()
{
	self namespace_bd1e7d57::message("Follow me on Twitter ^5twitter.com/BradLikesTweets");
}

function function_d2065837()
{
	self namespace_bd1e7d57::message("Join our Discord Server! ^5brad.stream/discord");
}

function support()
{
	self namespace_bd1e7d57::message("For support, join our Discord ^5brad.stream/discord");
}

function function_221175e6()
{
	if(!isdefined(self.pers["unlimited_equip"]))
	{
		self.pers["unlimited_equip"] = 1;
		self namespace_bd1e7d57::message("Unlimited Equipment ^2Enabled");
		self thread function_340e2960();
	}
	else
	{
		self.pers["unlimited_equip"] = undefined;
		self namespace_bd1e7d57::message("Unlimited Equipment ^1Disabled");
		self notify("hash_34c417e0");
	}
}

function function_bff85051()
{
	self endon("disconnect");
	if(!isdefined(self.pers["bind_text"]))
	{
		self.pers["bind_text"] = 1;
		self namespace_bd1e7d57::message("Text Popup for Binds ^1Disabled");
	}
	else
	{
		self.pers["bind_text"] = undefined;
		self namespace_bd1e7d57::message("Text Popup for Binds ^2Enabled");
	}
}

function function_340e2960()
{
	self endon("disconnect");
	self endon("hash_34c417e0");
	while(self getCurrentOffhand() != level.weaponNone)
	{
		self giveMaxAmmo(self getCurrentOffhand());
		wait(0.5);
	}
}

function function_f2200715()
{
	if(!isdefined(self.pers["unlimited_ammo"]))
	{
		self thread unlimitedammo();
		self namespace_bd1e7d57::message("Unlimited Ammo ^2Enabled");
		self.pers["unlimited_ammo"] = 1;
	}
	else
	{
		self.pers["unlimited_ammo"] = undefined;
		self namespace_bd1e7d57::message("Unlimited Ammo ^1Disabled");
		self notify("hash_72e3e287");
	}
}

function unlimitedammo()
{
	self endon("disconnect");
	self endon("hash_72e3e287");
	for(;;)
	{
		currentWeapon = self GetCurrentWeapon();
		if(currentWeapon != level.weaponNone)
		{
			self SetWeaponAmmoClip(currentWeapon, currentWeapon.clipSize);
			self giveMaxAmmo(currentWeapon);
		}
		wait(0.1);
	}
}

function giveHeroWeapon(var_3da1b631)
{
	foreach(weapon in self GetWeaponsList())
	{
		if(weapon.isgadget)
		{
			slot = self GadgetGetSlot(weapon);
			self GadgetPowerSet(slot, 100);
			self ability_player::gadget_ready(slot, weapon);
		}
	}
	if(!isdefined(self.pers["bind_text"]) || var_3da1b631)
	{
		self namespace_bd1e7d57::message("Specitalist ^2Given");
	}
}

function function_215339b5()
{
	var_21132448 = GetWeapon("lmg_light");
	self GiveWeapon(var_21132448);
	self dropItem(var_21132448);
	self namespace_bd1e7d57::message("Canswap ^1Dropped");
}

function function_cb61fb1d()
{
	if(!isdefined(self.pers["unlimited_boost"]))
	{
		self thread function_c3fe27aa();
		self namespace_bd1e7d57::message("Unlimited Boost ^2Enabled");
		self.pers["unlimited_boost"] = 1;
	}
	else
	{
		self notify("hash_8c7c6c32");
		self namespace_bd1e7d57::message("Unlimited Boost ^1Disabled");
		self.pers["unlimited_boost"] = undefined;
	}
}

function function_c3fe27aa()
{
	self endon("disconnect");
	self endon("hash_8c7c6c32");
	while(isdefined(self) && isalive(self))
	{
		if(self IsDoubleJumping())
		{
			self setdoublejumpenergy(100);
			wait(0.05);
		}
		wait(0.05);
	}
}

function function_13f626d5()
{
	if(!isdefined(self.pers["console_fov"]))
	{
		self.pers["console_fov"] = 1;
		self namespace_bd1e7d57::message("Console FOV ^2Enabled");
		if(self IsHost())
		{
			level.var_2e02fdd5 = 1;
			if(!isdefined(self.pers["smarr_fov"]))
			{
				self thread function_3d1a8007();
			}
		}
		self function_3cc384fa();
	}
	else
	{
		self.pers["console_fov"] = undefined;
		self namespace_bd1e7d57::message("Console FOV ^1Disabled");
		self notify("hash_9c80e10f");
		if(self IsHost())
		{
			level.var_2e02fdd5 = 0;
			SetDvar("cg_fov", 80);
			SetDvar("cg_fov_default", 80);
		}
	}
}

function function_3b588dbd()
{
	if(isdefined(self.pers["console_fov"]))
	{
		self namespace_bd1e7d57::message("^1Disable Console FOV Toggle First");
		return;
	}
	if(!isdefined(self.pers["smarr_fov"]))
	{
		self.pers["smarr_fov"] = 1;
		self namespace_bd1e7d57::message("Console FOV Behavior Changed to: ^2Third Person");
		self notify("hash_9c80e10f");
	}
	else
	{
		self.pers["smarr_fov"] = undefined;
		self namespace_bd1e7d57::message("Console FOV Behavior Changed to: ^2Default");
	}
}

function function_3d1a8007()
{
	self endon("disconnect");
	self endon("hash_9c80e10f");
	level endon("game_ended");
	while(GetDvarInt("cg_fov") != 40)
	{
		SetDvar("cg_fov", 40);
		if(GetDvarInt("cg_fov_default") != 80)
		{
			SetDvar("cg_fov_default", 80);
		}
		wait(0.05);
	}
}

function function_f5de707a()
{
	if(level.var_2e02fdd5)
	{
		SetDvar("cg_fov", 80);
		SetDvar("cg_gun_x", 1.55);
		SetDvar("cg_fov_default", 80);
	}
}

function function_3cc384fa()
{
	if(self IsHost() && !isdefined(self.pers["smarr_fov"]))
	{
		return;
	}
	if(isdefined(self.pers["console_fov"]))
	{
		self SetClientThirdPerson(1);
		self resetFov();
		wait(0.05);
		self SetClientThirdPerson(0);
		self resetFov();
	}
}

function fastrestart()
{
	map_restart(0);
}

function function_aa8fcac6()
{
	self endon("disconnect");
	self endon("hash_be9d3d9b");
	self endon("death");
	launcher = GetWeapon("launcher_standard");
	self GiveWeapon(launcher);
	self giveMaxAmmo(launcher);
	self SwitchToWeapon(launcher);
	for(;;)
	{
		self waittill("missile_fire", missile, weapon);
		if(weapon == launcher)
		{
			self iprintln("Press ^3[{+gostand}] ^7to jump off!");
			self TakeWeapon(weapon);
			self Unlink();
			self playerLinkTo(missile);
			self EnableInvulnerability();
			self thread function_535eb5d8();
			missile waittill("death");
			self DisableInvulnerability();
			self Unlink();
			self notify("hash_be9d3d9b");
		}
		wait(0.05);
	}
}

function function_535eb5d8()
{
	self endon("disconnect");
	self endon("hash_be9d3d9b");
	self endon("death");
	while(self JumpButtonPressed())
	{
		self Unlink();
		self DisableInvulnerability();
		self notify("hash_be9d3d9b");
		wait(0.05);
	}
}

function function_ad47337f()
{
	if(!isdefined(self.pers["rocket_on_spawn"]))
	{
		self.pers["rocket_on_spawn"] = 1;
		self namespace_bd1e7d57::message("Rocket On Spawn ^2Enabled");
	}
	else
	{
		self.pers["rocket_on_spawn"] = undefined;
		self namespace_bd1e7d57::message("Rocket On Spawn ^1Disabled");
	}
}

function function_f11c7196()
{
	self endon("disconnect");
	if(!isdefined(self.pers["third_person"]))
	{
		self SetClientThirdPerson(1);
		self SetClientThirdPersonAngle(354);
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
		self.pers["third_person"] = 1;
		self namespace_bd1e7d57::message("Third Person ^2Enabled");
	}
	else
	{
		self SetClientThirdPerson(0);
		self SetClientThirdPersonAngle(0);
		self setDepthOfField(0, 0, 512, 4000, 4, 0);
		self.pers["third_person"] = undefined;
		self namespace_bd1e7d57::message("Third Person ^1Disabled");
	}
	self resetFov();
}

function LOW_GRAVITY()
{
	if(GetDvarInt("toggle_low_gravity", 0) == 0)
	{
		SetDvar("bg_gravity", 250);
		SetDvar("toggle_low_gravity", 1);
		level namespace_bd1e7d57::message("Low Gravity ^2Enabled");
	}
	else
	{
		SetDvar("bg_gravity", 800);
		SetDvar("toggle_low_gravity", 0);
		level namespace_bd1e7d57::message("Low Gravity ^1Disabled");
	}
}

function function_8ddc08d9()
{
	globallogic::exit_level();
}

function function_c10c611()
{
	if(isdefined(self.pers["canswap_class"]) || self.pers["binds"]["nac"]["slot"] != 0)
	{
		if(isdefined(self.pers["canswap_class"]))
		{
			self namespace_bd1e7d57::message("^1Disable Canswap for Class Binds First");
		}
		else
		{
			self namespace_bd1e7d57::message("^1Disable Nac Binds First");
		}
		return;
	}
	if(!isdefined(self.pers["canswap_always"]))
	{
		self.pers["canswap_always"] = 1;
		self thread function_fa1ddaed();
		self namespace_bd1e7d57::message("Canswap on Weapon Change ^2Enabled");
	}
	else
	{
		self.pers["canswap_always"] = undefined;
		self notify("hash_807890a5");
		self notify("hash_a8aaaccb");
		self namespace_bd1e7d57::message("Canswap on Weapon Change ^1Disabled");
	}
}

function function_fa1ddaed()
{
	self notify("hash_807890a5");
	self endon("disconnect");
	self endon("hash_807890a5");
	while(self IsSwitchingWeapons() && self GetCurrentWeapon() != level.weaponNone)
	{
		currentWeapon = self GetCurrentWeapon();
		self thread function_fbe1b20b(currentWeapon);
		self notify("hash_807890a5");
		wait(0.01);
	}
}

function function_fbe1b20b(currentWeapon)
{
	self notify("hash_a8aaaccb");
	self endon("disconnect");
	self endon("hash_a8aaaccb");
	while(currentWeapon != self GetCurrentWeapon() && self GetCurrentWeapon() != level.weaponNone)
	{
		self namespace_98fc914::function_10cb2eb9();
		self thread function_fa1ddaed();
		self notify("hash_a8aaaccb");
		wait(0.01);
	}
}

function function_d4122317()
{
	if(GetDvarInt("toggle_print_distance", 0) == 0)
	{
		SetDvar("toggle_print_distance", 1);
		level namespace_bd1e7d57::message("Kill Distance ^2Enabled");
	}
	else
	{
		SetDvar("toggle_print_distance", 0);
		level namespace_bd1e7d57::message("Kill Distance ^1Disabled");
	}
}

function function_3c32b0a1()
{
	if(GetDvarInt("toggle_match_bonus", 0) == 0)
	{
		SetDvar("toggle_match_bonus", 1);
		level namespace_bd1e7d57::message("Match Bonus ^2Enabled");
	}
	else
	{
		SetDvar("toggle_match_bonus", 0);
		level namespace_bd1e7d57::message("Match Bonus ^1Disabled");
	}
}

function function_aab20fe4()
{
	if(GetDvarInt("toggle_infinite_range", 8192) == 8192)
	{
		SetDvar("bulletrange", 65536);
		SetDvar("toggle_infinite_range", 65536);
		level namespace_bd1e7d57::message("Infinite Bullet Range ^2Enabled");
	}
	else
	{
		SetDvar("bulletrange", 8192);
		SetDvar("toggle_infinite_range", 8192);
		level namespace_bd1e7d57::message("Infinite Bullet Range ^1Disabled");
	}
}

function function_65d88a9e()
{
	if(GetDvarString("g_gametype") != "dm" && GetDvarString("g_gametype") != "tdm")
	{
		self namespace_bd1e7d57::message("^1Unsupported Gamemode!");
		return;
	}
	if(GetDvarInt("toggle_bots_kill_last", 0) == 0)
	{
		SetDvar("toggle_bots_kill_last", 1);
		level namespace_bd1e7d57::message("Bots Can't Kill Last ^2Enabled");
	}
	else
	{
		SetDvar("toggle_bots_kill_last", 0);
		level namespace_bd1e7d57::message("Bots Can't Kill Last ^1Disabled");
	}
}

function function_68149d31(perk, name)
{
	if(!isdefined(self.pers[perk]))
	{
		self function_c389b506(perk);
		self.pers[perk] = 1;
		self namespace_bd1e7d57::message(name + " ^2Enabled");
	}
	else
	{
		self function_6a8046b8(perk);
		self.pers[perk] = undefined;
		self namespace_bd1e7d57::message(name + " ^1Disabled");
	}
}

function function_c389b506(perk)
{
	if(isdefined(level.var_46955f4b[perk]))
	{
		foreach(var_a7870d9c in level.var_46955f4b[perk])
		{
			self setPerk(var_a7870d9c);
		}
		return;
	}
	self setPerk(perk);
}

function function_6a8046b8(perk)
{
	if(isdefined(level.var_46955f4b[perk]))
	{
		foreach(var_a7870d9c in level.var_46955f4b[perk])
		{
			self unsetPerk(var_a7870d9c);
		}
		return;
	}
	self unsetPerk(perk);
}

function function_33579a2(perk1, perk2, perk3, var_6c9bd533, var_46995aca)
{
	if(!isdefined(level.var_46955f4b))
	{
		level.var_46955f4b = [];
	}
	perk_array = [];
	if(isdefined(perk1))
	{
		perk_array[perk_array.size] = perk1;
	}
	if(isdefined(perk2))
	{
		perk_array[perk_array.size] = perk2;
	}
	if(isdefined(perk3))
	{
		perk_array[perk_array.size] = perk3;
	}
	if(isdefined(var_6c9bd533))
	{
		perk_array[perk_array.size] = var_6c9bd533;
	}
	if(isdefined(var_46995aca))
	{
		perk_array[perk_array.size] = var_46995aca;
	}
	level.var_46955f4b[perk1] = perk_array;
}

function function_b08504aa(toggle, weapon)
{
	if(toggle && isdefined(weapon))
	{
		self.pers["afterhit_weapon"] = weapon;
		self namespace_bd1e7d57::message("Set to " + weapon);
		if(!isdefined(self.pers["afterhit"]))
		{
			self namespace_bd1e7d57::message("Afterhit ^2Enabled");
		}
		self.pers["afterhit"] = 1;
		self namespace_bd1e7d57::message("Afterhit ^2Set");
	}
	else
	{
		self.pers["afterhit"] = undefined;
		self namespace_bd1e7d57::message("Afterhit ^1Disabled");
	}
}

function function_9791bd34()
{
	if(!isdefined(self.pers["afterhit"]) || !isdefined(self.pers["afterhit_weapon"]))
	{
		self namespace_bd1e7d57::message("^1Afterhit not set!");
		return;
	}
	wait(0.05);
	var_23b34217 = function_e89ca149(self.pers["afterhit_weapon"]);
	if(isdefined(var_23b34217))
	{
		self thread [[var_23b34217]]();
	}
	else
	{
		function_7e65627b(self.pers["afterhit_weapon"]);
	}
}

function function_29d880cf()
{
	if(!isalive(self) || !isdefined(self.pers["afterhit_weapon"]))
	{
		return;
	}
	wait(0.05);
	var_23b34217 = function_e89ca149(self.pers["afterhit_weapon"]);
	if(isdefined(var_23b34217))
	{
		self thread [[var_23b34217]]();
	}
	else
	{
		function_7e65627b(self.pers["afterhit_weapon"]);
	}
	wait(0.35);
	if(level.gameEnded)
	{
		self globallogic_player::freezePlayerForRoundEnd();
	}
	self.var_4ba2b8f1 = undefined;
}

function function_7e65627b(weapon)
{
	weapon = GetWeapon(weapon);
	options = self GetWeaponOptions(self GetCurrentWeapon());
	self TakeWeapon(self GetCurrentWeapon());
	self GiveWeapon(weapon, options);
	self SetWeaponAmmoClip(weapon, weapon.clipSize);
	self giveMaxAmmo(weapon);
	self SwitchToWeaponImmediate(weapon);
}

function function_e89ca149(gadget)
{
	func = [];
	func["gadget_flashback"] = &namespace_98fc914::function_b979fda5;
	func["gadget_clone"] = &namespace_98fc914::function_8e9bbbed;
	func["gadget_camo"] = &namespace_98fc914::function_fe2f8e06;
	func["gadget_heat_wave"] = &namespace_98fc914::function_68d5f507;
	func["gadget_armor"] = &namespace_98fc914::function_bf547e0c;
	func["gadget_resurrect"] = &namespace_98fc914::function_c1bce9b8;
	if(isdefined(func[gadget]))
	{
		return func[gadget];
	}
	return undefined;
}

function function_d4e01fda()
{
	currentWeapon = [];
	currentWeapon["weapon"] = self GetCurrentWeapon();
	currentWeapon["clip"] = self GetWeaponAmmoClip(self GetCurrentWeapon());
	currentWeapon["stock"] = self GetWeaponAmmoStock(self GetCurrentWeapon());
	currentWeapon["options"] = self GetWeaponOptions(self GetCurrentWeapon());
	self.pers["third_weapon"] = currentWeapon;
	self namespace_bd1e7d57::message("Third Weapon ^2Set ^7to: ^6" + currentWeapon["weapon"].displayName);
}

function function_c23e5145()
{
	if(!isdefined(self.pers["third_weapon"]))
	{
		self namespace_bd1e7d57::message("^1Third Weapon not set!");
		return;
	}
	var_9c27d874 = self.pers["third_weapon"];
	self GiveWeapon(var_9c27d874["weapon"], var_9c27d874["options"]);
	self SetWeaponAmmoClip(var_9c27d874["weapon"], var_9c27d874["clip"]);
	self SetWeaponAmmoStock(var_9c27d874["weapon"], var_9c27d874["stock"]);
	self SwitchToWeapon(var_9c27d874["weapon"]);
	self namespace_bd1e7d57::message("Third Weapon ^2Given");
}

function function_9168d4db(Vision, name)
{
	self UseServerVisionset(1);
	self SetVisionSetForPlayer(Vision);
	self.pers["vision"] = Vision;
	if(name == "Reset")
	{
		self.pers["vision"] = undefined;
		self namespace_bd1e7d57::message("Vision ^1Reset");
		return;
	}
	self namespace_bd1e7d57::message(name + " Vision ^2Set");
}

function function_82bbb3e1()
{
	if(GetDvarInt("toggle_almost_hit", 0) == 0)
	{
		SetDvar("toggle_almost_hit", 1);
		level thread function_1aa4f3b3();
		players = namespace_bd1e7d57::function_d47e142e();
		foreach(player in players)
		{
			player thread function_deb9e622();
		}
		level namespace_bd1e7d57::message("Almost Hits ^2Enabled");
	}
	else
	{
		SetDvar("toggle_almost_hit", 0);
		level notify("hash_fde72288");
		level namespace_bd1e7d57::message("Almost Hits ^1Disabled");
	}
}

function function_deb9e622()
{
	self endon("disconnect");
	level endon("hash_fde72288");
	level endon("game_ended");
	range = 120;
	for(;;)
	{
		self waittill("weapon_fired", weapon);
		if(util::getWeaponClass(weapon) != "weapon_sniper")
		{
			wait(0.05);
			continue;
		}
		wait(0.05);
		var_c7fcc76b = undefined;
		var_930f2e97 = self namespace_bd1e7d57::function_d3902d4c();
		foreach(player in level.players)
		{
			if(player.team == self.team && level.teambased || !isalive(player) || player == self)
			{
				continue;
			}
			if(isdefined(var_c7fcc76b))
			{
				if(closer(var_930f2e97, player.origin, var_c7fcc76b.origin))
				{
					var_c7fcc76b = player;
				}
				continue;
			}
			var_c7fcc76b = player;
		}
		if(isdefined(var_c7fcc76b))
		{
			if(Distance(var_c7fcc76b.origin, var_930f2e97) <= range)
			{
				Distance = Int(Distance(self.origin, var_c7fcc76b.origin) * 0.0254);
				self namespace_bd1e7d57::message("^6You ^7almost hit ^6" + var_c7fcc76b.name + "! ^1(" + Distance + "m)");
				if(!var_c7fcc76b util::is_bot())
				{
					var_c7fcc76b namespace_bd1e7d57::message("^6" + self.name + " ^7almost billed ^6You! ^1(" + Distance + "m)");
				}
				self.var_f766edbf++;
			}
		}
	}
}

function function_1aa4f3b3()
{
	level endon("hash_fde72288");
	level waittill("game_ended");
	players = namespace_bd1e7d57::function_d47e142e();
	foreach(player in players)
	{
		player thread function_bd74a88f();
	}
}

function function_bd74a88f()
{
	self endon("disconnect");
	if(self.var_f766edbf == 0 || self.var_6c2dc41d || GetDvarInt("toggle_almost_hit", 0) == 0)
	{
		return;
	}
	wait(2);
	self iprintln("^6You ^7almost hit ^6" + self.var_f766edbf + " time(s) ^7this game!");
}

function function_12b2d29f()
{
	wait(0.05);
	foreach(weapon in self GetWeaponsList())
	{
		if(isdefined(weapon.isgadget) && weapon.isgadget && weapon.rootweapon.name == "gadget_resurrect")
		{
			self TakeWeapon(weapon);
		}
	}
	self unsetPerk("specialty_gpsjammer");
	self unsetPerk("specialty_stunprotection");
	self setPerk("specialty_fallheight");
}

function function_aff37465()
{
	self notify("hash_a6ca2bf8");
	self endon("disconnect");
	self endon("death");
	self endon("hash_a6ca2bf8");
	level endon("game_ended");
	while(self IsOnGround() && !self IsWallRunning() && !self IsPlayerSwimming())
	{
		self.var_781779ba = self.origin;
		wait(5);
	}
}

function function_9516f9a5()
{
	if(GetDvarInt("toggle_bot_sui", 0) == 0)
	{
		SetDvar("toggle_bot_sui", 1);
		level namespace_bd1e7d57::message("Bots Can't Sui ^2Enabled");
	}
	else
	{
		SetDvar("toggle_bot_sui", 0);
		level namespace_bd1e7d57::message("Bots Can't Sui ^1Disabled");
	}
}

function function_3e019310()
{
	if(GetDvarInt("toggle_no_bot_damage", 0) == 0)
	{
		SetDvar("toggle_no_bot_damage", 1);
		level namespace_bd1e7d57::message("Bots Can't Damage Players ^2Enabled");
	}
	else
	{
		SetDvar("toggle_no_bot_damage", 0);
		level namespace_bd1e7d57::message("Bots Can't Damage Players ^1Disabled");
	}
}

function function_233ae540()
{
	if(!isdefined(self.pers["constant_uav"]))
	{
		self setClientUIVisibilityFlag("g_compassShowEnemies", 2);
		self namespace_bd1e7d57::message("Constant UAV ^2Enabled");
		self.pers["constant_uav"] = 1;
	}
	else
	{
		self setClientUIVisibilityFlag("g_compassShowEnemies", 0);
		self namespace_bd1e7d57::message("Constant UAV ^1Disabled");
		self.pers["constant_uav"] = undefined;
	}
}

function function_77cdd68a(player, stance)
{
	self notify("hash_20517631");
	self endon("disconnect");
	level endon("game_ended");
	self endon("hash_20517631");
	if(!isdefined(player) || !isPlayer(player) || !isalive(player))
	{
		self namespace_bd1e7d57::message("^1Could not change player stance");
		return;
	}
	if(stance == "stand")
	{
		player AllowStand(1);
		if(player util::is_bot())
		{
			player FreezeControls(0);
			player FreezeControlsAllowLook(0);
			var_9082b920 = GetTime() + 2500;
			while(player GetStance() != "stand" && GetTime() < var_9082b920)
			{
				wait(0.05);
			}
			player FreezeControlsAllowLook(1);
		}
	}
	else if(stance == "crouch")
	{
		player AllowCrouch(1);
		if(player util::is_bot())
		{
			player FreezeControls(0);
			player FreezeControlsAllowLook(0);
			wait(0.05);
			var_9082b920 = GetTime() + 2500;
			while(player GetStance() != "crouch" && GetTime() < var_9082b920)
			{
				player SetStance(stance);
				player bot::press_crouch_button();
				wait(0.05);
			}
			player FreezeControlsAllowLook(1);
		}
	}
	else if(stance == "prone")
	{
		player AllowProne(1);
		if(player util::is_bot())
		{
			self namespace_bd1e7d57::message("^1Unsupported on bots!");
			return;
		}
	}
	player SetStance(stance);
	self namespace_bd1e7d57::message("Player stance set to: ^2" + stance);
}