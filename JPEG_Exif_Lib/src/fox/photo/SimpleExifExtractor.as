package fox.photo
{
	import flash.utils.ByteArray;
	
	import fox.photo.exif.InternalExif;
	import fox.photo.exif.ifd.IFD;
	import fox.photo.jpeg.Exif;
	import fox.photo.jpeg.JpegTag;

	public class SimpleExifExtractor
	{
		public function SimpleExifExtractor()
		{
		}

		public static function readExif(image:ByteArray):Exif
		{
			var exifData:ByteArray = readExifData(image);
			var exif:Exif=new Exif();
			if (exifData)
			{
				try{
					exifData.position=0;
					var exifHeader:String=exifData.readUTFBytes(6);
					var tiff:ByteArray=new ByteArray();
					exifData.readBytes(tiff);
					var iexif:InternalExif=new InternalExif();
					iexif.read(tiff);
					exif=createExif(iexif);
				}catch( e:Error){
				}
			}
			return exif;
		}

		private static function createExif(iexif:InternalExif):Exif
		{
			var exif:Exif=new Exif();
			var i:IFD=null;
			if (iexif.ifd0)
				for each (i in iexif.ifd0.data)
				{
					exif.tags.push(i.data);
				}

			if (iexif.ifd1)
				for each (i in iexif.ifd1.data)
				{
					exif.tags.push(i.data);
				}

			if (iexif.gps)
				for each (i in iexif.gps.data)
				{
					exif.tags.push(i.data);
				}

			if (iexif.exif)
				for each (i in iexif.exif.data)
				{
					exif.tags.push(i.data);
				}
			return exif;
		}

		private static function readExifData(data:ByteArray):ByteArray
		{
			try
			{
				data.position=0;
				while (data.bytesAvailable)
				{
					var tag:JpegTag=new JpegTag().read(data);
					if (tag.isExif)
					{
						return tag.data;
					}
				}
			}
			catch (error:Error)
			{
				trace(error);
			}
			return null;
		}
	}
}
