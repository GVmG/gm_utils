/*
	Event System
	version 2023.12
	by Raechel V.
	
	See https://github.com/GVmG/gm_utils for more info.
	
	......................................................................
	
	A simple implementation of Events and Listeners.
	
	The system is set up so you won't have to interact with the Event instances directly, just the Listeners, and even then you can get the system going with
	just 'eventAddListener()' (which returns a Listener instance) and 'eventTrigger()' (which fires all the callback functions for the Listeners of that event).
	Either way, the Event class still retains internal functions for you to use if you really want to, and the main functions are able to handle Listener
	instances in if that's how you want to handle it instead of strings.
*/

global.__events=ds_map_create();

function Event(identifier) constructor {
	_id=identifier;
	listeners=ds_priority_create();
	tofire=ds_priority_create();
	executed=0; //how many times this Event has been triggered
	stopFurtherListeners=false; //if set to true by a Listener during the execution of this Event's trigger() function, it will stop firing any more Listeners until the next trigger.
	ds_map_add(global.__events, _id, self);
	
	///Adds a listener to this event.
	///@param {Struct.EventListener} listener
	///@param {Real} priority
	addListener=function(listener, priority=0) {
		ds_priority_add(listeners, listener, priority);
		listener._event=self;
	}
	
	///Removes a listener from this event.
	// Ideally don't use this, but call the Listener's .destroy() function instead.
	///@param {Struct.EventListener} listener
	removeListener=function(listener) {
		if (listener._event!=self) return false;
		
		var ind=ds_priority_find_priority(listeners, listener);
		if (ind) {
			ds_priority_delete_value(listeners, listener);
			return true;
		}
		
		return false;
	}
	
	///Removes all the listeners from this Event's list of listeners.
	removeAllListeners=function() {
		ds_priority_clear(listeners);
	}
	
	///Fires all the listeners of this event.
	// Note: an Event doesn't "fire". An Event triggers, *its listeners* fire when it is triggered.
	///@param {Array} args
	trigger=function(args=[]) {
		stopFurtherListeners=false;
		
		if (ds_priority_size(listeners)>0) {
			ds_priority_clear(tofire);
			ds_priority_copy(tofire, listeners);
			
			while (ds_priority_size(tofire)>0) {
				var l=ds_priority_delete_max(tofire);
				
				l.fire(l, args);
				
				if (l.toDestroy) {ds_priority_delete_value(listeners, l);}
				
				if (stopFurtherListeners) break;
			}
		}
		executed++;
	}
}

///@param {Struct.Event} event the event this Listener is listening to.
///@param {Function} callback the function to call when this listener is fired (should take all the arguments from eventTrigger() in).
///@param {Real} repeats the amount of times this listener should be fired before it is removed from the event's list of listeners 
function EventListener(event, callback, repeats) constructor {
	_event=event;
	callbackFunc=callback;
	reps=repeats;
	executed=0; //total number of times the listener was fired
	deafened=false; //callback will not be executed if the listener is deafened
	skipped=0; //number of times the listener was called to fire but didn't (either it was deafened or the provided listener was the wrong one)
	toDestroy=false;
	
	///Fires this Listener.
	// Do not use this function on your own, use eventTrigger() instead!!!
	fire=function(l, args=[]) {
		if (deafened || l!=self) {skipped++; return;}
		
		executed++;
		var del=callbackFunc(l, args);
		if (del || (reps>=0 && executed>=reps)) {toDestroy=true;}
	}
	
	///Destroys the Listener, removing it from its Event in the process.
	destroy=function() {
		toDestroy=true;
		_event.removeListener(self);
	}
}

///@param {String} event
function eventGet(event) {
	return ds_map_find_value(global.__events, event);
}

/*......................................................................*/

///Creates a new an event listener.
///If the callback function returns true, the listener will be removed from the Event's queue immediately after this execution, regardless of the 'repeats' value.
///Setting the parent Event's 'stopFurtherListeners' variable to true in the callback function will prevent lower priority listeners in the queue from firing on that trigger.
///@param {Struct.Event|String} event the Event this listener belongs to.
///@param {Function} callback the function to run when this listener is fired.
///@param {Real} priority the priority of this Listener over other listeners. Higher priority listeners are fired first.
///@param {Real} repeats the number of repetitions before this event listener is deleted (any negative value will keep the listener running forever).
function eventAddListener(event, callback, priority=0, repeats=-1) {
	var ev=event;
	if (is_string(event)) {ev=eventGet(event); ev??=new Event(event);}
	
	var evL=new EventListener(ev, callback, repeats);
	ev.addListener(evL, priority);
	return evL;
}

///Triggers the given Event, causing all of its Listeners to fire.
///@param {String} event
///@param {Array} args
function eventTrigger(event, args=[]) {
	var ev=event;
	if (is_string(event)) {ev=eventGet(event);}
	
	if (ev) ev.trigger(args);
}
