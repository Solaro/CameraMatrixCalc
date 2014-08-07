import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class transformation extends PApplet {

Rectangle r;

public void setup() {
	size(640, 320);
	r = new Rectangle(0, 0, 50, 50);
	r.scale(2.0f, 2.0f);
	r.rotate(TWO_PI/8);
	r.translate(width/2, height/2);
	//r.rotate_translate(TWO_PI/8, width/2, height/2);
}

public void draw() {
	background(255);
	noFill();
	stroke(0);
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "transformation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
