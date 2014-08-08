class VectorField{
	Vector3f[][] original;
	Vector3f[][] transformed;
	int xNum, yNum;
	VectorField(){
		xNum = 10;
		yNum = 10;
		original = new Vector3f[xNum][yNum];
		transformed = new Vector3f[xNum][yNum];
		float x_spacer = width/xNum;
		float y_spacer = height/yNum;

		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				original[x][y] = new Vector3f(x*x_spacer, y*y_spacer);
				transformed[x][y] = original[x][y];
			}
		}
	}

	VectorField(int x_num, int y_num){
		xNum = x_num;
		yNum = y_num;
		original = new Vector3f[xNum][yNum];
		transformed = new Vector3f[xNum][yNum];
		float x_spacer = (float)2*width/xNum;
		float y_spacer = (float)2*height/yNum;

		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				original[x][y] = new Vector3f(x*x_spacer-width, y*y_spacer-height);
				transformed[x][y] = original[x][y];
			}
		}
	}
	void resetTransform(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = original[x][y];
			}
		}
	}

	void scale(float _x, float _y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setScale(_x, _y);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	void translate(float _x, float _y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setTranslate(_x, _y);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	void rotate(float theta){
		Matrix3x3 mat = new Matrix3x3();
		mat.setRotate(theta);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	void rotate_translate(float theta, float _x, float _y){
		Matrix3x3 rot = new Matrix3x3();
		rot.setRotate(theta);
		println("\n[rotate]");
		println(rot);
		Matrix3x3 trans = new Matrix3x3();
		trans.setTranslate(_x, _y);
		println("\n[translate]");
		println(trans);

		Matrix3x3 mat = trans.mult(rot);
		println("\n[rotate_translate]");
		println(mat);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	void drawOriginalPositions(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				Vector3f pos = original[x][y];
				ellipse(pos.x, pos.y, 2, 2);
			}
		}
	}

	void drawField(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				Vector3f p1 = original[x][y];
				Vector3f p2 = transformed[x][y];
				line(p1.x, p1.y, p2.x, p2.y);
			}
		}
	}
};