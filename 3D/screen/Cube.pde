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
	Vector4f[] local; // Position of local(=local) apex
	Vector4f[] world; // world 
	Vector4f[] cameraView;
	Vector4f[] projection;
	Vector4f[] screen_pos;
	Cube(){
		new Cube(1.0);
	}
	Cube(float s){
		local = new Vector4f[8];
		world = new Vector4f[8];
		cameraView = new Vector4f[8];
		projection = new Vector4f[8];
		screen_pos = new Vector4f[8];

		local[0] = new Vector4f( s,  s,  s);	
		local[1] = new Vector4f( s, -s,  s);
		local[2] = new Vector4f(-s, -s,  s);
		local[3] = new Vector4f(-s,  s,  s);
		local[4] = new Vector4f( s,  s, -s);	
		local[5] = new Vector4f( s, -s, -s);
		local[6] = new Vector4f(-s, -s, -s);
		local[7] = new Vector4f(-s,  s, -s);
		for(int i = 0; i < 8; i++){
			world[i] = local[i];
		}
	}

	void resetTransform(){
		for(int i = 0; i < 8; i++){
			world[i] = local[i];
		}
	}

	void scale(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(x, y, z);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}

	void translate(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(x, y, z);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}


	void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}
	void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}

	void viewTranslation(Matrix4x4 view){
		for(int i = 0; i < 8; i++){
			cameraView[i] = view.mult(world[i]);
		}
	}

	void applyProjection(Matrix4x4 proj){
		for(int i = 0; i < 8; i++){
			projection[i] = proj.mult(cameraView[i]);
			float w = projection[i].w;
			projection[i].div(w); // reset w to 1.0
		}

		// Vector4f near = new Vector4f(10.0, 0.0, 50.0, 1.0);
		// Vector4f mid  = new Vector4f(20.0, 0.0, 100.0, 1.0);
		// Vector4f far  = new Vector4f(0.0, 20.0, 150.0, 1.0);
		// near = proj.mult(near);
		// mid  = proj.mult(mid);
		// far  = proj.mult(far);
		// near.div(near.w);
		// mid.div(mid.w);
		// far.div(far.w);
		// println("Near >> "+near);
		// println("Mid  >> "+mid);
		// println("Far  >> "+far);
		// println("");
	}

	void applyScreenMatrix(Matrix4x4 mat){
		for(int i = 0; i < 8; i++){
			screen_pos[i] = mat.mult(projection[i]);
		}
	}

	void drawLocal(){
		drawLocalQuad(0, 1, 2, 3);
		drawLocalQuad(0, 4, 5, 1);
		drawLocalQuad(1, 5, 6, 2);
		drawLocalQuad(2, 6, 7, 3);
		drawLocalQuad(3, 7, 4, 0);
		drawLocalQuad(7, 6, 5, 4);
	}

	void drawWorld(){
		drawWorldQuad(0, 1, 2, 3);
		drawWorldQuad(0, 4, 5, 1);
		drawWorldQuad(1, 5, 6, 2);
		drawWorldQuad(2, 6, 7, 3);
		drawWorldQuad(3, 7, 4, 0);
		drawWorldQuad(7, 6, 5, 4);
	}

	void drawCameraView(){
		drawCameraViewQuad(0, 1, 2, 3);
		drawCameraViewQuad(0, 4, 5, 1);
		drawCameraViewQuad(1, 5, 6, 2);
		drawCameraViewQuad(2, 6, 7, 3);
		drawCameraViewQuad(3, 7, 4, 0);
		drawCameraViewQuad(7, 6, 5, 4);
	}
	void drawProjection(){
		drawProjectionQuad(0, 1, 2, 3);
		drawProjectionQuad(0, 4, 5, 1);
		drawProjectionQuad(1, 5, 6, 2);
		drawProjectionQuad(2, 6, 7, 3);
		drawProjectionQuad(3, 7, 4, 0);
		drawProjectionQuad(7, 6, 5, 4);
		strokeWeight(0.5);
		Cube area = new Cube(10.0);
		area.scale(1, 1, 0.5);
		area.translate(0, 0, 5.0);
		area.drawWorld();
	}
	void drawScreen(){
		drawScreenQuad(0, 1, 2, 3);
		drawScreenQuad(0, 4, 5, 1);
		drawScreenQuad(1, 5, 6, 2);
		drawScreenQuad(2, 6, 7, 3);
		drawScreenQuad(3, 7, 4, 0);
		drawScreenQuad(7, 6, 5, 4);
	}


	void drawLocalQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(local[i0].x, local[i0].y, local[i0].z);
		vertex(local[i1].x, local[i1].y, local[i1].z);
		vertex(local[i2].x, local[i2].y, local[i2].z);
		vertex(local[i3].x, local[i3].y, local[i3].z);
		endShape(CLOSE);
	}
	void drawWorldQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(world[i0].x, world[i0].y, world[i0].z);
		vertex(world[i1].x, world[i1].y, world[i1].z);
		vertex(world[i2].x, world[i2].y, world[i2].z);
		vertex(world[i3].x, world[i3].y, world[i3].z);
		endShape(CLOSE);
	}
	void drawCameraViewQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(cameraView[i0].x, cameraView[i0].y, cameraView[i0].z);
		vertex(cameraView[i1].x, cameraView[i1].y, cameraView[i1].z);
		vertex(cameraView[i2].x, cameraView[i2].y, cameraView[i2].z);
		vertex(cameraView[i3].x, cameraView[i3].y, cameraView[i3].z);
		endShape(CLOSE);
	}
	void drawProjectionQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(10*projection[i0].x, 10*projection[i0].y, 10*projection[i0].z);
		vertex(10*projection[i1].x, 10*projection[i1].y, 10*projection[i1].z);
		vertex(10*projection[i2].x, 10*projection[i2].y, 10*projection[i2].z);
		vertex(10*projection[i3].x, 10*projection[i3].y, 10*projection[i3].z);
		endShape(CLOSE);
	}
	void drawScreenQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(screen_pos[i0].x, screen_pos[i0].y, screen_pos[i0].z);
		vertex(screen_pos[i1].x, screen_pos[i1].y, screen_pos[i1].z);
		vertex(screen_pos[i2].x, screen_pos[i2].y, screen_pos[i2].z);
		vertex(screen_pos[i3].x, screen_pos[i3].y, screen_pos[i3].z);
		endShape(CLOSE);
	}
};