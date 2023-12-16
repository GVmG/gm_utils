/*
		VARIOUS UTILITIES
		by Raechel V.
		version 2023.12
		
		See https://github.com/GVmG/gm_utils for more info.
		
		(This is a random set of utilities that don't fit in any other major category.)
*/

///returns true if the object has that parent anywhere in its hierarchy
function object_has_parent(object, parent) {
	if (object==parent) {return true;}
	
	var prevChecked=object;
	do {
		prevChecked=object_get_parent(prevChecked);
		if (prevChecked==parent) {return true;}
	}
	until (prevChecked==-1 || prevChecked==-100)
	
	return false;
}

///Iterates through an iterable (array, ds_list, ds_map, or struct), executing the given function for each element in the iterable.
//f has to be a function taking in the index and optionally a secondary element:
//		for arrays, just the value at that index
//		for ds_lists, just the value at that index
//		for ds_maps, an array containing [0] the key and [1] the value of that key
//		for structs, an array containing [0] the variable name and [1] the variable value
function iterate(iterable, f=function(i, l) {}) {
	var i=0;
	if (is_array(iterable)) {
		for (i=0; i<array_length(iterable); i++) { f(i, iterable[i]); }
		return;
	}
	
	if (ds_exists(iterable, ds_type_list)) {
		for (i=0; i<ds_list_size(iterable); i++) { f(i, iterable[| i]); }
		return;
	}
	
	if (ds_exists(iterable, ds_type_map)) {
		var lastentry=ds_map_find_first(iterable);
		for (i=0; i<ds_map_size(iterable); i++) {
			f(i, [lastentry, ds_map_find_value(iterable, lastentry)]);
			lastentry=ds_map_find_next(iterable, lastentry);
		}
		return;
	}
	
	if (is_struct(iterable)) {
		var entries=variable_struct_get_names(iterable);
		for (i=0; i<array_length(entries); i++) { f(i, [entries[i], variable_struct_get(iterable, entries[i])]); }
		return;
	}
}

///Iterates through an iterable (array, ds_list, ds_map, or struct), executing the given function for each element in the iterable. Echo function of iterate();
function foreach(iterable, f) {iterate(iterable, f);}

///Resizes a surface. This WILL free the input surface and return a new one, so the ideal usage is to assign the returned surface directly to the input one (ex. partSurf=surface_expand(partSurf, ...);).
function surface_expand(surface, right=0, down=0, left=0, up=0, bg=0xffffff, bga=0) {
	var surf=surface_create(surface_get_width(surface)+right+left, surface_get_height(surface)+down+up);
	
	surface_set_target(surf);
	draw_clear_alpha(bg, bga);
	
	gpu_set_blendenable(false);
	draw_surface_ext(surface, left, up, 1, 1, 0, c_white, 1); //can't use surface_copy cause that re-enables blending for some reason
	gpu_set_blendenable(true);
	
	surface_reset_target();
	
	surface_free(surface);
	
	return surf;
}