Rectangle r;

void setup() {
	size(640, 320);
	r = new Rectangle(0, 0, 50, 50);

	// r.rotateZ(TWO_PI/8);
	// r.translate(width/2, height/2, 0);
	r.rotateZ_translate(TWO_PI/8, width/2, height/2, 0);
}

void draw() {
	background(255);
	noFill();
	stroke(0);
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();
}

void keyPressed(){
	switch(keyCode){
		case UP:
		r.translate(0, -10, 0);
		break;

		case RIGHT:
		r.translate(10, 0, 0);
		break;
		
		case DOWN:
		r.translate(0, 10, 0);
		break;
		
		case LEFT:
		r.translate(-10, 0, 0);
		break;

		default:
		break;
	}
}