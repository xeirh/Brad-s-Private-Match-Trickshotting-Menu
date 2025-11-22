#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\mp\gametypes\sd;
#using scripts\shared\gameobjects_shared;

#namespace namespace_79d1d819;

function function_7cdf7c8c(label)
{
	if(level.bombPlanted)
	{
		self namespace_bd1e7d57::message("^1Bomb is already planted");
		return;
	}
	bombsite = function_b2a58b9a(label);
	self function_cd91d5e9(bombsite);
}

function function_b2a58b9a(label)
{
	label = ToLower(label);
	foreach(bomb in level.bombZones)
	{
		var_f1add8a2 = bomb gameobjects::get_label();
		if(var_f1add8a2 == label || IsSubStr(var_f1add8a2, label))
		{
			return bomb;
		}
	}
	return level.bombZones[0];
}

function function_cd91d5e9(bombsite)
{
	if(level.bombPlanted)
	{
		return;
	}
	var_1f57f4d4 = level.players[0];
	if(isPlayer(self))
	{
		var_1f57f4d4 = self;
	}
	var_e3e9fbac = function_ba3d1e25();
	if(!isdefined(var_e3e9fbac))
	{
		Attackers = namespace_bd1e7d57::function_3390018e(game["attackers"]);
		if(Attackers.size > 0)
		{
			var_1f57f4d4 = Attackers[RandomInt(Attackers.size)];
		}
	}
	else
	{
		var_1f57f4d4 = var_e3e9fbac;
	}
	bombsite SD::onUsePlantObject(var_1f57f4d4, 1);
}

function function_9253b4ef()
{
	if(!level.bombPlanted)
	{
		self namespace_bd1e7d57::message("^1Bomb is not planted");
		return;
	}
	self function_cf36897c();
}

function function_cf36897c()
{
	if(!level.bombPlanted)
	{
		return;
	}
	var_9ac33941 = level.players[0];
	if(isPlayer(self))
	{
		var_9ac33941 = self;
	}
	Defenders = namespace_bd1e7d57::function_3390018e(game["defenders"]);
	if(Defenders.size > 0)
	{
		var_9ac33941 = Defenders[RandomInt(Defenders.size)];
	}
	bombsite = function_175993cd();
	bombsite SD::onUseDefuseObject(var_9ac33941, 1);
}

function function_1a7dc437()
{
	if(GetDvarInt("toggle_autoplant", 0) == 0)
	{
		level thread function_35d367d3();
		SetDvar("toggle_autoplant", 1);
		level namespace_bd1e7d57::message("Auto Plant ^2Enabled");
	}
	else
	{
		level notify("hash_33d99aaf");
		SetDvar("toggle_autoplant", 0);
		level namespace_bd1e7d57::message("Auto Plant ^1Disabled");
	}
}

function function_a42a76e2()
{
	if(GetDvarInt("toggle_autodefuse", 0) == 0)
	{
		SetDvar("toggle_autodefuse", 1);
		level namespace_bd1e7d57::message("Auto Defuse ^2Enabled");
	}
	else
	{
		SetDvar("toggle_autodefuse", 0);
		level namespace_bd1e7d57::message("Auto Defuse ^1Disabled");
	}
}

function function_da0bc41f()
{
	if(GetDvarInt("toggle_bots_cant_plant", 0) == 0)
	{
		SetDvar("toggle_bots_cant_plant", 1);
		level namespace_bd1e7d57::message("Bots Can't Plant/Defuse ^2Enabled");
	}
	else
	{
		SetDvar("toggle_bots_cant_plant", 0);
		level namespace_bd1e7d57::message("Bots Can't Plant/Defuse ^1Disabled");
	}
}

function function_831f6af6()
{
	if(GetDvarInt("toggle_bot_last", 0) == 0)
	{
		SetDvar("toggle_bot_last", 1);
		level namespace_bd1e7d57::message("Bots On Last Life ^2Enabled");
	}
	else
	{
		SetDvar("toggle_bot_last", 0);
		level namespace_bd1e7d57::message("Bots On Last Life ^1Disabled");
	}
}

