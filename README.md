actionscript-exif-reading-lib
=============================

photo exif reading lib for actionscript3/flash


How to use this lib to get the photo's orientation:
`
import flash.utils.ByteArray;
import fox.photo.SimpleExifExtractor;
import fox.photo.exif.ifd.IFDValue;
import fox.photo.jpeg.Exif;

var orientation:int = -1;
var orientationId:int = 274;// in Exif2-2.PDF document, the orientation id is 274
var bytes:ByteArray = PhotoData;
var exif:Exif=SimpleExifExtractor.readExif(bytes);
var tag:IFDValue=exif.findTagById(orientationId);
if (tag) // in certain case, it might don't have orientation infomation. 
{
	orientation=parseInt("" + tag.value);
}
trace('orientation is:'+orientation);
`