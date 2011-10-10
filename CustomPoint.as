package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Raphael Luchini
	 */
	public class CustomPoint extends Point
	{
		public var z:Number = 0;
		public var size:Number = 0;
		
		public function CustomPoint(x:Number, y:Number,z:Number = 0, size:Number = 0) 
		{
			super(x, y);
			this.z = z;
			this.size = size;
		}
		
	}

}