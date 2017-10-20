// state options
int LINE_G = 0;
int BAR_G = 1;
int PIE_G = 2;

class Multigraph {
   String [] ls;
   float [] vs;
   Sidebar sidebar;
   int state; 
   float maxY, sumValues;
   
   Multigraph(String[] labels, float[] values){
     this.ls = labels;
     this.vs = values;
     sidebar = new Sidebar();
     this.state = LINE_G;
     this.maxY = values[0];
     this.sumValues = 0;
     for (float v : values) {
       if (v > this.maxY) {
         this.maxY = v;
       }
       this.sumValues += v;
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
         float x_pos = width * 0.12 + i * interval;
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
       float cur_angle = 0;
       float x_pos = width * 0.4;
       float y_pos = height * 0.5;
       float d = width * 0.5;
       for (int i = 0; i < this.ls.length; i++){
         float end_angle = cur_angle + this.vs[i] * TWO_PI/this.sumValues;
         
         float dist = dist(mouseX, mouseY, x_pos, y_pos);
      
         // mouse out of pie
          if (dist > d/2 || mouseX == x_pos || mouseY == y_pos) {
            colorMode(HSB, 360, 100, 100);
            fill(color(360 * i/ this.ls.length, 88, 60));
            colorMode(RGB, 255);
          }
    
          else {
            float mouse_angle = 0;
            if (mouseX > x_pos && mouseY < y_pos) {
                mouse_angle = TWO_PI - atan((y_pos - mouseY)/(mouseX - x_pos)); 
            } else if (mouseX < x_pos && mouseY < y_pos) {
                mouse_angle = PI + atan((y_pos - mouseY) / (x_pos - mouseX));
            } else if (mouseX < x_pos && mouseY > y_pos) {
                mouse_angle = PI - atan((mouseY - y_pos)/ (x_pos - mouseX));
            } else {
                mouse_angle = atan((mouseY - y_pos) / (mouseX - x_pos));
            }
            
            // mouse on current segment
            if (mouse_angle > cur_angle && mouse_angle < end_angle) {
              colorMode(HSB, 360, 100, 100);
              fill(color(360 * i/ this.ls.length, 50, 90));
              colorMode(RGB, 255);
              
              stroke(0);
              arc(x_pos, y_pos, d, d, cur_angle, end_angle, PIE);
              fill(255);
              rect(width * 0.05, height * 0.05, width * .1, height * .1);
              fill(0);
              textAlign(CENTER, CENTER);
              text(this.ls[i] + ": " + this.vs[i], width * 0.1, height * 0.1); 
              cur_angle = end_angle;
              continue;
            } else {
              colorMode(HSB, 360, 100, 100);
              fill(color(360 * i/ this.ls.length, 88, 60));
              colorMode(RGB, 255);
            }
          }
          
          stroke(0);
         arc(x_pos, y_pos, d, d, cur_angle, end_angle, PIE);
         cur_angle = end_angle;
       }
   }
   
   void handleClick(){
       int i = sidebar.stateClick();
       
       if(i != -1) {
           this.state = i;
       }
   }


}