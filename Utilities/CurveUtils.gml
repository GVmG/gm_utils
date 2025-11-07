/*
		CURVE UTILITIES
		by Raechel V.
		version 2025.11
		
		See https://github.com/GVmG/gm_utils for more info.
*/

///@desc Bumps a number between 0 and 1 upwards towards 1.
function bump_up(n) 
{return 1-((1-n)*(1-n));}

///@desc Bumps a number between 0 and 1 downwards towards 0.
function bump_down(n) {return n*n;}

///@desc Smooths a number between 0 and 1 up or down, in an S-shaped curve.
function smoothstep(n) {return n*n*(3-2*n);}

///@desc Like smoothstep, but with a tighter curve - Ken Perlin's version.
function smootherstep(n) {return n*n*n*(n*(n*6-15)+10);}

///@desc Smoothstep to the p'th order. THIS IS SLOW.
function smoothstep_n(n, p) {
	var out=0;
	for (var i=0; i<=p; i++) {
		out+=pascal(-p-1, i)*pascal(2*p+1, p-i)*power(n, i+p+1);
	}
	
	return out;
}

///@desc Reverse of smoothstep - climbs up faster at the start and the end, and climbs slower in the middle.
function reverse_smoothstep(n) {return 0.5-sin(arcsin(1-2*n)/3);}

///@desc Takes a number betewen two values, and returns how far betwen the two it is (0 to 1).
function reverse_lerp(_min, _max, v) {return (v-_min)/(_max-_min);}

///@desc Alias of reverse_lerp() - takes a number betewen two values, and returns how far betwen the two it is (0 to 1).
function rlerp(_min, _max, v) {return reverse_lerp(_min, _max, v);}

///@desc Returns values of the pascal triangle. mostly used as a helper function to smoothstep_n().
function pascal(a, b) {
	var out=1;
	for (var i=0; i<b; i++) {
		out*=(a-i)/(i+1);
	}
	
	return out;

}
