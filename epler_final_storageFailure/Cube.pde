class Cube 
{
  
 PVector center, A, B, C, D, E, F, G, H;
 
 Cube() 
 {
 }
 
 Cube ( PVector centroid ) 
 {
  center = new PVector( centroid.x, centroid.y, centroid.z );
  setVectors();
 }
 
 void setVectors() 
 {
// --------------------------------------------- Top //
  A = new PVector( center.x - cubeSize/2, center.y - cubeSize/2, center.z + cubeSize/2 );
  B = new PVector( center.x + cubeSize/2, center.y - cubeSize/2, center.z + cubeSize/2 );
  C = new PVector( center.x + cubeSize/2, center.y - cubeSize/2, center.z - cubeSize/2 );
  D = new PVector( center.x - cubeSize/2, center.y - cubeSize/2, center.z - cubeSize/2 );
// ------------------------------------------ Bottom // 
  E = new PVector( center.x - cubeSize/2, center.y + cubeSize/2, center.z + cubeSize/2 );
  F = new PVector( center.x + cubeSize/2, center.y + cubeSize/2, center.z + cubeSize/2 );
  G = new PVector( center.x + cubeSize/2, center.y + cubeSize/2, center.z - cubeSize/2 );
  H = new PVector( center.x - cubeSize/2, center.y + cubeSize/2, center.z - cubeSize/2 );
 }
 
 
 void draw()
 {
   for( int i = 0; i < 12; i++ )
   {
     drawSingleEdge( i );
   }
 }
 
 
 void drawSingleEdge( int _i ) 
{
  switch( _i )
  {
   /*----------------------------------------------- TOP EDGES */
   case 0:
   pushMatrix();
    translate( A.x, A.y, A.z );
    translate( cubeSize/2, 0, 0 );
    box( cubeSize + barWidth, barWidth, barWidth );
   popMatrix();
   break;
  
   case 1:
   pushMatrix();
    translate( B.x, B.y, B.z );
    translate( 0, 0, -cubeSize/2 );
    box( barWidth, barWidth, cubeSize + barWidth );
   popMatrix();
   break;
  
   case 2:
   pushMatrix();
    translate( C.x, C.y, C.z );
    translate( -cubeSize/2, 0, 0 );
    box( cubeSize + barWidth, barWidth, barWidth );
   popMatrix();
   break;
  
   case 3:
   pushMatrix();
    translate( D.x, D.y, D.z );
    translate( 0, 0, cubeSize/2 );
    box( barWidth, barWidth, cubeSize + barWidth );
   popMatrix();
   break;
   
   /*-------------------------------------------- BOTTOM EDGES */
   case 4:
   pushMatrix();
    translate( E.x, E.y, E.z );
    translate( cubeSize/2, 0, 0 );
    box( cubeSize + barWidth, barWidth, barWidth );
   popMatrix();
   break;
  
   case 5:
   pushMatrix();
    translate( F.x, F.y, F.z );
    translate( 0, 0, -cubeSize/2 );
    box( barWidth, barWidth, cubeSize + barWidth );
   popMatrix();
   break;
  
   case 6:
   pushMatrix();
    translate( G.x, G.y, G.z );
    translate( -cubeSize/2, 0, 0 );
    box( cubeSize + barWidth, barWidth, barWidth );
   popMatrix();
   break;
  
   case 7:
   pushMatrix();
    translate( H.x, H.y, H.z );
    translate( 0, 0, cubeSize/2 );
    box( barWidth, barWidth, cubeSize + barWidth );
   popMatrix();
   break;
  
   /*-------------------------------------------- VERTICAL EDGES */
   case 8:
   pushMatrix();
    translate( E.x, E.y, E.z );
    translate( 0, -cubeSize/2, 0 );
    box( barWidth, cubeSize + barWidth, barWidth );
   popMatrix();
   break;
  
   case 9:
   pushMatrix();
    translate( F.x, F.y, F.z );
    translate( 0, -cubeSize/2, 0 );
    box( barWidth, cubeSize + barWidth, barWidth );
   popMatrix();
   break;
  
   case 10:
   pushMatrix();
    translate( G.x, G.y, G.z );
    translate( 0, -cubeSize/2, 0 );
    box( barWidth, cubeSize + barWidth, barWidth );
   popMatrix();
   break;
  
   case 11:
   pushMatrix();
    translate( H.x, H.y, H.z );
    translate( 0, -cubeSize/2, 0 );
    box( barWidth, cubeSize + barWidth, barWidth );
   popMatrix();
   break;
   } // end of switch
}
}

