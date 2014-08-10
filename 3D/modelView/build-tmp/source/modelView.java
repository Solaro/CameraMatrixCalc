import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class modelView extends PApplet {




PeasyCam cam;

Camera cameraa;

ControlP5 gui;
float sx, sy, sz; // scale of x,y,z
float rx, ry, rz; // rotation of x, y, z
float tx, ty, tz; // translation of x,y,z


Cube c1;
VectorField vf;

public void setup() {
	size(1200, 800, P3D);
  	cam = new PeasyCam(this, 400);
  	cam.setMinimumDistance(50);
  	cam.setMaximumDistance(800);
	
	c1 = new Cube(50);
	vf = new VectorField(5, 5, 5, 25);

	cameraa = new Camera();
	cameraa.setPosition(new Vector4f(300.0f, 200.0f, 100.0f));
	cameraa.setTarget(new Vector4f(0.0f, 0.0f, 0.0f));
	cameraa.viewTranslation();


	setupGUI();
}

public void draw() {
	background(255);

	transform();

	// DRAW AXIS
	// stroke(255, 0, 0);
	// line(-100, 0, 0, 100, 0, 0);
	// line(100, 0, 0, 90, 10, 10);
	// stroke(0, 255, 0);
	// line(0, -100, 0, 0, 100, 0);
	// line(0, 100, 0, 10, 90, 10);
	// stroke(0, 0, 255);
	// line(0, 0, -100, 0, 0, 100);
	// line(0, 0, 100, 10, 10, 90);


	// DRAW CUBE
	noFill();
	strokeWeight(0.5f);
	stroke(127, 0, 0);
	c1.drawLocal();
	stroke(255, 0, 0);
	strokeWeight(1.0f);
	c1.drawWorld();
	stroke(0);
	strokeWeight(2.0f);
	c1.drawCameraView();

	cameraa.draw();
	cameraa.drawTranslated();

	hint(DISABLE_DEPTH_TEST);
  	cam.beginHUD();
  	gui.draw();
  	cam.endHUD();
  	hint(ENABLE_DEPTH_TEST);
}

public void mousePressed(){
	if(gui.isMouseOver()){
  		cam.setMouseControlled(false);
  	}
}

public void mouseReleased(){
	cam.setMouseControlled(true);
}

public void transform(){
	c1.resetTransform();
	vf.resetTransform();

	c1.scale(sx, sy, sz);
	c1.rotateX(rx);
	c1.rotateY(ry);
	c1.rotateZ(rz);
	c1.translate(tx, ty, tz);
	vf.scale(sx, sy, sz);
	vf.rotateX(rx);
	vf.rotateY(ry);
	vf.rotateZ(rz);
	vf.translate(tx, ty, tz);

	c1.viewTranslation(cameraa.viewMatrix());
}

public void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("sx").setPosition(10, 10).setRange(0.5f, 1.5f).setSize(150, 12).setValue(1.0f).setColorCaptionLabel(100);
	gui.addSlider("sy").setPosition(10, 24).setRange(0.5f, 1.5f).setSize(150, 12).setValue(1.0f).setColorCaptionLabel(100);
	gui.addSlider("sz").setPosition(10, 38).setRange(0.5f, 1.5f).setSize(150, 12).setValue(1.0f).setColorCaptionLabel(100);
	gui.addSlider("rx").setPosition(10, 52).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);
	gui.addSlider("ry").setPosition(10, 66).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);
	gui.addSlider("rz").setPosition(10, 80).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);
	gui.addSlider("tx").setPosition(10, 94).setRange(-50, 50).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);
	gui.addSlider("ty").setPosition(10,108).setRange(-50, 50).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);
	gui.addSlider("tz").setPosition(10,122).setRange(-50, 50).setSize(150, 12).setValue(0.0f).setColorCaptionLabel(100);

	gui.setAutoDraw(false);
}
class Camera{
	Vector4f xDir, yDir, zDir;
	Vector4f pos; // world position of camera
	Vector4f up; // upper direction, not camera's yDir but on the z-y plane
	Vector4f target;

	// for check apply viewMatrix
	Vector4f cameraViewPos;
	Vector4f cameraViewXDir;
	Vector4f cameraViewYDir;
	Vector4f cameraViewZDir;


