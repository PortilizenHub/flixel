package flixel.util;

import haxe.ds.StringMap.StringMap;

/**
 * A class primarily containing functions related 
 * to formatting different data types to strings.
 */
class FlxStringUtil
{
	/**
	 * Takes two "ticks" timestamps and formats them into the number of seconds that passed as a String.
	 * Useful for logging, debugging, the watch window, or whatever else.
	 * 
	 * @param	StartTicks	The first timestamp from the system.
	 * @param	EndTicks	The second timestamp from the system.
	 * @return	A <code>String</code> containing the formatted time elapsed information.
	 */
	inline static public function formatTicks(StartTicks:Int, EndTicks:Int):String
	{
		return (Math.abs(EndTicks - StartTicks) / 1000) + "s";
	}
	
	/**
	 * Format seconds as minutes with a colon, an optionally with milliseconds too.
	 * 
	 * @param	Seconds		The number of seconds (for example, time remaining, time spent, etc).
	 * @param	ShowMS		Whether to show milliseconds after a "." as well.  Default value is false.
	 * @return	A nicely formatted <code>String</code>, like "1:03".
	 */
	inline static public function formatTime(Seconds:Float, ShowMS:Bool = false):String
	{
		var timeString:String = Std.int(Seconds / 60) + ":";
		var timeStringHelper:Int = Std.int(Seconds) % 60;
		if (timeStringHelper < 10)
		{
			timeString += "0";
		}
		timeString += timeStringHelper;
		if(ShowMS)
		{
			timeString += ".";
			timeStringHelper = Std.int((Seconds - Std.int(Seconds)) * 100);
			if (timeStringHelper < 10)
			{
				timeString += "0";
			}
			timeString += timeStringHelper;
		}
		
		return timeString;
	}
	
	/**
	 * Generate a comma-separated string from an array.
	 * Especially useful for tracing or other debug output.
	 * 
	 * @param	AnyArray	Any <code>Array</code> object.
	 * @return	A comma-separated <code>String</code> containing the <code>.toString()</code> output of each element in the array.
	 */
	inline static public function formatArray(AnyArray:Array<Dynamic>):String
	{
		var string:String = "";
		if ((AnyArray != null) && (AnyArray.length > 0))
		{
			string = Std.string(AnyArray[0]);
			var i:Int = 1;
			var l:Int = AnyArray.length;
			while (i < l)
			{
				string += ", " + Std.string(AnyArray[i++]);
			}
		}
		return string;
	}

	 /**
	 * Generate a comma-seperated string representation of the keys of a <code>StringMap</code>.
	 * 
	 * @param  AnyMap    A <code>StringMap</code> object.
	 * @return  A <code>String</code> formatted like this: <code>key1, key2, ..., keyX</code>
	 */
	inline static public function formatStringMap(AnyMap:Map<String,Dynamic>):String
	{
		var string:String = "";
		for (key in AnyMap.keys()) {
			string += Std.string(key);
			string += ", ";
		}
		
		return string.substring(0, string.length - 2);
	} 
	
