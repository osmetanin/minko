package aerys.minko.scene.camera
{
	import aerys.common.Factory;
	import aerys.minko.query.IScene3DQuery;
	import aerys.minko.query.RenderingQuery;
	import aerys.minko.type.math.Vector4;
	
	import flash.geom.Matrix3D;
	
	public class ArcBallCamera3D extends AbstractCamera3D
	{
		private static const EPSILON		: Number	= .001;
		private static const MAX_ROTATION_X	: Number	= Math.PI / 2. - EPSILON;
		private static const MIN_ROTATION_X	: Number	= -MAX_ROTATION_X;
		
		private var _distance	: Number	= 1.;
		private var _rotation	: Vector4	= new Vector4();
		
		private var _rv			: uint		= 0;
		
		public function ArcBallCamera3D()
		{
			super();
		}
		
		//{ region getters/setters
		public function get distance() : Number { return _distance; }
		
		public function set distance(value : Number) : void
		{
			if (value != _distance)
			{
				_distance = value;
				invalidateView();
			}
		}
		
		public function get rotation() : Vector4
		{
			return _rotation;
		}
		//} endregion
		
		//{ region methods
		override protected function invalidateTransform(query : RenderingQuery = null) : void
		{
			if (_rotation.x >= MAX_ROTATION_X)
				_rotation.x = MAX_ROTATION_X;
			else if (_rotation.x <= MIN_ROTATION_X)
				_rotation.x = MIN_ROTATION_X;
				
			if (_distance <= 0.)
				_distance = EPSILON;

			position.x = lookAt.x - _distance * Math.sin(_rotation.y) * Math.cos(_rotation.x);
			position.y = lookAt.y - _distance * Math.sin(_rotation.x);
			position.z = lookAt.z - _distance * Math.cos(_rotation.y) * Math.cos(_rotation.x);
			
			super.invalidateTransform(query);
		}
		
		override public function accept(visitor : IScene3DQuery) : void
		{
			if (_rotation.version != _rv)
			{
				invalidateView();
				_rv = _rotation.version;
			}
			
			super.accept(visitor);
		}
		//} endregion
	}
}