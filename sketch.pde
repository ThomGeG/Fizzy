//The dimensions of the board (To remove magic numbers).
int numOfVerticalPegs = 8;
int numOfHorizontalPegs = 8;

int fizzyXPos;
int fizzyYPos;
int fizzyRotation;

int fizzyXVelocity;
int fizzyYVelocity;

int fizzyWidth;
int fizzyHeight;
int fizzyEyeWidth;
int fizzyEyeHeight;
int fizzyPupilWidth;
int fizzyPupilHeight;

int rupeeSize;
int[] rupeeXPos;
int[] rupeeYPos; 
boolean[] rupeeRevealed;

public void setup() {
  
  size(810, 810); //Assignment spec says 810x810 & the math would suggest that, but the skeleton had 800x800?
  
  //Helper values to cache and improve readability futher down.
  int xSpacing = width / (numOfHorizontalPegs + 1); //The distance between each peg on the x axis.
  int ySpacing = height / (numOfVerticalPegs + 1);  //The distance between each peg on the y axis.
  
  //Initialize fizzys dimensions.
  fizzyWidth = 50;
  fizzyHeight = 50;
  fizzyEyeWidth = 20;
  fizzyEyeHeight = 25;
  fizzyPupilWidth = 10;
  fizzyPupilHeight = 15;
  
  //Place Fizzy in the top left corner to begin.
  fizzyXPos = xSpacing + fizzyWidth;
  fizzyYPos = ySpacing + fizzyHeight;
  fizzyRotation = 0;
  
  //Fizzy initializes downward.
  fizzyYVelocity = 2;
  fizzyXVelocity = 0;
  
  rupeeSize = 40;
  
  /** DETERMINING WHERE THE RUPEES GO. Here be dragons.
   *
   * The board can be considered a grid (because it is) with each peg being one corner of a box in the grid.
   * Using this abstraction we can define whether or not a box in the grid should contain a rupee, as done so
   * via the 2D array (Array contaning more arrays) hasRupee.
   * We can then iterate through this array (Using a nested loop) and create rupees for each true value
   * inside.
   * This grid methodology inherently gives an X and Y coordinate that we can use to determine the real
   * location of any rupee on the x & y axes with some basic math. It also alows the program to be slightly more dynamic;
   * giving us the oportunity to modify the default heart shape to something else by simply modifying which
   * grid locations will/won't have rupees without needing to do the coordinate calculations by hand.
   *
   * It should also be noted that this 2D array effectively represents a level/map and more may be implemented
   * by resetting the game after a trigger (All rupees found/blackhole entered) and loading up a new one.
   * 
   */
  
  //Our level pattern. The current one is the required heart shape.
  boolean[][] hasRupee = {
    {false, true,  true,  false, true,  true,  false},
    {true,  false, false, true,  false, false, true},
    {true,  false, false, false, false, false, true},
    {true,  false, false, false, false, false, true},
    {false, true,  false, false, false, true,  false},
    {false, false, true,  false, true,  false, false},
    {false, false, false, true,  false, false, false},
  };
  
  //Determine how many rupees there are, otherwise we can't declare our fixed length arrays.
  int counter = 0;
  for(int i = 0; i < hasRupee.length; i++)
    for(int j = 0; j < hasRupee[i].length; j++)
      if(hasRupee[i][j])
        counter++;
      
  rupeeXPos = new int[counter];         //Holds x position of rupee[n]
  rupeeYPos = new int[counter];         //Holds y position of rupee[n]
  rupeeRevealed = new boolean[counter]; //Holds isRevealed info of rupee[n]
  
  int n = 0; //What rupee we're initializing...
  for(int i = 0; i < hasRupee.length; i++)
    for(int j = 0; j < hasRupee[i].length; j++)
      if(hasRupee[i][j]) {
        rupeeXPos[n] = xSpacing*(j + 1) + xSpacing/2; //Important: j is our x-axis and i is our y-axis, not the other way around!
        rupeeYPos[n] = ySpacing*(i + 1) + ySpacing/2; //+1 because we want to be inside the grid, not in the border.
        n++;
      }
      
}

