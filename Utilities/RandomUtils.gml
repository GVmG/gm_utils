/*
		RANDOM NUMBER GENERATION UTILITIES
		by Raechel V.
		version 2023.12
		
		See https://github.com/GVmG/gm_utils for more info.
*/

#region /        Utilities         /
//various random generation utilities

///returns true an f in m chances. leave m undeclared to get a percentage chance (0-1).
///picks a number between 0 and m, returns true if it's less than f.
///@param {Real} f
///@param {Real} m
function chance(f, m=1) {
	return (random(m)<f);
}

///returns either a number between 0 and 1, or between 0 and the first parameter, or a number between the two parameters, or a random choice from the list of parameters, depending on how many you input (0, 1, 2 or more)
///@param {Any} ...
function rnd() {
	if (argument_count==0) return random(1);
	if (argument_count==1) return random(argument[0]);
	if (argument_count==2) return random_range(argument[0], argument[1]);
	if (argument_count>2) return argument[irandom(argument_count-1)];
}

///returns a random choice from within the array of choices, with each choice having a certain weight to it
///@param {Array<Any>} choices a collection of possible choices
///@param {Array<Real>} weights a collection of weights, one each choice
function choose_weighted(choices, weights) {
	if (array_length(choices)!=array_length(weights)) return -1; //must have one weight each choice!
	var maxWeight=0;
	for (var i=0; i<array_length(weights); i++) {maxWeight+=weights[i];}
	
	var chosenWeight=random(maxWeight);
	var totWeight=0;
	for (var i=0; i<array_length(weights); i++) {
		totWeight+=weights[i];
		if (totWeight>=chosenWeight) return choices[i];
	}
	
	return -1; //wasn't able to choose.
}

///returns a random number given the seed n. non-integer values of n interpolate linearly between the integer ones.
///@param {Real} n
function random_linear(n) {
	return random_ext(n)
}

///returns a random number given the seed n, much like random_linear. Unlike random_linear, this uses smoothstep to smoothen out the randomvalues between the integers.
///@param {Real} n
function random_smooth(n) {
	return random_ext(n, ___sf_smoothstep);
}

///returns a random number given the seed n. Custom functions (taking a single input n, in range 0-1) can be used to control the smoothing of the values. The package includes many under the names ___sf_*
///@param {Real} n
///@param {Function} smooth_function a smoothing function, either from the ones included with the script or a custom (n) -> {0-1} one
function random_ext(n, smooth_function=___sf_linear) {
	var seed=random_get_seed();
	random_set_seed(floor(n));
	var a=random(1);
	random_set_seed(floor(n+1));
	var b=random(1);
	random_set_seed(seed);
	
	var i=n-floor(n);
	
	return lerp(a, b, smooth_function(i));
}

///returns a random number given the seed n. This number is affected by other octaves of noise, generating brownian-like (technically, *fractal*) noise.
///@param {Real} n
///@param {Real} octaves how many octaves of noise will be summed together
///@param {Function} smooth_function a smoothing function, either from the ones included with the script or a custom (n) -> {0-1} one
function random_fractal(n, octaves=4, smooth_function=___sf_linear) {
	var out=0, d=0;
	for (var i=1; i<=octaves; i++) {
		out+=random_ext(n*power(2, i-1), smooth_function)/i;
		d+=1/i;
	}
	
	return out/d;
}

#endregion

#region /   Smoothing Functions    /

///quadratic interpolation
function ___sf_quadratic(n) {return n*n;}
///reverse quadratic interpolation
function ___sf_reverse_quadratic(n) {return 1-((1-n)*(1-n));}
///linear interpolation
function ___sf_linear(n) {return n;}
///smoothstep interpolation (1st level)
function ___sf_smoothstep(n) {return n*n*(3-2*n);}
///smoothstep interpolation (perlin level)
function ___sf_smootherstep(n) {return n*n*n*(n*(n*6-15)+10);}
///reverse smoothstep interpolation (inverted 1st level)
function ___sf_reverse_smoothstep(n) {return 0.5-sin(arcsin(1-n*n)/3);}
///nth smoothstep interpolation
function ___sf_smoothstep_n(n, p) {
	var out=0;
	for (var i=0; i<=p; i++) {
		out+=pascal_triangle(-p-1, i)*pascal_triangle(2*p+1, p-i)*power(n, i+p+1);
	}
	
	return out;
}

#endregion

#region / Linear Congruential Generator /

///Returns the current maximum value the LCG can achieve. This is used to calculate the divisor for lcg_rnd().
function lcg_max() {
	if (global.___lcg_bitl==0) return global.___lcg_p; //no bitmask
	return (1 << (global.___lcg_bitl-global.___lcg_bitr));
}

///LCG integer. returns a value between 0 and the LCG's modulus.
///@return {Real}
function lcg() {
	global.___lcg_seed=(global.___lcg_seed*global.___lcg_m+global.___lcg_a) % global.___lcg_p;
	
	if (global.___lcg_bitl==0) return global.___lcg_seed; //no bitmask if the bit settings say so.
	
	var out=((global.___lcg_seed << (64-global.___lcg_bitl)) >> (64-global.___lcg_bitl+global.___lcg_bitr));
	if (out<0) return lcg_max()+out; //temporary fix for the lack of unit64 support. ideally yoyogames will add that asap.
	
	return out;
}

