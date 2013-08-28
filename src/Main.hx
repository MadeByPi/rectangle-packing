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
 */

package;

import haxe.PosInfos;
import jQuery.Event;

import madebypi.util.rectanglepacking.Packer;

import jQuery.JQuery;
import js.Lib;


class Main {
	
	#if debug
	public static var isDebug:Bool = true;
	#else
	public static var isDebug:Bool = false;
	#end
	
	// Static Main
	static function main () {
		
		try {
			checkJSScriptDepenencies();
		} catch (err:String) {
			trace("Error setting up - missing one or more JS script dependencies", "error");
			trace(err, "error");
			return;
		}
		
		// jquery / dom ready
		new JQuery(function (e:Event) {
			var parameters 	= getScriptSrcParameters("mbp_rectanglePacker");
			var container 	= getParameter("container", parameters, "div#rectContainer");
			var xCellSize 	= Std.parseInt(getParameter("xCellSize", parameters));
			var yCellSize 	= Std.parseInt(getParameter("yCellSize", parameters));
			var padX 		= Std.parseInt(getParameter("padX", parameters));
			var padY 		= Std.parseInt(getParameter("padY", parameters));
			
			new Packer(container, xCellSize, yCellSize, padX, padY);
		});
	}
	
	
	/**
	 *
	 */
	private static function checkJSScriptDepenencies():Void {
		// fix if missing console
		untyped __js__("if(typeof console === 'undefined'){console={log:function(){},debug:function(){},warn:function(){},error:function(){},info:function(){}};}");
		
		var missing:Bool = false;
		
		// jQuery
		missing = untyped __js__("typeof window.jQuery === 'undefined'");
		if (missing) { throw "jQuery not found"; }
	}
	
	
	
	/**
	 * read a query-string parameter from the <script> tag that embedded us
	 * @param	name
	 * @return
	 */
	public static function getParameter(name:String, inParams:Array<NameValuePair>, ?defaultValue:String=null):String {
		for (i in 0...inParams.length) if (inParams[i].name == name) return inParams[i].value;
		return defaultValue;
	}
	
	
	/**
	 * Find the <script> tag in the page that contains this script, selecting by searching script data attribites for the scriptDataSelector (wdig_xdvideo_Main)
	 * Once found/selected, get any/all querystring parameters from the src attribute
	 * @param	scriptDataSelector
	 * @return 	Array<NameValuePair>
	 */
	private static function getScriptSrcParameters(scriptDataSelector:String):Array<NameValuePair> {
		var myScriptSrc		:String = new JQuery("script[data*=" + scriptDataSelector + "]").attr("src");
		
		var params			:Array<String> = myScriptSrc.substr(myScriptSrc.indexOf("?") + 1).split("&");
		var param			:Array<String>;
		
		var queryParameters	:Array<NameValuePair> = [];
		
		for (i in 0...params.length) {
			param 				= params[i].split("=");
			queryParameters[i] 	= new NameValuePair(param[0], param[1]);
		}
		
		return queryParameters;
	}
}


class NameValuePair {
	public var name:String;
	public var value:String;
	public function new (?name:String=null, ?value:String=null) {
		this.name 	= name;
		this.value 	= value;
	}
}