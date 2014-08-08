import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class transformationField extends PApplet {



ControlP5 gui;
float sx, sy; // scale of x axis and y axis
float theta;  // rotation
float tx, ty; // translation of x and y axis

Rectangle r;
VectorField vf;

public void setup() {
	size(800, 500);
	r = new Rectangle(0, 0, 40, 40);
	vf = new VectorField(80, 50);

	sx = 1.0f;
	sy = 1.0f;
	theta = 0;
	tx = 0;
	ty = 0;

	setupGUI();
}

public void draw() {
	background(255);
	
	pushMatrix(); // move center(0, 0) and draw all elements
  	translate(width/2, height/2);
  	
  	stroke(0);
	line(-width, 0, width, 0);
  	line(0, -height, 0, height);

  	r.scale(sx, sy);
	r.rotate(theta);
	r.scale(sx, sy);
	r.translate(tx, ty);
	//r.rotate_translate(theta, tx, ty);
	vf.scale(sx, sy);
	vf.rotate(theta);
	vf.scale(sx, sy);
	vf.translate(tx, ty);
	//vf.rotate_translate(theta, tx, ty);
	
	noFill();
	stroke(0);
	strokeWeight(1.0f);
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();

	fill(0);
	noStroke();
	vf.drawOriginalPositions();
	strokeWeight(0.5f);
	stroke(0, 0, 80);
	vf.drawField();

	r.resetTransform();
	vf.resetTransform();

  	popMatrix(); // reset "moved to center(0, 0)" now left-top is(0, 0), and draw GUI
}

public void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("sx").setPosition(10,10).setRange(0.5f, 2).setSize(200, 12).setValue(1.0f).setColorCaptionLabel(100);
	gui.addSlider("sy").setPosition(10,24).setRange(0.5f, 2).setSize(200, 12).setValue(1.0f).setColorCaptionLabel(100);
	gui.addSlider("theta").setPosition(10,38).setRange(-TWO_PI/18, TWO_PI/18).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
	gui.addSlider("tx").setPosition(10,52).setRange(-20, 20).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
	gui.addSlider("ty").setPosition(10,66).setRange(-20, 20).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
}

public void keyPressed(){
	switch(keyCode){
		case UP:
		r.translate(0, -10);
		break;

		case RIGHT:
		r.translate(10, 0);
		break;
		
		case DOWN:
		r.translate(0, 10);
		break;
		
		case LEFT:
		r.translate(-10, 0);
		break;

		default:
		break;
	}
}
class Matrix3x3{
	float[][] a = new float[3][3];

	Matrix3x3(){
		setIdentity();
	}

	public void setIdentity(){
		a[0][0] = 1.0f;	a[0][1] = 0.0f;	a[0][2] = 0.0f;
		a[1][0] = 0.0f;	a[1][1] = 1.0f;	a[1][2] = 0.0f;
		a[2][0] = 0.0f;	a[2][1] = 0.0f;	a[2][2] = 1.0f;
	}

	public void setScale(float x, float y){
		setIdentity();
		a[0][0] = x;
		a[1][1] = y;
	}

	public void setTranslate(float x, float y){
		setIdentity();
		a[0][2] = x;
		a[1][2] = y;
	}

	public void setRotate(float theta){
		setIdentity();
		a[0][0] = cos(theta);	a[0][1] = sin(theta);
		a[1][0] = -sin(theta);	a[1][1] = cos(theta);	
	}

	// --- MATRIX CALCULATION ---
	// result.x 	a[0][0] a[0][1] a[0][2] a[0][3] 	input.x
	// result.y  =	a[1][0] a[1][1] a[1][2] a[1][3]  *	input.y
	// result.w   	a[2][0] a[2][1] a[2][2] a[2][3]  	input.w

	public Vector3f mult(Vector3f p){
		Vector3f result = new Vector3f();
		result.x = a[0][0]*p.x + a[0][1]*p.y + a[0][2]*p.w;
		result.y = a[1][0]*p.x + a[1][1]*p.y + a[1][2]*p.w;
		result.w = a[2][0]*p.x + a[2][1]*p.y + a[2][2]*p.w;
		return result;
	}

