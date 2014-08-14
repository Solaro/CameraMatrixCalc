static class Vector4f{
	// if Vector4f is position, w = 1.0;
	// if Vector4f is vector,   w = 0.0;
	// position can't add to position.
	float x, y, z, w; 

	Vector4f(){
		x = 0.0;
		y = 0.0;
		z = 0.0;
		w = 1.0;
	}
	Vector4f(float _x, float _y){
		x = _x;
		y = _y;
		z = 0.0;
		w = 1.0;
	}
	Vector4f(float _x, float _y, float _z){
		x = _x;
		y = _y;
		z = _z;
		w = 1.0;
	}
	Vector4f(float _x, float _y, float _z, float _w){
		x = _x;
		y = _y;
		z = _z;
		w = _w;
	}
	Vector4f(Vector4f a){
		x = a.x;
		y = a.y;
		z = a.z;
		w = a.w;
	}

	float len(){
		// len() is always for vector, w = 0.0;
		return sqrt(pow(x, 2.0)+pow(y, 2.0)+pow(z, 2.0)+pow(w, 2.0));
	}

	void normalize(){
		float len = len();
		x /= len;
		y /= len;
		z /= len;
		w /= len; // normalize() is always for vector, w = 0.0;
	}

	static Vector4f sub(Vector4f a, Vector4f b){
		Vector4f result = new Vector4f();
		result.x = a.x - b.x;
		result.y = a.y - b.y;
		result.z = a.z - b.z;
		result.w = a.w - b.w;
		return result;
	}

	float dot(Vector4f a){
		return this.x*a.x + this.y*a.y + this.z*a.z + this.w+a.w;
	}

	static Vector4f cross(Vector4f a, Vector4f b){ // ignore w, return 3d cross product
		Vector4f result = new Vector4f();
		result.x = a.y*b.z - a.z*b.y;
		result.y = a.z*b.x - a.x*b.z;
		result.z = a.x*b.y - a.y*b.x;
		result.w = a.w * b.w;
		return result;	
	}

	String toString() {
        return String.format("[%.2f, %.2f, %.2f, %.2f]", x, y, z, w);
    }
};