	Camera(){
		pos  	= new Vector4f(0.0f, 0.0f, -1.0f, 1.0f);
		target 	= new Vector4f(0.0f, 0.0f,  0.0f, 1.0f);
		up   	= new Vector4f(0.0f, 1.0f,  0.0f, 0.0f);

		xDir = new Vector4f(1.0f, 0.0f, 0.0f, 0.0f);
		yDir = new Vector4f(0.0f, 1.0f, 0.0f, 0.0f);
		zDir = new Vector4f(0.0f, 0.0f, 1.0f, 0.0f);
	}

	public void updateDir(){
		zDir = Vector4f.sub(target, pos);
		zDir.normalize();
		xDir = Vector4f.cross(up, zDir);
		xDir.normalize(); // already normalized, just to be sure
		yDir = Vector4f.cross(zDir, xDir);
		yDir.normalize(); // already normalized, just to be sure
	}

	public void setPosition(Vector4f _pos){
		pos = _pos;
		pos.w = 1.0f;
		updateDir();
	}

	public void setTarget(Vector4f _target){
		target = _target;
		target.w = 1.0f;
		updateDir();
	}

	public void setUpDir(Vector4f _up){
		up = _up;
		up.w = 0.0f;
		updateDir();
	}

	public void viewTranslation(){
		Matrix4x4 mat = viewMatrix();
		cameraViewPos = mat.mult(pos);
		cameraViewXDir = mat.mult(xDir);
		cameraViewYDir = mat.mult(yDir);
		cameraViewZDir = mat.mult(zDir);

	}

	public Matrix4x4 viewMatrix(){
		Matrix4x4 view = new Matrix4x4();
		Vector4f posVec = new Vector4f(pos);
		posVec.w = 0.0f;
		view.a[0][0] = xDir.x;	view.a[0][1] = xDir.y;	view.a[0][2] = xDir.z;	view.a[0][3] = -posVec.dot(xDir);
		view.a[1][0] = yDir.x;	view.a[1][1] = yDir.y;	view.a[1][2] = yDir.z;	view.a[1][3] = -posVec.dot(yDir);
		view.a[2][0] = zDir.x;	view.a[2][1] = zDir.y;	view.a[2][2] = zDir.z;	view.a[2][3] = -posVec.dot(zDir);
		view.a[3][0] = 0;		view.a[3][1] = 0;		view.a[3][2] = 0;		view.a[3][3] = 1;
		return view;
	}

	public void draw(){
		strokeWeight(3.0f);
		point(pos.x, pos.y, pos.z);

		stroke(127, 0, 0);
		line(pos.x, pos.y, pos.z, pos.x+20*xDir.x, pos.y+20*xDir.y, pos.z+20*xDir.z);
		stroke(0, 127, 0);
		line(pos.x, pos.y, pos.z, pos.x+20*yDir.x, pos.y+20*yDir.y, pos.z+20*yDir.z);
		stroke(0, 0, 127);
		line(pos.x, pos.y, pos.z, pos.x+20*zDir.x, pos.y+20*zDir.y, pos.z+20*zDir.z);
	}

