/// Init

depth = 500;

Size = irandom_range(24, 32);
Col = c_white;
Type = choose(0, 0, 0, 0, 0, 3, 3, 4);
// 0 - Plain
// 1 - Blue HQ
// 2 - Red HQ
// 3 - Metal
// 4 - Plasma
// 5 - Blue Base
// 6 - Red Base

Links = ds_list_create();
//ds_list_add(Links, id);

Amount = 0; // Resource amount
Inc = -1; // Increment (1 every Inc seconds)