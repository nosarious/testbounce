import hypermedia.video.*;

OpenCV opencv;

import SimpleOpenNI.*;

PImage backdrop, test;
SimpleOpenNI  context;

// stuff for the particles
    import pbox2d.*;
    import org.jbox2d.collision.shapes.*;
    import org.jbox2d.common.*;
    import org.jbox2d.dynamics.*;
    import org.jbox2d.dynamics.*;
    
    // A reference to our box2d world
    PBox2D box2d;

// An ArrayList of particles that will fall on the surface
    ArrayList<Particle> particles;
    
// A list we'll use to track fixed objects
    ArrayList boundaries;

// for the images of logos
    String[] filenames;
    String fullPath = "/Users/nosarious/Documents/Processing/logos2"; // use forward slashes
    PImage[] logos;
    int counter = 0;
    boolean firstRun = true;
    
    // An object to store information about the uneven surface
    Surface surface;
    
    float ratioX, ratioY;
    
    int magAttract = 0;

void setup()
{
  
  opencv = new OpenCV(this);
  
  context = new SimpleOpenNI(this);
  
  context.setMirror(true);
  
  // enable depthMap generation
  if(context.enableScene() == false)
  {
     println("Can't open the sceneMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // stuff about the box information
   // Initialize box2d physics and create the world
      box2d = new PBox2D(this);
      box2d.createWorld();
      // We are setting a custom gravity
      box2d.setGravity(0, -2);
    
      // Create the empty list
      particles = new ArrayList<Particle>();
      // Create the surface
      surface = new Surface();
      
//  background(200,0,0);
//  size(context.sceneWidth() , context.sceneHeight()); 
    size(screen.width,screen.height);
  opencv.allocate(width,height);
  
  ratioX = float(screen.width)/float(640);  
  ratioY = float(screen.height)/float(480);
  
  println(ratioX+" "+ratioY);
  //background(bg);
  backdrop = loadImage ("backdrop1.jpg");
  
  filenames = loadFilenames(fullPath);
  logos = new PImage[counter];
  println("There are "+counter+" images");
  
    // Add a bunch of fixed boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height-10,0));
  boundaries.add(new Boundary(5,height/2,10,height-10,0));
  
}

void draw()
{
    if (firstRun){
      for (int i=1;i<(counter-1);i++){
        image (loadImage(filenames[i]),0,0);
        if (filenames[i] != null){
            test = loadImage(filenames[i]);
            logos[i] = test;
            float sz = random(2,6);
            particles.add(new Particle(width/2,height/2,sz,i));
          }
      }
      firstRun = false;
    }
    
  
  // update the cam
  context.update(); 
  
  opencv.copy(context.sceneImage());  
  
  opencv.blur( OpenCV.BLUR, 5 );
   
  image(backdrop,0,0);
  
  // find blobs
    Blob[] blobs = opencv.blobs( 10, width*height/2, 100, false, OpenCV.MAX_VERTICES*2 );

    // draw blob results
    for( int i=0; i<blobs.length; i++ ) {
        strokeWeight(2);
        stroke(0);
        fill(100);
        
        ArrayList<Vec2> surface;
        surface = new ArrayList<Vec2>();
        
        // This is what box2d uses to put the surface in its world
        ChainShape chain = new ChainShape();
        
        float theta = 0;
        // Store the vertex in screen coordinates
         //     surface.add(new Vec2(x,y));
        // Build an array of vertices in Box2D coordinates
        // from the ArrayList we made
            
            
        beginShape();
        for( int j=0; j<blobs[i].points.length; j++ ) {
            vertex( blobs[i].points[j].x*ratioX, blobs[i].points[j].y*ratioY );
            surface.add(new Vec2(blobs[i].points[j].x*ratioX, blobs[i].points[j].y*ratioY));
        }
        endShape(CLOSE);
        strokeWeight(1);
        stroke(255);
        
        magAttract += 1;
        float massX = float(blobs[i].centroid.x);
        
        float massY = float(blobs[i].centroid.y);
          // Draw all particles
        for (Particle p: particles) {
          p.display();
          if (magAttract > 100) {
                
               magAttract = 0;
               p.attract(massX, massY);
          }
        }
        
            // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made

            Vec2[] vertices = new Vec2[blobs[i].points.length];
      for (int ii = 0; ii < vertices.length; ii++) {
        Vec2 edge = box2d.coordPixelsToWorld(surface.get(ii));
        vertices[ii] = edge;
      }
          // Create the chain!
      chain.createChain(vertices,vertices.length);
  
      // The edge chain is now attached to a body via a fixture
      BodyDef bd = new BodyDef();
      bd.position.set(0.0f,0.0f);
      Body body = box2d.createBody(bd);
      // Shortcut, we could define a fixture if we
      // want to specify frictions, restitution, etc.
      body.createFixture(chain,1);
    }
    

    // // gives you a label map, 0 = no person, 0+n = person n
    // int[] map = new int[context.sceneWidth() * context.sceneHeight()];
    // context.sceneMap(map);
    
    // // get the floor plane
    // PVector point = new PVector();
    // PVector normal = new PVector();
    // context.getSceneFloor(point,normal);
/*
      // If the mouse is pressed, we make new particles
  if (random(1) < 0.5) {
    float sz = random(2,6);
    particles.add(new Particle(width/2,10,sz));
  }
*/
  // We must always step through time!
  box2d.step();

  // Draw all particles
  for (Particle p: particles) {
    p.display();
  }

  // Particles that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
  //    particles.remove(i);
    }
  }


}
