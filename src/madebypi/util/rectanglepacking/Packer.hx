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

/**
 * ...
 *
 * @author Mike Almond -
 * https://github.com/MadeByPi
 * https://github.com/mikedotalmond
 *
 * Uses parts of jeash (Rectangle and Point)
 * https://github.com/grumpytoad/jeash
 */

package madebypi.util.rectanglepacking;

import haxe.Timer;
import js.html.HtmlElement;
import js.html.Node;
import js.JQuery;

import madebypi.util.rectanglepacking.geom.Point;
import madebypi.util.rectanglepacking.geom.Rectangle;


@:expose('RectanglePacker')
@:final class Packer {
	
	static inline var MAX_PACK_TIME		:Int = 40; //; max time in ms allowed for a packing step - 40ms == 25fps
	
	var packables						:Array<Packable>;
	var fixedPositions					:Array<Rectangle>;
	var areaSortedIndices				:Array<Int>;
	var targetPoint						:Point;
	var xCellSize						:Int;
	var yCellSize						:Int;
	var padX							:Int;
	var padY							:Int;
	
	var tempPt							:Point;
	
	public var container(default, null):JQuery;
	public var outerBounds(default, null):Rectangle;
	public var fixedElements(default, null):JQuery;
	public var packableElements(default, null):JQuery;
	
	
	public static function create(containerSelector:String, ?xCellSize:Int=8, ?yCellSize:Int=8, ?padX:Int = 8, ?padY:Int = 8) {
		return new Packer(containerSelector, xCellSize, yCellSize, padX, padY);
	}
	
	/**
	 * Create a new Packer...
	 * @param	?xCellSize
	 * @param	?yCellSize
	 * @param	?padX
	 * @param	?padY
	 */
	public function new(containerSelector:String, ?xCellSize:Int=8, ?yCellSize:Int=8, ?padX:Int = 8, ?padY:Int = 8) {
		
		container = new JQuery(containerSelector);
		if (container.length == 0) {
			throw 'Container element "$containerSelector" does not exist.';
			return;
		}
		
		this.xCellSize  = xCellSize;
		this.yCellSize  = yCellSize;
		this.padX 		= padX;
		this.padY 		= padY;
		
		if (xCellSize < 1) xCellSize = 1;
		if (yCellSize < 1) yCellSize = 1;
		
		tempPt 			= new Point();
		outerBounds		= Packer.getDomElementBounds(cast container[0]);
		
		fixedElements 	= new JQuery(containerSelector + " div.fixedElement");
		packableElements= new JQuery(containerSelector + " div.packableElement");
		
		packables 		= new Array<Packable>();
		packableElements.each(function(index:Int, value:Node) {
			packables.push(new Packable(index, cast value));
		});
		
		fixedPositions = [];
		fixedElements.each(function(index:Int, element:Node) {
			fixedPositions[index] = Packer.getDomElementBounds(cast element);
		});
		
		#if debug
		packableElements.css("display", "block").css("background-color", "#aaa");
		#else
		packableElements.css("display", "none");
		#end
		
		prepare();
		
		#if debug
		fixedElements.css("display", "block").css("background-color", "#666");
		#else
		fixedElements.remove();
		#end
		
		// start finding spaces for each of the packable items...
		// elements get added to fixedPositions as a place is found
		// packItem starts off a sequential calling of packItem untill it has been called for every index up to packables.length.
		// if execution time is too long, subsequent calls to packItem will be delayed to give the browser time to render (only really an issue in browsers with slower js engines, like firefox)
		if(packables.length > 0){
			packItem(0);
		} else {
			trace("Nothing to pack...?");
		}
	}
	
	
	/**
	 * Start packing elements...
	 */
	function prepare():Void {
		
		// masterFixedNode is the rect we will try to arrange elements around...
		var masterFixedNode = new JQuery("div#fixed-master.fixedElement");
		var targetRect;
		
		if (masterFixedNode.length == 0) {
			trace("#fixed-master not found in .fixedElement items. Using the container instead...");
			targetRect = outerBounds.clone();
		} else {
			targetRect = Packer.getDomElementBounds(cast masterFixedNode[0]);
			#if debug
			masterFixedNode.css("display", "block").css("background-color", "#666");
			#end
		}
		
		// sort all packables by size (biggest first)
		sortPackableItemsByArea();
		
		// our target - the middle of the master rect
		targetPoint = new Point(targetRect.x + Math.round(targetRect.width/2), targetRect.y + Math.round(targetRect.height/2));
	}
	
	/**
	 *
	 * @param	index
	 */
	function packItem(index:Int):Void {
		
		var r				= null;
		var start 			= Date.now().getTime();
		var sortedIndex		= areaSortedIndices[index];
		var item		 	= packables[sortedIndex];
		
		if (!item.packed && !item.unpackable) { // not been processed already?
			
			// find a place for it... this is the time-consuming step
			r = findSpace(targetPoint, item.rect.clone());
			
			if (r == null) {
				// doh! no space found for that item...
				trace("Out of space! Can't place item " + item.index + " " + new JQuery(item.element).html());
				// set item as unpackable and remove from the DOM
				item.unpackable = true;
				new JQuery(item.element).remove();
				
			} else {
				trace("Placing item " + item.index + " at " + r.toString());
				
				// success!
				item.packed = true;
				fixedPositions.push(r);
				// update position in the document...
				item.jElement
					.css({"left":r.x}).css({"top":r.y}).css("display", "block")
					.removeClass("packableElement")
					.addClass("packedElement");
			}
		}
		
		var delta = Date.now().getTime() - start;
		
		#if debug
		trace('Took $delta ms to pack rect');
		#end
		
		index++;
		if (index == packables.length) {
			packComplete();
			return;
		} else {
			if (delta > MAX_PACK_TIME) {
				Timer.delay(function() { packItem(index); }, MAX_PACK_TIME);
			} else {
				packItem(index);
			}
		}
	}
	
	/**
	 * TODO: need to call any actions on completion?
	 */
	function packComplete():Void {
		
		trace("Packing complete");
		
		#if debug
		var c:Int = 0;
		for (i in 0...packables.length) if (packables[i].packed) c++;
		trace("Packed " + c + " of a possible " + packables.length + " rectangles");
		#end
	}
	
	// scan all the enclosing bounds for a space that will accomodate the rect
	function findSpace(target:Point, rect:Rectangle):Rectangle {
		
		// add padding...
		rect.inflate(padX, padY);
		
		// size of the search grid steps
		var columns			:Int 		= Math.round(outerBounds.width / xCellSize);
		var rows			:Int 		= Math.round(outerBounds.height / yCellSize);
		
		var dx				:Float 		= 0;
		var dy				:Float 		= 0;
		var px				:Int 		= 0;
		var py				:Int 		= 0;
		var fCount			:Int 		= fixedPositions.length;
		
		var spaceFound		:Bool  		= false;
		var distance		:Float 		= outerBounds.width * outerBounds.height; // start massive...
		var intersectsFixed	:Bool 		= false;
		var nearest 		:Rectangle	= new Rectangle();
		var d				:Float;
		var posK			:Rectangle;
		
		// square the distance here, so we don't have to sqrt the delta in the loop
		distance = distance * distance;
		
		for (i in 0...columns) {
			px 		= i * xCellSize;
			rect.x 	= px;
			for (j in 0...rows) {
				
				// process row
				intersectsFixed = false;
				py 				= j * yCellSize;
				rect.y 			= py;
				
				// check the rect is inside the main bounds...
				if(rect.bottom <= outerBounds.bottom) {
					for (k in 0...fCount) {
						// assign rect to temp var to allow inlining of the intersection check...
						posK = fixedPositions[k];
						// check the rect against each fixed position item...
						intersectsFixed = intersectsFixed || Rectangle.intersects(posK, rect);
					}
				} else {
					intersectsFixed = true;
				}
				
				if (!intersectsFixed) {
					
					spaceFound 	= true;
					tempPt.x 	= px;
					tempPt.y 	= py;
					
					dx 			= target.x - tempPt.x;
					dy 			= target.y - tempPt.y;
					d  			= (dx * dx + dy * dy); // don't bother with Math.sqrt - we're comparing against distance*distance to avoid this
					
					if (d < distance) {
						distance 		= d;
						nearest.x 		= rect.x;
						nearest.y 		= rect.y;
						nearest.width 	= rect.width;
						nearest.height 	= rect.height;
					}
				}
			}
		}
		
		if (!spaceFound) {
			trace("I'm sorry, I can't place that Dave.");
			return null;
		}
		
		// un-padding
		nearest.inflate(-padX, -padY);
		
		return nearest;
	}
	
	
	// sort movable rects based on size (rect area)
	function sortPackableItemsByArea() {
		
		// prepare...
		var areas = [];
		for (i in 0...packables.length) {
			areas.push( { index:i, area:packables[i].rect.area } );
		}
		
		//sort areas - biggest first
		areas.sort(function(a:Dynamic, b:Dynamic):Int {
			if (a.area > b.area) return -1;
			if (a.area < b.area) return 1;
			return 0;
		});
		
		// obtain sorted index array from areas
		areaSortedIndices = [];
		for (i in 0...packables.length) areaSortedIndices[i] = areas[i].index;
	}
	
	
	
	/**
	 *
	 * @param	element
	 * @return
	 */
	static public function getDomElementBounds(dom:HtmlElement):Rectangle {
		
		var s = dom.style;
		
		var width = Std.parseInt(s.width.substr(0, s.width.length - 2));
		var height = Std.parseInt(s.height.substr(0, s.height.length - 2));
		if (width==null) width = dom.clientWidth;
		if (height==null) height = dom.clientHeight;
		
		var top	 = Std.parseInt(s.top);
		var left = Std.parseInt(s.left);
		if (Math.isNaN(top)) top = 0; if (Math.isNaN(left)) left = 0;
		
		return new Rectangle(left, top, width, height);
	}
}


@:final class Packable {
	
	public var element		:HtmlElement;
	public var rect			:Rectangle;
	public var index		:Int;
	
	public var packed		:Bool;
	public var unpackable	:Bool;
	public var jElement		:JQuery;
	
	public function new(index:Int, element:HtmlElement) {
		element.id		= "packable_" + index;
		jElement		= new JQuery(element);
		this.unpackable	= false;
		this.packed 	= false;
		this.element 	= element;
		this.index 		= index;
		this.rect		= Packer.getDomElementBounds(element);		
	}
}