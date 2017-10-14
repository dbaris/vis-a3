class Multigraph {
   String [] ls;
   float [] vs;
   Sidebar sidebar;
   
   Multigraph(String[] labels, float[] values){
     this.ls = labels;
     this.vs = values;
     sidebar = new Sidebar();
   }
   
   void render() {
     sidebar.render();
   }


}