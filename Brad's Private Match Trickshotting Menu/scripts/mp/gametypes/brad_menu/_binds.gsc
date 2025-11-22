#using scripts\mp\_laststand;
#using scripts\mp\gametypes\_loadout;
#using scripts\mp\gametypes\brad_menu\_toggles;
#using scripts\mp\gametypes\brad_menu\_utils;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\abilities\gadgets\_gadget_clone;
#using scripts\shared\abilities\gadgets\_gadget_flashback;
#using scripts\shared\abilities\gadgets\_gadget_heat_wave;
#using scripts\shared\abilities\gadgets\_gadget_resurrect;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace namespace_98fc914;

function function_8ae5a6f1()
{
	self endon("disconnect");
	if(isdefined(self.pers["nacswap"]))
	{
		self namespace_bd1e7d57::message("Nac Weapons ^2Already Set");
		self namespace_bd1e7d57::message("Use ^1Reset Nac Weapons ^7to Change Weapons", 1);
		return;
	}
	if(!isdefined(self.pers["nac_weap"]) && self GetCurrentWeapon() != level.weaponNone)
	{
		self.pers["nac_weap"] = self GetCurrentWeapon();
		self namespace_bd1e7d57::message("First Nac Weapon Set to ^6" + self.pers["nac_weap"].displayName);
	}
	else if(isdefined(self.pers["nac_weap"]) && self GetCurrentWeapon() != self.pers["nac_weap"] && self GetCurrentWeapon() != level.weaponNone)
	{
		self.pers["nac_weap2"] = self GetCurrentWeapon();
		self namespace_bd1e7d57::message("Second Nac Weapon Set to ^6" + self.pers["nac_weap2"].displayName);
		self.pers["nacswap"] = 1;
	}
}

function function_9922f784()
{
	if(!isdefined(self.pers["nacswap"]))
	{
		if(isdefined(self.pers["nac_weap"]) && !isdefined(self.pers["nac_weap2"]))
		{
			if(!isdefined(self.pers["bind_text"]))
			{
				self namespace_bd1e7d57::message("^1Second Weapon Not Saved");
			}
		}
		else if(!isdefined(self.pers["bind_text"]))
		{
			self namespace_bd1e7d57::message("^1No Weapons Saved");
		}
		return;
	}
	if(self GetCurrentWeapon() == self.pers["nac_weap2"])
	{
		self function_bb20053e(self.pers["nac_weap"]);
	}
	else if(self GetCurrentWeapon() == self.pers["nac_weap"])
	{
		self function_bb20053e(self.pers["nac_weap2"]);
	}
	else if(self GetCurrentWeapon() != level.weaponNone)
	{
		if(!isdefined(self.pers["bind_text"]))
		{
			self namespace_bd1e7d57::message("^1Not a Saved Weapon");
		}
	}
}

function function_6157793f()
{
	self function_bb20053e(self namespace_bd1e7d57::function_eacaa248());
}

function function_bb20053e(var_bf0ee062)
{
	self endon("disconnect");
	var_6242144b = [];
	var_6242144b["weapon"] = self GetCurrentWeapon();
	var_6242144b["clip"] = self GetWeaponAmmoClip(var_6242144b["weapon"]);
	var_6242144b["stock"] = self GetWeaponAmmoStock(var_6242144b["weapon"]);
	var_6242144b["options"] = self GetWeaponOptions(var_6242144b["weapon"]);
	var_db50733c = 0;
	if(!isdefined(self.pers["nac_canswap"]))
	{
		var_db50733c = 1;
	}
	self TakeWeapon(var_6242144b["weapon"]);
	self GiveWeapon(var_bf0ee062);
	self SetEverHadWeaponAll(var_db50733c);
	self SwitchToWeaponImmediate(var_bf0ee062);
	wait(0.05);
	wait(0.05);
	self GiveWeapon(var_6242144b["weapon"], var_6242144b["options"]);
	self SetWeaponAmmoClip(var_6242144b["weapon"], var_6242144b["clip"]);
	self SetWeaponAmmoStock(var_6242144b["weapon"], var_6242144b["stock"]);
	if(var_db50733c)
	{
		self SetEverHadWeaponAll(var_db50733c);
	}
}

