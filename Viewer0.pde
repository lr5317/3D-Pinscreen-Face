/*
 * Barebones 3D viewer
 * Face Data set: http://tosca.cs.technion.ac.il/data/face.zip
 * Jama: http://math.nist.gov/javanumerics/jama/doc/
 *
 */

//Author: Lilly Reich 




import Jama.*;

Matrix [] vertices = new Matrix[3000];
void loadPoints() {
  String [] lines = loadStrings("face00.vert");
  for (int i = 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], ' ');
    vertices[i] = new Matrix(4, 1);
    vertices[i].set(0, 0, float(pieces[0]));
    vertices[i].set(1, 0, float(pieces[1]));
    vertices[i].set(2, 0, float(pieces[2]));
    vertices[i].set(3, 0, 1);
  }
}

void setup() {
  //size(800, 600, P2D);
  size(800, 600, P3D);
  fill(255);
  stroke(255);
  loadPoints();
}


//float phi = 0; 
//float y = 0; 
//float theta = 0; 

boolean orthographic = true;
boolean perspective = false;
void draw() {
  translate(width/2, height/2);


  //float theta = 0; 
  //int sx = 300;
  //int sy = 300;
  double [][]ecam = {
    {
      1.0, 0, 0, 0,
    }
    , 
    {
      0, 1.0, 0, 0,
    }
    , 
    {
      0, 0, 1.0, 0
    }
  };

  double [] [] rotationMatrixZ = {
    {
      cos(phi), -sin(phi), 0, 0,
    }
    , 
    {
      sin(phi), cos(phi), 0, 0
    }
    , 
    {
      0, 0, 1, 0,
    }
    , 
    {
      0, 0, 0, 1
    }
  };

  double [] [] rotationMatrixY = {
    {
      cos(y), 0, sin(y), 0,
    }
    , 
    {

      0, 1, 0, 0,
    }
    , 
    {
      -sin(y), 0, cos(y), 0,
    }
    , 
    {
      0, 0, 0, 1
    }
  }; 

  double [][] rotationMatrixX = {
    {
      1, 0, 0, 0,
    }
    , 
    {
      0, cos(theta), -sin(theta), 0,
    }
    , 
    {
      0, sin(theta), cos(theta), 0,
    }
    , 
    {
      0, 0, 0, 1
    }
  }; 

  Matrix rotationZ = new Matrix(rotationMatrixZ);  
  Matrix rotationY = new Matrix(rotationMatrixY); 
  Matrix rotationX = new Matrix (rotationMatrixX); 

  Matrix exC = rotationZ.times(rotationY.times(rotationX));

  double [][]icam = {
    {
      sx, 0, 0, 0
    }
    , 
    {
      0, sy, 0, 0
    }
    , 
    {
      0, 0, 1, 0
    }
  }; 
  
  double [] [] icam2 ={ //implement orthography and this will be a boolean
    {
      sx, 0,0,0
    }
    ,
    {
      0, sy, 0 , 0
    }
    ,
    {
      0, 0, 0,1
    }
  };
     

  background(0);
  //Matrix exC = new Matrix(ecam);
  Matrix inC = new Matrix(icam); 


  if (perspective == true) {
    inC = new Matrix(icam);
  } else {
    if (orthographic == false) {
      inC  = new Matrix(icam2);
    }
  }





  //draw vertices
  fill(255);
  noStroke();
  for (Matrix v : vertices) {
    if (v != null) {
      Matrix t = inC.times(exC.times(v));
      //fill(map(abs((float)v.get(2, 0)), 0, 5, 0, 255));
      ellipse((float)(t.get(0, 0)/t.get(2, 0)), (float)(t.get(1, 0)/t.get(2, 0)), 3, 3);
    }
  }
}

// create orthographic and perspective projections 
// look at handout 

// use mousePressed() to navigate between perspective and orthoganal 
// you are  rotating the camera 
// use a boolean 


float phi = 0;
float y = 0; 
float theta = 0; 



int sx = 300;
int sy = 300; 
void keyPressed() { 
  //rotate
  if (key == 's') { //scale
    sx --;
    sy--;
  } else if (key == 'S') { // increment large S
    sx++;
    sy++;
  } else if (key == 'i') { // phi 
    phi--;
  } else if (key == 'I') { // large phi
    phi++;
  } else if (key == 'y') { // y 
    y--;
  } else if (key == 'Y') { // large Y
    y++;
  } else if (key == 't') { // theta 
    theta--;
  } else if (key == 'T') { // large theta 
    theta++;

    //if user presses key for othography "true"
    // if user does not press orthography it would be "false"
  }else if((key == 'p') || (key =='P')){
    orthographic = false; 
  }else if ((key =='o')|| (key =='O')){
    orthographic = true;
    //perspective = false;
  }
}
