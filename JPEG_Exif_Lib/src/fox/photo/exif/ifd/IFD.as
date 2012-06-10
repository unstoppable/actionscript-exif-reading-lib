package fox.photo.exif.ifd
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	/**
	 *		Bytes 0-1 Tag
		Bytes 2-3 Type
		Bytes 4-7 Count
		Bytes 8-11 Value Offset
	 * @author Liu
	 *
	 */
	public class IFD
	{


		/**
		 *Each tag is assigned a unique 2-byte number to identify the field. The tag numbers in the Exif 0th IFD and 1st IFD
are all the same as the TIFF tag numbers.
	 */
		public var tag:uint

		public var type:uint
		/**
		 *The number of values. It should be noted carefully that the count is not the sum of the bytes. In the case of one value
of SHORT (16 bits), for example, the count is '1' even though it is 2 bytes.
	 */
		public var count:uint
		/**
		 *This tag records the offset from the start of the TIFF header to the position where the value itself is recorded. In
cases where the value fits in 4 bytes, the value itself is recorded. If the value is smaller than 4 bytes, the value is
stored in the 4-byte area starting from the left, i.e., from the lower end of the byte offset area. For example, in big
endian format, if the type is SHORT and the value is 1, it is recorded as 00010000.H.
Note that field Interoperability must be recorded in sequence starting from the smallest tag number. There is no
stipulation regarding the order or position of tag value (Value) recording.
	 */
		public var offset:uint

		public var data:IFDValue;

		public function IFD()
		{
			data=new IFDValue();
		}

		public function read(input:ByteArray):void
		{
			var pos:uint=input.position;
			tag=input.readUnsignedShort();
			type=input.readUnsignedShort();
			count=input.readUnsignedInt();
			data.tag = tag;
			readValue(input);
			input.position=pos + 12;
		}

		public function readValue(tiff:ByteArray):void
		{
			var value:Object=null;
			switch (type)
			{
				case 1: //取全整byte类型(Byte)
					value=tiff.readUnsignedByte();
					break;
				case 2: //取ASCII(ASCII)
					if (count <= 4)
					{
						value=tiff.readUTFBytes(count);
					}
					else
					{
						offset=tiff.readUnsignedInt();
						tiff.position=offset;
						value=tiff.readUTFBytes(count);
					}
					break;
				case 3: //取全整uint类型(SHORT)
					value=tiff.readUnsignedShort();
					break;
				case 4: //取全整INT类型(LONG)
					value=tiff.readUnsignedInt();
					break;
				case 5: //取全整INT类型分数(RATIONAL)
					offset=tiff.readUnsignedInt();
					tiff.position=offset;
					value=tiff.readUnsignedInt() + "/" + tiff.readUnsignedInt();
					break;
				case 7: //取任意字节(UNDEFINED)
					if (count <= 4)
					{
						value=tiff.readUTFBytes(count);
					}
					else
					{
						offset=tiff.readUnsignedInt();
						tiff.position=offset;
						value=tiff.readUTFBytes(count);
					}
					break;
				case 9: //取INT类型(SLONG)
					value=tiff.readInt();
					break;
				case 10: //取INT类型分数(SRATIONAL)
					offset=tiff.readUnsignedInt();
					tiff.position=offset;
					value=tiff.readInt() + "/" + tiff.readInt();
					break;
				
				default :break;
			}
			this.data.value=value;
		}

		public function toString():String
		{
			return "[IFD: tag=" + tag + ",\ttype=" + type + ",\tcount=" + count + ",\toffset=0x" + offset.toString(16) + "]";
		}
	}
}
