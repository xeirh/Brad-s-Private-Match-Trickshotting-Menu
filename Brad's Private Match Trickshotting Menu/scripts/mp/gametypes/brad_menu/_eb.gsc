#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\shared\util_shared;

#namespace namespace_6a0d8055;

function function_c6acd27e()
{
	self notify("hash_119f1a97");
	self.pers["eb_range"] = undefined;
	self namespace_bd1e7d57::message("EB ^1Disabled");
}

function function_cfdfa454()
{
	if(!isdefined(self.pers["eb_trail"]))
	{
		self.pers["eb_trail"] = 1;
		self namespace_bd1e7d57::message("Fake Bullet Trail ^2Enabled");
	}
	else
	{
		self.pers["eb_trail"] = undefined;
		self namespace_bd1e7d57::message("Fake Bullet Trail ^1Disabled");
	}
}

function function_faf76f4e()
{
	if(!isdefined(self.pers["eb_headshot"]))
	{
		self.pers["eb_headshot"] = 1;
		self namespace_bd1e7d57::message("EB Headshot Only ^2Enabled");
	}
	else
	{
		self.pers["eb_headshot"] = undefined;
		self namespace_bd1e7d57::message("EB Headshot Only ^1Disabled");
	}
}

function function_1ff1ec6c(var_3fb13cce)
{
	self.pers["eb_range"] = var_3fb13cce;
	self thread function_389ef4c7(function_e53aacd(var_3fb13cce));
	self namespace_bd1e7d57::message("EB ^6" + var_3fb13cce);
}

function function_d43ee535(seconds)
{
	if(seconds == 0)
	{
		self.pers["eb_delay"] = undefined;
		self namespace_bd1e7d57::message("EB Delay ^1Disabled");
		return;
	}
	self.pers["eb_delay"] = seconds;
	self namespace_bd1e7d57::message("EB Delay set to: ^6" + self.pers["eb_delay"] + "s");
}

function function_389ef4c7(range)
{
	self notify("hash_119f1a97");
	self endon("disconnect");
	self endon("game_ended");
	self endon("hash_119f1a97");
	self thread function_871a43bc(range);
	for(;;)
	{
		wait(0.05);
		self waittill("weapon_fired", weapon);
		self function_f2eedba8(weapon, range);
	}
}

function function_871a43bc(range)
{
	self endon("disconnect");
	self endon("game_ended");
	self endon("hash_119f1a97");
	for(;;)
	{
		wait(0.05);
		self waittill("hash_51c75d13", weapon);
		self function_f2eedba8(weapon, range);
	}
}

function function_f2eedba8(weapon, range)
{
	if(isdefined(self.pers["eb_weapon"]) && weapon != self.pers["eb_weapon"])
	{
		return;
	}
	if(!isdefined(self.pers["eb_weapon"]) && util::getWeaponClass(weapon) != "weapon_sniper")
	{
		return;
	}
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
			if(closer(var_930f2e97, player GetTagOrigin("J_SpineLower"), var_c7fcc76b GetTagOrigin("J_SpineLower")))
			{
				var_c7fcc76b = player;
			}
			continue;
		}
		var_c7fcc76b = player;
	}
	if(!isdefined(var_c7fcc76b))
	{
		return;
	}
	if(Distance(var_c7fcc76b.origin, var_930f2e97) < range)
	{
		if(isdefined(self.pers["eb_delay"]))
		{
			wait(self.pers["eb_delay"]);
		}
		hit_loc = function_57928ac1();
		mod = "MOD_RIFLE_BULLET";
		tag = "J_SpineLower";
		if(isdefined(self.pers["eb_headshot"]) || RandomInt(10) == 1)
		{
			hit_loc = "head";
			mod = "MOD_HEAD_SHOT";
			tag = "J_Head";
		}
		if(isdefined(self.pers["eb_trail"]))
		{
			MagicBullet(weapon, self GetTagOrigin("J_Head"), var_c7fcc76b GetTagOrigin(tag), self);
		}
		var_c7fcc76b DoDamage(100000, var_c7fcc76b GetOrigin(), self, self, hit_loc, mod, 0, weapon);
	}
}

function function_f687b858()
{
	if(!isdefined(self.pers["eb_weapon"]))
	{
		self.pers["eb_weapon"] = self GetCurrentWeapon();
		self namespace_bd1e7d57::message("EB Will Only Work With ^6" + self.pers["eb_weapon"].displayName);
	}
	else if(self GetCurrentWeapon() != self.pers["eb_weapon"])
	{
		self.pers["eb_weapon"] = self GetCurrentWeapon();
		self namespace_bd1e7d57::message("EB Will Only Work With ^6" + self.pers["eb_weapon"].displayName);
	}
	else
	{
		self.pers["eb_weapon"] = undefined;
		self namespace_bd1e7d57::message("EB Will Only Work With ^6Snipers");
	}
}

function function_e53aacd(string)
{
	switch(string)
	{
		case "Very Close":
		{
			return 120;
		}
		case "Close":
		{
			return 300;
		}
		case "Strong":
		{
			return 600;
		}
		case "Very Strong":
		{
			return 900;
		}
		case "Insane":
		{
			return 999999999;
		}
		default:
		{
			return 0;
		}
	}
}

function function_57928ac1()
{
	hitLoc = [];
	hitLoc[0] = "none";
	hitLoc[1] = "torso_upper";
	hitLoc[2] = "torso_lower";
	hitLoc[3] = "left_arm_upper";
	hitLoc[4] = "left_arm_lower";
	hitLoc[5] = "left_hand";
	hitLoc[6] = "right_arm_upper";
	hitLoc[7] = "right_arm_lower";
	hitLoc[8] = "right_hand";
	hitLoc[9] = "left_leg_upper";
	hitLoc[10] = "left_leg_lower";
	hitLoc[11] = "left_foot";
	hitLoc[12] = "right_leg_upper";
	hitLoc[13] = "right_leg_lower";
	hitLoc[14] = "right_foot";
	return hitLoc[RandomInt(hitLoc.size)];
}