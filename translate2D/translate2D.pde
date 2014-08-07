Rectangle r;

void setup() {
	size(512, 512);
	r = new Rectangle(100, 100, 200, 200);
	r.translate(50, 10, 0);
	r.applyMatrix();
}

void draw() {
	background(255);
	stroke(0);
	noFill();
	r.drawOriginal();
	stroke(255, 0, 0);
	r.drawOperated();
}