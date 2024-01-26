/// Step

var move = global.Speed / 2;

var s = Location.Size + Offset;
x = Location.x + (dcos(Angle) * s);
y = Location.y - (dsin(Angle) * s);
Angle += move;

// Shoot
var enm = obj_BlueShip;
if (Team == 1) enm = obj_RedShip;

if (Shoot > 0) Shoot -= (100 / (60 * ShootSpd)) * global.Speed;

var e = instance_nearest(x, y, enm);
if (instance_exists(e) and point_distance(x, y, e.x, e.y) < 100)
{
	if (Shoot <= 0)
	{
		Shoot += 100;
		ShootPos = [e.x, e.y];
		instance_destroy(e);
	}
}