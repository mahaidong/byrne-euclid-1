/* PROGRAM */

static final color RED = color(216, 34, 0),
                   YELLOW = color(253, 156, 0),
                   BLUE = color(0, 34, 85),
                   BLACK = color(0);

static final float S60 = sin(60 * PI / 180.0),   
                   C60 = cos(60 * PI / 180.0),
                   
                   LINE_OPACITY = 220;

coord a, b, c, d, e, f;       
String dragging;

void setup() {
  size(window.innerWidth, window.innerHeight); 
  
  a = new coord(width*0.65, height*0.58);   // THE FIRST POINT OF THE GIVEN LINE
  b = new coord(width*0.70, height*0.48);  // THE GIVEN POINT
  c = new coord(C60 * (a.x - b.x) - S60 * (a.y - b.y) + b.x,
                S60 * (a.x - b.x) + C60 * (a.y - b.y) + b.y);
                
  d = new coord(width*0.58, height*0.54); // THE SECOND POINT OF THE GIVEN LINE
  
  e = new coord(a.x + (a.x - c.x) / a.distance(c) * a.distance(d),
                a.y + (a.y - c.y) / a.distance(c) * a.distance(d));  // YELLOW LINE ENDPOINT
  
  f = new coord(b.x + (b.x - c.x) / b.distance(c) * a.distance(e),
                b.y + (b.y - c.y) / b.distance(c) * a.distance(e));  // YELLOW LINE ENDPOINT
                
  dragging = "";
}

void drawPoints() {
  a.drawPoint();
  b.drawPoint();
  //c.drawPoint();
  d.drawPoint();
  //e.drawPoint();
}

void connectPoints() {  
  a.connect(c, RED);
  b.connect(c, RED);
  a.connect(b, BLACK); // SHOULD BE DASHED. INVESTIGATE.
  a.connect(d, BLACK);
  a.connect(e, YELLOW);
  b.connect(f, BLUE);
}

void getNewPositions() {
  if (dragging.equals("a")) {
    a.setToMousePosition();
  } else if (dragging.equals("b")) {
    b.setToMousePosition();
  } else if (dragging.equals("d")) {
    d.setToMousePosition();
  }
}

coord getThirdEquiCoord(coord c1, coord c2){
  return new coord(C60 * (c2.x - c1.x) - S60 * (c2.y - c1.y) + c1.x,
                   S60 * (c2.x - c1.x) + C60 * (c2.y - c1.y) + c1.y);
}

void constrainProportions() {
  if (dragging.equals("a") || dragging.equals("b")) {
    c = getThirdEquiCoord(b, a);
    
    e.x = a.x + (a.x - c.x) / a.distance(c) * a.distance(d);
    e.y = a.y + (a.y - c.y) / a.distance(c) * a.distance(d); // YELLOW LINE ENDPOINT
    
    f.x = b.x + (b.x - c.x) / b.distance(c) * a.distance(e);    
    f.y = b.y + (b.y - c.y) / b.distance(c) * a.distance(e); // BLUE LINE ENDPOINT
    
  } else if (dragging.equals("d")) {
    a = getThirdEquiCoord(c, b);
    
    e.x = a.x + (a.x - c.x) / a.distance(c) * a.distance(d);
    e.y = a.y + (a.y - c.y) / a.distance(c) * a.distance(d); // YELLOW LINE ENDPOINT
    
    f.x = b.x + (b.x - c.x) / b.distance(c) * a.distance(e);    
    f.y = b.y + (b.y - c.y) / b.distance(c) * a.distance(e); // BLUE LINE ENDPOINT
  
  }
}

void drawCircles() {
  float radiusAD = a.distance(d);
  float radiusCF = c.distance(f);
  
  a.drawCircle(radiusAD, BLUE);
  c.drawCircle(radiusCF, RED);
  
}

void draw() {
  size(window.innerWidth, window.innerHeight);
  background(0, 0, 0, 0);
  getNewPositions();
  constrainProportions();
  connectPoints();
  drawCircles();
  drawPoints(); 
}

void mousePressed() {
  coord clickPos = new coord(mouseX, mouseY);
  if (a.inClickRadius()) {
    dragging = "a";
  } else if (b.inClickRadius()) {
    dragging = "b";
  } else if (c.inClickRadius()) {
    dragging = "c";
  } else if (d.inClickRadius()) {
    dragging = "d";
  }
}

void mouseReleased() {
  dragging = "";
}

/* CLASSES */

class coord {
  static final float POINT_SIZE = 9,
                     CLICK_RADIUS = 10,
                     LINE_WIDTH = 5,
                     LINE_OPACITY = 220;
                     
  float x, y;
  
  coord(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void connect(coord c, color col) { // drawing a line between two coordinates
    stroke(col, LINE_OPACITY);
    strokeWeight(LINE_WIDTH);
    line(x, y, c.x, c.y);
  }
  
  void drawPoint() { // white & opaque
    stroke(255);
    strokeWeight(POINT_SIZE);
    point(x, y);
  }
  
  boolean inClickRadius() {
    float diff_x = x - mouseX;
    float diff_y = y - mouseY;
    
    return diff_x * diff_x + diff_y * diff_y < CLICK_RADIUS * CLICK_RADIUS;
  }
  
  void setToMousePosition() {
    x = mouseX;
    y = mouseY;
  }
  
  float distance(coord c) {
    return dist(x, y, c.x, c.y);
  }
  
  void drawCircle(float radius, color col) {
    noFill();
    stroke(col, LINE_OPACITY);
    ellipse(x, y, radius*2, radius*2);
  }
  
  float getSlope(coord c) {
    return (c.y - y) / (c.x - x);
  }
}
