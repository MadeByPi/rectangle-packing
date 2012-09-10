(function () { "use strict";
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
var Main = function() { }
Main.__name__ = true;
Main.main = function() {
	try {
		Main.checkJSScriptDepenencies();
	} catch( err ) {
		if( js.Boot.__instanceof(err,String) ) {
			haxe.Log.trace("Error setting up - missing one or more JS script dependencies",{ fileName : "Main.hx", lineNumber : 55, className : "Main", methodName : "main", customParams : ["error"]});
			haxe.Log.trace(err,{ fileName : "Main.hx", lineNumber : 56, className : "Main", methodName : "main", customParams : ["error"]});
			return;
		} else throw(err);
	}
	haxe.Log.trace = function(v,inf) {
		var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
		if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
		if(type == "info" || type == "error" || type == "warning") haxe.Firebug.trace(v,inf);
	};
	new $(function(e) {
		var parameters = Main.getScriptSrcParameters("mbp_rectanglePacker");
		var container = Main.getParameter("container",parameters,"div#rectContainer");
		var xCellSize = Std.parseInt(Main.getParameter("xCellSize",parameters));
		var yCellSize = Std.parseInt(Main.getParameter("yCellSize",parameters));
		var padX = Std.parseInt(Main.getParameter("padX",parameters));
		var padY = Std.parseInt(Main.getParameter("padY",parameters));
		new madebypi.util.rectanglepacking.Packer(container,xCellSize,yCellSize,padX,padY);
	});
}
Main.checkJSScriptDepenencies = function() {
	if(typeof console === 'undefined'){console={log:function(){},debug:function(){},warn:function(){},error:function(){},info:function(){}};}
	var missing = false;
	missing = typeof window.jQuery === 'undefined';
	if(missing) throw "jQuery not found";
}
Main.getParameter = function(name,inParams,defaultValue) {
	var _g1 = 0, _g = inParams.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(inParams[i].name == name) return inParams[i].value;
	}
	return defaultValue;
}
Main.getScriptSrcParameters = function(scriptDataSelector) {
	var myScriptSrc = new $("script[data*=" + scriptDataSelector + "]").attr("src");
	var params = HxOverrides.substr(myScriptSrc,myScriptSrc.indexOf("?") + 1,null).split("&");
	var param;
	var queryParameters = [];
	var _g1 = 0, _g = params.length;
	while(_g1 < _g) {
		var i = _g1++;
		param = params[i].split("=");
		queryParameters[i] = new NameValuePair(param[0],param[1]);
	}
	return queryParameters;
}
var NameValuePair = function(name,value) {
	this.name = name;
	this.value = value;
};
NameValuePair.__name__ = true;
NameValuePair.prototype = {
	__class__: NameValuePair
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var haxe = {}
haxe.Firebug = function() { }
haxe.Firebug.__name__ = true;
haxe.Firebug.trace = function(v,inf) {
	var type = inf != null && inf.customParams != null?inf.customParams[0]:null;
	if(type != "warn" && type != "info" && type != "debug" && type != "error") type = inf == null?"error":"log";
	console[type]((inf == null?"":inf.fileName + ":" + inf.lineNumber + " : ") + Std.string(v));
}
haxe.Log = function() { }
haxe.Log.__name__ = true;
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.prototype = {
	run: function() {
	}
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,__class__: haxe.Timer
}
var js = {}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Lib = function() { }
js.Lib.__name__ = true;
var madebypi = {}
madebypi.util = {}
madebypi.util.rectanglepacking = {}
madebypi.util.rectanglepacking.Packer = function(containerSelector,xCellSize,yCellSize,padX,padY) {
	if(padY == null) padY = 8;
	if(padX == null) padX = 8;
	if(yCellSize == null) yCellSize = 8;
	if(xCellSize == null) xCellSize = 8;
	var _g = this;
	this.xCellSize = xCellSize;
	this.yCellSize = yCellSize;
	this.padX = padX;
	this.padY = padY;
	if(xCellSize < 1) xCellSize = 1;
	if(yCellSize < 1) yCellSize = 1;
	this.tempPt = new madebypi.util.rectanglepacking.geom.Point();
	this.container = new $(containerSelector);
	this.outerBounds = madebypi.util.rectanglepacking.Packer.getDomElementBounds(this.container[0]);
	this.fixedElements = new $(containerSelector + " div.fixedElement");
	this.packableElements = new $(containerSelector + " div.packableElement");
	this.packables = new Array();
	this.packableElements.each(function(index,value) {
		_g.packables.push(new madebypi.util.rectanglepacking.Packable(index,value));
	});
	this.fixedPositions = [];
	this.fixedElements.each(function(index,element) {
		_g.fixedPositions[index] = madebypi.util.rectanglepacking.Packer.getDomElementBounds(element);
	});
	this.packableElements.css("display","none");
	this.prepare();
	this.fixedElements.remove();
	if(this.packables.length > 0) this.packItem(0); else haxe.Log.trace("Nothing to pack...?",{ fileName : "Packer.hx", lineNumber : 121, className : "madebypi.util.rectanglepacking.Packer", methodName : "new", customParams : ["warn"]});
};
madebypi.util.rectanglepacking.Packer.__name__ = true;
madebypi.util.rectanglepacking.Packer.getDomElementBounds = function(dom) {
	var element = new $(dom);
	var top = Std.parseFloat(element.css("top"));
	var left = Std.parseFloat(element.css("left"));
	if(Math.isNaN(top)) top = 0;
	if(Math.isNaN(left)) left = 0;
	return new madebypi.util.rectanglepacking.geom.Rectangle(left,top,Std.parseFloat(element.width()),Std.parseFloat(element.height()));
}
madebypi.util.rectanglepacking.Packer.prototype = {
	sortPackableItemsByArea: function() {
		var areas = [];
		var sizeIndex = [];
		var n = this.packables.length;
		var _g = 0;
		while(_g < n) {
			var i = _g++;
			areas.push({ index : i, area : this.packables[i].rect.get_area()});
		}
		areas.sort(function(a,b) {
			if(a.area > b.area) return -1;
			if(a.area < b.area) return 1;
			return 0;
		});
		this.areaSortedIndices = [];
		var _g = 0;
		while(_g < n) {
			var i = _g++;
			this.areaSortedIndices[i] = areas[i].index;
		}
	}
	,findSpace: function(target,rect) {
		rect.inflate(this.padX,this.padY);
		var columns = Math.round(this.outerBounds.width / this.xCellSize);
		var rows = Math.round(this.outerBounds.height / this.yCellSize);
		var dx = 0;
		var dy = 0;
		var px = 0;
		var py = 0;
		var fCount = this.fixedPositions.length;
		var spaceFound = false;
		var distance = this.outerBounds.width * this.outerBounds.height;
		var intersectsFixed = false;
		var nearest = new madebypi.util.rectanglepacking.geom.Rectangle();
		var d;
		var posK;
		distance = distance * distance;
		var _g = 0;
		while(_g < columns) {
			var i = _g++;
			px = i * this.xCellSize;
			rect.x = px;
			var _g1 = 0;
			while(_g1 < rows) {
				var j = _g1++;
				intersectsFixed = false;
				py = j * this.yCellSize;
				rect.y = py;
				if(rect.get_bottom() <= this.outerBounds.get_bottom()) {
					var _g2 = 0;
					while(_g2 < fCount) {
						var k = _g2++;
						posK = this.fixedPositions[k];
						intersectsFixed = intersectsFixed || ((posK.get_right() > rect.get_right()?rect.get_right():posK.get_right()) <= (posK.x < rect.x?rect.x:posK.x)?false:(posK.get_bottom() > rect.get_bottom()?rect.get_bottom():posK.get_bottom()) > (posK.y < rect.y?rect.y:posK.y));
					}
				} else intersectsFixed = true;
				if(!intersectsFixed) {
					spaceFound = true;
					this.tempPt.x = px;
					this.tempPt.y = py;
					dx = target.x - this.tempPt.x;
					dy = target.y - this.tempPt.y;
					d = dx * dx + dy * dy;
					if(d < distance) {
						distance = d;
						nearest.x = rect.x;
						nearest.y = rect.y;
						nearest.width = rect.width;
						nearest.height = rect.height;
					}
				}
			}
		}
		if(!spaceFound) {
			haxe.Log.trace("I'm sorry, I can't place that Dave.",{ fileName : "Packer.hx", lineNumber : 288, className : "madebypi.util.rectanglepacking.Packer", methodName : "findSpace"});
			return null;
		}
		nearest.inflate(-this.padX,-this.padY);
		return nearest;
	}
	,packComplete: function() {
		haxe.Log.trace("Packing completed!",{ fileName : "Packer.hx", lineNumber : 211, className : "madebypi.util.rectanglepacking.Packer", methodName : "packComplete", customParams : ["info"]});
		var c = 0;
		var _g1 = 0, _g = this.packables.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this.packables[i].packed) c++;
		}
		haxe.Log.trace("Packed " + c + " of a possible " + this.packables.length + " rectangles",{ fileName : "Packer.hx", lineNumber : 215, className : "madebypi.util.rectanglepacking.Packer", methodName : "packComplete", customParams : ["info"]});
	}
	,packItem: function(index) {
		var _g = this;
		var r = null;
		var start = new Date().getTime();
		var sortedIndex = this.areaSortedIndices[index];
		var item = this.packables[sortedIndex];
		if(!item.packed && !item.unpackable) {
			r = this.findSpace(this.targetPoint,item.rect.clone());
			if(r == null) {
				haxe.Log.trace("Out of space! Can't place item " + item.index + " " + Std.string(new $(item.element).html()),{ fileName : "Packer.hx", lineNumber : 171, className : "madebypi.util.rectanglepacking.Packer", methodName : "packItem", customParams : ["info"]});
				item.unpackable = true;
				new $(item.element).remove();
			} else {
				haxe.Log.trace("Placing item " + item.index + " at " + r.toString(),{ fileName : "Packer.hx", lineNumber : 177, className : "madebypi.util.rectanglepacking.Packer", methodName : "packItem"});
				item.packed = true;
				this.fixedPositions.push(r);
				new $(item.element).css("left",r.x).css("top",r.y).css("display","block").removeClass("packableElement").addClass("packedElement");
			}
		}
		var delta = new Date().getTime() - start;
		haxe.Log.trace("Took " + delta + "ms to pack rect",{ fileName : "Packer.hx", lineNumber : 192, className : "madebypi.util.rectanglepacking.Packer", methodName : "packItem"});
		index++;
		if(index == this.packables.length) {
			this.packComplete();
			return;
		} else if(delta > madebypi.util.rectanglepacking.Packer.MAX_PACK_TIME) haxe.Timer.delay(function() {
			_g.packItem(index);
		},madebypi.util.rectanglepacking.Packer.MAX_PACK_TIME); else this.packItem(index);
	}
	,prepare: function() {
		var masterFixedNode = new $("div#fixed-master.fixedElement");
		var targetRect;
		if(masterFixedNode.length == 0) {
			haxe.Log.trace("#fixed-master not found in .fixedElement items. Using the container instead...",{ fileName : "Packer.hx", lineNumber : 136, className : "madebypi.util.rectanglepacking.Packer", methodName : "prepare", customParams : ["info"]});
			targetRect = this.outerBounds.clone();
		} else targetRect = madebypi.util.rectanglepacking.Packer.getDomElementBounds(masterFixedNode[0]);
		this.sortPackableItemsByArea();
		this.targetPoint = new madebypi.util.rectanglepacking.geom.Point(targetRect.x + targetRect.width / 2,targetRect.y + targetRect.height / 2);
	}
	,__class__: madebypi.util.rectanglepacking.Packer
}
madebypi.util.rectanglepacking.Packable = function(index,element) {
	this.unpackable = false;
	this.packed = false;
	this.element = element;
	this.index = index;
	this.rect = madebypi.util.rectanglepacking.Packer.getDomElementBounds(element);
	new $(element).attr("id","packable_" + index);
};
madebypi.util.rectanglepacking.Packable.__name__ = true;
madebypi.util.rectanglepacking.Packable.prototype = {
	__class__: madebypi.util.rectanglepacking.Packable
}
madebypi.util.rectanglepacking.geom = {}
madebypi.util.rectanglepacking.geom.Point = function(pX,pY) {
	this.x = pX == null?0.0:pX;
	this.y = pY == null?0.0:pY;
};
madebypi.util.rectanglepacking.geom.Point.__name__ = true;
madebypi.util.rectanglepacking.geom.Point.prototype = {
	__class__: madebypi.util.rectanglepacking.geom.Point
}
madebypi.util.rectanglepacking.geom.Rectangle = function(x,y,width,height) {
	if(height == null) height = 0.0;
	if(width == null) width = 0.0;
	if(y == null) y = 0.0;
	if(x == null) x = 0.0;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
};
madebypi.util.rectanglepacking.geom.Rectangle.__name__ = true;
madebypi.util.rectanglepacking.geom.Rectangle.prototype = {
	inflate: function(dx,dy) {
		this.x -= dx;
		this.width += dx * 2;
		this.y -= dy;
		this.height += dy * 2;
	}
	,clone: function() {
		return new madebypi.util.rectanglepacking.geom.Rectangle(this.x,this.y,this.width,this.height);
	}
	,get_bottomRight: function() {
		return new madebypi.util.rectanglepacking.geom.Point(this.x + this.width,this.y + this.height);
	}
	,get_size: function() {
		return new madebypi.util.rectanglepacking.geom.Point(this.width,this.height);
	}
	,get_topLeft: function() {
		return new madebypi.util.rectanglepacking.geom.Point(this.x,this.y);
	}
	,get_bottom: function() {
		return this.y + this.height;
	}
	,get_top: function() {
		return this.y;
	}
	,get_right: function() {
		return this.x + this.width;
	}
	,get_left: function() {
		return this.x;
	}
	,get_area: function() {
		return this.width * this.height;
	}
	,toString: function() {
		return "[Rectangle x:" + this.x + ", y:" + this.y + ", w:" + this.width + ", h:" + this.height + "]";
	}
	,__class__: madebypi.util.rectanglepacking.geom.Rectangle
}
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js.XMLHttpRequest = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch( e ) {
		try {
			return new ActiveXObject("Microsoft.XMLHTTP");
		} catch( e1 ) {
			throw "Unable to create XMLHttpRequest object.";
		}
	}
}:(function($this) {
	var $r;
	throw "Unable to create XMLHttpRequest object.";
	return $r;
}(this));
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
madebypi.util.rectanglepacking.Packer.MAX_PACK_TIME = 40;
Main.main();
})();
