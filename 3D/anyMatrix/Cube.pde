//
//           p3----------p0   (y+)
//          /|          /|    /
//         / |         / |   /
//       p2--+--------p1 | (y-)
//  (z+)  |  |        |  |
//   |    |  p7-------+--p4
//   |    | /         | /
//  (z-)  |/          |/
//       p6-----------p5
//
//         (x-)--(x+)
//
// --------------------- DRAWING CUBE CLOCKWISE ---------------------
// drawQuad(0, 1, 2, 3);
// drawQuad(0, 4, 5, 1);
// drawQuad(1, 5, 6, 2);
// drawQuad(2, 6, 7, 3);
// drawQuad(3, 7, 4, 0);
// drawQuad(7, 6, 5, 4);
// ------------------------------------------------------------------
//
class Cube{
	Vector4f[] original; // Position of original(=local) apex
	Vector4f[] transformed; // operated vertex for visualize
	Cube(){
		new Cube(1.0);
	}
	Cube(float s){
		original = new Vector4f[8];
		transformed = new Vector4f[8];
		original[0] = new Vector4f( s,  s,  s);	
		original[1] = new Vector4f( s, -s,  s);
		original[2] = new Vector4f(-s, -s,  s);
		original[3] = new Vector4f(-s,  s,  s);
		original[4] = new Vector4f( s,  s, -s);	
		original[5] = new Vector4f( s, -s, -s);
		original[6] = new Vector4f(-s, -s, -s);
		original[7] = new Vector4f(-s,  s, -s);
		for(int i = 0; i < 8; i++){
			transformed[i] = original[i];
		}
	}

	void resetTransform(){
		for(int i = 0; i < 8; i++){
			transformed[i] = original[i];
		}
	}

	void scale(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(x, y, z);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}

	void translate(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(x, y, z);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}


	void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}
	void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}

	void applyMatrix(Matrix4x4 mat){
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}

	void drawOriginal(){
		drawOriginalQuad(0, 1, 2, 3);
		drawOriginalQuad(0, 4, 5, 1);
		drawOriginalQuad(1, 5, 6, 2);
		drawOriginalQuad(2, 6, 7, 3);
		drawOriginalQuad(3, 7, 4, 0);
		drawOriginalQuad(7, 6, 5, 4);
	}

	void drawTransformed(){
		drawTransformedQuad(0, 1, 2, 3);
		drawTransformedQuad(0, 4, 5, 1);
		drawTransformedQuad(1, 5, 6, 2);
		drawTransformedQuad(2, 6, 7, 3);
		drawTransformedQuad(3, 7, 4, 0);
		drawTransformedQuad(7, 6, 5, 4);
	}

	void drawOriginalQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(original[i0].x, original[i0].y, original[i0].z);
		vertex(original[i1].x, original[i1].y, original[i1].z);
		vertex(original[i2].x, original[i2].y, original[i2].z);
		vertex(original[i3].x, original[i3].y, original[i3].z);
		endShape(CLOSE);
	}
	void drawTransformedQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(transformed[i0].x, transformed[i0].y, transformed[i0].z);
		vertex(transformed[i1].x, transformed[i1].y, transformed[i1].z);
		vertex(transformed[i2].x, transformed[i2].y, transformed[i2].z);
		vertex(transformed[i3].x, transformed[i3].y, transformed[i3].z);
		endShape(CLOSE);
	}
};