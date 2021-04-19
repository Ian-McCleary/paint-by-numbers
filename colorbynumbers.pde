import com.chroma.*;
import g4p_controls.*;
import java.awt.Font;

PImage p;
PImage currentImage;
PImage resetImage;
PImage processImage;
PImage whiteImage;
int[][] colorList;
int[][] numberList;
int maxColors = 15;
int currentStep = 0;
int blurAmount = 1;
int postAmount = 5;
int numberSpacing = 40;
int prevNumberSpacing = 40;
int numberTextSize = 12;
int outputWidth = 2550;
int outputHeight = 3300;

//setup GUI
boolean uploadButtonOver = false;
boolean generateButtonOver = false;
boolean saveButtonOver = false;
int uploadX,uploadY;
int generateX,generateY,saveButtonX,saveButtonY;
int buttonWidth = 70;
int buttonHeight = 30;
color buttonColor = color(200,200,200);
color buttonHighlight = color(220,220,220);

GTextField blurField;
GTextField postField;
GTextField numDensityField;
GTextField numTextField;
GTextField outputWidthField;
GTextField outputHeightField;

void setup(){
  colorMode(RGB);
  textAlign(CENTER,CENTER);
  size(800,500);
  background(255);
  colorList = new int[maxColors][2];
  //[0] = number [1] = color
  numberList = new int[(700*400)/(numberSpacing*numberSpacing)][3];
  frameRate(15);
  //setup rectangle buttons
  //upload
  uploadX = 10;
  uploadY = 410;
  generateX = 100;
  generateY = 465;
  saveButtonX = 462;
  saveButtonY = 460;
  numberTextSize = 12;
  fill(buttonColor);
  rect(uploadX,uploadY,buttonWidth,buttonHeight);
  rect(generateX,generateY,buttonWidth,buttonHeight);
  fill(30,30,30);
  textSize(15);
  textAlign(LEFT);
  text("Blur:",100,420);
  text("Color Simplicity:",100,450);
  
  blurField = new GTextField(this,140,405,30,25);
  postField = new GTextField(this,220,435,30,25);
  numDensityField = new GTextField(this,385,405,30,25);
  numTextField = new GTextField(this,260+buttonWidth,440,30,25);
  outputWidthField = new GTextField(this,450,430,50,25);
  outputHeightField = new GTextField(this,550,430,50,25);
  Font thisFont = new Font("Arial", Font.PLAIN,15);
  blurField.setFont(thisFont);
  postField.setFont(thisFont);
  numDensityField.setFont(thisFont);
  numTextField.setFont(thisFont);
  outputWidthField.setFont(thisFont);
  outputHeightField.setFont(thisFont);
  
  outputWidthField.setNumeric(2,10000,2550);
  outputHeightField.setNumeric(2,10000,3300);
  blurField.setNumeric(1,5,1);
  postField.setNumeric(2,10,5);
  numTextField.setNumeric(3,40,12);
  numDensityField.setNumeric(7,200,40);
  numDensityField.setText("40");
  blurField.setText("1");
  postField.setText("5");
  numTextField.setText("12");
  outputWidthField.setText(str(outputWidth));
  outputHeightField.setText(str(outputHeight));
  
  textAlign(CENTER,CENTER);
  p = loadImage("palouse.jpg");
  
  p.resize(700,400);
  
  loadPixels();
  p.filter(BLUR,1);
  p.filter(POSTERIZE,5);
  processImage = p;
  p.save("coloredOutput.jpg");
  //image(p,0,0);
  p.updatePixels();
  //drawBorders(p);
  PImage rawImage = loadImage("outputImage.jpg");
  currentImage = rawImage;
  rawImage.resize(700,400);
  rawImage.loadPixels();
  image(rawImage,0,0);
  placeNumbers(rawImage);
 
}

