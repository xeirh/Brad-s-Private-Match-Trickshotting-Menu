#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_hacker_tool;

#namespace _spawn;

function SpawnDart()
{
	if(!isdefined(self.darts))
	{
		self.darts = [];
	}
	index = self.darts.size;
	self.darts[index] = SpawnVehicle("veh_dart_mp", self namespace_bd1e7d57::function_d3902d4c(200), self.angles, "dynamic_spawn_ai");
	self.darts[index].team = self.team;
	self.darts[index].maxhealth = 99999;
	self.darts[index].health = 99999;
	self namespace_bd1e7d57::message("Spawned ^2Dart");
}

function function_3c4f5cae()
{
	foreach(dart in self.darts)
	{
		dart delete();
	}
	self.darts = [];
	self namespace_bd1e7d57::message("^1Deleted ^7All Darts");
}

function function_e8b3531d(type)
{
	if(!isdefined(self.slides))
	{
		self.slides = [];
	}
	index = self.slides.size;
	self.slides[index] = spawn("script_model", self.origin + VectorScale((0, 0, 1), 9));
	self.slides[index] SetModel("wpn_t7_care_package_world");
	self.slides[index].angles = (0, self getPlayerAngles()[1] - 90, 60);
	self thread function_aed11560(self.slides[index], type);
	self namespace_bd1e7d57::message("Spawned ^1" + type + " ^7Slide");
}

function function_aed11560(entity, type)
{
	self endon("hash_527e47de");
	self endon("disconnect");
	level endon("game_ended");
	for(;;)
	{
		angles = AnglesToForward(self getPlayerAngles());
		if(self meleeButtonPressed() || self AttackButtonPressed() && Distance(self.origin, entity.origin) < 70)
		{
			i = 0;
			if(type == "Normal")
			{
				while(i < 15)
				{
					self SetVelocity((angles[0] * 300, angles[1] * 300, 999));
					wait(0.05);
					i++;
				}
				break;
			}
			if(type == "High")
			{
				while(i < 30)
				{
					self SetVelocity((angles[0] * 300, angles[1] * 300, 999));
					wait(0.05);
					i++;
				}
				break;
			}
			if(type == "Insane")
			{
				while(i < 30)
				{
					self SetVelocity(self GetVelocity() + (angles[0] * 150, angles[1] * 150, 999));
					wait(0.05);
					i++;
				}
			}
		}
		wait(0.05);
	}
}

function function_c5793b82()
{
	self notify("hash_527e47de");
	foreach(slide in self.slides)
	{
		slide delete();
	}
	self.slides = [];
	self namespace_bd1e7d57::message("^1Deleted ^7All Slides");
}

function function_f58c763()
{
	self endon("disconnect");
	if(!isdefined(self.var_292884fe))
	{
		self.var_292884fe = [];
	}
	else
	{
		foreach(Crate in self.var_292884fe)
		{
			Crate delete();
		}
		self.var_292884fe = [];
	}
	startPos = self.origin + VectorScale((0, 0, -1), 15);
	for(i = -3; i < 3; i++)
	{
		for(j = -3; j < 3; j++)
		{
			index = self.var_292884fe.size;
			self.var_292884fe[index] = spawn("script_model", startPos + (j * 40, i * 70, 0));
			self.var_292884fe[index] SetModel("wpn_t7_care_package_world");
		}
	}
	self namespace_bd1e7d57::message("^2Spawned ^7Platform");
}

function function_f27faaca()
{
	self endon("disconnect");
	if(isdefined(self.platform))
	{
		self.platform.origin = self.origin;
	}
	else
	{
		self.platform = spawncollision("collision_clip_wall_128x128x10", "collider", self.origin, VectorScale((1, 0, 0), 90));
		self.platform.angles = VectorScale((1, 0, 0), 90);
	}
	self namespace_bd1e7d57::message("^2Spawned ^7Invisible Platform");
}

function function_270f33bd()
{
	if(isdefined(self.var_292884fe))
	{
		foreach(Crate in self.var_292884fe)
		{
			Crate delete();
		}
	}
	else if(isdefined(self.platform))
	{
		self.platform delete();
	}
	self.var_292884fe = [];
	self.platform = undefined;
	self namespace_bd1e7d57::message("^1Deleted ^7Platforms");
}

