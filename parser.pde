class Parser {
  String lines[];
  String [] header;
  String [] labels;
  float [] values;
  
  Parser(String filepath){
    this.lines = loadStrings(filepath);
    this.labels = new String[lines.length - 1];
    this.values = new float[lines.length - 1];
    
    for(int i = 1; i < lines.length; i++) {
      String[] line = split(lines[i], ",");
      this.labels[i - 1] = line[0];
      this.values[i - 1] = float(line[1]);
    }  
  }
  
  String[] getLabels(){
    return this.labels;
  }
  
  float[] getValues(){
    return this.values;
  }

}