/// Save Planets

var str = "Planets = [";

with (obj_LevelEditorPlanet)
{
	str += "[" + string(x) + ", " + string(y) + ", " + string(Type) + "], ";
}

str += "];"

clipboard_set_text(str);