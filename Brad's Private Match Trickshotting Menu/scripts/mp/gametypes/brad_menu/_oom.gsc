#using scripts\mp\gametypes\brad_menu\_utils;

#namespace namespace_24575103;

function function_30e7e48d()
{
	if(GetDvarInt("toggle_death_barriers", 0) == 0)
	{
		level namespace_bd1e7d57::message("Death Barriers ^1Disabled");
		function_d5873f7b(0);
		SetDvar("toggle_death_barriers", 1);
	}
	else
	{
		level namespace_bd1e7d57::message("Death Barriers ^2Enabled");
		function_d5873f7b(1);
		SetDvar("toggle_death_barriers", 0);
	}
}

function function_84988bde()
{
	if(GetDvarInt("toggle_oom_barriers", 0) == 0)
	{
		level namespace_bd1e7d57::message("OOM Death Barriers ^1Disabled");
		function_96c8359d(0);
		SetDvar("toggle_oom_barriers", 1);
	}
	else
	{
		level namespace_bd1e7d57::message("OOM Death Barriers ^2Enabled");
		function_96c8359d(1);
		SetDvar("toggle_oom_barriers", 0);
	}
}

function function_96c8359d(toggle)
{
	if(toggle == 0)
	{
		hurt_triggers = GetEntArray("trigger_out_of_bounds", "classname");
		foreach(trigger in hurt_triggers)
		{
			trigger.origin = trigger.origin - VectorScale((0, 0, 1), 99999);
		}
		
		// something broke here
	}
	hurt_triggers = GetEntArray("trigger_out_of_bounds", "classname");
	foreach(trigger in hurt_triggers)
	{
		trigger.origin = trigger.origin + VectorScale((0, 0, 1), 99999);
	}
}


function function_d5873f7b(toggle)
{
	if(toggle == 0)
	{
		hurt_triggers = GetEntArray("trigger_hurt", "classname");
		foreach(trigger in hurt_triggers)
		{
			trigger.origin = trigger.origin - VectorScale((0, 0, 1), 99999);
		}
		
		// something broke here
	}
	hurt_triggers = GetEntArray("trigger_hurt", "classname");
	foreach(trigger in hurt_triggers)
	{
		trigger.origin = trigger.origin + VectorScale((0, 0, 1), 99999);
	}
}

function function_788981d7()
{
	hurt_triggers = GetEntArray("trigger_hurt", "classname");
	foreach(trigger in hurt_triggers)
	{
		if(trigger.origin[2] > 0)
		{
			trigger delete();
		}
	}
}

function function_233db4ea()
{
	mapname = GetDvarString("mapname");
	if(!isdefined(level.var_60c52a66[mapname]))
	{
		self namespace_bd1e7d57::message("^1This map doesn't support this!");
		return;
	}
	if(GetDvarInt("toggle_lower_barriers", 0) == 0)
	{
		function_484b3988(level.var_60c52a66[mapname] * -1);
		SetDvar("toggle_lower_barriers", 1);
		self namespace_bd1e7d57::message("Lower Barriers ^2Enabled");
	}
	else
	{
		function_484b3988(level.var_60c52a66[mapname]);
		SetDvar("toggle_lower_barriers", 0);
		self namespace_bd1e7d57::message("Lower Barriers ^1Disabled");
	}
}

function function_484b3988(var_3389d184)
{
	hurt_triggers = GetEntArray("trigger_hurt", "classname");
	foreach(trigger in hurt_triggers)
	{
		trigger.origin = trigger.origin + (0, 0, var_3389d184);
	}
}

