// state options
final int LINE_G = 0;
final int BAR_G = 1;
final int PIE_G = 2;
final int LtoB = 3;
final int BtoL = 4;
final int BtoP = 5;
final int PtoB = 6;
final int LtoP = 7;
final int PtoL = 8;

class Multigraph {
   String [] ls;
   float [] vs;
   Sidebar sidebar;
   int state; // 0.line, 1.bar, 2.pie, 3.line-bar, 
              // 4.bar-line, 5.bar-pie, 6.pie-bar
   float maxY, sumValues;
   float lerp1, lerp2, lerp3, lerp4, lerp5, lerp6, lerp7, lerp8, lerp9;
   int line_pie_state;
   
   
   
   Multigraph(String[] labels, float[] values){
     this.ls = labels;
     this.vs = values;
     sidebar = new Sidebar();
     this.state = LINE_G;
     this.maxY = values[0];
     this.sumValues = 0;
     this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = this.lerp5 
                = this.lerp6 = this.lerp7  = this.lerp8 = this.lerp9 = 1.0;
     for (float v : values) {
       if (v > this.maxY) {
         this.maxY = v;
       }
       this.sumValues += v;
     }
     this.line_pie_state = 0;
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
         case(3): draw_LtoB();
                  break;
         case(4): draw_BtoL();
                  break;
         case(5): draw_BtoP();
                  break;
         case(6): draw_PtoB();
                  break;
         case(7): draw_LtoP();
                  break;
         case(8): draw_PtoL();
                  break;
     }
   }
   
   void draw_axes(){
      if (this.state == BtoP || this.state == PtoB) {
          stroke(lerp(0, 255, this.lerp3));
          fill(lerp(0, 255, this.lerp3));
      } else {
          stroke(0);
      }
      line(width * .1, height * .85, width * .7, height * .85);
      line(width * .1, height * .85, width * .1, height * .15);
      
      float interval = (height * .85 - height * .15) / 8;
      
      // Y axis labels
      for (int i = 0; i <= 8; i++){
        text(this.maxY - (this.maxY * i / 8), width * .05, height * .15 + interval * i);
        line(width * .1, height * .15 + interval * i, width * .12, height * .15 + interval * i);
      } 
      stroke(0);
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
         
         // connecting dots with lines
         if ((i + 1) < this.vs.length) {
           float x_posNext = width * 0.12 + (i + 1) * interval;
           float y_posNext = height * .85 - ((this.vs[i + 1] / this.maxY) * height * .7);
           if (this.state != LINE_G) {
               line(x_pos, y_pos, lerp(x_pos, x_posNext, 1 - this.lerp1), 
                                  lerp(y_pos, y_posNext, 1 - this.lerp1));
           } else {
               line(x_pos, y_pos, x_posNext, y_posNext);
           }
         }
         
         pushMatrix();
         translate(x_pos + interval /4, height * .9);
         rotate(-HALF_PI);
         translate(-x_pos - interval / 4, -height * .9);
         fill(0);
         text(this.ls[i], x_pos + interval/4, height * .9);
         popMatrix();
         
         if (abs(mouseX - x_pos) < 5 && abs(mouseY - y_pos) < 5) {
             text(this.vs[i], x_pos, y_pos - .03 * height);
             fill(#80d4ff);
         } else {
             fill(#205570);
         }
         
         if (this.state != LINE_G) {
             ellipse(x_pos, y_pos, lerp(2, 10, 1 - this.lerp2), lerp(2, 10, 1 - this.lerp2));
         } else {
             ellipse(x_pos, y_pos, 10, 10);
         }
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
         
         if (this.state == BtoP || this.state == PtoB) {
           fill(lerp(0, 255, this.lerp3));
         } else {
           fill(0);
         }
         text(this.ls[i], x_pos + bar_width/2, height * .9);
         popMatrix();
         
         if (mouseX > x_pos && mouseX < x_pos + bar_width && 
             mouseY > y_pos && mouseY < height * .85) {
             text(this.vs[i], x_pos, y_pos - .03 * height);
             fill(#80d4ff);
         } else {
             fill(#205570);
         }
         
         if (this.state == LtoB || this.state == BtoL){
             rect(x_pos, y_pos, lerp(0, bar_width, this.lerp3),
                                lerp(2, height * .85 - y_pos, this.lerp4));
         } else if(this.state == BtoP || this.state == PtoB) {
            noStroke();
            colorMode(HSB, 360, 100, 100);
            fill(color(lerp(200, 360 * i/ this.ls.length, lerp1), lerp(71, 88, lerp1), lerp(44, 60, lerp1)));
            rect(x_pos, y_pos, lerp(bar_width, 2, this.lerp2), height * .85 - y_pos);
            colorMode(RGB, 255);
         } else {
             rect(x_pos, y_pos, bar_width, height * .85 - y_pos);
         }
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
            stroke(255);
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
              
              stroke(255);
              arc(x_pos, y_pos, d, d, cur_angle, end_angle, PIE);
              fill(255);
              stroke(0);
              rect(width * 0.05, height * 0.05, width * .1, height * .1);
              fill(0);
              textAlign(CENTER, CENTER);
              text(this.ls[i] + ": " + this.vs[i], width * 0.1, height * 0.1); 
              cur_angle = end_angle;
              continue;
            } else {
              //noStroke();
              stroke(255);
              colorMode(HSB, 360, 100, 100);
              fill(color(360 * i/ this.ls.length, 88, 60));
              colorMode(RGB, 255);
            }
          }
          
          //noStroke();
          stroke(255);
         arc(x_pos, y_pos, d, d, cur_angle, end_angle, PIE);
         cur_angle = end_angle;
       }
       fill(255);
       noStroke();
       ellipse(x_pos, y_pos, lerp(d - 2, 0, this.lerp8), lerp(d - 2, 0, this.lerp8));
   }
   
   void draw_bp_transition(){
     int len = this.ls.length;
     float cur_angle = 0;
     float r = width * 0.25;
     
     for (int i = 0; i < len; i++){
       float interval = width *.6 / len;
       float scale = 0.5 * width * PI /( (height * .7/this.maxY) * this.sumValues);
       float y_axis = scale * height * 0.85;
       
       float x_pos = scale * (width * 0.12 + i * interval);
       float y_pos = scale * (height * .85 - ((this.vs[i] / this.maxY) * height * .7)); 
       
       float end_angle = cur_angle + this.vs[i] * TWO_PI/this.sumValues;
       
       float circle_x = width * 0.4 + cos(cur_angle) * r;
       float circle_y = height * 0.5 + sin(cur_angle) * r;
       
       float tan_x = circle_x - scale * ((this.vs[i] / this.maxY) * height * .7) * sin(cur_angle);
       float tan_y = circle_y + scale * ((this.vs[i] / this.maxY) * height * .7) * cos(cur_angle);
       float end_x = width * 0.4 + cos(end_angle) * r;
       float end_y = height * 0.5 + sin(end_angle) * r;
       float rot_x = x_pos + circle_x - tan_x;
       float rot_y = y_axis + circle_y - tan_y;
       
       colorMode(HSB, 360, 100, 100);
       stroke(color(360 * i/ len, 88, 60));
       colorMode(RGB, 255);
       
       if (this.lerp7 < 1){
           line(x_pos, scale * height * 0.85, lerp(x_pos, rot_x, this.lerp7), lerp(y_pos, rot_y, this.lerp7));
       } else if (this.lerp5 < 1) { // moving into place
           line(lerp(rot_x, circle_x, this.lerp5), lerp(rot_y, circle_y, this.lerp5),
             lerp(x_pos, tan_x, this.lerp5), lerp(scale * height * 0.85, tan_y, this.lerp5));
       } else {
           fill(255);
           float angle_diff = end_angle - cur_angle;
           float dist = tan(angle_diff / 4) * r;
           float h = sqrt(pow(r, 2) + pow(dist, 2));
           float theta = atan(dist/r);
           float c1x = width * .4 + cos(cur_angle + theta) * h;
           float c1y = height * .5 + sin(cur_angle + theta) * h;
           float c2x = width * .4 + cos(end_angle - theta) * h;
           float c2y = height * .5 + sin(end_angle - theta) * h;
           float int_x = lerp(tan_x, end_x, this.lerp6);
           float int_y = lerp(tan_y, end_y, this.lerp6);
           
           bezier(circle_x, circle_y, c1x, c1y, c2x, c2y, int_x, int_y);
           //beginShape();
           //curveVertex(lerp(circle_x, width * 0.4, this.lerp6), lerp(circle_y, height * 0.5, this.lerp6));
           //curveVertex(lerp(x_pos, circle_x, this.lerp5), lerp(y_pos, circle_y, this.lerp5));
           //curveVertex(lerp(tan_x, end_x, this.lerp6), lerp(tan_y, end_y, this.lerp6));
           //curveVertex(lerp(tan_x, width * 0.4, this.lerp6), lerp(tan_y, height * 0.5, this.lerp6));
           //endShape();
           
           //curve(lerp(circle_x, width * 0.4, this.lerp6), lerp(circle_y, height * 0.5, this.lerp6), // control 1
           //      lerp(x_pos, circle_x, this.lerp5), lerp(y_pos, circle_y, this.lerp5), // point 1
           //      lerp(tan_x, end_x, this.lerp6), lerp(tan_y, end_y, this.lerp6), // point 2
           //      lerp(tan_x, width * 0.4, this.lerp6), lerp(tan_y, height * 0.5, this.lerp6)); // control 2
       }
      
       cur_angle = end_angle;
     }
   }
   
   void handleClick(){
       int i = sidebar.stateClick(state);
       
       // 0.line, 1.bar, 2.pie, 3.line-bar, 
              // 4.bar-line, 5.bar-pie, 6.pie-bar
       
       if(i != -1) {
           this.state = i;
           if (i == LtoB) {
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = 0;
           } else if (i == BtoL) {
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = 1;
           } else if (i == BtoP) {
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = this.lerp5 
                          = this.lerp6 = this.lerp7 = this.lerp8 = this.lerp9 = 0;
           } else if (i == PtoB) {
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = this.lerp5 
                          = this.lerp6 = this.lerp7 = this.lerp8 = this.lerp9 = 1;
           } else if (i == LtoP) {
               this.line_pie_state = 1;
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = 0;
               this.state = LtoB;
           } else if (i == PtoL) {
               this.line_pie_state = 1;
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = this.lerp5 
                          = this.lerp6 = this.lerp7 = this.lerp8 = this.lerp9 = 1;
               this.state = PtoB;
           }
           
       }
   }
    
   void draw_LtoB(){
       if (this.lerp1 < 1) {
           draw_line();
           this.lerp1 += .01;
       } else if (this.lerp2 < 1) {
           draw_line();
           this.lerp2 += .01;
       } else if (this.lerp3 < 1) {
           draw_bar();
           this.lerp3 += .01;
       } else if (this.lerp4 < 1) {
           draw_bar();
           this.lerp4 += .01;
       }
       else {
           if (this.line_pie_state == 0) {
               this.state = BAR_G;
           } else {
               this.line_pie_state = 0;
               this.state = BtoP;
               this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = this.lerp5 
                          = this.lerp6 = this.lerp7 = this.lerp8 = this.lerp9 = 0;
           }
       } 
   }
   
   void draw_BtoL(){
       if (this.lerp4 > 0) {
           draw_bar();
           this.lerp4 -= .01;
       } else if (this.lerp3 > 0) {
           draw_bar();
           this.lerp3 -= .01;
       } else if (this.lerp2 > 0) {
           draw_line();
           this.lerp2 -= .01;
       } else if (this.lerp1 > 0) {
           draw_line();
           this.lerp1 -= .01;
       }
       else {
           this.state = LINE_G;
       }
   }
   
   void draw_BtoP(){
       float scale = 0.5 * width * PI /( (height * .7/this.maxY) * this.sumValues);
       if (scale > 1 && this.lerp9 < 1) {
           scale(lerp(1, .5, this.lerp9));
           this.lerp9 += 0.05;
       } else if (scale > 1) {
         scale(0.5);
       }
       //println("scale: " + scale);
       if (this.lerp1 < 1) {            // change colors
         draw_bar();
         this.lerp1 += 0.01;
       } else if (this.lerp2 < 1) {     // shrink bars
         draw_bar();
         this.lerp2 += 0.01;
       } else if (this.lerp4 < 1) {      // scale axes
         //scale(1 - this.lerp4);
         if (scale <= 1) {
         scale(lerp(1, scale, this.lerp4));
         }
         draw_bar();
         this.lerp4 += 0.01;
       } else if (this.lerp3 < 1) {     // fade axes
         //scale(1 - this.lerp4);
         if (scale <= 1){
           scale(scale);
           } 
         draw_bar();
         this.lerp3 += 0.01;
       } else if (this.lerp7 < 1) {
         draw_bp_transition();
         this.lerp7 += 0.01;
       } else if (this.lerp5 < 1) {     // move lines into circle position
         draw_bp_transition();
         this.lerp5 += 0.01;
       } else if (this.lerp6 < 1) {
         draw_bp_transition();
         this.lerp6 += 0.01;
       } else if (this.lerp8 < 1) {
         if (scale > 1) {
             scale(lerp(.5, 1, this.lerp8));
         }
         draw_pie();
         this.lerp8 += 0.01;
       } else {
         this.state = PIE_G;
       }
   }
   
   void draw_PtoB(){
       float scale = 0.5 * width * PI /( (height * .7/this.maxY) * this.sumValues);
       if (scale > 1 && this.lerp9 >0) {
           scale(lerp(1, .5, this.lerp9));
           this.lerp9 -= 0.05;
       } else if (scale > 1) {
           scale(.5);
       }
       if (this.lerp8 > 0) {
           if (scale > 1) {
             scale(lerp(.5, 1, this.lerp8));
         }
           draw_pie();
           this.lerp8 -= 0.01;
       } else if (this.lerp6 > 0) {
           draw_bp_transition();
           this.lerp6 -= 0.01;
       } else if (this.lerp5 > 0) {
           draw_bp_transition();
           this.lerp5 -= 0.01;
       } else if (this.lerp7 > 0) {
           draw_bp_transition();
           this.lerp7 -= 0.01;
       } else if (this.lerp3 > 0) {
           if (scale <= 1){
           scale(scale);
           }
           draw_bar();
           this.lerp3 -= 0.01;
       } else if (this.lerp4 > 0) {
           if (scale <= 1) {
             scale(lerp(1, scale, this.lerp4));
           }
           draw_bar();
           this.lerp4 -= 0.01;
       } else if (this.lerp2 > 0) {
           draw_bar();
           this.lerp2 -= 0.01;
       } else if (this.lerp1 > 0) {
           draw_bar();
           this.lerp1 -= 0.01;
       } else {
         if (this.line_pie_state == 0) { 
             this.state = BAR_G;
         } else {
             this.line_pie_state = 0;
             this.lerp1 = this.lerp2 = this.lerp3 = this.lerp4 = 1;
             this.state = BtoL;
         }
       }
   }
   
   void draw_LtoP(){
       this.state = PIE_G;
   }
   
   void draw_PtoL(){
       this.state = LINE_G;
   }
   

}