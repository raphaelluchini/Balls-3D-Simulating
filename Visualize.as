package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Raphael Luchini
	 */
	public class Visualize extends MovieClip
	{
		public var WIDTH:Number = 1000;
		public var HEIGHT:Number = 600;
		
		public static const DISPLAY_PIPE:String = 'pipe';
		public static const DISPLAY_CONE:String = 'cone';
		public static const DISPLAY_CIRCLE:String = 'circle';
		public static const DISPLAY_SPIRAL:String = 'spiral';
		public static const DISPLAY_SWIRL:String = 'swirl';
		
		public var indexDisplay:int = 0;
		public var arrDisplayMode:Array = [DISPLAY_PIPE, DISPLAY_CONE, DISPLAY_CIRCLE, DISPLAY_SPIRAL, DISPLAY_SWIRL];
		public var points:Array = [];
		public var arrBalls:Array = [];
		
		public static const POINTSLENGTH:int = 300;
		public static const RADIUS:Number = 200;
		public static const SCENE_DEPTH = -10;
		public var SCENE_VP:Point = new Point(WIDTH * .5, HEIGHT * .5);
		public var SCENE_VPSO:Point = new Point(1, 1);
		
		public var displayMode:String = DISPLAY_PIPE;	
		
		public function Visualize() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			
			createPoints();
			
			setDisplayMode(arrDisplayMode[indexDisplay]);
			
			this.addEventListener(Event.ENTER_FRAME, Step);
		}
		
		private function createPoints():void
		{
			var ball:Sprite;
			for ( var i:int = 0; i < POINTSLENGTH; i++ )
			{
				points.push(new CustomPoint(0, 0, 0, i / POINTSLENGTH * 4));
				ball = new Sprite();
				ball.graphics.beginFill(0xFFFFFF);
				ball.graphics.drawCircle(0, 0, 2);
				ball.graphics.endFill();
				addChild(ball);
				arrBalls.push(ball);
			}
			ball = null;
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			indexDisplay ++
			if (indexDisplay == arrDisplayMode.length)
			{
				indexDisplay = 0
			}
			setDisplayMode(arrDisplayMode[indexDisplay]);
		}
		
		private function setDisplayMode(mode:String):void
		{
			displayMode = mode;
			
			var x:Number = (WIDTH * .5) - RADIUS;
			var y:Number = (HEIGHT * .5) - RADIUS;
			var z:Number = 10;
			
			var len:int = points.length;
			
			for ( var i:int = 0; i < len; i++ )
			{
				z = (i / len) * 5;
				
				switch( displayMode )
				{
					case DISPLAY_CIRCLE:
					{
						x = (WIDTH * .5) + Math.cos( (i / len) * Math.PI * 2 ) * RADIUS;
						y = (HEIGHT * .5) + Math.sin( (i / len) * Math.PI * 2 ) * RADIUS;
						break;
					}
					case DISPLAY_PIPE:
					{
						x = (WIDTH * .5) + Math.cos( (i / (len * .5)) * RADIUS ) * RADIUS/2;
						y = (HEIGHT * .5) + Math.sin( (i / (len * .5)) * RADIUS ) * RADIUS/2;
						z = Math.cos( (i / (len * .5) ) ) * 5;
						break;
					}
					case DISPLAY_CONE:
					{
						x = (WIDTH * .5) + Math.cos( (i / (len * .1)) * RADIUS ) * ((len - (i * .6)) / len) * RADIUS;
						y = (HEIGHT * .5) + Math.sin( (i / (len * .1)) * RADIUS ) * ((len - (i * .6)) / len) * RADIUS;
						break;
					}
					case DISPLAY_SPIRAL:
					{
						x = (WIDTH * .5) + Math.cos( (i / (len * .3)) * Math.PI * 2 ) * (RADIUS * (i / len));
						y = (HEIGHT * .5) + Math.sin( (i / (len * .3)) * Math.PI * 2 ) * (RADIUS * (i / len));
						break;
					}
					case DISPLAY_SWIRL:
					{
						x = (WIDTH * .5) + Math.cos( (i / (len * .1)) * Math.PI * 2 ) * (RADIUS * (i / len));
						y = (HEIGHT * .5) + Math.sin( (i / (len * .1)) * Math.PI * 2 ) * (RADIUS * (i / len));
						break;
					}
					default:
					{
						x += 20;
						if ( x > (WIDTH * .5) + RADIUS )
						{
							x = (WIDTH * .5) - RADIUS;
							y += 20;
						}
					}
				}
				points[i].x = x;
				points[i].y = y;
				points[i].z = z;
			}
		}
		
		public function Step(event:Event):void
		{		
			var vpox:Number = ( this.mouseX - WIDTH * .5 ) * 1.2;
			var vpoy:Number = ( this.mouseY - HEIGHT * .5 ) * 1.2;
			
			SCENE_VP.x = (WIDTH * .5) + vpox;
			SCENE_VP.y = (HEIGHT * .5) + vpoy;
			Render();
		}
		
		public function Render():void
		{
			if ( points )
			{
				for (var i:int = 0; i <  points.length; i++)
				{	
					var instructions:CustomPoint = points[i];
					
					var particle:Object = { };
					
					particle.x = instructions.x + ( instructions.x - SCENE_VP.x  ) * ( ( instructions.z / SCENE_DEPTH ) / SCENE_VPSO.x );
					particle.y = instructions.y + ( instructions.y - SCENE_VP.y ) * ( ( instructions.z / SCENE_DEPTH ) / SCENE_VPSO.y );
					
					particle.scale = ( instructions.z / SCENE_DEPTH ) + 1;
					particle.size = instructions.size * particle.scale;
					
					arrBalls[i].x = particle.x;
					arrBalls[i].y = particle.y;
					arrBalls[i].scaleX = arrBalls[i].scaleY = particle.size;
				}
			}
		}
	}
}