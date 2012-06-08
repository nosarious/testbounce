// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  int number;

  Particle(float x, float y, float r_, int number_) {
    r = r_;
    number = number_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r,number);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2){
       pos.y = pos.y -r*3;
    } else if( pos.y< r*2){
       pos.y = pos.y +r*3;
    } 
    
    if (pos.x > width+r*2){
       pos.x = pos.x -r*3;
    } else if( pos.x< r*2){
       pos.x = pos.x +r*3;
    }  
    
    
      return true;
   //   killBody();
  //    return true;
  //  }
  //  return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
//    fill(175);
//    stroke(0);
//    strokeWeight(0);
//    ellipse(0,0,r*2,r*2);
//    rect(0,0,50,50);
    // Let's add a line so we can see the rotation
//    line(0,0,r,0);
    image(logos[number],0,0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r, int number) {
    /*
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);
*/
    //define a polygon (what we use for a rectangle
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(50);
    float box2dH = box2d.scalarPixelsToWorld(50);
    
    sd.setAsBox(box2dW,box2dH);
    // Make the body's shape a circle
//    CircleShape cs = new CircleShape();
//    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 2.5;
    fd.friction = 0.5;
    fd.restitution = 0.9;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.world.createBody(bd);
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    body.setAngularVelocity(random(-5,5));
  }
  
 void attract(float x,float y) {
    // From BoxWrap2D example
    Vec2 worldTarget = box2d.coordPixelsToWorld(x,y);   
    Vec2 bodyVec = body.getWorldCenter();
    // First find the vector going from this body to the specified point
    worldTarget.subLocal(bodyVec);
    // Then, scale the vector to the specified force
    worldTarget.normalize();
    worldTarget.mulLocal((float) 50);
    // Now apply it to the body's center of mass.
    body.applyForce(worldTarget, bodyVec);
  }
}


