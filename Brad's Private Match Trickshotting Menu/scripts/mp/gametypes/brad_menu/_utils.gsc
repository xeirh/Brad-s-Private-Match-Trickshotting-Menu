#using scripts\mp\gametypes\_globallogic_score;
#using scripts\shared\util_shared;

#namespace namespace_bd1e7d57;

function getName()
{
	name = self.name;
	if(name[0] != "[")
	{
		return name;
	}
	for(a = name.size - 1; a >= 0; a--)
	{
		if(name[a] == "]")
		{
			break;
		}
	}
	return GetSubStr(name, a + 1);
}

function function_d47e142e(State)
{
	playerArray = [];
	players = GetPlayers();
	foreach(player in players)
	{
		if(isdefined(State) && State == "alive")
		{
			if(!player util::is_bot() && isalive(player))
			{
				playerArray[playerArray.size] = player;
			}
			continue;
		}
		if(!player util::is_bot())
		{
			playerArray[playerArray.size] = player;
		}
	}
	return playerArray;
}

function function_a426e654(State)
{
	bots = [];
	players = GetPlayers();
	foreach(player in players)
	{
		if(isdefined(State) && State == "alive")
		{
			if(player util::is_bot() && isalive(player))
			{
				bots[bots.size] = player;
			}
			continue;
		}
		if(player util::is_bot())
		{
			bots[bots.size] = player;
		}
	}
	return bots;
}

function function_3390018e(team, State)
{
	playerArray = [];
	players = GetPlayers();
	foreach(player in players)
	{
		if(isdefined(team) && isdefined(State) && State == "alive")
		{
			if(player.team == team && isalive(player))
			{
				playerArray[playerArray.size] = player;
			}
			continue;
		}
		if(isdefined(team))
		{
			if(player.team == team)
			{
				playerArray[playerArray.size] = player;
			}
		}
	}
	return playerArray;
}

function function_a30ff3de()
{
	if(GetDvarString("g_gametype") == "dm" && isPlayer(self))
	{
		last = GetGametypeSetting("scorelimit") - 1;
		if(self.kills == last)
		{
			return 1;
		}
	}
	else if(GetDvarString("g_gametype") == "tdm" && isPlayer(self))
	{
		last = GetGametypeSetting("scorelimit") - 1;
		score = globallogic_score::_getTeamScore(self.team);
		if(score == last)
		{
			return 1;
		}
	}
	return 0;
}

function function_eacaa248()
{
	weaponList = self GetWeaponsListPrimaries();
	for(i = 0; i < weaponList.size; i++)
	{
		if(weaponList[i] == self GetCurrentWeapon())
		{
			if(isdefined(weaponList[i + 1]))
			{
				return weaponList[i + 1];
			}
		}
	}
	return weaponList[0];
}

function function_f084cd4c()
{
	if(isPlayer(self) && isdefined(self.var_1305f066) && self.var_1305f066)
	{
		return 1;
	}
	return 0;
}

function function_cfd4873c(align, relative, x, y, shader, width, height, color, alpha, sort)
{
	barElemBG = newClientHudElem(self);
	barElemBG.elemType = "bar";
	if(!level.Splitscreen)
	{
		barElemBG.x = -2;
		barElemBG.y = -3;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.sort = sort;
	barElemBG.color = color;
	barElemBG.alpha = alpha;
	barElemBG SetShader(shader, width, height);
	barElemBG.hidden = 0;
	barElemBG.x = x;
	barElemBG.y = y;
	barElemBG.alignX = align;
	barElemBG.alignY = relative;
	return barElemBG;
}

function function_c1c245d0(font, fontscale, align, relative, x, y, sort, alpha, glow, text)
{
	textelem = newClientHudElem(self);
	textelem.sort = sort;
	textelem.alpha = alpha;
	textelem.x = x;
	textelem.y = y;
	textelem.glowColor = glow;
	textelem.glowAlpha = 1;
	textelem.fontscale = fontscale;
	textelem setText(text);
	return textelem;
}

function function_d3902d4c(var_31116a75, var_b80e5676, var_8f42bdde)
{
	if(!isdefined(var_31116a75))
	{
		var_31116a75 = 10000000;
	}
	if(!isdefined(var_b80e5676))
	{
		var_b80e5676 = "position";
	}
	if(!isdefined(var_8f42bdde))
	{
		var_8f42bdde = 0;
	}
	return bullettrace(self GetEye(), self GetEye() + VectorScale(AnglesToForward(self getPlayerAngles()), var_31116a75), var_8f42bdde, self)[var_b80e5676];
}

function message(msg, disable_sound)
{
	if(self == level)
	{
		iprintln(msg);
	}
	else
	{
		self iprintln(msg);
	}
	if(isdefined(disable_sound) && disable_sound)
	{
		return;
	}
	sound = "mpl_killconfirm_tags_drop";
	if(IsSubStr(msg, "^1"))
	{
		sound = "mpl_killconfirm_tags_pickup";
	}
	if(self == level)
	{
		players = function_d47e142e();
		foreach(player in players)
		{
			player playlocalsound(sound);
		}
		return;
	}
	self playlocalsound(sound);
}