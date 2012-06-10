package fox.photo.jpeg
{
	import fox.photo.exif.UsefulExif;
	import fox.photo.exif.ifd.IFDValue;

	public class Exif
	{
		public var tags:Array = [];
		public var userful:UsefulExif=new UsefulExif();
		
		public function Exif()
		{
		}
		
		public function initUseFul():void
		{
			//拍照日期
			var tag:IFDValue = this.findTagById(36867);
			if(tag){
				var t:String = ""+tag.value;
				t = t.replace(":",'-').replace(":",'-');
				userful.date =  DateFormatter.parseDateString(t);
			}else if((tag=this.findTagById(36868))!=null){
				var tt:String = ""+tag.value;
				tt = tt.replace(":",'-').replace(":",'-');
				userful.date =  DateFormatter.parseDateString(tt);
			}else if((tag=this.findTagById(306))!=null){
				var t2:String = ""+tag.value;
				t2 = t2.replace(":",'-').replace(":",'-');
				userful.date =  DateFormatter.parseDateString(t2);
			}
			//高度
			tag = this.findTagById(40963);
			if(tag){
				userful.height = int(tag.value);
			}
			//宽度
			tag = this.findTagById(40962);
			if(tag){
				userful.width = int(tag.value);
			}
			//Orientation  274 图片方向
			tag = this.findTagById(274);
			if(tag){
				userful.orientation = int(tag.value);
			}
			//Model 272  设备制造商
			tag = this.findTagById(272);
			if(tag){
				userful.model = ""+(tag.value);
			}
			//Make 271  使用设备
			tag = this.findTagById(271);
			if(tag){
				userful.make = ""+(tag.value);
			}
		}
		
		public function findTagById(id:uint):IFDValue{
			for each (var i:IFDValue in tags) 
			{
				if(i.tag==id){
					return i;
				}
			}
			return null;
		}
	}
}