function function_b303ec85()
{
	self namespace_bd1e7d57::message("^2Spawned ^7Carepackage Stall");
	function_9a9db903(self.origin, (0, self getPlayerAngles()[1], 0), "supplydrop_mp", self, self.team, self.killCamEnt);
}

function function_da197ddf()
{
	self namespace_bd1e7d57::message("^2Spawned ^7Carepackage Stall @ Crosshair");
	trace = self namespace_bd1e7d57::function_d3902d4c();
	if(Distance(self.origin, trace) < 600)
	{
		function_9a9db903(trace, (0, self getPlayerAngles()[1], 0), "supplydrop_mp", self, self.team, self.killCamEnt);
	}
	else
	{
		function_9a9db903(self GetEye() + AnglesToForward(self getPlayerAngles()) * 600, self.angles, "supplydrop_mp", self, self.team, self.killCamEnt);
	}
}

function function_7921a9ca()
{
	self namespace_bd1e7d57::message("^1Deleted ^7All Carepackage Stalls");
	self notify("hash_409ed57a");
}

function function_9a9db903(origin, angle, killstreak, owner, team, killCamEnt, killstreak_id, package_contents_id, crate_, context)
{
	angle = (angle[0] * 0.5, angle[1] * 0.5, angle[2] * 0.5);
	if(isdefined(crate_))
	{
		origin = crate_.origin;
		angle = crate_.angles;
		crate_ thread supplydrop::WaitAndDelete(0.1);
	}
	Crate = supplydrop::crateSpawn(killstreak, killstreak_id, owner, team, origin, angle);
	killCamEnt Unlink();
	killCamEnt LinkTo(Crate);
	Crate.killCamEnt = killCamEnt;
	Crate.killstreak_id = killstreak_id;
	Crate.package_contents_id = package_contents_id;
	killCamEnt thread util::deleteAfterTime(15);
	killCamEnt thread supplydrop::unlinkOnRotation(Crate);
	Crate endon("death");
	Crate thread function_2d41a179();
	Crate thread hacker_tool::registerWithHackerTool(level.carePackageHackerToolRadius, level.carePackageHackerToolTimeMs);
	supplydrop::CleanUp(context, owner);
	if(isdefined(Crate.crateType) && isdefined(Crate.crateType.landFunctionOverride))
	{
		[[Crate.crateType.landFunctionOverride]](Crate, killstreak, owner, team, context);
	}
	else
	{
		Crate supplydrop::crateActivate();
		Crate thread function_cb0aba81();
		supplydrop::default_land_function(Crate, killstreak, owner, team);
	}
}

function function_cb0aba81()
{
	while(isdefined(self))
	{
		self waittill("trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		useEnt = self supplydrop::spawnUseEnt();
		result = 0;
		if(isdefined(self.hacker))
		{
			useEnt.hacker = self.hacker;
		}
		self.useEnt = useEnt;
		result = useEnt function_12b18b7(player, 3000);
		if(isdefined(useEnt))
		{
			useEnt delete();
		}
		if(result)
		{
			self notify("captured", player, 0);
		}
	}
}

function function_12b18b7(player, useTime)
{
	player notify("use_hold");
	player.var_ea62c32e = spawn("script_origin", player.origin);
	player.var_ea62c32e.angles = player.angles;
	player playerLinkTo(player.var_ea62c32e);
	player util::_disableWeapon();
	self.curProgress = 0;
	self.inUse = 1;
	self.useRate = 0;
	self.useTime = useTime;
	player thread supplydrop::personalUseBar(self);
	result = supplydrop::useHoldThinkLoop(player);
	if(isdefined(player))
	{
		player notify("done_using");
	}
	if(isdefined(player))
	{
		if(isalive(player))
		{
			player util::_enableWeapon();
			player.var_ea62c32e delete();
			player Unlink();
			if(level.gameEnded)
			{
				player FreezeControls(1);
			}
		}
	}
	if(isdefined(self))
	{
		self.inUse = 0;
	}
	if(isdefined(result) && result)
	{
		return 1;
	}
	return 0;
}

function function_2d41a179()
{
	self.owner waittill("hash_409ed57a");
	self notify("death");
	self supplydrop::crateDelete();
}