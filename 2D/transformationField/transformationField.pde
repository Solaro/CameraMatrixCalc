import controlP5.*;

ControlP5 gui;
float sx, sy; // scale of x axis and y axis
float theta;  // rotation
float tx, ty; // translation of x and y axis

Rectangle r;
VectorField vf;

void setup() {
	size(800, 500);
	r = new Rectangle(0, 0, 40, 40);
	vf = new VectorField(80, 50);

	sx = 1.0;
	sy = 1.0;
	theta = 0;
	tx = 0;
	ty = 0;

	setupGUI();
}

void draw() {
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
	strokeWeight(1.0);
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();

	fill(0);
	noStroke();
	vf.drawOriginalPositions();
	strokeWeight(0.5);
	stroke(0, 0, 80);
	vf.drawField();

	r.resetTransform();
	vf.resetTransform();

  	popMatrix(); // reset "moved to center(0, 0)" now left-top is(0, 0), and draw GUI
}

void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("sx").setPosition(10,10).setRange(0.5, 2).setSize(200, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("sy").setPosition(10,24).setRange(0.5, 2).setSize(200, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("theta").setPosition(10,38).setRange(-TWO_PI/18, TWO_PI/18).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
	gui.addSlider("tx").setPosition(10,52).setRange(-20, 20).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
	gui.addSlider("ty").setPosition(10,66).setRange(-20, 20).setSize(200, 12).setValue(0).setColorCaptionLabel(100);
}

void keyPressed(){
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