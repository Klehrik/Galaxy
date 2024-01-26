/// Draw

// Select
if (Select[0] >= 0)
{
	draw_rectangle(Select[0], Select[1], mouse_x, mouse_y, 1);
}

// Draw PlanetMap
//var node = ds_map_find_first(global.PlanetMap);
//for (var i = 0; i < ds_map_size(global.PlanetMap); i++)
//{
//	draw_text(node.x - 4, node.y - 50, global.PlanetMap[? node]);
//	draw_text(node.x - 16, node.y - 70, node);
//	node = ds_map_find_next(global.PlanetMap, node);
//}

// Buy Menu
var button = 0;
if (Buy == 1)
{	
	if (global.PlanetMap[? BuyPlanet][4] > 0) // Check if there is a blue unit on the planet
	{
		for (var _x = 0; _x < 6; _x++)
		{
			var col = c_white;
			
			// Cannon count
			var cannonCount = 0;
			with (obj_Cannon) { if (Team == 1 and Location == other.BuyPlanet.id) cannonCount += 1; }
		
			if (point_in_rectangle(mouse_x, mouse_y, _x * 200 + 20, 640, _x * 200 + 200, 700))
			{
				col = c_yellow;
				button = 1;
					
				if (mouse_check_button_released(mb_left) and BuildName[_x] != "") // Purchase
				{
					// Prevent purchase of base on non-plain
					var Check = 0;
					if (BuildName[_x] == "Fighter Base" and BuyPlanet.Type != 0) Check = 1;
					
					// Prevent purchase of over 9 cannons
					if (cannonCount >= 9 and BuildName[_x] != "Fighter Base") Check = 1;
					
					if (BuildName[_x] == "Fighter Base" and BuyPlanet.Type != 0) Check = 1;
					
					if (global.TResources[1][0] >= BuildCostM[_x] and global.TResources[1][1] >= BuildCostP[_x] and Check == 0)
					{
						global.TResources[1][0] -= BuildCostM[_x];
						global.TResources[1][1] -= BuildCostP[_x];
						
						switch (BuildName[_x])
						{
							case "Defense Cannon Mk. I":
								var c = instance_create_depth(BuyPlanet.x, BuyPlanet.y, 0, obj_Cannon);
								c.Location = BuyPlanet.id;
								break;
								
							case "Defense Cannon Mk. II":
								var c = instance_create_depth(BuyPlanet.x, BuyPlanet.y, 0, obj_Cannon);
								c.Location = BuyPlanet.id;
								c.ShootSpd = 1.5;
								break;
								
							case "Defense Cannon Mk. III":
								var c = instance_create_depth(BuyPlanet.x, BuyPlanet.y, 0, obj_Cannon);
								c.Location = BuyPlanet.id;
								c.ShootSpd = 1;
								break;
								
							case "Fighter Base":
								BuyPlanet.Type = 5;
								break;
						}
					}
				}
			}
		
			draw_rectangle_colour(_x * 200 + 20, 640, _x * 200 + 200, 700, c_black, c_black, c_black, c_black, 0);
			draw_rectangle_colour(_x * 200 + 20, 640, _x * 200 + 200, 700, col, col, col, col, 1);
		
			// Text
			draw_text(_x * 200 + 30, 650, BuildName[_x]);
			if (BuildName[_x] == "Fighter Base" and BuyPlanet.Type != 0) draw_text(_x * 200 + 30, 672, "Cannot build here.");
			else if (string_copy(BuildName[_x], 1, 14) == "Defense Cannon" and cannonCount >= 9) draw_text(_x * 200 + 30, 672, "Max cannons reached.");
			else
			{
				var cost = "";
				if (BuildCostM[_x] > 0) cost = string(BuildCostM[_x]) + " Metal";
				if (BuildCostP[_x] > 0) cost += ", " + string(BuildCostP[_x]) + " Plasma";
				draw_text(_x * 200 + 30, 672, cost);
			}
		}
	}
	else
	{
		draw_rectangle_colour(20, 640, 200, 700, c_black, c_black, c_black, c_black, 0);
		draw_rectangle_colour(20, 640, 200, 700, c_white, c_white, c_white, c_white, 1);
		draw_text(30, 650, "No ship on planet.");
	}
}

// Open buy menu
if (mouse_check_button_released(mb_left) and Selected == 0)
{
	var p = instance_nearest(mouse_x, mouse_y, obj_Planet);
	if (point_distance(mouse_x, mouse_y, p.x, p.y) <= p.Size)
	{
		Buy = 1;
		BuyPlanet = p;
	}
	else { if (button == 0) { Buy = 0; BuyPlanet = -4; } }
}
if (Selected == 2) Selected = 0;

if (Select[0] >= 0) { if (abs(Select[0] - mouse_x) > 40 or abs(Select[1] - mouse_y) > 40) { Buy = 0; BuyPlanet = -4; } }

// Game Speed
if (keyboard_check_pressed(vk_space))
{
	if (global.Speed > 0) { SpeedSave = global.Speed; global.Speed = 0; }
	else global.Speed = SpeedSave;
}
else if (keyboard_check_pressed(ord("1"))) { if (global.Speed > 1) global.Speed -= 1; }
else if (keyboard_check_pressed(ord("2"))) { if (global.Speed > 0) global.Speed += 1; }

for (var _x = 0; _x < 3; _x++)
{
	draw_rectangle(10 + _x * 50, 10, 50 + _x * 50, 50, 1);
	if (mouse_check_button_released(mb_left) and point_in_rectangle(mouse_x, mouse_y, 10 + _x * 50, 10, 50 + _x * 50, 50))
	{
		if (_x == 0 and global.Speed > 1) global.Speed -= 1;
		else if (_x == 1)
		{
			if (global.Speed > 0) { SpeedSave = global.Speed; global.Speed = 0; }
			else global.Speed = SpeedSave;
		}
		else if (_x == 2 and global.Speed > 0) global.Speed += 1;
	}
}

draw_set_halign(fa_center);

draw_text(30, 20, "<");
draw_text(130, 20, ">");

global.Speed = clamp(global.Speed, 0, 9);

if (global.Speed > 0) draw_text(80, 20, string(global.Speed) + "x");
else draw_text(80, 20, "| |");

draw_set_halign(fa_left);