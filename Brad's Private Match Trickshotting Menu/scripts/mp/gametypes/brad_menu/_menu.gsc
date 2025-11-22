#using scripts\mp\gametypes\brad_menu\_binds;
#using scripts\mp\gametypes\brad_menu\_eb;
#using scripts\mp\gametypes\brad_menu\_funcs;
#using scripts\mp\gametypes\brad_menu\_oom;
#using scripts\mp\gametypes\brad_menu\_snd;
#using scripts\mp\gametypes\brad_menu\_spawn;
#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\mp\gametypes\brad_menu\_verify;
#using scripts\shared\util_shared;

#namespace _MENU;

function function_874ae686()
{
	self.menu = spawnstruct();
	self.menu.option = [];
	self.menu.func = [];
	self.menu.arg1 = [];
	self.menu.arg2 = [];
	self.menu.var_806cc01d = [];
	self.menu.elem = [];
	self.menu.var_25a9347b = [];
	self.menu.open = 0;
	self.menu.var_6640885 = "Closed";
	self.var_6dcd0fb8 = spawnstruct();
	self.var_6dcd0fb8.elem = [];
	self.var_6dcd0fb8.open = 0;
	self function_2f95538e();
	self thread function_7151a7ab();
}

function function_2125a00d()
{
	self function_4506dea5();
	self FreezeControls(0);
	self.menu.var_6640885 = "Main Menu";
	self.menu.elem["title_bg"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 50, "white", 180, 30, (1, 0, 1), 1, 0);
	self.menu.elem["menu_bg"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 80, "white", 180, 218, (0, 0, 0), 0.6, 0);
	self.menu.elem["menu_title_bg"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 80, "white", 180, 20, (0, 0, 0), 0.5, 1);
	self.menu.elem["left_bar"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 50, "white", 2, 248, (1, 0, 1), 1, 2);
	self.menu.elem["right_bar"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 280, 50, "white", 2, 248, (1, 0, 1), 1, 2);
	self.menu.elem["top_bar"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 99, "white", 180, 2, (1, 0, 1), 1, 2);
	self.menu.elem["bottom_bar"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 297, "white", 182, 2, (1, 0, 1), 1, 2);
	self.menu.elem["scrollbar"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 100, "white", 180, 18, (1, 0, 1), 1, 1);
	self.menu.elem["title"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.6, "LEFT", "TOP", 120, 55, 2, 1, (1, 0, 0), "Brad's Private Match Menu");
	self.menu.elem["menu_title"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.5, "LEFT", "TOP", 105, 81, 2, 1, (1, 0, 0), self.menu.var_6640885);
	for(i = 0; i < 11; i++)
	{
		self.menu.elem["option"][i] = self namespace_bd1e7d57::function_c1c245d0("console", 1.5, "LEFT", "TOP", 105, 100 + i * 18, 2, 1, (0, 0, 0), "");
	}
	self.menu.elem["version"] = self namespace_bd1e7d57::function_c1c245d0("console", 1, "RIGHT", "TOP", 254, 285, 2, 1, (1, 0, 0), "^8v" + level.var_4abf90ed);
	self.menu.elem["made_by"] = self namespace_bd1e7d57::function_c1c245d0("console", 1, "LEFT", "TOP", 105, 298, 2, 1, (1, 0, 0), "Menu made by ^5@BradLikesTweets");
	self function_5f17d120();
	self.menu.open = 1;
}

function function_9f479280(menu, status)
{
	if(isdefined(status))
	{
		if(status == "Host")
		{
			if(!self namespace_93996bb7::function_bb9f3b9b())
			{
				self namespace_bd1e7d57::message("^1You must be host/co-host to access this!");
				return;
			}
		}
		if(status == "VIP")
		{
			if(!self namespace_93996bb7::function_cda3e662())
			{
				self namespace_bd1e7d57::message("You're not a ^3VIP!");
				self function_1896532d(0);
				return;
			}
		}
	}
	if(menu == "Players Menu")
	{
		self function_6c5d163a();
	}
	self.menu.var_6640885 = menu;
	self.menu.elem["menu_title"] setText(menu);
	self function_5f17d120();
}

function function_6c5d163a()
{
	self function_5add3549("Players Menu", "Main Menu");
	players = GetPlayers();
	var_15f3165d = 0;
	foreach(player in players)
	{
		if(player == self)
		{
			continue;
		}
		name = player namespace_bd1e7d57::getName();
		self addOption("Players Menu", name, &function_9f479280, name);
		self function_5add3549(name, "Players Menu");
		self addOption(name, "Revive Player", &namespace_363acd5d::RevivePlayer, player);
		self addOption(name, "Kill Player", &namespace_363acd5d::killplayer, player);
		self addOption(name, "Kick Player", &namespace_363acd5d::function_5d805918, player);
		self addOption(name, "Teleport to Player", &namespace_363acd5d::function_b76292e4, player);
		self addOption(name, "Teleport Player to Me", &namespace_363acd5d::function_284a6726, player);
		self addOption(name, "Teleport Player to Crosshairs", &namespace_363acd5d::function_31211fac, player);
		self addOption(name, "Freeze Player", &namespace_363acd5d::function_864b3c9f, player);
		self addOption(name, "Unfreeze Player", &namespace_363acd5d::function_a735567e, player);
		self addOption(name, "Set Stance to Stand", &namespace_363acd5d::function_77cdd68a, player, "stand");
		self addOption(name, "Set Stance to Crouch", &namespace_363acd5d::function_77cdd68a, player, "crouch");
		self addOption(name, "Set Stance to Prone", &namespace_363acd5d::function_77cdd68a, player, "prone");
		if(!player util::is_bot() && !player IsHost() && self IsHost())
		{
			if(player namespace_93996bb7::function_bb9f3b9b())
			{
				self addOption(name, "Take Co-Host", &function_13b4f490, player);
			}
			else
			{
				self addOption(name, "Give Co-Host", &function_5f657bde, player);
			}
		}
		var_15f3165d++;
	}
	if(var_15f3165d == 0)
	{
		self addOption("Players Menu", "No Players!", &function_9f479280, "Main Menu");
	}
}

function function_de62df31()
{
	self function_fb34bd0();
	if(isdefined(self.pers["reset_scrollbar"]))
	{
		menus = getArrayKeys(self.menu.var_25a9347b);
		foreach(menu in menus)
		{
			self.menu.var_25a9347b[menu] = 0;
		}
	}
	self.menu.var_6640885 = "Closed";
	self.menu.open = 0;
	self notify("menu_closed");
}

function function_7151a7ab()
{
	self endon("disconnect");
	level endon("game_ended");
	while(!self.menu.open)
	{
		if(self AdsButtonPressed() && self ActionSlotOneButtonPressed())
		{
			self function_2125a00d();
		}
		continue;
		if(self StanceButtonPressed() || self meleeButtonPressed())
		{
			if(!isdefined(self.menu.var_806cc01d[self.menu.var_6640885]))
			{
				self function_de62df31();
			}
			else
			{
				self function_9f479280(self.menu.var_806cc01d[self.menu.var_6640885]);
			}
			wait(0.2);
		}
		else if(self ActionSlotOneButtonPressed())
		{
			self.menu.var_25a9347b[self.menu.var_6640885]--;
			if(self.menu.var_25a9347b[self.menu.var_6640885] < 0)
			{
				self.menu.var_25a9347b[self.menu.var_6640885] = self.menu.option[self.menu.var_6640885].size - 1;
			}
			self function_5f17d120();
		}
		else if(self ActionSlotTwoButtonPressed())
		{
			self.menu.var_25a9347b[self.menu.var_6640885]++;
			if(self.menu.var_25a9347b[self.menu.var_6640885] > self.menu.option[self.menu.var_6640885].size - 1)
			{
				self.menu.var_25a9347b[self.menu.var_6640885] = 0;
			}
			self function_5f17d120();
		}
		else if(self useButtonPressed())
		{
            // tf is this
			if(isdefined(self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg3[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg4[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]))
			{
				self thread [[self.menu.func[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]]](self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg3[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg4[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]);
			}
			else if(isdefined(self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg3[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]))
			{
				self thread [[self.menu.func[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]]](self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg3[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]);
			}
			else if(isdefined(self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]) && isdefined(self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]))
			{
				self thread [[self.menu.func[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]]](self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]], self.menu.arg2[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]);
			}
			else if(isdefined(self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]))
			{
				self thread [[self.menu.func[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]]](self.menu.arg1[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]);
			}
			else
			{
				self thread [[self.menu.func[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885]]]]();
			}
			wait(0.2);
		}
		wait(0.05);
	}
}