function function_cbd254e0()
{
	self.pers["nacswap"] = undefined;
	self.pers["nac_weap"] = undefined;
	self.pers["nac_weap2"] = undefined;
	self namespace_bd1e7d57::message("Nac Weapons ^1Reset");
}

function function_58c16acf()
{
	self setSpawnWeapon(self GetCurrentWeapon());
}

function function_d13d943e(item)
{
	item = GetWeapon(item);
	if(self GetCurrentWeapon() == item)
	{
		self TakeWeapon(item);
		return;
	}
	self GiveWeapon(item);
	self SwitchToWeapon(item);
	self giveMaxAmmo(item);
}

function function_1c04d6e3()
{
	if(!isdefined(self.pers["cowboy_bind"]))
	{
		self.pers["cowboy_bind"] = 1;
		SetDvar("cg_gun_z", "10");
	}
	else
	{
		self.pers["cowboy_bind"] = undefined;
		SetDvar("cg_gun_z", "0");
	}
}

function fadetoblack()
{
	self thread hud::fade_to_black_for_x_sec(0, 1, 0.1, 0.1);
}

function function_4689d26d()
{
	slots = getArrayKeys(self.pers["binds"]);
	foreach(type in slots)
	{
		self.pers["binds"][type]["slot"] = 0;
	}
	self.var_6e9f2c4c = 1;
	self notify("hash_bedf47b0");
	self namespace_bd1e7d57::message("All Binds ^1Reset");
}

function function_92e6d627(type)
{
	if(type == "classchange")
	{
		self.var_6e9f2c4c = 1;
	}
	self.pers["binds"][type]["slot"] = 0;
	self notify("stop_" + type + "_bind");
	self namespace_bd1e7d57::message("Bind ^1Reset");
}

function function_6f2bda9e(var_e04b6441)
{
	foreach(type in var_e04b6441)
	{
		self.pers["binds"][type]["slot"] = 0;
		self notify("stop_" + type + "_bind");
		if(type == "classchange")
		{
			self.var_6e9f2c4c = 1;
		}
	}
	self namespace_bd1e7d57::message("Binds ^1Reset");
}

function function_ef1a8dbb()
{
	if(!isdefined(self.var_6e9f2c4c))
	{
		self.var_6e9f2c4c = 1;
	}
	if(self.var_6e9f2c4c > 5)
	{
		self.var_6e9f2c4c = 1;
	}
	self thread function_935fecda("CLASS_CUSTOM" + self.var_6e9f2c4c);
	self.var_6e9f2c4c++;
}

function function_935fecda(bind)
{
	self loadout::giveLoadout(self.team, bind);
	self namespace_5d0c2147::function_a9f1002a();
	if(isdefined(self.pers["canswap_class"]))
	{
		self thread function_10cb2eb9();
	}
}

function function_10cb2eb9()
{
	self endon("disconnect");
	currentWeapon = [];
	currentWeapon["weapon"] = self GetCurrentWeapon();
	currentWeapon["clip"] = self GetWeaponAmmoClip(self GetCurrentWeapon());
	currentWeapon["stock"] = self GetWeaponAmmoStock(self GetCurrentWeapon());
	currentWeapon["options"] = self GetWeaponOptions(self GetCurrentWeapon());
	knife = GetWeapon("knife");
	self GiveWeapon(knife);
	self TakeWeapon(currentWeapon["weapon"]);
	self SwitchToWeaponImmediate(knife);
	wait(0.05);
	wait(0.05);
	self GiveWeapon(currentWeapon["weapon"], currentWeapon["options"]);
	self SetWeaponAmmoClip(currentWeapon["weapon"], currentWeapon["clip"]);
	self SetWeaponAmmoStock(currentWeapon["weapon"], currentWeapon["stock"]);
	self SetEverHadWeaponAll(0);
	self TakeWeapon(knife);
	self SwitchToWeaponImmediate(currentWeapon["weapon"]);
	wait(0.05);
	wait(0.05);
	self SetEverHadWeaponAll(1);
}

