/// Draw

var col = [c_blue, c_red];
col = col[Team - 1];

if (Shoot >= 70)
{
	draw_set_alpha((Shoot - 70) / 30);
	draw_line_colour(x, y, ShootPos[0], ShootPos[1], col, col);
	draw_set_alpha(1);
}

if (ShootSpd != 1.5)
{
	var size = 4;
	if (ShootSpd == 1) { draw_set_circle_precision(4); size = 6; }
	draw_circle_colour(x, y, size + 2, c_gray, c_gray, 0);
	draw_circle_colour(x, y, size, col, col, 0);
	draw_set_circle_precision(64);
}
else
{
	draw_rectangle_colour(x - 6, y - 6, x + 6, y + 6, c_gray, c_gray, c_gray, c_gray, 0);
	draw_rectangle_colour(x - 4, y - 4, x + 4, y + 4, col, col, col, col, 0);
}