function function_5f17d120()
{
    // just use a single for loop
	if(!isdefined(self.menu.option[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885] - 6]) || self.menu.option[self.menu.var_6640885].size <= 11)
	{
		for(i = 0; i < 11; i++)
		{
			if(isdefined(self.menu.option[self.menu.var_6640885][i]))
			{
				self.menu.elem["option"][i] setText(self.menu.option[self.menu.var_6640885][i]);
			}
			else
			{
				self.menu.elem["option"][i] setText("");
			}
			if(self.menu.var_25a9347b[self.menu.var_6640885] == i)
			{
				self.menu.elem["option"][i].color = (0, 0, 0);
				continue;
			}
			self.menu.elem["option"][i].color = (1, 1, 1);
		}
		self.menu.elem["scrollbar"].y = 100 + 18 * self.menu.var_25a9347b[self.menu.var_6640885];
	}
	else if(isdefined(self.menu.option[self.menu.var_6640885][self.menu.var_25a9347b[self.menu.var_6640885] + 4]))
	{
		index = 0;
		for(i = self.menu.var_25a9347b[self.menu.var_6640885] - 6; i < self.menu.var_25a9347b[self.menu.var_6640885] + 5; i++)
		{
			if(isdefined(self.menu.option[self.menu.var_6640885][i]))
			{
				self.menu.elem["option"][index] setText(self.menu.option[self.menu.var_6640885][i]);
			}
			else
			{
				self.menu.elem["option"][index] setText("");
			}
			if(self.menu.var_25a9347b[self.menu.var_6640885] == i)
			{
				self.menu.elem["option"][index].color = (0, 0, 0);
			}
			else
			{
				self.menu.elem["option"][index].color = (1, 1, 1);
			}
			index++;
		}
		self.menu.elem["scrollbar"].y = 100 + 108;
	}
	else
	{
		for(i = 0; i < 11; i++)
		{
			self.menu.elem["option"][i] setText(self.menu.option[self.menu.var_6640885][self.menu.option[self.menu.var_6640885].size + i - 11]);
			if(self.menu.var_25a9347b[self.menu.var_6640885] == self.menu.option[self.menu.var_6640885].size + i - 11)
			{
				self.menu.elem["option"][i].color = (0, 0, 0);
				continue;
			}
			self.menu.elem["option"][i].color = (1, 1, 1);
		}
		self.menu.elem["scrollbar"].y = 100 + 18 * self.menu.var_25a9347b[self.menu.var_6640885] - self.menu.option[self.menu.var_6640885].size + 11;
	}
}

