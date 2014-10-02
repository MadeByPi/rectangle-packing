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
import haxe.web.Request;
import js.Browser;

import js.JQuery;
import js.Lib;

import madebypi.util.rectanglepacking.Packer;

class Main {
	
	#if debug
	public static var isDebug:Bool = true;
	#else
	public static var isDebug:Bool = false;
	#end
	
	// Static Main
	static function main () {
				
		// jquery / dom ready
		new JQuery(cast Browser.document).ready(function(_) {
			var parameters = getScriptSrcParameters("mbp_rectanglePacker");
			if (parameters != null) {
				var container 	= parameters.exists("container") ? parameters.get("container") : "#rectContainer";
				var xCellSize 	= Std.parseInt(parameters.get("xCellSize"));
				var yCellSize 	= Std.parseInt(parameters.get("yCellSize"));
				var padX 		= Std.parseInt(parameters.get("padX"));
				var padY 		= Std.parseInt(parameters.get("padY"));
				
				var jContainer 	= new JQuery(container);
				for (i in 0...32) { 
					new JQuery(container).append(
						new JQuery('<div class="packableElement" style="width:${(32 + Std.random(128 - 32))}px;height:${(32 + Std.random(128 - 32))}px;"></div>')
					);
				}				
				Packer.create(container, xCellSize, yCellSize, padX, padY);
			}
		});
	}
	
	
	/**
	 * Find the <script> tag in the page that contains this script, selecting by searching script data attribites for the scriptDataSelector (wdig_xdvideo_Main)
	 * Once found/selected, get any/all querystring parameters from the src attribute
	 * @param	scriptDataSelector
	 * @return 	Array<NameValuePair>
	 */
	static function getScriptSrcParameters(scriptDataSelector:String):Map<String,String> {
		
		var embed = new JQuery("script[data*=" + scriptDataSelector + "]");
		if (embed.length == 0) return null;
		
		var scriptSrc 		= embed.attr("src");
		var params 			= scriptSrc.substr(scriptSrc.indexOf("?") + 1).split("&");
		var queryParameters = new Map<String,String>();
		
		if (params.length < 2) return null;
		
		for (i in 0...params.length) {
			var param = params[i].split("=");
			queryParameters.set(param[0], param[1]);
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