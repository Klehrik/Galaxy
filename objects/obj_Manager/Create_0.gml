/// Init

audio_stop_all();
audio_play_sound(mus_final, 0, 1);

depth = -5000;
randomize();
draw_set_circle_precision(64);
draw_set_font(fnt_segoe);

global.DT = 0;
global.Speed = 1;
SpeedSave = 1;

Select = [-1, -1];
Selected = 0;

global.TResources = [0, [0, 0], [0, 0]];

Buy = 0;
BuyPlanet = -4;

BuildName = ["Defense Cannon Mk. I", "Defense Cannon Mk. II", "Defense Cannon Mk. III", "Fighter Base", "", ""];
BuildCostM = [25, 60, 140, 70, 0, 0];
BuildCostP = [10, 25, 60, 30, 0, 0];
//BuildCostM = [0, 0, 0, 0, 0, 0];
//BuildCostP = [0, 0, 0, 0, 0, 0];

var Set = 0;

if (Set == 1)
	{
	// [x, y, Type, Team, Units, DC Mk1, DC Mk2, DC Mk3]
	Planets = [[646, 354, 0, 0, 0, 0, 0, 0], [881, 369, 0, 0, 0, 0, 0, 0], [410, 381, 0, 0, 0, 0, 0, 0], [1098, 337, 2, 2, 10, 0, 0, 0], [185, 349, 1, 1, 30, 0, 0, 0]];

	for (var c = 0; c < array_length(Planets); c++)
	{
		var data = Planets[c]
		var p = instance_create_depth(data[0], data[1], 0, obj_Planet);
		p.Type = data[2];
	
		for (var i = 0; i < data[4]; i++)
		{
			var ship = obj_BlueShip;
			if (data[3] == 2) ship = obj_RedShip;
			var s = instance_create_depth(p.x, p.y, 0, ship);
			s.Location = p.id;
		}
	
		for (var i = 0; i < data[5]; i++)
		{
			var dc = instance_create_depth(p.x, p.y, 0, obj_Cannon);
			dc.Location = p.id;
			dc.Team = data[3];
		}
	
		for (var i = 0; i < data[6]; i++)
		{
			var dc = instance_create_depth(p.x, p.y, 0, obj_Cannon);
			dc.Location = p.id;
			dc.Team = data[3];
			dc.ShootSpd = 1.5;
		}
	
		for (var i = 0; i < data[7]; i++)
		{
			var dc = instance_create_depth(p.x, p.y, 0, obj_Cannon);
			dc.Location = p.id;
			dc.Team = data[3];
			dc.ShootSpd = 1;
		}
	
		if (p.Type == 1) blueNode = p;
		else if (p.Type == 2) redNode = p;
	}
}
else
{
	// Initial planet line
	var _y = 360;
	for (var i = 0; i < 5; i++)
	{
		var p = instance_create_depth(160 + (i * 240), _y, 0, obj_Planet);
	
		var table = [1, 3, 4, 3, 2];
		p.Type = table[i];
	
		var ship = -4;
		if (i == 0) ship = obj_BlueShip;
		else if (i == 4) ship = obj_RedShip;
		if (ship != -4)
		{
			for (var j = 0; j < 10; j++)
			{
				var s = instance_create_depth(160 + (i * 240), _y, 0, ship);
				s.Location = p.id;
			}
		}
	
		if (i == 0 or i == 4)
		{
			var c = instance_create_depth(400, 360, 0, obj_Cannon);
			c.Location = p.id;
			if (i == 4) c.Team = 2;
		}
	
		_y += irandom_range(-60, 60);
		_y = clamp(_y, 60, 660);
	
		if (p.Type == 1) blueNode = p;
		else if (p.Type == 2) redNode = p;
	}

	// Extra planets
	var planets = 7;
	while (planets < 20)
	{
		do
		{
			var _x = irandom_range(60, 1220);
			var _y = irandom_range(60, 660);
		
			var n = instance_nearest(_x, _y, obj_Planet);
			var d = point_distance(_x, _y, n.x, n.y);
		}
		until d < 240 and d > 160;
		instance_create_depth(_x, _y, 0, obj_Planet);
		planets += 1;
	}
}

// Links
with (obj_Planet)
{
	with (obj_Planet)
	{
		if (point_distance(x, y, other.x, other.y) < 250) ds_list_add(other.Links, id);
	}
}



/// Enemy AI

// global.PlanetMap
global.PlanetMap = ds_map_create();
with (obj_Planet) global.PlanetMap[? id] = [99, 0, 0, 99]; // dist from blue, blue units, red units, dist from red

// Distance from Blue Base: Loops through all planets a few times and selects the links with the smallest values
global.PlanetMap[? blueNode][0] = 0;
for (var _ = 0; _ < ceil(instance_number(obj_Planet) / 2); _++)
{
	with (obj_Planet)
	{
		for (var i = 1; i < ds_list_size(Links); i++)
		{
			if (global.PlanetMap[? Links[| i]][0] < global.PlanetMap[? id][0])
			{
				global.PlanetMap[? id][0] = global.PlanetMap[? Links[| i]][0] + 1;
			}
		}
	}
}

// Distance from Red Base: Loops through all planets a few times and selects the links with the smallest values
global.PlanetMap[? redNode][3] = 0;
for (var _ = 0; _ < ceil(instance_number(obj_Planet) / 2); _++)
{
	with (obj_Planet)
	{
		for (var i = 1; i < ds_list_size(Links); i++)
		{
			if (global.PlanetMap[? Links[| i]][3] < global.PlanetMap[? id][3])
			{
				global.PlanetMap[? id][3] = global.PlanetMap[? Links[| i]][3] + 1;
			}
		}
	}
}