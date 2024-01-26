/// Init

Team = 1;
if (object_index == obj_RedShip) Team = 2;
MoveDelay = 0; // Enemy AI

Location = instance_nearest(x, y, obj_Planet);
Destination = -4;
Angle = irandom_range(0, 359);
Offset = irandom_range(16, 32);

Selected = 0;

Loot = 0;
Resources = [0, 0];
ResourceCount = 0;

Engines = 1;