package fox.photo.jpeg
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	public class JpegTag 
	{
		public var id:int=0;
		public var length:int=0;
		public var data:ByteArray=null
		
		public function JpegTag()
		{
		}
		
		public function get isStartTag():Boolean{
			return TagConst.SOI==id;
		}
		public function get isEndTag():Boolean{
			return TagConst.EOI==id;
		}
		public function get isExif():Boolean{
			return TagConst.EXIF==id;
		}
		
		public function get isSOF0():Boolean{
			return TagConst.SOF0==id||TagConst.SOF2==id;
		}
		
		public function read(input:IDataInput):JpegTag{
			if(0xff != input.readUnsignedByte()){
				throw new Error("not a jpeg tag");
			}
			id = input.readUnsignedByte();
			if(!TagConst.hasData(id)) return this;
			length = input.readUnsignedShort();
			data = new ByteArray();
			input.readBytes(data,0,length-2);
			return this;
		}
		
		public function write(output:IDataOutput):void{
			output.writeByte(0xff);
			output.writeByte(id);
			output.writeShort(length);
			output.writeBytes(data);
		}
		
		public function toString():String{
			return "Tag["+id.toString(16)+","+length.toString(16)+"]";
		}
		
	}
}