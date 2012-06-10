package fox.photo.exif.ifd
{
	public class IFDType
	{
		/**
		 * The following types are used in Exif:
1 = BYTE An 8-bit unsigned integer.,
2 = ASCII An 8-bit byte containing one 7-bit ASCII code. The final byte is terminated with NULL.,
3 = SHORT A 16-bit (2 -byte) unsigned integer,
4 = LONG A 32-bit (4 -byte) unsigned integer,
5 = RATIONAL Two LONGs. The first LONG is the numerator and the second LONG expresses the
denominator.,
7 = UNDEFINED An 8-bit byte that can take any value depending on the field definition,
9 = SLONG A 32-bit (4 -byte) signed integer (2's complement notation),
10 = SRATIONAL Two SLONGs. The first SLONG is the numerator and the second SLONG is the
denominator.*/
		public function IFDType()
		{
		}
		public static const BYTE:uint=1 //  An 8-bit unsigned integer.,
		public static const ASCII:uint=	2 //  An 8-bit byte containing one 7-bit ASCII code. The final byte is terminated with NULL.,
		public static const SHORT:uint=		3 //  A 16-bit (2 -byte) unsigned integer,
		public static const LONG:uint=4 //  A 32-bit (4 -byte) unsigned integer,
		public static const RATIONAL:uint=5 //  Two LONGs. The first LONG is the numerator and the second LONG expresses the denominator.,
		public static const UNDEFINED:uint=	7 //  An 8-bit byte that can take any value depending on the field definition,
		public static const SLONG:uint=9 //  A 32-bit (4 -byte) signed integer (2's complement notation),
		public static const SRATIONAL:uint=10 //  Two SLONGs. The first SLONG is the numerator and the second SLONG is the denominator.		
	}
}