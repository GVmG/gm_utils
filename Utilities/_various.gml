/*
		VARIOUS UTILITIES
		by Raechel V.
		version 2024.8
		
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

/// @func draw_text_on_path(ix, iy, text, text_scale, text_color, text_alpha, path, path_xscale=1, path_yscale=1, path_angle=0, text_follows_path_angle=true)
/// @desc This function renders the given text along the given path.
/// @arg {Real} ix the x coordinate at which to start drawing.
/// @arg {Real} iy the y coordinate at which to start drawing.
/// @arg {String} text the string you wish to draw.
/// @arg {Real} text_scale the scale at which to draw the text.
/// @arg {Constant.Colour} text_color the color of the text.
/// @arg {Real} text_alpha the opacity of the text.
/// @arg {Asset.GMPath} path the Path which the text will follow the shape of.
/// @arg {Real} path_xscale the horizontal scale of the path.
/// @arg {Real} path_yscale the vertical scale of the path.
/// @arg {Real} path_angle the angle of the path.
/// @arg {Bool} text_follows_path_direction whether the text should follow the direction of the path (true) or always face horizontally (false).
function draw_text_on_path(ix, iy, text, text_scale, text_color, text_alpha, path, path_xscale=1, path_yscale=1, path_angle=0, text_follows_path_direction=true)
{
	if (text=="") return;
	
	var halign=draw_get_halign();
	draw_set_halign(fa_center);
	var valign=draw_get_valign();
	draw_set_valign(fa_middle); //for best results
	
	var l=string_length(text);
	var pangle=0, prev=0;
	
	for (var i=1; i<=l; i++) {
		var c=string_char_at(text, i);
		var prog=i/l;
		
		var px=path_get_x(path, prog)*path_xscale, py=path_get_y(path, prog)*path_yscale;
		var ppx=path_get_x(path, prev)*path_xscale, ppy=path_get_y(path, prev)*path_yscale;
		
		if (path_angle!=0) {
			var pdir=point_direction(0, 0, px, py);
			var plen=sqrt(px*px+py*py);
			px=lengthdir_x(plen, pdir+path_angle);
			py=lengthdir_y(plen, pdir+path_angle);
			
			if (text_follows_path_direction) {
				var ppdir=point_direction(0, 0, ppx, ppy);
				var pplen=sqrt(ppx*ppx+ppy*ppy);
				ppx=lengthdir_x(pplen, ppdir+path_angle);
				ppy=lengthdir_y(pplen, ppdir+path_angle);
			}
		}
		
		if (text_follows_path_direction) {
			pangle=point_direction(ppx, ppy, px, py);
			prev=prog;
		}
		
		draw_text_transformed_color(ix+px, iy+py, c, text_scale, text_scale, pangle, text_color,  text_color,  text_color,  text_color, 1);
		
	}
	
	draw_set_halign(halign); //reset alignmeent
	draw_set_valign(valign);
}