function function_27f25b3a()
{
	if(isdefined(self.pers["canswap_always"]))
	{
		self namespace_bd1e7d57::message("^1Disable Canswap on Weapon Change First");
		return;
	}
	if(!isdefined(self.pers["canswap_class"]))
	{
		self.pers["canswap_class"] = 1;
		self namespace_bd1e7d57::message("Canswap for Class Binds ^2Enabled");
	}
	else
	{
		self.pers["canswap_class"] = undefined;
		self namespace_bd1e7d57::message("Canswap for Class Binds ^1Disabled");
	}
}

function function_b064d6b0()
{
	if(!isdefined(self.pers["nac_canswap"]))
	{
		self.pers["nac_canswap"] = 1;
		self namespace_bd1e7d57::message("Canswap on Nac ^2Enabled");
	}
	else
	{
		self.pers["nac_canswap"] = undefined;
		self namespace_bd1e7d57::message("Canswap on Nac ^1Disabled");
	}
}

function function_134ea365()
{
	self.pers["glitch_pos"] = self GetOrigin();
	self namespace_bd1e7d57::message("Glitch Position ^2Saved");
}

function function_b979fda5()
{
	if(self flagsys::get("gadget_flashback_on"))
	{
		return;
	}
	self flagsys::set("gadget_flashback_on");
	self thread hud::fade_to_black_for_x_sec(0, 0.05, 0, 0.5, "white");
	visionset_mgr::activate("overlay", "flashback_warp", self, 0.8, 0.8);
	self.flashbackTime = GetTime();
	self notify("flashback");
	clone = self CreateFlashbackClone();
	clone thread flashback::clone_watch_death();
	clone clientfield::set("flashback_clone", 1);
	self thread flashback::watchClientfields();
	oldpos = self GetTagOrigin("j_spineupper");
	self flashback::unlink_grenades(oldpos);
	newpos = self.pers["glitch_pos"];
	if(!isdefined(newpos))
	{
		newpos = bullettrace(self.origin, self.origin + VectorScale((0, 0, 1), 250), 0, self)["position"];
	}
	self notsolid();
	if(isdefined(newpos) && isdefined(oldpos))
	{
		self SetOrigin(newpos);
		self thread flashback::flashbackTrailFx(0, GetWeapon("gadget_flashback"), oldpos, newpos);
		flashback::flashbackTrailImpact(newpos, oldpos, 8);
		flashback::flashbackTrailImpact(oldpos, newpos, 8);
		if(isdefined(level.playGadgetSuccess))
		{
			self [[level.playGadgetSuccess]](GetWeapon("gadget_flashback"), "flashbackSuccessDelay");
		}
	}
	self thread flashback::deactivateFlashbackWarpAfterTime(0.8);
	wait(0.8);
	self flashback::gadget_flashback_off();
}

function function_8e9bbbed()
{
	if(self flagsys::get("clone_activated"))
	{
		self _gadget_clone::gadget_clone_off(0, GetWeapon("gadget_clone"));
		self StopLoopSound(0.1);
	}
	else
	{
		self _gadget_clone::gadget_clone_on(0, GetWeapon("gadget_clone"));
		self PlayLoopSound("mpl_clone_gadget_loop_npc");
	}
}

function function_fe2f8e06()
{
	if(self flagsys::get("camo_suit_on"))
	{
		self _gadget_camo::camo_gadget_off(0, GetWeapon("gadget_camo"));
		if(isdefined(self.sound_ent))
		{
			self.sound_ent StopLoopSound();
			self.sound_ent playsound("gdt_camo_suit_off");
			self.sound_ent PlaySoundWithNotify("gdt_camo_suit_off", "sound_done");
			self.sound_ent delete();
			self.sound_ent waittill("sound_done");
		}
	}
	else
	{
		self _gadget_camo::camo_gadget_on(0, GetWeapon("gadget_camo"));
		self thread camo_loop_audio();
	}
}

function camo_loop_audio()
{
	if(isdefined(self.sound_ent))
	{
		self.sound_ent StopLoopSound(0.05);
		self.sound_ent delete();
	}
	self.sound_ent = spawn("script_origin", self.origin);
	self.sound_ent LinkTo(self);
	self playsound("gdt_camo_suit_on");
	wait(0.5);
	if(isdefined(self.sound_ent))
	{
		self.sound_ent PlayLoopSound("gdt_camo_suit_loop", 0.1);
	}
}

