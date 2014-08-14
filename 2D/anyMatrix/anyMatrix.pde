import controlP5.*;

ControlP5 gui;
float a11, a12, a21, a22;

Rectangle r1, r2, r3;
VectorField vf;

void setup() {
	size(800, 500);
	r1 = new Rectangle(0, 0, 20, 20);
	r2 = new Rectangle(160, -40, 80, 80);
	r3 = new Rectangle(-200, 100, 40, 40);
	vf = new VectorField(40, 25);

	setupGUI();
}

void draw() {
	background(255);
	
	pushMatrix(); // move center(0, 0) and draw all elements
  	translate(width/2, height/2);
  	
  	stroke(0);
	line(-width, 0, width, 0);
  	line(0, -height, 0, height);

  	Matrix3x3 mat = new Matrix3x3();
  	mat.a[0][0] = a11;
  	mat.a[0][1] = a12;
  	mat.a[1][0] = a21;
  	mat.a[1][1] = a22;

  	r1.applyMatrix(mat);
  	r2.applyMatrix(mat);
  	r3.applyMatrix(mat);
  	//vf.applyMatrix(mat);

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

	// fill(0);
	// noStroke();
	// vf.drawOriginalPositions();
	// strokeWeight(0.5);
	// stroke(0, 0, 80);
	// vf.drawField();

	fill(0);
	stroke(0);
	
	text("det = "+(a11*a22-a12*a21), 10, (-height/2)+20);
	text(mat.toString(), 10, (-height/2)+34);


	r1.resetTransform();
	r2.resetTransform();
	r3.resetTransform();
	vf.resetTransform();

  	popMatrix(); // reset "moved to center(0, 0)" now left-top is(0, 0), and draw GUI
}

void setupGUI(){
	gui = new ControlP5(this);
	  
	gui.addSlider("a11").setPosition(10,10).setRange(-2.0, 2.0).setSize(200, 12).setValue(1.0).setColorCaptionLabel(100);
	gui.addSlider("a12").setPosition(10,24).setRange(-2.0, 2.0).setSize(200, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a21").setPosition(10,38).setRange(-2.0, 2.0).setSize(200, 12).setValue(0.0).setColorCaptionLabel(100);
	gui.addSlider("a22").setPosition(10,52).setRange(-2.0, 2.0).setSize(200, 12).setValue(1.0).setColorCaptionLabel(100);
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
