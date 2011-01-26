package aerys.minko.type.triangle
{
	import aerys.common.Factory;
	import aerys.minko.ns.minko;
	import aerys.minko.type.math.Plane3D;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.stream.IndexStream3D;
	import aerys.minko.type.stream.VertexStream3D;
	import aerys.minko.type.vertex.Vertex3DReference;
	
	import flash.geom.Vector3D;

	public class Triangle3DReference
	{
		use namespace minko;
		
		private static const VECTOR4				: Factory	= Factory.getFactory(Vector4);
		
		private static const UPDATE_NONE			: uint		= 0;
		private static const UPDATE_NORMAL			: uint		= 1;
		private static const UPDATE_PLANE			: uint		= 2;
		private static const UPDATE_CENTER			: uint		= 4;
		
		minko static const UPDATE_ALL				: uint		= UPDATE_NORMAL | UPDATE_PLANE
															  	  | UPDATE_CENTER;

		minko var _index	: int				= 0;
		minko var _update	: uint				= UPDATE_ALL;

		private var _ib		: IndexStream3D		= null;
		
		private var _v0		: Vertex3DReference	= null;
		private var _v1		: Vertex3DReference	= null;
		private var _v2		: Vertex3DReference	= null;
		
		private var _i0		: int				= 0;
		private var _i1		: int				= 0;
		private var _i2		: int				= 0;
		
		private var _v0v	: uint				= 0;
		private var _v1v	: uint				= 0;
		private var _v2v	: uint				= 0;
		
		private var _normal	: Vector4			= null;
		private var _plane	: Plane3D			= null;
		private var _center	: Vector4			= null;
		
		public function get index()	: int				{ return _index; }
		
		public function get v0()	: Vertex3DReference	{ return _v0; }
		public function get v1() 	: Vertex3DReference	{ return _v1; }
		public function get v2() 	: Vertex3DReference	{ return _v2; }
		
		public function get i0() 	: int				{ return _ib._indices[int(_index * 3)]; }
		public function get i1() 	: int				{ return _ib._indices[int(_index * 3 + 1)]; }
		public function get i2() 	: int				{ return _ib._indices[int(_index * 3 + 2)]; }
		
		private function get updateNormal() : Boolean	{ return (_update & UPDATE_NORMAL) || _v0.version != _v0v
																 || _v1.version != _v1v || _v2.version != _v2v; }
		
		private function get updatePlane() : Boolean	{ return (_update & UPDATE_PLANE) || _v0.version != _v0v
																 || _v1.version != _v1v || _v2.version != _v2v; }
		
		private function get updateCenter() : Boolean	{ return (_update & UPDATE_CENTER) || _v0.version != _v0v
																 || _v1.version != _v1v || _v2.version != _v2v; }
		
		private function get verticesHaveChanged() : Boolean { return _v0.version != _v0v || _v1.version != _v1v
																	  || _v2.version != _v2v; }
		
		public function get plane() : Plane3D
		{
			if (updatePlane)
				invalidatePlane();
			
			return _plane;
		}
		
		public function get normalX() : Number
		{
			if (updateNormal)
				invalidateNormal();
			
			return _normal.x;
		}
		
		public function get normalY() : Number
		{
			if (updateNormal)
				invalidateNormal();
			
			return _normal.y;
		}
		
		public function get normalZ() : Number
		{
			if (updateNormal)
				invalidateNormal();
			
			return _normal.z;
		}
		
		public function get centerX() : Number
		{
			if (updateCenter)
				invalidateCenter();
			
			return _center.x;
		}
		
		public function get centerY() : Number
		{
			if (updateCenter)
				invalidateCenter();
			
			return _center.y;
		}
		
		public function get centerZ() : Number
		{
			if (updateCenter)
				invalidateCenter();
			
			return _center.z;
		}
		
		public function set i0(value : int) : void
		{
			_ib._indices[int(_index * 3)] = value;
			_ib._update = true;
			_ib._version++;
			_v0._index = value;
			_update |= UPDATE_ALL;
		}
		
		public function set i1(value : int) : void
		{
			_ib._indices[int(_index * 3 + 1)] = value;
			_ib._update = true;
			_ib._version++;
			_v1._index = value;
			_update |= UPDATE_ALL;
		}
		
		public function set i2(value : int) : void
		{
			_ib._indices[int(_index * 3 + 2)] = value;
			_ib._update = true;
			_ib._version++;
			_v2._index = value;
			_update |= UPDATE_ALL;
		}
		
		public function Triangle3DReference(vertexBuffer 	: VertexStream3D,
											indexBuffer		: IndexStream3D,
											index 			: int)
		{
			_ib = indexBuffer;
			
			_index = index;
			
			_v0 = new Vertex3DReference(vertexBuffer,
										indexBuffer._indices[int(_index * 3)]);
			_v1 = new Vertex3DReference(vertexBuffer,
										indexBuffer._indices[int(_index * 3 + 1)]);
			_v2 = new Vertex3DReference(vertexBuffer,
										indexBuffer._indices[int(_index * 3 + 2)]);			
		}
		
		private function invalidateNormal() : void
		{
			if (!_normal)
				_normal = new Vector4();
			
			var x0 : Number = _v0.x;
			var y0 : Number = _v0.y;
			var z0 : Number = _v0.z;
			var x1 : Number = _v1.x;
			var y1 : Number = _v1.y;
			var z1 : Number = _v1.z;
			var x2 : Number = _v2.x;
			var y2 : Number = _v2.y;
			var z2 : Number = _v2.z;
			
			_normal.x = (y0 - y2) * (z0 - z1) - (z0 - z2) * (y0 - y1);
			_normal.y = (z0 - z2) * (x0 - x1) - (x0 - x2) * (z0 - z1);
			_normal.z = (x0 - x2) * (y0 - y1) - (y0 - y2) * (x0 - x1);
			
			_normal.normalize();
			
			_update ^= UPDATE_NORMAL;
			_v0v = _v0.version;
			_v1v = _v1.version;
			_v2v = _v2.version;
		}
		
		public function getNormal(out : Vector4) : Vector4
		{
			return Vector4.copy(_normal, out);
		}
		
		public function getCenter(out : Vector4) : Vector4
		{
			return Vector4.copy(_center, out);
		}
		
		private function invalidatePlane() : void
		{
			if (updateNormal)
			{
				invalidateNormal();
			}
			else
			{
				_v0v = _v0.version;
				_v1v = _v1.version;
				_v2v = _v2.version;
			}
			
			if (!_plane)
				_plane = new Plane3D();
			
			var nx : Number = _normal.x;
			var ny : Number = _normal.y;
			var nz : Number = _normal.z;
			
			_plane._a = nx;
			_plane._b = ny;
			_plane._c = nz;
			_plane._d = _v0.x * nx + _v0.y * ny + _v0.z * nz;
			
			_plane.normalize();
			
			_update ^= UPDATE_PLANE;
		}
		
		private function invalidateCenter() : void
		{
			if (verticesHaveChanged)
			{
				_update = UPDATE_ALL ^ UPDATE_CENTER;
				_v0v = _v0.version;
				_v1v = _v1.version;
				_v2v = _v2.version;
			}
			
			_center.x = (_v0.x + _v1.x + _v2.x) * .33333333;
			_center.y = (_v0.y + _v1.y + _v2.y) * .33333333;
			_center.z = (_v0.z + _v1.z + _v2.z) * .33333333;
		}
		
		public function invertWinding() : void
		{
			_update = UPDATE_ALL;
			
			var tmp : int = _i0;
			
			_v0._index = _i0 = _i1;
			_v1._index = tmp;
			
			i0 = _i1;
			i1 = tmp;
		}
	}
}