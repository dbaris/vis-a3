Parser p;
Multigraph graph;

void setup() {
  size(800, 600);
  surface.setResizable(true);
  String filepath = "data.csv";
  p = new Parser(filepath);
  graph = new Multigraph(p.getLabels(), p.getValues());
  
}

void draw() {
  background(255);
  graph.render();
}