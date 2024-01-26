/// Draw

var col = [c_white, c_blue, c_red, c_gray, c_lime, c_aqua, c_orange];
col = col[Type];

draw_circle_colour(x, y, Size + 4, c_black, c_black, 0);
draw_circle_colour(x, y, Size, col, col, 1 - sign(Type));

// Links
ds_list_clear(Links);
with (obj_LevelEditorPlanet)
{
	if (point_distance(x, y, other.x, other.y) < 250) ds_list_add(other.Links, id);
}

// Show Location
draw_set_halign(fa_center);
draw_text(x, y - Size - 24, string(x) + ", " + string(y));