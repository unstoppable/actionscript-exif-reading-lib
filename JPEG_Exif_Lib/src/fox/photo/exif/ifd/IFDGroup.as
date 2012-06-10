package fox.photo.exif.ifd
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class IFDGroup
	{
		public var name:String="";
		public var length:int=0;
		public var data:Array = [];
		public function IFDGroup()
		{
		}
		
		public function read(input:ByteArray):void{
			length = input.readUnsignedShort();
			for(var i:int=0;i<length;i++){
				var ifd:IFD = new IFD();
				ifd.read(input);
				data.push(ifd);
				trace(this,i,ifd,ifd.data);
			}
				
		}
	}
}