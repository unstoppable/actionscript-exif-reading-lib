////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2003-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package 
{
	
	/**
	 *  The DateFormatter class uses a format String to return a formatted date and time String
	 *  from an input String or a Date object.
	 *  You can create many variations easily, including international formats.
	 *
	 *  <p>If an error occurs, an empty String is returned and a String describing 
	 *  the error is saved to the <code>error</code> property. The <code>error</code> 
	 *  property can have one of the following values:</p>
	 *
	 *  <ul>
	 *    <li><code>"Invalid value"</code> means a value that is not a Date object or a 
	 *    is not a recognized String representation of a date is
	 *    passed to the <code>format()</code> method. (An empty argument is allowed.)</li>
	 *    <li> <code>"Invalid format"</code> means either the <code>formatString</code> 
	 *    property is set to empty (""), or there is less than one pattern letter 
	 *    in the <code>formatString</code> property.</li>
	 *  </ul>
	 *
	 *  <p>The <code>parseDateString()</code> method uses the mx.formatters.DateBase class
	 *  to define the localized string information required to convert 
	 *  a date that is formatted as a String into a Date object.</p>
	 *  
	 *  @mxml
	 *  
	 *  <p>You use the <code>&lt;mx:DateFormatter&gt;</code> tag
	 *  to render date and time Strings from a Date object.</p>
	 *
	 *  <p>The <code>&lt;mx:DateFormatter&gt;</code> tag
	 *  inherits all of the tag attributes  of its superclass,
	 *  and adds the following tag attributes:</p>
	 *  
	 *  <pre>
	 *  &lt;mx:DateFormatter
	 *    formatString="Y|M|D|A|E|H|J|K|L|N|S|Q"
	 *   /> 
	 *  </pre>
	 *  
	 *  @includeExample examples/DateFormatterExample.mxml
	 *  
	 *  @see mx.formatters.DateBase
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class DateFormatter
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private    
		 */
		private static const VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S,Q";
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Converts a date that is formatted as a String into a Date object.
		 *  Month and day names must match the names in mx.formatters.DateBase.
		 *
		 *  The hour value in the String must be between 0 and 23, inclusive. 
		 *  The minutes and seconds value must be between 0 and 59, inclusive.
		 *  The following example uses this method to create a Date object:
		 *
		 *  <pre>
		 *  var myDate:Date = DateFormatter.parseDateString("2009-12-02 23:45:30"); </pre>
		 *  
		 *  @see mx.formatters.DateBase
		 * 
		 *  @param str Date that is formatted as a String. 
		 *
		 *  @return Date object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function parseDateString (str:String):Date
		{
			if (!str || str == "")
				return null;
			
			var year:int = -1;
			var mon:int = -1;
			var day:int = -1;
			var hour:int = -1;
			var min:int = -1;
			var sec:int = -1;
			
			var letter:String = "";
			var marker:Object = 0;
			
			var count:int = 0;
			var len:int = str.length;
			
			// Strip out the Timezone. It is not used by the DateFormatter
			var timezoneRegEx:RegExp = /(GMT|UTC)((\+|-)\d\d\d\d )?/ig;
			
			str = str.replace(timezoneRegEx, "");
			
			while (count < len)
			{
				letter = str.charAt(count);
				count++;
				
				// If the letter is a blank space or a comma,
				// continue to the next character
				if (letter <= " " || letter == ",")
					continue;
				
				// If the letter is a key punctuation character,
				// cache it for the next time around.
				if (letter == "/" || letter == ":" ||
					letter == "+" || letter == "-")
				{
					marker = letter;
					continue;
				}
				
				// Scan for groups of numbers and letters
				// and match them to Date parameters
				if ("a" <= letter && letter <= "z" ||
					"A" <= letter && letter <= "Z")
				{
					// Scan for groups of letters
					var word:String = letter;
					while (count < len) 
					{
						letter = str.charAt(count);
						if (!("a" <= letter && letter <= "z" ||
							"A" <= letter && letter <= "Z"))
						{
							break;
						}
						word += letter;
						count++;
					}
					
					
					marker = 0;
				}
					
				else if ("0" <= letter && letter <= "9")
				{
					// Scan for groups of numbers
					var numbers:String = letter;
					while ("0" <= (letter = str.charAt(count)) &&
						letter <= "9" &&
						count < len)
					{
						numbers += letter;
						count++;
					}
					var num:int = int(numbers);
					
					// If num is a number greater than 70, assign num to year.
					if (num >= 70)
					{
						if (year != -1)
						{
							break; // error
						}
						else if (letter <= " " || letter == "," || letter == "." ||
							letter == "/" || letter == "-" || count >= len)
						{
							year = num;
						}
						else
						{
							break; //error
						}
					}
						
						// If the current letter is a slash or a dash,
						// assign num to month or day.
					else if (letter == "/" || letter == "-" || letter == ".")
					{
						if (mon < 0)
							mon = (num - 1);
						else if (day < 0)
							day = num;
						else
							break; //error
					}
						
						// If the current letter is a colon,
						// assign num to hour or minute.
					else if (letter == ":")
					{
						if (hour < 0)
							hour = num;
						else if (min < 0)
							min = num;
						else
							break; //error
					}
						
						// If hours are defined and minutes are not,
						// assign num to minutes.
					else if (hour >= 0 && min < 0)
					{
						min = num;
					}
						
						// If minutes are defined and seconds are not,
						// assign num to seconds.
					else if (min >= 0 && sec < 0)
					{
						sec = num;
					}
						
						// If day is not defined, assign num to day.
					else if (day < 0)
					{
						day = num;
					}
						
						// If month and day are defined and year is not,
						// assign num to year.
					else if (year < 0 && mon >= 0 && day >= 0)
					{
						year = 2000 + num;
					}
						
						// Otherwise, break the loop
					else
					{
						break;  //error
					}
					
					marker = 0
				}
			}
			
			if (year < 0 || mon < 0 || mon > 11 || day < 1 || day > 31)
				return null; // error - needs to be a date
			
			// Time is set to 0 if null.
			if (sec < 0)
				sec = 0;
			if (min < 0)
				min = 0;
			if (hour < 0)
				hour = 0;
			
			// create a date object and check the validity of the input date
			// by comparing the result with input values.
			var newDate:Date = new Date(year, mon, day, hour, min, sec);
			if (day != newDate.getDate() || mon != newDate.getMonth())
				return null;
			
			return newDate;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function DateFormatter()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  formatString
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the formatString property.
		 */
		private var _formatString:String;
		
		[Inspectable(category="General", defaultValue="null")]
		
		/**
		 *  The mask pattern.
		 *  
		 *  <p>You compose a pattern String using specific uppercase letters,
		 *  for example: YYYY/MM.</p>
		 *
		 *  <p>The DateFormatter pattern String can contain other text
		 *  in addition to pattern letters.
		 *  To form a valid pattern String, you only need one pattern letter.</p>
		 *      
		 *  <p>The following table describes the valid pattern letters:</p>
		 *
		 *  <table class="innertable">
		 *    <tr><th>Pattern letter</th><th>Description</th></tr>
		 *    <tr>
		 *      <td>Y</td>
		 *      <td> Year. If the number of pattern letters is two, the year is 
		 *        truncated to two digits; otherwise, it appears as four digits. 
		 *        The year can be zero-padded, as the third example shows in the 
		 *        following set of examples: 
		 *        <ul>
		 *          <li>YY = 05</li>
		 *          <li>YYYY = 2005</li>
		 *          <li>YYYYY = 02005</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>M</td>
		 *      <td> Month in year. The format depends on the following criteria:
		 *        <ul>
		 *          <li>If the number of pattern letters is one, the format is 
		 *            interpreted as numeric in one or two digits. </li>
		 *          <li>If the number of pattern letters is two, the format 
		 *            is interpreted as numeric in two digits.</li>
		 *          <li>If the number of pattern letters is three, 
		 *            the format is interpreted as short text.</li>
		 *          <li>If the number of pattern letters is four, the format 
		 *           is interpreted as full text. </li>
		 *        </ul>
		 *          Examples:
		 *        <ul>
		 *          <li>M = 7</li>
		 *          <li>MM= 07</li>
		 *          <li>MMM=Jul</li>
		 *          <li>MMMM= July</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>D</td>
		 *      <td>Day in month. While a single-letter pattern string for day is valid, 
		 *        you typically use a two-letter pattern string.
		 * 
		 *        <p>Examples:</p>
		 *        <ul>
		 *          <li>D=4</li>
		 *          <li>DD=04</li>
		 *          <li>DD=10</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>E</td>
		 *      <td>Day in week. The format depends on the following criteria:
		 *        <ul>
		 *          <li>If the number of pattern letters is one, the format is 
		 *            interpreted as numeric in one or two digits.</li>
		 *          <li>If the number of pattern letters is two, the format is interpreted 
		 *           as numeric in two digits.</li>
		 *          <li>If the number of pattern letters is three, the format is interpreted 
		 *            as short text. </li>
		 *          <li>If the number of pattern letters is four, the format is interpreted 
		 *           as full text. </li>
		 *        </ul>
		 *          Examples:
		 *        <ul>
		 *          <li>E = 1</li>
		 *          <li>EE = 01</li>
		 *          <li>EEE = Mon</li>
		 *          <li>EEEE = Monday</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>A</td>
		 *      <td> am/pm indicator.</td>
		 *    </tr>
		 *    <tr>
		 *      <td>J</td>
		 *      <td>Hour in day (0-23).</td>
		 *    </tr>
		 *    <tr>
		 *      <td>H</td>
		 *      <td>Hour in day (1-24).</td>
		 *    </tr>
		 *    <tr>
		 *      <td>K</td>
		 *      <td>Hour in am/pm (0-11).</td>
		 *    </tr>
		 *    <tr>
		 *      <td>L</td>
		 *      <td>Hour in am/pm (1-12).</td>
		 *    </tr>
		 *    <tr>
		 *      <td>N</td>
		 *      <td>Minute in hour.
		 * 
		 *        <p>Examples:</p>
		 *        <ul>
		 *          <li>N = 3</li>
		 *          <li>NN = 03</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>S</td>
		 *      <td>Second in minute. 
		 * 
		 *        <p>Example:</p>
		 *        <ul>
		 *          <li>SS = 30</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>Q</td>
		 *      <td>Millisecond in second
		 * 
		 *        <p>Example:</p>
		 *        <ul>
		 *          <li>QQ = 78</li>
		 *          <li>QQQ = 078</li>
		 *        </ul></td>
		 *    </tr>
		 *    <tr>
		 *      <td>Other text</td>
		 *      <td>You can add other text into the pattern string to further 
		 *        format the string. You can use punctuation, numbers, 
		 *        and all lowercase letters. You should avoid uppercase letters 
		 *        because they may be interpreted as pattern letters.
		 * 
		 *        <p>Example:</p>
		 *        <ul>
		 *          <li>EEEE, MMM. D, YYYY at L:NN:QQQ A = Tuesday, Sept. 8, 2005 at 1:26:012 PM</li>
		 *        </ul></td>
		 *    </tr>
		 *  </table>
		 *
		 *  @default "MM/DD/YYYY"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get formatString():String
		{
			return _formatString;
		}
		
		/**
		 *  @private
		 */
		public function set formatString(value:String):void
		{
			_formatString = value 
		}
		
	}
	
}