	public void drawTranslated(){
		strokeWeight(3.0f);
		point(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z);

		stroke(255, 0, 0);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewXDir.x, cameraViewPos.y+20*cameraViewXDir.y, cameraViewPos.z+20*cameraViewXDir.z);
		stroke(0, 255, 0);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewYDir.x, cameraViewPos.y+20*cameraViewYDir.y, cameraViewPos.z+20*cameraViewYDir.z);
		stroke(0, 0, 255);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewZDir.x, cameraViewPos.y+20*cameraViewZDir.y, cameraViewPos.z+20*cameraViewZDir.z);
	}
};
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
	Cube(){
		new Cube(1.0f);
	}
	Cube(float s){
		local = new Vector4f[8];
		world = new Vector4f[8];
		cameraView = new Vector4f[8];
		
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

	public void resetTransform(){
		for(int i = 0; i < 8; i++){
			world[i] = local[i];
		}
	}

	public void scale(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(x, y, z);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}

	public void translate(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(x, y, z);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}


	public void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}public void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}
	public void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int i = 0; i < 8; i++){
			world[i] = mat.mult(world[i]);
		}
	}

	public void viewTranslation(Matrix4x4 view){
		for(int i = 0; i < 8; i++){
			cameraView[i] = view.mult(world[i]);
		}
	}

	public void drawLocal(){
		drawLocalQuad(0, 1, 2, 3);
		drawLocalQuad(0, 4, 5, 1);
		drawLocalQuad(1, 5, 6, 2);
		drawLocalQuad(2, 6, 7, 3);
		drawLocalQuad(3, 7, 4, 0);
		drawLocalQuad(7, 6, 5, 4);
	}

	public void drawWorld(){
		drawWorldQuad(0, 1, 2, 3);
		drawWorldQuad(0, 4, 5, 1);
		drawWorldQuad(1, 5, 6, 2);
		drawWorldQuad(2, 6, 7, 3);
		drawWorldQuad(3, 7, 4, 0);
		drawWorldQuad(7, 6, 5, 4);
	}

	public void drawCameraView(){
		drawCameraViewQuad(0, 1, 2, 3);
		drawCameraViewQuad(0, 4, 5, 1);
		drawCameraViewQuad(1, 5, 6, 2);
		drawCameraViewQuad(2, 6, 7, 3);
		drawCameraViewQuad(3, 7, 4, 0);
		drawCameraViewQuad(7, 6, 5, 4);
	}

	public void drawLocalQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(local[i0].x, local[i0].y, local[i0].z);
		vertex(local[i1].x, local[i1].y, local[i1].z);
		vertex(local[i2].x, local[i2].y, local[i2].z);
		vertex(local[i3].x, local[i3].y, local[i3].z);
		endShape(CLOSE);
	}
	public void drawWorldQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(world[i0].x, world[i0].y, world[i0].z);
		vertex(world[i1].x, world[i1].y, world[i1].z);
		vertex(world[i2].x, world[i2].y, world[i2].z);
		vertex(world[i3].x, world[i3].y, world[i3].z);
		endShape(CLOSE);
	}
	public void drawCameraViewQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(cameraView[i0].x, cameraView[i0].y, cameraView[i0].z);
		vertex(cameraView[i1].x, cameraView[i1].y, cameraView[i1].z);
		vertex(cameraView[i2].x, cameraView[i2].y, cameraView[i2].z);
		vertex(cameraView[i3].x, cameraView[i3].y, cameraView[i3].z);
		endShape(CLOSE);
	}
};
class Matrix4x4{
	float[][] a = new float[4][4];

	Matrix4x4(){
		setIdentity();
	}

	public void setIdentity(){
		a[0][0] = 1.0f;	a[0][1] = 0.0f;	a[0][2] = 0.0f;	a[0][3] = 0.0f;
		a[1][0] = 0.0f;	a[1][1] = 1.0f;	a[1][2] = 0.0f;	a[1][3] = 0.0f;
		a[2][0] = 0.0f;	a[2][1] = 0.0f;	a[2][2] = 1.0f;	a[2][3] = 0.0f;
		a[3][0] = 0.0f;	a[3][1] = 0.0f;	a[3][2] = 0.0f;	a[3][3] = 1.0f;	
	}

	public void setScale(float x, float y, float z){
		setIdentity();
		a[0][0] = x;
		a[1][1] = y;
		a[2][2] = z;
	}

	public void setTranslate(float x, float y, float z){
		setIdentity();
		a[0][3] = x;
		a[1][3] = y;
		a[2][3] = z;
	}

	public void setRotateX(float theta){
		setIdentity();
		a[1][1] = cos(theta);	a[1][2] =  sin(theta);
		a[2][1] = -sin(theta);	a[2][2] =  cos(theta);	
	}
	public void setRotateY(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][2] = -sin(theta);
		a[2][0] = sin(theta);	a[2][2] =  cos(theta);	
	}
	public void setRotateZ(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][1] =  sin(theta);
		a[1][0] = -sin(theta);	a[1][1] =  cos(theta);	
	}

	// --- MATRIX CALCULATION ---
	// result.x 	a[0][0] a[0][1] a[0][2] a[0][3] 	input.x
	// result.y 	a[1][0] a[1][1] a[1][2] a[1][3] 	input.y
	// result.z  = 	a[2][0] a[2][1] a[2][2] a[2][3]  * 	input.z
	// result.w 	a[3][0] a[3][1] a[3][2] a[3][3]		input.w


	public Vector4f mult(Vector4f p){
		Vector4f result = new Vector4f();
		result.x = a[0][0]*p.x + a[0][1]*p.y + a[0][2]*p.z + a[0][3]*p.w;
		result.y = a[1][0]*p.x + a[1][1]*p.y + a[1][2]*p.z + a[1][3]*p.w;
		result.z = a[2][0]*p.x + a[2][1]*p.y + a[2][2]*p.z + a[2][3]*p.w;
		result.w = p.w;
		return result;
	}

	public Matrix4x4 mult(Matrix4x4 m){
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

	public String toString() {
        return String.format("%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f\n%.2f, %.2f, %.2f, %.2f",
        a[0][0],a[0][1],a[0][2],a[0][3],a[1][0],a[1][1],a[1][2],a[1][3],a[2][0],a[2][1],a[2][2],a[2][3],a[3][0],a[3][1],a[3][2],a[3][3]);
    }
};
static class Vector4f{
	// if Vector4f is position, w = 1.0;
	// if Vector4f is vector,   w = 0.0;
	// position can't add to position.
	float x, y, z, w; 

