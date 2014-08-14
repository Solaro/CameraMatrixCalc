import peasy.*;
import controlP5.*;

PeasyCam cam;

Camera cameraa;

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

	cameraa = new Camera();
	cameraa.setPosition(new Vector4f(300.0, 200.0, 100.0));
	cameraa.setTarget(new Vector4f(0.0, 0.0, 0.0));
	cameraa.viewTranslation();


	setupGUI();
	test();
}

void draw() {
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
	strokeWeight(0.5);
	stroke(127, 0, 0);
	c1.drawLocal();
	stroke(255, 0, 0);
	strokeWeight(1.0);
	c1.drawWorld();
	stroke(0);
	strokeWeight(2.0);
	c1.drawCameraView();

	cameraa.draw();
	cameraa.drawTranslated();

	hint(DISABLE_DEPTH_TEST);
  	cam.beginHUD();
  	gui.draw();
  	cam.endHUD();
  	hint(ENABLE_DEPTH_TEST);
}

void mousePressed(){
	if(gui.isMouseOver()){
  		cam.setMouseControlled(false);
  	}
}

void mouseReleased(){
	cam.setMouseControlled(true);
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

	c1.viewTranslation(cameraa.viewMatrix());
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

void test(){
	Matrix4x4 R_x = new Matrix4x4();
	Matrix4x4 R_y = new Matrix4x4();
	Matrix4x4 R_z = new Matrix4x4();
	R_x.setRotateX(TWO_PI/36);
	R_y.setRotateY(TWO_PI/18);
	R_z.setRotateZ(TWO_PI/6);
	println("<Rotate around X axis>\n"+R_x+"\n");
	println("<Rotate around Y axis>\n"+R_y+"\n");
	println("<Rotate around Z axis>\n"+R_z+"\n");

	Matrix4x4 XYZ = R_x.mult(R_y.mult(R_z));
	println("<Rotate around XYZ axis>\n"+XYZ+"\n");
	
	Matrix4x4 XZY = R_x.mult(R_z.mult(R_y));
	println("<Rotate around XZY axis>\n"+XZY+"\n");
}
