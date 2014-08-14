class Vector4f{
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

	String toString() {
        return String.format("[%.2f, %.2f, %.2f, %.2f]", x, y, z, w);
    }
};