//Draw the game board (Pegs + Rupees)
public void drawGameBoard() {
  
  //Borders for poles & rupees
  strokeWeight(2);
  stroke(200);
  
  //Draw the poles.
  fill(200, 200, 0);
  for(int i = width/(numOfHorizontalPegs + 1); i < width; i+=width/(numOfHorizontalPegs + 1))
    for(int j = width/(numOfVerticalPegs + 1); j < height; j+=width/(numOfVerticalPegs + 1))
      ellipse(i, j, 10, 10);
  
  //Draw the rupees (Only those touched).
  fill(0, 255, 0);
  rectMode(CENTER); //Draw the rupes from the center of the rectangle
  for(int i = 0; i < rupeeRevealed.length; i++)
    if(rupeeRevealed[i])
      rect(rupeeXPos[i], rupeeYPos[i], rupeeSize, rupeeSize);
  
}

//Draw our glorious heroine at the target position, looking at the target direction (In degrees).
public void drawFizzy(int x, int y, int rot) {
  
  /*
    Rather than using a series of if statements to determine where we need to draw Fizzy's eyes & tail
    we can instead use a transformation, simplifying the process at an abstract level greatly.
    In the below code Fizzy is drawn at the origin (0, 0) and then TRANSLATED to her targeted postion at (x, y).
    We then perform a ROTATION transformation that will aim Fizzy to the desired angle (Not just 0, 90, 180, 270!).
    NOTE: The sequence of these two calls is imperitive! Rotating before translating will have a different effect, as the
    underlying means of performing these operations utilizes matrices, which don't follow the commutative law (A * B != B * A for matrices).
    
    If you do not wish to use this means (As it is theorically beyond your understanding and definately out of scope for the unit)
    you can instead use drawFizzySimple(x, y, rot). Just delete this and change the function name.
  */
  translate(x, y);
  rotate(radians(rot));
  
  //Fizzy's body
  strokeWeight(0);
  fill(255, 0, 0);  
  ellipse(0, 0, fizzyWidth, fizzyHeight); //Body
    
  //Fizzy's eyes
  fill(0);
  ellipse(-fizzyWidth/8, fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Left eye
  ellipse(fizzyWidth/8,  fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Right eye
   
  //Fizzy's pupils
  fill(255);
  ellipse(-fizzyWidth/8, fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Left pupil
  ellipse(fizzyWidth/8,  fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Right pupil
    
  //Fizzy's tail/nose/eye bridge line thing.
  color(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(4);
  line(0, -2*fizzyHeight/3, 0, 4*fizzyHeight/10); //Tail/eye bridge
    
}

public void drawFizzyBadly(int x, int y, int rot) {
     
  //Fizzy's body
  strokeWeight(0);
  fill(255, 0, 0);  
  ellipse(x, y, fizzyWidth, fizzyHeight); //Body
  
  //Fizzy's looking down...
  if(rot == 0 || rot == 360) { 
    
    //Fizzy's eyes
    fill(0);
    ellipse(x - fizzyWidth/8, y + fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Left eye
    ellipse(x + fizzyWidth/8, y + fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Right eye
       
    //Fizzy's pupils
    fill(255);
    ellipse(x - fizzyWidth/8, y + fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Left pupil
    ellipse(x + fizzyWidth/8, y + fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Right pupil
        
    //Fizzy's tail/nose/eye bridge line thing.
    color(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(4);
    line(x, y - 2*fizzyHeight/3, x, y + 4*fizzyHeight/10); //Tail/eye bridge
  
  } else if(rot == 90) { //Fizzy's looking to the left...
  
    //Fizzy's eyes
    fill(0);
    ellipse(x - fizzyWidth/8, y - fizzyHeight/8, fizzyEyeHeight, fizzyEyeWidth); //Left eye
    ellipse(x - fizzyWidth/8, y + fizzyHeight/8, fizzyEyeHeight, fizzyEyeWidth); //Right eye
       
    //Fizzy's pupils
    fill(255);
    ellipse(x - fizzyWidth/4, y - fizzyHeight/8, fizzyPupilHeight, fizzyPupilWidth); //Left pupil
    ellipse(x - fizzyWidth/4, y + fizzyHeight/8, fizzyPupilHeight, fizzyPupilWidth); //Right pupil
        
    //Fizzy's tail/nose/eye bridge line thing.
    color(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(4);
    line(x + 2*fizzyWidth/3, y, x - 4*fizzyWidth/10, y); //Tail/eye bridge
  
  } else if(rot == 180) { //Fizzy's looking up...
  
    //Fizzy's eyes
    fill(0);
    ellipse(x - fizzyWidth/8, y - fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Left eye
    ellipse(x + fizzyWidth/8, y - fizzyHeight/8, fizzyEyeWidth, fizzyEyeHeight); //Right eye
       
    //Fizzy's pupils
    fill(255);
    ellipse(x - fizzyWidth/8, y - fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Left pupil
    ellipse(x + fizzyWidth/8, y - fizzyHeight/4, fizzyPupilWidth, fizzyPupilHeight); //Right pupil
        
    //Fizzy's tail/nose/eye bridge line thing.
    color(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(4);
    line(x, y + 2*fizzyHeight/3, x, y - 4*fizzyHeight/10); //Tail/eye bridge
  
  } else if(rot == 270 || rot == -90) { //Fizzy's looking to the right...
  
    //Fizzy's eyes
    fill(0);
    ellipse(x + fizzyWidth/8, y - fizzyHeight/8, fizzyEyeHeight, fizzyEyeWidth); //Left eye
    ellipse(x + fizzyWidth/8, y + fizzyHeight/8, fizzyEyeHeight, fizzyEyeWidth); //Right eye
       
    //Fizzy's pupils
    fill(255);
    ellipse(x + fizzyWidth/4, y - fizzyHeight/8, fizzyPupilHeight, fizzyPupilWidth); //Left pupil
    ellipse(x + fizzyWidth/4, y + fizzyHeight/8, fizzyPupilHeight, fizzyPupilWidth); //Right pupil
        
    //Fizzy's tail/nose/eye bridge line thing.
    color(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(4);
    line(x - 2*fizzyWidth/3, y, x + 4*fizzyWidth/10, y); //Tail/eye bridge
    
  } else { //You've inputted an invalid degree... You broke Fizzy.
    rect(x, y, fizzyWidth, fizzyHeight);    
  }
        
}

public void draw(){
  
  background(0); //Clear background
 
  drawGameBoard(); //Draw poles and rupees.

  drawFizzy(fizzyXPos, fizzyYPos, fizzyRotation); //Draw fizzy.
  
  //Check if fizzy collided with any rupees.
  for(int i = 0; i < rupeeRevealed.length; i++)
    if(
        fizzyXPos > rupeeXPos[i] - rupeeSize/2 && fizzyXPos < rupeeXPos[i] + rupeeSize/2 && //Fizzy is inside the rupee on the X axis
        fizzyYPos > rupeeYPos[i] - rupeeSize/2 && fizzyYPos < rupeeYPos[i] + rupeeSize/2    //Fizzy is inside the rupee on the Y axis
    )
      rupeeRevealed[i] = true; //Reveal the rupee.
  
  //Calculate Fizzy's next position based on her velocity...
  
  if(fizzyXPos + fizzyWidth/2 > width || fizzyXPos - fizzyWidth/2 < 0) { //Fizzy hit an X-axis wall...
    fizzyXVelocity *= -1;                        //Reverse direction Fizzy moves.
    fizzyRotation = (fizzyRotation + 180) % 360; //Reverse direction Fizzy looks.
  }
  
  if(fizzyYPos + fizzyHeight/2 > height || fizzyYPos - fizzyHeight/2 < 0) { //Fizzy hit a Y-axis wall...
    fizzyYVelocity *= -1;                        //Reverse direction Fizzy moves.
    fizzyRotation = (fizzyRotation + 180) % 360; //Reverse direction Fizzy looks.
  }
  
  //Move Fizzy according to velocity...
  fizzyXPos = (fizzyXPos + fizzyXVelocity) % width;
  fizzyYPos = (fizzyYPos + fizzyYVelocity) % height;
  
}

//Control direction of Fizzy using WSAD.
//keyReleased as to avoid potential multiple callbacks through keyPressed.
void keyReleased() {
  
  /*
    I used a switch rather than nested ifs to improve readibly (and performance, but that's another story).
    You can hopefully see how to convert it back into either nested or sequential ifs, however you shouldn't need to; It's not a huge 
    stretch to believe one or more students used such a thing.
  */
  
  if(key == 'w') {        //Up
    fizzyXVelocity = 0;
    fizzyYVelocity = -2;
    fizzyRotation = 180;
  } else if(key == 'a') { //Left
    fizzyXVelocity = -2;
    fizzyYVelocity = 0;
    fizzyRotation = 90;
  } else if(key == 's') { //Down
    fizzyXVelocity = 0;
    fizzyYVelocity = 2;
    fizzyRotation = 0;
  } else if(key == 'd') { //Right
    fizzyXVelocity = 2;
    fizzyYVelocity = 0;
    fizzyRotation = -90; //or 270... both will work.
  }
  
}