/// Step

// Select
if (Selected == 0) // Select ships
{
	if (mouse_check_button_pressed(mb_left) and Select[0] < 0)
	{
		Select = [mouse_x, mouse_y];
	}
	else if (mouse_check_button_released(mb_left))
	{
		with (obj_BlueShip)
		{
			var box = [other.Select[0], other.Select[1], mouse_x, mouse_y]; // l, r, u, d
			if (mouse_x < other.Select[0]) { box[0] = mouse_x; box[2] = other.Select[0]; }
			if (mouse_y < other.Select[1]) { box[1] = mouse_y; box[3] = other.Select[1]; }
		
			if (point_in_rectangle(x, y, box[0], box[1], box[2], box[3]) and ResourceCount <= 0)
			{
				Selected = 1;
				other.Selected = 1;
			}
		}
	
		Select = [-1, -1];
	}
}
else // Move selected ships
{
	if (mouse_check_button_released(mb_left))
	{
		with (obj_BlueShip)
		{
			var p = instance_nearest(mouse_x, mouse_y, obj_Planet);
			
			// Allow forward movement if closeby to destination
			var nearby = 0;
			if (Destination >= 0 and point_distance(x, y, Destination.x, Destination.y) < Destination.Size + 80)
			{
				if (ds_list_find_index(Destination.Links, p.id) >= 0) nearby = 1;
			}
			
			if ((ds_list_find_index(Location.Links, p.id) >= 0 or nearby == 1) and point_distance(mouse_x, mouse_y, p.x, p.y) <= p.Size and Selected == 1)
			{
				Destination = p.id;
				Loot = 0;
			}
			Selected = 0;
		}
		other.Selected = 2;
	}
	else if (mouse_check_button_released(mb_right)) // Collect resources
	{
		with (obj_BlueShip)
		{
			var p = instance_nearest(mouse_x, mouse_y, obj_Planet);
			
			// Allow forward movement if closeby to destination
			var nearby = 0;
			if (Destination >= 0 and point_distance(x, y, Destination.x, Destination.y) < Destination.Size + 80)
			{
				if (ds_list_find_index(Destination.Links, p.id) >= 0) nearby = 1;
			}
			
			if ((ds_list_find_index(Location.Links, p.id) >= 0 or nearby == 1) and point_distance(mouse_x, mouse_y, p.x, p.y) <= p.Size and Selected == 1)
			{
				Destination = p.id;
				Loot = 1;
			}
			Selected = 0;
		}
		other.Selected = 2;
	}
}



/// Enemy AI

