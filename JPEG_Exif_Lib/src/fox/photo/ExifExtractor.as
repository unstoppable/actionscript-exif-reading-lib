package fox.photo
{
	import flash.utils.ByteArray;
	
	import fox.photo.exif.InternalExif;
	import fox.photo.exif.ifd.IFD;
	import fox.photo.jpeg.Exif;
	import fox.photo.jpeg.JpegTag;
	import fox.photo.jpeg.SOF0;

	public class ExifExtractor
	{
		private var exifData:ByteArray;
		private var sof0Data:ByteArray;

		public function ExifExtractor()
		{
		}

		public static function readExif(image:ByteArray):Exif
		{
			var ee:ExifExtractor=new ExifExtractor();
			return ee.readExif(image);
		}


		public function readExif(image:ByteArray):Exif
		{
			readExifData(image);
			var exif:Exif=null;
			if (exifData)
			{
				try{
					exifData.position=0;
					var exifHeader:String=exifData.readUTFBytes(6);
					//trace("exifHeader="+exifHeader);
					var tiff:ByteArray=new ByteArray();
					exifData.readBytes(tiff);
					var iexif:InternalExif=new InternalExif();
					iexif.read(tiff);
					exif=createExif(iexif);
				}catch( e:Error){
					trace(this, e);
					exif=new Exif();
				}
			}
			else
			{
				exif=new Exif();
			}

			if (!exif.userful.height || !exif.userful.width)
			{
				if(this.sof0Data){
					var sof:SOF0=new SOF0();
					sof.read(this.sof0Data);
					exif.userful.height=sof.height;
					exif.userful.width=sof.width;
					trace(this, "SOF0(w,h)=", sof.width, sof.height);
				}
			}

			return exif;
		}

		private function createExif(iexif:InternalExif):Exif
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
			exif.initUseFul();
			return exif;
		}

		private function readExifData(data:ByteArray):void
		{
			try
			{
				data.position=0;
				while (data.bytesAvailable)
				{
					var tag:JpegTag=new JpegTag().read(data);
					if (tag.isExif)
					{
						if (!exifData)
							exifData=tag.data;
					}
					else if (tag.isSOF0)
					{
						if (!sof0Data)
							sof0Data=tag.data;
					}
					trace("ExifExtractor", tag);
				}
			}
			catch (error:Error)
			{
				trace(error);
			}
		}
	}
}
