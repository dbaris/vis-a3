class Sidebar {
 
  String[] labels = {"Line", "Bar", "Pie"};
  
  Sidebar(){
    
  }
  
  public void render() {
      fill(177);
      noStroke();
      rect(width * 4 / 5, 0, width / 5, height);
      
      int i = 0;
      for(String s : labels) {
          float cx, cy, cr;
          cx = width * 9 / 10;
          cy = (height / 6) + (height * i/ 3);
          cr = height / 6;
          
          if (abs(mouseX - cx) < cr / 2 && abs(mouseY - cy) < cr / 2) {
              fill(#80d4ff);
          } else {
              fill(255);
          }
          
          ellipse(cx, cy, cr, cr);
          fill(0);
          textAlign(CENTER, CENTER);
          text(s, width * 9 /10, (height / 6) + (height * i/ 3));
          i++;
      }
  }
      
      int stateClick(int cur_state) {
        int state = -1;
        for(int i = 0; i < labels.length; i++) {
          float cx, cy, cr;
          cx = width * 9 / 10;
          cy = (height / 6) + (height * i/ 3);
          cr = height / 6;
          
          if (abs(mouseX - cx) < cr / 2 && abs(mouseY - cy) < cr / 2) {
            state = i;
          }
        }
        
        switch(cur_state){
            case(LINE_G): {
              if(state == BAR_G){
                return LtoB;
              } else if (state == PIE_G) {
                return LtoP;
              }
          } break;
            case(BAR_G): {
                if(state == LINE_G){
                return BtoL;
              } else if (state == PIE_G) {
                return BtoP;
              }
           } break;
             case(PIE_G): {
                if(state == LINE_G){
                return PtoL;
              } else if (state == BAR_G) {
                return PtoB;
              }
           } break;
        }
        return state;
      }
      
  }