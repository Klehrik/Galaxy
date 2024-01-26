/// Begin Step

// Check if planet is captured
if (Team == 1)
{
	if (global.PlanetMap[? Location][1] <= 0 and global.PlanetMap[? Location][2] > 0) instance_destroy();
}
else if (Team == 2)
{
	if (global.PlanetMap[? Location][2] <= 0 and global.PlanetMap[? Location][1] > 0) instance_destroy();
}