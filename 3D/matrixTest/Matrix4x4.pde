class Matrix4x4{
	float[][] a = new float[4][4];

	Matrix4x4(){
		setIdentity();
	}

	void setIdentity(){
		a[0][0] = 1.0;	a[0][1] = 0.0;	a[0][2] = 0.0;	a[0][3] = 0.0;
		a[1][0] = 0.0;	a[1][1] = 1.0;	a[1][2] = 0.0;	a[1][3] = 0.0;
		a[2][0] = 0.0;	a[2][1] = 0.0;	a[2][2] = 1.0;	a[2][3] = 0.0;
		a[3][0] = 0.0;	a[3][1] = 0.0;	a[3][2] = 0.0;	a[3][3] = 1.0;	
	}

	void setScale(float x, float y, float z){
		setIdentity();
		a[0][0] = x;
		a[1][1] = y;
		a[2][2] = z;
	}

	void setTranslate(float x, float y, float z){
		setIdentity();
		a[0][3] = x;
		a[1][3] = y;
		a[2][3] = z;
	}

	void setRotateX(float theta){
		setIdentity();
		a[1][1] = cos(theta);	a[1][2] =  sin(theta);
		a[2][1] = -sin(theta);	a[2][2] =  cos(theta);	
	}
	void setRotateY(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][2] = -sin(theta);
		a[2][0] = sin(theta);	a[2][2] =  cos(theta);	
	}
	void setRotateZ(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][1] =  sin(theta);
		a[1][0] = -sin(theta);	a[1][1] =  cos(theta);	
	}

	// --- MATRIX CALCULATION ---
	// result.x 	a[0][0] a[0][1] a[0][2] a[0][3] 	input.x
	// result.y 	a[1][0] a[1][1] a[1][2] a[1][3] 	input.y
	// result.z  = 	a[2][0] a[2][1] a[2][2] a[2][3]  * 	input.z
	// result.w 	a[3][0] a[3][1] a[3][2] a[3][3]		input.w


	Vector4f mult(Vector4f p){
		Vector4f result = new Vector4f();
		result.x = a[0][0]*p.x + a[0][1]*p.y + a[0][2]*p.z + a[0][3]*p.w;
		result.y = a[1][0]*p.x + a[1][1]*p.y + a[1][2]*p.z + a[1][3]*p.w;
		result.z = a[2][0]*p.x + a[2][1]*p.y + a[2][2]*p.z + a[2][3]*p.w;
		result.w = p.w;
		return result;
	}

	Matrix4x4 mult(Matrix4x4 m){
		Matrix4x4 result = new Matrix4x4();
		for(int row = 0; row < 4; row++){
			for(int col = 0; col < 4; col++){
				result.a[row][col] = a[row][0]*m.a[0][col]
									+a[row][1]*m.a[1][col]
									+a[row][2]*m.a[2][col]
									+a[row][3]*m.a[3][col];
			}
		}
		return result;
	}

	String toString() {
        return String.format("%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f",
        a[0][0],a[0][1],a[0][2],a[0][3],a[1][0],a[1][1],a[1][2],a[1][3],a[2][0],a[2][1],a[2][2],a[2][3],a[3][0],a[3][1],a[3][2],a[3][3]);
    }
};