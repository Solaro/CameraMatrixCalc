import peasy.*;
import controlP5.*;

PeasyCam cam;

ControlP5 gui;
float a11, a12, a13;
float a21, a22, a23;
float a31, a32, a33;


Cube c1;
VectorField vf;

void setup() {
	size(1200, 800, P3D);
  	cam = new PeasyCam(this, 400);
  	cam.setMinimumDistance(50);
  	cam.setMaximumDistance(800);
	
	c1 = new Cube(50);
	vf = new VectorField(5, 5, 5, 25);

	setupGUI();
}

void draw() {
	background(255);

	c1.resetTransform();
	vf.resetTransform();

	Matrix4x4 mat = new Matrix4x4();
	mat.a[0][0] = a11;
	mat.a[0][1] = a12;
	mat.a[0][2] = a13;
	mat.a[1][0] = a21;
	mat.a[1][1] = a22;
	mat.a[1][2] = a23;
	mat.a[2][0] = a31;
	mat.a[2][1] = a32;
	mat.a[2][2] = a33;

	c1.applyMatrix(mat);
	vf.applyMatrix(mat);

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
	strokeWeight(0.5);
	stroke(255, 0, 0);
	c1.drawOriginal();
	stroke(0);
	strokeWeight(1.0);
	c1.drawTransformed();

	// DRAW VECTORFIELD
	stroke(0, 0, 80);
	strokeWeight(2.0);
	vf.drawOriginalPositions();
	strokeWeight(1.7);
	vf.drawField();

	hint(DISABLE_DEPTH_TEST);
  	cam.beginHUD();
  	gui.draw();
  	// DRAW text
  	text("<TRANSFORMATION MATRIX>", 10, 150);
  	text(mat.toString(), 10, 164);
  	cam.endHUD();
  	hint(ENABLE_DEPTH_TEST);
}

void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("a11").setPosition(10, 10).setRange(-2.0, 2.0).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("a12").setPosition(10, 24).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a13").setPosition(10, 38).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a21").setPosition(10, 52).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a22").setPosition(10, 66).setRange(-2.0, 2.0).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("a23").setPosition(10, 80).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a31").setPosition(10, 94).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a32").setPosition(10,108).setRange(-2.0, 2.0).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a33").setPosition(10,122).setRange(-2.0, 2.0).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);

	gui.setAutoDraw(false);
}

void mousePressed(){
	if(gui.isMouseOver()){
  		cam.setMouseControlled(false);
  	}
}
void mouseReleased(){
	cam.setMouseControlled(true);
}
