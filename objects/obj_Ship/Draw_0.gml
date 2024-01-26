/// Draw

var col = [c_blue, c_red];
col = col[Team - 1];

if (Selected == 1) col = c_white;

var ol = 1;
if (ResourceCount > 0) ol = 0;
draw_circle_colour(x, y, 4, col, col, ol);