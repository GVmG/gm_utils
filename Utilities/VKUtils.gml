/*
		VK_* UTILITIES
		by Raechel V.
		version 2024.10
		
		See https://github.com/GVmG/gm_utils for more info.
*/

global.__keymap=ds_map_create();

ds_map_add(global.__keymap, "vk_nokey", vk_nokey);
ds_map_add(global.__keymap, "vk_anykey", vk_anykey);
ds_map_add(global.__keymap, "vk_left", vk_left);
ds_map_add(global.__keymap, "vk_right", vk_right);
ds_map_add(global.__keymap, "vk_up", vk_up);
ds_map_add(global.__keymap, "vk_down", vk_down);
ds_map_add(global.__keymap, "vk_enter", vk_enter);
ds_map_add(global.__keymap, "vk_escape", vk_escape);
ds_map_add(global.__keymap, "vk_space", vk_space);
ds_map_add(global.__keymap, "vk_shift", vk_shift);
ds_map_add(global.__keymap, "vk_control", vk_control);
ds_map_add(global.__keymap, "vk_alt", vk_alt);
ds_map_add(global.__keymap, "vk_backspace", vk_backspace);
ds_map_add(global.__keymap, "vk_tab", vk_tab);
ds_map_add(global.__keymap, "vk_home", vk_home);
ds_map_add(global.__keymap, "vk_end", vk_end);
ds_map_add(global.__keymap, "vk_delete", vk_delete);
ds_map_add(global.__keymap, "vk_insert", vk_insert);
ds_map_add(global.__keymap, "vk_pageup", vk_pageup);
ds_map_add(global.__keymap, "vk_pagedown", vk_pagedown);
ds_map_add(global.__keymap, "vk_pause", vk_pause);
ds_map_add(global.__keymap, "vk_printscreen", vk_printscreen);
ds_map_add(global.__keymap, "vk_f1", vk_f1);
ds_map_add(global.__keymap, "vk_f2", vk_f2);
ds_map_add(global.__keymap, "vk_f3", vk_f3);
ds_map_add(global.__keymap, "vk_f4", vk_f4);
ds_map_add(global.__keymap, "vk_f5", vk_f5);
ds_map_add(global.__keymap, "vk_f6", vk_f6);
ds_map_add(global.__keymap, "vk_f7", vk_f7);
ds_map_add(global.__keymap, "vk_f8", vk_f8);
ds_map_add(global.__keymap, "vk_f9", vk_f9);
ds_map_add(global.__keymap, "vk_f10", vk_f10);
ds_map_add(global.__keymap, "vk_f11", vk_f11);
ds_map_add(global.__keymap, "vk_f12", vk_f12);
ds_map_add(global.__keymap, "vk_numpad0", vk_numpad0);
ds_map_add(global.__keymap, "vk_numpad1", vk_numpad1);
ds_map_add(global.__keymap, "vk_numpad2", vk_numpad2);
ds_map_add(global.__keymap, "vk_numpad3", vk_numpad3);
ds_map_add(global.__keymap, "vk_numpad4", vk_numpad4);
ds_map_add(global.__keymap, "vk_numpad5", vk_numpad5);
ds_map_add(global.__keymap, "vk_numpad6", vk_numpad6);
ds_map_add(global.__keymap, "vk_numpad7", vk_numpad7);
ds_map_add(global.__keymap, "vk_numpad8", vk_numpad8);
ds_map_add(global.__keymap, "vk_numpad9", vk_numpad9);
ds_map_add(global.__keymap, "vk_multiply", vk_multiply);
ds_map_add(global.__keymap, "vk_divide", vk_divide);
ds_map_add(global.__keymap, "vk_add", vk_add);
ds_map_add(global.__keymap, "vk_subtract", vk_subtract);
ds_map_add(global.__keymap, "vk_decimal", vk_decimal);
ds_map_add(global.__keymap, "vk_lshift", vk_lshift);
ds_map_add(global.__keymap, "vk_lcontrol", vk_lcontrol);
ds_map_add(global.__keymap, "vk_lalt", vk_lalt);
ds_map_add(global.__keymap, "vk_rshift", vk_rshift);
ds_map_add(global.__keymap, "vk_rcontrol", vk_rcontrol);
ds_map_add(global.__keymap, "vk_ralt", vk_ralt);

///returns the vk_* value corresponding with the given string name. returns undefined if not a valid key.
function key_from_string(str) {return ds_map_find_value(global.__keymap, str);}
