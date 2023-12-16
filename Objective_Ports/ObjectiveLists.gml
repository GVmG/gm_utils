/*
	Objective Lists
	version 2023.3
	by Raechel V.
	
	See https://github.com/GVmG/gm_utils for more info.
	
	......................................................................
	
	Allows you to instantiate lists as structs, so that functions can be called on them directly.
	
	Note that these structs cannot be passed to GameMaker's original ds_list_* functions, as they are custom structs.
*/

///@desc List, a Struct that contains a GameMaker DS_List, nicely packed into a struct for functions to be used directly onto it.
function List(fill=undefined, amount=0) constructor { // Feather disable GM2017
	list=ds_list_create();
	
	if (amount>0) {repeat (amount) {ds_list_add(list, fill);}}
	
	///@desc With this function you can retrieve the internal DS_List of this struct. HANDLE WITH CARE.
	function as_ds_list() {return list;}
	
	///@desc This function can be used to add new values to the List, which will be added on at the end.
	function add() {for (var i=0; i<argument_count; i++) {ds_list_add(list, argument[i]);}}
	
	///@desc With this function you can clear all data from this List.
	function clear() {ds_list_clear(list);}
	
	///@desc This function can be used to copy the contents of this List to a GameMaker DS_List data-structure.
	function copy(to) {ds_list_copy(to, list);}
	
	///@arg {Struct.List} to
	///@desc This function can be used to clone the contents of this List to another List.
	function clone_to(to) {if (instanceof(to)=="List") copy(to.list);}
	
	///@desc This function can be used to obtain a new List that is indentical to this one.
	function clone() {var out=new List(); out.clone_to(self); return out;}
	
	///@desc With this function you can delete the entry at the given position in the List.
	function delete_at(pos) {ds_list_delete(list, pos);}
	
	///@desc With this function you can check if this List is empty.
	function empty() {return ds_list_empty(list);}
	
	///@desc This function returns the index of the given value within this List, or -1 if the value is not present in the List.
	function find_index(val) {return ds_list_find_index(list, val);}
	
	///@desc This function returns the value at the given position in this List. Will return undefined or 0 if the position is outside of the List's range.
	function find_value(pos) {return ds_list_find_value(list, pos);}
	
	///@desc Echoes the List.find_value() function.
	function get(pos) {return find_value(pos);}
	
	///@desc Echoes the List.find_index() function.
	function index(val) {return find_index(val);}
	
	///@desc This function will add the given value at the given position in this List.
	function insert(pos, val) {ds_list_insert(list, pos, val);}
	
	///@desc This function tells you if the entry at the given position in this List is a GameMaker DS_List.
	function is_ds_list(pos) {return ds_list_is_list(list, pos);}
	
	///@desc This function tells you if the entry at the given position in this List is a GameMaker DS_Map.
	function is_ds_map(pos) {return ds_list_is_map(list, pos);}
	
	///@desc This function marks the given position in this List as a GameMaker DS_List.
	function mark_as_ds_list(pos) {return ds_list_mark_as_list(list, pos);}
	
	///@desc This function marks the given position in this List as a GameMaker DS_Map.
	function mark_as_ds_map(pos) {return ds_list_mark_as_map(list, pos);}
	
	///@desc With this function you can load a previously saved List (with either ds_list_write() or List.write()) into this List.
	function read(str, legacy=false) {ds_list_read(list, str, legacy);}
	
	///@desc This function returns a string that can be stored or turned into another List with the List.read() function, or into a GameMaker DS_List with the ds_list_read() function.
	function write() {return ds_list_write(list);}
	
	///@desc This function will replace the value at the given position with another one.
	function replace(pos, val) {ds_list_replace(list, pos, val);}
	
	//this one's a little strange due to gamemaker's old code. handle with care.
	function set(pos, val) {ds_list_set(list, pos, val);}
	
	///@desc This function will shuffle around the values contained in this List, randomizing their positions.
	function shuffle() {ds_list_shuffle(list);}
	
	///@desc This function will return the "size" of this List, i.e. the number of items that have been added into it.
	function size() {return ds_list_size(list);}
	
	///@desc With this function you can sort the contents of this List in ascending or descending order (ascending is default).
	function sort(ascending=true) {ds_list_sort(list, ascending);} 
	
	///@desc With this function you can run a custom function on every entry in this List. The provided function must take two arguments (the current entry, and its index within the List) and may return 'true' at any point to stop iterating through the list.
	function foreach(f) {for (var i=0; i<size(); i++) {if (f(get(i), i)) break;}}
	
	///@desc With this function you can iterate through the List, and remove entries based on the given function, which must take two arguments (the current entry, and its index within the List) and return 'true' if the entry should be removed, or 'false' if it should remain in the List. You may also set 'remove_all' to false, and this will only remove the first entry that matches with the given function. Returns the number of entries that have been removed.
	///@return {Real} The number of entries that have been removed.
	function remove_if(f, remove_all=true) {
		var actualSize=size();
		var removed=0;
		for (var i=0; i<actualSize; i++) {
			if (f(get(i), i)) {
				delete_at(i);
				actualSize--;
				i--;
				removed++;
				
				if (!remove_all) break;
			}
		}
		
		return removed;
	}
	
	///@desc This function removes the DS_List (the GameMaker data structure) from memory and marks the List (the struct itself) for garbage collection.
	function destroy() {ds_list_destroy(list);}
}
