/*
	2D Vectors
	version 2023.2
	by Raechel V.
	
	Offers a handy and quick way to Struct out 2D Vectors.
*/

///@desc Vec2, a Struct containing X and Y coordinates as well as handy functions to manipulate them.
function Vec2(ix, iy) constructor // Feather disable GM2017
{
	_x=ix;
	_y=iy;
	
	///@desc returns the magnitude (length) of this Vector, squared.
	///@return {Real}
	function length_squared() {return (_x*_x)+(_y*_y);}
	
	///@desc returns the magnitude (length) of this Vector.
	function length() {return sqrt(length_squared());}
	
	function magnitude() {return length();}
	function magnitude_squared() {return length_squared();}
	
	///@desc returns the Dot product between this Vector, and the given Vector.
	///@arg {Struct.Vec2} vec
	function dot(vec) {return dot_product(_x, _y, vec._x, vec._y);}
	
	///@desc returns the direction of this Vector.
	function dir() {return point_direction(0, 0, _x, _y);}
	
	///@desc returns the difference between the angles of this Vector, and the given Vector.
	///@arg {Struct.Vec2} vec
	function dir_difference(vec) {return angle_difference(dir(), vec.dir());}
	
	///@desc returns the direction from this Vector's coordinates, to the given Vector's coordinates. Essentially, returns the direction of a Vector created by subtracting this Vector from the given one.
	///@arg {Struct.Vec2} vec
	function direction_to(vec) {return point_direction(_x, _y, vec._x, vec._y);}
	
	///@desc returns the direction from the given Vector's coordinates, to this Vector's coordinates. Essentially, returns the direction of a Vector created by subtracting the given Vector from this one.
	///@arg {Struct.Vec2} vec
	function direction_from(vec) {return vec.direction_to(self);}
	
	//@desc returns a normalized copy of this vector.
	function normalized() {return new Vec2(_x/length(), _y/length());}
	
	///@desc normalizes the current Vector. If you want a normalized copy of the Vector without modifying it, use Vec2.normalized() instead.
	function normalize() {var l=length(); _x/=l; _y/=l;}
	
	///@desc subtracts the given Vector from this one.
	///@arg {Struct.Vec2} vec
	function subtract(vec) {offset(-vec._x, -vec._y);}
	
	///@desc adds the given Vector to this one.
	///@arg {Struct.Vec2} vec
	function add(vec) {offset(vec._x, vec._y);}
	
	///@desc offsets this Vector by the given amount.
	///@arg {Real} dx
	///@arg {Real} dy
	function offset(dx, dy) {_x+=dx; _y+=dy;}
	
	///@desc returns a new Vec2 with the same magnitude (length) as this Vector, and the angle offset by the given amount (in degrees).
	///@arg {Real} angle
	function rotated(angle) {var v=new Vec2(_x, _y); v.rotate(angle); return v;}
	
	///@desc rotates this Vector by a certain amount (in degrees). If you want a rotated copy of the Vector without modifying it, use Vec2.rotated() instead.
	///@arg {Real} angle
	function rotate(angle) {
		var dist=length();
		var d=dir();
		
		_x=lengthdir_x(dist, d+angle);
		_y=lengthdir_y(dist, d+angle);
	}
	
}












