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

public class transformation extends PApplet {




PeasyCam cam;

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

	setupGUI();
}

public void draw() {
	background(255);

	transform();

	// DRAW CUBE
	noFill();
	strokeWeight(0.5f);
	stroke(255, 0, 0);
	c1.drawOriginal();
	stroke(0);
	strokeWeight(1.0f);
	c1.drawTransformed();

	// DRAW VECTORFIELD
	stroke(0, 0, 80);
	strokeWeight(2.0f);
	vf.drawOriginalPositions();
	strokeWeight(1.7f);
	vf.drawField();

	hint(DISABLE_DEPTH_TEST);
  	cam.beginHUD();
  	gui.draw();
  	cam.endHUD();
  	hint(ENABLE_DEPTH_TEST);
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
		new Cube(1.0f);
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

	public void resetTransform(){
		for(int i = 0; i < 8; i++){
			transformed[i] = original[i];
		}
	}

	public void scale(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setScale(x, y, z);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}

	public void translate(float x, float y, float z){
		Matrix4x4 mat = new Matrix4x4();
		mat.setTranslate(x, y, z);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}


	public void rotateX(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateX(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}public void rotateY(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateY(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}
	public void rotateZ(float theta){
		Matrix4x4 mat = new Matrix4x4();
		mat.setRotateZ(theta);
		for(int i = 0; i < 8; i++){
			transformed[i] = mat.mult(transformed[i]);
		}
	}

	public void drawOriginal(){
		drawOriginalQuad(0, 1, 2, 3);
		drawOriginalQuad(0, 4, 5, 1);
		drawOriginalQuad(1, 5, 6, 2);
		drawOriginalQuad(2, 6, 7, 3);
		drawOriginalQuad(3, 7, 4, 0);
		drawOriginalQuad(7, 6, 5, 4);
	}

	public void drawTransformed(){
		drawTransformedQuad(0, 1, 2, 3);
		drawTransformedQuad(0, 4, 5, 1);
		drawTransformedQuad(1, 5, 6, 2);
		drawTransformedQuad(2, 6, 7, 3);
		drawTransformedQuad(3, 7, 4, 0);
		drawTransformedQuad(7, 6, 5, 4);
	}

	public void drawOriginalQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(original[i0].x, original[i0].y, original[i0].z);
		vertex(original[i1].x, original[i1].y, original[i1].z);
		vertex(original[i2].x, original[i2].y, original[i2].z);
		vertex(original[i3].x, original[i3].y, original[i3].z);
		endShape(CLOSE);
	}
	public void drawTransformedQuad(int i0, int i1, int i2, int i3){
		beginShape();
		vertex(transformed[i0].x, transformed[i0].y, transformed[i0].z);
		vertex(transformed[i1].x, transformed[i1].y, transformed[i1].z);
		vertex(transformed[i2].x, transformed[i2].y, transformed[i2].z);
		vertex(transformed[i3].x, transformed[i3].y, transformed[i3].z);
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
		a[1][1] = cos(theta);	a[1][2] = sin(theta);
		a[2][1] = -sin(theta);	a[2][2] = cos(theta);	
	}
	public void setRotateY(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][2] = sin(theta);
		a[2][0] = -sin(theta);	a[2][2] = cos(theta);	
	}
	public void setRotateZ(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][1] = sin(theta);
		a[1][0] = -sin(theta);	a[1][1] = cos(theta);	
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
class Vector4f{
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

	public String toString() {
        return String.format("[%.2f, %.2f, %.2f, %.2f]", x, y, z, w);
    }
};
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

	public void resetTransform(){
		for(int z = 0; z < zNum; z++){
			for (int y = 0; y < yNum; y++) {
				for (int x = 0; x < xNum; x++) {
					transformed[x][y][z] = original[x][y][z];
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
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
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
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
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
					transformed[x][y][z] = mat.mult(transformed[x][y][z]);
				}
			}
		}
	}public void rotateY(float theta){
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
	public void rotateZ(float theta){
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

	public void drawOriginalPositions(){
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

	public void drawField(){
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "transformation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
