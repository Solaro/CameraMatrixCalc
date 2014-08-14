class Rectangle{
	Vector3f center;
	Vector3f p1, p2, p3, p4; // Position of original(=local) apex
	Vector3f v1, v2, v3, v4; // operated vertex for visualize
	Rectangle(){
		center 	= new Vector3f( 0.0,  0.0);
		v1 = p1 = new Vector3f( 100,  100);	
		v2 = p2 = new Vector3f(-100,  100);
		v3 = p3 = new Vector3f(-100, -100);
		v4 = p4 = new Vector3f( 100, -100);
	}
	Rectangle(float x, float y, float w, float h){
		center 	= new Vector3f(	  x,   y);
		v1 = p1 = new Vector3f( x+w, y+h);
		v2 = p2 = new Vector3f( x-w, y+h);
		v3 = p3 = new Vector3f( x-w, y-h);
		v4 = p4 = new Vector3f( x+w, y-h);
	}

	void resetTransform(){
		v1 = p1;
		v2 = p2;
		v3 = p3;
		v4 = p4;
	}

	void scale(float x, float y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setScale(x, y);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
		// println("\n[scale]");
		// println(mat);
	}

	void translate(float x, float y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setTranslate(x, y);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	void rotate(float theta){
		Matrix3x3 mat = new Matrix3x3();
		mat.setRotate(theta);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	void applyMatrix(Matrix3x3 mat){
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	void drawOriginal(){
		beginShape();
		vertex(p1.array());
		vertex(p2.array());
		vertex(p3.array());
		vertex(p4.array());
		endShape(CLOSE);
	}

	void drawOperated(){
		beginShape();
		vertex(v1.array());
		vertex(v2.array());
		vertex(v3.array());
		vertex(v4.array());
		endShape(CLOSE);
	}
};