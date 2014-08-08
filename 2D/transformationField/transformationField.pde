import controlP5.*;

ControlP5 gui;
float sx, sy; // scale of x axis and y axis
float theta;  // rotation
float tx, ty; // translation of x and y axis

Rectangle r1, r2, r3;
VectorField vf;

void setup() {
	size(800, 500);
	r1 = new Rectangle(0, 0, 20, 20);
	r2 = new Rectangle(160, -40, 80, 80);
	r3 = new Rectangle(-200, 100, 40, 40);
	vf = new VectorField(80, 50);

 
	setupGUI();
}

void draw() {
	background(255);
	
	pushMatrix(); // move center(0, 0) and draw all elements
  	translate(width/2, height/2);
  	
  	stroke(0);
	line(-width, 0, width, 0);
  	line(0, -height, 0, height);

  	r1.scale(sx, sy);
  	r2.scale(sx, sy);
  	r3.scale(sx, sy);

	r1.rotate(theta);
	r2.rotate(theta);
	r3.rotate(theta);

	r1.translate(tx, ty);
	r2.translate(tx, ty);
	r3.translate(tx, ty);
	//r1.rotate_translate(theta, tx, ty);
	//r2.rotate_translate(theta, tx, ty);
	//r3.rotate_translate(theta, tx, ty);
	vf.scale(sx, sy);
	vf.rotate(theta);
	
	vf.translate(tx, ty);
	//vf.rotate_translate(theta, tx, ty);
	
	noFill();
	stroke(0);
	strokeWeight(1.0);
	r1.drawOriginal();
	r2.drawOriginal();
	r3.drawOriginal();
	stroke(255, 0, 0);
	r1.drawOperated();
	r2.drawOperated();
	r3.drawOperated();

	fill(0);
	noStroke();
	vf.drawOriginalPositions();
	strokeWeight(0.5);
	stroke(0, 0, 80);
	vf.drawField();

	r1.resetTransform();
	r2.resetTransform();
	r3.resetTransform();
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
		r1.translate(0, -10);
		r2.translate(0, -10);
		r3.translate(0, -10);
		break;

		case RIGHT:
		r1.translate(10, 0);
		r2.translate(10, 0);
		r3.translate(10, 0);
		break;
		
		case DOWN:
		r1.translate(0, 10);
		r2.translate(0, 10);
		r3.translate(0, 10);
		break;
		
		case LEFT:
		r1.translate(-10, 0);
		r2.translate(-10, 0);
		r3.translate(-10, 0);
		break;

		default:
		break;
	}
}
