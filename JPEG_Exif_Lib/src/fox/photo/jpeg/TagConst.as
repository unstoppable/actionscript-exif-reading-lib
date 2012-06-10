package fox.photo.jpeg
{
	public class TagConst
	{
		public function TagConst()
		{
		}
		/**
		 * 段的格式:
~~~~~~~~~

  - header (4 bytes):
       $ff     段标识
        n      段的类型 (1 byte)
       sh, sl  该段长度, 包括这两个字节, 但是不包括前面的 $ff 和 n.
               注意: 长度不是 intel 次序, 而是 Motorola 的, 高字节在前,
      低字节在后!
  - 该段的内容, 最多 65533 字节

 注意:
  - 有一些无参数的段 (下面那些前面注明星号的)
    这些段没有长度描述 (而且没有内容), 只有 $ff 和类型字节.
  - 段之间无论有多少 $ff 都是合法的, 必须被忽略掉.

段的类型:
~~~~~~~~~
		 * */
		
		public static const TEM:uint   = 0x01;//【*忽略掉】
		public static const EXIF:uint   = 0xE1;//EXIF
		
		//Start Of Frame markers, non-differential, Huffman coding
		public static const SOF0:uint  = 0xc0;//帧开始 (baseline JPEG), 细节附后
		public static const SOF1:uint  = 0xc1;//   Extended sequential DCT
		public static const SOF2:uint  = 0xc2;//   Progressive DCT
		public static const SOF3:uint  = 0xc3;//   Lossless (sequential)
		
		//Start Of Frame markers, differential, Huffman coding
		public static const SOF5:uint  = 0xc5;//   Differential sequential DCT
		public static const SOF6:uint  = 0xc6;//   Differential progressive DCT
		public static const SOF7:uint  = 0xc7;//   Differential lossless (sequential)
		
		//Start Of Frame markers, non-differential, arithmetic coding
		public static const SOF8:uint  = 0xc8;//   Reserved for JPEG extensions
		public static const SOF9:uint  = 0xc9;//   arithmetic 编码(Huffman 的一种扩展算法), 通常不支持  Extended sequential DCT
		public static const SOF10:uint = 0xca;//   通常不支持 Progressive DCT
		public static const SOF11:uint = 0xcb;//   通常不支持 Lossless (sequential)
		
		//Start Of Frame markers, differential, arithmetic coding
		public static const SOF13:uint = 0xcd;//   通常不支持 Differential sequential DCT
		public static const SOF14:uint = 0xce;//   通常不支持 Differential progressive DCT
		public static const SOF15:uint = 0xcf;//   通常不支持 Differential lossless (sequential)
		
		public static const DHT:uint   = 0xc4;//   定义 Huffman Table,  细节附后
		public static const JPG:uint   = 0xc8;//   未定义/保留 (引起解码错误)
		public static const DAC:uint   = 0xcc;//   定义 Arithmetic Table, 通常不支持
		
		public static const RST0:uint  = 0xd0;// 【*忽略掉】  RSTn 用于 resync, 通常被忽略
		public static const RST1:uint  = 0xd1;//【*忽略掉】
		public static const RST2:uint  = 0xd2;//【*忽略掉】
		public static const RST3:uint  = 0xd3;//【*忽略掉】
		public static const RST4:uint  = 0xd4;//【*忽略掉】
		public static const RST5:uint  = 0xd5;//【*忽略掉】
		public static const RST6:uint  = 0xd6;//【*忽略掉】
		public static const RST7:uint  = 0xd7;//【*忽略掉】
		
		public static const SOI:uint   = 0xd8;//   图片开始
		public static const EOI:uint   = 0xd9;//   图片结束
		public static const SOS:uint   = 0xda;//   扫描行开始, 细节附后
		public static const DQT:uint   = 0xdb;//   定义 Quantization Table, 细节附后
		public static const DNL:uint   = 0xdc;//   通常不支持, 忽略
		public static const DRI:uint   = 0xdd;//   定义重新开始间隔, 细节附后
		public static const DHP:uint   = 0xde;//   忽略 (跳过)
		public static const EXP:uint   = 0xdf;//   忽略 (跳过)
		
		public static const APP0:uint  = 0xe0;//   JFIF APP0 segment marker (细节略)
		public static const APP15:uint = 0xef;//   忽略
		
		public static const JPG0:uint  = 0xf0;//   忽略 (跳过)
		public static const JPG13:uint = 0xfd;//   忽略 (跳过)
		public static const COM:uint   = 0xfe;//   注释, 细节附后
		
		public static function hasData(id:uint):Boolean{
			switch(id){
				case SOI:
				case EOI:
				case TEM:
				case RST0:
				case RST1:
				case RST2:
				case RST3:
				case RST4:
				case RST5:
				case RST6:
				case RST7:
					return false;
			}
			return true;
		}
	}
}