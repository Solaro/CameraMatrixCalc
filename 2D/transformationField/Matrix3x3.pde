class Matrix3x3{
	float[][] a = new float[3][3];

	Matrix3x3(){
		setIdentity();
	}

	void setIdentity(){
		a[0][0] = 1.0;	a[0][1] = 0.0;	a[0][2] = 0.0;
		a[1][0] = 0.0;	a[1][1] = 1.0;	a[1][2] = 0.0;
		a[2][0] = 0.0;	a[2][1] = 0.0;	a[2][2] = 1.0;
	}

	void setScale(float x, float y){
		setIdentity();
		a[0][0] = x;
		a[1][1] = y;
	}

	void setTranslate(float x, float y){
		setIdentity();
		a[0][2] = x;
		a[1][2] = y;
	}

	void setRotate(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][1] = sin(theta);
		a[1][0] = -sin(theta);	a[1][1] = cos(theta);	
	}

	// --- MATRIX CALCULATION ---
	// result.x 	a[0][0] a[0][1] a[0][2] a[0][3] 	input.x
	// result.y  =	a[1][0] a[1][1] a[1][2] a[1][3]  *	input.y
	// result.w   	a[2][0] a[2][1] a[2][2] a[2][3]  	input.w

	Vector3f mult(Vector3f p){
		Vector3f result = new Vector3f();
		result.x = a[0][0]*p.x + a[0][1]*p.y + a[0][2]*p.w;
		result.y = a[1][0]*p.x + a[1][1]*p.y + a[1][2]*p.w;
		result.w = a[2][0]*p.x + a[2][1]*p.y + a[2][2]*p.w;
		return result;
	}

	Matrix3x3 mult(Matrix3x3 m){
		Matrix3x3 result = new Matrix3x3();
		for(int row = 0; row < 3; row++){
			for(int col = 0; col < 3; col++){
				result.a[row][col] = a[row][0]*m.a[0][col]
									+a[row][1]*m.a[1][col]
									+a[row][2]*m.a[2][col];
			}
		}
		return result;
	}
	String toString() {
        return String.format("%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f",
        a[0][0],a[0][1],a[0][2],a[1][0],a[1][1],a[1][2],a[2][0],a[2][1],a[2][2]);
    }
};