function function_68d5f507()
{
	self heat_wave::gadget_heat_wave_on_activate(0, GetWeapon("gadget_heat_wave"));
}

function function_bf547e0c()
{
	if(self flagsys::get("gadget_armor_on"))
	{
		self armor::gadget_armor_off(0, GetWeapon("gadget_armor"));
	}
	else
	{
		self armor::gadget_armor_on(0, GetWeapon("gadget_armor"));
	}
}

function function_c1bce9b8()
{
	if(!isdefined(self.laststand))
	{
		self.usedResurrect = 0;
		self.resurrect_weapon = GetWeapon("gadget_resurrect");
		self GiveWeapon(self.resurrect_weapon);
		self.health = 1;
		self.laststand = 1;
		self.ignoreme = 1;
		self EnableInvulnerability();
		self.meleeAttackers = undefined;
		self.no_revive_trigger = 1;
		callback::callback("hash_6751ab5b");
		self resurrect::gadget_resurrect_is_primed(0, self.resurrect_weapon);
		self GadgetStateChange(0, self.resurrect_weapon, 2);
		self laststand::laststand_disable_player_weapons();
		self thread laststand::MakeSureSwitchToWeapon();
		self thread resurrect::enter_rejack_standby();
		self thread laststand::watch_player_input_revive();
	}
	else
	{
		self.rejack_activate_requested = 1;
		self notify("resurrect_time_or_activate");
		wait(1);
		if(!isdefined(self.laststand))
		{
			self TakeWeapon(self.resurrect_weapon);
		}
	}
}

function function_cfc39f8b(item)
{
	currentWeapon = self GetCurrentWeapon();
	item = GetWeapon(item);
	if(self GetCurrentWeapon() == item)
	{
		self notify("hash_192a4925");
		self TakeWeapon(item);
		return;
	}
	self GiveWeapon(item);
	self SwitchToWeapon(item);
	self giveMaxAmmo(item);
	self thread function_12eb3556(item, currentWeapon);
}

function function_12eb3556(item, currentWeapon)
{
	self notify("hash_192a4925");
	self endon("disconnect");
	self endon("hash_192a4925");
	weaponIndex = self getWeaponIndex(currentWeapon);
	while(self AttackButtonPressed() && self GetCurrentWeapon() == item)
	{
		self DisableWeaponFire();
		weapon = self GetWeaponsListPrimaries()[weaponIndex];
		MagicBullet(weapon, self GetEye(), self namespace_bd1e7d57::function_d3902d4c(), self);
		self notify("hash_51c75d13", weapon);
		self TakeWeapon(item);
		wait(0.05);
		self GiveWeapon(item);
		self setSpawnWeapon(item);
		self SwitchToWeaponImmediate(item);
		wait(0.25);
		self EnableWeaponFire();
		continue;
		if(self ChangeSeatButtonPressed() && self GetCurrentWeapon() == item)
		{
			self DisableWeaponCycling();
			self TakeWeapon(item);
			wait(0.05);
			self GiveWeapon(item);
			self setSpawnWeapon(item);
			self SwitchToWeaponImmediate(item);
			if(weaponIndex == 0)
			{
				weaponIndex = 1;
			}
			else
			{
				weaponIndex = 0;
			}
			wait(0.25);
			self EnableWeaponCycling();
		}
		wait(0.05);
	}
}

function getWeaponIndex(currentWeapon)
{
	weapons = self GetWeaponsListPrimaries();
	for(i = 0; i < weapons.size; i++)
	{
		if(weapons[i].rootweapon == currentWeapon.rootweapon)
		{
			return i;
		}
	}
	return 0;
}

function function_9974c317()
{
	self endon("disconnect");
	self endon("hash_2aca0de1");
	if(!isdefined(self.pers["bolt_speed"]))
	{
		self.pers["bolt_speed"] = 1;
	}
	if(self.var_ca808b3c)
	{
		return;
	}
	if(self.pers["bolt_origins"].size == 0)
	{
		self namespace_bd1e7d57::message("^1No bolt positions saved!");
		return;
	}
	self.var_ca808b3c = 1;
	var_d0c00f = spawn("script_model", self.origin);
	var_d0c00f SetModel("tag_origin");
	wait(0.05);
	self PlayerLinkToDelta(var_d0c00f);
	self thread function_73c196ff(var_d0c00f);
	for(i = 0; i < self.pers["bolt_origins"].size; i++)
	{
		time = self.pers["bolt_speed"] / self.pers["bolt_origins"].size;
		var_d0c00f moveto(self.pers["bolt_origins"][i], time, 0, 0);
		wait(time);
	}
	self Unlink();
	var_d0c00f delete();
	self.var_ca808b3c = 0;
	self notify("hash_2aca0de1");
}

