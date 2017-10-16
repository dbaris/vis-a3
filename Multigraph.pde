// state options
int LINE_G = 0;
int BAR_G = 1;
int PIE_G = 2;

class Multigraph {
   String [] ls;
   float [] vs;
   Sidebar sidebar;
   int state; 
   float maxY;
   
   Multigraph(String[] labels, float[] values){
     this.ls = labels;
     this.vs = values;
     sidebar = new Sidebar();
     this.state = LINE_G;
     this.maxY = values[0];
     for (float v : values) {
       if (v > this.maxY) {
         this.maxY = v;
       }
     }
     
   }
   
   void render() {
     sidebar.render();
     switch(this.state){
         case(0): draw_line();
                  break;
         case(1): draw_bar();
                  break;
         case(2): draw_pie();
                  break;
     }
   }
   
   void draw_axes(){
      stroke(0);
      line(width * .1, height * .85, width * .7, height * .85);
      line(width * .1, height * .85, width * .1, height * .15);
      
      float interval = (height * .85 - height * .15) / 8;
      
      // Y axis labels
      for (int i = 0; i <= 8; i++){
        text(this.maxY - (this.maxY * i / 8), width * .05, height * .15 + interval * i);
        line(width * .1, height * .15 + interval * i, width * .12, height * .15 + interval * i);
      } 
   }
   
   void draw_line(){
     draw_axes();
     int len = this.vs.length;
     float interval = width *.6 / len;
     
     for (int i = 0; i < this.vs.length; i++){
         float x_pos = width * 0.12 + i * interval;
         float y_pos = height * .85 - ((this.vs[i] / this.maxY) * height * .7);  
         textAlign(CENTER, CENTER);
         textSize(10);
         
         if ((i + 1) < this.vs.length) {
           float x_posNext = width * 0.12 + (i + 1) * interval;
           float y_posNext = height * .85 - ((this.vs[i + 1] / this.maxY) * height * .7);
           line(x_pos, y_pos, x_posNext, y_posNext);
         }
         
         pushMatrix();
         translate(x_pos, height * .9);
         rotate(-HALF_PI);
         translate(-x_pos, -height * .9);
         fill(0);
         text(this.ls[i], x_pos, height * .9);
         popMatrix();
         
         if (abs(mouseX - x_pos) < 5 && abs(mouseY - y_pos) < 5) {
             text(this.vs[i], x_pos, y_pos - .03 * height);
             fill(#80d4ff);
         } else {
             fill(#205570);
         }
         ellipse(x_pos, y_pos, 10, 10);
     }
     
   }
   
   void draw_bar() {
       draw_axes();
       int len = this.vs.length;
       float interval = width *.6 / len;
       float bar_width = interval / 2;
     
       for (int i = 0; i < this.vs.length; i++){
         float x_pos = width * 0.12 + i * interval - bar_width / 2;
         float y_pos = height * .85 - ((this.vs[i] / this.maxY) * height * .7);  
         textAlign(CENTER, CENTER);
         textSize(10);
         
         pushMatrix();
         translate(x_pos + bar_width / 2, height * .9);
         //textAlign(CENTER, TOP);
         rotate(-HALF_PI);
         translate(-x_pos - bar_width / 2, -height * .9);
         fill(0);
         text(this.ls[i], x_pos + bar_width/2, height * .9);
         popMatrix();
         
         if (mouseX > x_pos && mouseX < x_pos + bar_width && 
             mouseY > y_pos && mouseY < height * .85) {
             text(this.vs[i], x_pos, y_pos - .03 * height);
             fill(#80d4ff);
         } else {
             fill(#205570);
         }
         rect(x_pos, y_pos, bar_width, height * .85 - y_pos);
     }
   }
   
   void draw_pie() {
       textSize(100);
       text("PIEEEEEEEE", width /2, height /2);
   }
   
   void handleClick(){
       int i = sidebar.stateClick();
       
       if(i != -1) {
           this.state = i;
       }
   }


}