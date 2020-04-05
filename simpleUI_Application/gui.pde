
public void openImage_click1(GButton source, GEvent event) { //_CODE_:openImage:508236:
  if(source == openImage)
  UI.openFileLoadDialog("Load an image");
  println("openImage - GButton >> GEvent." + event + " @ " + millis());
  
} //_CODE_:openImage:508236:

public void saveButton_click1(GButton source, GEvent event) { //_CODE_:saveButton:731768:
  if(source == saveButton && img != null) //Ensuring that the user doesn't get prompted with the file dialog if no images are loaded 
  UI.openFileSaveDialog("Save Image");
  println("saveButton - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:saveButton:731768:

public void zoom_slider1(GCustomSlider source, GEvent event) { //_CODE_:Zoom:757364:
  if(source == Zoom && event == GEvent.VALUE_STEADY){
    if(img != null){
       if(Zoom.getValueF() > 0){
         img.resize(700, 650);
         println("Slider steady at the following floating value "+Zoom.getValueF());
       }
    }
  }
  println("custom_slider1 - GCustomSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:Zoom:757364:

public void Blur_click1(GButton source, GEvent event) { //_CODE_:BlurEffect:759259:
if(source == BlurEffect){
   if(img != null){
     editedImg = createImage(img.width, img.height, RGB);
     img.loadPixels();
     int matrixSize = 7;
     for(int y = 0; y < img.height; y++){
       for(int x = 0; x < img.width; x++){
          color c = convolution(x, y, blur, matrixSize, img);
          editedImg.set(x,y,c);
       }
     }
   }
}
  println("BlurEffect - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:BlurEffect:759259:

public void Sharpen_click1(GButton source, GEvent event) { //_CODE_:sharpenEffect:492264:
if(source == sharpenEffect){
   if(img != null){
     editedImg = createImage(img.width, img.height, RGB);
     img.loadPixels();
     int matrixSize = 3;
     for(int y = 0; y < img.height; y++){
       for(int x = 0; x < img.width; x++){
          color c = convolution(x, y, sharpen, matrixSize, img);
          editedImg.set(x,y,c);
       }
     }
   }
}
  println("sharpenEffect - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:sharpenEffect:492264:

public void Edges_click1(GButton source, GEvent event) { //_CODE_:findEdges:607497:
  if(source == findEdges){
   if(img != null){
   editedImg = createImage(img.width, img.height, RGB);
   img.loadPixels();
   int matrixSize = 3;
   for(int y = 0; y < img.height; y++){
     for(int x = 0; x < img.width; x++){
       color c = convolution(x, y, edgeDetection, matrixSize, img);
       editedImg.set(x,y,c);
     }
   }
   }
  }
  println("findEdges - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:findEdges:607497:

public void hue_slider(GSlider source, GEvent event) { //_CODE_:HueValue:954642:
if(source == HueValue && event == GEvent.VALUE_STEADY){
   if(img != null){
  imgWidth = img.width;
  imgHeight = img.height;
    for (int y = 0; y < imgHeight; y++) {
    
      for (int x = 0; x < imgWidth; x++){
        
        color thisPix = img.get(x,y);
        int red = (int) (red(thisPix));
        int green = (int) (green(thisPix));
        int blue = (int) (blue(thisPix));
        
        float[] hsb = Color.RGBtoHSB(red,green,blue, null);
        float hue = hsb[0];
        float sat = hsb[1];
        float val = hsb[2];
        
        
        hue += 30;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
    
        
        color newRGB =   HSVtoRGB(hue,  sat,  val);
        img.set(x,y, newRGB);
      
     
      }
    
    }  
   }
  
   //brightness = BrightValue.getValueF();
   
}
  println("HueValue - GSlider >> GEvent." + event + " @ " + millis());
  println("Slider steady at integer value "+HueValue.getValueI()+" and float value "+HueValue.getValueF()); //Getting live values for testing purposes
} //_CODE_:HueValue:954642:

public void sat_slider(GSlider source, GEvent event) { //_CODE_:SatValue:911665:
  if(source == SatValue && event == GEvent.VALUE_STEADY){
  }
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:SatValue:911665:

public void brightness_slider(GSlider source, GEvent event) { //_CODE_:BrightValue:328334:
  if(source == BrightValue && event == GEvent.VALUE_STEADY){
    if(img != null){
    //Loading the image pixels to update when we are done with the operation
    editedImg = img.copy();
    editedImg.loadPixels();
    //Getting the width and height of the image
    for(int x = 0; x < editedImg.width; x++){
     for(int y = 0; y < editedImg.height; y ++){
      
      int position = x + y * editedImg.width;
      
      //Getting the RGB values of the image
      float r = red (editedImg.pixels[position]);
      float g = green (editedImg.pixels[position]);
      float b = blue (editedImg.pixels[position]);
      //Ensuring we are within the pixel range of the image
      position = constrain(position, 0, img.pixels.length-1);
      //Adjusting brightness values accordingly as we move the slider
      float brightnessValue = map(mouseX, 0, 1000, 0, 8);
      r *= brightnessValue;
      g *= brightnessValue;
      b *= brightnessValue;
      //Enduring RGB values are within 0 - 255 range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      //Applying the updated values to the image accordingly
      color c = color(r, g, b);
      editedImg.pixels[position] = c;
      
     }
    }
    editedImg.updatePixels();
    
  }
  }
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:BrightValue:328334:

public void Clear_click2(GButton source, GEvent event) { //_CODE_:PanelClear:977546:
  if(source == PanelClear){
    img = null; //Reseting the img datatype to nothing
    editedImg = null;
    background(245); //Setting the new background to overwrite the image
  }
  println("PanelClear - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:PanelClear:977546:

public void removeShapes_click1(GButton source, GEvent event) { //_CODE_:removeShapes:477883:
  println("removeShapes - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:removeShapes:477883:

public void clearEffects_click1(GButton source, GEvent event) { //_CODE_:clearEffects:799537:
  if(source == clearEffects){
  editedImg = null; 
  //Resetting the sliders positions
  BrightValue.setLimits(0.0, -1.0, 1.0);
  image(img, 250,70);
  img.resize(700,650);
  }
  println("clearEffects - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:clearEffects:799537:

public void square_click1(GButton source, GEvent event) { //_CODE_:squareButton:304426:

  println("button3 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:squareButton:304426:

public void polgyon_click1(GButton source, GEvent event) { //_CODE_:polygonButton:808569:
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:polygonButton:808569:

public void triangle_click1(GButton source, GEvent event) { //_CODE_:triangleButton:642856:
  println("triangleButton - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:triangleButton:642856:

public void circle_click1(GButton source, GEvent event) { //_CODE_:circleButton:892263:
  println("circleButton - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:circleButton:892263:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  openImage = new GButton(this, 38, 55, 80, 30);
  openImage.setText("Browse");
  openImage.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  openImage.addEventHandler(this, "openImage_click1");
  saveButton = new GButton(this, 140, 55, 80, 30);
  saveButton.setText("Save");
  saveButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  saveButton.addEventHandler(this, "saveButton_click1");
  Zoom = new GCustomSlider(this, 534, 724, 206, 59, "grey_blue");
  Zoom.setShowLimits(true);
  Zoom.setLimits(0.5, 0.0, 1.0);
  Zoom.setNumberFormat(G4P.DECIMAL, 2);
  Zoom.setLocalColorScheme(GCScheme.RED_SCHEME);
  Zoom.setOpaque(false);
  Zoom.addEventHandler(this, "zoom_slider1");
  filehandling = new GLabel(this, 46, 25, 162, 20);
  filehandling.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  filehandling.setText("File Handling");
  filehandling.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  filehandling.setOpaque(true);
  imageEffects = new GLabel(this, 46, 103, 162, 20);
  imageEffects.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  imageEffects.setText("Image Effects");
  imageEffects.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  imageEffects.setOpaque(true);
  BlurEffect = new GButton(this, 38, 139, 80, 30);
  BlurEffect.setText("Blur");
  BlurEffect.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  BlurEffect.addEventHandler(this, "Blur_click1");
  sharpenEffect = new GButton(this, 140, 139, 80, 30);
  sharpenEffect.setText("Sharpen");
  sharpenEffect.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  sharpenEffect.addEventHandler(this, "Sharpen_click1");
  findEdges = new GButton(this, 86, 178, 80, 30);
  findEdges.setText("Edges ");
  findEdges.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  findEdges.addEventHandler(this, "Edges_click1");
  HsbEffects = new GLabel(this, 46, 236, 162, 20);
  HsbEffects.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  HsbEffects.setText("HSB Effects");
  HsbEffects.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  HsbEffects.setOpaque(true);
  HueValue = new GSlider(this, 108, 265, 66, 40, 10.0);
  HueValue.setShowLimits(true);
  HueValue.setLimits(0.0, 0.0, 18.0);
  HueValue.setNumberFormat(G4P.DECIMAL, 2);
  HueValue.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  HueValue.setOpaque(false);
  HueValue.addEventHandler(this, "hue_slider");
  label1 = new GLabel(this, 22, 276, 80, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Hue");
  label1.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  label1.setOpaque(false);
  ImgScake = new GLabel(this, 596, 776, 80, 20);
  ImgScake.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  ImgScake.setText("Scale Image");
  ImgScake.setLocalColorScheme(GCScheme.RED_SCHEME);
  ImgScake.setOpaque(false);
  SatValue = new GSlider(this, 108, 314, 100, 40, 10.0);
  SatValue.setShowLimits(true);
  SatValue.setLimits(0.0, -1.0, 1.0);
  SatValue.setNumberFormat(G4P.DECIMAL, 2);
  SatValue.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  SatValue.setOpaque(false);
  SatValue.addEventHandler(this, "sat_slider");
  saturationLabel = new GLabel(this, 22, 325, 80, 20);
  saturationLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  saturationLabel.setText("Saturation");
  saturationLabel.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  saturationLabel.setOpaque(false);
  BrightValue = new GSlider(this, 107, 363, 100, 40, 10.0);
  BrightValue.setShowLimits(true);
  BrightValue.setLimits(0.0, -1.0, 1.0);
  BrightValue.setNumberFormat(G4P.DECIMAL, 2);
  BrightValue.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  BrightValue.setOpaque(false);
  BrightValue.addEventHandler(this, "brightness_slider");
  BrightnessLabel = new GLabel(this, 22, 372, 80, 20);
  BrightnessLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  BrightnessLabel.setText("Brightness");
  BrightnessLabel.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  BrightnessLabel.setOpaque(false);
  PanelClear = new GButton(this, 282, 742, 80, 30);
  PanelClear.setText("Clear Panel");
  PanelClear.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  PanelClear.addEventHandler(this, "Clear_click2");
  removeShapes = new GButton(this, 381, 742, 94, 30);
  removeShapes.setText("Clear Shapes");
  removeShapes.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  removeShapes.addEventHandler(this, "removeShapes_click1");
  clearEffects = new GButton(this, 282, 25, 80, 30);
  clearEffects.setText("Clear Effects");
  clearEffects.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  clearEffects.addEventHandler(this, "clearEffects_click1");
  togGroup1 = new GToggleGroup();
  Shapes = new GLabel(this, 46, 427, 162, 20);
  Shapes.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  Shapes.setText("Draw Shapes");
  Shapes.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  Shapes.setOpaque(true);
  squareButton = new GButton(this, 38, 505, 80, 30);
  squareButton.setText("Square / Rect");
  squareButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  squareButton.addEventHandler(this, "square_click1");
  polygonButton = new GButton(this, 140, 505, 80, 30);
  polygonButton.setText("Polygon");
  polygonButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  polygonButton.addEventHandler(this, "polgyon_click1");
  triangleButton = new GButton(this, 38, 460, 80, 30);
  triangleButton.setText("Triangle");
  triangleButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  triangleButton.addEventHandler(this, "triangle_click1");
  circleButton = new GButton(this, 138, 460, 80, 30);
  circleButton.setText("Circle");
  circleButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  circleButton.addEventHandler(this, "circle_click1");
}

// Variable declarations 
// autogenerated do not edit
GButton openImage; 
GButton saveButton; 
GCustomSlider Zoom; 
GLabel filehandling; 
GLabel imageEffects; 
GButton BlurEffect; 
GButton sharpenEffect; 
GButton findEdges; 
GLabel HsbEffects; 
GSlider HueValue; 
GLabel label1; 
GLabel ImgScake; 
GSlider SatValue; 
GLabel saturationLabel; 
GSlider BrightValue; 
GLabel BrightnessLabel; 
GButton PanelClear; 
GButton removeShapes; 
GButton clearEffects; 
GToggleGroup togGroup1; 
GLabel Shapes; 
GButton squareButton; 
GButton polygonButton; 
GButton triangleButton; 
GButton circleButton; 