	Vector4f(){
		x = 0.0f;
		y = 0.0f;
		z = 0.0f;
		w = 1.0f;
	}
	Vector4f(float _x, float _y){
		x = _x;
		y = _y;
		z = 0.0f;
		w = 1.0f;
	}
	Vector4f(float _x, float _y, float _z){
		x = _x;
		y = _y;
		z = _z;
		w = 1.0f;
	}
	Vector4f(float _x, float _y, float _z, float _w){
		x = _x;
		y = _y;
		z = _z;
		w = _w;
	}
	Vector4f(Vector4f a){
		x = a.x;
		y = a.y;
		z = a.z;
		w = a.w;
	}

	public float len(){
		// len() is always for vector, w = 0.0;
		return sqrt(pow(x, 2.0f)+pow(y, 2.0f)+pow(z, 2.0f)+pow(w, 2.0f));
	}

	public void normalize(){
		float len = len();
		x /= len;
		y /= len;
		z /= len;
		w /= len; // normalize() is always for vector, w = 0.0;
	}

	public static Vector4f sub(Vector4f a, Vector4f b){
		Vector4f result = new Vector4f();
		result.x = a.x - b.x;
		result.y = a.y - b.y;
		result.z = a.z - b.z;
		result.w = a.w - b.w;
		return result;
	}

	public float dot(Vector4f a){
		return this.x*a.x + this.y*a.y + this.z*a.z + this.w+a.w;
	}

	public static Vector4f cross(Vector4f a, Vector4f b){ // ignore w, return 3d cross product
		Vector4f result = new Vector4f();
		result.x = a.y*b.z - a.z*b.y;
		result.y = a.z*b.x - a.x*b.z;
		result.z = a.x*b.y - a.y*b.x;
		result.w = a.w * b.w;
		return result;	
	}

	public String toString() {
        return String.format("[%.2f, %.2f, %.2f, %.2f]", x, y, z, w);
    }
};
class VectorField{
	Vector4f[][][] local;
	Vector4f[][][] world;
	int xNum, yNum, zNum;
	VectorField(){
		new VectorField(10, 10, 10, 25);
	}

	VectorField(int x_num, int y_num, int z_num, float spacer){
		xNum = x_num;
		yNum = y_num;
		zNum = z_num;
		local = new Vector4f[xNum][yNum][zNum];
		world = new Vector4f[xNum][yNum][zNum];
		float minX = -spacer*(xNum/2);
		float minY = -spacer*(yNum/2);
		float minZ = -spacer*(zNum/2);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					local[x][y][z] = new Vector4f(minX+x*spacer, minY+y*spacer, minZ+z*spacer);
					world[x][y][z] = local[x][y][z];
				}
			}
		}
	}

	public void resetTransform(){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = local[x][y][z];
				}
			}
		}
	}

	public void scale(float _x, float _y, float _z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(_x, _y, _z);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = mat.mult(world[x][y][z]);
				}
			}
		}
	}

	public void translate(float _x, float _y, float _z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(_x, _y, _z);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = mat.mult(world[x][y][z]);
				}
			}
		}
	}

	public void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = mat.mult(world[x][y][z]);
				}
			}
		}
	}public void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = mat.mult(world[x][y][z]);
				}
			}
		}
	}
	public void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					world[x][y][z] = mat.mult(world[x][y][z]);
				}
			}
		}
	}

	public void drawLocalPositions(){
		beginShape(POINTS);
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					Vector4f pos = local[x][y][z];
					vertex(pos.x, pos.y, pos.z);
				}
			}
		}
		endShape();
	}

	public void drawField(){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					stroke(200*x/xNum,200*y/yNum,200*z/zNum);
					Vector4f p1 = local[x][y][z];
					Vector4f p2 = world[x][y][z];
					line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
				}
			}
		}
	}
};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "modelView" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
