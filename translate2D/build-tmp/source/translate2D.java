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

public class translate2D extends PApplet {

Rectangle r;

public void setup() {
	size(512, 512);
	r = new Rectangle(100, 100, 200, 200);
	r.translate(50, 10, 0);
	r.applyMatrix();
}

public void draw() {
	background(255);
	stroke(0);
	noFill();
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();
}
class Matrix4x4{
	float[][] a = new float[4][4];

	Matrix4x4(){
		a[0][0] = 1.0f;	a[0][1] = 0.0f;	a[0][2] = 0.0f;	a[0][3] = 0.0f;
		a[1][0] = 0.0f;	a[1][1] = 1.0f;	a[1][2] = 0.0f;	a[1][3] = 0.0f;
		a[2][0] = 0.0f;	a[2][1] = 0.0f;	a[2][2] = 1.0f;	a[2][3] = 0.0f;
		a[3][0] = 0.0f;	a[3][1] = 0.0f;	a[3][2] = 0.0f;	a[3][3] = 1.0f;
	}

	Matrix4x4(float[][] _a){
		for(int i = 0; i < 4; i++){
			for(int j = 0; j < 4; j++){
				a[i][j] = _a[i][j];
			}
		}
	}
	public void translate(float x, float y, float z){
		a[0][3] += x;
		a[1][3] += y;
		a[2][3] += z;
	}
	// --- MATRIX CALCULATION ---
	// result.x 	a[0][0] a[0][1] a[0][2] a[0][3] 	input.x
	// result.y 	a[1][0] a[1][1] a[1][2] a[1][3] \/	input.y
	// result.z  = 	a[2][0] a[2][1] a[2][2] a[2][3] /\ 	input.z
	// result.w 	a[3][0] a[3][1] a[3][2] a[3][3]		input.w

	public Vector4f mult(Vector4f p){
		Vector4f result = new Vector4f();
		result.x = a[0][0]*p.x + a[0][1]*p.y + a[0][2]*p.z + a[0][3]*p.w;
		result.y = a[1][0]*p.x + a[1][1]*p.y + a[1][2]*p.z + a[1][3]*p.w;
		result.z = a[2][0]*p.x + a[2][1]*p.y + a[2][2]*p.z + a[2][3]*p.w;
		result.w = p.w;
		return result;
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

	public float[] array(){
		float[] a = new float[4];
		a[0] = x;
		a[1] = y;
		a[2] = z;
		a[3] = w;
		return a;
	}
	public String toString() {
        return String.format("[%.2f, %.2f, %.2f, %.2f]", x, y, z, w);
    }
};
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

	public void translate(float x, float y, float z){
		mat.translate(x, y, z);
	}

	public void applyMatrix(){
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "translate2D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
