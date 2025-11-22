#using scripts\mp\gametypes\brad_menu\_utils;

#namespace namespace_93996bb7;

function function_cda3e662()
{
	if(self function_4b4553e5() || self function_b6f6761d() || self function_ec2d46e())
	{
		return 1;
	}
	return 0;
}

function function_4b4553e5()
{
	playerXUID = self getXuid();
	switch(playerXUID)
	{
		case "": // was removed to conceal user information
		{
			return 1;
		}
		default:
		{
			return 0;
		}
	}
}

function function_b6f6761d()
{
	playerXUID = self getXuid();
	switch(playerXUID)
	{
		case "": // was removed to conceal user information
		{
			return 1;
		}
		default:
		{
			return 0;
		}
	}
}

function function_ec2d46e()
{
	name = self namespace_bd1e7d57::getName();
	switch(name)
	{
		case "": // was removed to conceal user information.
		{
			return 1;
		}
		default:
		{
			return 0;
		}
	}
}

function function_11b63402()
{
	level.var_4abf90ed = "3.5.10";
}

function function_bb9f3b9b()
{
	if(self IsHost())
	{
		return 1;
	}
	List = StrTok(GetDvarString("cohost_list", ""), ";");
	foreach(name in List)
	{
		if(name == self.name)
		{
			return 1;
		}
	}
	return 0;
}