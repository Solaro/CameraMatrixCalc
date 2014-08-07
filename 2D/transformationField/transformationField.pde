Rectangle r;
VectorField vf;

void setup() {
	size(640, 320);
	r = new Rectangle(0, 0, 40, 40);
	vf = new VectorField(64, 32);

	r.scale(1.5, 1.5);
	r.rotate(TWO_PI/32);
	//r.translate(50, 30);
	//r.rotate_translate(TWO_PI/8, 50, 30);
	
	vf.rotate(TWO_PI/32);
	vf.scale(1.5, 1.5);
	//vf.translate(50, 30);
	//vf.rotate_translate(TWO_PI/8, 50, 30);
}

void draw() {
	background(255);
	translate(width/2, height/2);

	noFill();
	stroke(0);
	strokeWeight(1.0);
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();

	fill(0);
	vf.drawOriginalPositions();
	strokeWeight(0.5);
	stroke(0, 127, 0);
	vf.drawField();
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