package fox.photo.exif.ifd
{
	import flash.utils.ByteArray;

	public class IFDValue
	{
		public var tag:uint

		public var value:Object;

		public function IFDValue()
		{

		}

		public function toString():String
		{
			return "[IFDValue: tag=" + tag + ",value=" + value + "]";
		}
	}
}
