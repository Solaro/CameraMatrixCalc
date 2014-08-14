import peasy.*;
import controlP5.*;

PeasyCam cam;
PeasyCam projectionCam;

Camera cameraa;

ControlP5 gui;
float sx, sy, sz; // scale of x,y,z
float rx, ry, rz; // rotation of x, y, z
float tx, ty, tz; // translation of x,y,z
boolean visualize_local  = true;
boolean visualize_world  = false;
boolean visualize_camera = false;
boolean visualize_projection = false;
boolean visualize_screen = false;

Cube c1;



void setup() {
	size(1200, 800, P3D);

  	cam = new PeasyCam(this, 100);
  	cam.setMinimumDistance(10.0);
  	cam.setMaximumDistance(500);

	
	c1 = new Cube(10);

	cameraa = new Camera();
	cameraa.setPosition(new Vector4f(30.0, 20.0, 100.0));
	cameraa.setTarget(new Vector4f(0.0, 0.0, 0.0));
	cameraa.setFov(TWO_PI/18);
	cameraa.setNear(50);
	cameraa.setFar(150);
	cameraa.viewTranslation();


	setupGUI();
}

void draw() {
	background(255);

	transform();

	// DRAW AXIS
	strokeWeight(0.5);
	stroke(255, 0, 0);
	line(-25, 0, 0, 25, 0, 0);
	line(25, 0, 0, 23, 2, 2);
	stroke(0, 255, 0);
	line(0, -25, 0, 0, 25, 0);
	line(0, 25, 0, 2, 23, 2);
	stroke(0, 0, 255);
	line(0, 0, -25, 0, 0, 25);
	line(0, 0, 25, 2, 2, 23);


	// DRAW CUBE
	noFill();
	if(visualize_local){
		strokeWeight(0.5);
		stroke(127, 0, 0);
		c1.drawLocal();
	}
	
	if(visualize_world){
		stroke(255, 0, 0);
		strokeWeight(1.0);
		c1.drawWorld();
		cameraa.draw();
	}
	
	if(visualize_camera){
		stroke(0);
		strokeWeight(2.0);
		c1.drawCameraView();
		cameraa.drawTranslated();
	}

	if(visualize_projection){
		stroke(0);
		strokeWeight(2.0);
		c1.drawProjection();
	}

	hint(DISABLE_DEPTH_TEST);
  	cam.beginHUD();
  	if(visualize_screen){
  		stroke(0);
  		strokeWeight(1);
		c1.drawScreen();
  	}
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

void keyPressed(){
	switch(key){
		case ' ':
		break;
		default:
		break;
	}
}

void transform(){
	c1.resetTransform();

	c1.scale(sx, sy, sz);
	c1.rotateX(rx);
	c1.rotateY(ry);
	c1.rotateZ(rz);
	c1.translate(tx, ty, tz);

	c1.viewTranslation(cameraa.viewMatrix());
	c1.applyProjection(cameraa.projectionMatrix());
	c1.applyScreenMatrix(cameraa.screenMatrix());
	
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

	Toggle[] t = new Toggle[5];
	t[0] = gui.addToggle("visualize_local",       true, 10, 136, 12, 12).setColorCaptionLabel(100);
	t[1] = gui.addToggle("visualize_world",      false, 10, 150, 12, 12).setColorCaptionLabel(100);
	t[2] = gui.addToggle("visualize_camera",     false, 10, 164, 12, 12).setColorCaptionLabel(100);
	t[3] = gui.addToggle("visualize_projection", false, 10, 178, 12, 12).setColorCaptionLabel(100);
	t[4] = gui.addToggle("visualize_screen",     false, 10, 192, 12, 12).setColorCaptionLabel(100);
	for(int i = 0; i < 5; i++){
		controlP5.Label l = t[i].captionLabel();
		l.style().marginTop = -14; //move upwards (relative to button size)
		l.style().marginLeft = 18; //move to the right
	}

	gui.setAutoDraw(false);
}

