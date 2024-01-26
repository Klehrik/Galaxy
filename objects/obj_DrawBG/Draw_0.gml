/// Draw

depth = 1000;

for (var i = 0; i < ds_list_size(Stars); i++)
{
	var s = Stars[| i];
	draw_point(s[0], s[1]);
}

with (obj_Planet)
{
	for (var i = 0; i < ds_list_size(Links); i++)
	{
		var p = Links[| i];
		draw_line_colour(x, y, p.x, p.y, c_gray, c_gray);
	}
}

with (obj_LevelEditorPlanet)
{
	for (var i = 0; i < ds_list_size(Links); i++)
	{
		var p = Links[| i];
		draw_line_colour(x, y, p.x, p.y, c_gray, c_gray);
	}
}