function function_f46216e6()
{
	level.var_a8594817 = [];
	mapname = GetDvarString("mapname");
	if(mapname == "mp_spire")
	{
		function_a57c24ce((3545.52, 3553.95, 569.726), (90, -90.7709, 0), "large");
		function_a57c24ce((-6400.75, -9185.27, 5545.01), (90, 3.3731, 0), "large");
		function_a57c24ce((-6362.53, -9405.68, 5543.72), (90, 9.88327, 0), "large");
		function_a57c24ce((-1625.06, 568.953, 542.311), (90, 43.2574, 0), "large");
	}
	else if(mapname == "mp_sector")
	{
		function_a57c24ce((-8451.46, -12639, 6285.89), (90, 58.7414, 0), "large");
		function_a57c24ce((8507.1, -518.234, 4825.68), (90, -135.562, 0), "med");
	}
	else if(mapname == "mp_biodome")
	{
		function_a57c24ce((8425.01, -3487.01, 320.129));
		function_a57c24ce((10371.5, -7815.37, 7252.6), (90, 115.679, 0), "large");
		function_a57c24ce((13972, 13210.2, 5356.36), (90, -134.754, 0), "large");
		function_a57c24ce((11699.2, 2815.05, 459.95));
	}
	else if(mapname == "mp_apartments")
	{
		function_a57c24ce((-6171.6, -2646.58, 1829.69));
		function_a57c24ce((5232.53, -9715.92, 12427), (90, 163.401, 0), "large");
		function_a57c24ce((2383.58, 3050.24, 1563.85), (90, -111.957, 0), "large");
		function_a57c24ce((8457.2, 14445.2, 7495.65), (90, -179.19, 0), "large");
		function_a57c24ce((-3400.23, 15149.5, 5910.54), (90, 179.305, 0), "large");
	}
	else if(mapname == "mp_veiled" || mapname == "mp_veiled_heyday")
	{
		function_a57c24ce((-16363.3, 14356.9, 13013.1), (90, -94.4358, 0), "large");
		function_a57c24ce((256.21, 3411.01, 312.945));
		function_a57c24ce((3040.72, 2582.15, 2965.61), (90, 57.7998, 0), "med");
		function_a57c24ce((3018.04, -1193.62, 453.402));
		function_a57c24ce((729.487, -2608.03, 393.285), (90, 52.6688, 0), "small");
		function_a57c24ce((774.551, 2900.48, 390.125));
		function_a57c24ce((2364.13, -1165.15, 412.838));
	}
	else if(mapname == "mp_havoc")
	{
		function_a57c24ce((-1403.04, 5094.67, 637.267), (90, 35.4113, 0), "small");
		function_a57c24ce((1074.7, 5459.55, 393.844), (90, -114.195, 0), "large");
		function_a57c24ce((-1745.66, -790.273, 457.292));
		function_a57c24ce((-144.725, -3292.8, 3507.13));
	}
	else if(mapname == "mp_ethiopia")
	{
		function_a57c24ce((-319.388, -127.522, 288.125));
		function_a57c24ce((-208.305, -1817.13, 955.745));
		function_a57c24ce((4143.99, 10208.8, 38.0509));
		function_a57c24ce((-4837.55, 6558.41, -151.311), (90, 4.71614, 0), "large");
		function_a57c24ce((875.684, 1858.72, -19.3888), (90, 104.204, 0), "med");
		function_a57c24ce((-1127.24, 1264.92, 14.6522), (90, 65.6281, 0), "med");
	}
	else if(mapname == "mp_metro")
	{
		function_a57c24ce((9012.92, 809.549, -95.875));
		function_a57c24ce((4496.67, -4529.39, 99.4202), (90, 91.2157, 0), "large");
		function_a57c24ce((-465.323, -8856.55, -47.875));
		function_a57c24ce((3779.17, 22445.1, 11378.4), (90, -93.4829, 0), "large");
	}
	else if(mapname == "mp_stronghold")
	{
		function_a57c24ce((-766.598, -3930.93, -341.875));
		function_a57c24ce((4586.03, -3745.28, 1826.09), (90, -130.825, 0), "large");
		function_a57c24ce((4004.36, -2160.19, 2377.96), (90, -179.16, 0), "large");
		function_a57c24ce((1919.27, -3215.33, 323.382));
	}
	else if(mapname == "mp_nuketown_x")
	{
		function_a57c24ce((136.129, -32743.9, 2108.13));
		function_a57c24ce((-29.8735, -1219.6, 895.125));
		function_a57c24ce((155.694, 1367.29, 896.125));
		function_a57c24ce((17573.3, 8547.66, 5989.52), (90, -148.45, 0), "large");
		function_a57c24ce((-8133.96, 23624, 8529.54), (90, -110.765, 0), "large");
	}
	else if(mapname == "mp_chinatown")
	{
		function_a57c24ce((-4247.83, -11391.1, 4713.25), (90, 87.2351, 0), "large");
		function_a57c24ce((9438.76, 2024.72, 2354.2), (90, -149.713, 0), "med");
		function_a57c24ce((11585.6, 6264.68, 2553.02), (90, 179.336, 0), "large");
	}
	else if(mapname == "mp_redwood")
	{
		function_a57c24ce((-12968.2, 1775.32, -224.512));
		function_a57c24ce((253.405, 8078.47, -63.1646), (90, -132.691, 0), "large");
		function_a57c24ce((-4416.85, -238.047, -485.175));
	}
	else if(mapname == "mp_infection")
	{
		function_a57c24ce((3413.96, -471.652, 259.361), (90, 45.636, 0), "small") function_a57c24ce((4997.67, 3153.77, 173.013), (90, -133.392, 0), "large");
		function_a57c24ce((6363.45, 1296.07, 404.814), (90, -91.2686, 0), "large");
		function_a57c24ce((2951.31, 770.814, 262.933), (90, -92.1908, 0), "large");
	}
	else if(mapname == "mp_aerospace")
	{
		function_a57c24ce((-4150.98, -2472.82, 2549.92), (90, -12.2782, 0), "massive");
		function_a57c24ce((-3496.42, -3416.34, 6051.93), (90, 46.8193, 0), "large");
		function_a57c24ce((-613.555, -5704.72, -30.875));
		function_a57c24ce((-745.118, 5636.54, -30.875));
		function_a57c24ce((-3533.53, 3426.9, 6045.78), (90, 49.9015, 0), "large");
	}
	else if(mapname == "mp_rome")
	{
		function_a57c24ce((1496.6, -5773.87, 334.125));
		function_a57c24ce((-6095.99, 4993.39, 491.666));
		function_a57c24ce((3661.7, 483.641, 425.327));
		function_a57c24ce((4620.1, 1885.14, 154.625));
	}
	else if(mapname == "mp_miniature")
	{
		function_a57c24ce((4721.27, -4281.12, 4928.13));
		function_a57c24ce((4565.58, 2089.01, 725.462));
		function_a57c24ce((5059.8, -761.498, 725.96));
		function_a57c24ce((-3578.57, 1258.18, 645.579), (90, 24.4116, 0), "med");
		function_a57c24ce((5033.23, 1517.05, 735.326));
	}
	else if(mapname == "mp_waterpark")
	{
		function_a57c24ce((492.302, -3555.48, 992.125));
		function_a57c24ce((-9145.97, -1208.66, 694.125));
		function_a57c24ce((-4435.98, 4155.77, 633.452));
		function_a57c24ce((-1692.08, 3921.07, 406.196));
		function_a57c24ce((4945.2, -941.732, 512.125));
		function_a57c24ce((-4406.86, 502.068, 388.387));
	}
	else if(mapname == "mp_conduit")
	{
		function_a57c24ce((-5119.06, -1188, 640.125));
		function_a57c24ce((-4870.95, 904.359, 616.125));
		function_a57c24ce((-5052.46, -2032.23, 1891.82));
		function_a57c24ce((5031.41, 1708.32, 1873.06));
		function_a57c24ce((5243.71, -1185.03, 640.125));
		function_a57c24ce((5463.79, -5.96605, 3712.13));
		function_a57c24ce((-5505.02, -10.8429, 3712.13));
	}
	else if(mapname == "mp_rise")
	{
		function_a57c24ce((-1488.38, 2026.95, 802.476));
		function_a57c24ce((-1570.58, 1674.77, 812.01));
		function_a57c24ce((487.876, -3020.45, 805.222));
		function_a57c24ce((-383.658, -3206.89, 796.284));
		function_a57c24ce((1760, -4211.92, 2904.06), (90, 133.334, 0), "large");
		function_a57c24ce((-7001.45, -1519.45, 804.055), (90, -1.02078, 0), "massive");
	}
	else if(mapname == "mp_rise")
	{
		function_a57c24ce((-1488.38, 2026.95, 802.476));
		function_a57c24ce((-1570.58, 1674.77, 812.01));
		function_a57c24ce((487.876, -3020.45, 805.222));
		function_a57c24ce((-383.658, -3206.89, 796.284));
		function_a57c24ce((1760, -4211.92, 2904.06), (90, 133.334, 0), "large");
		function_a57c24ce((-7001.45, -1519.45, 804.055), (90, -1.02078, 0), "massive");
	}
	else if(mapname == "mp_kung_fu")
	{
		function_a57c24ce((3272.14, -372.704, 2135.11));
		function_a57c24ce((3264.46, 150.519, 2135.13));
		function_a57c24ce((9291.34, -9256.91, 2378.13));
		function_a57c24ce((1329.26, 5005.53, 148.075));
	}
	else if(mapname == "mp_shrine")
	{
		function_a57c24ce((-3964.22, 2270.84, 2748.43), (90, -6.4605, 0), "large");
		function_a57c24ce((2986.76, 13550.7, 1644.24), (90, -101.168, 0), "massive");
		function_a57c24ce((4885.92, -8802.9, 1558.11), (90, 125.6, 0), "large");
		function_a57c24ce((3174.47, 3573.2, 394.744));
	}
	level function_10aecd52();
}

