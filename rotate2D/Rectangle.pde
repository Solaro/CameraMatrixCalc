class Rectangle{
	Vector4f center;
	Vector4f p1, p2, p3, p4; // Position of original(=local) apex
	Vector4f v1, v2, v3, v4; // operated vertex for visualize
	Rectangle(){
		center 	= new Vector4f( 0.0,  0.0);
		v1 = p1 = new Vector4f( 100,  100);	
		v2 = p2 = new Vector4f(-100,  100);
		v3 = p3 = new Vector4f(-100, -100);
		v4 = p4 = new Vector4f( 100, -100);
	}
	Rectangle(float x, float y, float w, float h){
		center 	= new Vector4f(	  x,   y);
		v1 = p1 = new Vector4f( x+w, y+h);
		v2 = p2 = new Vector4f( x-w, y+h);
		v3 = p3 = new Vector4f( x-w, y-h);
		v4 = p4 = new Vector4f( x+w, y-h);
	}

	void translate(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(x, y, z);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	void rotateZ_translate(float theta, float x, float y, float z){
		Matrix4x4 rot = new Matrix4x4();
		rot.setRotateZ(theta);
		println("[rotateZ]");
		println(rot);
		Matrix4x4 trans = new Matrix4x4();
		trans.setTranslate(x, y, z);
		println("[translate]");
		println(trans);

		Matrix4x4 mat = trans.mult(rot);
		println("[rotateZ_translate]");
		println(mat);
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