void draw(){
  background(255);
  update(mouseX,mouseY);
  //rotate(PI/2);
  //translate(0,-currentImage.height);
  //currentImage.resize(
  image(currentImage,0,0);
  //translate(0,currentImage.height);
  //rotate(-PI/2);
  
  //translate(0,-currentImage.height/2);
  //println(int(blurField.getText()));
  //step 1
  if (currentStep == 1){
    if (int(blurField.getText()) < 1){
      blurAmount = 1;
    } else if (int(blurField.getText()) > 5){
        blurAmount = 5;
    } else if (int(blurField.getText()) < 6 && int(blurField.getText()) > 0){
      blurAmount = int(blurField.getText());
    }
    //post field
      if (int(postField.getText()) < 3){
      postAmount = 2;
    } else if (int(postField.getText()) > 10){
        postAmount = 10;
    } else if (int(postField.getText()) < 10 && int(postField.getText()) > 1){
      postAmount = int(postField.getText());
    }
    
    //consider making copy image width and height as native photo width and height or with some resizing.
    PImage copyI = createImage(700,400,RGB);
    copyI = resetImage.copy();
    copyI.loadPixels();
    //copyI.resize(700,0);
    copyI.filter(BLUR,blurAmount);
    copyI.filter(POSTERIZE, postAmount);
    copyI.updatePixels();
    processImage = copyI;
    
    
    //rotate(PI/2);
    //translate(0,-currentImage.height);
    
    image(copyI,0,0);
    //translate(0,currentImage.height);
    //rotate(-PI/2);
    
    
  }
  if (currentStep == 2 || currentStep == 0){

    //text input sanitation
    if (int(numTextField.getText()) < 3){
      numberTextSize = 3;
    } else if (int(numTextField.getText()) > 40){
        numberTextSize = 40;
    } else if (int(numTextField.getText()) < 41 && int(numTextField.getText()) > 2){
      numberTextSize = int(numTextField.getText());
    }
    if (int(numDensityField.getText()) < 7){
      numberSpacing = 7;
    } else if (int(numDensityField.getText()) > 150){
        numberSpacing = 150;
    } else if (int(numDensityField.getText()) < 150 && int(numDensityField.getText()) > 6){
      numberSpacing = int(numDensityField.getText());
    }
    
    if (int(outputWidthField.getText()) < 2){
      outputWidth = 1;
    } else if (int(outputWidthField.getText()) > 10000){
        outputWidth = 10000;
    } else if (int(outputWidthField.getText()) < 10000 && int(outputWidthField.getText()) > 2){
      outputWidth = int(outputWidthField.getText());
    }
    if (int(outputHeightField.getText()) < 2){
      outputHeight = 1;
    } else if (int(outputHeightField.getText()) > 10000){
        outputHeight = 10000;
    } else if (int(outputHeightField.getText()) < 10000 && int(outputHeightField.getText()) > 2){
      outputHeight = int(outputHeightField.getText());
    }
    //check if numspacing has been updated.
    if (prevNumberSpacing != numberSpacing){
      numberList = new int[(700*400)/(numberSpacing*numberSpacing)][3];
      colorList = new int[maxColors][2];
      prevNumberSpacing = numberSpacing;
    }
    
    placeNumbers(currentImage);
    //draw hex list
    for (int i = 0; i < colorList.length; i++){
        
        
        //paint hex pallet
        fill(colorList[i][1]);
        rect(710,(colorList[i][0] * 25),60,20); 
        textSize(14);
        text(str(colorList[i][0]),780,(colorList[i][0] * 25)+10);
    }
    //draw black numbers on image
    for (int i = 0; i < numberList.length; i++){
      if (numberList[i][0] != 0 && numberList[i][1] != 0 && numberList[i][2] != 0){
        //show text
        //println(numberList[i]);
        textAlign(CENTER,CENTER);
        textSize(numberTextSize);
        fill(30,30,30);
        text(str(numberList[i][0]),numberList[i][1],numberList[i][2]);
      }
    }
    
  }
  if (uploadButtonOver) {
    fill(buttonHighlight);
    rect(uploadX, uploadY, buttonWidth, buttonHeight);
  } else {
    fill(buttonColor);
    rect(uploadX, uploadY, buttonWidth, buttonHeight);
  }
  if (generateButtonOver){
    fill(buttonHighlight);
    rect(generateX,generateY,buttonWidth,buttonHeight);
  } else{
    fill(buttonColor);
    rect(generateX,generateY,buttonWidth,buttonHeight);
  }
  if (saveButtonOver){
    fill(buttonHighlight);
    rect(saveButtonX,saveButtonY,buttonWidth+25,buttonHeight);
  } else{
    fill(buttonColor);
    rect(saveButtonX,saveButtonY,buttonWidth+25,buttonHeight);
  }
  
  fill(color(0,0,0));
  //GUI LINES AND TEXT
  line(uploadX+buttonWidth+10,400,uploadX+buttonWidth+10,700);
  line(generateX+buttonWidth*2+10,400,generateX+buttonWidth*2+10,700);
  line(425,400,425,475);
  textSize(15);
  textAlign(CENTER,CENTER);
  text("Upload",uploadX+35,uploadY+11);
  text("Generate",generateX+35,generateY+11);
  text("Step " + currentStep + "/2",width/2,height-15);
  
  textAlign(LEFT);
  text("Blur:",100,420);
  text("Color Simplicity:",100,450);
  text("Number Spacing:",260, 420);
  text("Output Resolution:",440,420);
  text("Save Image",470,480);
  text("Font Size:",260, 455);
  text("px",502,450);
  text("W:",430,450);
  text("px",600,450);
  text("H:",530,450);
  
}

