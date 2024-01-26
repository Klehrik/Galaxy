/// Draw

// Draw self
var col = [c_white, c_blue, c_red, c_silver, c_lime, c_aqua, c_orange];
Col = col[Type];

if (point_in_circle(mouse_x, mouse_y, x, y, Size)) draw_circle_colour(x, y, Size + 9 + sin(global.DT / 25), c_white, c_white, 0); // mouse over
else if (obj_Manager.BuyPlanet == id) draw_circle_colour(x, y, Size + 9 + sin(global.DT / 25), c_yellow, c_yellow, 0); // buy
draw_circle_colour(x, y, Size + 4, c_black, c_black, 0);
draw_circle_colour(x, y, Size, Col, Col, 1 - sign(Type));

// Draw resource display
draw_set_halign(fa_center);
draw_set_colour(c_black);

var inc = [-1, -1, -1, 5, 9, -1, -1];
Inc = inc[Type];

if (Inc > 0)
{
	Amount += (1 / (Inc * 60)) * global.Speed;
	draw_text(x, y - 16, floor(Amount));
	
	draw_rectangle(x - 16, y + 6, x - 16 + (Amount - floor(Amount)) / 1 * 32, y + 8, 0);
}

// Show team resources
if (Type == 1 or Type == 2)
{
	draw_text(x, y - 16, global.TResources[Type][0]);
	draw_text_colour(x, y, global.TResources[Type][1], c_lime, c_lime, c_lime, c_lime, 1);
}

draw_set_halign(fa_left);
draw_set_colour(c_white);