function function_2f95538e()
{
	self function_5add3549("Main Menu");
	self addOption("Main Menu", "Self Menu", &function_9f479280, "Self Menu");
	if(GetDvarString("g_gametype") == "dm" || GetDvarString("g_gametype") == "tdm")
	{
		self addOption("Main Menu", "FFA/TDM Menu", &function_9f479280, "FFA/TDM Menu");
	}
	else if(GetDvarString("g_gametype") == "sd")
	{
		self addOption("Main Menu", "SND Menu", &function_9f479280, "SND Menu");
	}
	self addOption("Main Menu", "Bots Menu", &function_9f479280, "Bots Menu");
	self addOption("Main Menu", "EB Menu", &function_9f479280, "EB Menu", "VIP");
	self addOption("Main Menu", "Binds Menu", &function_9f479280, "Binds Menu", "VIP");
	self addOption("Main Menu", "Afterhit Menu", &function_9f479280, "Afterhit Menu", "VIP");
	self addOption("Main Menu", "Save/Load Menu", &function_9f479280, "Save/Load Menu");
	if(level.var_a8594817.size > 0)
	{
		self addOption("Main Menu", "OOM Menu", &function_9f479280, "OOM Menu");
	}
	self addOption("Main Menu", "Weapons Menu", &function_9f479280, "Weapons Menu");
	self addOption("Main Menu", "Streaks Menu", &function_9f479280, "Streaks Menu");
	self addOption("Main Menu", "Spawn Menu", &function_9f479280, "Spawn Menu");
	if(self namespace_93996bb7::function_bb9f3b9b())
	{
		self addOption("Main Menu", "Game Menu", &function_9f479280, "Game Menu", "Host");
		self addOption("Main Menu", "Players Menu", &function_9f479280, "Players Menu", "Host");
	}
	self addOption("Main Menu", "Menu Settings", &function_9f479280, "Menu Settings");
	self function_5add3549("Self Menu", "Main Menu");
	self addOption("Self Menu", "Suicide", &namespace_363acd5d::killplayer);
	self addOption("Self Menu", "Console FOV", &namespace_363acd5d::function_13f626d5);
	self addOption("Self Menu", "Perk Menu", &function_9f479280, "Perk Menu");
	self addOption("Self Menu", "Vision Menu", &function_9f479280, "Vision Menu");
	self addOption("Self Menu", "Floaters", &namespace_363acd5d::function_32bcf614);
	self addOption("Self Menu", "UFO Mode", &namespace_363acd5d::UFOMode);
	self addOption("Self Menu", "God Mode", &namespace_363acd5d::function_459c2a05);
	self addOption("Self Menu", "Invisibility", &namespace_363acd5d::function_d6b609b4);
	self addOption("Self Menu", "Unlimited Boost", &namespace_363acd5d::function_cb61fb1d);
	self addOption("Self Menu", "Third Person", &namespace_363acd5d::function_f11c7196);
	self addOption("Self Menu", "Constant UAV", &namespace_363acd5d::function_233ae540);
	self addOption("Self Menu", "MW2 Round End Freeze", &namespace_363acd5d::function_c77163ab);
	self addOption("Self Menu", "Give Rocket Ride", &namespace_363acd5d::function_aa8fcac6);
	self addOption("Self Menu", "Rocket Ride on Spawn", &namespace_363acd5d::function_ad47337f);
	self function_5add3549("Perk Menu", "Self Menu");
	self addOption("Perk Menu", "No Fall Damage", &namespace_363acd5d::function_68149d31, "specialty_fallheight", "No Fall Damage");
	self addOption("Perk Menu", "Steady Aim", &namespace_363acd5d::function_68149d31, "specialty_bulletaccuracy", "Steady Aim");
	self addOption("Perk Menu", "Sleight of Hand", &namespace_363acd5d::function_68149d31, "specialty_fastreload", "Sleight of Hand");
	self addOption("Perk Menu", "Quickdraw", &namespace_363acd5d::function_68149d31, "specialty_fastads", "Quickdraw");
	self addOption("Perk Menu", "Stalker", &namespace_363acd5d::function_68149d31, "specialty_stalker", "Stalker");
	self addOption("Perk Menu", "Afterburner", &namespace_363acd5d::function_68149d31, "specialty_jetcharger", "Afterburner");
	self addOption("Perk Menu", "Fast Hands", &namespace_363acd5d::function_68149d31, "specialty_fastweaponswitch", "Fast Hands");
	self addOption("Perk Menu", "Gung-Ho", &namespace_363acd5d::function_68149d31, "specialty_sprintfire", "Gung-Ho");
	self function_5add3549("Vision Menu", "Self Menu");
	self addOption("Vision Menu", "Reset Vision", &namespace_363acd5d::function_9168d4db, "default", "Reset");
	self addOption("Vision Menu", "Black/White Vision", &namespace_363acd5d::function_9168d4db, "mpintro", "Black/White");
	self addOption("Vision Menu", "Bright Vision", &namespace_363acd5d::function_9168d4db, "mp_ability_wakeup", "Bright");
	self addOption("Vision Menu", "Dim Vision", &namespace_363acd5d::function_9168d4db, "mp_ability_resurrection", "Dim");
	self addOption("Vision Menu", "Dart Vision", &namespace_363acd5d::function_9168d4db, "mp_vehicles_dart", "Dart");
	self addOption("Vision Menu", "Sentinel Vision", &namespace_363acd5d::function_9168d4db, "mp_vehicles_sentinel", "Sentinel");
	self addOption("Vision Menu", "Hellstorm Vision", &namespace_363acd5d::function_9168d4db, "mp_hellstorm", "Hellstorm");
	self addOption("Vision Menu", "Turret Vision", &namespace_363acd5d::function_9168d4db, "mp_vehicles_turret", "Turret");
	self addOption("Vision Menu", "Overdrive Vision", &namespace_363acd5d::function_9168d4db, "speed_burst_initialize", "Overdrive");
	self addOption("Vision Menu", "Mothership Vision", &namespace_363acd5d::function_9168d4db, "mp_vehicles_mothership", "Mothership");
	self addOption("Vision Menu", "Cerberus Vision", &namespace_363acd5d::function_9168d4db, "mp_vehicles_agr", "Cerberus");
	self function_5add3549("FFA/TDM Menu", "Main Menu");
	self addOption("FFA/TDM Menu", "Fast Last", &namespace_363acd5d::function_bed32f9f);
	self addOption("FFA/TDM Menu", "Add Kill", &namespace_363acd5d::function_86226dd0);
	self addOption("FFA/TDM Menu", "Remove Kill", &namespace_363acd5d::function_c04897bd);
	self addOption("FFA/TDM Menu", "Bots Can't Kill Last", &namespace_363acd5d::function_65d88a9e);
	self function_5add3549("SND Menu", "Main Menu");
	self addOption("SND Menu", "Plant A Bomb", &namespace_79d1d819::function_7cdf7c8c, "A");
	self addOption("SND Menu", "Plant B Bomb", &namespace_79d1d819::function_7cdf7c8c, "B");
	self addOption("SND Menu", "Defuse Bomb", &namespace_79d1d819::function_9253b4ef);
	self addOption("SND Menu", "Bots Can't Plant/Defuse", &namespace_79d1d819::function_da0bc41f);
	self addOption("SND Menu", "Bots on Last Life", &namespace_79d1d819::function_831f6af6);
	self addOption("SND Menu", "Auto Plant at Round End", &namespace_79d1d819::function_1a7dc437);
	self addOption("SND Menu", "Auto Defuse at Round End", &namespace_79d1d819::function_a42a76e2);
	self function_5add3549("Spawn Menu", "Main Menu");
	self addOption("Spawn Menu", "Spawn Platform", &_spawn::function_f58c763);
	self addOption("Spawn Menu", "Spawn Invis Platform", &_spawn::function_f27faaca);
	self addOption("Spawn Menu", "Delete Platforms", &_spawn::function_270f33bd);
	self addOption("Spawn Menu", "Spawn Normal Slide", &_spawn::function_e8b3531d, "Normal");
	self addOption("Spawn Menu", "Spawn High Slide", &_spawn::function_e8b3531d, "High");
	self addOption("Spawn Menu", "Spawn Insane Slide", &_spawn::function_e8b3531d, "Insane");
	self addOption("Spawn Menu", "Delete All Slides", &_spawn::function_c5793b82);
	self addOption("Spawn Menu", "Spawn Carepkg Stall", &_spawn::function_b303ec85);
	self addOption("Spawn Menu", "Spawn Carepkg Stall @ Crosshair", &_spawn::function_da197ddf);
	self addOption("Spawn Menu", "Delete All Carepkg Stalls", &_spawn::function_7921a9ca);
	self addOption("Spawn Menu", "Spawn Frozen Dart", &_spawn::SpawnDart);
	self addOption("Spawn Menu", "Delete All Darts", &_spawn::function_3c4f5cae);
	self function_5add3549("Weapons Menu", "Main Menu");
	self addOption("Weapons Menu", "DLC Weapons", &function_9f479280, "DLC Weapons");
	self addOption("Weapons Menu", "Take Weapon", &namespace_363acd5d::function_e11e9b0f);
	self addOption("Weapons Menu", "Drop Weapon", &namespace_363acd5d::dropweapon);
	self addOption("Weapons Menu", "Drop Canswap", &namespace_363acd5d::function_215339b5);
	self addOption("Weapons Menu", "Refill Ammo", &namespace_363acd5d::maxAmmo);
	self addOption("Weapons Menu", "Set Third Weapon", &namespace_363acd5d::function_d4e01fda);
	self addOption("Weapons Menu", "Give Third Weapon", &namespace_363acd5d::function_c23e5145);
	self addOption("Weapons Menu", "Set Mag to Last Shot", &namespace_363acd5d::function_62a143c3, 1);
	self addOption("Weapons Menu", "Unlimited Ammo", &namespace_363acd5d::function_f2200715);
	self addOption("Weapons Menu", "Unlimited Equipment", &namespace_363acd5d::function_221175e6);
	self addOption("Weapons Menu", "Canswap on Weapon Change", &namespace_363acd5d::function_c10c611);
	self function_5add3549("Game Menu", "Main Menu");
	self addOption("Game Menu", "Add/Remove Time", &function_9f479280, "Add/Remove Time");
	self addOption("Game Menu", "Timescale Options", &function_9f479280, "Timescale Options");
	self addOption("Game Menu", "Death Barrier Options", &function_9f479280, "Death Barrier Options");
	self addOption("Game Menu", "Change Pickup Radius", &namespace_363acd5d::function_3ceeb21d);
	self addOption("Game Menu", "Low Gravity", &namespace_363acd5d::LOW_GRAVITY);
	self addOption("Game Menu", "Sniper Only Damage", &namespace_363acd5d::function_87f998db);
	self addOption("Game Menu", "Post Game Damage", &namespace_363acd5d::function_df9ec412);
	self addOption("Game Menu", "Kill Distance (Meters)", &namespace_363acd5d::function_d4122317);
	self addOption("Game Menu", "Almost Hits", &namespace_363acd5d::function_82bbb3e1);
	self addOption("Game Menu", "Match Bonus", &namespace_363acd5d::function_3c32b0a1);
	self addOption("Game Menu", "Infinite Bullet Range", &namespace_363acd5d::function_aab20fe4);
	self addOption("Game Menu", "Fast Restart Match", &namespace_363acd5d::fastrestart);
	self addOption("Game Menu", "End Game Instantly", &namespace_363acd5d::function_8ddc08d9);
	self function_5add3549("Timescale Options", "Game Menu");
	self addOption("Timescale Options", "Change Timescale", &namespace_363acd5d::function_cd990b08);
	self addOption("Timescale Options", "Timescale During Killcam", &namespace_363acd5d::function_c86649fd);
	self function_5add3549("Death Barrier Options", "Game Menu");
	self addOption("Death Barrier Options", "Death Barriers", &namespace_24575103::function_30e7e48d);
	self addOption("Death Barrier Options", "OOM Barriers (Red Screen)", &namespace_24575103::function_84988bde);
	self addOption("Death Barrier Options", "Lower Death Barriers", &namespace_24575103::function_233db4ea);
	self function_5add3549("Binds Menu", "Main Menu");
	self addOption("Binds Menu", "Nac Mod Bind", &function_9f479280, "Nac Mod Bind");
	self addOption("Binds Menu", "Nac Next Bind", &function_9f479280, "Nac Next Bind");
	self addOption("Binds Menu", "Repeater Bind", &function_9f479280, "Repeater Bind");
	self addOption("Binds Menu", "Canswap Bind", &function_9f479280, "Canswap Bind");
	self addOption("Binds Menu", "Cowboy Bind", &function_9f479280, "Cowboy Bind");
	self addOption("Binds Menu", "Equipment Bind", &function_9f479280, "Equipment Bind");
	self addOption("Binds Menu", "rMala Bind", &function_9f479280, "rMala Bind");
	self addOption("Binds Menu", "Last Shot Bind", &function_9f479280, "Last Shot Bind");
	self addOption("Binds Menu", "Custom Class Binds", &function_9f479280, "Custom Class Binds");
	self addOption("Binds Menu", "Specialist Binds", &function_9f479280, "Specialist Binds");
	self addOption("Binds Menu", "Bolt Movement Bind", &function_9f479280, "Bolt Movement Bind");
	self addOption("Binds Menu", "Fade to Black Bind", &function_9f479280, "Fade to Black Bind");
	self addOption("Binds Menu", "Reset All Binds", &namespace_98fc914::function_4689d26d);
	self function_5add3549("Nac Mod Bind", "Binds Menu");
	self addOption("Nac Mod Bind", "Set Nac Weapons", &namespace_98fc914::function_8ae5a6f1);
	self addOption("Nac Mod Bind", "Reset Nac Weapons", &namespace_98fc914::function_cbd254e0);
	self addOption("Nac Mod Bind", "Canswap on Nac", &namespace_98fc914::function_b064d6b0);
	self function_f82260a("Nac Mod Bind", "nac", &namespace_98fc914::function_9922f784);
	self addOption("Nac Mod Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "nac");
	self function_5add3549("Nac Next Bind", "Binds Menu");
	self addOption("Nac Next Bind", "Canswap on Nac", &namespace_98fc914::function_b064d6b0);
	self function_f82260a("Nac Next Bind", "nac_next", &namespace_98fc914::function_6157793f);
	self addOption("Nac Next Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "nac_next");
	self function_5add3549("Repeater Bind", "Binds Menu");
	self function_f82260a("Repeater Bind", "repeat", &namespace_98fc914::function_58c16acf);
	self addOption("Repeater Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "repeat");
	var_e4ffe802 = StrTok("briefcase_bomb;uav;supplydrop_marker;killstreak_remote_turret;satchel_charge;pda_hack;inventory_minigun_drop;ball;gadget_vision_pulse", ";");
	equip_name = StrTok("Bomb Briefcase;UAV;Carepackage Marker;Killstreak Pad;C4;Black Hat;Drop Marker;Uplink Ball;M27", ";");
	self function_5add3549("Equipment Bind", "Binds Menu");
	for(i = 0; i < var_e4ffe802.size; i++)
	{
		self addOption("Equipment Bind", equip_name[i], &function_9f479280, equip_name[i]);
		self function_5add3549(equip_name[i], "Equipment Bind");
		self function_f82260a(equip_name[i], var_e4ffe802[i], &namespace_98fc914::function_d13d943e, var_e4ffe802[i]);
		self addOption(equip_name[i], "Reset Bind", &namespace_98fc914::function_92e6d627, var_e4ffe802[i]);
	}
	self addOption("Equipment Bind", "Reset Binds", &namespace_98fc914::function_6f2bda9e, var_e4ffe802);
	var_abd5cb1f = StrTok("briefcase_bomb;supplydrop_marker;killstreak_remote_turret;satchel_charge;pda_hack;inventory_minigun_drop;gadget_vision_pulse", ";");
	var_ea30a4b0 = StrTok("Bomb Briefcase rMala;Carepackage Marker rMala;Killstreak Pad rMala;C4 rMala;Black Hat rMala;Drop Marker rMala;M27 rMala", ";");
	self function_5add3549("rMala Bind", "Binds Menu");
	for(i = 0; i < var_abd5cb1f.size; i++)
	{
		self addOption("rMala Bind", var_ea30a4b0[i], &function_9f479280, var_ea30a4b0[i]);
		self function_5add3549(var_ea30a4b0[i], "rMala Bind");
		self function_f82260a(var_ea30a4b0[i], var_abd5cb1f[i] + "_mala", &namespace_98fc914::function_cfc39f8b, var_abd5cb1f[i]);
		self addOption(var_ea30a4b0[i], "Reset Bind", &namespace_98fc914::function_92e6d627, var_abd5cb1f[i] + "_mala");
	}
	self addOption("rMala Bind", "Reset Binds", &namespace_98fc914::function_6f2bda9e, StrTok("briefcase_bomb_mala;supplydrop_marker_mala;killstreak_remote_turret_mala;satchel_charge_mala;pda_hack_mala;inventory_minigun_drop_mala;gadget_vision_pulse_mala", ";"));
	self function_5add3549("Canswap Bind", "Binds Menu");
	self function_f82260a("Canswap Bind", "canswap", &namespace_98fc914::function_10cb2eb9);
	self addOption("Canswap Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "canswap");
	self function_5add3549("Specialist Binds", "Binds Menu");
	self addOption("Specialist Binds", "Glitch Bind", &function_9f479280, "Glitch Bind");
	self addOption("Specialist Binds", "Active Camo Bind", &function_9f479280, "Active Camo Bind");
	self addOption("Specialist Binds", "Psychosis Bind", &function_9f479280, "Psychosis Bind");
	self addOption("Specialist Binds", "Kinetic Armor Bind", &function_9f479280, "Kinetic Armor Bind");
	self addOption("Specialist Binds", "Rejack Bind", &function_9f479280, "Rejack Bind");
	self addOption("Specialist Binds", "Heat Wave Bind", &function_9f479280, "Heat Wave Bind");
	self addOption("Specialist Binds", "Reset Binds", &namespace_98fc914::function_6f2bda9e, StrTok("glitch;psychosis;active_camo;kinetic_armor;rejack;heat_wave", ";"));
	self function_5add3549("Glitch Bind", "Specialist Binds");
	self addOption("Glitch Bind", "Save Glitch Position", &namespace_98fc914::function_134ea365);
	self function_f82260a("Glitch Bind", "glitch", &namespace_98fc914::function_b979fda5);
	self addOption("Glitch Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "glitch");
	self function_5add3549("Active Camo Bind", "Specialist Binds");
	self function_f82260a("Active Camo Bind", "active_camo", &namespace_98fc914::function_fe2f8e06);
	self addOption("Active Camo Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "active_camo");
	self function_5add3549("Psychosis Bind", "Specialist Binds");
	self function_f82260a("Psychosis Bind", "psychosis", &namespace_98fc914::function_8e9bbbed);
	self addOption("Psychosis Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "psychosis");
	self function_5add3549("Kinetic Armor Bind", "Specialist Binds");
	self function_f82260a("Kinetic Armor Bind", "kinetic_armor", &namespace_98fc914::function_bf547e0c);
	self addOption("Kinetic Armor Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "kinetic_armor");
	self function_5add3549("Rejack Bind", "Specialist Binds");
	self function_f82260a("Rejack Bind", "rejack", &namespace_98fc914::function_c1bce9b8);
	self addOption("Rejack Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "rejack");
	self function_5add3549("Heat Wave Bind", "Specialist Binds");
	self function_f82260a("Heat Wave Bind", "heat_wave", &namespace_98fc914::function_68d5f507);
	self addOption("Heat Wave Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "heat_wave");
	self function_5add3549("Cowboy Bind", "Binds Menu");
	self addOption("Cowboy Bind", "Toggle Cowboy", &namespace_98fc914::function_1c04d6e3);
	self function_f82260a("Cowboy Bind", "cowboy", &namespace_98fc914::function_1c04d6e3);
	self addOption("Cowboy Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "cowboy");
	self function_5add3549("Last Shot Bind", "Binds Menu");
	self function_f82260a("Last Shot Bind", "lastshot", &namespace_363acd5d::function_62a143c3, 0);
	self addOption("Last Shot Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "lastshot");
	var_3d5e64ea = StrTok("CLASS_CUSTOM1;CLASS_CUSTOM2;CLASS_CUSTOM3;CLASS_CUSTOM4;CLASS_CUSTOM5", ";");
	var_1f7056e3 = StrTok("Custom Class 1;Custom Class 2;Custom Class 3;Custom Class 4;Custom Class 5", ";");
	self function_5add3549("Custom Class Binds", "Binds Menu");
	self addOption("Custom Class Binds", "Toggle Canswap", &namespace_98fc914::function_27f25b3a);
	self addOption("Custom Class Binds", "Swap Between Classes", &function_9f479280, "Swap Between Classes");
	for(i = 0; i < var_3d5e64ea.size; i++)
	{
		self addOption("Custom Class Binds", var_1f7056e3[i], &function_9f479280, var_1f7056e3[i]);
		self function_5add3549(var_1f7056e3[i], "Custom Class Binds");
		self function_f82260a(var_1f7056e3[i], var_3d5e64ea[i], &namespace_98fc914::function_935fecda, var_3d5e64ea[i]);
		self addOption(var_1f7056e3[i], "Reset Bind", &namespace_98fc914::function_92e6d627, var_3d5e64ea[i]);
	}
	var_3d5e64ea[var_3d5e64ea.size] = "classchange";
	self addOption("Custom Class Binds", "Reset Binds", &namespace_98fc914::function_6f2bda9e, var_3d5e64ea);
	self function_5add3549("Swap Between Classes", "Custom Class Binds");
	self function_f82260a("Swap Between Classes", "classchange", &namespace_98fc914::function_ef1a8dbb);
	self addOption("Swap Between Classes", "Reset Bind", &namespace_98fc914::function_92e6d627, "classchange");
	self function_5add3549("Bolt Movement Bind", "Binds Menu");
	self addOption("Bolt Movement Bind", "Play Bolt", &namespace_98fc914::function_9974c317);
	self addOption("Bolt Movement Bind", "Save Bolt Position", &namespace_98fc914::function_2997cbe3);
	self addOption("Bolt Movement Bind", "Remove Bolt Position", &namespace_98fc914::function_eab57065);
	self addOption("Bolt Movement Bind", "Change Bolt Speed", &function_9f479280, "Bolt Speed");
	self function_f82260a("Bolt Movement Bind", "bolt", &namespace_98fc914::function_9974c317);
	self addOption("Bolt Movement Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "bolt");
	self function_5add3549("Bolt Speed", "Bolt Movement Bind");
	for(i = 0.5; i < 3.75; i = 0.5)
	{
		self addOption("Bolt Speed", i + " seconds", &namespace_98fc914::function_3c99d8f5, i);
	}
	self function_5add3549("Fade to Black Bind", "Binds Menu");
	self function_f82260a("Fade to Black Bind", "fade_black", &namespace_98fc914::fadetoblack);
	self addOption("Fade to Black Bind", "Reset Bind", &namespace_98fc914::function_92e6d627, "fade_black");
	self function_5add3549("EB Menu", "Main Menu");
	self addOption("EB Menu", "Disable EB", &namespace_6a0d8055::function_c6acd27e);
	self addOption("EB Menu", "Select EB Gun", &namespace_6a0d8055::function_f687b858);
	self addOption("EB Menu", "EB Delay", &function_9f479280, "EB Delay");
	self addOption("EB Menu", "Headshot Only", &namespace_6a0d8055::function_faf76f4e);
	self addOption("EB Menu", "Fake Bullet Trail", &namespace_6a0d8055::function_cfdfa454);
	self addOption("EB Menu", "EB: Very Close", &namespace_6a0d8055::function_1ff1ec6c, "Very Close");
	self addOption("EB Menu", "EB: Close", &namespace_6a0d8055::function_1ff1ec6c, "Close");
	self addOption("EB Menu", "EB: Strong", &namespace_6a0d8055::function_1ff1ec6c, "Strong");
	self addOption("EB Menu", "EB: Very Strong", &namespace_6a0d8055::function_1ff1ec6c, "Very Strong");
	self addOption("EB Menu", "EB: Insane", &namespace_6a0d8055::function_1ff1ec6c, "Insane");
	self function_5add3549("EB Delay", "EB Menu");
	self addOption("EB Delay", "Disable EB Delay", &namespace_6a0d8055::function_d43ee535, 0);
	for(i = 0.1; i < 1.1; i = 0.1)
	{
		self addOption("EB Delay", i + " seconds", &namespace_6a0d8055::function_d43ee535, i);
	}
	self function_5add3549("Save/Load Menu", "Main Menu");
	self addOption("Save/Load Menu", "Save Position", &namespace_363acd5d::function_5fefc250, 1);
	self addOption("Save/Load Menu", "Load Position", &namespace_363acd5d::function_3b5807e5, 1);
	self addOption("Save/Load Menu", "Reset Position", &namespace_363acd5d::function_bf8eb08c, 1);
	self addOption("Save/Load Menu", "Save & Load Bind", &namespace_363acd5d::function_6f9a4d9a);
	self addOption("Save/Load Menu", "Load On Spawn", &namespace_363acd5d::function_c0f1bb67);
	self function_5add3549("Add/Remove Time", "Game Menu");
	self addOption("Add/Remove Time", "Add 1 Minute", &namespace_363acd5d::function_4ed51df1, 1);
	self addOption("Add/Remove Time", "Add 5 Minutes", &namespace_363acd5d::function_4ed51df1, 5);
	self addOption("Add/Remove Time", "Remove 1 Minute", &namespace_363acd5d::function_5c15baa7, 1);
	self addOption("Add/Remove Time", "Remove 5 Minutes", &namespace_363acd5d::function_5c15baa7, 5);
	self function_5add3549("Streaks Menu", "Main Menu");
	self addOption("Streaks Menu", "Give Streaks", &namespace_363acd5d::streaks, 1);
	self addOption("Streaks Menu", "Give Specialist", &namespace_363acd5d::giveHeroWeapon, 1);
	self addOption("Streaks Menu", "Streaks/Specialist Bind", &namespace_363acd5d::function_747e240b);
	if(level.var_a8594817.size > 0)
	{
		self function_5add3549("OOM Menu", "Main Menu");
		for(i = 0; i < level.var_a8594817.size; i++)
		{
			self addOption("OOM Menu", "OOM Spot " + i + 1, &namespace_24575103::function_6ad1816b, level.var_a8594817[i]);
		}
		self addOption("OOM Menu", "Return to Spawn", &namespace_24575103::function_fca89254);
	}
	self function_5add3549("Bots Menu", "Main Menu");
	self addOption("Bots Menu", "Spawn 1 Bot", &namespace_363acd5d::function_5fa6a50, 1);
	self addOption("Bots Menu", "Kick 1 Bot", &namespace_363acd5d::function_6598a964);
	self addOption("Bots Menu", "Kick All Bots", &namespace_363acd5d::function_7eba5f5d);
	self addOption("Bots Menu", "Freeze All Bots", &namespace_363acd5d::function_15af110b);
	self addOption("Bots Menu", "Unfreeze All Bots", &namespace_363acd5d::function_6193775c);
	self addOption("Bots Menu", "Teleport 1 Bot to Crosshair", &namespace_363acd5d::function_36e1f78);
	self addOption("Bots Menu", "Teleport All Bots to Crosshair", &namespace_363acd5d::function_4f02155f);
	self addOption("Bots Menu", "Save Bots Spawn Position", &namespace_363acd5d::function_52b3eff2);
	self addOption("Bots Menu", "Reset Bots Spawn Position", &namespace_363acd5d::function_4198eede);
	self addOption("Bots Menu", "Bots Can't Damage Players", &namespace_363acd5d::function_3e019310);
	self addOption("Bots Menu", "Bots Can't Sui", &namespace_363acd5d::function_9516f9a5);
	self addOption("Bots Menu", "Bots Look at You", &namespace_363acd5d::function_c4698fe6);
	self addOption("Bots Menu", "Set Bot Kills to 0", &namespace_363acd5d::function_a98af669, 0);
	self function_5add3549("DLC Weapons", "Weapons Menu");
	self addOption("DLC Weapons", "Assault Rifles", &function_9f479280, "DLC Assault Rifles");
	self addOption("DLC Weapons", "Submachine Guns", &function_9f479280, "DLC Submachine Guns");
	self addOption("DLC Weapons", "Shotguns", &function_9f479280, "DLC Shotguns");
	self addOption("DLC Weapons", "Light Machine Guns", &function_9f479280, "DLC Light Machine Guns");
	self addOption("DLC Weapons", "Sniper Rifles", &function_9f479280, "DLC Sniper Rifles");
	self addOption("DLC Weapons", "Pistols", &function_9f479280, "DLC Pistols");
	self addOption("DLC Weapons", "Launchers", &function_9f479280, "DLC Launchers");
	self addOption("DLC Weapons", "Melee Weapons", &function_9f479280, "DLC Melee Weapons");
	self addOption("DLC Weapons", "Special Weapons", &function_9f479280, "DLC Special Weapons");
	self addOption("DLC Weapons", "Toggle Drop Current Weapon", &namespace_363acd5d::function_3c485487);
	self function_5add3549("DLC Assault Rifles", "DLC Weapons");
	self addOption("DLC Assault Rifles", "AN-94", &namespace_363acd5d::function_fcb76e97, "ar_an94");
	self addOption("DLC Assault Rifles", "Famas", &namespace_363acd5d::function_fcb76e97, "ar_famas");
	self addOption("DLC Assault Rifles", "Galil", &namespace_363acd5d::function_fcb76e97, "ar_galil");
	self addOption("DLC Assault Rifles", "M16", &namespace_363acd5d::function_fcb76e97, "ar_m16");
	self addOption("DLC Assault Rifles", "MX Garand", &namespace_363acd5d::function_fcb76e97, "ar_garand");
	self addOption("DLC Assault Rifles", "Peacekeeper MK2", &namespace_363acd5d::function_fcb76e97, "ar_peacekeeper");
	self addOption("DLC Assault Rifles", "LV8 Basilisk", &namespace_363acd5d::function_fcb76e97, "ar_pulse");
	self function_5add3549("DLC Submachine Guns", "DLC Weapons");
	self addOption("DLC Submachine Guns", "AK74u", &namespace_363acd5d::function_fcb76e97, "smg_ak74u");
	self addOption("DLC Submachine Guns", "HG 40", &namespace_363acd5d::function_fcb76e97, "smg_mp40");
	self addOption("DLC Submachine Guns", "HLX 4", &namespace_363acd5d::function_fcb76e97, "smg_rechamber");
	self addOption("DLC Submachine Guns", "MSMC", &namespace_363acd5d::function_fcb76e97, "smg_msmc");
	self addOption("DLC Submachine Guns", "PPSH", &namespace_363acd5d::function_fcb76e97, "smg_ppsh");
	self addOption("DLC Submachine Guns", "Sten", &namespace_363acd5d::function_fcb76e97, "smg_sten2");
	self addOption("DLC Submachine Guns", "DIY 11 Renovator", &namespace_363acd5d::function_fcb76e97, "smg_nailgun");
	self function_5add3549("DLC Shotguns", "DLC Weapons");
	self addOption("DLC Shotguns", "Banshii", &namespace_363acd5d::function_fcb76e97, "shotgun_energy");
	self addOption("DLC Shotguns", "Olympia", &namespace_363acd5d::function_fcb76e97, "shotgun_olympia");
	self function_5add3549("DLC Light Machine Guns", "DLC Weapons");
	self addOption("DLC Light Machine Guns", "RPK", &namespace_363acd5d::function_fcb76e97, "lmg_rpk");
	self addOption("DLC Light Machine Guns", "R70", &namespace_363acd5d::function_fcb76e97, "lmg_infinite");
	self function_5add3549("DLC Sniper Rifles", "DLC Weapons");
	self addOption("DLC Sniper Rifles", "DBSR-50", &namespace_363acd5d::function_fcb76e97, "sniper_double");
	self addOption("DLC Sniper Rifles", "RSA Interdiction", &namespace_363acd5d::function_fcb76e97, "sniper_quickscope");
	self addOption("DLC Sniper Rifles", "XPR-50", &namespace_363acd5d::function_fcb76e97, "sniper_xpr50");
	self addOption("DLC Sniper Rifles", "Dragoon", &namespace_363acd5d::function_fcb76e97, "sniper_mosin");
	self function_5add3549("DLC Launchers", "DLC Weapons");
	self addOption("DLC Launchers", "L4 Siege", &namespace_363acd5d::function_fcb76e97, "launcher_multi");
	self addOption("DLC Launchers", "MAX-GL", &namespace_363acd5d::function_fcb76e97, "launcher_ex41");
	self function_5add3549("DLC Pistols", "DLC Weapons");
	self addOption("DLC Pistols", "M1911", &namespace_363acd5d::function_fcb76e97, "pistol_m1911");
	self addOption("DLC Pistols", "M1911 Dual Wield", &namespace_363acd5d::function_fcb76e97, "pistol_m1911_dw");
	self addOption("DLC Pistols", "Marshal 16", &namespace_363acd5d::function_fcb76e97, "pistol_shotgun");
	self addOption("DLC Pistols", "Marshal 16 Dual Wield", &namespace_363acd5d::function_fcb76e97, "pistol_shotgun_dw");
	self addOption("DLC Pistols", "Rift E9", &namespace_363acd5d::function_fcb76e97, "pistol_energy");
	self function_5add3549("DLC Melee Weapons", "DLC Weapons");
	self addOption("DLC Melee Weapons", "Ace of Spades", &namespace_363acd5d::function_fcb76e97, "melee_shovel");
	self addOption("DLC Melee Weapons", "Bowie Knife", &namespace_363acd5d::function_fcb76e97, "bowie_knife");
	self addOption("DLC Melee Weapons", "Brass Knuckles", &namespace_363acd5d::function_fcb76e97, "melee_knuckles");
	self addOption("DLC Melee Weapons", "Bushwhacker", &namespace_363acd5d::function_fcb76e97, "melee_chainsaw");
	self addOption("DLC Melee Weapons", "Butterfly Knife", &namespace_363acd5d::function_fcb76e97, "melee_butterfly");
	self addOption("DLC Melee Weapons", "Buzz Cut", &namespace_363acd5d::function_fcb76e97, "melee_improvise");
	self addOption("DLC Melee Weapons", "Carver", &namespace_363acd5d::function_fcb76e97, "melee_bowie");
	self addOption("DLC Melee Weapons", "Enforcer", &namespace_363acd5d::function_fcb76e97, "melee_shockbaton");
	self addOption("DLC Melee Weapons", "Slash n' Burn", &namespace_363acd5d::function_fcb76e97, "melee_fireaxe");
	self addOption("DLC Melee Weapons", "Wrench", &namespace_363acd5d::function_fcb76e97, "melee_wrench");
	self addOption("DLC Melee Weapons", "Fury's Song", &namespace_363acd5d::function_fcb76e97, "melee_sword");
	self addOption("DLC Melee Weapons", "Iron Jim", &namespace_363acd5d::function_fcb76e97, "melee_crowbar");
	self addOption("DLC Melee Weapons", "L3FT.E", &namespace_363acd5d::function_fcb76e97, "melee_prosthetic");
	self addOption("DLC Melee Weapons", "Malice", &namespace_363acd5d::function_fcb76e97, "melee_dagger");
	self addOption("DLC Melee Weapons", "MVP", &namespace_363acd5d::function_fcb76e97, "melee_bat");
	self addOption("DLC Melee Weapons", "Nightbreaker", &namespace_363acd5d::function_fcb76e97, "melee_boneglass");
	self addOption("DLC Melee Weapons", "Nunchuks", &namespace_363acd5d::function_fcb76e97, "melee_nunchuks");
	self addOption("DLC Melee Weapons", "Path of Sorrows", &namespace_363acd5d::function_fcb76e97, "melee_katana");
	self addOption("DLC Melee Weapons", "Prize Fighters", &namespace_363acd5d::function_fcb76e97, "melee_boxing");
	self addOption("DLC Melee Weapons", "Raven's Eye", &namespace_363acd5d::function_fcb76e97, "melee_crescent");
	self addOption("DLC Melee Weapons", "Skull Splitter", &namespace_363acd5d::function_fcb76e97, "melee_mace");
	self function_5add3549("DLC Special Weapons", "DLC Weapons");
	self addOption("DLC Special Weapons", "M27", &namespace_363acd5d::function_fcb76e97, "gadget_vision_pulse");
	self addOption("DLC Special Weapons", "Pink M27", &namespace_363acd5d::function_fcb76e97, "baseweapon");
	self addOption("DLC Special Weapons", "Default Weapon", &namespace_363acd5d::function_fcb76e97, "defaultweapon");
	self addOption("DLC Special Weapons", "Ballistic Knife", &namespace_363acd5d::function_fcb76e97, "knife_ballistic");
	self addOption("DLC Special Weapons", "NX ShadowClaw", &namespace_363acd5d::function_fcb76e97, "special_crossbow");
	self addOption("DLC Special Weapons", "NX ShadowClaw Dual Wield", &namespace_363acd5d::function_fcb76e97, "special_crossbow_dw");
	self addOption("DLC Special Weapons", "D13 Sector", &namespace_363acd5d::function_fcb76e97, "special_discgun");
	self function_5add3549("Afterhit Menu", "Main Menu");
	self addOption("Afterhit Menu", "Assault Rifles", &function_9f479280, "Assault Rifles");
	self addOption("Afterhit Menu", "Submachine Guns", &function_9f479280, "Submachine Guns");
	self addOption("Afterhit Menu", "Shotguns", &function_9f479280, "Shotguns");
	self addOption("Afterhit Menu", "Light Machine Guns", &function_9f479280, "Light Machine Guns");
	self addOption("Afterhit Menu", "Sniper Rifles", &function_9f479280, "Sniper Rifles");
	self addOption("Afterhit Menu", "Pistols", &function_9f479280, "Pistols");
	self addOption("Afterhit Menu", "Launchers", &function_9f479280, "Launchers");
	self addOption("Afterhit Menu", "Melee Weapons", &function_9f479280, "Melee Weapons");
	self addOption("Afterhit Menu", "Specials", &function_9f479280, "Specials");
	self addOption("Afterhit Menu", "Specialist Weapons", &function_9f479280, "Specialist Weapons");
	self addOption("Afterhit Menu", "Specialist Abilities", &function_9f479280, "Specialist Abilities");
	self addOption("Afterhit Menu", "Unset Afterhit", &namespace_363acd5d::function_b08504aa, 0);
	self addOption("Afterhit Menu", "Preview Afterhit", &namespace_363acd5d::function_9791bd34);
	self function_5add3549("Assault Rifles", "Afterhit Menu");
	self addOption("Assault Rifles", "KN-44", &namespace_363acd5d::function_b08504aa, 1, "ar_standard");
	self addOption("Assault Rifles", "XR-2", &namespace_363acd5d::function_b08504aa, 1, "ar_fastburst");
	self addOption("Assault Rifles", "HVK-30", &namespace_363acd5d::function_b08504aa, 1, "ar_cqb");
	self addOption("Assault Rifles", "ICR-1", &namespace_363acd5d::function_b08504aa, 1, "ar_accurate");
	self addOption("Assault Rifles", "Man-O-War", &namespace_363acd5d::function_b08504aa, 1, "ar_damage");
	self addOption("Assault Rifles", "Sheiva", &namespace_363acd5d::function_b08504aa, 1, "ar_marksman");
	self addOption("Assault Rifles", "M8A7", &namespace_363acd5d::function_b08504aa, 1, "ar_longburst");
	self addOption("Assault Rifles", "AN-94", &namespace_363acd5d::function_b08504aa, 1, "ar_an94");
	self addOption("Assault Rifles", "Famas", &namespace_363acd5d::function_b08504aa, 1, "ar_famas");
	self addOption("Assault Rifles", "Galil", &namespace_363acd5d::function_b08504aa, 1, "ar_galil");
	self addOption("Assault Rifles", "M16", &namespace_363acd5d::function_b08504aa, 1, "ar_m16");
	self addOption("Assault Rifles", "MX Garand", &namespace_363acd5d::function_b08504aa, 1, "ar_garand");
	self addOption("Assault Rifles", "Peacekeeper MK2", &namespace_363acd5d::function_b08504aa, 1, "ar_peacekeeper");
	self addOption("Assault Rifles", "LV8 Basilisk", &namespace_363acd5d::function_b08504aa, 1, "ar_pulse");
	self function_5add3549("Submachine Guns", "Afterhit Menu");
	self addOption("Submachine Guns", "Kuda", &namespace_363acd5d::function_b08504aa, 1, "smg_standard");
	self addOption("Submachine Guns", "VMP", &namespace_363acd5d::function_b08504aa, 1, "smg_versatile");
	self addOption("Submachine Guns", "Weevil", &namespace_363acd5d::function_b08504aa, 1, "smg_capacity");
	self addOption("Submachine Guns", "Vesper", &namespace_363acd5d::function_b08504aa, 1, "smg_fastfire");
	self addOption("Submachine Guns", "Pharo", &namespace_363acd5d::function_b08504aa, 1, "smg_burst");
	self addOption("Submachine Guns", "Razorback", &namespace_363acd5d::function_b08504aa, 1, "smg_longrange");
	self addOption("Submachine Guns", "AK74u", &namespace_363acd5d::function_b08504aa, 1, "smg_ak74u");
	self addOption("Submachine Guns", "HG 40", &namespace_363acd5d::function_b08504aa, 1, "smg_mp40");
	self addOption("Submachine Guns", "HLX 4", &namespace_363acd5d::function_b08504aa, 1, "smg_rechamber");
	self addOption("Submachine Guns", "MSMC", &namespace_363acd5d::function_b08504aa, 1, "smg_msmc");
	self addOption("Submachine Guns", "PPSH", &namespace_363acd5d::function_b08504aa, 1, "smg_ppsh");
	self addOption("Submachine Guns", "Sten", &namespace_363acd5d::function_b08504aa, 1, "smg_sten2");
	self addOption("Submachine Guns", "DIY 11 Renovator", &namespace_363acd5d::function_b08504aa, 1, "smg_nailgun");
	self function_5add3549("Shotguns", "Afterhit Menu");
	self addOption("Shotguns", "KRM-262", &namespace_363acd5d::function_b08504aa, 1, "shotgun_pump");
	self addOption("Shotguns", "205 Brecci", &namespace_363acd5d::function_b08504aa, 1, "shotgun_semiauto");
	self addOption("Shotguns", "Haymaker 12", &namespace_363acd5d::function_b08504aa, 1, "shotgun_fullauto");
	self addOption("Shotguns", "Argus", &namespace_363acd5d::function_b08504aa, 1, "shotgun_precision");
	self addOption("Shotguns", "Banshii", &namespace_363acd5d::function_b08504aa, 1, "shotgun_energy");
	self addOption("Shotguns", "Olympia", &namespace_363acd5d::function_b08504aa, 1, "shotgun_olympia");
	self function_5add3549("Light Machine Guns", "Afterhit Menu");
	self addOption("Light Machine Guns", "BRM", &namespace_363acd5d::function_b08504aa, 1, "lmg_light");
	self addOption("Light Machine Guns", "Dingo", &namespace_363acd5d::function_b08504aa, 1, "lmg_cqb");
	self addOption("Light Machine Guns", "Gorgon", &namespace_363acd5d::function_b08504aa, 1, "lmg_slowfire");
	self addOption("Light Machine Guns", "48 Dredge", &namespace_363acd5d::function_b08504aa, 1, "lmg_heavy");
	self addOption("Light Machine Guns", "RPK", &namespace_363acd5d::function_b08504aa, 1, "lmg_rpk");
	self addOption("Light Machine Guns", "R70", &namespace_363acd5d::function_b08504aa, 1, "lmg_infinite");
	self function_5add3549("Sniper Rifles", "Afterhit Menu");
	self addOption("Sniper Rifles", "Drakon", &namespace_363acd5d::function_b08504aa, 1, "sniper_fastsemi");
	self addOption("Sniper Rifles", "Locus", &namespace_363acd5d::function_b08504aa, 1, "sniper_fastbolt");
	self addOption("Sniper Rifles", "P-06", &namespace_363acd5d::function_b08504aa, 1, "sniper_chargeshot");
	self addOption("Sniper Rifles", "SVG-100", &namespace_363acd5d::function_b08504aa, 1, "sniper_powerbolt");
	self addOption("Sniper Rifles", "DBSR-50", &namespace_363acd5d::function_b08504aa, 1, "sniper_double");
	self addOption("Sniper Rifles", "RSA Interdiction", &namespace_363acd5d::function_b08504aa, 1, "sniper_quickscope");
	self addOption("Sniper Rifles", "XPR-50", &namespace_363acd5d::function_b08504aa, 1, "sniper_xpr50");
	self addOption("Sniper Rifles", "Dragoon", &namespace_363acd5d::function_b08504aa, 1, "sniper_mosin");
	self function_5add3549("Pistols", "Afterhit Menu");
	self addOption("Pistols", "MR6", &namespace_363acd5d::function_b08504aa, 1, "pistol_standard");
	self addOption("Pistols", "RK5", &namespace_363acd5d::function_b08504aa, 1, "pistol_burst");
	self addOption("Pistols", "L-CAR 9", &namespace_363acd5d::function_b08504aa, 1, "pistol_fullauto");
	self addOption("Pistols", "M1911", &namespace_363acd5d::function_b08504aa, 1, "pistol_m1911");
	self addOption("Pistols", "M1911 Dual Wield", &namespace_363acd5d::function_b08504aa, 1, "pistol_m1911_dw");
	self addOption("Pistols", "Marshal 16", &namespace_363acd5d::function_b08504aa, 1, "pistol_shotgun");
	self addOption("Pistols", "Marshal 16 Dual Wield", &namespace_363acd5d::function_b08504aa, 1, "pistol_shotgun_dw");
	self addOption("Pistols", "Rift E9", &namespace_363acd5d::function_b08504aa, 1, "pistol_energy");
	self function_5add3549("Launchers", "Afterhit Menu");
	self addOption("Launchers", "XM-53", &namespace_363acd5d::function_b08504aa, 1, "launcher_standard");
	self addOption("Launchers", "BlackCell", &namespace_363acd5d::function_b08504aa, 1, "launcher_lockonly");
	self addOption("Launchers", "L4 Siege", &namespace_363acd5d::function_b08504aa, 1, "launcher_multi");
	self addOption("Launchers", "MAX-GL", &namespace_363acd5d::function_b08504aa, 1, "launcher_ex41");
	self function_5add3549("Melee Weapons", "Afterhit Menu");
	self addOption("Melee Weapons", "Combat Knife", &namespace_363acd5d::function_b08504aa, 1, "knife_loadout");
	self addOption("Melee Weapons", "Ace of Spades", &namespace_363acd5d::function_b08504aa, 1, "melee_shovel");
	self addOption("Melee Weapons", "Bowie Knife", &namespace_363acd5d::function_b08504aa, 1, "bowie_knife");
	self addOption("Melee Weapons", "Brass Knuckles", &namespace_363acd5d::function_b08504aa, 1, "melee_knuckles");
	self addOption("Melee Weapons", "Bushwhacker", &namespace_363acd5d::function_b08504aa, 1, "melee_chainsaw");
	self addOption("Melee Weapons", "Butterfly Knife", &namespace_363acd5d::function_b08504aa, 1, "melee_butterfly");
	self addOption("Melee Weapons", "Buzz Cut", &namespace_363acd5d::function_b08504aa, 1, "melee_improvise");
	self addOption("Melee Weapons", "Carver", &namespace_363acd5d::function_b08504aa, 1, "melee_bowie");
	self addOption("Melee Weapons", "Enforcer", &namespace_363acd5d::function_b08504aa, 1, "melee_shockbaton");
	self addOption("Melee Weapons", "Slash n' Burn", &namespace_363acd5d::function_b08504aa, 1, "melee_fireaxe");
	self addOption("Melee Weapons", "Wrench", &namespace_363acd5d::function_b08504aa, 1, "melee_wrench");
	self addOption("Melee Weapons", "Fury's Song", &namespace_363acd5d::function_b08504aa, 1, "melee_sword");
	self addOption("Melee Weapons", "Iron Jim", &namespace_363acd5d::function_b08504aa, 1, "melee_crowbar");
	self addOption("Melee Weapons", "L3FT.E", &namespace_363acd5d::function_b08504aa, 1, "melee_prosthetic");
	self addOption("Melee Weapons", "Malice", &namespace_363acd5d::function_b08504aa, 1, "melee_dagger");
	self addOption("Melee Weapons", "MVP", &namespace_363acd5d::function_b08504aa, 1, "melee_bat");
	self addOption("Melee Weapons", "Nightbreaker", &namespace_363acd5d::function_b08504aa, 1, "melee_boneglass");
	self addOption("Melee Weapons", "Nunchuks", &namespace_363acd5d::function_b08504aa, 1, "melee_nunchuks");
	self addOption("Melee Weapons", "Path of Sorrows", &namespace_363acd5d::function_b08504aa, 1, "melee_katana");
	self addOption("Melee Weapons", "Prize Fighters", &namespace_363acd5d::function_b08504aa, 1, "melee_boxing");
	self addOption("Melee Weapons", "Raven's Eye", &namespace_363acd5d::function_b08504aa, 1, "melee_crescent");
	self addOption("Melee Weapons", "Skull Splitter", &namespace_363acd5d::function_b08504aa, 1, "melee_mace");
	self function_5add3549("Specials", "Afterhit Menu");
	self addOption("Specials", "Ballistic Knife", &namespace_363acd5d::function_b08504aa, 1, "knife_ballistic");
	self addOption("Specials", "NX ShadowClaw", &namespace_363acd5d::function_b08504aa, 1, "special_crossbow");
	self addOption("Specials", "NX ShadowClaw Dual Wield", &namespace_363acd5d::function_b08504aa, 1, "special_crossbow_dw");
	self addOption("Specials", "D13 Sector", &namespace_363acd5d::function_b08504aa, 1, "special_discgun");
	self addOption("Specials", "M27", &namespace_363acd5d::function_b08504aa, 1, "gadget_vision_pulse");
	self addOption("Specials", "Pink M27", &namespace_363acd5d::function_b08504aa, 1, "baseweapon");
	self addOption("Specials", "Default Weapon", &namespace_363acd5d::function_b08504aa, 1, "defaultweapon");
	self addOption("Specials", "Bomb Briefcase", &namespace_363acd5d::function_b08504aa, 1, "briefcase_bomb");
	self addOption("Specials", "UAV", &namespace_363acd5d::function_b08504aa, 1, "uav");
	self addOption("Specials", "Carepackage Marker", &namespace_363acd5d::function_b08504aa, 1, "supplydrop_marker");
	self addOption("Specials", "Killstreak Pad", &namespace_363acd5d::function_b08504aa, 1, "killstreak_remote_turret");
	self addOption("Specials", "C4", &namespace_363acd5d::function_b08504aa, 1, "satchel_charge");
	self addOption("Specials", "Black Hat", &namespace_363acd5d::function_b08504aa, 1, "pda_hack");
	self addOption("Specials", "Drop Marker", &namespace_363acd5d::function_b08504aa, 1, "inventory_minigun_drop");
	self addOption("Specials", "Uplink Ball", &namespace_363acd5d::function_b08504aa, 1, "ball");
	self function_5add3549("Specialist Weapons", "Afterhit Menu");
	self addOption("Specialist Weapons", "Reaper Scythe", &namespace_363acd5d::function_b08504aa, 1, "hero_minigun");
	self addOption("Specialist Weapons", "Firebreak Purifier", &namespace_363acd5d::function_b08504aa, 1, "hero_flamethrower");
	self addOption("Specialist Weapons", "Prophet Tempest", &namespace_363acd5d::function_b08504aa, 1, "hero_lightninggun");
	self addOption("Specialist Weapons", "Nomad HIVE", &namespace_363acd5d::function_b08504aa, 1, "hero_chemicalgelgun");
	self addOption("Specialist Weapons", "Battery War Machine", &namespace_363acd5d::function_b08504aa, 1, "hero_pineapplegun");
	self addOption("Specialist Weapons", "Outrider Sparrow", &namespace_363acd5d::function_b08504aa, 1, "hero_bowlauncher");
	self addOption("Specialist Weapons", "Seraph Annihilator", &namespace_363acd5d::function_b08504aa, 1, "hero_annihilator");
	self function_5add3549("Specialist Abilities", "Afterhit Menu");
	self addOption("Specialist Abilities", "Glitch", &namespace_363acd5d::function_b08504aa, 1, "gadget_flashback");
	self addOption("Specialist Abilities", "Psychosis", &namespace_363acd5d::function_b08504aa, 1, "gadget_clone");
	self addOption("Specialist Abilities", "Active Camo", &namespace_363acd5d::function_b08504aa, 1, "gadget_camo");
	self addOption("Specialist Abilities", "Heat Wave", &namespace_363acd5d::function_b08504aa, 1, "gadget_heat_wave");
	self addOption("Specialist Abilities", "Kinetic Armor", &namespace_363acd5d::function_b08504aa, 1, "gadget_armor");
	self addOption("Specialist Abilities", "Rejack", &namespace_363acd5d::function_b08504aa, 1, "gadget_resurrect");
	self function_5add3549("Menu Settings", "Main Menu");
	self addOption("Menu Settings", "Text Popup for Binds", &namespace_363acd5d::function_bff85051);
	self addOption("Menu Settings", "Reset Scrollbar Positions on Close", &function_35800fc);
	self addOption("Menu Settings", "Reset Toggles On Round Change", &function_a3c31091);
	self addOption("Menu Settings", "Console FOV Behavior", &namespace_363acd5d::function_3b588dbd);
	self addOption("Menu Settings", "Mod Info", &function_9f479280, "Mod Info");
	self function_5add3549("Mod Info", "Menu Settings");
	self addOption("Mod Info", "Menu Help", &namespace_363acd5d::help);
	self addOption("Mod Info", "VIP Info", &function_1896532d, 1);
	self addOption("Mod Info", "Support", &namespace_363acd5d::support);
	self addOption("Mod Info", "Discord", &namespace_363acd5d::function_d2065837);
	self addOption("Mod Info", "Twitter", &namespace_363acd5d::function_dec31dfe);
}

function function_f82260a(menu, bind, func, arg)
{
	self addOption(menu, "Set Bind to: ^3[{+actionslot 1}]^7", &namespace_98fc914::function_70c4e6b8, bind, 1, func, arg);
	self addOption(menu, "Set Bind to: ^3[{+actionslot 2}]^7", &namespace_98fc914::function_70c4e6b8, bind, 2, func, arg);
	self addOption(menu, "Set Bind to: ^3[{+actionslot 3}]^7", &namespace_98fc914::function_70c4e6b8, bind, 3, func, arg);
	self addOption(menu, "Set Bind to: ^3[{+actionslot 4}]^7", &namespace_98fc914::function_70c4e6b8, bind, 4, func, arg);
	self addOption(menu, "Set Bind to: ^3[{+smoke}]^7", &namespace_98fc914::function_70c4e6b8, bind, 5, func, arg);
	self addOption(menu, "Set Bind to: ^3[{+frag}]^7", &namespace_98fc914::function_70c4e6b8, bind, 6, func, arg);
}

function function_5add3549(menu, var_806cc01d)
{
	self.menu.option[menu] = [];
	self.menu.func[menu] = [];
	self.menu.arg1[menu] = [];
	self.menu.arg2[menu] = [];
	self.menu.arg3[menu] = [];
	self.menu.arg4[menu] = [];
	self.menu.var_25a9347b[menu] = 0;
	if(isdefined(var_806cc01d))
	{
		self.menu.var_806cc01d[menu] = var_806cc01d;
	}
}

function addOption(menu, text, func, arg, arg2, arg3, arg4)
{
	option = self.menu.option[menu].size;
	self.menu.option[menu][option] = text;
	self.menu.func[menu][option] = func;
	if(isdefined(arg))
	{
		self.menu.arg1[menu][option] = arg;
	}
	if(isdefined(arg2))
	{
		self.menu.arg2[menu][option] = arg2;
	}
	if(isdefined(arg3))
	{
		self.menu.arg3[menu][option] = arg3;
	}
	if(isdefined(arg4))
	{
		self.menu.arg4[menu][option] = arg4;
	}
}

function function_fb34bd0(except)
{
	foreach(elem in self.menu.elem)
	{
		if(isdefined(except) && elem == except)
		{
			continue;
		}
		if(IsArray(elem))
		{
			foreach(var_1f5344e6 in elem)
			{
				var_1f5344e6 destroy();
			}
			continue;
		}
		elem destroy();
	}
}

function function_1896532d(var_3da1b631)
{
	self function_4506dea5();
	self playlocalsound("mpl_killconfirm_tags_pickup");
	self.var_6dcd0fb8.elem["bg"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 50, "white", 200, 310, (0, 0, 0), 0.6, -4);
	self.var_6dcd0fb8.elem["title_bg"] = self namespace_bd1e7d57::function_cfd4873c("LEFT", "TOP", 100, 50, "white", 200, 28, (0, 0, 0), 0.6, -3);
	self.var_6dcd0fb8.elem["title"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.6, "LEFT", "TOP", 105, 55, 2, 1, (0, 0, 0), "VIP Info");
	if(!var_3da1b631)
	{
		self.var_6dcd0fb8.elem["text"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.4, "LEFT", "TOP", 105, 80, 2, 1, (0, 0, 0), "You need ^3VIP ^7to access this! ^3VIP ^7Includes: - EB Menu - Nac Binds - Change Class Binds - Canswap Binds - Equipment Binds - Afterhits & more");
	}
	else
	{
		self.var_6dcd0fb8.elem["text"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.4, "LEFT", "TOP", 105, 80, 2, 1, (0, 0, 0), "Interested in ^3VIP^7? ^3VIP ^7Includes: - EB Menu - Nac Binds - Change Class Binds - Canswap Binds - Equipment Binds - Afterhits & more");
	}
	self.var_6dcd0fb8.elem["price"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.4, "LEFT", "TOP", 105, 250, 2, 1, (0, 0, 0), "Price: ^3$10.99 USD ^7for ^3LIFETIME ^7If you're interested, please join ^5brad.stream/discord ^7and look at ^6#bo3-pm-menu-vip ^7for more details");
	self.var_6dcd0fb8.elem["xuid"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.1, "LEFT", "TOP", 105, 342, 2, 1, (0, 0, 0), "GUID: " + self getXuid());
	self.var_6dcd0fb8.elem["close"] = self namespace_bd1e7d57::function_c1c245d0("console", 1.2, "LEFT", "TOP", 105, 360, 2, 1, (0, 0, 0), "Press ^3[{+gostand}]/[{+stance}] ^7to close");
	self.var_6dcd0fb8.open = 1;
	self thread function_e0e3c254();
}

function function_11df8ea5()
{
	foreach(elem in self.var_6dcd0fb8.elem)
	{
		elem destroy();
	}
	self.var_6dcd0fb8.open = 0;
	self notify("hash_b6200a09");
}

function function_e0e3c254()
{
	self endon("hash_3a4399f6");
	self endon("disconnect");
	while(self JumpButtonPressed() || self StanceButtonPressed() && self.var_6dcd0fb8.open)
	{
		self function_11df8ea5();
		wait(0.1);
		self function_2125a00d();
		self notify("hash_3a4399f6");
		wait(0.05);
	}
}

function function_4506dea5()
{
	if(isdefined(self.menu.open) && self.menu.open)
	{
		self function_de62df31();
	}
	if(isdefined(self.var_6dcd0fb8.open) && self.var_6dcd0fb8.open)
	{
		self function_11df8ea5();
	}
}

function function_35800fc()
{
	if(!isdefined(self.pers["reset_scrollbar"]))
	{
		self.pers["reset_scrollbar"] = 1;
		self namespace_bd1e7d57::message("Reset Scrollbar Positions ^2Enabled");
	}
	else
	{
		self.pers["reset_scrollbar"] = undefined;
		self namespace_bd1e7d57::message("Reset Scrollbar Positions ^1Disabled");
	}
}

function function_a3c31091()
{
	if(!isdefined(self.pers["reset_toggles"]))
	{
		self.pers["reset_toggles"] = 1;
		self namespace_bd1e7d57::message("Reset Toggles ^2Enabled");
	}
	else
	{
		self.pers["reset_toggles"] = undefined;
		self namespace_bd1e7d57::message("Reset Toggles ^1Disabled");
	}
}

function function_5f657bde(player)
{
	if(player namespace_93996bb7::function_bb9f3b9b())
	{
		self namespace_bd1e7d57::message("^1Player is already a Co-Host!");
		return;
	}
	List = GetDvarString("cohost_list", "");
	SetDvar("cohost_list", List + player.name + ";");
	self namespace_bd1e7d57::message("^2Added ^7" + player.name + "as ^6Co-Host");
	player namespace_bd1e7d57::message("^6" + self.name + " ^7made you ^6Co-Host!");
	wait(0.05);
	player function_2f95538e();
	if(isdefined(player.menu.open) && player.menu.open)
	{
		player function_9f479280(player.menu.var_6640885);
	}
}

function function_13b4f490(player)
{
	if(!player namespace_93996bb7::function_bb9f3b9b())
	{
		self namespace_bd1e7d57::message("^1Player is not a Co-Host!");
		return;
	}
	List = StrTok(GetDvarString("cohost_list", ""), ";");
	var_a711f955 = "";
	foreach(var_15ea2311 in List)
	{
		if(var_15ea2311 != player.name)
		{
			var_a711f955 = var_a711f955 + var_15ea2311 + ";";
		}
	}
	SetDvar("cohost_list", var_a711f955);
	self namespace_bd1e7d57::message("^1Removed ^7" + player.name + "as ^6Co-Host");
	player namespace_bd1e7d57::message("^1You are no longer a Co-Host!");
	wait(0.05);
	player function_2f95538e();
	if(isdefined(player.menu.open) && player.menu.open)
	{
		player function_9f479280(player.menu.var_6640885);
	}
}