void mousePressed() {
  if (uploadButtonOver) {
    selectInput("Select an image to process:", "fileSelected");
  }
  if (generateButtonOver && currentStep == 1) {
    drawBorders(processImage);
  }
  if (saveButtonOver && currentStep == 2){
  saveImage();
  }
}

//saves image with numbers, then upscales to desiered resolution
void saveImage(){

}

void update(int x, int y) {
  if (overRect(uploadX, uploadY, buttonWidth, buttonHeight) ) {
    uploadButtonOver = true;
    generateButtonOver = false;
    saveButtonOver = false;
  } else if ( overRect(generateX, generateY, buttonWidth, buttonHeight) ) {
    generateButtonOver = true;
    uploadButtonOver = false;
    saveButtonOver = false;
  } else if(overRect(saveButtonX,saveButtonY,buttonWidth+25,buttonHeight)){
    saveButtonOver = true;
    generateButtonOver = false;
    uploadButtonOver = false;
  }
    else {
    generateButtonOver = false;
    uploadButtonOver = false;
    saveButtonOver = false;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}


void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    final String canvasPath = selection.getAbsolutePath();
    //need to check if its a jpg
    currentImage=loadImage(canvasPath);
    currentImage.loadPixels();
    //get the scaled image size to display. 16 x 9 aspect ratio. w=700.
   //for (int i = currentImage.height; i <= 395; i-=16){
      
    //}
    //currentImage.resize(700,400);
    currentImage.resize(700,394);
    image(currentImage,0,0);
    //resetImage.resize(700,400);
    //resetImage.loadPixels();
    //set image size canvas: 700 x 400
    
    
    
    resetImage = currentImage;
    
    blurField.setText("1");
    postField.setText("5");
    currentStep = 1;
  }
}

void palletManager(int textX, int textY){
  color thisColor = processImage.get(textX,textY);
  int thisNumber=0;
  boolean alreadyExists = false;
  for(int i = 0; i < colorList.length; i++){
    if(colorList[i][1] == thisColor){
      alreadyExists = true;
      thisNumber = colorList[i][0];
      break;
    }
  }
  if (alreadyExists == false){
    for(int i = 0; i < colorList.length; i++){
      if(colorList[i][0] == 0 && colorList[i][1] == 0){
        thisNumber = i+1;
        colorList[i][0] = thisNumber;
        colorList[i][1] = thisColor;
        break;
      }
    }
  }

    for (int i = 0; i < numberList.length; i++){
      if (numberList[i][0] == 0 && numberList[i][1] == 0 && numberList[i][2] == 0){
        numberList[i][0] = thisNumber;
        numberList[i][1] = textX;
        numberList[i][2] = textY;
        //println(numberList[i]);
        break;
      }
    }
}

