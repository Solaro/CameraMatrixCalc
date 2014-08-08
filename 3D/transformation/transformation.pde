import peasy.*;
import controlP5.*;

PeasyCam cam;

ControlP5 gui;
float sx, sy, sz; // scale of x,y,z
float rx, ry, rz; // rotation of x, y, z
float tx, ty, tz; // translation of x,y,z


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

	transform();

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
  	cam.endHUD();
  	hint(ENABLE_DEPTH_TEST);
}

void transform(){
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

void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("sx").setPosition(10, 10).setRange(0.5, 1.5).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("sy").setPosition(10, 24).setRange(0.5, 1.5).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("sz").setPosition(10, 38).setRange(0.5, 1.5).setSize(150, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("rx").setPosition(10, 52).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("ry").setPosition(10, 66).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("rz").setPosition(10, 80).setRange(-TWO_PI/18, TWO_PI/18).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("tx").setPosition(10, 94).setRange(-50, 50).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("ty").setPosition(10,108).setRange(-50, 50).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("tz").setPosition(10,122).setRange(-50, 50).setSize(150, 12).setValue(0.0).setColorCaptionLabel(100);

	gui.setAutoDraw(false);
}
