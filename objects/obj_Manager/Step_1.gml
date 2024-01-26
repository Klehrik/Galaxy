/// Begin Step

global.DT += 1;

// Update global.PlanetMap

with (obj_Planet) // Refresh planet data
{
	global.PlanetMap[? id][1] = 0;
	global.PlanetMap[? id][2] = 0;
	global.PlanetMap[? id][4] = 0;
	global.PlanetMap[? id][5] = 0;
}

with (obj_Ship) // Unit count
{
	global.PlanetMap[? Location][Team] += 1;
	if (Destination < 0) global.PlanetMap[? Location][Team + 3] += 1; // True count (all units that are not moving)
}