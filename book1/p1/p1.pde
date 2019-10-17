/* PROGRAM */

static final color RED = color(216, 34, 0),
                   YELLOW = color(253, 156, 0),
                   BLUE = color(0, 34, 85),
                   BLACK = color(0);

static final float S60 = sin(60 * PI / 180.0),   
                   C60 = cos(60 * PI / 180.0),
                   
                   LINE_OPACITY = 220;

coord a, b, c;       
String dragging;

void setup() {
  size(window.innerWidth, window.innerHeight); 
  
  a = new coord(width*0.65, height*0.5);
  b = new coord(width*0.75, height*0.55);
  c = new coord(C60 * (a.x - b.x) - S60 * (a.y - b.y) + b.x,
                S60 * (a.x - b.x) + C60 * (a.y - b.y) + b.y);
                
  dragging = "";
}

void drawPoints() {
  a.drawPoint();
  b.drawPoint();
}

void connectPoints() {
  a.connect(c, YELLOW);
  b.connect(c, RED);
  a.connect(b, BLACK);
}

void getNewPositions() {
  if (dragging.equals("a")) {
    a.setToMousePosition();
  } else if (dragging.equals("b")) {
    b.setToMousePosition();
  }
}

coord getThirdEquiCoord(coord c1, coord c2){
  return new coord(C60 * (c2.x - c1.x) - S60 * (c2.y - c1.y) + c1.x,
                   S60 * (c2.x - c1.x) + C60 * (c2.y - c1.y) + c1.y);
}

void constrainProportions() {
  if (dragging.equals("a") || dragging.equals("b")) {
    c = getThirdEquiCoord(b, a);
  }
}

void drawCircles() {
  float radiusAB = a.distance(b);
  a.drawCircle(radiusAB, BLUE);
  b.drawCircle(radiusAB, RED);
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
}
