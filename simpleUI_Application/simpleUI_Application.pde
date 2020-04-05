import g4p_controls.*;
import java.io.File;
import java.awt.Rectangle;
import java.util.ArrayList;
import java.awt.Color;


/**** Datatypes Declartion ****/
PImage img; //Main image
PImage editedImg; //The image that handles effects
SimpleUI UI;
int imgWidth, imgHeight;






/**** Image effects matrix ****/
float[][] edgeDetection = {{ -1, -1, -1}, 
                          { -1,  9, -1}, 
                          { -1, -1, -1}};
                          
float[][] blur = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                   { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                   { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                   { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                   { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                   { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                   { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}};
                                  
float[][] sharpen = {  { 0, -1, 0 },
                       {-1, 5, -1 },
                       { 0, -1, 0 } };                                  


/*public static class RGBtoHSB{
   public static void conversion(){
    int red = 51; 
    int green = 102;  
    int blue = 153;
    float hsb[] = Color.RGBtoHSB(red, green, blue, null); 
    
    float hue = hsb[0];
    float saturation = hsb[1];
    float brightness = hsb[2];
    
    hue = hue * 60;
   if( hue < 0 ) hue += 360;
    
    println("RGB [" + red + "," + green + "," + blue + "] converted to HSB ["+ hue + "," + saturation + "," + brightness + "]");
   }
}*/

//Setup function 
void setup(){
   size(1000,800);
   background(245);
   createGUI();
   UI = new SimpleUI(); //Instantiate UI

   

/******* GUI Design **********/
UI.addCanvas(250,70,700,650);


}


//Drawing Function 
void draw(){
  
  UI.update();
  if(img != null){
    image(img,250,70);
    img.resize(700,650); //Ensures the image is within the canvas
    img.loadPixels();
  }
  if(editedImg != null){
    image(editedImg, 250, 70);
    editedImg.resize(700,650);
    img.loadPixels();
  }
} 



//Function to handle user interface events (e.g. buttons pressed)
void handleUIEvent(UIEventData uied){
  uied.print(3);
 
  
   //This handles the loading of images into the panel   
  if(uied.eventIsFromWidget("fileLoadDialog"))
  {
    img = loadImage(uied.fileSelection);
  }
  //This handles the saving of images into the panel
  if(uied.eventIsFromWidget("fileSaveDialog")){
    img = editedImg; //Ensures that the effects applied is being saved
    img.save(uied.fileSelection);
  }
  else 
    return;
  
}


//Responsible for manipulating visual effects on the loaded image
color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

/***************** RGB TO HSV    *********************/
float[] RGBtoHSV(float r, float g, float b){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
    
    
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
    // saturation is the difference between the smallest R,G or B value, and the biggest
      saturation = delta / maxRGB; }
   else { // it’s black, so we don’t know the hue
       return returnVals;
       }
       
  if(delta == 0){ 
         hue = 0;
        }
   else {
    // now work out the hue by finding out where it lies on the spectrum
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   // between magenta, blue, cyan
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   // between cyan, green, yellow
      if( r == maxRGB ) hue = ( g - b ) / delta;       // between yellow, Red, magenta
      
    }
  // the above produce a hue in the range -6...6, 
  // where 0 is magenta, 1 is red, 2 is yellow, 3 is green, 4 is cyan, 5 is blue and 6 is back to magenta 
  // Multiply the above by 60 to give degrees
   hue = hue * 60;
   if( hue < 0 ) hue += 360;

   
   
   returnVals[0] = hue;
   returnVals[1] = saturation;
   returnVals[2] = value;
   
   return returnVals;
}



color HSVtoRGB(float hue, float sat, float val)
{  
  
    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);

    float r,g,b;


    switch (h) {
      case 0: r = val; g = t; b = p; break;
      case 1: r = q; g = val; b = p; break;
      case 2: r = p; g = val; b = t; break;
      case 3: r = p; g = q; b = val; break;
      case 4: r = t; g = p; b = val; break;
      case 5: r = val; g = p; b = q; break;
      default: r = val; g = t; b = p;
    }
    
    return color(r*255,g*255,b*255);
}

      
