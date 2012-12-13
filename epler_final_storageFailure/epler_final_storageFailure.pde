// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://sourceforge.net/projects/glgraphics/
import codeanticode.glgraphics.*;
Globals globals;

import peasy.*;
PeasyCam cam;

ArrayList<Cube> allCubes = new ArrayList();
int gridSize = 7;
int cubeSize = 10;
int barWidth = 5;

ArrayList<TMesh> lightBalls = new ArrayList();
ArrayList<Value> values = new ArrayList();
int direction = 1;  // 0=down, 1=up, 2=left, 3=right, 4=front, 5=back


void setup() {
  size( 500, 500,GLConstants.GLGRAPHICS ); 
  globals = new Globals( this );
  
  noStroke();
  fill( 100 );

  cam = new PeasyCam(this, 100);
  cam.lookAt( (gridSize/2)*cubeSize, (gridSize/2)*cubeSize, (gridSize/2)*cubeSize );

  // create cubes
  for ( int x = 0; x < gridSize; x++ )
  {
    for ( int y = 0; y < gridSize; y++ )
    {
      for ( int z = 0; z < gridSize; z++ )
      {
        PVector currPos = new PVector();
        currPos.x = x * cubeSize; 
        currPos.y = y * cubeSize;
        currPos.z = z * cubeSize;
        Cube newCube = new Cube( currPos );
        allCubes.add( newCube );
      }
    }
  } 

  // make an array of light balls
  TMeshFactory meshFactory = new TMeshFactory( globals );
  for ( int i = 0; i < 5; i++ )
  {
    TMesh lightMesh = meshFactory.createSphere( 6, 6, 2 );
    int ranNum = floor( random( 0, allCubes.size() ) );
    Cube thisCube = allCubes.get( ranNum );
    PVector ranCenter = (PVector) thisCube.center;
    lightMesh.setPosition( ranCenter );
    lightMesh.direction = floor( random( 0, 6 ) );
    lightBalls.add( lightMesh );
    if ( i > 0 )
    {
      TMesh prevMesh = lightBalls.get ( i - 1 );
      lightMesh.setParent( prevMesh );
    }
  }
}

void draw() {
  globals.mRenderer.beginGL();
  background( 0 );

  resetValues();
  PVector currPos = new PVector();
  for( TMesh lightMesh : lightBalls )
  {
    currPos = lightMesh.getPosition();
    //drawRefs( currPos );
    stroke( 255 );
    lightMesh.draw();
    pointLight( 255, 255, 255, currPos.x, currPos.y, currPos.z );
    
    fill( 0, 0, 50 );
    noStroke();
    for ( Cube c : allCubes )
    {
      c.draw();
      if ( dist( c.center.x, c.center.y, c.center.z, currPos.x, currPos.y, currPos.z ) < 1 )
      {
        int checkEdges = checkEdge( currPos );
      
        int ranNum = floor( random( 0, 6 ) );
        Value thisValue = (Value) values.get( ranNum );
        lightMesh.direction = (int) thisValue.num;
        resetValues();
        }
    }
    updatePosition( lightMesh, currPos, lightMesh.direction );
  }  
  globals.mRenderer.endGL();
}


void updatePosition( TMesh _lightMesh, PVector _currPos, int _dir ) // 0=down, 1=up, 2=left, 3=right, 4=front, 5=back
{ 
  stroke( 255 );
  
  switch( _dir )
  {
  case 0:
    _lightMesh.setPosition( new PVector( _currPos.x, _currPos.y + 1, _currPos.z ) );
    break;
  case 1:
    _lightMesh.setPosition( new PVector( _currPos.x, _currPos.y - 1, _currPos.z ) );
    break;
  case 2:
    _lightMesh.setPosition( new PVector( _currPos.x - 1, _currPos.y, _currPos.z ) );
    break;
  case 3:
    _lightMesh.setPosition( new PVector( _currPos.x  + 1, _currPos.y, _currPos.z ) );
    break;
  case 4:
    _lightMesh.setPosition( new PVector( _currPos.x, _currPos.y, _currPos.z  + 1 ) );
    break;
  case 5:
    _lightMesh.setPosition( new PVector( _currPos.x, _currPos.y, _currPos.z  - 1 ) );
    break;
  case 6:
    break;
  } 
}