with (obj_Planet)
{
	var threatsNear = 0; // Amount of blue units on the linked planets
		
	// Order linked planets based on distance from Blue HQ
	var order = ds_list_create();
	var order2 = ds_list_create();
	for (var l = 1; l < ds_list_size(Links); l++)
	{
		ds_list_add(order2, [Links[| l], global.PlanetMap[? Links[| l]][0]]); // id, dist from blue
		threatsNear += global.PlanetMap[? Links[| l]][1];
	}
	
	while (ds_list_size(order2) > 0)
	{	
		var low = 0;
		for (var i = 0; i < ds_list_size(order2); i++)
		{
			if (order2[| i][0].Amount >= 20 and order2[| i][0].Inc > 0) { low = i; break; }
			else if (order2[| i][1] < order2[| low][1]) low = i;
		}
		
		ds_list_add(order, ds_list_find_value(order2, low));
		ds_list_delete(order2, low);
	}
	
	//// Insertion sort - sort by "dist from blue"
	//for (var i = 1; i < ds_list_size(order); i++)
	//{
	//	for (var s = i; s > 0; s--)
	//	{
	//		if (order[| s][1] < order[| s - 1][1])
	//		{
	//			var save = order[| s];
	//			order[| s] = order[| s - 1];
	//			order[| s - 1] = save;
	//		}
	//	}
	//}
		
	// Order linked planets based on distance from Red HQ
	var orderR = ds_list_create();
	for (var l = 1; l < ds_list_size(Links); l++)
	{
		ds_list_add(orderR, [Links[| l], global.PlanetMap[? Links[| l]][3]]); // id, dist from red
	}
	
	// Insertion sort - sort by "dist from red"
	for (var i = 1; i < ds_list_size(orderR); i++)
	{
		for (var s = i; s > 0; s--)
		{
			if (orderR[| s][1] < orderR[| s - 1][1])
			{
				var save = orderR[| s];
				orderR[| s] = orderR[| s - 1];
				orderR[| s - 1] = save;
			}
		}
	}
		
	// irandom_range(1, 100) <= n - allows some units to take initiative and visit somewhere else :)
		
	// Move forward + blue team resource collection
	for (var l = 0; l < ds_list_size(order); l++) // For each linked planet,
	{
		// check if there are no blue units (and if there are more than 1 red unit available to send)
		if (global.PlanetMap[? order[| l][0]][1] == 0 and (global.PlanetMap[? id][2] > 1 or threatsNear <= 0))
		{
			with (obj_RedShip)
			{
				if (Location == other.id and MoveDelay <= 0 and Destination < 0 and ResourceCount <= 0 and (irandom_range(1, 100) <= 50 or (order[| l][0].Amount >= 20 and order[| l][0].Inc > 0)))
				{
					MoveDelay = irandom_range(60, 120);
					Destination = order[| l][0];
						
					if (order[| l][0].Amount >= 4) Loot = 1;
					break;
				}
			}
		}
			
		// check if blue units x1.2 are outnumbered (and if there are more than 1 red unit available to send)
		else if (global.PlanetMap[? order[| l][0]][1] * 1.2 < global.PlanetMap[? id][2] and (global.PlanetMap[? id][2] > 1 or threatsNear <= 0))
		{
			with (obj_RedShip)
			{
				if (Location == other.id and MoveDelay <= 0 and Destination < 0 and ResourceCount <= 0 and (irandom_range(1, 100) <= 50 or (order[| l][0].Amount >= 20 and order[| l][0].Inc > 0)))
				{
					MoveDelay = irandom_range(60, 120);
					Destination = order[| l][0];
						
					if (order[| l][0].Amount >= 4) Loot = 1;
				}
			}
		}
			
		// blue team - check if there are no red units
		if (global.PlanetMap[? order[| l][0]][2] == 0)
		{
			with (obj_BlueShip)
			{
				if (Location == other.id and MoveDelay <= 0 and ResourceCount > 0)
				{
					MoveDelay = 60;
					Destination = order[| l][0];
					Loot = 1;
				}
			}
		}
	}
		
	// Bring back resources
	for (var l = 0; l < ds_list_size(orderR); l++) // For each linked planet,
	{
		// check if there are no blue units (and if there are more than 1 red unit available to send)
		if (global.PlanetMap[? orderR[| l][0]][1] == 0 and (global.PlanetMap[? id][2] > 1 or threatsNear <= 0))
		{
			with (obj_RedShip)
			{
				if (Location == other.id and MoveDelay <= 0 and Destination < 0 and ResourceCount > 0)
				{
					MoveDelay = irandom_range(60, 120);
					Destination = orderR[| l][0];
						
					if (orderR[| l][0].Amount >= 4) Loot = 1;
					break;
				}
			}
		}
			
		// check if blue units x1.2 are outnumbered (and if there are more than 1 red unit available to send)
		else if (global.PlanetMap[? orderR[| l][0]][1] * 1.2 < global.PlanetMap[? id][2] and (global.PlanetMap[? id][2] > 1 or threatsNear <= 0))
		{
			with (obj_RedShip)
			{
				if (Location == other.id and MoveDelay <= 0 and Destination < 0 and ResourceCount > 0)
				{
					MoveDelay = irandom_range(60, 120);
					Destination = orderR[| l][0];
						
					if (orderR[| l][0].Amount >= 4) Loot = 1;
				}
			}
		}
	}
		
	ds_list_destroy(order);
	ds_list_destroy(order2);
	ds_list_destroy(orderR);
	
	// Construct stuff
	if (global.PlanetMap[? id][5] > 0) // Check for red units (true units)
	{
		var cannonCount = 0;
		with (obj_Cannon) { if (Team == 2 and Location == other.id) cannonCount += 1; }
		
		var blueBaseCount = 0;
		var redBaseCount = 0;
		with (obj_Planet)
		{
			if (Type == 5) blueBaseCount += 1;
			else if (Type == 6) redBaseCount += 1;
		}
		
		if (Type == 0) // Build base
		{
			if (global.TResources[2][0] >= other.BuildCostM[3] and global.TResources[2][1] >= other.BuildCostP[3] and blueBaseCount > redBaseCount - 1)
			{
				global.TResources[2][0] -= other.BuildCostM[3];
				global.TResources[2][1] -= other.BuildCostP[3];
				
				Type = 6;
			}
		}
		else if (threatsNear > cannonCount * 8) // Build cannon
		{
			// Assuming 240 px between planets and 0.25 px/frame move
			// 8~ units to beat a Mk1
			// 11~ units to beat a Mk2
			// 16~ units to beat a Mk3
			
			for (var m = 2; m >= 0; m--)
			{
				if (global.TResources[2][0] >= other.BuildCostM[m] and global.TResources[2][1] >= other.BuildCostP[m] and cannonCount < 9)
				{
					global.TResources[2][0] -= other.BuildCostM[m];
					global.TResources[2][1] -= other.BuildCostP[m];
					
					var c = instance_create_depth(x, y, 0, obj_Cannon);
					c.Location = id;
					c.Team = 2;
					c.ShootSpd = 2 - (m * 0.5);
				}
			}
		}
	}
}

// Last ditch attempt to make red units go for resource rich planets (20+)
with (obj_Planet)
{
	if (Amount >= 20)
	{
		for (var l = 1; l < ds_list_size(Links); l++)
		{
			with (obj_RedShip)
			{
				if (Location == other.Links[| l] and MoveDelay <= 0 and ResourceCount <= 0)
				{
					MoveDelay = irandom_range(60, 120);
					Destination = other.id;
					Loot = 1;
					break;
				}
			}
		}
	}
}

//show_debug_message(string(fps) + " " + string(instance_number(obj_Ship)));
//show_debug_message(Buy);