	public Matrix3x3 mult(Matrix3x3 m){
		Matrix3x3 result = new Matrix3x3();
		for(int row = 0; row < 3; row++){
			for(int col = 0; col < 3; col++){
				result.a[row][col] = a[row][0]*m.a[0][col]
									+a[row][1]*m.a[1][col]
									+a[row][2]*m.a[2][col];
			}
		}
		return result;
	}
	public String toString() {
        return String.format("%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f\n%.2f, %.2f, %.2f",
        a[0][0],a[0][1],a[0][2],a[1][0],a[1][1],a[1][2],a[2][0],a[2][1],a[2][2]);
    }
};
class Rectangle{
	Vector3f center;
	Vector3f p1, p2, p3, p4; // Position of original(=local) apex
	Vector3f v1, v2, v3, v4; // operated vertex for visualize
	Rectangle(){
		center 	= new Vector3f( 0.0f,  0.0f);
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

	public void resetTransform(){
		v1 = p1;
		v2 = p2;
		v3 = p3;
		v4 = p4;
	}

	public void scale(float x, float y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setScale(x, y);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
		// println("\n[scale]");
		// println(mat);
	}

	public void translate(float x, float y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setTranslate(x, y);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	public void rotate(float theta){
		Matrix3x3 mat = new Matrix3x3();
		mat.setRotate(theta);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	public void rotate_translate(float theta, float x, float y){
		Matrix3x3 rot = new Matrix3x3();
		rot.setRotate(theta);
		println("\n[rotate]");
		println(rot);
		Matrix3x3 trans = new Matrix3x3();
		trans.setTranslate(x, y);
		println("\n[translate]");
		println(trans);

		Matrix3x3 mat = trans.mult(rot);
		println("\n[rotate_translate]");
		println(mat);
		v1 = mat.mult(v1);
		v2 = mat.mult(v2);
		v3 = mat.mult(v3);
		v4 = mat.mult(v4);
	}

	public void drawOriginal(){
		beginShape();
		vertex(p1.array());
		vertex(p2.array());
		vertex(p3.array());
		vertex(p4.array());
		endShape(CLOSE);
	}

	public void drawOperated(){
		beginShape();
		vertex(v1.array());
		vertex(v2.array());
		vertex(v3.array());
		vertex(v4.array());
		endShape(CLOSE);
	}
};
class Vector3f{
	// if Vector3f is position, w = 1.0;
	// if Vector3f is vector,   w = 0.0;
	// position can't add to position.
	float x, y, w; 

	Vector3f(){
		x = 0.0f;
		y = 0.0f;
		w = 1.0f;
	}
	Vector3f(float _x, float _y){
		x = _x;
		y = _y;
		w = 1.0f;
	}
	Vector3f(float _x, float _y, float _w){
		x = _x;
		y = _y;
		w = _w;
	}

	public float[] array(){
		float[] a = new float[3];
		a[0] = x;
		a[1] = y;
		a[2] = w;
		return a;
	}
	public String toString() {
        return String.format("[%.2f, %.2f, %.2f]", x, y, w);
    }
};
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
	public void resetTransform(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = original[x][y];
			}
		}
	}

	public void scale(float _x, float _y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setScale(_x, _y);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	public void translate(float _x, float _y){
		Matrix3x3 mat = new Matrix3x3();
		mat.setTranslate(_x, _y);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	public void rotate(float theta){
		Matrix3x3 mat = new Matrix3x3();
		mat.setRotate(theta);
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				transformed[x][y] = mat.mult(transformed[x][y]);
			}
		}
	}

	public void rotate_translate(float theta, float _x, float _y){
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

	public void drawOriginalPositions(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				Vector3f pos = original[x][y];
				ellipse(pos.x, pos.y, 2, 2);
			}
		}
	}

	public void drawField(){
		for (int y = 0; y < yNum; y++) {
			for (int x = 0; x < xNum; x++) {
				Vector3f p1 = original[x][y];
				Vector3f p2 = transformed[x][y];
				line(p1.x, p1.y, p2.x, p2.y);
			}
		}
	}
};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "transformationField" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