int checkEdge( PVector currPos ) // 0=down, 1=up, 2=left, 3=right, 4=front, 5=back
{

  if ( zeroMargin( currPos.x ) && zeroMargin( currPos.y ) && zeroMargin( currPos.z ) )      // at a TOP CORNER edge (A)
  { 
    println( "CORNER A" );
    int[] badValues = {1, 2, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) && zeroMargin( currPos.y ) && limitMargin( currPos.z ) ) 
  { 
    println( "CORNER B" );
    int[] badValues = {1, 2, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && zeroMargin( currPos.y ) && limitMargin( currPos.z ) ) 
  { 
    println( "CORNER C" );
    int[] badValues = {1, 3, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && zeroMargin( currPos.y ) && zeroMargin( currPos.z ) )
  { 
    println( "CORNER D" );
    int[] badValues = {1, 3, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) && limitMargin( currPos.y ) && zeroMargin( currPos.z ) ) // at a BOTTOM CORNER edge
  { 
    println( "CORNER E" );
    int[] badValues = {0, 2, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) && limitMargin( currPos.y ) && limitMargin( currPos.z ) )
  { 
    println( "CORNER F" );
    int[] badValues = {0, 2, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && limitMargin( currPos.y ) && limitMargin( currPos.z ) )
  { 
    println( "CORNER G" );
    int[] badValues = {0, 3, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && limitMargin( currPos.y ) && zeroMargin( currPos.z ) )
  { 
    println( "CORNER H" );
    int[] badValues = {0, 3, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.y ) && zeroMargin( currPos.x ) )                     // at an edge in 2 directions @ TOP
  { 
    println( "EDGE 1" );
    int[] badValues = {1, 2};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.y ) && limitMargin( currPos.z ) )
  { 
    println( "EDGE 2" );
    int[] badValues = {1, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.y ) && limitMargin( currPos.x ) )
  { 
    println( "EDGE 3" );
    int[] badValues = {1, 3};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.y ) && zeroMargin( currPos.z ) )
  { 
    println( "EDGE 4" );
    int[] badValues = {1, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.y ) && zeroMargin( currPos.x ) )   // at an edge in 2 directions @ BOTTOM
  { 
    println( "EDGE 5" );
    int[] badValues = {0, 2};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.y ) && limitMargin( currPos.z ) )
  { 
    println( "EDGE 6" );
    int[] badValues = {0, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.y ) && limitMargin( currPos.x ) )
  { 
    println( "EDGE 7" );
    int[] badValues = {0, 3};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.y ) && zeroMargin( currPos.z ) )
  { 
    println( "EDGE 8" );
    int[] badValues = {0, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) && zeroMargin( currPos.z ) )                     // at an edge in 2 directions on VERTICAL
  { 
    println( "EDGE 9" );
    int[] badValues = {2, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) && limitMargin( currPos.z ) )
  { 
    println( "EDGE 10" );
    int[] badValues = {2, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && limitMargin( currPos.z ) )
  { 
    println( "EDGE 11" );
    int[] badValues = {3, 4};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) && zeroMargin( currPos.z ) )
  { 
    println( "EDGE 12" );
    int[] badValues = {3, 5};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.y ) )                   // at an edge in 1 direction
  { 
    println( "BOTTOM FACE" );
    int[] badValues = {0};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.y ) )
  { 
    println( "TOP FACE" );
    int[] badValues = {1};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.x ) ) 
  { 
    println( "LEFT FACE" );
    int[] badValues = {2};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.x ) )
  { 
    println( "RIGHT FACE" );
    int[] badValues = {3};
    removeValues( badValues );
    return 1;
  }  

  if ( limitMargin( currPos.z ) )
  { 
    println( "BACK FACE" );
    int[] badValues = {4};
    removeValues( badValues );
    return 1;
  }  

  if ( zeroMargin( currPos.z ) )
  { 
    println( "FRONT FACE" );
    int[] badValues = {5};
    removeValues( badValues );
    return 1;
  } 
  return 0;
  // 0=down, 1=up, 2=left, 3=right, 4=front, 5=back
}

boolean zeroMargin( float f )
{
  if ( f < 0.5 )
  {
    return true;
  } 
  else {
    return false;
  }
}

boolean limitMargin( float f )
{
  if ( (cubeSize * gridSize) - f  < 0.5 )
  {
    return true;
  } 
  else {
    return false;
  }
}


void removeValues( int[] badValues )
{
  for ( int i = 0; i < badValues.length; i++ )
  {
    for ( int j = 0; j < values.size(); j++ )
    {
      Value thisValue = values.get( j );
      if ( thisValue.num == badValues[i] ) {
        thisValue.num = 6; // will do nothing since
      }
    }
  }
}


void resetValues()
{
  values.clear();
  for ( int i = 0; i < 6; i++ )
  {
    Value newValue = new Value( i );
    values.add( newValue );
  } 
}


void drawRefs( PVector currPos )
{
  // at 0, 0, 0
  stroke( 255, 0, 0 );
  line( 0, 0, 0, 75, 0, 0 );
  stroke( 0, 255, 0 );
  line( 0, 0, 0, 0, 75, 0 );
  stroke( 0, 0, 255 );
  line( 0, 0, 0, 0, 0, 75 );

  // at light object
  stroke( 255, 0, 0 );
  line( currPos.x, currPos.y, currPos.z, currPos.x + 25, currPos.y, currPos.z );
  stroke( 0, 255, 0 );
  line( currPos.x, currPos.y, currPos.z, currPos.x, currPos.y  + 25, currPos.z );
  stroke( 0, 0, 255 );
  line( currPos.x, currPos.y, currPos.z, currPos.x, currPos.y, currPos.z  + 25 );
}

