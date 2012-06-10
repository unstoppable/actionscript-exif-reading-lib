package fox.photo
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	public class HexBinaryConverter extends Sprite
	{
		public function HexBinaryConverter()
		{
		}

		public static function encode(ba:ByteArray):String
		{
			var len:uint=ba.length;
			var s:String="";
			for (var i:uint=0; i < len; i++)
			{
				s+=ba[i].toString(16);
			}
			return s;
		}

		public static function decode(value:String):ByteArray
		{
			var ba:ByteArray=new ByteArray();
			var len:uint=value.length;
			for (var i:uint=0; i < len; i+=2)
			{
				var c:String=value.charAt(i) + value.charAt(i + 1);
				ba.writeByte(parseInt(c, 16));
			}
			return ba;
		}
	}
}
