/// Step

var spawn = 300;
var spawnB = 420;

// Blue HQ
if (Type == 1)
{
	if (Amount < spawn) Amount += global.Speed;
	else if (instance_number(obj_BlueShip) < 200)
	{
		Amount -= spawn;
		var s = instance_create_depth(x + irandom_range(-2, 2), y + irandom_range(-2, 2), 0, obj_BlueShip);
		s.Destination = id;
	}
}

// Red HQ
else if (Type == 2)
{
	if (Amount < spawn) Amount += global.Speed;
	else if (instance_number(obj_RedShip) < 200)
	{
		Amount -= spawn;
		var s = instance_create_depth(x + irandom_range(-2, 2), y + irandom_range(-2, 2), 0, obj_RedShip);
		s.Destination = id;
	}
}

// Blue Base
else if (Type == 5)
{
	if (global.PlanetMap[? id][1] <= 0 and global.PlanetMap[? id][2] > 0) { Type = 0; Amount = 0; }
	
	if (Amount < spawnB) Amount += global.Speed;
	else if (instance_number(obj_BlueShip) < 200)
	{
		Amount -= spawnB;
		var s = instance_create_depth(x + irandom_range(-2, 2), y + irandom_range(-2, 2), 0, obj_BlueShip);
		s.Destination = id;
	}
}

// Red Base
else if (Type == 6)
{
	if (global.PlanetMap[? id][2] <= 0 and global.PlanetMap[? id][1] > 0) { Type = 0; Amount = 0; }
	
	if (Amount < spawnB) Amount += global.Speed;
	else if (instance_number(obj_RedShip) < 200)
	{
		Amount -= spawnB;
		var s = instance_create_depth(x + irandom_range(-2, 2), y + irandom_range(-2, 2), 0, obj_RedShip);
		s.Destination = id;
	}
}