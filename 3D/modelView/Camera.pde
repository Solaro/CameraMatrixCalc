class Camera{
	Vector4f xDir, yDir, zDir;
	Vector4f pos; // world position of camera
	Vector4f up; // upper direction, not camera's yDir but on the z-y plane
	Vector4f target;

	// for check apply viewMatrix
	Vector4f cameraViewPos;
	Vector4f cameraViewXDir;
	Vector4f cameraViewYDir;
	Vector4f cameraViewZDir;


	Camera(){
		pos  	= new Vector4f(0.0, 0.0, -1.0, 1.0);
		target 	= new Vector4f(0.0, 0.0,  0.0, 1.0);
		up   	= new Vector4f(0.0, 1.0,  0.0, 0.0);

		xDir = new Vector4f(1.0, 0.0, 0.0, 0.0);
		yDir = new Vector4f(0.0, 1.0, 0.0, 0.0);
		zDir = new Vector4f(0.0, 0.0, 1.0, 0.0);
	}

	void updateDir(){
		zDir = Vector4f.sub(target, pos);
		zDir.normalize();
		xDir = Vector4f.cross(up, zDir);
		xDir.normalize(); // already normalized, just to be sure
		yDir = Vector4f.cross(zDir, xDir);
		yDir.normalize(); // already normalized, just to be sure
	}

	void setPosition(Vector4f _pos){
		pos = _pos;
		pos.w = 1.0;
		updateDir();
	}

	void setTarget(Vector4f _target){
		target = _target;
		target.w = 1.0;
		updateDir();
	}

	void setUpDir(Vector4f _up){
		up = _up;
		up.w = 0.0;
		updateDir();
	}

	void viewTranslation(){
		Matrix4x4 mat = viewMatrix();
		cameraViewPos = mat.mult(pos);
		cameraViewXDir = mat.mult(xDir);
		cameraViewYDir = mat.mult(yDir);
		cameraViewZDir = mat.mult(zDir);

	}

	Matrix4x4 viewMatrix(){
		Matrix4x4 view = new Matrix4x4();
		Vector4f posVec = new Vector4f(pos);
		posVec.w = 0.0;
		view.a[0][0] = xDir.x;	view.a[0][1] = xDir.y;	view.a[0][2] = xDir.z;	view.a[0][3] = -posVec.dot(xDir);
		view.a[1][0] = yDir.x;	view.a[1][1] = yDir.y;	view.a[1][2] = yDir.z;	view.a[1][3] = -posVec.dot(yDir);
		view.a[2][0] = zDir.x;	view.a[2][1] = zDir.y;	view.a[2][2] = zDir.z;	view.a[2][3] = -posVec.dot(zDir);
		view.a[3][0] = 0;		view.a[3][1] = 0;		view.a[3][2] = 0;		view.a[3][3] = 1;
		return view;
	}

	void draw(){
		strokeWeight(3.0);
		point(pos.x, pos.y, pos.z);

		stroke(127, 0, 0);
		line(pos.x, pos.y, pos.z, pos.x+20*xDir.x, pos.y+20*xDir.y, pos.z+20*xDir.z);
		stroke(0, 127, 0);
		line(pos.x, pos.y, pos.z, pos.x+20*yDir.x, pos.y+20*yDir.y, pos.z+20*yDir.z);
		stroke(0, 0, 127);
		line(pos.x, pos.y, pos.z, pos.x+20*zDir.x, pos.y+20*zDir.y, pos.z+20*zDir.z);
	}

	void drawTranslated(){
		strokeWeight(3.0);
		point(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z);

		stroke(255, 0, 0);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewXDir.x, cameraViewPos.y+20*cameraViewXDir.y, cameraViewPos.z+20*cameraViewXDir.z);
		stroke(0, 255, 0);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewYDir.x, cameraViewPos.y+20*cameraViewYDir.y, cameraViewPos.z+20*cameraViewYDir.z);
		stroke(0, 0, 255);
		line(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z,
			 cameraViewPos.x+20*cameraViewZDir.x, cameraViewPos.y+20*cameraViewZDir.y, cameraViewPos.z+20*cameraViewZDir.z);
	}
};