#using scripts\mp\gametypes\brad_menu\_binds;
#using scripts\mp\gametypes\brad_menu\_eb;
#using scripts\mp\gametypes\brad_menu\_funcs;
#using scripts\mp\gametypes\brad_menu\_oom;
#using scripts\mp\gametypes\brad_menu\_snd;
#using scripts\shared\util_shared;

#namespace namespace_5d0c2147;

function function_a0beddb2()
{
	self.var_4ba2b8f1 = undefined;
	self.var_f766edbf = 0;
	self.var_6c2dc41d = 0;
	self.var_ca808b3c = 0;
	if(!isdefined(self.pers["bolt_origins"]))
	{
		self.pers["bolt_origins"] = [];
	}
	if(isdefined(self.pers["reset_toggles"]))
	{
		self.pers["saved_origin"] = undefined;
		self.pers["saved_angles"] = undefined;
		self.pers["saved_pos"] = undefined;
		self.pers["save_load"] = undefined;
		self.pers["load_on_spawn"] = undefined;
		self.pers["streaks_bind"] = undefined;
		self.pers["floaters"] = undefined;
		self.pers["unlimited_boost"] = undefined;
		self.pers["unlimited_equip"] = undefined;
		self.pers["unlimited_ammo"] = undefined;
		self.pers["console_fov"] = undefined;
		self.pers["eb_range"] = undefined;
		self.pers["eb_delay"] = undefined;
		self.pers["eb_weapon"] = undefined;
		self.pers["eb_trail"] = undefined;
		self.pers["cowboy_bind"] = undefined;
		self.pers["canswap_always"] = undefined;
		self.pers["canswap_class"] = undefined;
		self.pers["nacswap"] = undefined;
		self.pers["ufo"] = undefined;
		self.pers["invisible"] = undefined;
		self.pers["third_person"] = undefined;
		self.pers["godmode"] = undefined;
		self.pers["rocket_on_spawn"] = undefined;
		self.pers["nac_canswap"] = undefined;
		self.pers["nac_weap"] = undefined;
		self.pers["nac_weap2"] = undefined;
		self.pers["afterhit"] = undefined;
		self.pers["afterhit_weapon"] = undefined;
		self.pers["third_weapon"] = undefined;
		self.pers["freeze_round_end"] = undefined;
		self.pers["vision"] = undefined;
		self.pers["constant_uav"] = undefined;
		self.pers["bolt_origins"] = [];
		self.pers["bolt_speed"] = 1;
		PERKS = getArrayKeys(level.var_46955f4b);
		foreach(perk in PERKS)
		{
			self.pers[perk] = undefined;
		}
	}
	else if(!isdefined(self.pers["binds"]) || isdefined(self.pers["reset_toggles"]))
	{
		self.pers["binds"] = [];
		var_83cc8133 = StrTok("nac;nac_next;repeat;fade_black;bolt;canswap;glitch;psychosis;active_camo;kinetic_armor;rejack;heat_wave;cowboy;lastshot;CLASS_CUSTOM1;CLASS_CUSTOM2;CLASS_CUSTOM3;CLASS_CUSTOM4;CLASS_CUSTOM5;classchange;briefcase_bomb;uav;supplydrop_marker;killstreak_remote_turret;satchel_charge;pda_hack;inventory_minigun_drop;ball;gadget_vision_pulse;briefcase_bomb_mala;supplydrop_marker_mala;killstreak_remote_turret_mala;satchel_charge_mala;pda_hack_mala;inventory_minigun_drop_mala;gadget_vision_pulse_mala", ";");
		var_bd76f073 = StrTok("Nac;Nac Next;Repeater;Fade to Black;Bolt Movement;Canswap;Glitch;Psychosis;Active Camo;Kinetic Armor;Rejack;Heat Wave;Cowboy;Last Shot;Custom Class 1;Custom Class 2;Custom Class 3;Custom Class 4;Custom Class 5;Change Between Classes;Bomb Briefcase;UAV;Carepackage Marker;Killstreak Pad;C4;Black Hat;Drop Marker;Uplink Ball;M27;Bomb Briefcase rMala;Carepackage Marker rMala;Killstreak Pad rMala;C4 rMala;Black Hat rMala;Drop Marker rMala;M27 rMala", ";");
		for(i = 0; i < var_83cc8133.size; i++)
		{
			self.pers["binds"][var_83cc8133[i]] = [];
			self.pers["binds"][var_83cc8133[i]]["name"] = var_bd76f073[i];
			self.pers["binds"][var_83cc8133[i]]["slot"] = 0;
		}
	}
}

