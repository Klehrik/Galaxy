/// Step

var move = (global.Speed / 4) * Engines;

var enm = obj_BlueShip;
if (object_index == obj_BlueShip) enm = obj_RedShip;

var e = instance_nearest(x, y, enm);
if (instance_exists(e) and point_distance(x, y, e.x, e.y) < 80) // Move towards target
{
	motion_set(point_direction(x, y, e.x, e.y), move);
	if (Destination < 0) Destination = Location;
}
else if (Destination < 0)
{
	var s = Location.Size + Offset;
	x = Location.x + (dcos(Angle) * s);
	y = Location.y - (dsin(Angle) * s);
	Angle += move;
	
	// Loot planet
	if (Loot == 1)
	{
		Loot = 0;
		if (Location.Inc > 0 and Location.Amount > 0)
		{
			if (Location.Type >= 3) Resources[Location.Type - 3] += floor(Location.Amount);
			Location.Amount -= floor(Location.Amount);
		}
	}
}
else
{
	var dist = point_distance(x, y, Destination.x, Destination.y);
	
	if (dist <= Destination.Size + (Offset - global.Speed)) motion_set(point_direction(Destination.x, Destination.y, x, y), move);
	else motion_set(point_direction(x, y, Destination.x, Destination.y), move);

	if (dist >= Destination.Size + (Offset - global.Speed) and dist <= Destination.Size + Offset)
	{
		motion_set(0, 0);
		Angle = point_direction(Destination.x, Destination.y, x, y);
		Location = Destination;
		Destination = -4;
	}
}

// Push other ships away
var pos = [x, y];
x = 10000;
y = 10000;
var s = instance_nearest(pos[0], pos[1], object_index);
x = pos[0];
y = pos[1];

if (Destination < 0)
{
	if (instance_exists(s) and point_distance(x, y, s.x, s.y) < 12)
	{
		Angle -= sign(s.Angle - Angle) * move;
		s.Angle += sign(s.Angle - Angle) * move;
	}
}
else
{
	if (instance_exists(s) and point_distance(x, y, s.x, s.y) < 12)
	{
		// + move / 4 to prevent total obstructions
		
		x -= sign(s.x - x) * move + move / 4;
		y -= sign(s.y - y) * move;
		s.x += sign(s.x - x) * move + move / 4;
		s.y += sign(s.y - y) * move;
	}
}

// Collide with target
if (instance_exists(e) and point_distance(x, y, e.x, e.y) < 8)
{
	instance_destroy(e);
	instance_destroy();
}

// Deposit resources
ResourceCount = 0;
for (var i = 0; i < array_length(Resources); i++) ResourceCount += Resources[i];

var base = 1;
if (object_index == obj_RedShip) base = 2;
if (Location.Type == base)
{
	if (ResourceCount > 0)
	{
		for (var i = 0; i < array_length(Resources); i++)
		{
			global.TResources[base][i] += Resources[i];
			Resources[i] = 0;
		}
	}
}

// Move Delay (Enemy AI)
if (Destination < 0 and MoveDelay > 0) MoveDelay -= global.Speed;