//Search for space between left/right, top/bottom black pixels.
//find the center of white space and place number there
void placeNumbers(PImage inputPhoto){
  inputPhoto.loadPixels();
  int[][] textPosList = new int[(inputPhoto.width * inputPhoto.height)/40][4];
  
  //int count = inputPhoto.width * inputPhoto.height;
  int pixelSpace = numberSpacing;
  for (int y = pixelSpace; y < inputPhoto.height; y+=pixelSpace){
    for (int x = pixelSpace; x < inputPhoto.width; x+=pixelSpace){
      //println(inputPhoto.get(x,y));
      //image is "grayscale" so only need red (all vals same)
      
      if (red(inputPhoto.get(x,y)) > 50){
        //find the top, bottom, left, and right pixels;
        //find top pixel
        boolean foundTp = false;
        int topY = y;
        while(foundTp == false){
        topY -=1;
          if(red(inputPhoto.get(x,topY)) < 50){
            foundTp = true;
           }
        }
        //find bottom pixel
        boolean foundBp = false;
        int bottomY = y;
        while(foundBp == false){
        bottomY +=1;
          if(red(inputPhoto.get(x,bottomY)) < 50){
            foundBp = true;
           }
        }
        //find left pixel
        boolean foundLp = false;
        int leftX = x;
        while(foundLp == false){
        leftX -=1;
          if(red(inputPhoto.get(leftX,y)) < 50){
            foundLp = true;
           }
        }
        //find right pixel
        boolean foundRp = false;
        int rightX = x;
        while(foundRp == false){
        rightX +=1;
          if(red(inputPhoto.get(rightX,y)) < 50){
            foundRp = true;
           }
        }
        //get text coordinates and 2 radi for ellipse computation
        int textX = leftX + ((rightX-leftX)/2);
        int textY = topY+((bottomY-topY)/2);
        int textA = textX - leftX;
        int textB = textY-topY;
        boolean takenPixel = false;
        
        if (textPosList[0][0] == 0 && textPosList[0][1] == 0){
          textPosList[0][0] = textX;
          textPosList[0][1] = textY;
          textPosList[0][2] = textA;
          textPosList[0][3] = textB;
        } else{
          for (int n = 0; n < textPosList.length; n++){
            if (textPosList[n][0] != 0 && textPosList[n][1] != 0){
              if ( (sq(textX-textPosList[n][0])/sq(textPosList[n][2]))+(sq(textY-textPosList[n][1])/ sq(textPosList[n][3]))<=1){
                takenPixel = true;           
              }
            } else{
              textPosList[n][0] = textX;
              textPosList[n][1] = textY;
              textPosList[n][2] = textA;
              textPosList[n][3] = textB;
              break;
            }
          }
        }
        if (takenPixel == false){
           //fill(255,0,0);
           //ellipse(textX,textY,textA,textB);
          //println(textX,textY);
          //println(p.get(textPosList[0][0],textPosList[0][1]));
          palletManager(textX,textY);
        }
        
        //if ( (sq(cx-textX)/sq(textA))+(sq(cy-textY)/ sq(textB))<=1){
      }
    }
  }
  
}

