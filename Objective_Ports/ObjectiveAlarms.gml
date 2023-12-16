/*
    Objective Alarms
    version 2023.12
    By Raechel V.
	
	See https://github.com/GVmG/gm_utils for more info.
	
	......................................................................
	
	Allows the instantiation of custom Alarm structs that hold and control a TimeSource variable and all related functions, so that they can be called on the Alarm struct instances directly.
	
	Note that these structs cannot be passed to GameMaker's original time_source_* functions, as they are custom structs.
*/

enum AlarmUnits {SECONDS, TICKS};
enum AlarmExpire {AFTER, NEAREST};

enum AlarmErrors {ERR_TS_DESTROYED};

function Alarm(t=game_get_speed(gamespeed_fps), timeUnit=AlarmUnits.TICKS, repeats=0, instantStart=true, callback=function() {}, callbackArgs=[], expiryType=AlarmExpire.AFTER, destroyOnEnd=true, destroyOnStop=false) constructor {
	
	_t=t;
	_unit=timeUnit;
	_repeats=repeats;
	_instantStart=instantStart;
	_callback=callback;
	_callbackArgs=callbackArgs;
	_expiryType=expiryType;
	_destroyOnEnd=destroyOnEnd;
	_destroyOnStop=destroyOnStop;
	
	ts=time_source_create(time_source_game, _t, _unit==AlarmUnits.SECONDS ? time_source_units_seconds : time_source_units_frames, function() {
		method_call(_callback, _callbackArgs);
		
		if (loopsLeft()==0 && _destroyOnEnd) destroy();
	}, [], _repeats, _expiryType==AlarmExpire.NEAREST ? time_source_expire_nearest : time_source_expire_after);
	
	///Start the alarm.
	start=function() {if (!exists()) {return;}; time_source_start(ts);}
	///Pause the alarm.
	pause=function() {if (!exists()) {return;}; time_source_pause(ts);}
	///Resume the alarm.
	resume=function() {if (!exists()) {return;}; time_source_resume(ts);}
	///Stop the alarm. If _destroyOnStop is true, the alarm will be destroyed.
	stop=function() {if (!exists()) {return;}; time_source_stop(ts); if (_destroyOnStop) destroy();}
	///Reset the alarm. This does not automatically start it.
	reset=function() {if (!exists()) {return;}; time_source_reset(ts);}
	///Restart the alarm. This causes it to reset and then start from the reset state.
	restart=function() {if (!exists()) {return;}; reset(); start();}
	
	///Destroy the alarm. This will happen automatically if _destroyOnEnd is true.
	destroy=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; time_source_destroy(ts); return true;}
	
	///Returns how many repetitions the alarm still has to do.
	loopsLeft=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; return time_source_get_reps_remaining(ts);}
	///Returns how many repetitions the alarm has completed so far.
	loopsDone=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; return time_source_get_reps_completed(ts);}
	///Returns how many repetitions the alarm has to do in total (calculated on the fly).
	loopsTotal=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; var left=loopsLeft(); return loopsDone()+(left==undefined ? 0 : left);}
	
	///Returns the total duration of the alarm, in the unit that the alarm uses.
	duration=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; return time_source_get_period(ts);}
	///Returns the time left for the alarm to run the current iteration, in the unit that the alarm uses.
	left=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; return time_source_get_time_remaining(ts);}
	///Returns the unit that the alarm uses.
	unit=function() {if (!exists()) {return AlarmErrors.ERR_TS_DESTROYED;}; return time_source_get_units(ts);}
	
	///Returns whether or not the alarm's internal Time Source still exists.
	exists=function() {return ts!=undefined && time_source_exists(ts);}
	
	///Returns all the properties of the alarm as they were defined on instantiation. These may be different from the actual internal variables.
	properties=function() {return [_t, _unit, _repeats, _instantStart, _callback, _callbackArgs, _expiryType, _destroyOnEnd, _destroyOnStop];}
	
	///Creates a clone of this Alarm (based on its starting settings on instantiation) and returns it. Do note that if this original alarm was set to start instantly on instantiation, the copy will start instantly as well the moment this function is called.
	clone=function() {return new Alarm(_t, _unit, _repeats, _instantStart, _callback, _callbackArgs, _expiryType, _destroyOnEnd, _destroyOnStop);}
	
	if (_instantStart) start();
}

