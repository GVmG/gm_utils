/*
		SIMPLE STATE MACHINE
		by Raechel V.
		version 2024.6
		
		See https://github.com/GVmG/gm_utils for more info.
		
		......................................................................
		
		Allows the instantiation of a simple state machine with states, automatically handling swapping between them.
		
		Use:
		1. create a State Machine with _sm=new StateMachine();
		2. create all the States you need with _state=new State(identifier, ...);
		2.1 add each State to the machine with _sm.addState(_state);
		3. initialize the machine with _sm.to("first state identifier");
*/

// Feather disable GM2017

///Returns a new State.
///@arg {String} identifier
function State(identifier, onDefined=function() {}, onEntered=function() {}, onStep=function() {}, onLeft=function() {}) constructor // Feather disable GM2017
{
	_identifier=identifier;
	_onEntered=onEntered;
	_onStep=onStep;
	_onLeft=onLeft;
	_onDefined=onDefined;
	_machine=undefined;
	
	///@arg {Struct} state
	to=function(state) {
		_machine.to(state);
	};
	
	_onDefined();
}

///Returns a new State Machine. Make sure to call to() to initialize the machine, and doStep() in the step event! Also don't forget to call onDestroy() whenever you don't need the State Machine anymore.
function StateMachine() constructor {
	states=ds_map_create();
	activeStateIdentifier="undefined";
	lastActiveState=activeStateIdentifier;
	suspended=false;
	ticks=0;
	ticksInState=0;
	
	///@arg {Struct} state
	addState=function(state) {
		ds_map_add(states, state._identifier, state);
		state._machine=self;
	}
	
	getActiveState=function() {
		return states[? activeStateIdentifier];
	}
	
	///@arg {String} state
	to=function(state) {
		if (!is_undefined(getActiveState())) getActiveState()._onLeft();
		lastActiveState=activeStateIdentifier;
		activeStateIdentifier=state;
		ticksInState=0;
		if (!is_undefined(getActiveState())) getActiveState()._onEntered();
	};
	
	doStep=function() {
		if (!suspended) {
			getActiveState()._onStep();
			ticks++;
			ticksInState++;
		}
	};
	
	onDestroy=function() {
		ds_map_destroy(states);
	}
}