function function_35d367d3()
{
	level notify("hash_33d99aaf");
	level endon("game_ended");
	level endon("hash_33d99aaf");
	level endon("bomb_planted");
	if(!isdefined(level.prematch_over) || (isdefined(level.prematch_over) && !level.prematch_over))
	{
		level waittill("prematch_over");
	}
	for(;;)
	{
		wait(0.999);
		timePassed = GetTime() - level.startTime / 1000;
		timeRemaining = GetGametypeSetting("timelimit") * 60 - timePassed;
		if(timeRemaining > 2 || level.bombPlanted)
		{
			continue;
		}
		level function_cd91d5e9(level.bombZones[RandomInt(level.bombZones.size)]);
		level notify("hash_33d99aaf");
	}
}

function function_175993cd()
{
	for(index = 0; index < level.bombZones.size; index++)
	{
		if(level.bombZones[index].isPlanted)
		{
			return level.bombZones[index];
		}
	}
	return 0;
}

function function_ba3d1e25()
{
	foreach(player in level.players)
	{
		if(isdefined(player.isBombCarrier) && player.isBombCarrier)
		{
			return player;
		}
	}
	return undefined;
}

function function_194dc2a7()
{
	if(GetDvarString("g_gametype") != "sd")
	{
		return;
	}
	level thread function_40bc335c(game["attackers"]);
	level thread function_40bc335c(game["defenders"]);
}

function function_40bc335c(team)
{
	level endon("game_ended");
	if(!isdefined(level.prematch_over) || (isdefined(level.prematch_over) && !level.prematch_over))
	{
		level waittill("prematch_over");
	}
	for(;;)
	{
		players = namespace_bd1e7d57::function_3390018e(team, "alive");
		if(players.size == 1)
		{
			player = players[0];
			player.var_1305f066 = 1;
			break;
		}
		if(players.size > 1)
		{
			foreach(player in players)
			{
				player.var_1305f066 = 0;
			}
		}
		wait(0.05);
	}
}

function function_7e9471e2(bombsite)
{
	if(isdefined(self.setDropped))
	{
		if([[self.setDropped]]())
		{
			return;
		}
	}
	self.isResetting = 1;
	self notify("dropped");
	var_db00fcad = bombsite.visuals[0].origin + VectorScale((1, 1, 0), 40);
	startOrigin = var_db00fcad + VectorScale((0, 0, 1), 20);
	endOrigin = var_db00fcad - VectorScale((0, 0, 1), 2000);
	trace_size = 10;
	trace = PhysicsTrace(startOrigin, endOrigin, (trace_size * -1, trace_size * -1, trace_size * -1), (trace_size, trace_size, trace_size), self, 32);
	self gameobjects::clear_carrier();
	if(isdefined(trace))
	{
		tempAngle = RandomFloat(360);
		dropOrigin = trace["position"] + (0, 0, self.dropOffset);
		if(trace["fraction"] < 1)
		{
			FORWARD = (cos(tempAngle), sin(tempAngle), 0);
			FORWARD = VectorNormalize(FORWARD - VectorScale(trace["normal"], VectorDot(FORWARD, trace["normal"])));
			if(SessionModeIsMultiplayerGame())
			{
				if(isdefined(trace["walkable"]))
				{
					if(trace["walkable"] == 0)
					{
						end_reflect = FORWARD * 1000 + trace["position"];
						reflect_trace = PhysicsTrace(trace["position"], end_reflect, (trace_size * -1, trace_size * -1, trace_size * -1), (trace_size, trace_size, trace_size), self, 32);
						if(isdefined(reflect_trace))
						{
							dropOrigin = reflect_trace["position"] + (0, 0, self.dropOffset);
							if(reflect_trace["fraction"] < 1)
							{
								FORWARD = (cos(tempAngle), sin(tempAngle), 0);
								FORWARD = VectorNormalize(FORWARD - VectorScale(reflect_trace["normal"], VectorDot(FORWARD, reflect_trace["normal"])));
							}
						}
					}
				}
			}
			dropAngles = VectorToAngles(FORWARD);
		}
		else
		{
			dropAngles = (0, tempAngle, 0);
		}
		foreach(visual in self.visuals)
		{
			visual.origin = dropOrigin;
			visual.angles = dropAngles;
			visual DontInterpolate();
			visual show();
		}
		self.trigger.origin = dropOrigin;
		self.curorigin = self.trigger.origin;
		self thread gameobjects::pickup_timeout(trace["position"][2], startOrigin[2]);
	}
	else
	{
		self gameobjects::move_visuals_to_base();
		self.trigger.origin = self.trigger.baseOrigin;
		self.curorigin = self.trigger.baseOrigin;
	}
	self gameobjects::update_icons_and_objective();
	self.isResetting = 0;
}