function function_2bdcb50()
{
	level.var_2e02fdd5 = 0;
	level.var_60c52a66 = [];
	level.var_60c52a66["mp_biodome"] = 100;
	level.var_60c52a66["mp_spire"] = 400;
	level.var_60c52a66["mp_sector"] = 200;
	level.var_60c52a66["mp_apartments"] = 150;
	level.var_60c52a66["mp_ethiopia"] = 300;
	level.var_60c52a66["mp_stronghold"] = 600;
	level.var_60c52a66["mp_chinatown"] = 100;
	level.var_60c52a66["mp_redwood"] = 600;
	level.var_60c52a66["mp_infection"] = 300;
	level.var_60c52a66["mp_skyjacked"] = 600;
	level.var_60c52a66["mp_aerospace"] = 700;
	level.var_60c52a66["mp_conduit"] = 700;
	level.var_60c52a66["mp_miniature"] = 350;
	level.var_60c52a66["mp_shrine"] = 100;
	namespace_363acd5d::function_33579a2("specialty_jetcharger");
	namespace_363acd5d::function_33579a2("specialty_fallheight");
	namespace_363acd5d::function_33579a2("specialty_bulletaccuracy");
	namespace_363acd5d::function_33579a2("specialty_fastreload");
	namespace_363acd5d::function_33579a2("specialty_fastads");
	namespace_363acd5d::function_33579a2("specialty_stalker");
	namespace_363acd5d::function_33579a2("specialty_fastweaponswitch", "specialty_sprintrecovery", "specialty_sprintfirerecovery");
	namespace_363acd5d::function_33579a2("specialty_sprintfire", "specialty_sprintgrenadelethal", "specialty_sprintgrenadetactical", "specialty_sprintequipment");
	if(GetDvarInt("toggle_low_gravity", 0) == 1)
	{
		SetDvar("bg_gravity", 250);
	}
	if(GetDvarInt("toggle_autoplant", 0) == 1)
	{
		level thread namespace_79d1d819::function_35d367d3();
	}
	if(GetDvarInt("toggle_oom_barriers", 0) == 1)
	{
		namespace_24575103::function_96c8359d(0);
	}
	if(GetDvarInt("toggle_death_barriers", 0) == 1)
	{
		namespace_24575103::function_d5873f7b(0);
	}
	if(GetDvarInt("toggle_lower_barriers", 0) == 1)
	{
		namespace_24575103::function_484b3988(level.var_60c52a66[GetDvarString("mapname")] * -1);
	}
	if(GetDvarFloat("toggle_timescale", 1) != 1)
	{
		SetDvar("timescale", GetDvarFloat("toggle_timescale", 1));
	}
	if(GetDvarInt("toggle_pickup_radius", 128) != 128)
	{
		SetDvar("toggle_pickup_radius", GetDvarInt("toggle_pickup_radius", 128));
	}
	if(GetDvarInt("toggle_infinite_range", 8192) != 8192)
	{
		SetDvar("bulletrange", GetDvarInt("toggle_infinite_range", 8192));
	}
	if(GetDvarInt("toggle_almost_hit", 0) == 1)
	{
		level thread namespace_363acd5d::function_1aa4f3b3();
	}
}

