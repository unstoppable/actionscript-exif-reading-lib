package fox.photo.exif
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import fox.photo.HexBinaryConverter;
	import fox.photo.exif.ifd.IFD;
	import fox.photo.exif.ifd.IFDGroup;
	import fox.photo.exif.ifd.IFDValue;

	public class InternalExif
	{
		public var gps:IFDGroup;
		public var exif:IFDGroup;
		public var ifd0:IFDGroup;
		public var ifd1:IFDGroup;

		public function InternalExif()
		{

		}


		public function read(tiff:ByteArray):void
		{
			readHeaders(tiff);

			//0th IFD 
			var start:uint=tiff.readUnsignedInt();
			trace("00000008.H=" + start.toString(16));
			this.ifd0=readIFDGroup(tiff, start);

			//1st IFD
			trace(this, "read", "IFD1");
			start=tiff.readUnsignedInt();
			this.ifd1=readIFDGroup(tiff, start);

			//EXIF
			trace(this, "read", "EXIF");
			var exifIFD:IFDValue=this.findTagById(34665);
			if (exifIFD)
				this.exif=readIFDGroup(tiff, uint(exifIFD.value));

			//GPS
			trace(this, "read", "GPS");
			var gpsIFD:IFDValue=this.findTagById(34853);
			if (gpsIFD)
				this.gps=readIFDGroup(tiff, uint(gpsIFD.value));

		}

		public function findTagById(id:uint):IFDValue
		{
			var i:IFD=null;
			if (this.ifd0)
				for each (i in this.ifd0.data)
				{
					if (i.tag == id)
					{
						return i.data;
					}
				}

			if (this.ifd1)
				for each (i in this.ifd1.data)
				{
					if (i.tag == id)
					{
						return i.data;
					}
				}

			if (this.gps)
				for each (i in this.gps.data)
				{
					if (i.tag == id)
					{
						return i.data;
					}
				}

			if (this.exif)
				for each (i in this.exif.data)
				{
					if (i.tag == id)
					{
						return i.data;
					}
				}

			return null;
		}

		private function readIFDGroup(tiff:ByteArray, start:uint):IFDGroup
		{
			try
			{
				tiff.position=start;
				var g:IFDGroup=new IFDGroup();
				g.read(tiff);
				return g;
			}
			catch (error:Error)
			{
				trace(this, "readIFDGroup", "pos=" + start.toString(16));
			}
			return null;

		}

		private function readHeaders(tiff:ByteArray):void
		{
			//TIFF Headers
			tiff.position=0;
			var a:uint=tiff.readUnsignedByte();
			var b:uint=tiff.readUnsignedByte();
			if (a == 0x4d && b == 0x4d)
			{
				tiff.endian=Endian.BIG_ENDIAN;
			}
			else if (a == 0x49 && b == 0x49)
			{
				tiff.endian=Endian.LITTLE_ENDIAN;
			}
			else
			{
				tiff.position=0;
				var log:String = HexBinaryConverter.encode(tiff);
				log = log.replace(/([\dabcdef]{32})/gi,"$1\n");
				log = log.replace(/([\dabcdef]{2})/gi,"$1 ");
				trace(this,"readHeaders","\n"+log);
				throw new Error("invalid TIFF header");
			}

			//002A.H (fixed)
			var fixed:uint=tiff.readUnsignedShort();
			trace("002A.H (fixed)=" + fixed.toString(16));
		}
	}
}
