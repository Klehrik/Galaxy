/// Init

// Stars
Stars = ds_list_create();
for (var i = 0; i < 150; i++)
{
	ds_list_add(Stars, [irandom_range(10, 1270), irandom_range(10, 710)]);
}