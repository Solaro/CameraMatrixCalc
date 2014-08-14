class Vector3f{
	// if Vector3f is position, w = 1.0;
	// if Vector3f is vector,   w = 0.0;
	// position can't add to position.
	float x, y, w; 

	Vector3f(){
		x = 0.0;
		y = 0.0;
		w = 1.0;
	}
	Vector3f(float _x, float _y){
		x = _x;
		y = _y;
		w = 1.0;
	}
	Vector3f(float _x, float _y, float _w){
		x = _x;
		y = _y;
		w = _w;
	}

	float[] array(){
		float[] a = new float[3];
		a[0] = x;
		a[1] = y;
		a[2] = w;
		return a;
	}
	String toString() {
        return String.format("[%.2f, %.2f, %.2f]", x, y, w);
    }
};