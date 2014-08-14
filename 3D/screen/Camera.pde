class Camera{
	Vector4f xDir, yDir, zDir;
	Vector4f pos; // world position of camera
	Vector4f up; // upper direction, not camera's yDir but on the z-y plane
	Vector4f target;

	float fov; // angle of view for x axis, meaning fovX
	float near;
	float far;
	float aspect; // height/width

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

	void setFov(float _fov){
		fov = _fov;
		aspect = (float)height/(float)width;
	}
	void setNear(float _near){
		near = _near;
	}

	void setFar(float _far){
		far = _far;
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

	Matrix4x4 projectionMatrix(){
		Matrix4x4 proj = new Matrix4x4();
		proj.a[0][0] = 1.0/tan(fov/2);
		proj.a[1][1] = 1.0/(aspect*tan(fov/2));
		proj.a[2][2] = far/(far-near);
		proj.a[2][3] = -far*near/(far-near);
		proj.a[3][2] = 1.0;
		proj.a[3][3] = 0.0;
		return proj;
	}

	Matrix4x4 screenMatrix(){
		Matrix4x4 mat = new Matrix4x4();
		mat.a[0][0] = width/2;		mat.a[0][3] = width/2;
		mat.a[1][1] = -height/2;	mat.a[1][3] = height/2;
		return mat;
	}

	void draw(){
		strokeWeight(5.0);
		point(pos.x, pos.y, pos.z);

		Vector4f nearCenter = Vector4f.add(pos, Vector4f.mult(zDir, near));
		Vector4f farCenter = Vector4f.add(pos, Vector4f.mult(zDir, far));
		float len_nearX = near*tan(fov/2);
		float len_farX  = far*tan(fov/2);
		Vector4f nearX = Vector4f.mult(xDir, len_nearX);
		Vector4f nearY = Vector4f.mult(yDir, aspect*len_nearX);
		Vector4f farX  = Vector4f.mult(xDir, len_farX);
		Vector4f farY  = Vector4f.mult(yDir, aspect*len_farX);

		strokeWeight(0.5);
		Cube view = new Cube(1.0);
		view.world[0] = Vector4f.add(Vector4f.add(farCenter, farX), farY);
		view.world[1] = Vector4f.sub(Vector4f.add(farCenter, farX), farY);
		view.world[2] = Vector4f.sub(Vector4f.sub(farCenter, farX), farY);
		view.world[3] = Vector4f.add(Vector4f.sub(farCenter, farX), farY);

		view.world[4] = Vector4f.add(Vector4f.add(nearCenter, nearX), nearY);
		view.world[5] = Vector4f.sub(Vector4f.add(nearCenter, nearX), nearY);
		view.world[6] = Vector4f.sub(Vector4f.sub(nearCenter, nearX), nearY);
		view.world[7] = Vector4f.add(Vector4f.sub(nearCenter, nearX), nearY);
		view.drawWorld();
	}

	void drawTranslated(){
		strokeWeight(3.0);
		point(cameraViewPos.x, cameraViewPos.y, cameraViewPos.z);

		Vector4f nearCenter = Vector4f.add(cameraViewPos, Vector4f.mult(cameraViewZDir, near));
		Vector4f farCenter = Vector4f.add(cameraViewPos, Vector4f.mult(cameraViewZDir, far));
		float len_nearX = near*tan(fov/2);
		float len_farX  = far*tan(fov/2);
		Vector4f nearX = Vector4f.mult(cameraViewXDir, len_nearX);
		Vector4f nearY = Vector4f.mult(cameraViewYDir, aspect*len_nearX);
		Vector4f farX  = Vector4f.mult(cameraViewXDir, len_farX);
		Vector4f farY  = Vector4f.mult(cameraViewYDir, aspect*len_farX);

		strokeWeight(0.5);
		Cube view = new Cube(1.0);
		view.world[0] = Vector4f.add(Vector4f.add(farCenter, farX), farY);
		view.world[1] = Vector4f.sub(Vector4f.add(farCenter, farX), farY);
		view.world[2] = Vector4f.sub(Vector4f.sub(farCenter, farX), farY);
		view.world[3] = Vector4f.add(Vector4f.sub(farCenter, farX), farY);

		view.world[4] = Vector4f.add(Vector4f.add(nearCenter, nearX), nearY);
		view.world[5] = Vector4f.sub(Vector4f.add(nearCenter, nearX), nearY);
		view.world[6] = Vector4f.sub(Vector4f.sub(nearCenter, nearX), nearY);
		view.world[7] = Vector4f.add(Vector4f.sub(nearCenter, nearX), nearY);
		view.drawWorld();
	}
};