function function_a57c24ce(origin, angles, platform)
{
	dest = [];
	dest["origin"] = origin;
	if(isdefined(angles))
	{
		dest["angles"] = angles;
	}
	if(isdefined(platform))
	{
		dest["platform"] = platform;
	}
	level.var_a8594817[level.var_a8594817.size] = dest;
}

function function_10aecd52()
{
	foreach(dest in level.var_a8594817)
	{
		if(isdefined(dest["platform"]) && IsString(dest["platform"]))
		{
			var_7817cc0 = "collision_clip_wall_128x128x10";
			if(dest["platform"] == "massive")
			{
				var_7817cc0 = "collision_clip_wall_256x256x10";
			}
			else if(dest["platform"] == "large")
			{
				var_7817cc0 = "collision_clip_wall_128x128x10";
			}
			else if(dest["platform"] == "med")
			{
				var_7817cc0 = "collision_clip_wall_64x64x10";
			}
			else if(dest["platform"] == "small")
			{
				var_7817cc0 = "collision_clip_wall_32x32x10";
			}
			dest["platform"] = spawncollision(var_7817cc0, "collider", dest["origin"], dest["angles"]);
		}
	}
}

function function_6ad1816b(dest)
{
	if(GetDvarInt("toggle_oom_barriers", 0) == 0)
	{
		SetDvar("toggle_oom_barriers", 1);
		function_96c8359d(0);
		level namespace_bd1e7d57::message("OOM Death Barriers Automatically ^1Disabled");
	}
	self SetOrigin(dest["origin"] + VectorScale((0, 0, 1), 10));
	self namespace_bd1e7d57::message("^2Teleported ^7to Spot");
}

function function_fca89254()
{
	self SetOrigin(self.spawnpoint);
	self namespace_bd1e7d57::message("^2Teleported ^7to Spawn");
}