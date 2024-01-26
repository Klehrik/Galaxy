/// Step

// Create planets
var select = 0;

if (instance_exists(obj_LevelEditorPlanet))
{
	var near = instance_nearest(mouse_x, mouse_y, obj_LevelEditorPlanet);
	if (point_distance(mouse_x, mouse_y, near.x, near.y) < near.Size) select = 1;
}

if (select == 0)
{
	if (Hold == 1)
	{
		near.x = mouse_x;
		near.y = mouse_y;
	}
	else
	{
		if (mouse_check_button_released(mb_left)) instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet);
		if (keyboard_check_pressed(ord("1"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 1; }
		if (keyboard_check_pressed(ord("2"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 2; }
		if (keyboard_check_pressed(ord("3"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 3; }
		if (keyboard_check_pressed(ord("4"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 4; }
		if (keyboard_check_pressed(ord("5"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 5; }
		if (keyboard_check_pressed(ord("6"))) { var p = instance_create_depth(mouse_x, mouse_y, 0, obj_LevelEditorPlanet); p.Type = 6; }
	}
}

// Move / delete planets
else
{
	if (instance_exists(obj_LevelEditorPlanet))
	{
		if (mouse_check_button_pressed(mb_left)) Hold = 1;
		
		if (Hold == 1)
		{
			near.x = mouse_x;
			near.y = mouse_y;
		}
		
		if (mouse_check_button_released(mb_right))
		{
			with (obj_LevelEditorPlanet) ds_list_clear(Links);
			instance_destroy(near);
			Hold = 0;
		}
	}
}
if (mouse_check_button_released(mb_left)) Hold = 0;