void drawBorders(PImage startingImage){
  startingImage.loadPixels();
  //startingImage.filter(BLUR,1);
  //startingImage.filter(POSTERIZE,5);
  //startingImage.updatePixels();
  PImage overlayImage = createImage(startingImage.width,startingImage.height,RGB);
  //background(255);
  overlayImage.loadPixels();
  
  int count = (overlayImage.width * overlayImage.height)-overlayImage.width-1;
  
  for (int i = width+1; i < count; i++){
  //get the LAB values for each of 5 pixels. mid,top,bot,left,right
  //NOTE THAT EDGE PIXELS CONSIDER THE LAST PIXEL OF PREVIOUS LINE AS LEFT/RIGHT
  Chroma mp = new Chroma(startingImage.pixels[i]);
  Chroma tp = new Chroma(startingImage.pixels[i-overlayImage.width]);
  Chroma bp = new Chroma(startingImage.pixels[i+overlayImage.width]);
  Chroma lp = new Chroma(startingImage.pixels[i-1]);
  Chroma rp = new Chroma(startingImage.pixels[i+1]);
  
  double[] mpVals = mp.get(ColorSpace.LAB);
  double[] tpVals = tp.get(ColorSpace.LAB);
  double[] bpVals = bp.get(ColorSpace.LAB);
  double[] lpVals = lp.get(ColorSpace.LAB);
  double[] rpVals = rp.get(ColorSpace.LAB);
  
  double tpDelta = calculateDeltaE(mpVals[0],mpVals[1],mpVals[2],tpVals[0],tpVals[1],tpVals[2]);
  double bpDelta = calculateDeltaE(mpVals[0],mpVals[1],mpVals[2],bpVals[0],bpVals[1],bpVals[2]);
  double lpDelta = calculateDeltaE(mpVals[0],mpVals[1],mpVals[2],lpVals[0],lpVals[1],lpVals[2]);
  double rpDelta = calculateDeltaE(mpVals[0],mpVals[1],mpVals[2],rpVals[0],rpVals[1],rpVals[2]);
   
  //println(tpDelta,bpDelta,lpDelta,rpDelta);
  color b = color(0,0,0);
  color w = color(255,255,255);
  
  float tolerance = 5.0;
  if (tpDelta > tolerance){
    overlayImage.pixels[i-overlayImage.width] = color(0,0,0);
  }else{
    overlayImage.pixels[i-overlayImage.width] = color(255,255,255);
  }
  if (bpDelta > tolerance){
    overlayImage.pixels[i+overlayImage.width] = color(0,0,0);
  }else{
    overlayImage.pixels[i+overlayImage.width] = color(255,255,255);
  }
  if (lpDelta > tolerance){
    overlayImage.pixels[i-1] = color(0,0,0);
  }else{
    overlayImage.pixels[i-1] = color(255,255,255);
  }
  if (rpDelta > tolerance){
    overlayImage.pixels[i+1] = color(0,0,0);
  }else{
    overlayImage.pixels[i+1] = color(255,255,255);
  }
  overlayImage.updatePixels();
  
  //whiteImage.loadPixels();
  //image(overlayImage,0,0);
  //currentImage = overlayImage;
  
  
  //println(tpDelta + "->" + bpDelta + "->" + lpDelta + "->" + rpDelta + "->");
  }
  currentImage = overlayImage;
  currentImage.loadPixels();
  currentStep = 2;
  overlayImage.save("outputImage.jpg");
  println("Draw borders finished");
}

float colorDistanceLAB(Chroma a, Chroma b) {
  double[] aVals = a.get(ColorSpace.LAB);
  double[] bVals = b.get(ColorSpace.LAB);
  double lDiff = aVals[0] - bVals[0];
  double aDiff = aVals[1] - bVals[1];
  double bDiff = aVals[2] - bVals[2];
  return sqrt( sq((float)lDiff) + sq((float)aDiff) + sq((float)bDiff));
}


//Chroma closestColorChroma(Chroma c){

//  Chroma[] palletToUse = crayolaChroma;
//  double recordDistance = 10000000;
//  int index = 0;
//  double[] cLabVals = c.get(ColorSpace.LAB);
  
//  for (int i = 0; i < palletToUse.length; i++){
//    double[] palletLabVals = palletToUse[i].get(ColorSpace.LAB);
//    //if (colorDistanceLAB(c, palletToUse[i]) < recordDistance) {
//      double deltaE = calculateDeltaE(cLabVals[0],cLabVals[1],cLabVals[2],palletLabVals[0],palletLabVals[1],palletLabVals[2]);
//      if (deltaE < recordDistance){
//        recordDistance = deltaE;
        
//        //recordDistance = colorDistanceLAB(c, palletToUse[i]);
//      //println(colorDistanceLAB(c, palletToUse[i]));
//      //println(palletToUse[i].get());
//      index = i;
//     }
//  }
//  Chroma returnColor = palletToUse[index];
//  return returnColor;
  

//}
