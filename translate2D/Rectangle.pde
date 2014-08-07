class Rectangle{
	Vector4f p1, p2, p3, p4; // Position of original(=local) apex
	Vector4f v1, v2, v3, v4; // operated vertex for visualize
	Matrix4x4 mat;
	Rectangle(){
		p1 = new Vector4f(   0,   0);	
		p2 = new Vector4f( 100,   0);
		p3 = new Vector4f( 100, 100);
		p4 = new Vector4f(   0, 100);
		mat = new Matrix4x4();
	}
	Rectangle(float x, float y, float w, float h){
		p1 = new Vector4f(   x,   y);
		p2 = new Vector4f( x+w,   y);
		p3 = new Vector4f( x+w, y+h);
		p4 = new Vector4f(   x, y+h);
		mat = new Matrix4x4();
	}

	void translate(float x, float y, float z){
		mat.translate(x, y, z);
	}

	void applyMatrix(){
		v1 = mat.mult(p1);
		v2 = mat.mult(p2);
		v3 = mat.mult(p3);
		v4 = mat.mult(p4);

		println("original >> ");
		println("p1 = " + p1);
		println("p2 = " + p2);
		println("p3 = " + p3);
		println("p4 = " + p4);
		println("operated >> ");
		println("v1 = " + v1);
		println("v2 = " + v2);
		println("v3 = " + v3);
		println("v4 = " + v4);
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