function function_f96501ce()
{
	if(isdefined(self.pers["save_load"]))
	{
		self thread namespace_363acd5d::function_d3444e8c();
	}
	if(isdefined(self.pers["streaks_bind"]))
	{
		self thread namespace_363acd5d::function_6529a157();
	}
	if(isdefined(self.pers["floaters"]))
	{
		self thread namespace_363acd5d::function_f3f32dcd();
	}
	if(isdefined(self.pers["unlimited_boost"]))
	{
		self thread namespace_363acd5d::function_c3fe27aa();
	}
	if(isdefined(self.pers["unlimited_equip"]))
	{
		self thread namespace_363acd5d::function_340e2960();
	}
	if(isdefined(self.pers["unlimited_ammo"]))
	{
		self thread namespace_363acd5d::unlimitedammo();
	}
	if(isdefined(self.pers["console_fov"]))
	{
		if(self IsHost())
		{
			level.var_2e02fdd5 = 1;
			if(!isdefined(self.pers["smarr_fov"]))
			{
				self thread namespace_363acd5d::function_3d1a8007();
			}
		}
		self namespace_363acd5d::function_3cc384fa();
	}
	if(isdefined(self.pers["eb_range"]))
	{
		range = namespace_6a0d8055::function_e53aacd(self.pers["eb_range"]);
		self thread namespace_6a0d8055::function_389ef4c7(range);
	}
	if(isdefined(self.pers["cowboy_bind"]))
	{
		SetDvar("cg_gun_z", "10");
	}
	if(isdefined(self.pers["canswap_always"]))
	{
		self thread namespace_363acd5d::function_fa1ddaed();
	}
	if(isdefined(self.pers["ufo"]))
	{
		self thread namespace_363acd5d::function_c7249b63();
	}
	if(isdefined(self.pers["freeze_round_end"]))
	{
		self thread namespace_363acd5d::function_69dae33f();
	}
	if(GetDvarInt("toggle_almost_hit", 0) == 1)
	{
		self thread namespace_363acd5d::function_deb9e622();
	}
	var_83cc8133 = getArrayKeys(self.pers["binds"]);
	foreach(type in var_83cc8133)
	{
		if(self.pers["binds"][type]["slot"] != 0)
		{
			self namespace_98fc914::function_70c4e6b8(type, self.pers["binds"][type]["slot"], self.pers["binds"][type]["func"], self.pers["binds"][type]["func_arg"], 1);
		}
	}
}

function function_af18ab33()
{
	if(isdefined(self.pers["invisible"]))
	{
		self Hide();
	}
	if(isdefined(self.pers["third_person"]))
	{
		self SetClientThirdPerson(1);
		self SetClientThirdPersonAngle(354);
		self setDepthOfField(0, 128, 512, 4000, 6, 1.8);
	}
	if(isdefined(self.pers["godmode"]))
	{
		self EnableInvulnerability();
	}
	if(isdefined(self.pers["rocket_on_spawn"]))
	{
		self thread namespace_363acd5d::function_aa8fcac6();
	}
	if(isdefined(self.pers["vision"]))
	{
		self UseServerVisionset(1);
		self SetVisionSetForPlayer(self.pers["vision"]);
	}
	if(isdefined(self.pers["constant_uav"]))
	{
		self setClientUIVisibilityFlag("g_compassShowEnemies", 2);
	}
	PERKS = getArrayKeys(level.var_46955f4b);
	foreach(perk in PERKS)
	{
		if(isdefined(self.pers[perk]))
		{
			self namespace_363acd5d::function_c389b506(perk);
		}
	}
}

function function_24801e0b()
{
	if(isdefined(self.pers["load_on_spawn"]) && isdefined(self.pers["saved_pos"]))
	{
		self namespace_363acd5d::function_3b5807e5(0);
	}
}

function function_a9f1002a()
{
	PERKS = getArrayKeys(level.var_46955f4b);
	foreach(perk in PERKS)
	{
		if(isdefined(self.pers[perk]))
		{
			self namespace_363acd5d::function_c389b506(perk);
		}
	}
	if(self util::is_bot())
	{
		self thread namespace_363acd5d::function_12b2d29f();
	}
}