///LCG noise. returns a value between 0 and n.
///@param {Real} n
///@return {Real}
function lcg_rnd(n=1) {
	return (real(lcg())/lcg_max())*n;
}

///LCG noise in range. returns a floating point value between a and b.
///@param {Real} a
///@param {Real} b
///@return {Real}
function lcg_range(a=0, b=global.___lcg_p) {
	return lcg_rnd(b-a)+a;
}

///Reseeds the LCG. Leave seed empty (or -1) to randomize based on the current date and time.
///@param {Real} seed
function lcg_reseed(seed=-1) {
	if (seed==-1) {
		global.___lcg_seed=int64(date_get_second(date_current_datetime()) % global.___lcg_p);
		return;
	}
	global.___lcg_seed=int64(seed);
}

///Changes the settings of the LCG.
///@param {Real} m the multiplier
///@param {Real} a the additive
///@param {Real} p the modulus
///@param {Real} bitl the leftmost bit to return
///@param {Real} bitr the rightmost bit to return
///@param {Real} maxval the maximum value the rng can generate (used for generation purposes
///@param {Real} seed the starting seed
function lcg_settings(m, a, p, bitl=0, bitr=0, maxval=0, seed=-1) { //park-miller implementation
	global.___lcg_m=int64(m);
	global.___lcg_p=int64(p);
	global.___lcg_a=int64(a);
	global.___lcg_bitl=int64(bitl);
	global.___lcg_bitr=int64(bitr);
	lcg_reseed(seed);
}

////////////////////////////////////////// IMPLEMENTATIONS //////////////////////////////////////////

///Changes the settings of the LCG to the original Park-Miller/Lehmer implementation with m=16807.
function lcg_settings_parkmiller() {lcg_settings(16807, 0, 2147483647);}

///Changes the settings of the LCG to the more recent Park-Miller/Lehmer implementation with m=48271.
function lcg_settings_parkmiller2() {lcg_settings(48271, 0, 2147483647);}

///Changes the settings of the LCG to the Sinclair ZX81 implementation - 16-bit friendly, from 1981.
function lcg_settings_zx81() {lcg_settings(75, 74, 65537);}

///Changes the settings of the LCG to the IBM RANDU implementation, a Lehmer variant - NOTE: this is an infamous terrible implementation. do not use this. this is mostly included for reference.
function lcg_settings_randu() {lcg_settings(65539, 0, 2147483648);}

///Changes the settings of the LCG to the CRAY RANF implementation, a Lehmer variant - NOTE: this may not work due to how GameMaker handles real numbers.
function lcg_settings_ranf() {lcg_settings(44485709377909, 0, 281474976710656);}

///Changes the settings of the LCG to the Turbo Pascal implementation.
function lcg_settings_tpasc() {lcg_settings(134775813, 1, 4294967296);}

///Changes the settings of the LCG to the implementation suggested in the book Numerical Recipes by Knuth and H. W. Lewis.
function lcg_settings_numericalrecipes() {lcg_settings(1664525, 1013904223, 4294967296);}

///Changes the settings of the LCG to the implementation from Microsoft Visual Basic 6 (and earlier)
function lcg_settings_msvb6() {lcg_settings(1140671485, 12820163, 16777216);}

///Changes the settings of the LCG to the RtlUniform implementation from the Microsoft Native API.
function lcg_settings_rtluniform() {lcg_settings(2147483629, 2147483587, 2147483647);}

//Changes the settings of the LCG to the implementation from the GNU C Library (glibc).
function lcg_settings_glibc() {lcg_settings(1103515245, 12345, 2147483648, 30, 0);}

//Changes the settings of the LCG to the implementation from the ANSI C Standard.
function lcg_settings_ansic() {lcg_settings(1103515245, 12345, 2147483648, 30, 16);}

//Changes the settings of the LCG to the implementation from the Microsoft Visual C/C++ Compiler (MSVC).
function lcg_settings_msvc() {lcg_settings(214013, 2531011, 4294967296, 30, 16);}

//Changes the settings of the LCG to the implementation from the java.util.Random class in Java.
function lcg_settings_java() {lcg_settings(25214903917, 11, 281474976710656, 47, 16);}

/////////////////////////////////////////////////////////////////////////////////////////////////////

lcg_settings_parkmiller2(); //Initialize all required things. By default, use the modern Park-Miller implementation.

#endregion

#region /        Other Utils       /
//these ones aren't necessarily random-related, but they are used by the random generators in some ways.

///lerps between multiple values in different dimensions
///@param {Array<Real>} amounts a collection of 0-1 numbers to interpolate with
///@param {Array<Real>} values a collection of values to interpolate between
function dimensional_lerp(amounts, values) {
	if (array_length(values)!=power(2, array_length(amounts))) return -1; //there must be 2 values each dimension
	
	for (var i=0; i<array_length(amounts); i++) {
		for (var j=0; j<((1 << array_length(amounts))-i); j+=2) {
			values[floor(j/2)]=lerp(values[j], values[j+1], amounts[i]);
		}
	}
	
	return values[0];
}

///returns values of the pascal triangle. mostly used as a helper function to smoothstep_n().
///@param {Real} a
///@param {Real} b
function pascal_triangle(a, b) {
	var out=1;
	for (var i=0; i<b; i++) {
		out*=(a-i)/(i+1);
	}
	
	return out;
}

#endregion