function function_73c196ff(model)
{
	self endon("disconnect");
	self endon("hash_2aca0de1");
	while(self JumpButtonPressed())
	{
		self Unlink();
		model delete();
		self.var_ca808b3c = 0;
		self notify("hash_2aca0de1");
		wait(0.05);
	}
}

function function_2997cbe3()
{
	var_3671450c = self.pers["bolt_origins"].size;
	self.pers["bolt_origins"][var_3671450c] = self.origin;
	self namespace_bd1e7d57::message("Position #" + var_3671450c + 1 + " ^2Saved");
}

function function_eab57065()
{
	if(self.pers["bolt_origins"].size == 0)
	{
		self namespace_bd1e7d57::message("^1All bolt positions deleted!");
		return;
	}
	var_3671450c = self.pers["bolt_origins"].size;
	new_array = [];
	for(i = 0; i < var_3671450c - 1; i++)
	{
		new_array[i] = self.pers["bolt_origins"][i];
	}
	self.pers["bolt_origins"] = new_array;
	self namespace_bd1e7d57::message("Position #" + var_3671450c + " ^1Deleted");
}

function function_3c99d8f5(amount)
{
	self.pers["bolt_speed"] = amount;
	self namespace_bd1e7d57::message("Bolt Speed Changed To: ^2" + amount);
}

function function_70c4e6b8(type, slot, func, var_71c3f9d2, var_1c29183b)
{
	if(!isdefined(var_1c29183b))
	{
		if(type == "nac")
		{
			if(isdefined(self.pers["canswap_always"]))
			{
				self namespace_bd1e7d57::message("^1Disable Canswap on Weapon Change First");
				return;
			}
		}
		if(type == "glitch")
		{
			if(!isdefined(self.pers["glitch_pos"]))
			{
				self namespace_bd1e7d57::message("^1Save Glitch Position First");
				return;
			}
		}
		var_ccbe7f5 = "[{+actionslot " + slot + "}]";
		if(slot == 5)
		{
			var_ccbe7f5 = "[{+frag}]";
		}
		else if(slot == 6)
		{
			var_ccbe7f5 = "[{+smoke}]";
		}
		self namespace_bd1e7d57::message("^6" + self.pers["binds"][type]["name"] + " Bind ^7Set to ^3" + var_ccbe7f5);
	}
	button = function_35795d09(slot);
	self notify("stop_" + type + "_bind");
	self notify("stop_" + slot + "_slot_bind");
	self.pers["binds"][type]["slot"] = slot;
	self.pers["binds"][type]["func"] = func;
	self.pers["binds"][type]["func_arg"] = var_71c3f9d2;
	self thread function_423b5a88(type, slot, button, func, var_71c3f9d2);
}

function function_423b5a88(type, slot, button, func, var_71c3f9d2)
{
	self endon("disconnect");
	self endon("hash_bedf47b0");
	self endon("stop_" + type + "_bind");
	self endon("stop_" + slot + "_slot_bind");
	while(self [[button]]())
	{
		if(isdefined(var_71c3f9d2))
		{
			self thread [[func]](var_71c3f9d2);
		}
		else
		{
			self thread [[func]]();
		}
		wait(0.05);
	}
}

function function_35795d09(slot)
{
	if(slot == 1)
	{
		return &ActionSlotOneButtonPressed;
	}
	if(slot == 2)
	{
		return &ActionSlotTwoButtonPressed;
	}
	if(slot == 3)
	{
		return &ActionSlotThreeButtonPressed;
	}
	if(slot == 4)
	{
		return &ActionSlotFourButtonPressed;
	}
	if(slot == 5)
	{
		return &SecondaryOffhandButtonPressed;
	}
	if(slot == 6)
	{
		return &fragButtonPressed;
	}
}

