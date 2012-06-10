package fox.photo.jpeg
{
	import flash.utils.IDataInput;

	/*
	- $ff, $c0 (SOF0)
	- 长度 (高字节, 低字节), 8+components*3     这里占两个字节
	- 数据精度 (1 byte) 每个样本位数, 通常是 8 (大多数软件不支持 12 和 16)    这里占一个字节
	- 图片高度 (高字节, 低字节), 如果不支持 DNL 就必须 >0      这里占两个字节
	- 图片宽度 (高字节, 低字节), 如果不支持 DNL 就必须 >0      这里占两个字节
	也就是说，在FFC0后３个字节开始 ,　两个字节为图片高度 ,再两个字节为图片宽度
	- components 数量(1 byte), 灰度图是 1, YCbCr/YIQ 彩色图是 3, CMYK 彩色图是 4
	- 每个 component: 3 bytes
	- component id (1 = Y, 2 = Cb, 3 = Cr, 4 = I, 5 = Q)
	- 采样系数 (bit 0-3 vert., 4-7 hor.)
	- quantization table 号
	*/
	/*
	*/
	public class SOF0
	{
		public var baseline:int=0;
		public var width:int=0;
		public var height:int=0;
		public function SOF0()
		{
		}
		
		public function read(input:IDataInput):void{
			baseline = input.readUnsignedByte();
			this.height = input.readUnsignedShort();
			this.width = input.readUnsignedShort();
		}
	}
}