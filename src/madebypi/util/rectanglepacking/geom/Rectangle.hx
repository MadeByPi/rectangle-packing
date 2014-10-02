/*Copyright (c) 2012 Mike.Almond, MadeByPi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

package madebypi.util.rectanglepacking.geom;

/**
 * Bare minimum Rectangle functionality required for the rectangle packer.
 * Based on jeash/flash geom.Rectangle
 * 
 * IntRectangle
 *
 * @author Mike Almond -
 * https://github.com/MadeByPi
 * https://github.com/mikedotalmond
 *
 */

@:final class Rectangle {

	public var x		:Int;
	public var y 		:Int;
	public var width	:Int;
	public var height	:Int;

   public function new(x : Int = 0, y : Int = 0, width : Int = 0, height : Int = 0) : Void {
		this.x 		= x;
		this.y 		= y;
		this.width 	= width;
		this.height = height;
	}

	public function toString():String {
		return "[Rectangle x:" + x + ", y:" + y + ", w:" + width + ", h:" + height + "]";
	}

	public var area(get, null):Int;
	function get_area() return width * height;
	
	public var left(get,null) : Int;
	function get_left() return x;

	public var right(get,null) : Int;
	function get_right() return x + width;

	public var top(get,null) : Int;
	function get_top() return y;

	public var bottom(get,null) : Int;
	function get_bottom() return y + height;
	
	public var topLeft(get,null) : Point;
	function get_topLeft() return new Point(x,y);
	
	public var size(get,null) : Point;
	function get_size() return new Point(width, height);

	public var bottomRight(get, null) : Point;
	function get_bottomRight() return new Point(x + width, y + height);
	
	inline public function clone():Rectangle return new Rectangle(x, y, width, height);
	
	public function inflate(dx : Int, dy : Int) : Void  {
		x 		-= dx;
		width  	+= (dx << 1);
		y 		-= dy;
		height 	+= (dy << 1);
	}
	
	
	/**
	 * Inlineable intersection check for comparing 2 rectangles
	 * @param	rectA
	 * @param	rectB
	 * @return	True if the two rectangles intersect, false if not.
	 */
	public static inline function intersects(rectA:Rectangle, rectB:Rectangle) : Bool {
	  return	((rectA.right > rectB.right 	? rectB.right 	: rectA.right) 	<= 	(rectA.x < rectB.x ? rectB.x : rectA.x)) ? false :
				(rectA.bottom > rectB.bottom 	? rectB.bottom 	: rectA.bottom) > 	(rectA.y < rectB.y ? rectB.y : rectA.y);
	}
}