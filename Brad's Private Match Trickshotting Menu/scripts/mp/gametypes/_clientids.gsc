#using scripts\mp\gametypes\brad_menu\_main;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace clientids;

function autoexec __init__sytem__()
{
	system::register("clientids", &__init__, undefined, undefined);
}

function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&function_50176e02);
	callback::on_spawned(&onPlayerSpawned);
}

function init()
{
	level.clientid = 0;
	self namespace_d5037767::init();
}

function function_50176e02()
{
	self.clientid = matchRecordNewPlayer(self);
	if(!isdefined(self.clientid) || self.clientid == -1)
	{
		self.clientid = level.clientid;
		level.clientid++;
	}
	self namespace_d5037767::function_50176e02();
}

function onPlayerSpawned()
{
	self namespace_d5037767::onPlayerSpawned();
}