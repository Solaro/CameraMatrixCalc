class VectorField{
	Vector4f[][][] original;
	Vector4f[][][] transformed;
	int xNum, yNum, zNum;
	VectorField(){
		new VectorField(10, 10, 10, 25);
	}

	VectorField(int x_num, int y_num, int z_num, float spacer){
		xNum = x_num;
		yNum = y_num;
		zNum = z_num;
		original = new Vector4f[xNum][yNum][zNum];
		transformed = new Vector4f[xNum][yNum][zNum];
		float minX = -spacer*(xNum/2);
		float minY = -spacer*(yNum/2);
		float minZ = -spacer*(zNum/2);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					original[x][y][z] = new Vector4f(minX+x*spacer, minY+y*spacer, minZ+z*spacer);
					transformed[x][y][z] = original[x][y][z];
				}
			}
		}
	}

	void resetTransform(){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = original[x][y][z];
				}
			}
		}
	}

	void scale(float _x, float _y, float _z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(_x, _y, _z);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}

	void translate(float _x, float _y, float _z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(_x, _y, _z);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}

	void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}
	void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}

	void applyMatrix(Matrix4x4 mat){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}

	void drawOriginalPositions(){
		beginShape(POINTS);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					Vector4f pos = original[x][y][z];
					vertex(pos.x, pos.y, pos.z);
				}
			}
		}
		endShape();
	}

	void drawField(){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					stroke(200*x/xNum,200*y/yNum,200*z/zNum);
					Vector4f p1 = original[x][y][z];
					Vector4f p2 = transformed[x][y][z];
					line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
				}
			}
		}
	}
};