	/**
	 * Automatically commas and decimals in the right places for displaying money amounts.
	 * Does not include a dollar sign or anything, so doesn't really do much
	 * if you call say <code>var results:String = FlxString.formatMoney(10,false);</code>
	 * However, very handy for displaying large sums or decimal money values.
	 * 
	 * @param	Amount			How much moneys (in dollars, or the equivalent "main" currency - i.e. not cents).
	 * @param	ShowDecimal		Whether to show the decimals/cents component. Default value is true.
	 * @param	EnglishStyle	Major quantities (thousands, millions, etc) separated by commas, and decimal by a period.  Default value is true.
	 * @return	A nicely formatted <code>String</code>.  Does not include a dollar sign or anything!
	 */
	inline static public function formatMoney(Amount:Float, ShowDecimal:Bool = true, EnglishStyle:Bool = true):String
	{
		var helper:Int;
		var amount:Int = Math.floor(Amount);
		var string:String = "";
		var comma:String = "";
		var zeroes:String = "";
		while(amount > 0)
		{
			if((string.length > 0) && comma.length <= 0)
			{
				if (EnglishStyle)
				{
					comma = ",";
				}
				else
				{
					comma = ".";
				}
			}
			zeroes = "";
			helper = amount - Math.floor(amount / 1000) * 1000;
			amount = Math.floor(amount / 1000);
			if(amount > 0)
			{
				if (helper < 100)
				{
					zeroes += "0";
				}
				if (helper < 10)
				{
					zeroes += "0";
				}
			}
			string = zeroes + helper + comma + string;
		}
		if(ShowDecimal)
		{
			amount = Std.int(Amount * 100) - (Std.int(Amount) * 100);
			string += (EnglishStyle ? "." : ",") + amount;
			if (amount < 10)
			{
				string += "0";
			}
		}
		return string;
	}
	
	/** 
	 * Takes a string and filters out everything but the digits.
	 * 
	 * @param 	Input	The input string
	 * @return 	The output string, digits-only
	 */
	static public function filterDigits(Input:String):String 
	{
		var output = new StringBuf();
		for (i in 0...Input.length) {
			var c = Input.charCodeAt(i);
			if (c >= '0'.code && c <= '9'.code) {
				output.addChar(c);
			}
		}
		return output.toString();
	}
	
	/**
	 * Format a text with html tags - useful for <code>TextField.htmlText</code>. 
	 * Used by the log window of the debugger.
	 * 
	 * @param	Text		The text to format
	 * @param	Size		The text size, using <font size>
	 * @param	Color		The text color, using <font color>
	 * @param	Bold		Whether the text should be bold (<b> tag)
	 * @param	Italic		Whether the text should be italic (<i> tag)
	 * @param	Underlined 	Whether the text should be underlined (<u> tag)
	 * @return	The html-formatted text.
	 */
	static public function htmlFormat(Text:String, Size:Int = 12, Color:String = "FFFFFF", Bold:Bool = false, Italic:Bool = false, Underlined:Bool = false):String
	{
		var prefix:String = "<font size='" + Size + "' color='#" + Color + "'>";
		var suffix:String = "</font>";
		
		if (Bold) 
		{
			prefix = "<b>" + prefix;
			suffix = suffix + "</b>";
		}
		if (Italic) 
		{
			prefix = "<i>" + prefix;
			suffix = suffix + "</i>";
		}
		if (Underlined) 
		{
			prefix = "<u>" + prefix;
			suffix = suffix + "</u>";
		}
		
		return prefix + Text + suffix;
	}
	
	/**
	 * Get the <code>String</code> name of any <code>Object</code>.
	 * 
	 * @param	Obj		The <code>Object</code> object in question.
	 * @param	Simple	Returns only the class name, not the package or packages.
	 * @return	The name of the <code>Class</code> as a <code>String</code> object.
	 */
	@:extern inline static public function getClassName(Obj:Dynamic, Simple:Bool = false):String
	{
		var s:String = Type.getClassName(Type.getClass(Obj));
		if (s != null)
		{
			s = StringTools.replace(s, "::", ".");
			if (Simple)
			{
				s = s.substr(s.lastIndexOf(".") + 1);
			}
		}
		return s;
	}
	
	/**
	 * Helper function that uses <code>getClassName</code> to compare two objects' class names.
	 * 
	 * @param	Obj1	The first object
	 * @param	Obj2	The second object
	 * @param	Simple 	Only uses the class name, not the package or packages.
	 * @return	Whether they have the same class name or not
	 */
	inline static public function sameClassName(Obj1:Dynamic, Obj2:Dynamic, Simple:Bool = true):Bool
	{
		return (getClassName(Obj1, Simple) == getClassName(Obj2, Simple));
	}
}